# Get font cache directory

Returns the directory where cardargus caches downloaded font files.
Fonts in this directory are automatically embedded in SVG/PNG exports.

## Usage

``` r
font_cache_dir(persistent = TRUE)
```

## Arguments

- persistent:

  Logical. If TRUE (default), uses persistent cache via
  [`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html). If
  FALSE or if persistent cache is unavailable, uses a session-specific
  temporary directory.

## Value

A character path to the cache directory.
