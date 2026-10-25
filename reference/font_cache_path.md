# Build a cache filename for a font family

Build a cache filename for a font family

## Usage

``` r
font_cache_path(family, text = NULL)
```

## Arguments

- family:

  Font family name.

- text:

  Optional normalized character set (see
  [`font_subset_charset()`](https://strategicprojects.github.io/cardargus/reference/font_subset_charset.md)).
  When supplied, the cache key gets a stable suffix derived from the
  character set, so each subset is cached separately from the full font.

## Value

Path to the cached font file.
