# Sanitize SVG for rasterization engines (librsvg / ImageMagick)

SVGs exported by editors such as Inkscape may contain `sodipodi:*`
and/or `inkscape:*` nodes/attributes. If these namespace prefixes appear
without the corresponding `xmlns:*` declarations, strict parsers
(notably `librsvg`) can fail with errors like:

    Namespace prefix sodipodi on namedview is not defined

This helper removes non-rendering metadata blocks and attributes
commonly responsible for parse failures, producing a more interoperable
SVG string. It also removes Google Fonts @import rules which are not
supported by rasterization engines.

## Usage

``` r
sanitize_svg_for_raster(svg_input)
```

## Arguments

- svg_input:

  An SVG string or an object coercible to character (e.g.
  [`htmltools::HTML`](https://rstudio.github.io/htmltools/reference/HTML.html)).

## Value

A character string containing a sanitized SVG.
