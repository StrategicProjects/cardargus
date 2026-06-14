# Safely close a Chromote session

Closes a chromote session handling pending promises to avoid "Unhandled
promise error: timed out waiting for response" warnings. This function
processes pending async operations before closing and silently ignores
any timeout errors during cleanup.

## Usage

``` r
cleanup_chromote_session(session, timeout_before = 2, timeout_after = 1)
```

## Arguments

- session:

  A ChromoteSession object to close.

- timeout_before:

  Seconds to wait for pending promises before closing (default 2).

- timeout_after:

  Seconds to wait for cleanup after closing (default 1).

## Value

NULL (invisibly). Called for side effects.
