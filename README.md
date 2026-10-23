# ABAP Building Brix

ABAP Building Brix is a utility library that provides reusable building blocks for working with **time instants** and **durations** in ABAP.

The repository currently contains:

- domain interfaces (`zif_brx_moment`, `zif_brx_duration`)
- concrete implementations (`zcl_brx_moment`, `zcl_brx_duration`)
- shared constants (`zif_brx_const`)
- typed exception handling (`zcx_brx_error`)

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

## 1) `zif_brx_const` (Interface)

Central constants used by the library.

### Purpose

Provides strongly-typed constants for:

- **Time units** (`gc_unit`):
  - `year`, `month`, `week`, `day`, `hour`, `minute`, `second`
- **Weekdays** (`gc_weekday`):
  - `monday` .. `sunday` mapped to `0..6`

### Typical Usage

Use these constants instead of hardcoded literals when calling APIs such as `create`, `end_of`, or arithmetic methods.

---

## 2) `zif_brx_duration` (Interface)

Abstraction for a duration value (internally represented in seconds).

### Methods

- **`as_seconds( ) -> tv_seconds`**  
  Returns the duration in seconds.

- **`add( io_duration | iv_seconds | iv_minutes | iv_hours | iv_days ) -> ro_duration`**  
  Returns a new duration by adding another duration and/or scalar values.

- **`subtract( io_duration | iv_seconds | iv_minutes | iv_hours | iv_days ) -> ro_duration`**  
  Returns a new duration by subtracting another duration and/or scalar values.

### What it is used for

- Duration arithmetic in domain logic.
- Keeping time calculations explicit and composable.

---

## 3) `zcl_brx_duration` (Class)

Concrete implementation of `zif_brx_duration`.

### Key Methods

- **`create( iv_value, iv_unit ) -> ro_duration`** *(class-method)*  
  Factory method for creating duration instances.

  Supported fixed-size units:
  - `day`
  - `hour`
  - `minute`
  - `second`

  `month` and `year` are intentionally excluded because they are not fixed-length durations.

- **`constructor( iv_seconds )`**  
  Internal initialization from seconds.

- **`zif_brx_duration~as_seconds`**, **`~add`**, **`~subtract`**  
  Interface method implementations.

### What it is used for

- Standardized creation and manipulation of duration objects.
- Safe conversion from business units to a canonical seconds representation.

---

## 4) `zif_brx_moment` (Interface)

Abstraction for an instant in time.

### Core Methods

- **`as_date( iv_timezone ) -> d`**  
  Returns date part in the requested timezone.

- **`as_time( iv_timezone ) -> t`**  
  Returns time part in the requested timezone.

- **`as_timestamp( ) -> timestamp`**  
  Returns short timestamp representation.

- **`as_timestampl( ) -> timestampl`**  
  Returns long timestamp representation.

- **`as_weekday( iv_timezone ) -> i`**  
  Returns weekday index.

- **`as_string( ) -> string`**  
  Returns ISO-8601 formatted string.

- **`end_of( iv_unit, iv_timezone ) -> ro_moment`**  
  Returns a new moment at the end of the specified unit (for example day/week/month).

### What it is used for

- Timezone-aware date/time extraction.
- Building period boundary logic (e.g., end-of-day, end-of-week).
- Uniform representation of time instants in application logic.

---

## 5) `zcl_brx_moment` (Class)

Concrete implementation of `zif_brx_moment`.

### Key Class Methods

- **`now( ) -> ro_moment`**  
  Creates/returns a moment representing current system time.

- **`infinity( ) -> ro_moment`**  
  Returns a singleton representing a maximal/infinite timestamp.

- **`initial( ) -> ro_moment`**  
  Returns a singleton representing an initial/zero timestamp.

- **`class_constructor`**  
  Performs class-level initialization.

### Internal Model (high level)

- Timestamp/date/time boundary constants (`gc_timestamp`, `gc_date`, `gc_time`)
- Current moment storage (`gv_timestamp`)
- Singleton references (`go_infinity`, `go_initial`)

### What it is used for

- Working with “current”, “initial”, and “infinite” time anchors.
- Calculating normalized and bounded temporal values.

---

## 6) `zcx_brx_error` (Exception Class)

Typed library exception (`CX_STATIC_CHECK`) implementing:

- `IF_T100_MESSAGE`
- `IF_T100_DYN_MSG`

### Purpose

Provides consistent exception semantics across BRX components, including support for T100 message keys and exception chaining.

### Constructor

- **`constructor( textid, previous )`**  
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

- Prefer interfaces (`zif_*`) in consuming code where possible.
- Use `zif_brx_const` for unit values to avoid literal drift.
- Handle `zcx_brx_error` explicitly in calling layers.
- Keep duration logic in fixed-size units unless business logic defines explicit calendar semantics.
