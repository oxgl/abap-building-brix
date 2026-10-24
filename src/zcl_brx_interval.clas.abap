"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Time interval</p>
CLASS zcl_brx_interval DEFINITION
  PUBLIC
  FINAL
  CREATE PROTECTED.

  PUBLIC SECTION.
    INTERFACES zif_brx_interval.

    "! <p class="shorttext synchronized" lang="en">Creates a new time interval</p>
    "!
    "! @parameter io_start | <p class="shorttext synchronized" lang="en">Start moment of the interval</p>
    "! @parameter io_end | <p class="shorttext synchronized" lang="en">End moment of the interval</p>
    CLASS-METHODS create
      IMPORTING
        io_start           TYPE REF TO zif_brx_moment OPTIONAL
        io_end             TYPE REF TO zif_brx_moment OPTIONAL
        io_duration        TYPE REF TO zif_brx_duration OPTIONAL
      RETURNING
        VALUE(ro_interval) TYPE REF TO zif_brx_interval
      RAISING
        zcx_brx_invalid_value.

    "! @parameter io_moment | <p class="shorttext synchronized" lang="en">Create an interval of a given unit that covers the moment</p>
    "!
    "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Unit of the interval</p>
    "! @parameter ro_interval | <p class="shorttext synchronized" lang="en">Interval that covers the given moment</p>
    CLASS-METHODS create_covering
      IMPORTING
        io_moment          TYPE REF TO zif_brx_moment
        iv_unit            TYPE zif_brx_type=>tv_time_unit
        iv_timezone        TYPE zif_brx_type=>tv_time_zone DEFAULT sy-zonlo
      RETURNING
        VALUE(ro_interval) TYPE REF TO zif_brx_interval
      RAISING
        zcx_brx_invalid_value.

  PROTECTED SECTION.
    TYPES:
      "! <p class="shorttext synchronized" lang="en">Date parts structure</p>
      BEGIN OF ts_date_parts,
        year  TYPE n LENGTH 4,
        month TYPE n LENGTH 2,
        day   TYPE n LENGTH 2,
      END OF ts_date_parts.

    DATA:
      "! <p class="shorttext synchronized" lang="en">Start moment of the interval</p>
      go_start TYPE REF TO zif_brx_moment,

      "! <p class="shorttext synchronized" lang="en">End moment of the interval</p>
      go_end   TYPE REF TO zif_brx_moment.

    "! <p class="shorttext synchronized" lang="en">Constructor</p>
    "!
    "! @parameter io_start | <p class="shorttext synchronized" lang="en">Start moment of the interval</p>
    "! @parameter io_end | <p class="shorttext synchronized" lang="en">End moment of the interval</p>
    METHODS constructor
      IMPORTING
        io_start TYPE REF TO zif_brx_moment
        io_end   TYPE REF TO zif_brx_moment.


  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_brx_interval IMPLEMENTATION.


  METHOD constructor.
    go_start = io_start.
    go_end   = io_end.
  ENDMETHOD.

  METHOD create.
    IF io_start->compare( io_end ) LE 0.
      " Create a new interval with the given start and end moments
      RETURN NEW zcl_brx_interval(
        io_start = io_start
        io_end   = io_end
      ).
    ELSE.
      " Flip the start and end moments if they are in the wrong order,
      " so that the start moment is always less than or equal to the end moment
      RETURN NEW zcl_brx_interval(
        io_start = io_end
        io_end   = io_start
      ).
    ENDIF.
  ENDMETHOD.

  METHOD create_covering.
    IF io_moment->is_infinity( ) OR io_moment->is_initial( ).
      RAISE EXCEPTION TYPE zcx_brx_invalid_value
        EXPORTING
          textid    = zcx_brx_invalid_value=>invalid_parameter_value
          value     = CONV #( io_moment->as_timestampl( ) )
          paramname = 'IO_MOMENT'.
    ENDIF.

    DATA(lv_timestamp) = io_moment->as_timestampl( ).

    CONVERT TIME STAMP lv_timestamp TIME ZONE iv_timezone
             INTO DATE DATA(lv_date) TIME DATA(lv_time).

    CASE iv_unit.
      WHEN zif_brx_const=>gc_time_unit-second.
        DATA(lv_start) = CONV zif_brx_type=>tv_timestamp_long( floor( lv_timestamp ) ).
        DATA(lv_end)   = CONV zif_brx_type=>tv_timestamp_long( floor( lv_timestamp ) ).

      WHEN zif_brx_const=>gc_time_unit-minute.
        CONVERT DATE lv_date TIME CONV t( |{ lv_time(4) }00| )
           INTO TIME STAMP lv_start TIME ZONE iv_timezone.

        CONVERT DATE lv_date TIME CONV t( |{ lv_time(4) }59| )
           INTO TIME STAMP lv_end TIME ZONE iv_timezone.


      WHEN zif_brx_const=>gc_time_unit-hour.
        CONVERT DATE lv_date TIME CONV t( |{ lv_time(2) }0000| )
           INTO TIME STAMP lv_start TIME ZONE iv_timezone.
        CONVERT DATE lv_date TIME CONV t( |{ lv_time(2) }5959| )
           INTO TIME STAMP lv_end TIME ZONE iv_timezone.


      WHEN zif_brx_const=>gc_time_unit-day.
        CONVERT DATE lv_date TIME zif_brx_const=>gc_time-initial
           INTO TIME STAMP lv_start TIME ZONE iv_timezone.
        CONVERT DATE lv_date TIME zif_brx_const=>gc_time-maximum
           INTO TIME STAMP lv_end TIME ZONE iv_timezone.

      WHEN zif_brx_const=>gc_time_unit-week.
        " Calculate the last day of the current week (Sunday)
        lv_date = io_moment->as_date( iv_timezone ) - ( io_moment->as_weekday( iv_timezone ) - zif_brx_const=>gc_weekday-monday ).
        CONVERT DATE lv_date TIME zif_brx_const=>gc_time-initial
           INTO TIME STAMP lv_start TIME ZONE iv_timezone.
        lv_date += 6.
        CONVERT DATE lv_date TIME zif_brx_const=>gc_time-maximum
           INTO TIME STAMP lv_end TIME ZONE iv_timezone.

      WHEN zif_brx_const=>gc_time_unit-month.
        " Convert date to parts, increment month, and handle year overflow
        DATA(ls_date) = CONV ts_date_parts( lv_date ).

        " Calculate first day of the current month
        ls_date-day = 1.
        CONVERT DATE CONV d( ls_date ) TIME zif_brx_const=>gc_time-initial
           INTO TIME STAMP lv_start TIME ZONE iv_timezone.

        " Increment month and handle year overflow (this will be the first day of the next month)
        ls_date-month += 1.
        IF ls_date-month GT 12.
          ls_date-month = 1.
          ls_date-year += 1.
        ENDIF.

        lv_date = ls_date.
        lv_date -= 1. " Go to the last day of the current month

        CONVERT DATE lv_date TIME zif_brx_const=>gc_time-maximum
           INTO TIME STAMP lv_end TIME ZONE iv_timezone.

      WHEN zif_brx_const=>gc_time_unit-year.
        CONVERT DATE CONV d( |{ lv_date(4) }0101| ) TIME zif_brx_const=>gc_time-initial
           INTO TIME STAMP lv_start TIME ZONE iv_timezone.

        CONVERT DATE CONV d( |{ lv_date(4) }1231| ) TIME zif_brx_const=>gc_time-maximum
           INTO TIME STAMP lv_end TIME ZONE iv_timezone.

      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_brx_invalid_value
          EXPORTING
            textid    = zcx_brx_invalid_value=>invalid_parameter_value
            value     = CONV #( iv_unit )
            paramname = 'IV_UNIT'.
    ENDCASE.

    lv_end = floor( lv_end ) + zif_brx_const=>gc_timestamp-end_of_second.

    RETURN create(
      io_start = zcl_brx_moment=>create( lv_start )
      io_end   = zcl_brx_moment=>create( lv_end )
    ).

  ENDMETHOD.

  METHOD zif_brx_interval~duration.
    TRY.
        RETURN go_start->delta( go_end ).
      CATCH zcx_brx_invalid_value.
        " Should never happen, as both go_start and go_end are
        " valid moments, but just in case, we return a zero duration
    ENDTRY.
  ENDMETHOD.


  METHOD zif_brx_interval~end.
    RETURN go_end.
  ENDMETHOD.


  METHOD zif_brx_interval~start.
    RETURN go_start.
  ENDMETHOD.


  METHOD zif_brx_interval~compare.
    IF go_start->equals( io_interval->start( ) ) AND go_end->equals( io_interval->end( ) ).
      RETURN 0.
    ELSE.
      RETURN 1.
    ENDIF.
  ENDMETHOD.


  METHOD zif_brx_interval~equals.
    RETURN xsdbool( zif_brx_interval~compare( io_interval ) EQ 0 ).
  ENDMETHOD.

ENDCLASS.
