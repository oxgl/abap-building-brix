"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Exception class for invalid values</p>
CLASS zcx_brx_invalid_value DEFINITION
  PUBLIC
  INHERITING FROM zcx_brx_static_check
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF zcx_brx_invalid_value,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '020',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF zcx_brx_invalid_value.

    CONSTANTS:
      BEGIN OF invalid_value,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '021',
        attr1 TYPE scx_attrname VALUE 'VALUE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_value.

    CONSTANTS:
      BEGIN OF invalid_datatype_value,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '022',
        attr1 TYPE scx_attrname VALUE 'VALUE',
        attr2 TYPE scx_attrname VALUE 'DATATYPE',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_datatype_value.

    CONSTANTS:
      BEGIN OF invalid_parameter_value,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '023',
        attr1 TYPE scx_attrname VALUE 'PARAMNAME',
        attr2 TYPE scx_attrname VALUE 'VALUE',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_parameter_value.

    CONSTANTS:
      BEGIN OF value_out_of_range,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '025',
        attr1 TYPE scx_attrname VALUE 'VALUE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF value_out_of_range.

    CONSTANTS:
      BEGIN OF datatype_out_of_range,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '026',
        attr1 TYPE scx_attrname VALUE 'VALUE',
        attr2 TYPE scx_attrname VALUE 'DATATYPE',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF datatype_out_of_range.

    CONSTANTS:
      BEGIN OF parameter_out_of_range,
        msgid TYPE symsgid VALUE 'ZBRX',
        msgno TYPE symsgno VALUE '027',
        attr1 TYPE scx_attrname VALUE 'VALUE',
        attr2 TYPE scx_attrname VALUE 'PARAMNAME',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF parameter_out_of_range.


    DATA value TYPE string.
    DATA datatype TYPE string.
    DATA paramname TYPE string.

    "! <p class="shorttext synchronized" lang="en">CONSTRUCTOR</p>
    METHODS constructor
      IMPORTING
        !textid    LIKE if_t100_message=>t100key OPTIONAL
        !previous  LIKE previous OPTIONAL
        !value     TYPE string OPTIONAL
        !datatype  TYPE string OPTIONAL
        !paramname TYPE string OPTIONAL.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_brx_invalid_value IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = zcx_brx_invalid_value.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
    me->value = value.
    me->datatype = datatype.
    me->paramname = paramname.
  ENDMETHOD.
ENDCLASS.
