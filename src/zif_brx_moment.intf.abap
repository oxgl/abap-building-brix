"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Moment</p>
INTERFACE zif_brx_moment
  PUBLIC .

  "! <p class="shorttext synchronized" lang="en">Returns the date part of the moment</p>
  "!
  "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone</p>
  "! @parameter rv_date | <p class="shorttext synchronized" lang="en">Date part of the moment</p>
  METHODS as_date
    IMPORTING
      !iv_timezone   TYPE timezone DEFAULT sy-zonlo
    RETURNING
      VALUE(rv_date) TYPE d .

  "! <p class="shorttext synchronized" lang="en">Returns the time part of the moment</p>
  "!
  "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone</p>
  "! @parameter rv_time | <p class="shorttext synchronized" lang="en">Time part of the moment</p>
  METHODS as_time
    IMPORTING
      !iv_timezone   TYPE timezone DEFAULT sy-zonlo
    RETURNING
      VALUE(rv_time) TYPE t .

  "! <p class="shorttext synchronized" lang="en">Returns the timestamp of the moment</p>
  "!
  "! @parameter rv_timestamp | <p class="shorttext synchronized" lang="en">Timestamp of the moment</p>
  METHODS as_timestamp
    RETURNING
      VALUE(rv_timestamp) TYPE timestamp .

  "! <p class="shorttext synchronized" lang="en">Returns the timestamp of the moment in local time</p>
  "!
  "! @parameter rv_timestampl | <p class="shorttext synchronized" lang="en">Timestamp of the moment in local time</p>
  METHODS as_timestampl
    RETURNING
      VALUE(rv_timestampl) TYPE timestampl .

  "! <p class="shorttext synchronized" lang="en">Returns the weekday of the moment</p>
  "!
  "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone</p>
  "! @parameter rv_weekday | <p class="shorttext synchronized" lang="en">Weekday of the moment</p>
  METHODS as_weekday
    IMPORTING
      !iv_timezone      TYPE timezone DEFAULT sy-zonlo
    RETURNING
      VALUE(rv_weekday) TYPE i.

  "! <p class="shorttext synchronized" lang="en">Returns the ISO 8601 representation of the moment</p>
  "!
  "! @parameter rv_string | <p class="shorttext synchronized" lang="en">ISO 8601 representation of the moment</p>
  METHODS as_string
    RETURNING
      VALUE(rv_string) TYPE string.

  "! <p class="shorttext synchronized" lang="en">Returns the end of given unit of time</p>
  "!
  "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Unit of time</p>
  "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone</p>
  "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Moment representing the end of given unit of time</p>
  "! @raising zcx_brx_error | <p class="shorttext synchronized" lang="en">Exception raised if the calculation fails</p>
  METHODS end_of
    IMPORTING
      !iv_unit         TYPE msehi
      !iv_timezone     TYPE timezone DEFAULT sy-zonlo
    RETURNING
      VALUE(ro_moment) TYPE REF TO zif_brx_moment
    RAISING
      zcx_brx_error .

  "! <p class="shorttext synchronized" lang="en">Returns the start of given unit of time</p>
  "!
  "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Unit of time</p>
  "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone</p>
  "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Moment representing the start of given unit of time</p>
  "! @raising zcx_brx_error | <p class="shorttext synchronized" lang="en">Exception raised if the calculation fails</p>
  METHODS start_of
    IMPORTING
      !iv_unit         TYPE msehi
      !iv_timezone     TYPE timezone DEFAULT sy-zonlo
    RETURNING
      VALUE(ro_moment) TYPE REF TO zif_brx_moment
    RAISING
      zcx_brx_error .

  "! <p class="shorttext synchronized" lang="en">Returns the end of previous unit of time</p>
  "!
  "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Unit of time</p>
  "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone</p>
  "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Moment representing the end of previous unit of time</p>
  "! @raising zcx_brx_error | <p class="shorttext synchronized" lang="en">Exception raised if the calculation fails</p>"!
  METHODS end_of_previous
    IMPORTING
      !iv_unit         TYPE msehi
      !iv_timezone     TYPE timezone DEFAULT sy-zonlo
    RETURNING
      VALUE(ro_moment) TYPE REF TO zif_brx_moment
    RAISING
      zcx_brx_error .


  "! <p class="shorttext synchronized" lang="en">Returns the start of next unit of time</p>
  "!
  "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Unit of time</p>
  "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone</p>
  "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Moment representing the start of next unit of time</p>
  "! @raising zcx_brx_error | <p class="shorttext synchronized" lang="en">Exception raised if the calculation fails</p>"!"!
  METHODS start_of_next
    IMPORTING
      !iv_unit         TYPE msehi
      !iv_timezone     TYPE timezone DEFAULT sy-zonlo
    RETURNING
      VALUE(ro_moment) TYPE REF TO zif_brx_moment
    RAISING
      zcx_brx_error .


  "! <p class="shorttext synchronized" lang="en">Adds a given amount of time to the moment</p>
  "!
  "! @parameter iv_value | <p class="shorttext synchronized" lang="en">Amount of time to add (used with iv_unit)</p>
  "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Unit of time to add (used with iv_value)</p>
  "! @parameter iv_seconds | <p class="shorttext synchronized" lang="en">Seconds to add</p>
  "! @parameter iv_minutes | <p class="shorttext synchronized" lang="en">Minutes to add</p>
  "! @parameter iv_hours | <p class="shorttext synchronized" lang="en">Hours to add</p>
  "! @parameter iv_days | <p class="shorttext synchronized" lang="en">Days to add</p>
  "! @parameter iv_months | <p class="shorttext synchronized" lang="en">Months to add</p>
  "! @parameter iv_years | <p class="shorttext synchronized" lang="en">Years to add</p>
  "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone</p>
  "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Moment representing the result of the addition</p>
  "! @raising zcx_brx_error | <p class="shorttext synchronized" lang="en">Exception raised if the addition fails</p>
  METHODS add
    IMPORTING
      !iv_value        TYPE numeric OPTIONAL
      !iv_unit         TYPE msehi OPTIONAL
      !iv_seconds      TYPE numeric OPTIONAL
      !iv_minutes      TYPE numeric OPTIONAL
      !iv_hours        TYPE numeric OPTIONAL
      !iv_days         TYPE numeric OPTIONAL
      !iv_months       TYPE numeric OPTIONAL
      !iv_years        TYPE numeric OPTIONAL
      !iv_timezone     TYPE timezone DEFAULT sy-zonlo
    RETURNING
      VALUE(ro_moment) TYPE REF TO zif_brx_moment
    RAISING
      zcx_brx_error.
ENDINTERFACE.
