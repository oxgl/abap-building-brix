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
        zcx_brx_conversion_failed
        zcx_brx_out_of_range.

    "! <p class="shorttext synchronized" lang="en">Converts a timestamp string to an internal timestamp</p>
    "!
    "! <p>Accepted input formats (depending on iv_format):</p>
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
    "! @parameter iv_input | <p class="shorttext synchronized" lang="en">The input timestamp string to be converted</p>
    "! @parameter iv_format | <p class="shorttext synchronized" lang="en">The expected format of the input timestamp string</p>
    "! @parameter iv_plausibility_check | <p class="shorttext synchronized" lang="en">Performs a plausibility check on the input timestamp string</p>
    "! @parameter ev_format | <p class="shorttext synchronized" lang="en">The found format of the input timestamp string</p>
    "! @parameter rv_output | <p class="shorttext synchronized" lang="en">The internal timestamp representation after conversion</p>
    "! @raising zcx_brx_conversion_failed | <p class="shorttext synchronized" lang="en">Raised when the conversion fails</p>
    "! @raising zcx_brx_out_of_range | <p class="shorttext synchronized" lang="en">Raised when the input timestamp is out of range</p>
    CLASS-METHODS parse_timestamp
      IMPORTING
        iv_input              TYPE clike
        iv_format             TYPE zif_brx_type=>tv_timestamp_format DEFAULT zif_brx_const=>gc_timestamp_format-auto
        iv_plausibility_check TYPE abap_bool DEFAULT abap_true
      EXPORTING
        ev_format             TYPE zif_brx_type=>tv_timestamp_format
      RETURNING
        VALUE(rv_output)      TYPE zif_brx_type=>tv_timestamp_long
      RAISING
        zcx_brx_conversion_failed
        zcx_brx_out_of_range.

    "! <p class="shorttext synchronized" lang="en">Converts a time string to an internal time representation</p>
    "!
    "! <p>Accepted input formats (depending on iv_format):</p>
    "! <ul>
    "!   <li>auto: tries all formats below in parser order</li>
    "!   <li>eur: hh.mm.ss (example: 14.30.59)</li>
    "!   <li>iso: hh:mm:ss (example: 14:30:59)</li>
    "!   <li>internal: hhmmss (example: 143059)</li>
    "! </ul>
    "!
    "! @parameter iv_input | <p class="shorttext synchronized" lang="en">The input time string to be converted</p>
    "! @parameter iv_format | <p class="shorttext synchronized" lang="en">The expected format of the input time string</p>
    "! @parameter iv_plausibility_check | <p class="shorttext synchronized" lang="en">Performs a plausibility check on the input time string</p>
    "! @parameter ev_format | <p class="shorttext synchronized" lang="en">The found format of the input time string</p>
    "! @parameter rv_output | <p class="shorttext synchronized" lang="en">The internal time representation after conversion</p>
    "! @raising zcx_brx_conversion_failed | <p class="shorttext synchronized" lang="en">Raised when the conversion fails</p>
    "! @raising zcx_brx_out_of_range | <p class="shorttext synchronized" lang="en">Raised when the input time is out of range</p>
    CLASS-METHODS parse_time
      IMPORTING
        iv_input              TYPE clike
        iv_format             TYPE zif_brx_type=>tv_time_format DEFAULT zif_brx_const=>gc_time_format-auto
        iv_plausibility_check TYPE abap_bool DEFAULT abap_true
      EXPORTING
        ev_format             TYPE zif_brx_type=>tv_time_format
      RETURNING
        VALUE(rv_output)      TYPE t
      RAISING
        zcx_brx_conversion_failed
        zcx_brx_out_of_range.


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

ENDCLASS.



CLASS zcl_brx_conversion IMPLEMENTATION.
  METHOD create_matcher.
    DATA(lo_regex) = cl_abap_regex=>create_pcre(
      pattern     = iv_pattern
      ignore_case = iv_ignore_case ).
    RETURN lo_regex->create_matcher( text = iv_text ).
  ENDMETHOD.

  METHOD parse_date.

    TYPES:
      BEGIN OF ts_date_components,
        year(4)  TYPE n,
        month(2) TYPE n,
        day(2)   TYPE n,
      END OF ts_date_components.

    CONSTANTS:
      BEGIN OF lc_regex,
        eur TYPE string VALUE '^(0[1-9]|[1-2][0-9]|3[0-1]|[1-9])\.(0[1-9]|1[0-2]|[1-9])\.([0-9]{4})',
        usa TYPE string VALUE '^(0[1-9]|1[0-2]|[1-9])[/-](0[1-9]|[1-2][0-9]|3[0-1]|[1-9])[/-]([0-9]{4})',
        iso TYPE string VALUE '^([0-9]{4})[-/.](0[1-9]|1[0-2]|[1-9])[-/.](0[1-9]|[1-2][0-9]|3[0-1]|[1-9])',
        int TYPE string VALUE '^([0-9]{4})(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])',
      END OF lc_regex.

    DATA:
      ls_datecomp TYPE ts_date_components.

    FIELD-SYMBOLS:
     <fss_submatch>   TYPE submatch_result.


    DEFINE lm_save_submatch.  " &text &submatch_table &submatch1 &submatch2 &submatch3
      LOOP AT &2 ASSIGNING <fss_submatch>.
        CASE sy-tabix.
          WHEN 1.
            &3 = &1+<fss_submatch>-offset(<fss_submatch>-length).
          WHEN 2.
            &4 = &1+<fss_submatch>-offset(<fss_submatch>-length).
          WHEN 3.
            &5 = &1+<fss_submatch>-offset(<fss_submatch>-length).
        ENDCASE.
      ENDLOOP.
    END-OF-DEFINITION.

    ev_format = zif_brx_const=>gc_date_format-unknown.

    DATA(lv_input) = CONV string( iv_input ).
    CONDENSE lv_input NO-GAPS.

    TRY.

        DO.
          IF iv_format = zif_brx_const=>gc_date_format-auto OR iv_format = zif_brx_const=>gc_date_format-eur.
            DATA(lo_matcher) = create_matcher( iv_pattern = lc_regex-eur iv_text = iv_input ).  " Try to parse as EUR
            IF lo_matcher->match( ).
              DATA(ls_match) = lo_matcher->get_match( ).
              lm_save_submatch lv_input ls_match-submatches ls_datecomp-day ls_datecomp-month ls_datecomp-year.

              rv_output = ls_datecomp.
              ev_format = zif_brx_const=>gc_date_format-eur.
              EXIT.
            ENDIF.
          ENDIF.

          IF iv_format = zif_brx_const=>gc_date_format-auto OR iv_format = zif_brx_const=>gc_date_format-iso.
            lo_matcher = create_matcher( iv_pattern = lc_regex-iso iv_text = iv_input ).        " Try to parse as ISO
            IF lo_matcher->match( ).
              ls_match = lo_matcher->get_match( ).
              lm_save_submatch lv_input ls_match-submatches ls_datecomp-year ls_datecomp-month ls_datecomp-day.

              rv_output = ls_datecomp.
              ev_format = zif_brx_const=>gc_date_format-iso.
              EXIT.
            ENDIF.
          ENDIF.

          IF iv_format = zif_brx_const=>gc_date_format-auto OR iv_format = zif_brx_const=>gc_date_format-usa.
            lo_matcher = create_matcher( iv_pattern = lc_regex-usa iv_text = iv_input ).         " Try to parse as USA
            IF lo_matcher->match( ).
              ls_match = lo_matcher->get_match( ).
              lm_save_submatch lv_input ls_match-submatches ls_datecomp-month ls_datecomp-day ls_datecomp-year.

              rv_output = ls_datecomp.
              ev_format = zif_brx_const=>gc_date_format-usa.
              EXIT.
            ENDIF.
          ENDIF.

          IF iv_format = zif_brx_const=>gc_date_format-auto OR iv_format = zif_brx_const=>gc_date_format-internal.
            lo_matcher = create_matcher( iv_pattern = lc_regex-int iv_text = iv_input ).         " Try to parse as Internal
            IF lo_matcher->match( ).
              ls_match = lo_matcher->get_match( ).
              lm_save_submatch lv_input ls_match-submatches ls_datecomp-year ls_datecomp-month ls_datecomp-day.

              rv_output = ls_datecomp.
              ev_format = zif_brx_const=>gc_date_format-internal.
              EXIT.
            ENDIF.
          ENDIF.

          EXIT.

        ENDDO.

      CATCH cx_sy_regex cx_sy_matcher.
        ASSERT 0 = 1.
    ENDTRY.

    IF ev_format EQ zif_brx_const=>gc_date_format-unknown.
      RAISE EXCEPTION TYPE zcx_brx_conversion_failed.
    ENDIF.

    IF iv_plausibility_check EQ abap_true AND rv_output IS NOT INITIAL.
      TRY.
          cl_abap_tstmp=>systemtstmp_syst2utc(
            syst_date = rv_output
            syst_time = '000000'
          ).
        CATCH cx_parameter_invalid_range INTO DATA(lo_invalid_range).
          RAISE EXCEPTION TYPE zcx_brx_out_of_range
            EXPORTING
              previous = lo_invalid_range.
      ENDTRY.
    ENDIF.


  ENDMETHOD.

  METHOD parse_timestamp.
    TYPES:
      BEGIN OF ts_pattern_format,
        pattern TYPE string,
        format  TYPE zif_brx_type=>tv_timestamp_format,
      END OF ts_pattern_format,

      tt_pattern_format TYPE STANDARD TABLE OF ts_pattern_format WITH DEFAULT KEY.

    CONSTANTS:
      BEGIN OF lc_timestamp_pattern,
        raw    TYPE string  VALUE '[0-9]{14}(.[0-9]*)?',
        global TYPE string  VALUE '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(.[0-9]*)?(Z)',
        offset TYPE string  VALUE '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(.[0-9]*)?[+-][0-9]{2}:[0-9]{2}',
        local  TYPE string  VALUE '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(.[0-9]*)?',
        text   TYPE string  VALUE '^((([0-9]{4}[-/.][0-9]{1,2}[-/.][0-9]{1,2})|([0-9]{1,2}[./-][0-9]{1,2}[./-][0-9]{4}))([[:space:]][0-9]{2}:[0-9]{2}:[0-9]{2}(.[0-9]*)?)?)$',
      END OF lc_timestamp_pattern.

    ev_format = zif_brx_const=>gc_timestamp_format-unknown.

    DATA(lv_input) = CONV string( iv_input ).

    FINAL(lt_pattern_format) = VALUE tt_pattern_format(
       ( pattern = lc_timestamp_pattern-raw    format = zif_brx_const=>gc_timestamp_format-raw )
       ( pattern = lc_timestamp_pattern-global format = zif_brx_const=>gc_timestamp_format-iso_utc )
       ( pattern = lc_timestamp_pattern-offset format = zif_brx_const=>gc_timestamp_format-iso_offset )
       ( pattern = lc_timestamp_pattern-local  format = zif_brx_const=>gc_timestamp_format-iso_local )
       ( pattern = lc_timestamp_pattern-text   format = zif_brx_const=>gc_timestamp_format-text )
    ).

    LOOP AT lt_pattern_format ASSIGNING FIELD-SYMBOL(<fss_pattern_format>).
      CHECK iv_format EQ <fss_pattern_format>-format
         OR iv_format EQ zif_brx_const=>gc_timestamp_format-auto.

      CHECK <fss_pattern_format>-pattern IS INITIAL
         OR cl_abap_matcher=>matches(
              pattern = <fss_pattern_format>-pattern
              text    = iv_input ).

      CASE <fss_pattern_format>-format.
        WHEN zif_brx_const=>gc_timestamp_format-raw.
          CONDENSE lv_input NO-GAPS.

          IF strlen( lv_input ) GE 8.
            WHILE strlen( lv_input ) LT 14.
              lv_input = lv_input && '0'.
            ENDWHILE.
            rv_output = lv_input.
            ev_format = zif_brx_const=>gc_timestamp_format-raw.
            EXIT.
          ENDIF.

        WHEN zif_brx_const=>gc_timestamp_format-iso_utc
          OR zif_brx_const=>gc_timestamp_format-iso_offset
          OR zif_brx_const=>gc_timestamp_format-iso_local.

          TRY.
              cl_gdt_conversion=>date_time_inbound(
                EXPORTING
                  im_value      = lv_input
                IMPORTING
                  ex_value_long = rv_output ).

              ev_format = <fss_pattern_format>-format.
              EXIT.
            CATCH cx_gdt_conversion.
          ENDTRY.

        WHEN zif_brx_const=>gc_timestamp_format-text.
          SPLIT lv_input AT space INTO TABLE DATA(lt_parts).

          IF lines( lt_parts ) GE 1.
            TRY.
                DATA(lv_date) = parse_date( lt_parts[ 1 ] ).
              CATCH zcx_brx_static_check.
                CONTINUE.
            ENDTRY.

            TRY.
                IF lines( lt_parts ) GE 2.
                  DATA(lv_time) = parse_time( lt_parts[ 2 ] ).
                ENDIF.
              CATCH zcx_brx_static_check.
                CLEAR lv_time.
            ENDTRY.

            IF lv_date IS NOT INITIAL.
              CONVERT DATE lv_date TIME lv_time
                 INTO TIME STAMP rv_output TIME ZONE 'UTC'.
              ev_format = zif_brx_const=>gc_timestamp_format-text.
              EXIT.
            ENDIF.
          ENDIF.

      ENDCASE.
    ENDLOOP.

    IF ev_format EQ zif_brx_const=>gc_date_format-unknown.
      RAISE EXCEPTION TYPE zcx_brx_conversion_failed.
    ENDIF.

    IF iv_plausibility_check EQ abap_true AND rv_output IS NOT INITIAL.
      TRY.
          cl_abap_tstmp=>systemtstmp_utc2syst(
            utc_tstmp = floor( rv_output )
          ).
        CATCH cx_parameter_invalid_range INTO DATA(lo_invalid_range).
          RAISE EXCEPTION TYPE zcx_brx_out_of_range
            EXPORTING
              previous = lo_invalid_range.
      ENDTRY.
    ENDIF.

  ENDMETHOD.

  METHOD parse_time.
    TYPES:
      BEGIN OF ts_time_components,
        hour(2)   TYPE n,
        minute(2) TYPE n,
        second(2) TYPE n,
      END OF ts_time_components.

    CONSTANTS:
      BEGIN OF lc_regex,
        eur TYPE string VALUE '^(0[1-9]|1[0-9]|2[0-3]|[1-9])\.([0-5][0-9]|[0-9])\.([0-5][0-9]|[0-9])',
        iso TYPE string VALUE '^(0[1-9]|1[0-9]|2[0-3]|[1-9])\:([0-5][0-9]|[0-9])\:([0-5][0-9]|[0-9])',
        int TYPE string VALUE '^(0[1-9]|1[0-9]|2[0-3])([0-5][0-9])([0-5][0-9])',
      END OF lc_regex.

    DATA:
      ls_timecomp TYPE ts_time_components.

    FIELD-SYMBOLS:
      <fss_submatch>   TYPE submatch_result.

    DEFINE lm_save_submatch.  " &text &submatch_table &submatch1 &submatch2 &submatch3
      LOOP AT &2 ASSIGNING <fss_submatch>.
        CASE sy-tabix.
          WHEN 1.
            &3 = &1+<fss_submatch>-offset(<fss_submatch>-length).
          WHEN 2.
            &4 = &1+<fss_submatch>-offset(<fss_submatch>-length).
          WHEN 3.
            &5 = &1+<fss_submatch>-offset(<fss_submatch>-length).
        ENDCASE.
      ENDLOOP.
    END-OF-DEFINITION.

    ev_format = zif_brx_const=>gc_time_format-unknown.

    DATA(lv_input) = CONV string( iv_input ).
    CONDENSE lv_input NO-GAPS.

    TRY.
        DO.
          IF iv_format = zif_brx_const=>gc_time_format-auto OR iv_format = zif_brx_const=>gc_time_format-eur.
            DATA(lo_matcher) = create_matcher( iv_pattern = lc_regex-eur iv_text = iv_input ).      " Try to parse as EUR
            IF lo_matcher->match( ).
              DATA(ls_match) = lo_matcher->get_match( ).
              lm_save_submatch lv_input ls_match-submatches ls_timecomp-hour ls_timecomp-minute ls_timecomp-second.

              rv_output = ls_timecomp.
              ev_format = zif_brx_const=>gc_time_format-eur.
              EXIT.
            ENDIF.
          ENDIF.

          IF iv_format = zif_brx_const=>gc_time_format-auto OR iv_format = zif_brx_const=>gc_time_format-iso.
            lo_matcher = create_matcher( iv_pattern = lc_regex-iso iv_text = iv_input ).            " Try to parse as ISO
            IF lo_matcher->match( ).
              ls_match = lo_matcher->get_match( ).
              lm_save_submatch lv_input ls_match-submatches ls_timecomp-hour ls_timecomp-minute ls_timecomp-second.

              rv_output = ls_timecomp.
              ev_format = zif_brx_const=>gc_time_format-iso.
              EXIT.
            ENDIF.
          ENDIF.

          IF iv_format = zif_brx_const=>gc_time_format-auto OR iv_format = zif_brx_const=>gc_time_format-internal.
            lo_matcher = create_matcher( iv_pattern = lc_regex-int iv_text = iv_input ).            " Try to parse as Internal
            IF lo_matcher->match( ).
              ls_match = lo_matcher->get_match( ).
              lm_save_submatch lv_input ls_match-submatches ls_timecomp-hour ls_timecomp-minute ls_timecomp-second.

              rv_output = ls_timecomp.
              ev_format = zif_brx_const=>gc_time_format-internal.
              EXIT.
            ENDIF.
          ENDIF.

          EXIT.

        ENDDO.
      CATCH cx_sy_regex cx_sy_matcher.
        ASSERT 0 = 1.
    ENDTRY.

    IF ev_format EQ zif_brx_const=>gc_date_format-unknown.
      RAISE EXCEPTION TYPE zcx_brx_conversion_failed.
    ENDIF.

    IF iv_plausibility_check EQ abap_true AND rv_output IS NOT INITIAL.
      TRY.
          cl_abap_tstmp=>systemtstmp_syst2utc(
            syst_date = '20010101'
            syst_time = rv_output
          ).
        CATCH cx_parameter_invalid_range INTO DATA(lo_invalid_range).
          RAISE EXCEPTION TYPE zcx_brx_out_of_range
            EXPORTING
              previous = lo_invalid_range.
      ENDTRY.
    ENDIF.


  ENDMETHOD.

ENDCLASS.
