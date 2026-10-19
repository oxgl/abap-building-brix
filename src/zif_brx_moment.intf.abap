"! <p class="shorttext synchronized" lang="en">ABAP Building Components: Moment</p>
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
  "! @parameter rv_weekday | <p class="shorttext synchronized" lang="en">Weekday of the moment</p>
  METHODS as_weekday
    RETURNING
      VALUE(rv_weekday) TYPE i.

  "! <p class="shorttext synchronized" lang="en">Returns the end of given unit of time</p>
  "!
  "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Unit of time</p>
  "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Moment representing the end of given unit of time</p>
  METHODS end_of_current
    IMPORTING
      !iv_unit         TYPE msehi
      !iv_timezone     TYPE timezone DEFAULT sy-zonlo
    RETURNING
      VALUE(ro_moment) TYPE REF TO zif_brx_moment .

  "! <p class="shorttext synchronized" lang="en">Returns the start of given unit of time</p>
  "!
  "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Unit of time</p>
  "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Moment representing the start of given unit of time</p>
  METHODS start_of_current
    IMPORTING
      !iv_unit         TYPE msehi
      !iv_timezone     TYPE timezone DEFAULT sy-zonlo
    RETURNING
      VALUE(ro_moment) TYPE REF TO zif_brx_moment .
ENDINTERFACE.
