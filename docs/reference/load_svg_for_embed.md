# Load and process external SVG file for embedding

Reads an SVG file and processes it to be embedded inside another SVG.
Removes XML declarations, adjusts dimensions, and prepares for
embedding.

## Usage

``` r
load_svg_for_embed(svg_path, target_height = 40, target_width = NULL)
```

## Arguments

- svg_path:

  Path to the SVG file

- target_height:

  Desired height in pixels

- target_width:

  Optional desired width (calculated from aspect ratio if NULL)

## Value

A list with svg_content, width, and height

## Details

This function is useful when you want to embed custom logos or icons in
cards. You can pass any SVG file path to the `logos`, `bottom_logos`, or
`with_icon` parameters of
[`svg_card()`](https://monitoramento.pe.gov.br/cardargus/reference/svg_card.md).

## Examples

``` r
if (FALSE)  # Need a external svg file
# Load a custom logo
logo <- load_svg_for_embed("/path/to/logo.svg", target_height = 40)

# Or just pass the path directly to svg_card():
svg_card(
  title = "My Card",
  logos = c("/path/to/logo1.svg", "/path/to/logo2.svg"),
  ...
)
#> Error: '...' used in an incorrect context
 # \dontrun{}
```
