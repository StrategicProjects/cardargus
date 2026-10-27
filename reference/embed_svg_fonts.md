# Embed font files into an SVG via @font-face

Embed font files into an SVG via @font-face

## Usage

``` r
embed_svg_fonts(svg_content, font_family, woff2_path, unicode_range = NULL)
```

## Arguments

- svg_content:

  Character SVG.

- font_family:

  Font family name to embed.

- woff2_path:

  Path(s) to font file(s) (.woff2, .ttf, .woff, or .otf). Pode ser um
  vetor: uma regra `@font-face` é gerada por arquivo, na ordem dada
  (primário primeiro, blocos extras depois).

- unicode_range:

  Optional `unicode-range` value(s), parallel to `woff2_path` (`NA` =
  sem declaração). Com múltiplos arquivos, os ranges dizem ao
  renderizador qual face usar para cada code point (#29).

## Value

SVG string with embedded @font-face rule(s).
