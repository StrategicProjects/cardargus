# Batch convert SVGs to PNG base64 using headless Chrome

Converts multiple SVGs to base64-encoded PNG strings using a single
Chrome session. Much faster than calling svg_to_png_chrome() repeatedly.

## Usage

``` r
batch_svg_to_base64_chrome(
  svg_list,
  dpi = 300,
  background = "transparent",
  load_wait = 0.5,
  restart_every = 50,
  retry_attempts = 3,
  progress = TRUE
)
```

## Arguments

- svg_list:

  List of SVG strings or file paths.

- dpi:

  Resolution (default 300).

- background:

  Background color (default "transparent").

- load_wait:

  Seconds to wait for each page to load (default 0.5). Increase if
  conversions are failing.

- restart_every:

  Restart Chrome session every N conversions (default 50). Helps prevent
  memory issues and stale connections.

- retry_attempts:

  Number of retry attempts on failure (default 3).

- progress:

  Show progress bar (default TRUE).

## Value

Character vector of base64-encoded PNGs (data URI format). Returns NA
for failed conversions.
