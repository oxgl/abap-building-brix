*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_table_term_eval DEFINITION.
  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
          it_values TYPE INDEX TABLE
          iv_ci     TYPE abap_bool.

    INTERFACES zif_brx_boolexpr_term_eval.

  PRIVATE SECTION.
    DATA:
      gv_ci     TYPE abap_bool,
      gt_values TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

ENDCLASS.

CLASS lcl_table_term_eval IMPLEMENTATION.
  METHOD constructor.
    LOOP AT it_values ASSIGNING FIELD-SYMBOL(<fsv_value>).
      DATA(lv_value) = CONV string( <fsv_value> ).
      IF iv_ci EQ abap_true.
        lv_value = to_upper( lv_value ).
      ENDIF.
      APPEND lv_value TO gt_values.
    ENDLOOP.
    gv_ci    = iv_ci.
  ENDMETHOD.

  METHOD zif_brx_boolexpr_term_eval~evaluate.
    IF gv_ci EQ abap_true.
      DATA(lv_term) = to_upper( iv_term ).
    ELSE.
      lv_term = iv_term.
    ENDIF.

    LOOP AT gt_values ASSIGNING FIELD-SYMBOL(<fsv_value>).
      IF lv_term = <fsv_value>.
        RETURN abap_true.
      ENDIF.
    ENDLOOP.

    RETURN abap_false.
  ENDMETHOD.

ENDCLASS.
