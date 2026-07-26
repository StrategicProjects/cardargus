# Wait until the page is fully rendered (fonts loaded, layout painted)

Deterministic readiness wait: resolves once `document.fonts.ready` fires
(all `@font-face` fonts loaded) and two animation frames have painted.
This replaces fixed
[`Sys.sleep()`](https://rdrr.io/r/base/Sys.sleep.html) waits,
guaranteeing screenshots/PDFs are never captured before web fonts
render, while returning as soon as the page is actually ready. Falls
back to a short fixed wait (with a warning) if the readiness signal
times out.

## Usage

``` r
wait_for_page_ready(b, timeout = 10)
```

## Arguments

- b:

  ChromoteSession object.

- timeout:

  Maximum seconds to wait for readiness (default 10).

## Value

NULL (invisibly).
