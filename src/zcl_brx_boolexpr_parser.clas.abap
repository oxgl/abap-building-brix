"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Boolean expression parser</p>
CLASS zcl_brx_boolexpr_parser DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_brx_boolexpr_parser .

    "! <p class="shorttext synchronized" lang="en">CONSTRUCTOR</p>
    "!
    "! @parameter io_term_eval | <p class="shorttext synchronized" lang="en">Boolean expression parser term evaluator</p>
    METHODS constructor
      IMPORTING
        !io_term_eval TYPE REF TO zif_brx_boolexpr_term_eval .
    "! <p class="shorttext synchronized" lang="en">Get parser instance</p>
    "!
    "! @parameter io_term_eval | <p class="shorttext synchronized" lang="en">Boolean expression parser term evaluator</p>
    "! @parameter ro_parser    | <p class="shorttext synchronized" lang="en">Parser instance</p>
    CLASS-METHODS get_instance
      IMPORTING
        !io_term_eval    TYPE REF TO zif_brx_boolexpr_term_eval
      RETURNING
        VALUE(ro_parser) TYPE REF TO zif_brx_boolexpr_parser .
  PROTECTED SECTION.

  PRIVATE SECTION.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">String table</p>
      tt_string TYPE STANDARD TABLE OF string WITH DEFAULT KEY .

    DATA:
      "! <p class="shorttext synchronized" lang="en">Term evaluator instance</p>
      go_term_eval TYPE REF TO zif_brx_boolexpr_term_eval .


    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Characters used in boolean expressions</p>
      BEGIN OF gc_char,
        alternatives TYPE string VALUE '^!,|' ##NO_TEXT,
        not          TYPE c LENGTH 1 VALUE '!' ##NO_TEXT,
        and          TYPE c LENGTH 1 VALUE '&' ##NO_TEXT,
        or           TYPE c LENGTH 1 VALUE '|' ##NO_TEXT,
        par_open     TYPE c LENGTH 1 VALUE '(' ##NO_TEXT,
        par_close    TYPE c LENGTH 1 VALUE ')' ##NO_TEXT,
      END OF gc_char .


    "! <p class="shorttext synchronized" lang="en">Split expression at given char (considering parentheses)</p>
    "!
    "! @parameter iv_expression | <p class="shorttext synchronized" lang="en">Expression</p>
    "! @parameter iv_separator  | <p class="shorttext synchronized" lang="en">Separator</p>
    "! @parameter ev_depth      | <p class="shorttext synchronized" lang="en">Depth =&gt; should be 0 if expression is syntactically correct</p>
    "! @parameter et_parts      | <p class="shorttext synchronized" lang="en">String table</p>
    CLASS-METHODS split_expression_at
      IMPORTING
        !iv_expression TYPE csequence
        !iv_separator  TYPE c
      EXPORTING
        !ev_depth      TYPE i
        !et_parts      TYPE tt_string .


    "! <p class="shorttext synchronized" lang="en">Trim needless parentheses</p>
    "!
    "! @parameter cv_expression | <p class="shorttext synchronized" lang="en">Expression after trimming</p>
    "! @parameter ev_found      | <p class="shorttext synchronized" lang="en">Unneded parentheses found</p>
    CLASS-METHODS trim_unneeded_parentheses
      EXPORTING
        ev_found      TYPE abap_bool
      CHANGING
        cv_expression TYPE string.

ENDCLASS.



CLASS zcl_brx_boolexpr_parser IMPLEMENTATION.
  METHOD constructor.
    go_term_eval = io_term_eval.
  ENDMETHOD.

  METHOD zif_brx_boolexpr_parser~evaluate.
    " Supported special chars:
    " ( ) parenthesys
    " &   AND
    " | = OR (alternative char ,)
    " ! = NOT (alternative char ^)

    DATA(lv_expression) = CONV string( iv_expression ).

    CONDENSE lv_expression.

    IF lv_expression IS INITIAL.
      RAISE EXCEPTION TYPE zcx_brx_evaluation_failed
        EXPORTING
          textid = zcx_brx_evaluation_failed=>empty_expression.
    ENDIF.

    "************************************************************************
    " Translate alternative chars:
    " , is same as | (OR)
    " ^ is same as ! (NOT)
    "************************************************************************
    TRANSLATE lv_expression USING gc_char-alternatives.

    "************************************************************************
    " Trim unneeded parenthesys
    "************************************************************************
    trim_unneeded_parentheses(
      CHANGING
        cv_expression = lv_expression ).



    "************************************************************************
    " Special case when whole expression is in NOT
    " e.g.: !(expression&expression)
    "************************************************************************
    IF lv_expression(1) CA gc_char-not.
      DATA(lv_expression_wo_not) = lv_expression+1(*).

      trim_unneeded_parentheses(
        IMPORTING
          ev_found      = DATA(lv_found)
        CHANGING
          cv_expression = lv_expression_wo_not
      ).

      IF lv_found EQ abap_true.
        RETURN xsdbool( zif_brx_boolexpr_parser~evaluate( lv_expression_wo_not ) EQ abap_false ).
      ENDIF.

    ENDIF.



    "************************************************************************
    " Handle OR parts
    "************************************************************************
    split_expression_at(
      EXPORTING
        iv_expression = lv_expression
        iv_separator  = gc_char-or
      IMPORTING
        ev_depth      = DATA(lv_depth)
        et_parts      = DATA(lt_parts) ).

    IF lv_depth NE 0.
      RAISE EXCEPTION TYPE zcx_brx_evaluation_failed
        EXPORTING
          textid = zcx_brx_evaluation_failed=>invalid_parenthesis.
    ENDIF.

    IF lines( lt_parts ) GT 1.
      rv_result = abap_false.
      LOOP AT lt_parts INTO DATA(lv_part).
        rv_result = zif_brx_boolexpr_parser~evaluate( lv_part ).
        IF rv_result NE abap_false.
          EXIT.
        ENDIF.
      ENDLOOP.
      RETURN rv_result.
    ENDIF.


    "************************************************************************
    " Handle AND parts
    "************************************************************************
    split_expression_at(
      EXPORTING
        iv_expression = lv_expression
        iv_separator  = gc_char-and
      IMPORTING
        ev_depth      = lv_depth
        et_parts      = lt_parts ).

    IF lv_depth NE 0.
      RAISE EXCEPTION TYPE zcx_brx_evaluation_failed
        EXPORTING
          textid = zcx_brx_evaluation_failed=>invalid_parenthesis.
    ENDIF.

    IF lines( lt_parts ) GT 1.
      rv_result = abap_true.
      LOOP AT lt_parts INTO lv_part.
        rv_result = zif_brx_boolexpr_parser~evaluate( lv_part ).

        IF rv_result NE abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.
      RETURN rv_result.
    ENDIF.


    "************************************************************************
    " No OR, AND parts anymore => handle NOT
    "************************************************************************
    IF lv_expression(1) CA gc_char-not.
      lv_expression = lv_expression+1(*).

      rv_result = zif_brx_boolexpr_parser~evaluate( lv_expression ).
      rv_result = xsdbool( rv_result EQ abap_false ).
      RETURN.
    ENDIF.



    "************************************************************************
    " No OR, AND and no parenthesys anymore => evaluate part
    "************************************************************************
    rv_result = go_term_eval->evaluate( lv_expression ).

  ENDMETHOD.

  METHOD get_instance.
    ro_parser = NEW zcl_brx_boolexpr_parser( io_term_eval ).
  ENDMETHOD.

  METHOD split_expression_at.
    CLEAR:
      ev_depth,
      et_parts.

    "************************************************************************
    " Speed up things little bit :)
    "************************************************************************
    IF iv_expression NS iv_separator.
      et_parts = VALUE #( ( iv_expression ) ).
      RETURN.
    ENDIF.


    "************************************************************************
    " Walk through the expression
    "************************************************************************
    DATA(lv_part) = ``.

    DO strlen( iv_expression ) TIMES.
      DATA(lv_index) = sy-index - 1.

      DATA(lv_char) = CONV string( iv_expression+lv_index(1) ).

      CASE lv_char.
        WHEN gc_char-par_open.
          ev_depth += 1.
        WHEN gc_char-par_close.
          ev_depth -= 1.
          IF ev_depth LT 0.       " Invalid parentheses => closed without opening
            CLEAR et_parts.
            RETURN.
          ENDIF.
        WHEN iv_separator.
          IF ev_depth IS INITIAL.
            APPEND lv_part TO et_parts.
            CLEAR lv_part.
            CONTINUE. " Do not add separator to next part
          ENDIF.
        WHEN OTHERS.

      ENDCASE.

      lv_part = lv_part && lv_char.
    ENDDO.

    IF ev_depth NE 0.             " Invalid parentheses => opened without closing
      CLEAR et_parts.
      RETURN.
    ENDIF.

    IF lv_part IS NOT INITIAL.
      APPEND lv_part TO et_parts.
    ENDIF.

  ENDMETHOD.

  METHOD trim_unneeded_parentheses.
    CLEAR:
      ev_found.

    DO.
      CONDENSE cv_expression.

      " At least 2 chars needed
      DATA(lv_length) = strlen( cv_expression ).
      IF lv_length LT 2.
        EXIT.
      ENDIF.

      " Format (...)
      IF cv_expression NP |{ gc_char-par_open }*{ gc_char-par_close }|.
        EXIT.
      ENDIF.

      " Find the pair of first opening parenthesys
      DATA(lv_depth) = 0.
      DO lv_length TIMES.
        DATA(lv_offset) = sy-index - 1.
        DATA(lv_curr) = cv_expression+lv_offset(1).

        CASE lv_curr.
          WHEN gc_char-par_open.
            lv_depth += 1.
          WHEN gc_char-par_close.
            lv_depth -= 1.
          WHEN OTHERS.
        ENDCASE.

        IF lv_depth EQ 0.
          EXIT.
        ENDIF.
      ENDDO.

      IF lv_offset EQ lv_length - 1.
        ev_found = abap_true.
        " Remove the first and last char
        lv_length -= 2.
        cv_expression = cv_expression+1(lv_length).
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.
  ENDMETHOD.

ENDCLASS.
