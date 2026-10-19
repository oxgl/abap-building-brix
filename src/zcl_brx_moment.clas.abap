"! <p class="shorttext synchronized" lang="en">ABAP Building Components: Moment implementation</p>
CLASS zcl_brx_moment DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.

    INTERFACES zif_abc_moment .

    "! <p class="shorttext synchronized" lang="en">Class constructor</p>
    CLASS-METHODS class_constructor .
    "! <p class="shorttext synchronized" lang="en">Returns a reference to current moment</p>
    "!
    "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Reference to moment</p>
    CLASS-METHODS now
      RETURNING
        VALUE(ro_moment) TYPE REF TO zif_abc_moment .
    "! <p class="shorttext synchronized" lang="en">Returns a reference to infinite moment</p>
    "!
    "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Reference to moment</p>  	
    CLASS-METHODS infinity
      RETURNING
        VALUE(ro_moment) TYPE REF TO zif_abc_moment .
    "! <p class="shorttext synchronized" lang="en">Returns a reference to zero moment</p>
    "!
    "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Reference to moment</p>
    CLASS-METHODS initial
      RETURNING
        VALUE(ro_moment) TYPE REF TO zif_abc_moment .
  PROTECTED SECTION.


  PRIVATE SECTION.
    TYPES:
      "! <p class="shorttext synchronized" lang="en">Date parts structure</p>
      BEGIN OF ts_date_parts,
        year  TYPE n LENGTH 4,
        month TYPE n LENGTH 2,
        day   TYPE n LENGTH 2,
      END OF ts_date_parts.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">Time parts structure</p>
      BEGIN OF ts_time_parts,
        hour   TYPE n LENGTH 2,
        minute TYPE n LENGTH 2,
        second TYPE n LENGTH 2,
      END OF ts_time_parts.

    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Timestamp constants</p>
      BEGIN OF gc_timestamp,
        infinity      TYPE timestampl VALUE '99991231235959.9999999',
        initial       TYPE timestampl VALUE '0',
        end_of_second TYPE timestampl VALUE '0.9999999',
      END OF gc_timestamp.

    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Date constants</p>
      BEGIN OF gc_date,
        infinity TYPE d VALUE '99991231',
        initial  TYPE d VALUE '00000000',
      END OF gc_date.

    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Time constants</p>
      BEGIN OF gc_time,
        maximum TYPE t VALUE '235959',
        initial TYPE t VALUE '000000',
      END OF gc_time.

    DATA:
      "! <p class="shorttext synchronized" lang="en">Timestamp of current moment</p>
      gv_timestamp TYPE timestampl.

    CLASS-DATA:
      "! <p class="shorttext synchronized" lang="en">Reference to singleton instance of infinite moment</p>
      go_infinity TYPE REF TO zif_abc_moment.

    CLASS-DATA:
      "! <p class="shorttext synchronized" lang="en">Reference to singleton instance of zero moment</p>
      go_initial     TYPE REF TO zif_abc_moment.


    METHODS:
	  "! <p class="shorttext synchronized" lang="en">Constructor</p>
	  "!
	  "! @parameter iv_timestamp | <p class="shorttext synchronized" lang="en">Timestamp of moment</p>
	  constructor
		IMPORTING
		  iv_timestamp TYPE timestampl OPTIONAL.


ENDCLASS.



CLASS zcl_brx_moment IMPLEMENTATION.


  METHOD class_constructor.

  ENDMETHOD.


  METHOD constructor.
    IF iv_timestamp IS SUPPLIED.
      gv_timestamp = iv_timestamp.
    ELSE.
      GET TIME STAMP FIELD gv_timestamp.
    ENDIF.
  ENDMETHOD.


  METHOD infinity.
    IF go_infinity IS NOT BOUND.
      go_infinity = NEW zcl_brx_moment( gc_timestamp-infinity ).
    ENDIF.
    ro_moment = go_infinity.
  ENDMETHOD.


  METHOD now.
    ro_moment = NEW zcl_brx_moment( ).
  ENDMETHOD.


  METHOD initial.
    IF go_initial IS NOT BOUND.
      go_initial = NEW zcl_brx_moment( gc_timestamp-initial ).
    ENDIF.
    ro_moment = go_initial.
  ENDMETHOD.


  METHOD zif_abc_moment~as_date.
    CASE me.
      WHEN infinity( ).
        rv_date = gc_date-infinity.
      WHEN initial( ).
        rv_date = gc_date-initial.
      WHEN OTHERS.
        CONVERT TIME STAMP gv_timestamp TIME ZONE iv_timezone
        INTO DATE rv_date.
    ENDCASE.
  ENDMETHOD.


  METHOD zif_abc_moment~as_time.
    CASE me.
      WHEN infinity( ).
        rv_time = gc_time-maximum.
      WHEN initial( ).
        rv_time = gc_time-initial.
      WHEN OTHERS.
        CONVERT TIME STAMP gv_timestamp TIME ZONE iv_timezone
           INTO TIME rv_time.
    ENDCASE.
  ENDMETHOD.


  METHOD zif_abc_moment~as_timestamp.
    rv_timestamp = floor( gv_timestamp ).
  ENDMETHOD.


  METHOD zif_abc_moment~as_timestampl.
    rv_timestampl = gv_timestamp.
  ENDMETHOD.


  METHOD zif_abc_moment~as_weekday.
    CASE me.
      WHEN infinity( ).
        rv_weekday = 7.
      WHEN initial( ).
        rv_weekday = 0.
      WHEN OTHERS.
        rv_weekday = ( zif_abc_moment~as_date( ) + 5 ) MOD 7.
    ENDCASE.
  ENDMETHOD.


  METHOD zif_abc_moment~end_of_current.
    " Whith these two cases we can avoid the conversion of
    " timestamp to date and time zone, which is expensive
    IF me EQ infinity( ) OR me EQ initial( ).
      ro_moment = me.
      RETURN.
    ENDIF.

    CONVERT TIME STAMP gv_timestamp TIME ZONE iv_timezone
       INTO DATE DATA(lv_date) TIME DATA(lv_time).

    CASE iv_unit.
      WHEN zif_abc_const=>gc_unit-second.
        ro_moment = NEW zcl_brx_moment( floor( gv_timestamp ) + gc_timestamp-end_of_second ).
        RETURN.

      WHEN zif_abc_const=>gc_unit-minute.
        CONVERT DATE lv_date TIME CONV t( |{ lv_time(4) }59| )
           INTO TIME STAMP DATA(lv_timestamp) TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN zif_abc_const=>gc_unit-hour.
        CONVERT DATE lv_date TIME CONV t( |{ lv_time(2) }5959| )
           INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN zif_abc_const=>gc_unit-day.
        CONVERT DATE lv_date TIME gc_time-maximum
           INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN zif_abc_const=>gc_unit-month.
        " Convert date to parts, increment month, and handle year overflow
        DATA(ls_date) = CONV ts_date_parts( lv_date ).
        " Increment month and handle year overflow
        ls_date-month += 1.
        IF ls_date-month GT 12.
          ls_date-month = 1.
          ls_date-year += 1.
        ENDIF.
        " This is the first day of the next month
        ls_date-day = 1.

        lv_date = ls_date.
        lv_date -= 1. " Go to the last day of the current month

        CONVERT DATE lv_date TIME gc_time-maximum
           INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN zif_abc_const=>gc_unit-year.
        CONVERT DATE CONV d( |{ lv_date(4) }1231| ) TIME gc_time-maximum
           INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN OTHERS.

    ENDCASE.
  ENDMETHOD.


  METHOD zif_abc_moment~start_of_current.
    IF me EQ infinity( ) OR me EQ initial( ).
      ro_moment = me.
      RETURN.
    ENDIF.

    CONVERT TIME STAMP gv_timestamp TIME ZONE iv_timezone
       INTO DATE DATA(lv_date) TIME DATA(lv_time).

    CASE iv_unit.
      WHEN zif_abc_const=>gc_unit-second.
        ro_moment = NEW zcl_brx_moment( floor( gv_timestamp ) ).
        RETURN.

      WHEN zif_abc_const=>gc_unit-minute.
        CONVERT DATE lv_date TIME CONV t( |{ lv_time(4) }00| )
           INTO TIME STAMP DATA(lv_timestamp) TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

      WHEN zif_abc_const=>gc_unit-hour.
        CONVERT DATE lv_date TIME CONV t( |{ lv_time(2) }0000| )
           INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

      WHEN zif_abc_const=>gc_unit-day.
        CONVERT DATE lv_date TIME gc_time-initial
           INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

      WHEN zif_abc_const=>gc_unit-month.
        CONVERT DATE CONV d( |{ lv_date(6) }01| ) TIME gc_time-initial
           INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

      WHEN zif_abc_const=>gc_unit-year.
        CONVERT DATE CONV d( |{ lv_date(4) }0101| ) TIME gc_time-initial
             INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
