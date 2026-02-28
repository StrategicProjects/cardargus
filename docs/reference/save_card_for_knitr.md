# Save card and return path for knitr

Saves a card to a file and returns the path for use in knitr chunks.

## Usage

``` r
save_card_for_knitr(
  svg_string,
  filename = "card",
  format = c("svg", "png"),
  dpi = 300,
  dir = NULL,
  engine = c("auto", "chrome", "rsvg")
)
```

## Arguments

- svg_string:

  SVG string from
  [`svg_card()`](https://monitoramento.pe.gov.br/cardargus/reference/svg_card.md).

- filename:

  Output filename (without extension).

- format:

  Output format: `"svg"` or `"png"`.

- dpi:

  Rasterization DPI for PNG (default 300).

- dir:

  Output directory (defaults to knitr figure directory or tempdir()).

- engine:

  Rendering engine for PNG: `"auto"`, `"chrome"`, or `"rsvg"`.

## Value

Path to the saved file.
