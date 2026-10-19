"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Constants</p>
INTERFACE zif_brx_const
  PUBLIC .


  CONSTANTS:
    "! <p class="shorttext synchronized" lang="en">Unit of measure</p>
    BEGIN OF gc_unit,
      year   TYPE msehi VALUE 'JHR',
      month  TYPE msehi VALUE 'MON',
      week   TYPE msehi VALUE 'WCH',
      day    TYPE msehi VALUE 'TAG',
      hour   TYPE msehi VALUE 'STD',
      minute TYPE msehi VALUE 'MIN',
      second TYPE msehi VALUE 'S',
    END OF gc_unit .

  CONSTANTS:
    "! <p class="shorttext synchronized" lang="en">Weekday</p>
    BEGIN OF gc_weekday,
      monday    TYPE i VALUE 0,
      tuesday   TYPE i VALUE 1,
      wednesday TYPE i VALUE 2,
      thursday  TYPE i VALUE 3,
      friday    TYPE i VALUE 4,
      saturday  TYPE i VALUE 5,
      sunday    TYPE i VALUE 6,
    END OF gc_weekday .
ENDINTERFACE.
