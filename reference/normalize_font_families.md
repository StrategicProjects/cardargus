# Normalize a vector of raw font-family values

Takes the first family of each declaration, strips quotes/whitespace,
dedups, and drops CSS generic family names.

## Usage

``` r
normalize_font_families(families)
```

## Arguments

- families:

  Character vector of raw font-family values.
