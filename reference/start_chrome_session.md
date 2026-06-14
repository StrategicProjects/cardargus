# Start a new Chrome session safely

Creates a new ChromoteSession, optionally closing an existing one first.
Includes a small delay after closing to allow Chrome to clean up.

## Usage

``` r
start_chrome_session(old_session = NULL)
```

## Arguments

- old_session:

  Previous session to close (can be NULL).

## Value

New ChromoteSession object.
