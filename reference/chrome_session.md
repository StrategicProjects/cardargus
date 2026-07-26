# Get (or create) the persistent Chrome session

Returns a package-level ChromoteSession, creating one on first use and
replacing it if it is no longer responsive (health-checked via
[`chrome_session_alive()`](https://strategicprojects.github.io/cardargus/reference/chrome_session_alive.md)).
Reusing one session across conversions avoids the ~1-2s startup cost of
a new session per call.

## Usage

``` r
chrome_session(reset = FALSE)
```

## Arguments

- reset:

  Force-close the current session and start a fresh one.

## Value

A live ChromoteSession object.
