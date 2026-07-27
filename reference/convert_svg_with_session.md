# Convert a single SVG using an existing Chrome session

Internal helper that renders an SVG to PNG using an existing Chrome
session. Waits deterministically for load/fonts via
[`load_svg_page()`](https://strategicprojects.github.io/cardargus/reference/load_svg_page.md).
When `background` is transparent, the PNG is captured with a real alpha
channel.

## Usage

``` r
convert_svg_with_session(
  b,
  svg_content,
  scale,
  background,
  load_wait = 0,
  timeout = 10
)
```

## Arguments

- b:

  ChromoteSession object.

- svg_content:

  SVG content string (already sanitized).

- scale:

  DPI scale factor.

- background:

  Background color.

- load_wait:

  Extra fixed wait in seconds after readiness (default 0).

- timeout:

  Maximum seconds to wait for page readiness (default 10).

## Value

Base64 encoded PNG string.
