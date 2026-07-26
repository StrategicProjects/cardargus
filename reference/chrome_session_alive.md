# Check that a ChromoteSession is alive and responsive

Verifies the session is active and answers a trivial CDP command within
a short timeout. Used before reusing the persistent session so a dead or
hung Chrome is replaced transparently instead of failing the conversion.

## Usage

``` r
chrome_session_alive(b, timeout = 2)
```

## Arguments

- b:

  A ChromoteSession object (or NULL).

- timeout:

  Seconds to wait for the health-check command (default 2).

## Value

TRUE if the session is usable, FALSE otherwise.
