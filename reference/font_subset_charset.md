# Normalize text into a stable character set for font subsetting

Collapses the input, deduplicates and sorts its characters. Two texts
using the same glyphs therefore map to the same subset (and the same
cache file), regardless of character order or repetition.

## Usage

``` r
font_subset_charset(text)
```

## Arguments

- text:

  Character vector (or NULL).

## Value

A single string with the sorted unique characters, or `NULL` when there
is no usable text.
