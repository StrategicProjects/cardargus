# Extract the visible text content of an SVG

Collects the character content of `<text>`, `<tspan>` and `<textPath>`
elements. Used to build the character set for font subsetting;
duplicated characters are harmless there, so no effort is made to
deduplicate.

## Usage

``` r
svg_text_content(svg_content)
```

## Arguments

- svg_content:

  SVG string.

## Value

A single string with all visible text (possibly empty).
