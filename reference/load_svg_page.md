# Load an SVG into a Chrome session and wait until it is rendered

Sanitizes the SVG, wraps it in HTML, and navigates to it via a `data:`
URL (no temp files / file:// URLs; a temp file is used only for very
large documents). Blocks until the load event fires and all fonts are
loaded.

## Usage

``` r
load_svg_page(b, svg_content, background, timeout = 10, extra_wait = 0)
```

## Arguments

- b:

  ChromoteSession object.

- svg_content:

  SVG content string.

- background:

  Background color.

- timeout:

  Maximum seconds to wait for load and font readiness.

- extra_wait:

  Additional fixed wait (seconds) after readiness (default 0).

## Value

A list with width and height (CSS px) of the page.
