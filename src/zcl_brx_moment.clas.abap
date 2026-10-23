"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Moment implementation</p>
CLASS zcl_brx_moment DEFINITION
  PUBLIC
  CREATE PROTECTED .

  PUBLIC SECTION.

    INTERFACES zif_brx_moment .

    "! <p class="shorttext synchronized" lang="en">Class constructor</p>
    CLASS-METHODS class_constructor .
    "! <p class="shorttext synchronized" lang="en">Creates a new moment instance</p>
    "!
    "! @parameter iv_timestamp | <p class="shorttext synchronized" lang="en">Timestamp of moment</p>
    "! @parameter iv_date | <p class="shorttext synchronized" lang="en">Date of moment</p>
    "! @parameter iv_time | <p class="shorttext synchronized" lang="en">Time of moment</p>
    "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Reference to moment</p>
    CLASS-METHODS create
      IMPORTING
        iv_timestamp     TYPE numeric OPTIONAL
        iv_date          TYPE d OPTIONAL
        iv_time          TYPE t OPTIONAL
        iv_timezone      TYPE zif_brx_type=>tv_time_zone DEFAULT sy-zonlo
      RETURNING
        VALUE(ro_moment) TYPE REF TO zif_brx_moment
      RAISING
        zcx_brx_static_check.


    "! <p class="shorttext synchronized" lang="en">Parses a string representation of a moment</p>
    "!
    "! <p>The string representation should be in RFC 3339 format, which is a subset of ISO 8601. The expected formats are:
    "! <ul>
    "! <li>"YYYY-MM-DDTHH:MM:SS" (local time)</li>
    "! <li>"YYYY-MM-DDTHH:MM:SSZ" (UTC time)</li>
    "! <li>"YYYY-MM-DDTHH:MM:SS±HH:MM" (with time zone offset)</li>
    "! </ul>
    "! </p>
    "!
    "! @parameter iv_string | <p class="shorttext synchronized" lang="en">String representation of a moment</p>
    "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Reference to moment</p>
    "! @raising zcx_brx_conversion_failed | <p class="shorttext synchronized" lang="en">Conversion failed due to invalid format or value</p>
    "! @raising zcx_brx_out_of_range | <p class="shorttext synchronized" lang="en">Conversion failed due to value being out of range</p>
    CLASS-METHODS parse
      IMPORTING
        iv_string        TYPE clike
      RETURNING
        VALUE(ro_moment) TYPE REF TO zif_brx_moment
      RAISING
        zcx_brx_conversion_failed
        zcx_brx_out_of_range.

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
    "! @raising zcx_brx_static_check | <p class="shorttext synchronized" lang="en">Exception raised in case of invalid date</p>
    METHODS to_valid_date
      IMPORTING
        !iv_date       TYPE clike
      RETURNING
        VALUE(rv_date) TYPE d
      RAISING
        zcx_brx_static_check.

    "! <p class="shorttext synchronized" lang="en">Adds a value to a timestamp</p>
    "!
    "! @parameter iv_timestamp | <p class="shorttext synchronized" lang="en">Timestamp to which the value will be added</p>
    "! @parameter iv_value | <p class="shorttext synchronized" lang="en">Value to be added</p>
    "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Unit of the value to be added</p>
    "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone for the operation</p>
    "! @raising zcx_brx_static_check | <p class="shorttext synchronized" lang="en">Exception raised in case of error</p>
    METHODS tstmp_add
      IMPORTING
        !iv_timestamp       TYPE timestampl
        !iv_value           TYPE numeric
        !iv_unit            TYPE msehi OPTIONAL
        !iv_timezone        TYPE zif_brx_type=>tv_time_zone DEFAULT sy-zonlo
      RETURNING
        VALUE(rv_timestamp) TYPE timestampl
      RAISING
        zcx_brx_static_check.

    "! <p class="shorttext synchronized" lang="en">Subtracts a value from a timestamp</p>
    "!
    "! @parameter iv_timestamp | <p class="shorttext synchronized" lang="en">Timestamp from which the value will be subtracted</p>
    "! @parameter iv_value | <p class="shorttext synchronized" lang="en">Value to be subtracted</p>
    "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Unit of the value to be subtracted</p>
    "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone for the operation</p>
    "! @raising zcx_brx_static_check | <p class="shorttext synchronized" lang="en">Exception raised in case of error</p>
    METHODS tstmp_subtract
      IMPORTING
        !iv_timestamp       TYPE timestampl
        !iv_value           TYPE numeric
        !iv_unit            TYPE msehi OPTIONAL
        !iv_timezone        TYPE zif_brx_type=>tv_time_zone DEFAULT sy-zonlo
      RETURNING
        VALUE(rv_timestamp) TYPE timestampl
      RAISING
        zcx_brx_static_check.

    "! <p class="shorttext synchronized" lang="en">Determines the time zone to be used for operations</p>
    "!
    "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Input time zone</p>
    "! @parameter rv_timezone | <p class="shorttext synchronized" lang="en">Determined time zone</p>
    METHODS determine_timezone
      IMPORTING
        !iv_timezone       TYPE zif_brx_type=>tv_time_zone
      RETURNING
        VALUE(rv_timezone) TYPE zif_brx_type=>tv_time_zone.


  PRIVATE SECTION.

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


  METHOD create.
    IF iv_timestamp IS NOT INITIAL.
      ro_moment = NEW zcl_brx_moment( iv_timestamp ).
    ELSEIF iv_date IS NOT INITIAL.
      CONVERT DATE iv_date TIME iv_time
         INTO TIME STAMP DATA(lv_timestamp) TIME ZONE iv_timezone.
      ro_moment = NEW zcl_brx_moment( CONV #( lv_timestamp ) ).
    ELSE.
      " If no parameters are supplied, return the current moment
      ro_moment = now( ).
    ENDIF.
  ENDMETHOD.


  METHOD parse.
    DATA(lv_timestamp) = zcl_brx_conversion=>parse_timestamp( iv_string ).
    RETURN NEW zcl_brx_moment( lv_timestamp ).
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
        DATA(lv_timezone) = determine_timezone( iv_timezone ).
        CONVERT TIME STAMP gv_timestamp TIME ZONE lv_timezone
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
        DATA(lv_timezone) = determine_timezone( iv_timezone ).
        CONVERT TIME STAMP gv_timestamp TIME ZONE lv_timezone
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

    DATA(lv_timezone) = determine_timezone( iv_timezone ).

    rv_weekday = ( zif_brx_moment~as_date( lv_timezone ) + 5 ) MOD 7.
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

    DATA(lv_timezone) = determine_timezone( iv_timezone ).

    CONVERT TIME STAMP gv_timestamp TIME ZONE lv_timezone
       INTO DATE DATA(lv_date) TIME DATA(lv_time).

    CASE iv_unit.
      WHEN zif_brx_const=>gc_unit-second.
        RETURN NEW zcl_brx_moment( floor( gv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN zif_brx_const=>gc_unit-minute.
        CONVERT DATE lv_date TIME CONV t( |{ lv_time(4) }59| )
           INTO TIME STAMP DATA(lv_timestamp) TIME ZONE lv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN zif_brx_const=>gc_unit-hour.
        CONVERT DATE lv_date TIME CONV t( |{ lv_time(2) }5959| )
           INTO TIME STAMP lv_timestamp TIME ZONE lv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN zif_brx_const=>gc_unit-day.
        CONVERT DATE lv_date TIME gc_time-maximum
           INTO TIME STAMP lv_timestamp TIME ZONE lv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN zif_brx_const=>gc_unit-week.
        " Calculate the last day of the current week (Sunday)
        lv_date = zif_brx_moment~as_date( lv_timezone ) + ( zif_brx_const=>gc_weekday-sunday - zif_brx_moment~as_weekday( lv_timezone ) ).
        CONVERT DATE lv_date TIME gc_time-maximum
           INTO TIME STAMP lv_timestamp TIME ZONE lv_timezone.
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
           INTO TIME STAMP lv_timestamp TIME ZONE lv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN zif_brx_const=>gc_unit-year.
        CONVERT DATE CONV d( |{ lv_date(4) }1231| ) TIME gc_time-maximum
           INTO TIME STAMP lv_timestamp TIME ZONE lv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_brx_static_check.

    ENDCASE.
  ENDMETHOD.


  METHOD zif_brx_moment~start_of.
    IF me EQ initial( ).
      RETURN me.
    ENDIF.

    DATA(lv_timezone) = determine_timezone( iv_timezone ).

    CONVERT TIME STAMP gv_timestamp TIME ZONE lv_timezone
       INTO DATE DATA(lv_date) TIME DATA(lv_time).

    CASE iv_unit.
      WHEN zif_brx_const=>gc_unit-second.
        ro_moment = NEW zcl_brx_moment( floor( gv_timestamp ) ).
        RETURN.

      WHEN zif_brx_const=>gc_unit-minute.
        CONVERT DATE lv_date TIME CONV t( |{ lv_time(4) }00| )
           INTO TIME STAMP DATA(lv_timestamp) TIME ZONE lv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

      WHEN zif_brx_const=>gc_unit-hour.
        CONVERT DATE lv_date TIME CONV t( |{ lv_time(2) }0000| )
           INTO TIME STAMP lv_timestamp TIME ZONE lv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

      WHEN zif_brx_const=>gc_unit-day.
        CONVERT DATE lv_date TIME gc_time-initial
           INTO TIME STAMP lv_timestamp TIME ZONE lv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

      WHEN zif_brx_const=>gc_unit-week.
        lv_date = zif_brx_moment~as_date( lv_timezone ) - zif_brx_moment~as_weekday( lv_timezone ).
        CONVERT DATE lv_date TIME gc_time-initial
           INTO TIME STAMP lv_timestamp TIME ZONE lv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

      WHEN zif_brx_const=>gc_unit-month.
        CONVERT DATE CONV d( |{ lv_date(6) }01| ) TIME gc_time-initial
           INTO TIME STAMP lv_timestamp TIME ZONE lv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

      WHEN zif_brx_const=>gc_unit-year.
        CONVERT DATE CONV d( |{ lv_date(4) }0101| ) TIME gc_time-initial
             INTO TIME STAMP lv_timestamp TIME ZONE lv_timezone.
        RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_brx_static_check.

    ENDCASE.
  ENDMETHOD.


  METHOD zif_brx_moment~end_of_previous.
    IF me EQ initial( ).
      RETURN me.
    ENDIF.

    DATA(lv_timezone) = determine_timezone( iv_timezone ).

    DATA(lo_start_of_current) = zif_brx_moment~start_of( iv_unit = iv_unit iv_timezone = lv_timezone ).

    DATA(lv_timestamp) = tstmp_add(
      iv_timestamp = lo_start_of_current->as_timestamp( )
      iv_value     = -1
      iv_unit      = zif_brx_const=>gc_unit-second
      iv_timezone  = lv_timezone
    ).

    RETURN NEW zcl_brx_moment( floor( lv_timestamp ) + gc_timestamp-end_of_second ).

  ENDMETHOD.


  METHOD zif_brx_moment~start_of_next.
    IF me EQ infinity( ).
      RETURN me.
    ENDIF.

    DATA(lv_timezone) = determine_timezone( iv_timezone ).

    DATA(lo_end_of_current) = zif_brx_moment~end_of( iv_unit = iv_unit iv_timezone = lv_timezone ).

    DATA(lv_timestamp) = tstmp_add(
      iv_timestamp = lo_end_of_current->as_timestamp( )
      iv_value     = 1
      iv_unit      = zif_brx_const=>gc_unit-second
      iv_timezone  = lv_timezone
    ).

    RETURN NEW zcl_brx_moment( floor( lv_timestamp ) ).

  ENDMETHOD.


  METHOD zif_brx_moment~add.
    IF me EQ infinity( ) OR me EQ initial( ).
      ro_moment = me.
      RETURN.
    ENDIF.

    DATA(lv_timezone) = determine_timezone( iv_timezone ).

    " Calculate the new timestamp by adding components to the current timestamp
    " Start from the largest unit to the smallest unit to avoid overflow issues

    DATA(lv_timestamp) = gv_timestamp.

    " Add the specified number of years to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_years iv_unit = zif_brx_const=>gc_unit-year iv_timezone = lv_timezone ).

    " Add the specified number of months to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_months iv_unit = zif_brx_const=>gc_unit-month iv_timezone = lv_timezone ).

    " Add the specified number of days to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_days iv_unit = zif_brx_const=>gc_unit-day iv_timezone = lv_timezone ).

    " Add the specified number of hours to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_hours iv_unit = zif_brx_const=>gc_unit-hour iv_timezone = lv_timezone ).

    " Add the specified number of minutes to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_minutes iv_unit = zif_brx_const=>gc_unit-minute iv_timezone = lv_timezone ).

    " Add the specified number of seconds to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_seconds iv_unit = zif_brx_const=>gc_unit-second iv_timezone = lv_timezone ).

    " Add the specified value and unit to the current timestamp
    IF io_duration IS BOUND.
      " Handle the case where the duration is infinite,
      " as adding an infinite duration to a finite moment results in an infinite moment.
      IF io_duration->is_infinite( ).
        IF io_duration->sign( ) LT 0.
          RETURN initial( ).
        ELSE.
          RETURN infinity( ).
        ENDIF.
      ENDIF.
      lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = io_duration->as_seconds( ) iv_unit = zif_brx_const=>gc_unit-second iv_timezone = lv_timezone ).
    ENDIF.

    RETURN NEW zcl_brx_moment( lv_timestamp ).
  ENDMETHOD.

  METHOD zif_brx_moment~subtract.
    IF me EQ infinity( ) OR me EQ initial( ).
      ro_moment = me.
      RETURN.
    ENDIF.

    DATA(lv_timezone) = determine_timezone( iv_timezone ).

    " Calculate the new timestamp by subtracting components from the current timestamp
    " Start from the largest unit to the smallest unit to avoid overflow issues

    DATA(lv_timestamp) = gv_timestamp.

    " Subtract the specified number of years from the current timestamp
    lv_timestamp = tstmp_subtract( iv_timestamp = lv_timestamp iv_value = iv_years iv_unit = zif_brx_const=>gc_unit-year iv_timezone = lv_timezone ).

    " Subtract the specified number of months from the current timestamp
    lv_timestamp = tstmp_subtract( iv_timestamp = lv_timestamp iv_value = iv_months iv_unit = zif_brx_const=>gc_unit-month iv_timezone = lv_timezone ).

    " Subtract the specified number of days from the current timestamp
    lv_timestamp = tstmp_subtract( iv_timestamp = lv_timestamp iv_value = iv_days iv_unit = zif_brx_const=>gc_unit-day iv_timezone = lv_timezone ).

    " Subtract the specified number of hours from the current timestamp
    lv_timestamp = tstmp_subtract( iv_timestamp = lv_timestamp iv_value = iv_hours iv_unit = zif_brx_const=>gc_unit-hour iv_timezone = lv_timezone ).

    " Subtract the specified number of minutes from the current timestamp
    lv_timestamp = tstmp_subtract( iv_timestamp = lv_timestamp iv_value = iv_minutes iv_unit = zif_brx_const=>gc_unit-minute iv_timezone = lv_timezone ).

    " Subtract the specified number of seconds from the current timestamp
    lv_timestamp = tstmp_subtract( iv_timestamp = lv_timestamp iv_value = iv_seconds iv_unit = zif_brx_const=>gc_unit-second iv_timezone = lv_timezone ).

    " Subtract the specified value and unit from the current timestamp
    IF io_duration IS BOUND.
      " Handle the case where the duration is infinite,
      " as subtracting an infinite duration from a finite moment results in an initial moment (Big Bang :).
      IF io_duration->is_infinite( ).
        IF io_duration->sign( ) GT 0.
          RETURN initial( ).
        ELSE.
          RETURN infinity( ).
        ENDIF.
      ENDIF.

      lv_timestamp = tstmp_subtract( iv_timestamp = lv_timestamp iv_value = io_duration->as_seconds( ) iv_unit = zif_brx_const=>gc_unit-second iv_timezone = lv_timezone ).
    ENDIF.

    RETURN NEW zcl_brx_moment( lv_timestamp ).

  ENDMETHOD.

  METHOD to_valid_date.

    rv_date = iv_date.

    DO.
      IF rv_date EQ gc_date-initial OR rv_date = gc_date-infinity.
        EXIT.
      ENDIF.

      TRY.
          cl_abap_tstmp=>systemtstmp_syst2utc(
            EXPORTING
              syst_date = rv_date
              syst_time = '000000'
            IMPORTING
              utc_tstmp = DATA(lv_utc_tstmp)
          ).

          " if the conversion is successful, we can exit the loop
          IF lv_utc_tstmp IS NOT INITIAL.
            EXIT.
          ENDIF.


        CATCH cx_parameter_invalid_range.
      ENDTRY.

      DATA(ls_date) = CONV ts_date_parts( rv_date ).
      IF ls_date-day GT 1.
        ls_date-day -= 1.
        rv_date = ls_date.
      ELSE.
        RAISE EXCEPTION TYPE zcx_brx_static_check.
      ENDIF.
    ENDDO.

    RETURN rv_date.

  ENDMETHOD.

  METHOD tstmp_add.
    IF iv_value IS INITIAL.
      rv_timestamp = iv_timestamp.
      RETURN.
    ENDIF.

    DATA(lv_timezone) = determine_timezone( iv_timezone ).

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
            CONVERT TIME STAMP iv_timestamp TIME ZONE lv_timezone
               INTO DATE DATA(lv_date) TIME DATA(lv_time).

            " Add days...
            lv_date = lv_date + floor( iv_value ).

            " Convert date and original time back to timestamp
            CONVERT DATE lv_date TIME lv_time
               INTO TIME STAMP rv_timestamp TIME ZONE lv_timezone.

            " Add the fractional part of the original timestamp to the new timestamp
            RETURN floor( rv_timestamp ) + frac( iv_timestamp ).

          WHEN zif_brx_const=>gc_unit-month
            OR zif_brx_const=>gc_unit-year.
            " Convert timestamp to date and time zone
            CONVERT TIME STAMP iv_timestamp TIME ZONE lv_timezone
               INTO DATE lv_date TIME lv_time.

            " Convert date to parts
            DATA(ls_date) = CONV ts_date_parts( lv_date ).

            CASE iv_unit.
              WHEN zif_brx_const=>gc_unit-month.
                DATA(lv_months) = floor( iv_value ).

                DATA(lv_new_months) = CONV i( ls_date-month ) + lv_months.

                IF CONV i( ls_date-year ) + lv_new_months DIV 12 > 9999.
                  RAISE EXCEPTION TYPE cx_sy_arithmetic_overflow.
                ELSEIF CONV i( ls_date-year ) + lv_new_months DIV 12 < 0.
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
               INTO TIME STAMP rv_timestamp TIME ZONE lv_timezone.

            " Add the fractional part of the original timestamp to the new timestamp
            RETURN floor( rv_timestamp ) + frac( iv_timestamp ).

          WHEN OTHERS.
            RAISE EXCEPTION TYPE zcx_brx_static_check.
        ENDCASE.

      CATCH cx_parameter_invalid cx_sy_arithmetic_overflow INTO DATA(lo_calculation_error).

        RAISE EXCEPTION TYPE zcx_brx_static_check
          EXPORTING
            previous = lo_calculation_error.
    ENDTRY.

  ENDMETHOD.

  METHOD tstmp_subtract.
    RETURN tstmp_add(
      iv_timestamp = iv_timestamp
      iv_value     = - iv_value
      iv_unit      = iv_unit
      iv_timezone  = iv_timezone
    ).
  ENDMETHOD.


  METHOD determine_timezone.
    IF iv_timezone IS INITIAL.
      rv_timezone = sy-zonlo.
    ELSE.
      rv_timezone = iv_timezone.
    ENDIF.
  ENDMETHOD.

  METHOD zif_brx_moment~compare.
    IF io_moment IS NOT BOUND.
      RETURN 1.
    ELSE.
      " The return is an integer, but timestampl is a floating point number,
      " so a simple subtraction would return 0 if the difference is less than 1 second.
      " To avoid this, we use the SIGN function to return -1, 0, or 1 based on the comparison.
      RETURN sign( zif_brx_moment~as_timestampl( ) - io_moment->as_timestampl( ) ).
    ENDIF.
  ENDMETHOD.

  METHOD zif_brx_moment~equals.
    RETURN xsdbool( zif_brx_moment~compare( io_moment ) EQ 0 ).
  ENDMETHOD.

ENDCLASS.

