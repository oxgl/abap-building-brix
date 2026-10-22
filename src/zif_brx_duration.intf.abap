"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Duration</p>
INTERFACE zif_brx_duration
  PUBLIC .
  TYPES:
    " <p class="shorttext synchronized" lang="en">Seconds</p>
    tv_seconds TYPE tzntstmpl.

  "! <p class="shorttext synchronized" lang="en">Returns the duration in seconds</p>
  "!
  "! @parameter rv_seconds | <p class="shorttext synchronized" lang="en">Seconds</p>
  METHODS as_seconds
    RETURNING
      VALUE(rv_seconds) TYPE tv_seconds.

  "! <p class="shorttext synchronized" lang="en">Adds a given amount of time to the duration</p>
  "!
  "! @parameter io_duration | <p class="shorttext synchronized" lang="en">Duration to add</p>
  "! @parameter iv_seconds | <p class="shorttext synchronized" lang="en">Seconds to add</p>
  "! @parameter iv_minutes | <p class="shorttext synchronized" lang="en">Minutes to add</p>
  "! @parameter iv_hours | <p class="shorttext synchronized" lang="en">Hours to add</p>
  "! @parameter iv_days | <p class="shorttext synchronized" lang="en">Days to add</p>
  "! @parameter ro_duration | <p class="shorttext synchronized" lang="en">Resulting duration</p>
  "! @raising zcx_brx_error | <p class="shorttext synchronized" lang="en">Exception raised if the addition fails</p>
  METHODS add
    IMPORTING
      !io_duration       TYPE REF TO zif_brx_duration OPTIONAL
      !iv_seconds        TYPE numeric OPTIONAL
      !iv_minutes        TYPE numeric OPTIONAL
      !iv_hours          TYPE numeric OPTIONAL
      !iv_days           TYPE numeric OPTIONAL
        PREFERRED PARAMETER io_duration
    RETURNING
      VALUE(ro_duration) TYPE REF TO zif_brx_duration
    RAISING
      zcx_brx_error.

  "! <p class="shorttext synchronized" lang="en">Subtracts a given amount of time from the duration</p>
  "!
  "! @parameter io_duration | <p class="shorttext synchronized" lang="en">Duration to subtract</p>
  "! @parameter iv_seconds | <p class="shorttext synchronized" lang="en">Seconds to subtract</p>
  "! @parameter iv_minutes | <p class="shorttext synchronized" lang="en">Minutes to subtract</p>
  "! @parameter iv_hours | <p class="shorttext synchronized" lang="en">Hours to subtract</p>
  "! @parameter iv_days | <p class="shorttext synchronized" lang="en">Days to subtract</p>
  "! @parameter ro_duration | <p class="shorttext synchronized" lang="en">Resulting duration</p>
  "! @raising zcx_brx_error | <p class="shorttext synchronized" lang="en">Exception raised if the addition fails</p>
  METHODS subtract
    IMPORTING
      !io_duration       TYPE REF TO zif_brx_duration OPTIONAL
      !iv_seconds        TYPE numeric OPTIONAL
      !iv_minutes        TYPE numeric OPTIONAL
      !iv_hours          TYPE numeric OPTIONAL
      !iv_days           TYPE numeric OPTIONAL
        PREFERRED PARAMETER io_duration
    RETURNING
      VALUE(ro_duration) TYPE REF TO zif_brx_duration
    RAISING
      zcx_brx_error.
ENDINTERFACE.
