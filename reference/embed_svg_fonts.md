# Embed a font file into an SVG via @font-face

Embed a font file into an SVG via @font-face

## Usage

``` r
embed_svg_fonts(svg_content, font_family, woff2_path)
```

## Arguments

- svg_content:

  Character SVG.

- font_family:

  Font family name to embed.

- woff2_path:

  Path to a font file (.woff2, .ttf, .woff, or .otf).

## Value

SVG string with embedded @font-face rule.
