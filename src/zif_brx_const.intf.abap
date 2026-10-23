"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Constants</p>
INTERFACE zif_brx_const
  PUBLIC .


  CONSTANTS:
    "! <p class="shorttext synchronized" lang="en">Unit of measure</p>
    BEGIN OF gc_unit,
      year   TYPE zif_brx_type=>tv_time_unit VALUE 'JHR',
      month  TYPE zif_brx_type=>tv_time_unit VALUE 'MON',
      week   TYPE zif_brx_type=>tv_time_unit VALUE 'WCH',
      day    TYPE zif_brx_type=>tv_time_unit VALUE 'TAG',
      hour   TYPE zif_brx_type=>tv_time_unit VALUE 'STD',
      minute TYPE zif_brx_type=>tv_time_unit VALUE 'MIN',
      second TYPE zif_brx_type=>tv_time_unit VALUE 'S',
    END OF gc_unit .

  CONSTANTS:
    "! <p class="shorttext synchronized" lang="en">Weekday</p>
    BEGIN OF gc_weekday,
      monday    TYPE zif_brx_type=>tv_weekday VALUE 0,
      tuesday   TYPE zif_brx_type=>tv_weekday VALUE 1,
      wednesday TYPE zif_brx_type=>tv_weekday VALUE 2,
      thursday  TYPE zif_brx_type=>tv_weekday VALUE 3,
      friday    TYPE zif_brx_type=>tv_weekday VALUE 4,
      saturday  TYPE zif_brx_type=>tv_weekday VALUE 5,
      sunday    TYPE zif_brx_type=>tv_weekday VALUE 6,
    END OF gc_weekday .

  CONSTANTS:
    "! <p class="shorttext synchronized" lang="en">Date format</p>
    BEGIN OF gc_date_format,
      auto     TYPE zif_brx_type=>tv_date_format VALUE ' ',
      eur      TYPE zif_brx_type=>tv_date_format VALUE 'E',
      internal TYPE zif_brx_type=>tv_date_format VALUE 'D',
      iso      TYPE zif_brx_type=>tv_date_format VALUE 'I',
      unknown  TYPE zif_brx_type=>tv_date_format VALUE ' ',
      usa      TYPE zif_brx_type=>tv_date_format VALUE 'U',
    END OF gc_date_format .

  CONSTANTS:
    "! <p class="shorttext synchronized" lang="en">Time format</p>
    BEGIN OF gc_time_format,
      auto     TYPE zif_brx_type=>tv_time_format VALUE ' ',
      eur      TYPE zif_brx_type=>tv_time_format VALUE 'E',
      internal TYPE zif_brx_type=>tv_time_format VALUE 'T',
      iso      TYPE zif_brx_type=>tv_time_format VALUE 'I',
      unknown  TYPE zif_brx_type=>tv_time_format VALUE ' ',
    END OF gc_time_format .

  CONSTANTS:
    "! <p class="shorttext synchronized" lang="en">Timestamp format</p>
    BEGIN OF gc_timestamp_format,
      auto       TYPE zif_brx_type=>tv_timestamp_format VALUE ' ',
      iso_local  TYPE zif_brx_type=>tv_timestamp_format VALUE 'L',
      iso_offset TYPE zif_brx_type=>tv_timestamp_format VALUE 'O',
      iso_utc    TYPE zif_brx_type=>tv_timestamp_format VALUE 'Z',
      raw        TYPE zif_brx_type=>tv_timestamp_format VALUE 'R',
      text       TYPE zif_brx_type=>tv_timestamp_format VALUE 'T',
      unknown    TYPE zif_brx_type=>tv_timestamp_format VALUE ' ',
    END OF gc_timestamp_format .

ENDINTERFACE.
