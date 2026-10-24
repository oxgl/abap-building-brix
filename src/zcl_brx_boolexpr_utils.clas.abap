"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Boolean expression utils</p>
CLASS zcl_brx_boolexpr_utils DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "! <p class="shorttext synchronized" lang="en">Evaluates a boolean expression against a single value.</p>
    "!
    "! @parameter iv_expression | <p class="shorttext synchronized" lang="en">Boolean expression to evaluate.</p>
    "! @parameter iv_value | <p class="shorttext synchronized" lang="en">Value to evaluate against the boolean expression.</p>
    "! @parameter iv_case_insensitive | <p class="shorttext synchronized" lang="en">Evaluation should be case insensitive.</p>
    "! @parameter rv_result | <p class="shorttext synchronized" lang="en">Result of the evaluation.</p>
    "! @raising zcx_brx_evaluation_failed | <p class="shorttext synchronized" lang="en">Evaluation failed.</p>
    CLASS-METHODS evaluate_boolexpr_value
      IMPORTING
        !iv_expression       TYPE clike
        !iv_value            TYPE clike
        !iv_case_insensitive TYPE abap_bool DEFAULT abap_true
      RETURNING
        VALUE(rv_result)     TYPE abap_bool
      RAISING
        zcx_brx_evaluation_failed.

    "! <p class="shorttext synchronized" lang="en">Evaluates a boolean expression against a table of values.</p>
    "!
    "! @parameter iv_expression | <p class="shorttext synchronized" lang="en">Boolean expression to evaluate.</p>
    "! @parameter it_values | <p class="shorttext synchronized" lang="en">Table of values to evaluate against the boolean expression.</p>
    "! @parameter iv_case_insensitive | <p class="shorttext synchronized" lang="en">Evaluation should be case insensitive.</p>
    "! @parameter rv_result | <p class="shorttext synchronized" lang="en">Result of the evaluation.</p>
    "! @raising zcx_brx_evaluation_failed | <p class="shorttext synchronized" lang="en">Evaluation failed.</p>
    CLASS-METHODS evaluate_boolexpr_table
      IMPORTING
        !iv_expression       TYPE clike
        !it_values           TYPE INDEX TABLE
        !iv_case_insensitive TYPE abap_bool DEFAULT abap_true
      RETURNING
        VALUE(rv_result)     TYPE abap_bool
      RAISING
        zcx_brx_evaluation_failed .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_brx_boolexpr_utils IMPLEMENTATION.
  METHOD evaluate_boolexpr_table.
    DATA(lo_term_eval) = NEW lcl_table_term_eval(
      it_values = it_values
      iv_ci     = iv_case_insensitive ).

    DATA(lo_parser) = zcl_brx_boolexpr_parser=>get_instance( lo_term_eval ).

    RETURN lo_parser->evaluate( iv_expression ).

  ENDMETHOD.

  METHOD evaluate_boolexpr_value.
    TYPES:
      tt_values TYPE STANDARD TABLE OF string WITH EMPTY KEY.

    RETURN evaluate_boolexpr_table(
      iv_expression       = iv_expression
      it_values           = VALUE tt_values( ( iv_value ) )
      iv_case_insensitive = iv_case_insensitive ).

  ENDMETHOD.

ENDCLASS.
