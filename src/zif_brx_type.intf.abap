"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Type definitions</p>
INTERFACE zif_brx_type
  PUBLIC .
  TYPES:
    "! <p class="shorttext synchronized" lang="en">Type for the time unit</p>
    tv_time_unit TYPE msehi.

  TYPES:
    "! <p class="shorttext synchronized" lang="en">Type for the time zone</p>
    tv_time_zone TYPE timezone.

  TYPES:
    "! <p class="shorttext synchronized" lang="en">Type for the weekday</p>
    tv_weekday TYPE i.

  TYPES:
    "! <p class="shorttext synchronized" lang="en">Type for the long timestamp</p>
    tv_timestamp_long TYPE timestampl.

  TYPES:
    "! <p class="shorttext synchronized" lang="en">Type for the short timestamp</p>
    tv_timestamp_short TYPE timestamp.


  TYPES:
    "! <p class="shorttext synchronized" lang="en">Type for date format</p>
    tv_date_format TYPE c LENGTH 1 .

  TYPES:
    "! <p class="shorttext synchronized" lang="en">Type for time format</p>
    tv_time_format TYPE c LENGTH 1 .

  TYPES:
    "! <p class="shorttext synchronized" lang="en">Type for timestamp format</p>
    tv_timestamp_format TYPE c LENGTH 1 .

ENDINTERFACE.
