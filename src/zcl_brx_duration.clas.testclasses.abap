*"* use this source file for your ABAP unit test classes
CLASS ltc_brx_duration DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      test_create_seconds         FOR TESTING,
      test_create_minutes         FOR TESTING,
      test_add_components         FOR TESTING,
      test_sub_components         FOR TESTING,
      test_add_with_duration      FOR TESTING,
      test_sub_with_duration      FOR TESTING,
      test_compare_and_equals     FOR TESTING,
      test_sign_values            FOR TESTING,
      test_initial_singleton      FOR TESTING,
      test_infinity_singletons    FOR TESTING,
      test_is_infinite_true       FOR TESTING,
      test_create_bad_unit_raises FOR TESTING.

    METHODS assert_seconds
      IMPORTING
        io_duration TYPE REF TO zif_brx_duration
        iv_expected TYPE zif_brx_duration=>tv_seconds
        iv_msg      TYPE string.
ENDCLASS.

CLASS ltc_brx_duration IMPLEMENTATION.

  METHOD assert_seconds.
    cl_abap_unit_assert=>assert_bound(
      act = io_duration
      msg = |Duration must be bound: { iv_msg }| ).

    cl_abap_unit_assert=>assert_equals(
      act = io_duration->as_seconds( )
      exp = iv_expected
      msg = iv_msg ).
  ENDMETHOD.

  METHOD test_create_seconds.
    TRY.
        DATA(lo_dur) = zcl_brx_duration=>create(
          iv_value = 90
          iv_unit  = zif_brx_const=>gc_unit-second ).

        assert_seconds(
          io_duration = lo_dur
          iv_expected = 90
          iv_msg      = 'create second failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_create_minutes.
    TRY.
        DATA(lo_dur) = zcl_brx_duration=>create(
          iv_value = 2
          iv_unit  = zif_brx_const=>gc_unit-minute ).

        assert_seconds(
          io_duration = lo_dur
          iv_expected = 120
          iv_msg      = 'create minute conversion failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_add_components.
    TRY.
        DATA(lo_base) = zcl_brx_duration=>create( iv_value = 100 ).

        DATA(lo_res) = lo_base->add(
          iv_days    = 1
          iv_hours   = 1
          iv_minutes = 1
          iv_seconds = 1 ).

        " 100 + 86400 + 3600 + 60 + 1 = 90161
        assert_seconds(
          io_duration = lo_res
          iv_expected = 90161
          iv_msg      = 'add components failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception in add: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_sub_components.
    TRY.
        DATA(lo_base) = zcl_brx_duration=>create( iv_value = 100000 ).

        DATA(lo_res) = lo_base->subtract(
          iv_days    = 1
          iv_hours   = 1
          iv_minutes = 1
          iv_seconds = 1 ).

        " 100000 - 86400 - 3600 - 60 - 1 = 9939
        assert_seconds(
          io_duration = lo_res
          iv_expected = 9939
          iv_msg      = 'subtract components failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception in subtract: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_add_with_duration.
    TRY.
        DATA(lo_a) = zcl_brx_duration=>create( iv_value = 10 ).
        DATA(lo_b) = zcl_brx_duration=>create(
          iv_value = 2
          iv_unit  = zif_brx_const=>gc_unit-minute ).

        DATA(lo_res) = lo_a->add( io_duration = lo_b ).

        assert_seconds(
          io_duration = lo_res
          iv_expected = 130
          iv_msg      = 'add duration failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception in add io_duration: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_sub_with_duration.
    TRY.
        DATA(lo_a) = zcl_brx_duration=>create( iv_value = 200 ).
        DATA(lo_b) = zcl_brx_duration=>create( iv_value = 30 ).

        DATA(lo_res) = lo_a->subtract( io_duration = lo_b ).

        assert_seconds(
          io_duration = lo_res
          iv_expected = 170
          iv_msg      = 'subtract duration failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception in subtract io_duration: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_compare_and_equals.
    TRY.
        DATA(lo_a) = zcl_brx_duration=>create( iv_value = 60 ).
        DATA(lo_b) = zcl_brx_duration=>create( iv_value = 60 ).
        DATA(lo_c) = zcl_brx_duration=>create( iv_value = 61 ).

        cl_abap_unit_assert=>assert_equals(
          act = lo_a->compare( lo_b )
          exp = 0
          msg = 'compare equal failed' ).

        cl_abap_unit_assert=>assert_equals(
          act = lo_a->equals( lo_b )
          exp = abap_true
          msg = 'equals true failed' ).

        cl_abap_unit_assert=>assert_equals(
          act = lo_a->compare( lo_c )
          exp = -1
          msg = 'compare less failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception in compare/equals: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_sign_values.
    TRY.
        DATA(lo_pos) = zcl_brx_duration=>create( iv_value = 1 ).
        DATA(lo_neg) = zcl_brx_duration=>create( iv_value = -1 ).
        DATA(lo_ini) = zcl_brx_duration=>initial( ).

        cl_abap_unit_assert=>assert_equals( act = lo_pos->sign( ) exp = 1 msg = 'pos sign failed' ).
        cl_abap_unit_assert=>assert_equals( act = lo_neg->sign( ) exp = -1 msg = 'neg sign failed' ).
        cl_abap_unit_assert=>assert_equals( act = lo_ini->sign( ) exp = 0 msg = 'zero sign failed' ).

      CATCH zcx_brx_invalid_value INTO DATA(lx).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception in sign test: { lx->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_initial_singleton.
    DATA(lo_a) = zcl_brx_duration=>initial( ).
    DATA(lo_b) = zcl_brx_duration=>initial( ).

    cl_abap_unit_assert=>assert_equals(
      act = xsdbool( lo_a EQ lo_b )
      exp = abap_true
      msg = 'initial should be singleton' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_a->is_initial( )
      exp = abap_true
      msg = 'initial flag should be true' ).
  ENDMETHOD.

  METHOD test_infinity_singletons.
    DATA(lo_pos_a) = zcl_brx_duration=>infinity( ).
    DATA(lo_pos_b) = zcl_brx_duration=>infinity( ).
    DATA(lo_neg_a) = zcl_brx_duration=>infinity( iv_negative = abap_true ).
    DATA(lo_neg_b) = zcl_brx_duration=>infinity( iv_negative = abap_true ).

    cl_abap_unit_assert=>assert_equals(
      act = xsdbool( lo_pos_a EQ lo_pos_b )
      exp = abap_true
      msg = 'positive infinity should be singleton' ).

    cl_abap_unit_assert=>assert_equals(
      act = xsdbool( lo_neg_a EQ lo_neg_b )
      exp = abap_true
      msg = 'negative infinity should be singleton' ).
  ENDMETHOD.

  METHOD test_is_infinite_true.
    DATA(lo_inf) = zcl_brx_duration=>infinity( ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_inf->is_infinite( )
      exp = abap_true
      msg = 'infinity should be infinite' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_inf->is_initial( )
      exp = abap_false
      msg = 'infinity should not be initial' ).
  ENDMETHOD.

  METHOD test_create_bad_unit_raises.
    TRY.
        DATA(lo_dur) = zcl_brx_duration=>create(
          iv_value = 1
          iv_unit  = zif_brx_const=>gc_unit-month ).

        cl_abap_unit_assert=>fail(
          msg = 'Expected zcx_brx_invalid_value for invalid unit' ).

      CATCH zcx_brx_invalid_value.
        " expected
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
