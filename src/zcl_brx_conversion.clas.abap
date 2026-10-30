"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Conversion methods</p>
CLASS zcl_brx_conversion DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    "! <p class="shorttext synchronized" lang="en">Converts a date string to an internal date representation</p>
    "!
    "! <p>Accepted input formats (depending on iv_format):</p>
    "! <ul>
    "!   <li>auto: tries all formats below in parser order</li>
    "!   <li>eur: dd.mm.yyyy (example: 25.12.2021)</li>
    "!   <li>usa: mm/dd/yyyy or mm-dd-yyyy (example: 12/25/2021)</li>
    "!   <li>iso: yyyy-mm-dd, yyyy.mm.dd, yyyy/mm/dd (example: 2021-12-25)</li>
    "!   <li>internal: yyyymmdd (example: 20211225)</li>
    "! </ul>
    "!
    "! @parameter iv_input | <p class="shorttext synchronized" lang="en">The input date string to be converted</p>
    "! @parameter iv_format | <p class="shorttext synchronized" lang="en">The expected format of the input date string</p>
    "! @parameter iv_plausibility_check | <p class="shorttext synchronized" lang="en">Performs a plausibility check on the input date string</p>
    "! @parameter ev_format | <p class="shorttext synchronized" lang="en">The found format of the input date string</p>
    "! @parameter rv_output | <p class="shorttext synchronized" lang="en">The internal date representation after conversion</p>
    "! @raising zcx_brx_conversion_failed | <p class="shorttext synchronized" lang="en">Raised when the conversion fails</p>
    CLASS-METHODS parse_date
      IMPORTING
        iv_input              TYPE clike
        iv_format             TYPE zif_brx_type=>tv_date_format DEFAULT zif_brx_const=>gc_date_format-auto
        iv_plausibility_check TYPE abap_bool DEFAULT abap_true
      EXPORTING
        ev_format             TYPE zif_brx_type=>tv_date_format
      RETURNING
        VALUE(rv_output)      TYPE d
      RAISING
        zcx_brx_conversion_failed.


    "! <p class="shorttext synchronized" lang="en">Converts a time string to an internal time representation</p>
    "!
    "! <p>Accepted input formats:</p>
    "! <ul>
    "!   <li>auto: tries all formats below in parser order</li>
    "!   <li>eur: hh.mm.ss (example: 14.30.59)</li>
    "!   <li>iso: hh:mm:ss (example: 14:30:59)</li>
    "!   <li>internal: hhmmss (example: 143059)</li>
    "! </ul>
    "!
    "! @parameter iv_input | <p class="shorttext synchronized" lang="en">The input time string to be converted</p>
    "! @parameter iv_plausibility_check | <p class="shorttext synchronized" lang="en">Performs a plausibility check on the input time string</p>
    "! @parameter ev_offset | <p class="shorttext synchronized" lang="en">The offset in seconds from UTC</p>
    "! @parameter ev_fraction | <p class="shorttext synchronized" lang="en">The fractional seconds part of the time</p>
    "! @parameter rv_output | <p class="shorttext synchronized" lang="en">The internal time representation after conversion</p>
    "! @raising zcx_brx_conversion_failed | <p class="shorttext synchronized" lang="en">Raised when the conversion fails</p>
    CLASS-METHODS parse_time
      IMPORTING
        iv_input              TYPE clike
        iv_plausibility_check TYPE abap_bool DEFAULT abap_true
      EXPORTING
        ev_offset             TYPE zif_brx_type=>tv_seconds
        ev_fraction           TYPE zif_brx_type=>tv_seconds
      RETURNING
        VALUE(rv_output)      TYPE t
      RAISING
        zcx_brx_conversion_failed.


    "! <p class="shorttext synchronized" lang="en">Converts a date/time string to internal date and time</p>
    "!
    "! <p>Accepted input forms:</p>
    "! <ul>
    "!   <li><strong>raw</strong>: yyyymmddhhmmss[.fff...]
    "!       (example: 20211225143059, 20211225143059.123)</li>
    "!   <li><strong>text date only</strong>: date part only; time remains initial
    "!       (examples: 25.12.2021, 12/25/2021, 2021-12-25)</li>
    "!   <li><strong>text date-time</strong>: date + separator (space or T) + time
    "!       (examples: 2021-12-25 14:30:59, 2021-12-25T14:30:59Z)</li>
    "!   <li>Time accepts optional fraction and offset, as documented in parse_time.</li>
    "!   <li>Date parsing supports auto-detection, as documented in parse_date.</li>
    "! </ul>
    "!
    "! @parameter iv_input | <p class="shorttext synchronized" lang="en">The input date/time string to be converted</p>
    "! @parameter iv_plausibility_check | <p class="shorttext synchronized" lang="en">Performs a plausibility check on the parsed date and time</p>
    "! @parameter ev_offset | <p class="shorttext synchronized" lang="en">The offset in seconds from UTC parsed from the time part</p>
    "! @parameter ev_fraction | <p class="shorttext synchronized" lang="en">The fractional seconds part parsed from the time part</p>
    "! @parameter ev_date | <p class="shorttext synchronized" lang="en">The internal date representation after conversion</p>
    "! @parameter ev_time | <p class="shorttext synchronized" lang="en">The internal time representation after conversion</p>
    "! @raising zcx_brx_conversion_failed | <p class="shorttext synchronized" lang="en">Raised when the conversion fails</p>
    CLASS-METHODS parse_date_time
      IMPORTING
        iv_input              TYPE clike
        iv_date_format        TYPE zif_brx_type=>tv_date_format DEFAULT zif_brx_const=>gc_date_format-auto
        iv_plausibility_check TYPE abap_bool DEFAULT abap_true
      EXPORTING
        ev_offset             TYPE zif_brx_type=>tv_seconds
        ev_fraction           TYPE zif_brx_type=>tv_seconds
        ev_date               TYPE d
        ev_time               TYPE t
      RAISING
        zcx_brx_conversion_failed.


    "! <p class="shorttext synchronized" lang="en">Converts a timestamp string to an internal timestamp</p>
    "!
    "! <p>Accepted input formats (depending on iv_date_format):</p>
    "! <ul>
    "!   <li>auto: tries all formats below in parser order</li>
    "!   <li>raw: yyyymmddhhmmss[.fff...] (example: 20211225143059 or 20211225143059.123)</li>
    "!   <li>iso_utc: yyyy-mm-ddThh:mm:ss[.fff...]Z (example: 2021-12-25T14:30:59Z)</li>
    "!   <li>iso_offset: yyyy-mm-ddThh:mm:ss[.fff...]+/-hh:mm (example: 2021-12-25T14:30:59+01:00)</li>
    "!   <li>iso_local: yyyy-mm-ddThh:mm:ss[.fff...] (example: 2021-12-25T14:30:59)</li>
    "!   <li>text: date [time], where time is optional</li>
    "!   <li>text date examples: 25.12.2021, 12/25/2021, 2021.12.25, 2021-12-25</li>
    "!   <li>text date-time examples: 2021-12-25 14:30:59, 25.12.2021 14:30:59.123</li>
    "! </ul>
    "!
    "! <p><strong>Limitation: offsets and daylight saving time (DST)</strong></p>
    "! <p>A UTC offset (for example +01:00 or -05:00) is only a fixed shift relative to UTC.
    "! It does not identify a time zone and carries no DST rules. Therefore, the offset
    "! alone cannot tell whether a local date and time actually exists in a given zone
    "! (spring-forward gap, e.g. 2026-03-08T02:30:00-05:00 in America/New_York)
    "! or is ambiguous (fall-back overlap). ISO 8601 does not carry a time zone ID
    "! such as America/New_York either.</p>
    "! <p>Consequences:</p>
    "! <ul>
    "!   <li>iso_utc and iso_offset: the offset is applied as is. No DST validation is possible,
    "!       so the result is not safe for DST-sensitive local times.</li>
    "!   <li>iso_local, raw and text: no offset is present. The value is interpreted as local time
    "!       in iv_timezone. Only in this case can nonexistent or ambiguous local times
    "!       be detected.</li>
    "!   <li>The plausibility check validates the date and time values (ranges), not DST correctness
    "!       derived from an offset.</li>
    "! </ul>
    "!
    "! @parameter iv_input | <p class="shorttext synchronized" lang="en">The input timestamp string to be converted</p>
    "! @parameter iv_date_format | <p class="shorttext synchronized" lang="en">The expected format of the input</p>
    "! @parameter iv_plausibility_check | <p class="shorttext synchronized" lang="en">Performs a plausibility check</p>
    "! @parameter rv_output | <p class="shorttext synchronized" lang="en">The internal timestamp representation after conversion</p>
    "! @raising zcx_brx_conversion_failed | <p class="shorttext synchronized" lang="en">Raised when the conversion fails</p>
    CLASS-METHODS parse_timestamp
      IMPORTING
        iv_input              TYPE clike
        iv_date_format        TYPE zif_brx_type=>tv_date_format DEFAULT zif_brx_const=>gc_date_format-auto
        iv_plausibility_check TYPE abap_bool DEFAULT abap_true
      RETURNING
        VALUE(rv_output)      TYPE zif_brx_type=>tv_timestamp_long
      RAISING
        zcx_brx_conversion_failed.





  PROTECTED SECTION.
  PRIVATE SECTION.
    "! <p class="shorttext synchronized" lang="en">Creates a matcher object for the given pattern and text</p>
    "!
    "! @parameter iv_pattern | <p class="shorttext synchronized" lang="en">The regular expression pattern to be used for matching</p>
    "! @parameter iv_text | <p class="shorttext synchronized" lang="en">The text to be matched against the pattern</p>
    "! @parameter iv_ignore_case | <p class="shorttext synchronized" lang="en">Case sensitivity</p>
    "! @parameter ro_matcher | <p class="shorttext synchronized" lang="en">The matcher object</p>
    CLASS-METHODS create_matcher
      IMPORTING
        iv_pattern        TYPE clike
        iv_text           TYPE clike
        iv_ignore_case    TYPE abap_bool DEFAULT abap_true
      RETURNING
        VALUE(ro_matcher) TYPE REF TO cl_abap_matcher.


    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Regular expressions for date matching</p>
      "! <p> The name of constant should match the constant value {@link zif_brx_const=>gc_date_format }
      BEGIN OF gc_date_matcher,
        ymd TYPE string VALUE `^(\d{4})[-./]?(0?[1-9]|1[0-2])[-./]?(0?[1-9]|[12]\d|3[01])$` ##NO_TEXT,
        dmy TYPE string VALUE `^(0?[1-9]|[12]\d|3[01])[-./](0?[1-9]|1[0-2])[-./](\d{4})$` ##NO_TEXT,
        mdy TYPE string VALUE `^(0?[1-9]|1[0-2])[-./](0?[1-9]|[12]\d|3[01])[-./](\d{4})$` ##NO_TEXT,
      END OF gc_date_matcher.

    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Regular expressions for time matching</p>
      "! <p>Time regex (group 2): accepted formats:</p>
      "! <ul>
      "!   <li>HH:MM or HH:MM:SS or HH:MM:SS[.,]fraction</li>
      "!   <li>HHMM or HHMMSS or HHMMSS[.,]fraction</li>
      "!   <li>Optional timezone suffix: Z, +HH:MM, -HH:MM, +HHMM, -HHMM</li>
      "!   <li>Fraction is only allowed after seconds.</li>
      "!   <li>Validates structure only, not value ranges.</li>
      "! </ul>
      BEGIN OF gc_time_matcher,
        default TYPE string VALUE `^([01]\d|2[0-3]):?([0-5]\d)(?::?([0-5]\d))?(?:[.,](\d+))?(Z|[+-](?:[01]\d|2[0-3]):?[0-5]\d)?$` ##NO_TEXT,
      END OF gc_time_matcher.


    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Regular expressions for timestamp matching</p>
      "! <p>Timestamp regex patterns:</p>
      "! <ul>
      "!   <li><strong>raw</strong>: yyyymmddhhmmss[.,]fraction</li>
      "!   <li>raw group 1: date part in internal format (yyyymmdd)</li>
      "!   <li>raw group 2: time part in internal format (hhmmss) with optional fraction</li>
      "!   <li><strong>date_time</strong>: splits text into date and optional time by first separator
      "!       (space or T)</li>
      "!   <li>Examples: 20211225143059, 20211225143059.123,
      "!       2021-12-25 14:30:59, 2021-12-25T14:30:59+01:00</li>
      "!   <li>Validates structure only; semantic date/time plausibility is checked later.</li>
      "! </ul>
      BEGIN OF gc_timestamp_matcher,
        raw       TYPE string VALUE `^(\d{4}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01]))((?:[01]\d|2[0-3])[0-5]\d[0-5]\d(?:[.,]\d+)?)$` ##NO_TEXT,
        date_time TYPE string VALUE `^(.+?)(?:[ T](.+))?$`,
      END OF gc_timestamp_matcher.

ENDCLASS.



CLASS zcl_brx_conversion IMPLEMENTATION.


  METHOD create_matcher.
    DATA(lo_regex) = cl_abap_regex=>create_pcre(
      pattern     = iv_pattern
      ignore_case = iv_ignore_case ).
    RETURN lo_regex->create_matcher( text = iv_text ).
  ENDMETHOD.


  METHOD parse_date.
    DATA:
      BEGIN OF ls_date_comp,
        year  TYPE n LENGTH 4,
        month TYPE n LENGTH 2,
        day   TYPE n LENGTH 2,
      END OF ls_date_comp,
      lt_date_format TYPE STANDARD TABLE OF zif_brx_type=>tv_date_format WITH EMPTY KEY.

    CLEAR ev_format.

    DATA(lv_input) = CONV string( iv_input ).

    IF iv_format EQ zif_brx_const=>gc_date_format-auto.
      lt_date_format = VALUE #( ( zif_brx_const=>gc_date_format-ymd )
                                ( zif_brx_const=>gc_date_format-dmy )
                                ( zif_brx_const=>gc_date_format-mdy )
                              ).
    ELSE.
      lt_date_format = VALUE #( ( iv_format ) ).
    ENDIF.

    LOOP AT lt_date_format ASSIGNING FIELD-SYMBOL(<lv_format>).

      ASSIGN COMPONENT <lv_format> OF STRUCTURE gc_date_matcher TO FIELD-SYMBOL(<lv_pattern>).

      TRY.

          DATA(lo_matcher) = create_matcher(
            iv_pattern = <lv_pattern>
            iv_text    = lv_input
          ).

          IF NOT lo_matcher->match( ).
            CONTINUE.
          ENDIF.

          DATA(ls_match) = lo_matcher->get_match( ).

          LOOP AT ls_match-submatches REFERENCE INTO DATA(lrs_submatch).
            DATA(lv_offset) = sy-tabix - 1.
            CASE <lv_format>+lv_offset(1).
              WHEN 'D'.
                ls_date_comp-day = lv_input+lrs_submatch->offset(lrs_submatch->length).
              WHEN 'M'.
                ls_date_comp-month = lv_input+lrs_submatch->offset(lrs_submatch->length).
              WHEN 'Y'.
                ls_date_comp-year = lv_input+lrs_submatch->offset(lrs_submatch->length).
              WHEN OTHERS.
                ASSERT 0 = 1. " Invalid constant!
                CONTINUE.
            ENDCASE.
          ENDLOOP.

          DATA(lv_date) = CONV d( ls_date_comp ).

          IF iv_plausibility_check EQ abap_true.
            TRY.
                cl_abap_tstmp=>systemtstmp_syst2utc(
                  syst_date = lv_date
                  syst_time = '000000'
                ).
              CATCH cx_parameter_invalid_range.
                CONTINUE.
            ENDTRY.
          ENDIF.

          rv_output = lv_date.
          ev_format = <lv_format>.

          EXIT.

        CATCH cx_sy_matcher.
          CONTINUE.
      ENDTRY.


    ENDLOOP.

    IF ev_format IS INITIAL.
      RAISE EXCEPTION TYPE zcx_brx_conversion_failed
        EXPORTING
          textid   = zcx_brx_conversion_failed=>conversion_to_datatype_failed
          value    = iv_input
          datatype = 'DATE'.
    ENDIF.
  ENDMETHOD.


  METHOD parse_time.
    TYPES:
      BEGIN OF ts_time_comp,
        hour   TYPE n LENGTH 2,
        minute TYPE n LENGTH 2,
        second TYPE n LENGTH 2,
      END OF ts_time_comp.


    CLEAR:
      ev_offset,
      ev_fraction.

    DATA(lv_input) = CONV string( iv_input ).
    CONDENSE lv_input.

    DATA(lv_match) = abap_false.

    DO.

      DATA(lo_matcher) = create_matcher(
        iv_pattern = gc_time_matcher-default
        iv_text    = lv_input
      ).

      IF NOT lo_matcher->match( ).
        EXIT.
      ENDIF.

      TRY.
          DATA(ls_match) = lo_matcher->get_match( ).
        CATCH cx_sy_matcher.
          EXIT.
      ENDTRY.

      DATA(ls_time_comp) = VALUE ts_time_comp( ).

      LOOP AT ls_match-submatches REFERENCE INTO DATA(lrs_submatch)
                                      WHERE offset GE 0 AND length GT 0.
        DATA(lv_substring) = lv_input+lrs_submatch->offset(lrs_submatch->length).
        CASE sy-tabix.
          WHEN 1.
            ls_time_comp-hour = lv_substring.
          WHEN 2.
            ls_time_comp-minute = lv_substring.
          WHEN 3.
            ls_time_comp-second = lv_substring.
          WHEN 4.
            IF lv_substring IS NOT INITIAL.
              ev_fraction = |0.{ lv_substring }|.
            ENDIF.
          WHEN 5.
            IF lv_substring EQ 'Z'.
              ev_offset = 0.
            ELSE.
              DATA(lv_offset_sign) = lv_substring(1).
              DATA(lv_offset_time) = lv_substring+1(*).

              DATA(ls_offset_comp) = CONV ts_time_comp( parse_time( lv_offset_time ) ).

              ev_offset = ( ls_offset_comp-hour * 3600 + ls_offset_comp-minute * 60 + ls_offset_comp-second )
                                * ( COND #( WHEN lv_offset_sign EQ '-' THEN -1 ELSE 1 ) ).

            ENDIF.
          WHEN OTHERS.
            CONTINUE.
        ENDCASE.
      ENDLOOP.

      rv_output = ls_time_comp.

      lv_match = abap_true.
      EXIT.

    ENDDO.

    IF lv_match NE abap_true.
      RAISE EXCEPTION TYPE zcx_brx_conversion_failed
        EXPORTING
          textid   = zcx_brx_conversion_failed=>conversion_to_datatype_failed
          value    = iv_input
          datatype = 'TIME'.
    ENDIF.

    IF iv_plausibility_check EQ abap_true AND rv_output IS NOT INITIAL.
      TRY.
          cl_abap_tstmp=>systemtstmp_syst2utc(
            syst_date = '20010101'
            syst_time = rv_output
          ).
        CATCH cx_parameter_invalid_range INTO DATA(lo_invalid_range).
          RAISE EXCEPTION TYPE zcx_brx_conversion_failed
            EXPORTING
              textid   = zcx_brx_conversion_failed=>conversion_to_datatype_failed
              value    = iv_input
              datatype = 'TIME'
              previous = lo_invalid_range.
      ENDTRY.
    ENDIF.
  ENDMETHOD.



  METHOD parse_date_time.

    DATA(lv_input) = CONV string( iv_input ).
    CONDENSE lv_input.

    DATA(lv_match) = abap_false.

    DO.

      CASE sy-index.
        WHEN 1.
          DATA(lv_pattern) = gc_timestamp_matcher-raw.
        WHEN 2.
          lv_pattern = gc_timestamp_matcher-date_time.
        WHEN OTHERS.
          EXIT.
      ENDCASE.

      " First try to match the raw timestamp format
      DATA(lo_matcher) = create_matcher(
        iv_pattern = lv_pattern
        iv_text    = lv_input
      ).

      CLEAR:
        ev_offset,
        ev_fraction,
        ev_date,
        ev_time.

      TRY.
          IF lo_matcher->match( ).
            DATA(ls_match) = lo_matcher->get_match( ).

            LOOP AT ls_match-submatches REFERENCE INTO DATA(lrs_submatch)
                                            WHERE offset GE 0 AND length GT 0.
              DATA(lv_substring) = lv_input+lrs_submatch->offset(lrs_submatch->length).
              CASE sy-tabix.
                WHEN 1.
                  ev_date = parse_date(
                    iv_input              = lv_substring
                    iv_format             = iv_date_format
                    iv_plausibility_check = iv_plausibility_check
                  ).
                WHEN 2.
                  parse_time(
                    EXPORTING
                      iv_input              = lv_substring
                      iv_plausibility_check = iv_plausibility_check
                    IMPORTING
                      ev_offset             = ev_offset
                      ev_fraction           = ev_fraction
                    RECEIVING
                      rv_output             = ev_time
                  ).
                WHEN OTHERS.
                  CONTINUE.
              ENDCASE.
            ENDLOOP.

            lv_match  = abap_true.
            EXIT.
          ENDIF.

        CATCH cx_sy_matcher.
          CONTINUE.
      ENDTRY.
    ENDDO.


    IF lv_match NE abap_true.
      RAISE EXCEPTION TYPE zcx_brx_conversion_failed
        EXPORTING
          textid   = zcx_brx_conversion_failed=>conversion_to_datatype_failed
          value    = iv_input
          datatype = 'TIMESTAMP'.
    ENDIF.

    IF iv_plausibility_check EQ abap_true AND ev_date IS NOT INITIAL AND ev_time IS NOT INITIAL.
      TRY.
          cl_abap_tstmp=>systemtstmp_syst2utc(
            syst_date = ev_date
            syst_time = ev_time
          ).

        CATCH cx_parameter_invalid_range INTO DATA(lo_invalid_range).
          RAISE EXCEPTION TYPE zcx_brx_conversion_failed
            EXPORTING
              textid   = zcx_brx_conversion_failed=>conversion_to_datatype_failed
              value    = iv_input
              datatype = 'DATE/TIME'
              previous = lo_invalid_range.
      ENDTRY.
    ENDIF.

  ENDMETHOD.



  METHOD parse_timestamp.
    parse_date_time(
      EXPORTING
        iv_input              = iv_input
        iv_plausibility_check = iv_plausibility_check
      IMPORTING
        ev_offset             = DATA(lv_offset)
        ev_fraction           = DATA(lv_fraction)
        ev_date               = DATA(lv_date)
        ev_time               = DATA(lv_time)
    ).

    CONVERT DATE lv_date TIME lv_time INTO
            TIME STAMP rv_output TIME ZONE 'UTC'.
    IF sy-subrc IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_brx_conversion_failed
        EXPORTING
          textid   = zcx_brx_conversion_failed=>conversion_to_datatype_failed
          value    = iv_input
          datatype = 'TIMESTAMP'.
    ENDIF.

    TRY.
        rv_output = cl_abap_tstmp=>add(
          tstmp = rv_output
          secs  = lv_fraction - lv_offset
        ).

        cl_abap_tstmp=>systemtstmp_utc2syst(
          EXPORTING
            utc_tstmp = floor( rv_output )
        ).

      CATCH cx_parameter_invalid INTO DATA(lo_parameter_invalid).
        RAISE EXCEPTION TYPE zcx_brx_conversion_failed
          EXPORTING
            textid   = zcx_brx_conversion_failed=>conversion_to_datatype_failed
            value    = iv_input
            datatype = 'TIMESTAMP'
            previous = lo_parameter_invalid.
    ENDTRY.
  ENDMETHOD.


ENDCLASS.
