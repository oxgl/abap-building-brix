# ABAP Building Brix

[![CI](https://github.com/oxgl/abap-building-brix/actions/workflows/ci.yml/badge.svg)](https://github.com/oxgl/abap-building-brix/actions/workflows/ci.yml)
[![ABAP Cloud](https://img.shields.io/badge/ABAP-Cloud%20Ready-green)](https://abaplint.app/stats/oxgl/abap-building-brix/object_classifications)
[![ABAP Version](https://img.shields.io/badge/ABAP-7.58%2B-blue)](https://abaplint.app/stats/oxgl/abap-building-brix/statement_compatibility)
[![Code Statistics](https://img.shields.io/badge/Code%20Statistics-abaplint-blue)](https://abaplint.app/stats/oxgl/abap-building-brix)
[![License](https://img.shields.io/github/license/oxgl/abap-building-brix)](https://github.com/oxgl/abap-building-brix/blob/main/LICENSE)

ABAP Building Brix is a modern, ABAP Cloud-ready utility library that provides small, reusable building blocks for everyday ABAP development.

> **Status: under heavy development.** The package is continuously evolving, with frequent additions of new classes, interfaces, and improvements.

---

## Quick Overview

The goal of the library is to help you solve common tasks faster and with cleaner code, for example:

- handling moments and durations with immutable objects,
- parsing and converting date/time/timestamp values through a unified API,
- safely evaluating textual boolean expressions (`AND/OR/NOT`),
- using shared constants, types, and exceptions for consistent implementation.

**Developer benefit:** less repetitive boilerplate, clearer domain logic, and easier maintenance.

---

## Latest Focus Areas and Improvements

Recent updates especially strengthened the following areas:

- **Unified time model** (`Moment` + `Duration`) with immutable behavior.
- **Interval operations around a moment** (`current`, `next`, `previous`) for day-to-day business logic.
- **Clear separation** between exact elapsed time (second-based) and calendar units (month/year).
- **Flexible parsing layer** for date, time, and timestamp with multiple input formats.
- **Expanded boolean expression parser/utils** for configuration and authorization-like use cases.
- **Stronger exception structure** (`ZCX_BRX_*`) with explicit and predictable error signaling.

---

## Newer and Highlighted Objects

### Time Handling

| Object | Kind | Purpose |
|---|---|---|
| `ZIF_BRX_MOMENT` | Interface | Moment-in-time API |
| `ZCL_BRX_MOMENT` | Class | `Moment` implementation + factory methods |
| `ZIF_BRX_DURATION` | Interface | Duration API |
| `ZCL_BRX_DURATION` | Class | `Duration` implementation + factory methods |
| `ZCL_BRX_CONVERSION` | Class | Date/time/timestamp parsing and conversion helpers |

### Boolean Expressions

| Object | Kind | Purpose |
|---|---|---|
| `ZCL_BRX_BOOLEXPR_UTILS` | Class | Ready-to-use entry points for expression evaluation |
| `ZIF_BRX_BOOLEXPR_PARSER` | Interface | Parser API |
| `ZCL_BRX_BOOLEXPR_PARSER` | Class | Recursive parser implementation |
| `ZIF_BRX_BOOLEXPR_TERM_EVAL` | Interface | Strategy interface for custom term evaluation |

### Shared Foundations

| Object | Kind | Purpose |
|---|---|---|
| `ZIF_BRX_CONST` | Interface | Units, formats, weekday constants |
| `ZIF_BRX_TYPE` | Interface | Shared type definitions |
| `ZCX_BRX_INVALID_VALUE` | Exception class | Invalid / out-of-range values |
| `ZCX_BRX_CONVERSION_FAILED` | Exception class | Conversion failures |
| `ZCX_BRX_EVALUATION_FAILED` | Exception class | Boolean evaluation failures |

---

## Why It Is Useful for Developers

- **Fast to start:** practical API, usable in just a few lines.
- **Safer behavior:** immutable objects with fewer side effects.
- **Consistency:** shared constants/types/exceptions across your codebase.
- **ABAP Cloud compatibility:** modern direction, future-friendly foundation.

---

## Mini Example – Simple to Use

```abap
TRY.
    DATA(lo_now) = zcl_brx_moment=>now( ).

    DATA(lo_today) = lo_now->current( iv_unit = zif_brx_const=>gc_time_unit-day ).
    DATA(lo_end_of_day) = lo_today->end( ).

    DATA(lo_15m) = zcl_brx_duration=>create(
      iv_value = 15
      iv_unit  = zif_brx_const=>gc_time_unit-minute ).

    DATA(lo_deadline) = lo_now->add( io_duration = lo_15m ).
  CATCH zcx_brx_invalid_value INTO DATA(lx).
    " handle error
ENDTRY.
```

```abap
TRY.
    DATA(lv_ok) = zcl_brx_boolexpr_utils=>evaluate_boolexpr_table(
      iv_expression = `ADMIN & !GUEST`
      it_values     = VALUE string_table( ( `ADMIN` ) ( `AUDITOR` ) ) ).
  CATCH zcx_brx_evaluation_failed INTO DATA(lx_eval).
    " handle error
ENDTRY.
```

---

## Design in Short

- **Interface-first approach** (`ZIF_*`)
- **Immutability by default**
- **Explicit, typed error handling** (`ZCX_BRX_*`)
- **No magic literals:** rely on central constants

---

## Contributors / Next Steps

The library is actively evolving. If you build ABAP utility components, it is worth following upcoming updates and patterns—the goal is a progressively richer, easy-to-integrate building-block toolkit.
