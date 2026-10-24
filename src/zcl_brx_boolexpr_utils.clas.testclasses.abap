*"* use this source file for your ABAP unit test classes
CLASS ltc_brx_boolexpr_utils DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      test_value_single_match_ci   FOR TESTING,
      test_table_match             FOR TESTING,
      test_table_alt_operators     FOR TESTING,
      test_value_case_sensitive    FOR TESTING,
      test_invalid_parentheses     FOR TESTING,
      test_empty_expression_raises FOR TESTING.
ENDCLASS.

CLASS ltc_brx_boolexpr_utils IMPLEMENTATION.

  METHOD test_value_single_match_ci.
    TRY.
        " Single value, case-insensitive by default
        DATA(lv_match) = zcl_brx_boolexpr_utils=>evaluate_boolexpr_value(
          iv_expression = `(DE | AT) & !HU`
          iv_value      = `de` ).

        cl_abap_unit_assert=>assert_equals(
          act = lv_match
          exp = abap_true
          msg = 'Expected case-insensitive single value match' ).

      CATCH zcx_brx_evaluation_failed INTO DATA(lx_eval).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception: { lx_eval->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_table_match.
    DATA(lt_roles) = VALUE string_table( ( `ADMIN` ) ( `AUDITOR` ) ).

    TRY.
        " Table of values: true if expression is satisfied by the set
        DATA(lv_allowed) = zcl_brx_boolexpr_utils=>evaluate_boolexpr_table(
          iv_expression = `ADMIN & !GUEST`
          it_values     = lt_roles ).

        cl_abap_unit_assert=>assert_equals(
          act = lv_allowed
          exp = abap_true
          msg = 'Expected ADMIN & !GUEST to be true for ADMIN+AUDITOR' ).

      CATCH zcx_brx_evaluation_failed INTO DATA(lx_eval).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception: { lx_eval->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_table_alt_operators.
    DATA(lt_roles) = VALUE string_table( ( `ADMIN` ) ( `AUDITOR` ) ).

    TRY.
        " Alternative operators: ^ as NOT, , as OR
        DATA(lv_alt) = zcl_brx_boolexpr_utils=>evaluate_boolexpr_table(
          iv_expression = `^GUEST & (ADMIN, SUPPORT)`
          it_values     = lt_roles ).

        cl_abap_unit_assert=>assert_equals(
          act = lv_alt
          exp = abap_true
          msg = 'Expected alt operators (^ and ,) to work' ).

      CATCH zcx_brx_evaluation_failed INTO DATA(lx_eval).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception: { lx_eval->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_value_case_sensitive.
    TRY.
        " Explicit case-sensitive evaluation
        DATA(lv_cs) = zcl_brx_boolexpr_utils=>evaluate_boolexpr_value(
          iv_expression       = `abc`
          iv_value            = `ABC`
          iv_case_insensitive = abap_false ).

        cl_abap_unit_assert=>assert_equals(
          act = lv_cs
          exp = abap_false
          msg = 'Expected case-sensitive comparison to fail for abc vs ABC' ).

      CATCH zcx_brx_evaluation_failed INTO DATA(lx_eval).
        cl_abap_unit_assert=>fail(
          msg = |Unexpected exception: { lx_eval->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_invalid_parentheses.
    TRY.
        DATA(lv_dummy) = zcl_brx_boolexpr_utils=>evaluate_boolexpr_value(
          iv_expression = `(A | B`
          iv_value      = `A` ).

        cl_abap_unit_assert=>fail(
          msg = 'Expected zcx_brx_evaluation_failed for invalid parentheses' ).

      CATCH zcx_brx_evaluation_failed.
        " expected
    ENDTRY.
  ENDMETHOD.

  METHOD test_empty_expression_raises.
    TRY.
        DATA(lv_dummy) = zcl_brx_boolexpr_utils=>evaluate_boolexpr_value(
          iv_expression = ``
          iv_value      = `A` ).

        cl_abap_unit_assert=>fail(
          msg = 'Expected zcx_brx_evaluation_failed for empty expression' ).

      CATCH zcx_brx_evaluation_failed.
        " expected
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
