"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Constants</p>
INTERFACE zif_brx_const
  PUBLIC .


  CONSTANTS:
    "! <p class="shorttext synchronized" lang="en">Unit of measure</p>
    BEGIN OF gc_time_unit,
      year   TYPE zif_brx_type=>tv_time_unit VALUE 'JHR',
      month  TYPE zif_brx_type=>tv_time_unit VALUE 'MON',
      week   TYPE zif_brx_type=>tv_time_unit VALUE 'WCH',
      day    TYPE zif_brx_type=>tv_time_unit VALUE 'TAG',
      hour   TYPE zif_brx_type=>tv_time_unit VALUE 'STD',
      minute TYPE zif_brx_type=>tv_time_unit VALUE 'MIN',
      second TYPE zif_brx_type=>tv_time_unit VALUE 'S',
    END OF gc_time_unit .

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
      auto TYPE zif_brx_type=>tv_date_format VALUE '   ',
      ymd  TYPE zif_brx_type=>tv_date_format VALUE 'YMD',
      dmy  TYPE zif_brx_type=>tv_date_format VALUE 'DMY',
      mdy  TYPE zif_brx_type=>tv_date_format VALUE 'MDY',
    END OF gc_date_format .

  CONSTANTS:
    "! <p class="shorttext synchronized" lang="en">Timestamp constants</p>
    BEGIN OF gc_timestamp,
      infinity      TYPE zif_brx_type=>tv_timestamp_long VALUE '99991231235959.9999999',
      initial       TYPE zif_brx_type=>tv_timestamp_long VALUE '0',
      end_of_second TYPE zif_brx_type=>tv_timestamp_long VALUE '0.9999999',
    END OF gc_timestamp.

  CONSTANTS:
    "! <p class="shorttext synchronized" lang="en">Date constants</p>
    BEGIN OF gc_date,
      infinity TYPE d VALUE '99991231',
      initial  TYPE d VALUE '00000000',
      maximum  TYPE d VALUE '99991231',
      minimum  TYPE d VALUE '00010101',
    END OF gc_date.


  CONSTANTS:
    "! <p class="shorttext synchronized" lang="en">Time constants</p>
    BEGIN OF gc_time,
      maximum TYPE t VALUE '235959',
      minimum TYPE t VALUE '000000',
      initial TYPE t VALUE '000000',
    END OF gc_time.

ENDINTERFACE.
