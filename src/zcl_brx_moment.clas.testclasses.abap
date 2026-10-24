*"* use this source file for your ABAP unit test classes
*"* use this source file for your ABAP unit test classes
CLASS ltc_brx_moment DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CONSTANTS c_tz_utc TYPE zif_brx_type=>tv_time_zone VALUE 'UTC'.

    METHODS:
      test_add_days          FOR TESTING,
      test_sub_days          FOR TESTING,
      test_current_day       FOR TESTING,
      test_next_day          FOR TESTING,
      test_prev_day          FOR TESTING,
      test_current_month     FOR TESTING,
      test_next_month        FOR TESTING,
      test_prev_month        FOR TESTING,
      test_bad_unit_current  FOR TESTING,
      test_bad_unit_next     FOR TESTING,
      test_bad_unit_prev     FOR TESTING,
      test_add_day_dst_gap   FOR TESTING,
      test_sub_month_dst_gap FOR TESTING.


    METHODS assert_ts
      IMPORTING
        io_moment TYPE REF TO zif_brx_moment
        iv_exp_ts TYPE zif_brx_type=>tv_timestamp_short
        iv_msg    TYPE string.
ENDCLASS.

CLASS ltc_brx_moment IMPLEMENTATION.

  METHOD assert_ts.
    cl_abap_unit_assert=>assert_bound(
      act = io_moment
      msg = |Moment not bound: { iv_msg }| ).

    cl_abap_unit_assert=>assert_equals(
      act = io_moment->as_timestamp( )
      exp = iv_exp_ts
      msg = iv_msg ).
  ENDMETHOD.

  METHOD test_add_days.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_res) = lo_base->add(
          iv_days     = 2
          iv_timezone = c_tz_utc ).

        assert_ts(
          io_moment = lo_res
          iv_exp_ts = '20261026120000'
          iv_msg    = 'add 2 days failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected add exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_sub_days.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_res) = lo_base->subtract(
          iv_days     = 1
          iv_timezone = c_tz_utc ).

        assert_ts(
          io_moment = lo_res
          iv_exp_ts = '20261023120000'
          iv_msg    = 'subtract 1 day failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected subtract exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_current_day.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_int) = lo_base->current(
          iv_unit     = zif_brx_const=>gc_time_unit-day
          iv_timezone = c_tz_utc ).

        assert_ts(
          io_moment = lo_int->start( )
          iv_exp_ts = '20261024000000'
          iv_msg    = 'current(day) start failed' ).

        assert_ts(
          io_moment = lo_int->end( )
          iv_exp_ts = '20261024235959'
          iv_msg    = 'current(day) end failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected current(day) exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_next_day.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_int) = lo_base->next(
          iv_unit     = zif_brx_const=>gc_time_unit-day
          iv_timezone = c_tz_utc ).

        assert_ts(
          io_moment = lo_int->start( )
          iv_exp_ts = '20261025000000'
          iv_msg    = 'next(day) start failed' ).

        assert_ts(
          io_moment = lo_int->end( )
          iv_exp_ts = '20261025235959'
          iv_msg    = 'next(day) end failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected next(day) exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_prev_day.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_int) = lo_base->previous(
          iv_unit     = zif_brx_const=>gc_time_unit-day
          iv_timezone = c_tz_utc ).

        assert_ts(
          io_moment = lo_int->start( )
          iv_exp_ts = '20261023000000'
          iv_msg    = 'previous(day) start failed' ).

        assert_ts(
          io_moment = lo_int->end( )
          iv_exp_ts = '20261023235959'
          iv_msg    = 'previous(day) end failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected previous(day) exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_current_month.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_int) = lo_base->current(
          iv_unit     = zif_brx_const=>gc_time_unit-month
          iv_timezone = c_tz_utc ).

        assert_ts(
          io_moment = lo_int->start( )
          iv_exp_ts = '20261001000000'
          iv_msg    = 'current(month) start failed' ).

        assert_ts(
          io_moment = lo_int->end( )
          iv_exp_ts = '20261031235959'
          iv_msg    = 'current(month) end failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected current(month) exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_next_month.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_int) = lo_base->next(
          iv_unit     = zif_brx_const=>gc_time_unit-month
          iv_timezone = c_tz_utc ).

        assert_ts(
          io_moment = lo_int->start( )
          iv_exp_ts = '20261101000000'
          iv_msg    = 'next(month) start failed' ).

        assert_ts(
          io_moment = lo_int->end( )
          iv_exp_ts = '20261130235959'
          iv_msg    = 'next(month) end failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected next(month) exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_prev_month.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_int) = lo_base->previous(
          iv_unit     = zif_brx_const=>gc_time_unit-month
          iv_timezone = c_tz_utc ).

        assert_ts(
          io_moment = lo_int->start( )
          iv_exp_ts = '20260901000000'
          iv_msg    = 'previous(month) start failed' ).

        assert_ts(
          io_moment = lo_int->end( )
          iv_exp_ts = '20260930235959'
          iv_msg    = 'previous(month) end failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected previous(month) exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_bad_unit_current.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_int) = lo_base->current(
          iv_unit     = 'BAD'
          iv_timezone = c_tz_utc ).

        cl_abap_unit_assert=>fail(
          msg = 'Expected zcx_brx_invalid_value in current(BAD)' ).

      CATCH zcx_brx_invalid_value.
        " expected
    ENDTRY.
  ENDMETHOD.

  METHOD test_bad_unit_next.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_int) = lo_base->next(
          iv_unit     = 'BAD'
          iv_timezone = c_tz_utc ).

        cl_abap_unit_assert=>fail(
          msg = 'Expected zcx_brx_invalid_value in next(BAD)' ).

      CATCH zcx_brx_invalid_value.
        " expected
    ENDTRY.
  ENDMETHOD.

  METHOD test_bad_unit_prev.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_int) = lo_base->previous(
          iv_unit     = 'BAD'
          iv_timezone = c_tz_utc ).

        cl_abap_unit_assert=>fail(
          msg = 'Expected zcx_brx_invalid_value in previous(BAD)' ).

      CATCH zcx_brx_invalid_value.
        " expected
    ENDTRY.
  ENDMETHOD.

  METHOD test_add_day_dst_gap.
    " Europe/Berlin: 2026-03-29 02:00-02:59 local time does not exist
    " 2026-03-28 02:30 + 1 day should normalize to a valid local time (typically 03:30)
    TRY.
        CONSTANTS c_tz_cet TYPE zif_brx_type=>tv_time_zone VALUE 'CET'.

        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20260328'
          iv_time     = '023000'
          iv_timezone = c_tz_cet ).

        DATA(lo_res) = lo_base->add(
          iv_days     = 1
          iv_timezone = c_tz_cet ).

        DATA(lv_res_date) = lo_res->as_date( c_tz_cet ).
        DATA(lv_res_time) = lo_res->as_time( c_tz_cet ).

        cl_abap_unit_assert=>assert_equals(
          act = lv_res_date
          exp = '20260329'
          msg = 'DST day add should keep target date' ).

        " Expected normalized local time for this case
        cl_abap_unit_assert=>assert_equals(
          act = lv_res_time
          exp = '033000'
          msg = 'DST gap normalization expected 03:30 local time' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception in DST add test: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.


  METHOD test_sub_month_dst_gap.
    " Europe/Berlin: 2026-03-29 02:00-02:59 local time does not exist
    " Start from 2026-04-29 02:30 and subtract 1 month -> target local 2026-03-29 02:30 (missing)
    " Expected normalization to valid local time (typically 03:30)
    TRY.
        CONSTANTS c_tz_cet TYPE zif_brx_type=>tv_time_zone VALUE 'CET'.

        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20260429'
          iv_time     = '023000'
          iv_timezone = c_tz_cet ).

        DATA(lo_res) = lo_base->subtract(
          iv_months   = 1
          iv_timezone = c_tz_cet ).

        DATA(lv_res_date) = lo_res->as_date( c_tz_cet ).
        DATA(lv_res_time) = lo_res->as_time( c_tz_cet ).

        cl_abap_unit_assert=>assert_equals(
          act = lv_res_date
          exp = '20260329'
          msg = 'Subtract month should keep target date' ).

        cl_abap_unit_assert=>assert_equals(
          act = lv_res_time
          exp = '033000'
          msg = 'DST gap normalization expected 03:30 local time' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception in DST month subtract test: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.


ENDCLASS.
