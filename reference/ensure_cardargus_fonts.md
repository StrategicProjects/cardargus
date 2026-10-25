# Ensure cardargus fonts are available (WOFF2 cache)

Ensure cardargus fonts are available (WOFF2 cache)

## Usage

``` r
ensure_cardargus_fonts(families, weight = "400", text = NULL)
```

## Arguments

- families:

  Character vector of font families.

- weight:

  Weight to request when downloading (default "400").

- text:

  Optional normalized character set (see
  [`font_subset_charset()`](https://strategicprojects.github.io/cardargus/reference/font_subset_charset.md)).
  When supplied, a glyph subset is downloaded/cached instead of the full
  font; if the subset cannot be obtained, the full font is used as
  fallback.

## Value

Named character vector family -\> font file path (NA if unavailable).
