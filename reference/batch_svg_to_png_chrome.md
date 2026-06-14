# Batch convert SVGs to PNG files using headless Chrome

Converts multiple SVGs to PNG files using a single Chrome session. Much
faster than calling svg_to_png_chrome() repeatedly.

## Usage

``` r
batch_svg_to_png_chrome(
  svg_list,
  output_paths = NULL,
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

- output_paths:

  Character vector of output paths. If NULL, temp files are created.

- dpi:

  Resolution (default 300).

- background:

  Background color (default "transparent").

- load_wait:

  Seconds to wait for each page to load (default 0.5). Increase if
  conversions are failing.

- restart_every:

  Restart Chrome session every N conversions (default 50).

- retry_attempts:

  Number of retry attempts on failure (default 3).

- progress:

  Show progress bar (default TRUE).

## Value

Character vector of output file paths. Returns NA for failed
conversions.
