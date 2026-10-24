"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Boolean expression parser term evaluator</p>
INTERFACE zif_brx_boolexpr_term_eval
  PUBLIC .
  "! <p class="shorttext synchronized" lang="en">Evaluates a single term of a boolean expression.</p>
  "!
  "! @parameter iv_term | <p class="shorttext synchronized" lang="en">The term to evaluate.</p>
  "! @parameter rv_result | <p class="shorttext synchronized" lang="en">The result of the evaluation.</p>
  "! @raising zcx_brx_evaluation_failed | <p class="shorttext synchronized" lang="en">Raised if the evaluation of the term fails.</p>
  METHODS evaluate
    IMPORTING
      !iv_term         TYPE clike
    RETURNING
      VALUE(rv_result) TYPE abap_bool
    RAISING
      zcx_brx_evaluation_failed.
ENDINTERFACE.
