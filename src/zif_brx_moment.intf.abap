"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Moment</p>
INTERFACE zif_brx_moment
  PUBLIC .

  "! <p class="shorttext synchronized" lang="en">Returns the date part of the moment</p>
  "!
  "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone</p>
  "! @parameter rv_date | <p class="shorttext synchronized" lang="en">Date part of the moment</p>
  METHODS as_date
    IMPORTING
      iv_timezone    TYPE zif_brx_type=>tv_time_zone OPTIONAL
    RETURNING
      VALUE(rv_date) TYPE d .

  "! <p class="shorttext synchronized" lang="en">Returns the time part of the moment</p>
  "!
  "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone</p>
  "! @parameter rv_time | <p class="shorttext synchronized" lang="en">Time part of the moment</p>
  METHODS as_time
    IMPORTING
      iv_timezone    TYPE zif_brx_type=>tv_time_zone OPTIONAL
    RETURNING
      VALUE(rv_time) TYPE t .

  "! <p class="shorttext synchronized" lang="en">Returns the timestamp of the moment</p>
  "!
  "! @parameter rv_timestamp | <p class="shorttext synchronized" lang="en">Timestamp of the moment</p>
  METHODS as_timestamp
    RETURNING
      VALUE(rv_timestamp) TYPE zif_brx_type=>tv_timestamp_short.

  "! <p class="shorttext synchronized" lang="en">Returns the timestamp of the moment in local time</p>
  "!
  "! @parameter rv_timestampl | <p class="shorttext synchronized" lang="en">Timestamp of the moment in local time</p>
  METHODS as_timestampl
    RETURNING
      VALUE(rv_timestampl) TYPE zif_brx_type=>tv_timestamp_long .

  "! <p class="shorttext synchronized" lang="en">Returns the weekday of the moment</p>
  "!
  "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone</p>
  "! @parameter rv_weekday | <p class="shorttext synchronized" lang="en">Weekday of the moment</p>
  METHODS as_weekday
    IMPORTING
      iv_timezone       TYPE zif_brx_type=>tv_time_zone OPTIONAL
    RETURNING
      VALUE(rv_weekday) TYPE zif_brx_type=>tv_weekday.

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
  "! @raising zcx_brx_static_check | <p class="shorttext synchronized" lang="en">Exception raised if the calculation fails</p>
  METHODS end_of
    IMPORTING
      iv_unit          TYPE zif_brx_type=>tv_time_unit
      iv_timezone      TYPE zif_brx_type=>tv_time_zone OPTIONAL
    RETURNING
      VALUE(ro_moment) TYPE REF TO zif_brx_moment
    RAISING
      zcx_brx_static_check .

  "! <p class="shorttext synchronized" lang="en">Returns the start of given unit of time</p>
  "!
  "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Unit of time</p>
  "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone</p>
  "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Moment representing the start of given unit of time</p>
  "! @raising zcx_brx_static_check | <p class="shorttext synchronized" lang="en">Exception raised if the calculation fails</p>
  METHODS start_of
    IMPORTING
      iv_unit          TYPE zif_brx_type=>tv_time_unit
      iv_timezone      TYPE zif_brx_type=>tv_time_zone OPTIONAL
    RETURNING
      VALUE(ro_moment) TYPE REF TO zif_brx_moment
    RAISING
      zcx_brx_static_check .

  "! <p class="shorttext synchronized" lang="en">Returns the end of previous unit of time</p>
  "!
  "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Unit of time</p>
  "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone</p>
  "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Moment representing the end of previous unit of time</p>
  "! @raising zcx_brx_static_check | <p class="shorttext synchronized" lang="en">Exception raised if the calculation fails</p>"!
  METHODS end_of_previous
    IMPORTING
      iv_unit          TYPE zif_brx_type=>tv_time_unit
      iv_timezone      TYPE zif_brx_type=>tv_time_zone OPTIONAL
    RETURNING
      VALUE(ro_moment) TYPE REF TO zif_brx_moment
    RAISING
      zcx_brx_static_check .


  "! <p class="shorttext synchronized" lang="en">Returns the start of next unit of time</p>
  "!
  "! @parameter iv_unit | <p class="shorttext synchronized" lang="en">Unit of time</p>
  "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone</p>
  "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Moment representing the start of next unit of time</p>
  "! @raising zcx_brx_static_check | <p class="shorttext synchronized" lang="en">Exception raised if the calculation fails</p>"!"!
  METHODS start_of_next
    IMPORTING
      iv_unit          TYPE zif_brx_type=>tv_time_unit
      iv_timezone      TYPE zif_brx_type=>tv_time_zone OPTIONAL
    RETURNING
      VALUE(ro_moment) TYPE REF TO zif_brx_moment
    RAISING
      zcx_brx_static_check .


  "! <p class="shorttext synchronized" lang="en">Adds a given amount of time to the moment</p>
  "!
  "! <h1>Behavior of exact duration vs calendar units</h1>
  "! <p>If <em>io_duration</em> is supplied, the value represents an exact elapsed time and is added as seconds.
  "! This keeps the precise time difference between two moments.</p>
  "!
  "! If calendar units are supplied (especially <em>iv_months</em> and <em>iv_years</em>), calculation is calendar-based in the given time zone.
  "! Therefore adding one month is not a fixed number of days: it can correspond to 28, 29, 30, or 31 days, depending on the target month.
  "! If the target month has fewer days than the source date, the result is adjusted to the last valid day of that month.
  "!
  "! @parameter io_duration | <p class="shorttext synchronized" lang="en">Duration to add</p>
  "! @parameter iv_years | <p class="shorttext synchronized" lang="en">Years to add</p>
  "! @parameter iv_months | <p class="shorttext synchronized" lang="en">Months to add</p>
  "! @parameter iv_days | <p class="shorttext synchronized" lang="en">Days to add</p>
  "! @parameter iv_hours | <p class="shorttext synchronized" lang="en">Hours to add</p>
  "! @parameter iv_minutes | <p class="shorttext synchronized" lang="en">Minutes to add</p>
  "! @parameter iv_seconds | <p class="shorttext synchronized" lang="en">Seconds to add</p>
  "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone</p>
  "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Moment representing the result of the addition</p>
  "! @raising zcx_brx_static_check | <p class="shorttext synchronized" lang="en">Exception raised if the addition fails</p>
  METHODS add
    IMPORTING
      !io_duration     TYPE REF TO zif_brx_duration OPTIONAL
      !iv_years        TYPE numeric OPTIONAL
      !iv_months       TYPE numeric OPTIONAL
      !iv_days         TYPE numeric OPTIONAL
      !iv_hours        TYPE numeric OPTIONAL
      !iv_minutes      TYPE numeric OPTIONAL
      !iv_seconds      TYPE numeric OPTIONAL
      !iv_timezone     TYPE zif_brx_type=>tv_time_zone OPTIONAL
        PREFERRED PARAMETER io_duration
    RETURNING
      VALUE(ro_moment) TYPE REF TO zif_brx_moment
    RAISING
      zcx_brx_static_check.

  "! <p class="shorttext synchronized" lang="en">Subtracts a given amount of time from the moment</p>
  "!
  "! <h1>Behavior of exact duration vs calendar units</h1>
  "! <p>If <em>io_duration</em> is supplied, the value represents an exact elapsed time and is added as seconds.
  "! This keeps the precise time difference between two moments.</p>
  "!
  "! If calendar units are supplied (especially <em>iv_months</em> and <em>iv_years</em>), calculation is calendar-based in the given time zone.
  "! Therefore subtracting one month is not a fixed number of days: it can correspond to 28, 29, 30, or 31 days, depending on the target month.
  "! If the target month has fewer days than the source date, the result is adjusted to the last valid day of that month.
  "!
  "! @parameter io_duration | <p class="shorttext synchronized" lang="en">Duration to add</p>
  "! @parameter iv_years | <p class="shorttext synchronized" lang="en">Years to add</p>
  "! @parameter iv_months | <p class="shorttext synchronized" lang="en">Months to add</p>
  "! @parameter iv_days | <p class="shorttext synchronized" lang="en">Days to add</p>
  "! @parameter iv_hours | <p class="shorttext synchronized" lang="en">Hours to add</p>
  "! @parameter iv_minutes | <p class="shorttext synchronized" lang="en">Minutes to add</p>
  "! @parameter iv_seconds | <p class="shorttext synchronized" lang="en">Seconds to add</p>
  "! @parameter iv_timezone | <p class="shorttext synchronized" lang="en">Time zone</p>
  "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">Moment representing the result of the addition</p>
  "! @raising zcx_brx_static_check | <p class="shorttext synchronized" lang="en">Exception raised if the addition fails</p>
  METHODS subtract
    IMPORTING
      !io_duration     TYPE REF TO zif_brx_duration OPTIONAL
      !iv_years        TYPE numeric OPTIONAL
      !iv_months       TYPE numeric OPTIONAL
      !iv_days         TYPE numeric OPTIONAL
      !iv_hours        TYPE numeric OPTIONAL
      !iv_minutes      TYPE numeric OPTIONAL
      !iv_seconds      TYPE numeric OPTIONAL
      !iv_timezone     TYPE zif_brx_type=>tv_time_zone OPTIONAL
        PREFERRED PARAMETER io_duration
    RETURNING
      VALUE(ro_moment) TYPE REF TO zif_brx_moment
    RAISING
      zcx_brx_static_check.


  "! <p class="shorttext synchronized" lang="en">Checks if moments are equal</p>
  "!
  "! @parameter io_moment | <p class="shorttext synchronized" lang="en">Moment to compare with</p>
  "! @parameter rv_equals | <p class="shorttext synchronized" lang="en">Returns true if the moments are equal, false otherwise</p>
  METHODS equals
    IMPORTING
      !io_moment       TYPE REF TO zif_brx_moment
    RETURNING
      VALUE(rv_equals) TYPE abap_bool.

  "! <p class="shorttext synchronized" lang="en">Compares the moment with another moment</p>
  "!
  "! <p class="shorttext synchronized" lang="en">Returns:
  "! <li> &lt; 0 if the moment is before the other moment</li>
  "! <li> = 0 if the moments are equal</li>
  "! <li> &gt; 0 if the moment is after the other moment</li>
  "! </p>
  "!
  "! @parameter io_moment | <p class="shorttext synchronized" lang="en">Moment to compare with</p>
  "! @parameter rv_compare | <p class="shorttext synchronized" lang="en">Comparison result</p>
  METHODS compare
    IMPORTING
      !io_moment        TYPE REF TO zif_brx_moment
    RETURNING
      VALUE(rv_compare) TYPE i.
ENDINTERFACE.
