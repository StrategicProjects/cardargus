# Register a local font file for embedding

Copies a local font file (TTF or WOFF2) to the cardargus cache directory
so it can be embedded in SVG exports.

## Usage

``` r
register_font(font_path, family = NULL)
```

## Arguments

- font_path:

  Path to a local .ttf or .woff2 font file

- family:

  Font family name to register (e.g., "Jost"). If NULL, the filename
  without extension is used.

## Value

Path to the cached font file (invisible)
