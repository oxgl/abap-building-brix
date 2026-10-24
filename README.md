# ABAP Building Brix

[![CI](https://github.com/oxgl/abap-building-brix/actions/workflows/ci.yml/badge.svg)](https://github.com/oxgl/abap-building-brix/actions/workflows/ci.yml)
[![ABAP Cloud](https://img.shields.io/badge/ABAP-Cloud%20Ready-green)](https://abaplint.app/stats/oxgl/abap-building-brix/object_classifications)
[![ABAP Version](https://img.shields.io/badge/ABAP-7.58%2B-blue)](https://abaplint.app/stats/oxgl/abap-building-brix/statement_compatibility)
[![Code Statistics](https://img.shields.io/badge/Code%20Statistics-abaplint-blue)](https://abaplint.app/stats/oxgl/abap-building-brix)
[![License](https://img.shields.io/github/license/oxgl/abap-building-brix)](https://github.com/oxgl/abap-building-brix/blob/main/LICENSE)

ABAP Building Brix is a utility library that provides small, reusable building blocks for everyday ABAP development.

> **Status: under heavy development.** The package is growing continuously. New classes and interfaces are added regularly, and APIs may still change.

## Motivation

After many years of ABAP development, I have a fairly good idea of what a programmer usually needs in day-to-day work: reliable time handling, safe conversions, small parsing helpers, and so on. This package collects those things in one place as a clean, interface-driven utility library. It is not finished yet, and more building blocks will be added over time.

---

## Contents

- [Categories](#categories)
  - [Working with time](#working-with-time)
  - [Boolean expressions](#boolean-expressions)
  - [Shared (constants, types, exceptions)](#shared-constants-types-exceptions)
- [Design principles](#design-principles)
- [Notes for contributors](#notes-for-contributors)

---

## Categories

### Working with time

| Object | Kind | Purpose |
|---|---|---|
| `ZIF_BRX_MOMENT` | Interface | An instant in time (API) |
| `ZCL_BRX_MOMENT` | Class | Implementation of `ZIF_BRX_MOMENT` and factory methods |
| `ZIF_BRX_DURATION` | Interface | An exact elapsed time (API) |
| `ZCL_BRX_DURATION` | Class | Implementation of `ZIF_BRX_DURATION` and factory methods |
| `ZCL_BRX_CONVERSION` | Class | Parsing of date, time and timestamp strings |

> ### Moment and duration are immutable
> `ZIF_BRX_MOMENT` and `ZIF_BRX_DURATION` objects never change after creation.
> Every method that "modifies" a value (`add`, `subtract`, `end_of`, `start_of`, ...) **returns a new instance** and leaves the original untouched. It is therefore safe to share these objects between components.

#### `ZIF_BRX_MOMENT` / `ZCL_BRX_MOMENT`

A moment is stored internally as a long UTC timestamp (`TIMESTAMPL`).

Factory methods of `ZCL_BRX_MOMENT`:

- `create( iv_timestamp | iv_date + iv_time, iv_timezone )`: creates a moment from a timestamp, or from a date and time in a time zone. Without parameters it returns the current moment.
- `parse( iv_string )`: parses an RFC 3339 / ISO 8601 string (`2025-12-25T14:30:59Z`, `...+01:00`, or local time without an offset).
- `now( )`: the current moment.
- `initial( )`: singleton representing the "zero" (lowest) moment.
- `infinity( )`: singleton representing the maximal moment (`9999-12-31 23:59:59.9999999`).

Methods of `ZIF_BRX_MOMENT`:

| Method | Description |
|---|---|
| `as_date( iv_timezone )` | Date part in the given time zone |
| `as_time( iv_timezone )` | Time part in the given time zone |
| `as_timestamp( )` / `as_timestampl( )` | Short / long timestamp |
| `as_weekday( iv_timezone )` | Weekday (`ZIF_BRX_CONST=>GC_WEEKDAY`, Monday = 0) |
| `as_string( )` | ISO 8601 string |
| `start_of( iv_unit, iv_timezone )` | Start of the second/minute/hour/day/week/month/year |
| `end_of( iv_unit, iv_timezone )` | End of the unit |
| `end_of_previous( iv_unit, iv_timezone )` | End of the previous unit |
| `start_of_next( iv_unit, iv_timezone )` | Start of the next unit |
| `add( ... )` / `subtract( ... )` | Add / subtract a duration and/or calendar units (`iv_years`, `iv_months`, `iv_days`, `iv_hours`, `iv_minutes`, `iv_seconds`) |
| `equals( io_moment )` | Equality check |
| `compare( io_moment )` | Returns `-1`, `0` or `1` |

**Exact duration vs. calendar units:** when a duration object is passed to `add` / `subtract`, it is applied as exact elapsed seconds. Calendar units (especially months and years) are calculated in the given time zone. Adding one month is not a fixed number of days, and if the target month is shorter, the result is clamped to its last valid day.

`infinity( )` and `initial( )` are absorbing for `add` / `subtract`: the result is the same moment.

#### `ZIF_BRX_DURATION` / `ZCL_BRX_DURATION`

A duration is stored internally in seconds.

Factory methods of `ZCL_BRX_DURATION`:

- `create( iv_value, iv_unit )`: supported units are `day`, `hour`, `minute` and `second` (default). `month` and `year` are intentionally not supported because they are not fixed-length.
- `initial( )`: singleton for a zero duration.
- `infinity( iv_negative )`: singleton for a positive or negative infinite duration.

Methods of `ZIF_BRX_DURATION`:

| Method | Description |
|---|---|
| `as_seconds( )` | The duration in seconds |
| `add( ... )` / `subtract( ... )` | Add / subtract a duration and/or `iv_days`, `iv_hours`, `iv_minutes`, `iv_seconds` |
| `is_initial( )` | `abap_true` if the duration is zero |
| `is_infinite( )` | `abap_true` if the duration is infinite (positive or negative) |
| `sign( )` | `1`, `-1` or `0` |
| `equals( io_duration )` | Equality check |
| `compare( io_duration )` | Returns `-1`, `0` or `1` |

#### `ZCL_BRX_CONVERSION`

Static parsing helpers. Each method can detect the format automatically (`auto`) or expect a specific one, and returns the detected format in `ev_format`. An optional plausibility check validates the result.

- `parse_date( iv_input, iv_format )`: formats `eur` (`25.12.2021`), `usa` (`12/25/2021`), `iso` (`2021-12-25`), `internal` (`20211225`).
- `parse_time( iv_input, iv_format )`: formats `eur` (`14.30.59`), `iso` (`14:30:59`), `internal` (`143059`).
- `parse_timestamp( iv_input, iv_format )`: formats `raw`, `iso_utc`, `iso_offset`, `iso_local`, `text` (a date with an optional time).

They raise `ZCX_BRX_CONVERSION_FAILED` if the format is not recognized and `ZCX_BRX_INVALID_VALUE` if the value is out of range.

#### Examples

```abap
" Current moment, and the end of the current day in the user's time zone
DATA(lo_now)         = zcl_brx_moment=>now( ).
DATA(lo_end_of_day)  = lo_now->end_of( iv_unit = zif_brx_const=>gc_unit-day ).
```

```abap
" Immutability: add( ) returns a NEW instance, lo_now stays unchanged
DATA(lo_later) = lo_now->add( iv_hours = 2 ).

ASSERT lo_later <> lo_now.
ASSERT lo_now->compare( lo_later ) = -1.
```

```abap
" Durations are immutable as well
DATA(lo_quarter_hour) = zcl_brx_duration=>create(
  iv_value = 15
  iv_unit  = zif_brx_const=>gc_unit-minute ).

DATA(lo_forty_five) = lo_quarter_hour->add( iv_minutes = 30 ).

" lo_quarter_hour is still 15 minutes
ASSERT lo_quarter_hour->as_seconds( ) = 900.
ASSERT lo_forty_five->as_seconds( )   = 2700.
```

```abap
" Add a duration (exact seconds) vs. calendar units (clamped to the last day of month)
DATA(lo_deadline)   = lo_now->add( io_duration = lo_quarter_hour ).
DATA(lo_next_month) = lo_now->add( iv_months = 1 ).
```

```abap
" Period boundaries
DATA(lo_month_start) = lo_now->start_of( zif_brx_const=>gc_unit-month ).
DATA(lo_next_week)   = lo_now->start_of_next( zif_brx_const=>gc_unit-week ).
DATA(lo_last_year_end) = lo_now->end_of_previous( zif_brx_const=>gc_unit-year ).
```

```abap
" Parse an ISO string and read it in a given time zone
TRY.
    DATA(lo_moment) = zcl_brx_moment=>parse( `2025-12-25T14:30:59Z` ).
    DATA(lv_date)   = lo_moment->as_date( 'CET' ).
    DATA(lv_time)   = lo_moment->as_time( 'CET' ).
  CATCH zcx_brx_conversion_failed zcx_brx_invalid_value INTO DATA(lx_error).
    " handle error
ENDTRY.
```

```abap
" Parse a date in any supported format
TRY.
    DATA(lv_parsed_date) = zcl_brx_conversion=>parse_date( `25.12.2021` ).   " -> 20211225
  CATCH zcx_brx_conversion_failed zcx_brx_invalid_value.
    " handle error
ENDTRY.
```

---

### Boolean expressions

Evaluate textual boolean expressions against a value or a set of values, for example expressions that users enter in configuration tables or selection fields.

| Object | Kind | Purpose |
|---|---|---|
| `ZCL_BRX_BOOLEXPR_UTILS` | Class | Entry point: ready-to-use evaluation methods |
| `ZIF_BRX_BOOLEXPR_PARSER` | Interface | Parser API (`evaluate( iv_expression )`) |
| `ZCL_BRX_BOOLEXPR_PARSER` | Class | Recursive parser implementation, created with `get_instance( io_term_eval )` |
| `ZIF_BRX_BOOLEXPR_TERM_EVAL` | Interface | Strategy for evaluating a single term (the "leaf" of the expression) |

#### Syntax

| Operator | Meaning | Alternative char |
|---|---|---|
| `&` | AND | |
| `\|` | OR | `,` |
| `!` | NOT | `^` |
| `( )` | Grouping | |

Precedence: parentheses, then OR splits the expression first, then AND, then NOT. Terms are compared with the values as plain text (case-insensitive by default).

#### `ZCL_BRX_BOOLEXPR_UTILS`

- `evaluate_boolexpr_value( iv_expression, iv_value, iv_case_insensitive )`: evaluates the expression against a single value.
- `evaluate_boolexpr_table( iv_expression, it_values, iv_case_insensitive )`: evaluates against a table of values. A term is true if it equals any entry of the table.

Both raise `ZCX_BRX_EVALUATION_FAILED` for an invalid expression (for example an empty expression or unbalanced parentheses).

#### Custom term evaluation

The parser is separated from the meaning of the terms. To define your own semantics (for example checking authorizations, feature flags or master data), implement `ZIF_BRX_BOOLEXPR_TERM_EVAL` and pass it to the parser:

```abap
DATA(lo_parser) = zcl_brx_boolexpr_parser=>get_instance( NEW lcl_my_term_eval( ) ).
DATA(lv_result) = lo_parser->evaluate( `(A | B) & !C` ).
```

#### Examples

```abap
TRY.
    " Single value
    DATA(lv_match) = zcl_brx_boolexpr_utils=>evaluate_boolexpr_value(
      iv_expression = `(DE | AT) & !HU`
      iv_value      = `de` ).                       " -> abap_true

    " Table of values: true if the combination of values satisfies the expression
    DATA(lt_roles) = VALUE string_table( ( `ADMIN` ) ( `AUDITOR` ) ).

    DATA(lv_allowed) = zcl_brx_boolexpr_utils=>evaluate_boolexpr_table(
      iv_expression = `ADMIN & !GUEST`
      it_values     = lt_roles ).                   " -> abap_true

    " Alternative operator characters: ',' is OR, '^' is NOT
    DATA(lv_alt) = zcl_brx_boolexpr_utils=>evaluate_boolexpr_table(
      iv_expression = `^GUEST & (ADMIN, SUPPORT)`
      it_values     = lt_roles ).                   " -> abap_true

    " Case-sensitive evaluation
    DATA(lv_cs) = zcl_brx_boolexpr_utils=>evaluate_boolexpr_value(
      iv_expression       = `abc`
      iv_value            = `ABC`
      iv_case_insensitive = abap_false ).           " -> abap_false
  CATCH zcx_brx_evaluation_failed INTO DATA(lx_eval).
    " e.g. empty expression or invalid parentheses
ENDTRY.
```

---

### Shared (constants, types, exceptions)

| Object | Kind | Purpose |
|---|---|---|
| `ZIF_BRX_CONST` | Interface | Constants: time units (`GC_UNIT`), weekdays (`GC_WEEKDAY`), date / time / timestamp formats (`GC_DATE_FORMAT`, `GC_TIME_FORMAT`, `GC_TIMESTAMP_FORMAT`) |
| `ZIF_BRX_TYPE` | Interface | Shared type definitions (time unit, time zone, weekday, short / long timestamp, format types) |
| `ZCX_BRX_STATIC_CHECK` | Exception class | Base class for the library's static-check exceptions |
| `ZCX_BRX_DYNAMIC_CHECK` | Exception class | Base class for the library's dynamic-check exceptions |
| `ZCX_BRX_INVALID_VALUE` | Exception class | Invalid or out-of-range value or parameter |
| `ZCX_BRX_CONVERSION_FAILED` | Exception class | A conversion failed (see `ZCL_BRX_CONVERSION`) |
| `ZCX_BRX_EVALUATION_FAILED` | Exception class | Boolean expression evaluation failed |
| `ZBRX` | Message class | T100 messages used by the exceptions |

Weekdays are numbered `0..6` (`monday` .. `sunday`). Use the constants instead of literals:

```abap
IF lo_moment->as_weekday( ) = zif_brx_const=>gc_weekday-friday.
  " ...
ENDIF.
```

---

## Design principles

- **Interface-driven:** `ZIF_*` interfaces define the API, classes implement it. Prefer the interfaces in consuming code.
- **Immutability:** moments and durations never change; operations return new instances.
- **Explicit errors:** typed exceptions with T100 message support instead of silent failures.
- **No magic literals:** units, weekdays and formats come from `ZIF_BRX_CONST`.

## Notes for contributors

- Prefer interfaces (`ZIF_*`) in consuming code where possible.
- Use `ZIF_BRX_CONST` for unit values to avoid literal drift.
- Handle the `ZCX_BRX_*` exceptions explicitly in calling layers.
- Keep duration logic in fixed-size units unless business logic defines explicit calendar semantics (use calendar units on `ZIF_BRX_MOMENT` for months and years).
- Keep new objects immutable where it makes sense.
