# Generate unique ID suffix

Produces a short, collision-resistant suffix derived from the supplied
content plus a session-local counter. Using a counter (instead of
[`stats::runif()`](https://rdrr.io/r/stats/Uniform.html)) keeps output
deterministic and reproducible within a session while remaining unique
across calls.

## Usage

``` r
generate_id(...)
```

## Arguments

- ...:

  Values to hash

## Value

Character string with unique ID
