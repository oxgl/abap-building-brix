"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Static Check Exception</p>
CLASS zcx_brx_static_check DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Error occurred.</p>
      BEGIN OF zcx_brx_static_check,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF zcx_brx_static_check .
    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Internal error.</p>
      BEGIN OF internal_error,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '011',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF internal_error .
    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Internal error in method.</p>
      BEGIN OF internal_error_in_method,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '012',
        attr1 TYPE scx_attrname VALUE 'CLASSNAME',
        attr2 TYPE scx_attrname VALUE 'METHODNAME',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF internal_error_in_method .

    DATA classname TYPE string .
    DATA methodname TYPE string.

    "! <p class="shorttext synchronized" lang="en">CONSTRUCTOR</p>
    METHODS constructor
      IMPORTING
        !textid     LIKE if_t100_message=>t100key OPTIONAL
        !previous   LIKE previous OPTIONAL
        !classname  TYPE clike OPTIONAL
        !methodname TYPE clike OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_brx_static_check IMPLEMENTATION.


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
    me->classname = classname.
    me->methodname = methodname.
  ENDMETHOD.
ENDCLASS.
