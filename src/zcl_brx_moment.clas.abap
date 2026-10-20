"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Moment implementation</p>
CLASS zcl_brx_moment DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.

    INTERFACES zif_brx_moment .

    "! <p class="shorttext synchronized" lang="en">Class constructor</p>
    CLASS-METHODS class_constructor .
    "! <p class="shorttext synchronized" lang="en">Returns a reference to current moment</p>
    "!
    "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Reference to moment</p>
    CLASS-METHODS now
      RETURNING
        VALUE(ro_moment) TYPE REF TO zif_brx_moment .
    "! <p class="shorttext synchronized" lang="en">Returns a reference to infinite moment</p>
    "!
    "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Reference to moment</p>  	
    CLASS-METHODS infinity
      RETURNING
        VALUE(ro_moment) TYPE REF TO zif_brx_moment .
    "! <p class="shorttext synchronized" lang="en">Returns a reference to zero moment</p>
    "!
    "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Reference to moment</p>
    CLASS-METHODS initial
      RETURNING
        VALUE(ro_moment) TYPE REF TO zif_brx_moment .
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
      go_infinity TYPE REF TO zif_brx_moment.

    CLASS-DATA:
      "! <p class="shorttext synchronized" lang="en">Reference to singleton instance of zero moment</p>
      go_initial     TYPE REF TO zif_brx_moment.


    METHODS:
	  "! <p class="shorttext synchronized" lang="en">Constructor</p>
	  "!
	  "! @parameter iv_timestamp | <p class="shorttext synchronized" lang="en">Timestamp of moment</p>
	  constructor
		IMPORTING
		  iv_timestamp TYPE timestampl OPTIONAL.
    		
    "! <p class="shorttext synchronized" lang="en">Validates a date value and returns it as a date type</p>
    "!
    "! @parameter iv_date | <p class="shorttext synchronized" lang="en">Date string to be validated</p>
    "! @parameter rv_date | <p class="shorttext synchronized" lang="en">Validated date as type d</p>
    "! @raising zcx_brx_error | <p class="shorttext synchronized" lang="en">Exception raised in case of invalid date</p>
    METHODS to_valid_date
      IMPORTING
        !iv_date       TYPE clike
      RETURNING
        VALUE(rv_date) TYPE d
      RAISING
        zcx_brx_error.

    "! <p class="shorttext synchronized" lang="en">Adds a value to a timestamp</p>
    "!
    "! @parameter iv_timestamp | <p class="shorttext synchronized" lang="en">Timestamp to which the value will be added</p>
    "! @parameter iv_value | <p class="shorttext synchronized" lang="en">Value to be added</p>
    "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Unit of the value to be added</p>
    "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone for the operation</p>
    "! @raising zcx_brx_error | <p class="shorttext synchronized" lang="en">Exception raised in case of error</p>
    METHODS tstmp_add
      IMPORTING
        !iv_timestamp       TYPE timestampl
        !iv_value           TYPE numeric
        !iv_unit            TYPE msehi OPTIONAL
        !iv_timezone        TYPE timezone DEFAULT sy-zonlo
      RETURNING
        VALUE(rv_timestamp) TYPE timestampl
      RAISING
        zcx_brx_error.


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
    RETURN go_infinity.
  ENDMETHOD.


  METHOD now.
    RETURN NEW zcl_brx_moment( ).
  ENDMETHOD.


  METHOD initial.
    IF go_initial IS NOT BOUND.
      go_initial = NEW zcl_brx_moment( gc_timestamp-initial ).
    ENDIF.
    RETURN go_initial.
  ENDMETHOD.


  METHOD zif_brx_moment~as_date.
    CASE me.
      WHEN infinity( ).
        RETURN gc_date-infinity.
      WHEN initial( ).
        RETURN gc_date-initial.
      WHEN OTHERS.
        CONVERT TIME STAMP gv_timestamp TIME ZONE iv_timezone
           INTO DATE rv_date.
        RETURN rv_date.
    ENDCASE.
  ENDMETHOD.


  METHOD zif_brx_moment~as_time.
    CASE me.
      WHEN infinity( ).
        RETURN gc_time-maximum.
      WHEN initial( ).
        RETURN gc_time-initial.
      WHEN OTHERS.
        CONVERT TIME STAMP gv_timestamp TIME ZONE iv_timezone
           INTO TIME rv_time.
        RETURN rv_time.
    ENDCASE.
  ENDMETHOD.


  METHOD zif_brx_moment~as_timestamp.
    RETURN floor( gv_timestamp ).
  ENDMETHOD.


  METHOD zif_brx_moment~as_timestampl.
    RETURN gv_timestamp.
  ENDMETHOD.


  METHOD zif_brx_moment~as_weekday.
    " Simple formula to calculate the weekday from a date, where 0 is Monday and 6 is Sunday.
    " In ABAP the when date is converted to an integer, it represents the number of days
    " since 0001-01-01. Each day of the week corresponds to a specific remainder when divided by 7.
    " Thus, we can use the formula (date + 5) MOD 7 to get the weekday, where 0 is Monday and 6 is Sunday.
    " Same calculation is used by standard code, like CL_SCAL_UTILS...
    rv_weekday = ( zif_brx_moment~as_date( iv_timezone ) + 5 ) MOD 7.
  ENDMETHOD.


  METHOD zif_brx_moment~as_string.
    rv_string = |{ gv_timestamp TIMESTAMP = ISO }|.
  ENDMETHOD.


  METHOD zif_brx_moment~end_of.
    " Whith these two cases we can avoid the conversion of
    " timestamp to date and time zone, which is expensive
    IF me EQ infinity( ).
      RETURN me.
    ENDIF.

    CONVERT TIME STAMP gv_timestamp TIME ZONE iv_timezone
       INTO DATE DATA(lv_date) TIME DATA(lv_time).

    CASE iv_unit.
      WHEN zif_brx_const=>gc_unit-second.
        RETURN NEW zcl_brx_moment( floor( gv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN zif_brx_const=>gc_unit-minute.
        CONVERT DATE lv_date TIME CONV t( |{ lv_time(4) }59| )
           INTO TIME STAMP DATA(lv_timestamp) TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN zif_brx_const=>gc_unit-hour.
        CONVERT DATE lv_date TIME CONV t( |{ lv_time(2) }5959| )
           INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN zif_brx_const=>gc_unit-day.
        CONVERT DATE lv_date TIME gc_time-maximum
           INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN zif_brx_const=>gc_unit-week.
        " Calculate the last day of the current week (Sunday)
        lv_date = zif_brx_moment~as_date( iv_timezone ) + ( zif_brx_const=>gc_weekday-sunday - zif_brx_moment~as_weekday( iv_timezone ) ).
        CONVERT DATE lv_date TIME gc_time-maximum
           INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN zif_brx_const=>gc_unit-month.
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

      WHEN zif_brx_const=>gc_unit-year.
        CONVERT DATE CONV d( |{ lv_date(4) }1231| ) TIME gc_time-maximum
           INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_brx_error.

    ENDCASE.
  ENDMETHOD.


  METHOD zif_brx_moment~start_of.
    IF me EQ initial( ).
      RETURN me.
    ENDIF.

    CONVERT TIME STAMP gv_timestamp TIME ZONE iv_timezone
       INTO DATE DATA(lv_date) TIME DATA(lv_time).

    CASE iv_unit.
      WHEN zif_brx_const=>gc_unit-second.
        ro_moment = NEW zcl_brx_moment( floor( gv_timestamp ) ).
        RETURN.

      WHEN zif_brx_const=>gc_unit-minute.
        CONVERT DATE lv_date TIME CONV t( |{ lv_time(4) }00| )
           INTO TIME STAMP DATA(lv_timestamp) TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

      WHEN zif_brx_const=>gc_unit-hour.
        CONVERT DATE lv_date TIME CONV t( |{ lv_time(2) }0000| )
           INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

      WHEN zif_brx_const=>gc_unit-day.
        CONVERT DATE lv_date TIME gc_time-initial
           INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

      WHEN zif_brx_const=>gc_unit-week.
        lv_date = zif_brx_moment~as_date( iv_timezone ) - zif_brx_moment~as_weekday( iv_timezone ).
        CONVERT DATE lv_date TIME gc_time-initial
           INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

      WHEN zif_brx_const=>gc_unit-month.
        CONVERT DATE CONV d( |{ lv_date(6) }01| ) TIME gc_time-initial
           INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

      WHEN zif_brx_const=>gc_unit-year.
        CONVERT DATE CONV d( |{ lv_date(4) }0101| ) TIME gc_time-initial
             INTO TIME STAMP lv_timestamp TIME ZONE iv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_brx_error.

    ENDCASE.
  ENDMETHOD.


  METHOD zif_brx_moment~end_of_previous.
    IF me EQ initial( ).
      RETURN me.
    ENDIF.

    DATA(lo_start_of_current) = zif_brx_moment~start_of( iv_unit = iv_unit iv_timezone = iv_timezone ).

    DATA(lv_timestamp) = tstmp_add(
      iv_timestamp = lo_start_of_current->as_timestamp( )
      iv_value     = -1
      iv_unit      = zif_brx_const=>gc_unit-second
      iv_timezone  = iv_timezone
    ).

    RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

  ENDMETHOD.


  METHOD zif_brx_moment~start_of_next.
    IF me EQ infinity( ).
      RETURN me.
    ENDIF.

    DATA(lo_end_of_current) = zif_brx_moment~end_of( iv_unit = iv_unit iv_timezone = iv_timezone ).

    DATA(lv_timestamp) = tstmp_add(
      iv_timestamp = lo_end_of_current->as_timestamp( )
      iv_value     = 1
      iv_unit      = zif_brx_const=>gc_unit-second
      iv_timezone  = iv_timezone
    ).

    RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

  ENDMETHOD.



  METHOD to_valid_date.

    rv_date = iv_date.

    DO.
      IF rv_date EQ gc_date-initial OR rv_date = gc_date-infinity.
        EXIT.
      ENDIF.

      CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
        EXPORTING
          date                      = rv_date
        EXCEPTIONS
          plausibility_check_failed = 1
          OTHERS                    = 2.
      IF sy-subrc IS INITIAL.
        EXIT.
      ENDIF.

      DATA(ls_date) = CONV ts_date_parts( rv_date ).
      IF ls_date-day GT 1.
        ls_date-day -= 1.
        rv_date = ls_date.
      ELSE.
        RAISE EXCEPTION TYPE zcx_brx_error.
      ENDIF.
    ENDDO.

    RETURN rv_date.

  ENDMETHOD.

  METHOD tstmp_add.
    IF iv_value IS INITIAL.
      rv_timestamp = iv_timestamp.
      RETURN.
    ENDIF.

    TRY.
        CASE iv_unit.
          WHEN zif_brx_const=>gc_unit-second.
            RETURN cl_abap_tstmp=>add(
              tstmp = iv_timestamp
              secs  = iv_value
            ).

          WHEN zif_brx_const=>gc_unit-minute.
            RETURN cl_abap_tstmp=>add(
              tstmp = iv_timestamp
              secs  = iv_value * 60
            ).

          WHEN zif_brx_const=>gc_unit-hour.
            RETURN cl_abap_tstmp=>add(
              tstmp = iv_timestamp
              secs  = iv_value * 3600
            ).

          WHEN zif_brx_const=>gc_unit-day.

            " Convert timestamp to date and time zone
            CONVERT TIME STAMP iv_timestamp TIME ZONE iv_timezone
               INTO DATE DATA(lv_date) TIME DATA(lv_time).

            " Add days...
            lv_date = lv_date + floor( iv_value ).

            " Convert date and original time back to timestamp
            CONVERT DATE lv_date TIME lv_time
               INTO TIME STAMP rv_timestamp TIME ZONE iv_timezone.

            " Add the fractional part of the original timestamp to the new timestamp
            RETURN floor( rv_timestamp ) + frac( iv_timestamp ).

          WHEN zif_brx_const=>gc_unit-month
            OR zif_brx_const=>gc_unit-year.
            " Convert timestamp to date and time zone
            CONVERT TIME STAMP iv_timestamp TIME ZONE iv_timezone
               INTO DATE lv_date TIME lv_time.

            " Convert date to parts
            DATA(ls_date) = CONV ts_date_parts( lv_date ).

            CASE iv_unit.
              WHEN zif_brx_const=>gc_unit-month.
                DATA(lv_months) = floor( iv_value ).

                DATA(lv_new_months) = CONV i( ls_date-month ) + lv_months.

                IF CONV i( ls_date-year ) + lv_new_months DIV 12 > 9999.
                  RAISE EXCEPTION TYPE cx_sy_arithmetic_overflow.
                ENDIF.
                ls_date-year += lv_new_months DIV 12.
                ls_date-month = lv_new_months MOD 12.
              WHEN zif_brx_const=>gc_unit-year.
                ls_date-year += floor( iv_value ).
            ENDCASE.

            " Convert parts back to date
            lv_date = to_valid_date( ls_date ).

            " Convert date and original time back to timestamp
            CONVERT DATE lv_date TIME lv_time
               INTO TIME STAMP rv_timestamp TIME ZONE iv_timezone.

            " Add the fractional part of the original timestamp to the new timestamp
            RETURN floor( rv_timestamp ) + frac( iv_timestamp ).

          WHEN OTHERS.
            RAISE EXCEPTION TYPE zcx_brx_error.
        ENDCASE.

      CATCH cx_parameter_invalid cx_sy_arithmetic_overflow INTO DATA(lo_calculation_error).

        RAISE EXCEPTION TYPE zcx_brx_error
          EXPORTING
            previous = lo_calculation_error.
    ENDTRY.

  ENDMETHOD.


  METHOD zif_brx_moment~add.
    IF me EQ infinity( ) OR me EQ initial( ).
      ro_moment = me.
      RETURN.
    ENDIF.

    " Calculate the new timestamp by adding components to the current timestamp
    " Start from the largest unit to the smallest unit to avoid overflow issues

    DATA(lv_timestamp) = gv_timestamp.

    " Add the specified number of years to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_years iv_unit = zif_brx_const=>gc_unit-year iv_timezone = iv_timezone ).

    " Add the specified number of months to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_months iv_unit = zif_brx_const=>gc_unit-month iv_timezone = iv_timezone ).

    " Add the specified number of days to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_days iv_unit = zif_brx_const=>gc_unit-day iv_timezone = iv_timezone ).

    " Add the specified number of hours to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_hours iv_unit = zif_brx_const=>gc_unit-hour iv_timezone = iv_timezone ).

    " Add the specified number of minutes to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_minutes iv_unit = zif_brx_const=>gc_unit-minute iv_timezone = iv_timezone ).

    " Add the specified number of seconds to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_seconds iv_unit = zif_brx_const=>gc_unit-second iv_timezone = iv_timezone ).

    " Add the specified value and unit to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_value iv_unit = iv_unit iv_timezone = iv_timezone ).

    RETURN NEW zcl_brx_moment( lv_timestamp ).
  ENDMETHOD.






ENDCLASS.
