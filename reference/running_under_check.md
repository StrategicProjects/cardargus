# Is the package being checked by `R CMD check`?

`R CMD check` sets the `_R_CHECK_PACKAGE_NAME_` environment variable for
the duration of the check (including while running examples, tests and
vignettes). We use it to route the font cache to a temporary directory
so the check never writes to the user's home filespace.

## Usage

``` r
running_under_check()
```

## Value

`TRUE` when running under `R CMD check`, otherwise `FALSE`.
