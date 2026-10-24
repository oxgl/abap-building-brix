"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Boolean expression parser</p>
INTERFACE zif_brx_boolexpr_parser
  PUBLIC .

  "! <p class="shorttext synchronized" lang="en">Evalueate a boolean expression</p>
  "!
  "! @parameter iv_expression | <p class="shorttext synchronized" lang="en">The boolean expression to evaluate</p>
  "! @parameter rv_result | <p class="shorttext synchronized" lang="en">The result of the evaluation</p>
  "! @raising zcx_brx_evaluation_failed | <p class="shorttext synchronized" lang="en">Exception raised if the evaluation fails</p>
  METHODS evaluate
    IMPORTING
      !iv_expression   TYPE clike
    RETURNING
      VALUE(rv_result) TYPE abap_bool
    RAISING
      zcx_brx_evaluation_failed.
ENDINTERFACE.
