# Convert a single SVG using an existing Chrome session

Internal helper that renders an SVG to PNG using an existing Chrome
session. Uses fixed-time waiting instead of event-based waiting for
reliability.

## Usage

``` r
convert_svg_with_session(b, svg_content, scale, background, load_wait = 0.5)
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

  Seconds to wait for page load (default 0.5).

## Value

Base64 encoded PNG string.
