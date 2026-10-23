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
    "! @raising zcx_brx_static_check | <p class="shorttext synchronized" lang="en">Error creating duration</p>
    CLASS-METHODS create
      IMPORTING
        !iv_value          TYPE numeric OPTIONAL
        !iv_unit           TYPE zif_brx_type=>tv_time_unit DEFAULT zif_brx_const=>gc_unit-second
          PREFERRED PARAMETER iv_value
      RETURNING
        VALUE(ro_duration) TYPE REF TO zif_brx_duration
      RAISING
        zcx_brx_static_check.

    "! <p class="shorttext synchronized" lang="en">Get the duration representing initial</p>
    "!
    "! @parameter ro_duration | <p class="shorttext synchronized" lang="en">Instance of the duration representing initial</p>
    CLASS-METHODS initial
      RETURNING
        VALUE(ro_duration) TYPE REF TO zif_brx_duration.

    "! <p class="shorttext synchronized" lang="en">Get the duration representing infinity</p>
    "!
    "! @parameter iv_negative | <p class="shorttext synchronized" lang="en">If true, the duration will be negative</p>
    "! @parameter ro_duration | <p class="shorttext synchronized" lang="en">Instance of the duration representing infinity</p>
    CLASS-METHODS infinity
      IMPORTING
        iv_negative        TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(ro_duration) TYPE REF TO zif_brx_duration.

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

    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Duration constants</p>
      BEGIN OF gc_duration,
        infinity TYPE zif_brx_type=>tv_timestamp_long VALUE '99991231235959.9999999',
        initial  TYPE zif_brx_type=>tv_timestamp_long VALUE '0',
      END OF gc_duration.

    CLASS-DATA:
      " Instance of the duration representing infinity
      go_infinity_positive TYPE REF TO zif_brx_duration,
      go_infinity_negative TYPE REF TO zif_brx_duration,

      " Instance of the duration representing initial
      go_initial           TYPE REF TO zif_brx_duration.



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
          RAISE EXCEPTION TYPE zcx_brx_static_check.
      ENDCASE.
    ENDIF.

    IF lv_seconds GE gc_duration-infinity.
      RETURN infinity( iv_negative = xsdbool( lv_seconds LT 0 ) ).
    ELSEIF lv_seconds EQ gc_duration-initial.
      RETURN initial( ).
    ELSE.
      RETURN NEW zcl_brx_duration( lv_seconds ).
    ENDIF.

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

  METHOD zif_brx_duration~compare.
    IF io_duration IS NOT BOUND.
      RETURN 1.
    ELSE.
      " The return is an integer, but seconds is a floating point number,
      " so a simple subtraction would return 0 if the difference is less than 1 second.
      " To avoid this, we use the SIGN function to return -1, 0, or 1 based on the comparison.
      RETURN sign( zif_brx_duration~as_seconds( ) - io_duration->as_seconds( ) ).
    ENDIF.
  ENDMETHOD.

  METHOD zif_brx_duration~equals.
    RETURN xsdbool( zif_brx_duration~compare( io_duration ) EQ 0 ).
  ENDMETHOD.

  METHOD infinity.
    IF iv_negative EQ abap_true.
      IF go_infinity_negative IS NOT BOUND.
        go_infinity_negative = NEW zcl_brx_duration( - gc_duration-infinity ).
      ENDIF.
      RETURN go_infinity_negative.
    ELSE.
      IF go_infinity_positive IS NOT BOUND.
        go_infinity_positive = NEW zcl_brx_duration( gc_duration-infinity ).
      ENDIF.
      RETURN go_infinity_positive.
    ENDIF.
  ENDMETHOD.

  METHOD initial.
    IF go_initial IS NOT BOUND.
      go_initial = NEW zcl_brx_duration( gc_duration-initial ).
    ENDIF.
    RETURN go_initial.
  ENDMETHOD.

  METHOD zif_brx_duration~is_infinite.
    RETURN xsdbool(
             gv_seconds GE gc_duration-infinity
          OR gv_seconds LE - gc_duration-infinity ).
  ENDMETHOD.

  METHOD zif_brx_duration~is_initial.
    RETURN xsdbool( gv_seconds EQ gc_duration-initial ).
  ENDMETHOD.

  METHOD zif_brx_duration~sign.
    RETURN sign( gv_seconds ).
  ENDMETHOD.

ENDCLASS.
