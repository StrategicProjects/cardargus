# Save SVG string to file (sanitized + embedded fonts)

Saves an SVG string to disk. Before saving, the function:

1.  sanitizes the SVG to remove problematic Inkscape/Sodipodi metadata
    that can break strict XML parsers, and

2.  detects and embeds fonts (WOFF2 via @font-face) for deterministic
    rendering.

This function expects the font helpers to be available in the package:
[`detect_svg_fonts()`](https://monitoramento.pe.gov.br/cardargus/reference/detect_svg_fonts.md),
[`ensure_cardargus_fonts()`](https://monitoramento.pe.gov.br/cardargus/reference/ensure_cardargus_fonts.md),
and
[`embed_svg_fonts()`](https://monitoramento.pe.gov.br/cardargus/reference/embed_svg_fonts.md).

## Usage

``` r
save_svg(svg_content, output_path)
```

## Arguments

- svg_content:

  SVG string (or object coercible to character).

- output_path:

  Output file path.

## Value

Path to the saved SVG file.

## Examples

``` r
svg <- svg_card("FAR", list(), list())
save_svg(svg, tempfile(fileext = ".svg"))
#> [1] "/var/folders/j9/7g_srh2x0d71c5q0pbj5mxh40000gn/T//Rtmpy89dSb/file5a5d7d0c4256.svg"
```
