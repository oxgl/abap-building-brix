"! <p class="shorttext synchronized" lang="en">ABAP Building Brix: Interval</p>
INTERFACE zif_brx_interval
  PUBLIC .

  "! <p class="shorttext synchronized" lang="en">Returns the start moment of the interval.</p>
  "!
  "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">The start moment of the interval.</p>
  METHODS start
    RETURNING
      VALUE(ro_moment) TYPE REF TO zif_brx_moment.

  "! <p class="shorttext synchronized" lang="en">Returns the end moment of the interval.</p>
  "!
  "! @parameter ro_moment | <p class="shorttext synchronized" lang="en">The end moment of the interval.</p>
  METHODS end
    RETURNING
      VALUE(ro_moment) TYPE REF TO zif_brx_moment.

  "! <p class="shorttext synchronized" lang="en">Returns the duration of the interval.</p>
  "!
  "! @parameter ro_duration | <p class="shorttext synchronized" lang="en">The duration of the interval.</p>
  METHODS duration
    RETURNING
      VALUE(ro_duration) TYPE REF TO zif_brx_duration.


  "! <p class="shorttext synchronized" lang="en">Checks if the interval equals another interval</p>
  "!
  "! @parameter io_interval | <p class="shorttext synchronized" lang="en">Interval to compare with</p>
  "! @parameter rv_equals | <p class="shorttext synchronized" lang="en">True if the durations are equal, false otherwise</p>
  METHODS equals
    IMPORTING
      io_interval      TYPE REF TO zif_brx_interval
    RETURNING
      VALUE(rv_equals) TYPE abap_bool.

  "! <p class="shorttext synchronized" lang="en">Compares the interval to another interval</p>
  "!
  "! <p>Returns:
  "! <li> = 0 if the intervalss are equal</li>
  "! <li> <> 0 if the intervals are not equal</li>
  "! </p>
  "!
  "! @parameter io_interval | <p class="shorttext synchronized" lang="en">Interval to compare with</p>
  "! @parameter rv_compare | <p class="shorttext synchronized" lang="en">Comparison result</p>
  METHODS compare
    IMPORTING
      io_interval       TYPE REF TO zif_brx_interval
    RETURNING
      VALUE(rv_compare) TYPE i.

ENDINTERFACE.
