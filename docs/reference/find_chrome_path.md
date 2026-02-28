# Find Chrome executable path

Attempts to find a Chrome or Chromium executable on the system. Checks
common installation paths and environment variables.

## Usage

``` r
find_chrome_path()
```

## Value

Path to Chrome executable, or NULL if not found.

## Examples

``` r
path <- find_chrome_path()
if (!is.null(path)) {
  message("Chrome found at: ", path)
}
#> Chrome found at: /Applications/Google Chrome.app/Contents/MacOS/Google Chrome
```
