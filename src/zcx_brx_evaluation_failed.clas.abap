"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Exception class for evaluation failures</p>
CLASS zcx_brx_evaluation_failed DEFINITION
  PUBLIC
  INHERITING FROM zcx_brx_static_check
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF zcx_brx_evaluation_failed,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '060',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF zcx_brx_evaluation_failed.

    CONSTANTS:
      BEGIN OF empty_expression,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '061',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF empty_expression.

    CONSTANTS:
      BEGIN OF invalid_expression,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '062',
        attr1 TYPE scx_attrname VALUE 'EXPRESSION',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_expression.

    CONSTANTS:
      BEGIN OF invalid_token,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '063',
        attr1 TYPE scx_attrname VALUE 'TOKEN',
        attr2 TYPE scx_attrname VALUE 'POSITION',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_token.

    CONSTANTS:
      BEGIN OF invalid_parenthesis,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '064',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_parenthesis.


    DATA expression TYPE string.
    DATA token TYPE string.
    DATA position TYPE i.

    "! <p class="shorttext synchronized" lang="en">CONSTRUCTOR</p>
    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_brx_evaluation_failed IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
