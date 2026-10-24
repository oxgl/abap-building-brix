*"* use this source file for your ABAP unit test classes
*"* use this source file for your ABAP unit test classes
CLASS ltc_brx_conversion DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      test_date_parse_eur     FOR TESTING,
      test_date_parse_iso     FOR TESTING,
      test_date_parse_int     FOR TESTING,
      test_date_parse_auto    FOR TESTING,
      test_time_parse_iso     FOR TESTING,
      test_time_parse_int     FOR TESTING,
      test_ts_parse_raw       FOR TESTING,
      test_ts_parse_iso_utc   FOR TESTING,
      test_ts_parse_text_dt   FOR TESTING,
      test_bad_date_conv_fail FOR TESTING,
      test_bad_time_conv_fail FOR TESTING,
      test_bad_ts_conv_fail   FOR TESTING,
      test_bad_date_range_err FOR TESTING.
ENDCLASS.

CLASS ltc_brx_conversion IMPLEMENTATION.

  METHOD test_date_parse_eur.
    TRY.
        DATA(lv_fmt) = VALUE zif_brx_type=>tv_date_format( ).
        zcl_brx_conversion=>parse_date(
          EXPORTING
            iv_input  = `25.12.2021`
            iv_format = zif_brx_const=>gc_date_format-eur
          IMPORTING
            ev_format = lv_fmt
          RECEIVING
            rv_output = DATA(lv_date) ).

        cl_abap_unit_assert=>assert_equals( act = lv_date exp = '20211225' msg = 'EUR date parse failed' ).
        cl_abap_unit_assert=>assert_equals( act = lv_fmt exp = zif_brx_const=>gc_date_format-eur msg = 'EUR format detect failed' ).

      CATCH zcx_brx_static_check INTO DATA(lx).
        cl_abap_unit_assert=>fail( msg = |Unexpected exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_date_parse_iso.
    TRY.
        zcl_brx_conversion=>parse_date(
          EXPORTING
            iv_input  = `2021-12-25`
            iv_format = zif_brx_const=>gc_date_format-iso
          RECEIVING
            rv_output = DATA(lv_date) ).

        cl_abap_unit_assert=>assert_equals( act = lv_date exp = '20211225' msg = 'ISO date parse failed' ).

      CATCH zcx_brx_static_check INTO DATA(lx).
        cl_abap_unit_assert=>fail( msg = |Unexpected exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_date_parse_int.
    TRY.
        zcl_brx_conversion=>parse_date(
          EXPORTING
            iv_input  = `20211225`
            iv_format = zif_brx_const=>gc_date_format-internal
          RECEIVING
            rv_output = DATA(lv_date) ).

        cl_abap_unit_assert=>assert_equals( act = lv_date exp = '20211225' msg = 'INT date parse failed' ).

      CATCH zcx_brx_static_check INTO DATA(lx).
        cl_abap_unit_assert=>fail( msg = |Unexpected exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_date_parse_auto.
    TRY.
        DATA(lv_fmt) = VALUE zif_brx_type=>tv_date_format( ).
        zcl_brx_conversion=>parse_date(
          EXPORTING
            iv_input  = `12/25/2021`
          IMPORTING
            ev_format = lv_fmt
          RECEIVING
            rv_output = DATA(lv_date) ).

        cl_abap_unit_assert=>assert_equals( act = lv_date exp = '20211225' msg = 'AUTO date parse failed' ).
        cl_abap_unit_assert=>assert_equals( act = lv_fmt exp = zif_brx_const=>gc_date_format-usa msg = 'AUTO date format failed' ).

      CATCH zcx_brx_static_check INTO DATA(lx).
        cl_abap_unit_assert=>fail( msg = |Unexpected exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_time_parse_iso.
    TRY.
        zcl_brx_conversion=>parse_time(
          EXPORTING
            iv_input  = `14:30:59`
            iv_format = zif_brx_const=>gc_time_format-iso
          RECEIVING
            rv_output = DATA(lv_time) ).

        cl_abap_unit_assert=>assert_equals( act = lv_time exp = '143059' msg = 'ISO time parse failed' ).

      CATCH zcx_brx_static_check INTO DATA(lx).
        cl_abap_unit_assert=>fail( msg = |Unexpected exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_time_parse_int.
    TRY.
        zcl_brx_conversion=>parse_time(
          EXPORTING
            iv_input  = `143059`
            iv_format = zif_brx_const=>gc_time_format-internal
          RECEIVING
            rv_output = DATA(lv_time) ).

        cl_abap_unit_assert=>assert_equals( act = lv_time exp = '143059' msg = 'INT time parse failed' ).

      CATCH zcx_brx_static_check INTO DATA(lx).
        cl_abap_unit_assert=>fail( msg = |Unexpected exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_ts_parse_raw.
    TRY.
        DATA(lv_fmt) = VALUE zif_brx_type=>tv_timestamp_format( ).
        zcl_brx_conversion=>parse_timestamp(
          EXPORTING
            iv_input  = `20211225143059`
            iv_format = zif_brx_const=>gc_timestamp_format-raw
          IMPORTING
            ev_format = lv_fmt
          RECEIVING
            rv_output = DATA(lv_ts) ).

        cl_abap_unit_assert=>assert_equals( act = floor( lv_ts ) exp = '20211225143059' msg = 'RAW ts parse failed' ).
        cl_abap_unit_assert=>assert_equals( act = lv_fmt exp = zif_brx_const=>gc_timestamp_format-raw msg = 'RAW ts format failed' ).

      CATCH zcx_brx_static_check INTO DATA(lx).
        cl_abap_unit_assert=>fail( msg = |Unexpected exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_ts_parse_iso_utc.
    TRY.
        DATA(lv_fmt) = VALUE zif_brx_type=>tv_timestamp_format( ).
        zcl_brx_conversion=>parse_timestamp(
          EXPORTING
            iv_input  = `2021-12-25T14:30:59Z`
            iv_format = zif_brx_const=>gc_timestamp_format-iso_utc
          IMPORTING
            ev_format = lv_fmt
          RECEIVING
            rv_output = DATA(lv_ts) ).

        cl_abap_unit_assert=>assert_not_initial( act = lv_ts msg = 'ISO UTC ts parse produced initial' ).
        cl_abap_unit_assert=>assert_equals( act = lv_fmt exp = zif_brx_const=>gc_timestamp_format-iso_utc msg = 'ISO UTC format failed' ).

      CATCH zcx_brx_static_check INTO DATA(lx).
        cl_abap_unit_assert=>fail( msg = |Unexpected exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_ts_parse_text_dt.
    TRY.
        DATA(lv_fmt) = VALUE zif_brx_type=>tv_timestamp_format( ).
        zcl_brx_conversion=>parse_timestamp(
          EXPORTING
            iv_input  = `2021-12-25 14:30:59`
            iv_format = zif_brx_const=>gc_timestamp_format-text
          IMPORTING
            ev_format = lv_fmt
          RECEIVING
            rv_output = DATA(lv_ts) ).

        cl_abap_unit_assert=>assert_not_initial( act = lv_ts msg = 'TEXT ts parse produced initial' ).
        cl_abap_unit_assert=>assert_equals( act = lv_fmt exp = zif_brx_const=>gc_timestamp_format-text msg = 'TEXT ts format failed' ).

      CATCH zcx_brx_static_check INTO DATA(lx).
        cl_abap_unit_assert=>fail( msg = |Unexpected exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_bad_date_conv_fail.
    TRY.
        zcl_brx_conversion=>parse_date(
          EXPORTING
            iv_input  = `abc`
            iv_format = zif_brx_const=>gc_date_format-auto
          RECEIVING
            rv_output = DATA(lv_date) ).

        cl_abap_unit_assert=>fail(
          msg = 'Expected zcx_brx_conversion_failed for invalid date text' ).

      CATCH zcx_brx_conversion_failed.
        " expected
      CATCH zcx_brx_invalid_value INTO DATA(lx_inv).
        cl_abap_unit_assert=>fail(
          msg = |Expected conversion_failed, got invalid_value: { lx_inv->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_bad_time_conv_fail.
    TRY.
        zcl_brx_conversion=>parse_time(
          EXPORTING
            iv_input  = `xx:yy:zz`
            iv_format = zif_brx_const=>gc_time_format-auto
          RECEIVING
            rv_output = DATA(lv_time) ).

        cl_abap_unit_assert=>fail(
          msg = 'Expected zcx_brx_conversion_failed for invalid time text' ).

      CATCH zcx_brx_conversion_failed.
        " expected
      CATCH zcx_brx_invalid_value INTO DATA(lx_inv).
        cl_abap_unit_assert=>fail(
          msg = |Expected conversion_failed, got invalid_value: { lx_inv->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_bad_ts_conv_fail.
    TRY.
        zcl_brx_conversion=>parse_timestamp(
          EXPORTING
            iv_input  = `not-a-timestamp`
            iv_format = zif_brx_const=>gc_timestamp_format-auto
          RECEIVING
            rv_output = DATA(lv_ts) ).

        cl_abap_unit_assert=>fail(
          msg = 'Expected zcx_brx_conversion_failed for invalid timestamp text' ).

      CATCH zcx_brx_conversion_failed.
        " expected
      CATCH zcx_brx_invalid_value INTO DATA(lx_inv).
        cl_abap_unit_assert=>fail(
          msg = |Expected conversion_failed, got invalid_value: { lx_inv->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_bad_date_range_err.
    TRY.
        zcl_brx_conversion=>parse_date(
          EXPORTING
            iv_input              = `31.02.2021`
            iv_format             = zif_brx_const=>gc_date_format-eur
            iv_plausibility_check = abap_true
          RECEIVING
            rv_output = DATA(lv_date) ).

        cl_abap_unit_assert=>fail(
          msg = 'Expected zcx_brx_invalid_value for implausible date' ).

      CATCH zcx_brx_invalid_value.
        " expected
      CATCH zcx_brx_conversion_failed INTO DATA(lx_conv).
        cl_abap_unit_assert=>fail(
          msg = |Expected invalid_value, got conversion_failed: { lx_conv->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
