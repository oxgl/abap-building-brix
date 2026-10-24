*"* use this source file for your ABAP unit test classes
CLASS ltc_brx_moment DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CONSTANTS:
      c_tz_utc TYPE zif_brx_type=>tv_time_zone VALUE 'UTC'.

    METHODS:
      test_create_as_ts        FOR TESTING,
      test_add_sub_days        FOR TESTING,
      test_start_next_day      FOR TESTING,
      test_end_prev_day        FOR TESTING,
      test_start_next_month    FOR TESTING,
      test_end_prev_month      FOR TESTING,
      test_end_of_bad_unit     FOR TESTING,
      test_start_next_bad_unit FOR TESTING.

    METHODS assert_moment_ts
      IMPORTING
        io_moment TYPE REF TO zif_brx_moment
        iv_exp_ts TYPE zif_brx_type=>tv_timestamp_short
        iv_msg    TYPE string.
ENDCLASS.

CLASS ltc_brx_moment IMPLEMENTATION.

  METHOD assert_moment_ts.
    cl_abap_unit_assert=>assert_bound(
      act = io_moment
      msg = |Moment must be bound: { iv_msg }| ).

    cl_abap_unit_assert=>assert_equals(
      act = io_moment->as_timestamp( )
      exp = iv_exp_ts
      msg = iv_msg ).
  ENDMETHOD.

  METHOD test_create_as_ts.
    TRY.
        DATA(lo_moment) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        assert_moment_ts(
          io_moment = lo_moment
          iv_exp_ts = '20261024120000'
          iv_msg    = 'Create from date/time in UTC failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx_invalid).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception: { lx_invalid->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_add_sub_days.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_plus_2d) = lo_base->add(
          iv_days     = 2
          iv_timezone = c_tz_utc ).

        assert_moment_ts(
          io_moment = lo_plus_2d
          iv_exp_ts = '20261026120000'
          iv_msg    = 'Add 2 days failed' ).

        DATA(lo_minus_1d) = lo_base->subtract(
          iv_days     = 1
          iv_timezone = c_tz_utc ).

        assert_moment_ts(
          io_moment = lo_minus_1d
          iv_exp_ts = '20261023120000'
          iv_msg    = 'Subtract 1 day failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx_invalid).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception in add/subtract: { lx_invalid->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_start_next_day.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_next_day) = lo_base->start_of_next(
          iv_unit     = zif_brx_const=>gc_unit-day
          iv_timezone = c_tz_utc ).

        assert_moment_ts(
          io_moment = lo_next_day
          iv_exp_ts = '20261025000000'
          iv_msg    = 'start_of_next(day) failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx_invalid).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception in start_of_next(day): { lx_invalid->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_end_prev_day.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_prev_day_end) = lo_base->end_of_previous(
          iv_unit     = zif_brx_const=>gc_unit-day
          iv_timezone = c_tz_utc ).

        assert_moment_ts(
          io_moment = lo_prev_day_end
          iv_exp_ts = '20261023235959'
          iv_msg    = 'end_of_previous(day) failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx_invalid).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception in end_of_previous(day): { lx_invalid->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_start_next_month.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_next_month) = lo_base->start_of_next(
          iv_unit     = zif_brx_const=>gc_unit-month
          iv_timezone = c_tz_utc ).

        assert_moment_ts(
          io_moment = lo_next_month
          iv_exp_ts = '20261101000000'
          iv_msg    = 'start_of_next(month) failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx_invalid).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception in start_of_next(month): { lx_invalid->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_end_prev_month.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_prev_month_end) = lo_base->end_of_previous(
          iv_unit     = zif_brx_const=>gc_unit-month
          iv_timezone = c_tz_utc ).

        assert_moment_ts(
          io_moment = lo_prev_month_end
          iv_exp_ts = '20260930235959'
          iv_msg    = 'end_of_previous(month) failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx_invalid).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception in end_of_previous(month): { lx_invalid->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_end_of_bad_unit.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_result) = lo_base->end_of(
          iv_unit     = 'INV'
          iv_timezone = c_tz_utc ).

        cl_abap_unit_assert=>fail(
          msg = 'Expected zcx_brx_invalid_value for end_of with invalid unit' ).

      CATCH zcx_brx_invalid_value.
        " expected
    ENDTRY.
  ENDMETHOD.

  METHOD test_start_next_bad_unit.
    TRY.
        DATA(lo_base) = zcl_brx_moment=>create(
          iv_date     = '20261024'
          iv_time     = '120000'
          iv_timezone = c_tz_utc ).

        DATA(lo_result) = lo_base->start_of_next(
          iv_unit     = 'INV'
          iv_timezone = c_tz_utc ).

        cl_abap_unit_assert=>fail(
          msg = 'Expected zcx_brx_invalid_value for start_of_next with invalid unit' ).

      CATCH zcx_brx_invalid_value.
        " expected
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
