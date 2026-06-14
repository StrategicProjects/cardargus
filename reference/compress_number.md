# Compress number to abbreviated format

Compress number to abbreviated format

## Usage

``` r
compress_number(x, digits = 1)
```

## Arguments

- x:

  Numeric value to compress

- digits:

  Number of decimal places

## Value

Character string with abbreviated number

## Examples

``` r
compress_number(1234567)
#> [1] "1,2 milhões"
compress_number(36400000)
#> [1] "36,4 milhões"
```
