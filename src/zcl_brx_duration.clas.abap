"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Duration implementation</p>
CLASS zcl_brx_duration DEFINITION
  PUBLIC
  FINAL
  CREATE PROTECTED .

  PUBLIC SECTION.

    INTERFACES zif_brx_duration .

    "! <p class="shorttext synchronized" lang="en">Create a new instance of the duration</p>
    "!
    "! <p>Do not use units month and year, because they are not fixed values.
    "! Use days, hours, minutes and seconds instead.</p>
    "!
    "! @parameter iv_value | <p class="shorttext synchronized" lang="en">Duration value</p>
    "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Duration unit</p>
    "! @parameter ro_duration | <p class="shorttext synchronized" lang="en">Instance of the duration</p>
    "! @raising zcx_brx_error | <p class="shorttext synchronized" lang="en">Error creating duration</p>
    CLASS-METHODS create
      IMPORTING
        !iv_value          TYPE numeric OPTIONAL
        !iv_unit           TYPE msehi DEFAULT zif_brx_const=>gc_unit-second
          PREFERRED PARAMETER iv_value
      RETURNING
        VALUE(ro_duration) TYPE REF TO zif_brx_duration
      RAISING
        zcx_brx_error.

  PROTECTED SECTION.
    "! <p class="shorttext synchronized" lang="en">Constructor</p>
    "!
    "! @parameter iv_seconds | <p class="shorttext synchronized" lang="en">Duration in seconds</p>
    METHODS constructor
      IMPORTING
        iv_seconds TYPE numeric.

    DATA:
      "! <p class="shorttext synchronized" lang="en">Duration in seconds</p>
      gv_seconds TYPE zif_brx_duration=>tv_seconds.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_brx_duration IMPLEMENTATION.

  METHOD constructor.
    gv_seconds = iv_seconds.
  ENDMETHOD.


  METHOD create.
    DATA(lv_seconds) = VALUE zif_brx_duration=>tv_seconds( ).
    IF iv_value IS NOT INITIAL.
      CASE iv_unit.
        WHEN zif_brx_const=>gc_unit-day.
          lv_seconds += iv_value * 86400.
        WHEN zif_brx_const=>gc_unit-hour.
          lv_seconds += iv_value * 3600.
        WHEN zif_brx_const=>gc_unit-minute.
          lv_seconds += iv_value * 60.
        WHEN zif_brx_const=>gc_unit-second.
          lv_seconds += iv_value.
        WHEN OTHERS.
          RAISE EXCEPTION TYPE zcx_brx_error.
      ENDCASE.
    ENDIF.

    RETURN NEW zcl_brx_duration( lv_seconds ).
  ENDMETHOD.


  METHOD zif_brx_duration~as_seconds.
    RETURN gv_seconds.
  ENDMETHOD.


  METHOD zif_brx_duration~add.
    DATA(lv_seconds) = gv_seconds.
    IF io_duration IS BOUND.
      lv_seconds += io_duration->as_seconds( ).
    ENDIF.

    lv_seconds += iv_days * 86400 + iv_hours * 3600 + iv_minutes * 60 + iv_seconds.

    RETURN NEW zcl_brx_duration( lv_seconds ).
  ENDMETHOD.


  METHOD zif_brx_duration~subtract.
    DATA(lv_seconds) = gv_seconds.
    IF io_duration IS BOUND.
      lv_seconds -= io_duration->as_seconds( ).
    ENDIF.

    lv_seconds -= iv_days * 86400 + iv_hours * 3600 + iv_minutes * 60 + iv_seconds.

    RETURN NEW zcl_brx_duration( lv_seconds ).
  ENDMETHOD.

ENDCLASS.
