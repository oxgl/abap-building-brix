# ABAP Building Brix

[![CI](https://github.com/oxgl/abap-building-brix/actions/workflows/ci.yml/badge.svg)](https://github.com/oxgl/abap-building-brix/actions/workflows/ci.yml)
[![ABAP Cloud](https://img.shields.io/badge/ABAP-Cloud%20Ready-green)](https://abaplint.app/stats/oxgl/abap-building-brix/object_classifications)
[![ABAP Version](https://img.shields.io/badge/ABAP-7.58%2B-blue)](https://abaplint.app/stats/oxgl/abap-building-brix/statement_compatibility)
[![Code Statistics](https://img.shields.io/badge/Code%20Statistics-abaplint-blue)](https://abaplint.app/stats/oxgl/abap-building-brix)
[![License](https://img.shields.io/github/license/oxgl/abap-building-brix)](https://github.com/oxgl/abap-building-brix/blob/main/LICENSE)

ABAP Building Brix is a utility library that provides reusable building blocks for working with **time instants** and **durations** in ABAP.

The repository currently contains:

- domain interfaces (`ZIF_BRX_MOMENT`, `ZIF_BRX_DURATION`)
- concrete implementations (`ZCL_BRX_MOMENT`, `ZCL_BRX_DURATION`)
- conversion utilities (`ZCL_BRX_CONVERSION`)
- shared constants (`ZIF_BRX_CONST`)
- typed exception handling (`ZCX_BRX_ERROR`)

---

## Architecture Overview

The design follows a small, interface-driven model:

- **Interfaces** define the public API and expected behavior.
- **Classes** provide implementations behind those interfaces.
- **Constants interface** centralizes canonical unit and weekday values.
- **Exception class** ensures consistent error handling with T100 support.

This makes the package easier to consume, test, and extend in business code.

---

## Main Components

## 1) `ZIF_BRX_CONST` (Interface)

Central constants used by the library.

### Purpose

Provides strongly-typed constants for:

- **Time units** (`GC_UNIT`):
  - `year`, `month`, `week`, `day`, `hour`, `minute`, `second`
- **Weekdays** (`GC_WEEKDAY`):
  - `monday` .. `sunday` mapped to `0..6`

### Typical Usage

Use these constants instead of hardcoded literals when calling APIs such as `create`, `end_of`, or arithmetic methods.

---

## 2) `ZIF_BRX_DURATION` (Interface)

Abstraction for a duration value (internally represented in seconds).

### Methods

- **`AS_SECONDS( ) -> TV_SECONDS`**  
  Returns the duration in seconds.

- **`ADD( IO_DURATION | IV_SECONDS | IV_MINUTES | IV_HOURS | IV_DAYS ) -> RO_DURATION`**  
  Returns a new duration by adding another duration and/or scalar values.

- **`SUBTRACT( IO_DURATION | IV_SECONDS | IV_MINUTES | IV_HOURS | IV_DAYS ) -> RO_DURATION`**  
  Returns a new duration by subtracting another duration and/or scalar values.

### What it is used for

- Duration arithmetic in domain logic.
- Keeping time calculations explicit and composable.

---

## 3) `ZCL_BRX_DURATION` (Class)

Concrete implementation of `ZIF_BRX_DURATION`.

### Key Methods

- **`CREATE( IV_VALUE, IV_UNIT ) -> RO_DURATION`** *(class-method)*  
  Factory method for creating duration instances.

  Supported fixed-size units:
  - `day`
  - `hour`
  - `minute`
  - `second`

  `month` and `year` are intentionally excluded because they are not fixed-length durations.

- **`CONSTRUCTOR( IV_SECONDS )`**  
  Internal initialization from seconds.

- **`ZIF_BRX_DURATION~AS_SECONDS`**, **`~ADD`**, **`~SUBTRACT`**  
  Interface method implementations.

### What it is used for

- Standardized creation and manipulation of duration objects.
- Safe conversion from business units to a canonical seconds representation.

---

## 4) `ZIF_BRX_MOMENT` (Interface)

Abstraction for an instant in time.

### Core Methods

- **`AS_DATE( IV_TIMEZONE ) -> D`**  
  Returns date part in the requested timezone.

- **`AS_TIME( IV_TIMEZONE ) -> T`**  
  Returns time part in the requested timezone.

- **`AS_TIMESTAMP( ) -> TIMESTAMP`**  
  Returns short timestamp representation.

- **`AS_TIMESTAMPL( ) -> TIMESTAMPL`**  
  Returns long timestamp representation.

- **`AS_WEEKDAY( IV_TIMEZONE ) -> I`**  
  Returns weekday index.

- **`AS_STRING( ) -> STRING`**  
  Returns ISO-8601 formatted string.

- **`END_OF( IV_UNIT, IV_TIMEZONE ) -> RO_MOMENT`**  
  Returns a new moment at the end of the specified unit (for example day/week/month).

### What it is used for

- Timezone-aware date/time extraction.
- Building period boundary logic (e.g., end-of-day, end-of-week).
- Uniform representation of time instants in application logic.

---

## 5) `ZCL_BRX_MOMENT` (Class)

Concrete implementation of `ZIF_BRX_MOMENT`.

### Key Class Methods

- **`NOW( ) -> RO_MOMENT`**  
  Creates/returns a moment representing current system time.

- **`INFINITY( ) -> RO_MOMENT`**  
  Returns a singleton representing a maximal/infinite timestamp.

- **`INITIAL( ) -> RO_MOMENT`**  
  Returns a singleton representing an initial/zero timestamp.

- **`CLASS_CONSTRUCTOR`**  
  Performs class-level initialization.

### Internal Model (high level)

- Timestamp/date/time boundary constants (`GC_TIMESTAMP`, `GC_DATE`, `GC_TIME`)
- Current moment storage (`GV_TIMESTAMP`)
- Singleton references (`GO_INFINITY`, `GO_INITIAL`)

### What it is used for

- Working with “current”, “initial”, and “infinite” time anchors.
- Calculating normalized and bounded temporal values.

---

## 6) `ZCL_BRX_CONVERSION` (Class)

Utility class for conversion-related operations within the BRX domain.

### Purpose

- Centralizes conversion logic to keep domain classes focused.
- Improves reuse and consistency of transformations.

---

## 7) `ZCX_BRX_ERROR` (Exception Class)

Typed library exception (`CX_STATIC_CHECK`) implementing:

- `IF_T100_MESSAGE`
- `IF_T100_DYN_MSG`

### Purpose

Provides consistent exception semantics across BRX components, including support for T100 message keys and exception chaining.

### Constructor

- **`CONSTRUCTOR( TEXTID, PREVIOUS )`**  
  Initializes error context with optional message ID and nested exception.

---

## Practical Examples

### Create a duration

```abap
DATA(lo_duration) = zcl_brx_duration=>create(
  iv_value = 15
  iv_unit  = zif_brx_const=>gc_unit-minute
).
```

### Add time to a duration

```abap
DATA(lo_extended) = lo_duration->add( iv_minutes = 30 ).
```

### Get current moment

```abap
DATA(lo_now) = zcl_brx_moment=>now( ).
```

### Calculate end of current day

```abap
DATA(lo_end_of_day) = lo_now->end_of(
  iv_unit = zif_brx_const=>gc_unit-day
).
```

---

## Notes for Contributors

- Prefer interfaces (`ZIF_*`) in consuming code where possible.
- Use `ZIF_BRX_CONST` for unit values to avoid literal drift.
- Handle `ZCX_BRX_ERROR` explicitly in calling layers.
- Keep duration logic in fixed-size units unless business logic defines explicit calendar semantics.
