"! <p class="shorttext synchronized" lang="en">ABAP Building Brix:  Conversion error</p>
CLASS zcx_brx_conversion_failed DEFINITION
  PUBLIC
  INHERITING FROM zcx_brx_static_check
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF zcx_brx_conversion_failed,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '040',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF zcx_brx_conversion_failed.

    CONSTANTS:
      BEGIN OF conversion_of_value_failed,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '041',
        attr1 TYPE scx_attrname VALUE 'VALUE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF conversion_of_value_failed.

    CONSTANTS:
      BEGIN OF conversion_to_datatype_failed,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '042',
        attr1 TYPE scx_attrname VALUE 'VALUE',
        attr2 TYPE scx_attrname VALUE 'DATATYPE',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF conversion_to_datatype_failed.

    DATA value TYPE string.
    DATA datatype TYPE string.

    "! <p class="shorttext synchronized" lang="en">CONSTRUCTOR</p>
    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL
        !value    TYPE string OPTIONAL
        !datatype TYPE string OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_brx_conversion_failed IMPLEMENTATION.


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
    me->value = value.
    me->datatype = datatype.
  ENDMETHOD.
ENDCLASS.
