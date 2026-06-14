# Font Management

## Overview

cardargus uses **Jost** as its default font, a modern sans-serif from
Google Fonts. This article explains how to configure and manage fonts
for best results.

## Quick Setup

``` r

library(cardargus)

# Automatically setup fonts (recommended)
setup_fonts()
```

This function:

1.  Registers Jost and Montserrat from Google Fonts
2.  Enables showtext auto mode
3.  Prepares the system for font rendering

## Check Availability

``` r

# Check if a font is available
font_available("Jost")
font_available("Arial")

# List cached fonts
list_fonts()
```

## Register Google Fonts

``` r

# Register a specific Google Font
register_google_font("Roboto")
register_google_font("Open Sans")
register_google_font("Lato")
```

## Install Fonts Locally

For offline use or better performance, download fonts to your local
cache:

``` r

# Download and cache fonts
install_fonts()

# Install specific fonts
install_fonts(fonts = c("Jost", "Montserrat", "Roboto"))

# Check cache location
font_cache_dir()
```

## Using Custom Fonts

``` r

# Use a different font in cards
card <- svg_card(
  title = "MY CARD",
  font = "Montserrat",  # Use Montserrat instead of Jost
  ...
)
```

## CSS for SVG

cardargus embeds fonts via Google Fonts CSS in SVGs:

``` r

# Generate CSS for a font
css <- get_font_css("Jost")
cat(css)
# @import url("https://fonts.googleapis.com/css2?family=Jost:wght@400;500;600;700&display=swap");

# Multiple weights
css <- get_font_css("Montserrat", weights = c(400, 700))
```

## Font Cache

cardargus caches downloaded fonts in a user directory:

``` r

# Get cache directory
font_cache_dir()
#> "/home/user/.cache/cardargus"

# List cached fonts
list_fonts()
```

## Access Package Resources

``` r

# SVGs directory (bundled logos)
svgs_dir()

# Path to a specific SVG
get_svg_path("morar_bem.svg")

# List available SVGs
list_bundled_svgs()
```

## Troubleshooting

### Font not rendering correctly

1.  Run
    [`setup_fonts()`](https://strategicprojects.github.io/cardargus/reference/setup_fonts.md)
    before creating cards
2.  Check if font is available: `font_available("Jost")`
3.  Install required packages:

``` r

install.packages(c("showtext", "sysfonts", "systemfonts"))
```

### PNG export with rsvg

For correct font rendering in PNG exports with rsvg:

``` r

# Setup fonts first
setup_fonts()

# Download fonts for embedding
install_fonts()

# Create and export
card <- svg_card(...)
svg_to_png(card, "card.png", dpi = 300)
```

### PNG export with Chrome (recommended)

For **perfect font rendering**, use Chrome-based conversion:

``` r

# Ensure Chrome is available
ensure_chrome(download = TRUE)

# Create and export
card <- svg_card(...)
svg_to_png_chrome(card, "card.png", dpi = 300)
```

Chrome handles Google Fonts automatically via `@import`, so no local
font installation is needed.

### Fonts on servers

On servers without GUI:

``` r

# Option 1: Download fonts locally
install_fonts()

# Update font cache (Linux)
system("fc-cache -fv")

# Option 2: Use Chrome rendering (recommended)
ensure_chrome(download = TRUE)
svg_to_png_chrome(card, "card.png")
```

## Recommended Fonts

| Font       | Type       | Description               |
|------------|------------|---------------------------|
| Jost       | Sans-serif | Default, modern           |
| Montserrat | Sans-serif | Elegant alternative       |
| Roboto     | Sans-serif | Readable, Google Material |
| Open Sans  | Sans-serif | Neutral, versatile        |
| Lato       | Sans-serif | Friendly, rounded         |

## Dependencies

For full font functionality:

``` r

install.packages(c(
  "showtext",      # Font rendering
  "sysfonts",      # Font management
  "systemfonts",   # System font detection
  "gdtools"        # Text metrics
))
```

For Chrome-based rendering (recommended):

``` r

install.packages("chromote")
```
