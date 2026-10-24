"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Moment implementation</p>
CLASS zcl_brx_moment DEFINITION
  PUBLIC
  CREATE PROTECTED .

  PUBLIC SECTION.

    INTERFACES zif_brx_moment .


    "! <p class="shorttext synchronized" lang="en">Creates a new moment instance</p>
    "!
    "! @parameter iv_timestamp | <p class="shorttext synchronized" lang="en">Timestamp of moment</p>
    "! @parameter iv_date | <p class="shorttext synchronized" lang="en">Date of moment</p>
    "! @parameter iv_time | <p class="shorttext synchronized" lang="en">Time of moment</p>
    "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone for date and time conversion</p>
    "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Reference to moment</p>
    CLASS-METHODS create
      IMPORTING
        iv_timestamp     TYPE numeric OPTIONAL
        iv_date          TYPE d OPTIONAL
        iv_time          TYPE t OPTIONAL
        iv_timezone      TYPE zif_brx_type=>tv_time_zone DEFAULT sy-zonlo
          PREFERRED PARAMETER iv_timestamp
      RETURNING
        VALUE(ro_moment) TYPE REF TO zif_brx_moment
      RAISING
        zcx_brx_invalid_value.


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
    "! @raising zcx_brx_invalid_value | <p class="shorttext synchronized" lang="en">Invalid value encountered during parsing</p>
    CLASS-METHODS parse
      IMPORTING
        iv_string        TYPE clike
      RETURNING
        VALUE(ro_moment) TYPE REF TO zif_brx_moment
      RAISING
        zcx_brx_conversion_failed
        zcx_brx_invalid_value.


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


    DATA:
      "! <p class="shorttext synchronized" lang="en">Timestamp of current moment</p>
      gv_timestamp TYPE timestampl.


    CLASS-DATA:
      "! <p class="shorttext synchronized" lang="en">Reference to singleton instance of infinite moment</p>
      go_infinity TYPE REF TO zif_brx_moment,

      "! <p class="shorttext synchronized" lang="en">Reference to singleton instance of zero moment</p>
      go_initial  TYPE REF TO zif_brx_moment.

    "! <p class="shorttext synchronized" lang="en">Constructor</p>
    "!
    "! @parameter iv_timestamp | <p class="shorttext synchronized" lang="en">Timestamp of moment</p>
    METHODS constructor
      IMPORTING
        iv_timestamp TYPE timestampl OPTIONAL.

    			

    "! <p class="shorttext synchronized" lang="en">Validates a date value and returns it as a date type</p>
    "!
    "! @parameter iv_date | <p class="shorttext synchronized" lang="en">Date string to be validated</p>
    "! @parameter rv_date | <p class="shorttext synchronized" lang="en">Validated date as type d</p>
    "! @raising zcx_brx_invalid_value | <p class="shorttext synchronized" lang="en">Exception raised in case of invalid date</p>
    METHODS to_valid_date
      IMPORTING
        !iv_date       TYPE clike
      RETURNING
        VALUE(rv_date) TYPE d
      RAISING
        zcx_brx_invalid_value.


    "! <p class="shorttext synchronized" lang="en">Converts a date and time to a valid timestamp</p>
    "!
    "! @parameter iv_date | <p class="shorttext synchronized" lang="en">Date to be converted</p>
    "! @parameter iv_time | <p class="shorttext synchronized" lang="en">Time to be converted</p>
    "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone for the conversion</p>
    "! @parameter rv_timestamp | <p class="shorttext synchronized" lang="en">Resulting timestamp</p>
    METHODS to_valid_timestamp
      IMPORTING
        iv_date             TYPE d
        iv_time             TYPE t OPTIONAL
        iv_timezone         TYPE zif_brx_type=>tv_time_zone
      RETURNING
        VALUE(rv_timestamp) TYPE timestampl
      RAISING
        zcx_brx_invalid_value.



    "! <p class="shorttext synchronized" lang="en">Adds a value to a timestamp</p>
    "!
    "! @parameter iv_timestamp | <p class="shorttext synchronized" lang="en">Timestamp to which the value will be added</p>
    "! @parameter iv_value | <p class="shorttext synchronized" lang="en">Value to be added</p>
    "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Unit of the value to be added</p>
    "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone for the operation</p>
    "! @raising zcx_brx_invalid_value | <p class="shorttext synchronized" lang="en">Exception raised in case of error</p>
    METHODS tstmp_add
      IMPORTING
        !iv_timestamp       TYPE timestampl
        !iv_value           TYPE numeric
        !iv_unit            TYPE msehi OPTIONAL
        !iv_timezone        TYPE zif_brx_type=>tv_time_zone DEFAULT sy-zonlo
      RETURNING
        VALUE(rv_timestamp) TYPE timestampl
      RAISING
        zcx_brx_invalid_value.



    "! <p class="shorttext synchronized" lang="en">Subtracts a value from a timestamp</p>
    "!
    "! @parameter iv_timestamp | <p class="shorttext synchronized" lang="en">Timestamp from which the value will be subtracted</p>
    "! @parameter iv_value | <p class="shorttext synchronized" lang="en">Value to be subtracted</p>
    "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Unit of the value to be subtracted</p>
    "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone for the operation</p>
    "! @raising zcx_brx_invalid_value | <p class="shorttext synchronized" lang="en">Exception raised in case of error</p>
    METHODS tstmp_subtract
      IMPORTING
        !iv_timestamp       TYPE timestampl
        !iv_value           TYPE numeric
        !iv_unit            TYPE msehi OPTIONAL
        !iv_timezone        TYPE zif_brx_type=>tv_time_zone DEFAULT sy-zonlo
      RETURNING
        VALUE(rv_timestamp) TYPE timestampl
      RAISING
        zcx_brx_invalid_value.



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


  METHOD constructor.
    IF iv_timestamp IS SUPPLIED.
      gv_timestamp = iv_timestamp.
    ELSE.
      GET TIME STAMP FIELD gv_timestamp.
    ENDIF.
  ENDMETHOD.


  METHOD infinity.
    IF go_infinity IS NOT BOUND.
      go_infinity = NEW zcl_brx_moment( zif_brx_const=>gc_timestamp-infinity ).
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
      go_initial = NEW zcl_brx_moment( zif_brx_const=>gc_timestamp-initial ).
    ENDIF.
    RETURN go_initial.
  ENDMETHOD.


  METHOD zif_brx_moment~as_date.
    CASE me.
      WHEN infinity( ).
        RETURN zif_brx_const=>gc_date-infinity.
      WHEN initial( ).
        RETURN zif_brx_const=>gc_date-initial.
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
        RETURN zif_brx_const=>gc_time-maximum.
      WHEN initial( ).
        RETURN zif_brx_const=>gc_time-initial.
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


  METHOD zif_brx_moment~current.

    DATA(lv_timezone) = determine_timezone( iv_timezone ).

    RETURN zcl_brx_interval=>create_covering(
      io_moment   = me
      iv_timezone = lv_timezone
      iv_unit     = iv_unit
    ).
  ENDMETHOD.


  METHOD zif_brx_moment~next.
    DATA(lv_timezone) = determine_timezone( iv_timezone ).

    RETURN zcl_brx_interval=>create_covering(
      io_moment   = zif_brx_moment~current(
        iv_timezone = lv_timezone
        iv_unit     = iv_unit
      )->end( )->add( iv_seconds = 1 )
      iv_timezone = lv_timezone
      iv_unit     = iv_unit
    ).
  ENDMETHOD.


  METHOD zif_brx_moment~previous.
    DATA(lv_timezone) = determine_timezone( iv_timezone ).

    RETURN zcl_brx_interval=>create_covering(
        io_moment   = zif_brx_moment~current(
          iv_timezone = lv_timezone
          iv_unit     = iv_unit
        )->start( )->subtract( iv_seconds = 1 )
        iv_timezone = lv_timezone
        iv_unit     = iv_unit
      ).
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
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_years iv_unit = zif_brx_const=>gc_time_unit-year iv_timezone = lv_timezone ).

    " Add the specified number of months to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_months iv_unit = zif_brx_const=>gc_time_unit-month iv_timezone = lv_timezone ).

    " Add the specified number of days to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_days iv_unit = zif_brx_const=>gc_time_unit-day iv_timezone = lv_timezone ).

    " Add the specified number of hours to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_hours iv_unit = zif_brx_const=>gc_time_unit-hour iv_timezone = lv_timezone ).

    " Add the specified number of minutes to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_minutes iv_unit = zif_brx_const=>gc_time_unit-minute iv_timezone = lv_timezone ).

    " Add the specified number of seconds to the current timestamp
    lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = iv_seconds iv_unit = zif_brx_const=>gc_time_unit-second iv_timezone = lv_timezone ).

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
      lv_timestamp = tstmp_add( iv_timestamp = lv_timestamp iv_value = io_duration->as_seconds( ) iv_unit = zif_brx_const=>gc_time_unit-second iv_timezone = lv_timezone ).
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
    lv_timestamp = tstmp_subtract( iv_timestamp = lv_timestamp iv_value = iv_years iv_unit = zif_brx_const=>gc_time_unit-year iv_timezone = lv_timezone ).

    " Subtract the specified number of months from the current timestamp
    lv_timestamp = tstmp_subtract( iv_timestamp = lv_timestamp iv_value = iv_months iv_unit = zif_brx_const=>gc_time_unit-month iv_timezone = lv_timezone ).

    " Subtract the specified number of days from the current timestamp
    lv_timestamp = tstmp_subtract( iv_timestamp = lv_timestamp iv_value = iv_days iv_unit = zif_brx_const=>gc_time_unit-day iv_timezone = lv_timezone ).

    " Subtract the specified number of hours from the current timestamp
    lv_timestamp = tstmp_subtract( iv_timestamp = lv_timestamp iv_value = iv_hours iv_unit = zif_brx_const=>gc_time_unit-hour iv_timezone = lv_timezone ).

    " Subtract the specified number of minutes from the current timestamp
    lv_timestamp = tstmp_subtract( iv_timestamp = lv_timestamp iv_value = iv_minutes iv_unit = zif_brx_const=>gc_time_unit-minute iv_timezone = lv_timezone ).

    " Subtract the specified number of seconds from the current timestamp
    lv_timestamp = tstmp_subtract( iv_timestamp = lv_timestamp iv_value = iv_seconds iv_unit = zif_brx_const=>gc_time_unit-second iv_timezone = lv_timezone ).

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

      lv_timestamp = tstmp_subtract( iv_timestamp = lv_timestamp iv_value = io_duration->as_seconds( ) iv_unit = zif_brx_const=>gc_time_unit-second iv_timezone = lv_timezone ).
    ENDIF.

    RETURN NEW zcl_brx_moment( lv_timestamp ).

  ENDMETHOD.


  METHOD zif_brx_moment~delta.
    " If either moment is infinite, the difference is considered infinite.
    IF zif_brx_moment~is_infinity( ) NE io_moment->is_infinity( ).
      RETURN zcl_brx_duration=>infinity( ).
    ENDIF.

    " If either moment is initial, the difference is considered infinite.
    IF zif_brx_moment~is_initial( ) NE io_moment->is_initial( ).
      RETURN zcl_brx_duration=>infinity( ).
    ENDIF.

    " If both moments are same, the difference is zero.
    IF zif_brx_moment~equals( io_moment ) .
      RETURN zcl_brx_duration=>initial( ).
    ENDIF.

    " Calculate the difference in seconds between the two moments
    DATA(lv_timestamp_this) = zif_brx_moment~as_timestampl( ).
    DATA(lv_timestamp_that) = io_moment->as_timestampl( ).

    " Calculate the difference in seconds between the two timestamps
    TRY.
        DATA(lv_seconds) = cl_abap_tstmp=>subtract(
          tstmp1 = lv_timestamp_this
          tstmp2 = lv_timestamp_that
        ).
      CATCH cx_parameter_invalid INTO DATA(lo_error).
        RAISE EXCEPTION TYPE zcx_brx_invalid_value
          EXPORTING
            textid   = zcx_brx_invalid_value=>value_out_of_range
            value    = |{ lv_timestamp_this } - { lv_timestamp_that }|
            previous = lo_error.
    ENDTRY.

    RETURN zcl_brx_duration=>create(
             iv_value = lv_seconds
             iv_unit  = zif_brx_const=>gc_time_unit-second
           ).
  ENDMETHOD.


  METHOD zif_brx_moment~distance.
    RETURN zif_brx_moment~delta( io_moment )->absolute( ).
  ENDMETHOD.


  METHOD zif_brx_moment~is_initial.
    RETURN xsdbool( gv_timestamp EQ zif_brx_const=>gc_timestamp-initial ).
  ENDMETHOD.


  METHOD zif_brx_moment~is_infinity.
    RETURN xsdbool( gv_timestamp GE zif_brx_const=>gc_timestamp-infinity ).
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


  METHOD to_valid_date.

    rv_date = iv_date.

    DO.
      IF rv_date EQ zif_brx_const=>gc_date-initial OR rv_date = zif_brx_const=>gc_date-infinity.
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
        RAISE EXCEPTION TYPE zcx_brx_invalid_value
          EXPORTING
            textid = zcx_brx_invalid_value=>value_out_of_range
            value  = CONV #( rv_date ).
      ENDIF.
    ENDDO.

    RETURN rv_date.

  ENDMETHOD.


  METHOD to_valid_timestamp.
    IF iv_date EQ zif_brx_const=>gc_date-initial AND iv_time EQ zif_brx_const=>gc_time-initial.
      RETURN zif_brx_const=>gc_timestamp-initial.
    ENDIF.

    " First try...
    CONVERT DATE iv_date TIME iv_time
       INTO TIME STAMP rv_timestamp TIME ZONE iv_timezone.

    IF sy-subrc IS INITIAL.
      RETURN rv_timestamp.
    ENDIF.

    " If the first conversion fails, we will try to adjust the time,
    " maybe it's a missing hour because of daylight saving...
    DATA(ls_time) = CONV ts_time_parts( iv_time ).
    IF ls_time-hour LT 23.
      ls_time-hour += 1.
      DATA(lv_time) = ls_time.

      " Second try with adjusted time...
      CONVERT DATE iv_date TIME lv_time
         INTO TIME STAMP rv_timestamp TIME ZONE iv_timezone.
      IF sy-subrc IS INITIAL.
        RETURN rv_timestamp.
      ENDIF.
    ENDIF.

    " Still not valid, raise an exception with the original date and time values
    RAISE EXCEPTION TYPE zcx_brx_invalid_value
      EXPORTING
        textid = zcx_brx_invalid_value=>value_out_of_range
        value  = |{ iv_date } { iv_time } )|.
  ENDMETHOD.


  METHOD tstmp_add.
    IF iv_value IS INITIAL.
      rv_timestamp = iv_timestamp.
      RETURN.
    ENDIF.

    DATA(lv_timezone) = determine_timezone( iv_timezone ).

    TRY.
        CASE iv_unit.
          WHEN zif_brx_const=>gc_time_unit-second.
            RETURN cl_abap_tstmp=>add(
              tstmp = iv_timestamp
              secs  = iv_value
            ).

          WHEN zif_brx_const=>gc_time_unit-minute.
            RETURN cl_abap_tstmp=>add(
              tstmp = iv_timestamp
              secs  = iv_value * 60
            ).

          WHEN zif_brx_const=>gc_time_unit-hour.
            RETURN cl_abap_tstmp=>add(
              tstmp = iv_timestamp
              secs  = iv_value * 3600
            ).

          WHEN zif_brx_const=>gc_time_unit-day.

            " Convert timestamp to date and time zone
            CONVERT TIME STAMP iv_timestamp TIME ZONE lv_timezone
               INTO DATE DATA(lv_date) TIME DATA(lv_time).

            " Add days...
            lv_date = lv_date + floor( iv_value ).

            " Convert date and original time back to timestamp
            rv_timestamp = to_valid_timestamp(
              iv_date     = lv_date
              iv_time     = lv_time
              iv_timezone = lv_timezone
            ).

            " Add the fractional part of the original timestamp to the new timestamp
            RETURN floor( rv_timestamp ) + frac( iv_timestamp ).

          WHEN zif_brx_const=>gc_time_unit-month
            OR zif_brx_const=>gc_time_unit-year.
            " Convert timestamp to date and time zone
            CONVERT TIME STAMP iv_timestamp TIME ZONE lv_timezone
               INTO DATE lv_date TIME lv_time.

            " Convert date to parts
            DATA(ls_date) = CONV ts_date_parts( lv_date ).

            CASE iv_unit.
              WHEN zif_brx_const=>gc_time_unit-month.
                DATA(lv_months) = floor( iv_value ).

                DATA(lv_new_months) = CONV i( ls_date-month ) + lv_months.

                IF CONV i( ls_date-year ) + lv_new_months DIV 12 > 9999.
                  RAISE EXCEPTION TYPE cx_sy_arithmetic_overflow.
                ELSEIF CONV i( ls_date-year ) + lv_new_months DIV 12 < 0.
                  RAISE EXCEPTION TYPE cx_sy_arithmetic_overflow.
                ENDIF.
                ls_date-year += lv_new_months DIV 12.
                ls_date-month = lv_new_months MOD 12.
              WHEN zif_brx_const=>gc_time_unit-year.
                ls_date-year += floor( iv_value ).
            ENDCASE.

            " Convert parts back to date
            lv_date = to_valid_date( ls_date ).

            " Convert date and original time back to timestamp
            rv_timestamp = to_valid_timestamp(
              iv_date     = lv_date
              iv_time     = lv_time
              iv_timezone = lv_timezone
            ).

            " Add the fractional part of the original timestamp to the new timestamp
            RETURN floor( rv_timestamp ) + frac( iv_timestamp ).

          WHEN OTHERS.
            RAISE EXCEPTION TYPE zcx_brx_invalid_value
              EXPORTING
                textid    = zcx_brx_invalid_value=>invalid_parameter_value
                value     = CONV #( iv_unit )
                paramname = 'IV_UNIT'.
        ENDCASE.

      CATCH cx_parameter_invalid cx_sy_arithmetic_overflow INTO DATA(lo_calculation_error).

        RAISE EXCEPTION TYPE zcx_brx_invalid_value
          EXPORTING
            textid   = zcx_brx_invalid_value=>value_out_of_range
            value    = CONV #( iv_value )
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

ENDCLASS.

