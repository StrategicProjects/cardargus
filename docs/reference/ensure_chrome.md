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
#> ! Chrome/Chromium not found on this system.
#> 
#> ── Options to enable Chrome rendering 
#> Install Chrome or Chromium:
#>   Linux: `sudo apt install chromium-browser`
#>   macOS: `brew install --cask google-chrome`
#>   Windows: Download from <https://www.google.com/chrome/>
#> Or set path to existing Chrome:
#>   `Sys.setenv(CHROMOTE_CHROME = "/path/to/chrome")`
#> Or download Chrome for Testing:
#>   `ensure_chrome(download = TRUE)`
#> [1] FALSE

# Download Chrome if not available
if (FALSE) { # \dontrun{
ensure_chrome(download = TRUE)
} # }
```
