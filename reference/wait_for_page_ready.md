# Wait until all fonts on the page are loaded

Deterministic readiness wait: resolves once `document.fonts.ready` fires
(all `@font-face` fonts loaded, including web fonts fetched over the
network). This replaces fixed
[`Sys.sleep()`](https://rdrr.io/r/base/Sys.sleep.html) waits,
guaranteeing screenshots/PDFs are never captured before fonts render,
while returning as soon as the page is actually ready. Falls back to a
short fixed wait (with a warning) if the readiness signal times out.

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
