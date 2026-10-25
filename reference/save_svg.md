# Save SVG string to file (sanitized + embedded fonts)

Saves an SVG string to disk. Before saving, the function:

1.  sanitizes the SVG to remove problematic Inkscape/Sodipodi metadata
    that can break strict XML parsers, and

2.  detects and embeds fonts (WOFF2 via @font-face) for deterministic
    rendering.

## Usage

``` r
save_svg(svg_content, output_path, subset_fonts = FALSE)
```

## Arguments

- svg_content:

  SVG string (or object coercible to character).

- output_path:

  Output file path.

- subset_fonts:

  If TRUE, embed a glyph *subset* covering only the characters used by
  the card text, instead of the full font. This typically shrinks the
  saved SVG dramatically. Subsets are downloaded from the Google Fonts
  CSS API (network required on first use) and cached per character set;
  when a subset cannot be obtained, the full font is embedded instead.

## Value

Path to the saved SVG file.

## Examples

``` r
svg <- svg_card("FAR", list(), list())
save_svg(svg, tempfile(fileext = ".svg"))
#> [1] "/tmp/RtmphAsF68/file1d5818047c5e.svg"

# Much smaller file: embed only the glyphs the card uses
save_svg(svg, tempfile(fileext = ".svg"), subset_fonts = TRUE)
#> Warning: Could not download a subset of font "Jost"; using the full font.
#> [1] "/tmp/RtmphAsF68/file1d58d8d34b9.svg"
```
