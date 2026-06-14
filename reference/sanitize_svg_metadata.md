# Sanitize SVG metadata for Chrome rendering

Removes problematic Inkscape/Sodipodi metadata that can cause issues,
but preserves @import rules since Chrome handles them correctly.

## Usage

``` r
sanitize_svg_metadata(svg_content)
```

## Arguments

- svg_content:

  SVG string.

## Value

Sanitized SVG string.
