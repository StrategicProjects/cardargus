# Download a Google Font as WOFF2 to the cache

Download a Google Font as WOFF2 to the cache

## Usage

``` r
download_google_font_woff2(family, weight = "400", text = NULL)
```

## Arguments

- family:

  Font family name.

- weight:

  Numeric/character weight (default "400").

- text:

  Optional normalized character set (see
  [`font_subset_charset()`](https://strategicprojects.github.io/cardargus/reference/font_subset_charset.md)).
  When supplied, the Google Fonts CSS API is asked for a *subset*
  containing only those glyphs (`&text=` parameter), which is
  dramatically smaller than the full font. Subsets are cached per
  character set.

## Value

Path to cached WOFF2 file or NA_character\_.
