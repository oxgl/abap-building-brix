# ABAP Building Brix

[![CI](https://github.com/oxgl/abap-building-brix/actions/workflows/ci.yml/badge.svg)](https://github.com/oxgl/abap-building-brix/actions/workflows/ci.yml)
[![ABAP Cloud](https://img.shields.io/badge/ABAP-Cloud%20Ready-green)](https://abaplint.app/stats/oxgl/abap-building-brix/object_classifications)
[![ABAP Version](https://img.shields.io/badge/ABAP-7.58%2B-blue)](https://abaplint.app/stats/oxgl/abap-building-brix/statement_compatibility)
[![Code Statistics](https://img.shields.io/badge/Code%20Statistics-abaplint-blue)](https://abaplint.app/stats/oxgl/abap-building-brix)
[![License](https://img.shields.io/github/license/oxgl/abap-building-brix)](https://github.com/oxgl/abap-building-brix/blob/main/LICENSE)

ABAP Building Brix egy modern, ABAP Cloud-ready segédkönyvtár, amely kis, újrahasznosítható építőelemeket ad a mindennapi fejlesztéshez.

> **Status: under heavy development.** A csomag folyamatosan bővül, rendszeresen érkeznek új osztályok, interfészek és fejlesztések.

---

## Rövid áttekintés

A könyvtár célja, hogy gyorsabban és tisztábban tudj tipikus feladatokat megoldani, például:

- időpontok és időtartamok kezelése immutábilis objektumokkal,
- dátum/idő/timestamp konverziók és parsing egységes API-val,
- szöveges logikai kifejezések (`AND/OR/NOT`) biztonságos kiértékelése,
- közös konstansok, típusok és kivételek használata konzisztens kódhoz.

**Fejlesztői előny:** kevesebb ismétlődő boilerplate kód, tisztább domain-logika, jobban karbantartható implementáció.

---

## Legújabb fókuszterületek és bővítések

Az utóbbi frissítésekben a könyvtár különösen az alábbi területeken erősödött:

- **Időkezelési modell egységesítése** (`Moment` + `Duration`) immutábilis működéssel.
- **Fejlettebb időhatár műveletek** (`start_of`, `end_of`, `start_of_next`, `end_of_previous`) napi üzleti logikához.
- **Pontos különválasztás** az egzakt időtartam (másodperc alapú) és a naptári egységek (hónap/év) között.
- **Rugalmas parsing réteg** dátumra, időre és timestampre több input formátummal.
- **Boolean expression parser/utils** modul bővítése konfigurációs és jogosultsági jellegű use-case-ekre.
- **Erősebb kivételkezelési struktúra** (`ZCX_BRX_*`) egyértelmű hibajelzésekkel.

---

## Újabb és kiemelt objektumok

### Időkezelés

| Objektum | Típus | Rövid cél |
|---|---|---|
| `ZIF_BRX_MOMENT` | Interfész | Időpillanat API |
| `ZCL_BRX_MOMENT` | Osztály | `Moment` implementáció + factory metódusok |
| `ZIF_BRX_DURATION` | Interfész | Időtartam API |
| `ZCL_BRX_DURATION` | Osztály | `Duration` implementáció + factory metódusok |
| `ZCL_BRX_CONVERSION` | Osztály | Dátum/idő/timestamp parsing és konverzió |

### Logikai kifejezések

| Objektum | Típus | Rövid cél |
|---|---|---|
| `ZCL_BRX_BOOLEXPR_UTILS` | Osztály | Egyszerű, kész belépési pont értékeléshez |
| `ZIF_BRX_BOOLEXPR_PARSER` | Interfész | Parser API |
| `ZCL_BRX_BOOLEXPR_PARSER` | Osztály | Rekurzív parser implementáció |
| `ZIF_BRX_BOOLEXPR_TERM_EVAL` | Interfész | Saját term-kiértékelési stratégia |

### Közös alapok

| Objektum | Típus | Rövid cél |
|---|---|---|
| `ZIF_BRX_CONST` | Interfész | Egységek, formátumok, weekday konstansok |
| `ZIF_BRX_TYPE` | Interfész | Megosztott típusdefiníciók |
| `ZCX_BRX_INVALID_VALUE` | Kivételosztály | Érvénytelen / tartományon kívüli érték |
| `ZCX_BRX_CONVERSION_FAILED` | Kivételosztály | Sikertelen konverzió |
| `ZCX_BRX_EVALUATION_FAILED` | Kivételosztály | Sikertelen logikai kiértékelés |

---

## Miért hasznos fejlesztőként?

- **Gyors indulás:** kevés sorból használható, jól szegmentált API.
- **Biztonságos működés:** immutábilis objektumok, kevesebb mellékhatás.
- **Konzisztencia:** közös konstansok/típusok/kivételek a projekt egészében.
- **ABAP Cloud kompatibilitás:** modern irány, jövőállóbb kódbázis.

---

## Mini példa – mennyire egyszerű használni

```abap
DATA(lo_now) = zcl_brx_moment=>now( ).
DATA(lo_end_of_day) = lo_now->end_of( zif_brx_const=>gc_unit-day ).

DATA(lo_15m) = zcl_brx_duration=>create(
  iv_value = 15
  iv_unit  = zif_brx_const=>gc_unit-minute ).

DATA(lo_deadline) = lo_now->add( io_duration = lo_15m ).
```

```abap
DATA(lv_ok) = zcl_brx_boolexpr_utils=>evaluate_boolexpr_table(
  iv_expression = `ADMIN & !GUEST`
  it_values     = VALUE string_table( ( `ADMIN` ) ( `AUDITOR` ) ) ).
```

---

## Design röviden

- **Interface-first megközelítés** (`ZIF_*`)
- **Immutability by default**
- **Típusos, explicit hibakezelés** (`ZCX_BRX_*`)
- **„No magic literals”**: központi konstansok használata

---

## Contributors / következő lépések

A könyvtár aktívan fejlődik. Ha ABAP utility komponenseket építesz, érdemes követni a frissítéseket és a mintákat, mert a cél egy egyre teljesebb, könnyen beépíthető „building blocks” ökoszisztéma.
