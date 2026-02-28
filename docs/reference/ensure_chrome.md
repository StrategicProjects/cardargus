# Ensure Chrome is available, downloading if necessary

Checks if Chrome is available and optionally downloads a standalone
Chrome for Testing if not found. This ensures Chrome-based rendering
works without requiring a system-wide Chrome installation.

## Usage

``` r
ensure_chrome(download = FALSE, verbose = TRUE)
```

## Arguments

- download:

  If TRUE and Chrome is not found, attempt to download Chrome for
  Testing (default FALSE).

- verbose:

  Print status messages (default TRUE).

## Value

TRUE if Chrome is available (or was successfully downloaded), FALSE
otherwise.

## Details

When `download = TRUE`, this function will download "Chrome for
Testing", a standalone Chrome distribution designed for automation. The
download is approximately 150MB and is cached in the user's data
directory.

Alternatively, you can:

- Install Chrome/Chromium system-wide

- Set the `CHROMOTE_CHROME` environment variable to point to an existing
  installation

## Examples

``` r
# Check and report status
ensure_chrome()
#> ✔ Chrome is available: /Applications/Google Chrome.app/Contents/MacOS/Google Chrome
#> [1] TRUE

# Download Chrome if not available
if (FALSE)  # Requires an external Chrome/Chromium installation 
ensure_chrome(download = TRUE)
 # \dontrun{}
```
