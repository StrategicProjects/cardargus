# Changelog

## cardargus 0.2.5

### New features

- [`svg_to_pdf()`](https://strategicprojects.github.io/cardargus/reference/svg_to_pdf.md)
  exports a card to a **vector** PDF via
  [`rsvg::rsvg_pdf()`](https://docs.ropensci.org/rsvg/reference/rsvg.html),
  mirroring
  [`svg_to_png()`](https://strategicprojects.github.io/cardargus/reference/svg_to_png.md)
  (sanitizes the SVG and embeds WOFF2 fonts). For Chrome-based
  rendering,
  [`svg_to_pdf_chrome()`](https://strategicprojects.github.io/cardargus/reference/svg_to_pdf_chrome.md)
  remains available
  ([\#17](https://github.com/StrategicProjects/cardargus/issues/17)).
- [`save_card_for_knitr()`](https://strategicprojects.github.io/cardargus/reference/save_card_for_knitr.md)
  now accepts `format = "pdf"` (in addition to `"svg"` and `"png"`),
  using Chrome when available and
  [`svg_to_pdf()`](https://strategicprojects.github.io/cardargus/reference/svg_to_pdf.md)
  otherwise.

### Minor improvements

- `svg_to_formats(formats = "pdf")` now reuses
  [`svg_to_pdf()`](https://strategicprojects.github.io/cardargus/reference/svg_to_pdf.md)
  for the vector path and warns explicitly when it falls back to a
  rasterized PDF via `magick`.

### Bug fixes

- `magick` and `rsvg` moved from `Imports` to `Suggests`: they are only
  needed for raster/PDF export, which is already guarded by
  [`requireNamespace()`](https://rdrr.io/r/base/ns-load.html). This
  lightens the install footprint and matches the package’s “heavy deps
  in Suggests” convention
  ([\#19](https://github.com/StrategicProjects/cardargus/issues/19)).
- [`svg_card()`](https://strategicprojects.github.io/cardargus/reference/svg_card.md)
  now sizes badges using `value_fontsize` instead of a hard-coded `10`,
  preventing clipped/misaligned badge text when `value_fontsize` differs
  from 10
  ([\#18](https://github.com/StrategicProjects/cardargus/issues/18)).
- [`is_light_color()`](https://strategicprojects.github.io/cardargus/reference/is_light_color.md)
  now reports an unknown color name with a clear `cli` error instead of
  letting [`col2rgb()`](https://rdrr.io/r/grDevices/col2rgb.html) raise
  a raw base error
  ([\#20](https://github.com/StrategicProjects/cardargus/issues/20)).

## cardargus 0.2.4

CRAN release: 2026-06-14

### CRAN policy fix

- The font cache no longer writes to the user’s home filespace during
  `R CMD check`. When a check is detected (via the
  `_R_CHECK_PACKAGE_NAME_` environment variable),
  [`font_cache_dir()`](https://strategicprojects.github.io/cardargus/reference/font_cache_dir.md)
  routes downloads to a session-specific temporary directory. This
  resolves the `donttest` additional issue where examples
  ([`install_fonts()`](https://strategicprojects.github.io/cardargus/reference/install_fonts.md),
  [`svg_to_png()`](https://strategicprojects.github.io/cardargus/reference/svg_to_png.md),
  [`save_svg()`](https://strategicprojects.github.io/cardargus/reference/save_svg.md))
  left `*.woff2` files under `~/.cache/R/cardargus/`. Interactive and
  normal use is unchanged (the persistent cache is still the default).

## cardargus 0.2.3

CRAN release: 2026-06-14

### Bug fixes

- [`create_badge()`](https://strategicprojects.github.io/cardargus/reference/create_badge.md)
  now accepts CSS gradient background colors; previously
  [`is_light_color()`](https://strategicprojects.github.io/cardargus/reference/is_light_color.md)
  was evaluated before gradient detection and aborted in
  [`col2rgb()`](https://rdrr.io/r/grDevices/col2rgb.html)
  ([\#14](https://github.com/StrategicProjects/cardargus/issues/14)).
- [`css_gradient_to_svg()`](https://strategicprojects.github.io/cardargus/reference/css_gradient_to_svg.md)
  with a single color now produces a solid gradient of that color
  instead of falling back to white-to-black
  ([\#4](https://github.com/StrategicProjects/cardargus/issues/4)).
- Utility functions in `utils.R`
  ([`compress_number()`](https://strategicprojects.github.io/cardargus/reference/compress_number.md),
  [`escape_xml()`](https://strategicprojects.github.io/cardargus/reference/escape_xml.md),
  [`text_width()`](https://strategicprojects.github.io/cardargus/reference/text_width.md),
  [`text_height()`](https://strategicprojects.github.io/cardargus/reference/text_height.md),
  [`wrap_text()`](https://strategicprojects.github.io/cardargus/reference/wrap_text.md))
  no longer error on `NULL`, `NA`, or length \> 1 input
  ([\#2](https://github.com/StrategicProjects/cardargus/issues/2)).
- [`is_light_color()`](https://strategicprojects.github.io/cardargus/reference/is_light_color.md)
  now validates its input and errors clearly on `NA`, `NULL`, or invalid
  hex strings instead of returning `NA`/`TRUE` silently
  ([\#5](https://github.com/StrategicProjects/cardargus/issues/5)).
- Google Fonts downloaded via `gfonts` are now cached with their real
  file extension, so `@font-face` declares the correct
  [`format()`](https://rdrr.io/r/base/format.html)
  ([\#3](https://github.com/StrategicProjects/cardargus/issues/3)).

### Internal / maintenance

- SVG geometry and font-family parsing now use `xml2` (a new soft
  dependency in Suggests) with a regex fallback, making them robust to
  attribute order, quoting, units (`px`/`%`), whitespace and
  viewBox-only sizing. Affects
  [`parse_svg_root_dim()`](https://strategicprojects.github.io/cardargus/reference/parse_svg_root_dim.md),
  [`detect_svg_fonts()`](https://strategicprojects.github.io/cardargus/reference/detect_svg_fonts.md),
  [`load_svg_for_embed()`](https://strategicprojects.github.io/cardargus/reference/load_svg_for_embed.md),
  the logo rows and custom-icon sizing
  ([\#13](https://github.com/StrategicProjects/cardargus/issues/13)).
- [`generate_id()`](https://strategicprojects.github.io/cardargus/reference/generate_id.md)
  is now deterministic (session-local counter) instead of using
  [`runif()`](https://rdrr.io/r/stats/Uniform.html), improving
  reproducibility
  ([\#12](https://github.com/StrategicProjects/cardargus/issues/12)).
- Removed dead `footer_logos_svg` placeholder in
  [`svg_card()`](https://strategicprojects.github.io/cardargus/reference/svg_card.md)
  ([\#6](https://github.com/StrategicProjects/cardargus/issues/6)).
- Network downloads use explicit connect/read timeouts
  ([\#11](https://github.com/StrategicProjects/cardargus/issues/11)).
- Added a `tests/testthat/` suite covering the pure utilities
  ([\#9](https://github.com/StrategicProjects/cardargus/issues/9)).
- Fixed duplicated roxygen `@param` tags in
  [`svg_card()`](https://strategicprojects.github.io/cardargus/reference/svg_card.md)
  and a `lifecycle` reference without the dependency
  ([\#7](https://github.com/StrategicProjects/cardargus/issues/7),
  [\#8](https://github.com/StrategicProjects/cardargus/issues/8)).
  Documentation regenerated with roxygen2 8.0.0.

## cardargus 0.2.0

CRAN release: 2026-01-31

### Breaking changes

#### Function renames (tidyverse style)

All functions now follow `snake_case` naming convention. The old
function names have been removed.

| Removed function | Use instead |
|----|----|
| `house_icon_svg()` | [`icon_house()`](https://strategicprojects.github.io/cardargus/reference/icon_house.md) |
| `building_icon_svg()` | [`icon_building()`](https://strategicprojects.github.io/cardargus/reference/icon_building.md) |
| `construction_icon_svg()` | [`icon_construction()`](https://strategicprojects.github.io/cardargus/reference/icon_construction.md) |
| `map_pin_icon_svg()` | [`icon_map_pin()`](https://strategicprojects.github.io/cardargus/reference/icon_map_pin.md) |
| `money_icon_svg()` | [`icon_money()`](https://strategicprojects.github.io/cardargus/reference/icon_money.md) |
| `badge_svg()` | [`create_badge()`](https://strategicprojects.github.io/cardargus/reference/create_badge.md) |
| `badge_row_svg()` | [`create_badge_row()`](https://strategicprojects.github.io/cardargus/reference/create_badge_row.md) |
| `setup_cardargus_fonts()` | [`setup_fonts()`](https://strategicprojects.github.io/cardargus/reference/setup_fonts.md) |
| `install_cardargus_fonts()` | [`install_fonts()`](https://strategicprojects.github.io/cardargus/reference/install_fonts.md) |
| `cardargus_font_cache_dir()` | [`font_cache_dir()`](https://strategicprojects.github.io/cardargus/reference/font_cache_dir.md) |
| `register_knitr_engine()` | [`register_cardargus_knitr()`](https://strategicprojects.github.io/cardargus/reference/register_cardargus_knitr.md) |

### New features

#### Chrome-based rendering

Added headless Chrome support for superior font rendering via the
`chromote` package.

- [`svg_to_png_chrome()`](https://strategicprojects.github.io/cardargus/reference/svg_to_png_chrome.md) -
  Convert SVG to PNG using headless Chrome
- [`svg_to_pdf_chrome()`](https://strategicprojects.github.io/cardargus/reference/svg_to_pdf_chrome.md) -
  Convert SVG to vector PDF using headless Chrome
- [`chrome_available()`](https://strategicprojects.github.io/cardargus/reference/chrome_available.md) -
  Check if Chrome/Chromium is available
- [`ensure_chrome()`](https://strategicprojects.github.io/cardargus/reference/ensure_chrome.md) -
  Check and optionally download Chrome for Testing
- [`find_chrome_path()`](https://strategicprojects.github.io/cardargus/reference/find_chrome_path.md) -
  Find Chrome executable on the system

#### Chrome auto-download

When Chrome is not installed, use `ensure_chrome(download = TRUE)` to
automatically download “Chrome for Testing” (~150MB). This standalone
Chrome distribution is cached locally and works without system
installation.

#### Improved CLI output

All user-facing messages now use the `cli` package for better
formatting: - Informative error messages with suggestions - Progress
indicators for downloads - Structured output with bullets and formatting

#### Custom SVG support

Made it clearer that you can use your own SVG files for logos and icons:

``` r

# Use any SVG file path for logos
svg_card(
 title = "My Card",
 logos = c("/path/to/logo1.svg", "/path/to/logo2.svg"),
 ...
)

# Or for icons in fields
svg_card(
 title = "My Card",
 fields = list(
   list(list(label = "Name", value = "Test", with_icon = "/path/to/icon.svg"))
 ),
 ...
)
```

#### Enhanced knitr functions

All knitr/Quarto functions now support an `engine` parameter:

- [`include_card()`](https://strategicprojects.github.io/cardargus/reference/include_card.md) -
  Added `engine` parameter
- [`include_card_png()`](https://strategicprojects.github.io/cardargus/reference/include_card_png.md) -
  Added `engine` parameter
- [`save_card_for_knitr()`](https://strategicprojects.github.io/cardargus/reference/save_card_for_knitr.md) -
  Added `engine` parameter
- [`card_to_grob()`](https://strategicprojects.github.io/cardargus/reference/card_to_grob.md) -
  Added `engine` parameter

Engine options: - `"auto"` (default): Uses Chrome if available,
otherwise rsvg - `"chrome"`: Forces Chrome rendering - `"rsvg"`: Forces
rsvg/magick rendering

### Bug fixes

- Fixed duplicate `@font-face` declarations in
  [`embed_svg_fonts()`](https://strategicprojects.github.io/cardargus/reference/embed_svg_fonts.md)
- Fixed double font embedding in
  [`svg_to_formats()`](https://strategicprojects.github.io/cardargus/reference/svg_to_formats.md)
- Now uses modern CSS weight range syntax (`font-weight: 100 900`)
- Removed unused `inst/fonts/` directory

### Deprecated

- `fonts_dir()` - Use
  [`font_cache_dir()`](https://strategicprojects.github.io/cardargus/reference/font_cache_dir.md)
  instead
- [`custom_logo_svg()`](https://strategicprojects.github.io/cardargus/reference/custom_logo_svg.md) -
  Use
  [`load_svg_for_embed()`](https://strategicprojects.github.io/cardargus/reference/load_svg_for_embed.md)
  or pass file paths directly

------------------------------------------------------------------------

## cardargus 0.1.0

### Initial release

#### Card Creation

- [`svg_card()`](https://strategicprojects.github.io/cardargus/reference/svg_card.md) -
  Main function for creating SVG cards with badges, fields, and logos
- Support for Google Fonts via embedded CSS
- Shields.io-style badges with uniform height
- Top-right and bottom-left logo positioning

#### Icons

- [`icon_house()`](https://strategicprojects.github.io/cardargus/reference/icon_house.md) -
  House/home icon
- [`icon_building()`](https://strategicprojects.github.io/cardargus/reference/icon_building.md) -
  Building icon
- [`icon_construction()`](https://strategicprojects.github.io/cardargus/reference/icon_construction.md) -
  Construction icon
- [`icon_map_pin()`](https://strategicprojects.github.io/cardargus/reference/icon_map_pin.md) -
  Location pin icon
- [`icon_money()`](https://strategicprojects.github.io/cardargus/reference/icon_money.md) -
  Money/currency icon

#### Logos

- [`load_svg_for_embed()`](https://strategicprojects.github.io/cardargus/reference/load_svg_for_embed.md) -
  Load and process external SVG files
- [`create_logo_row()`](https://strategicprojects.github.io/cardargus/reference/create_logo_row.md) -
  Create horizontal logo rows
- [`get_svg_path()`](https://strategicprojects.github.io/cardargus/reference/get_svg_path.md) -
  Get paths to bundled SVGs
- [`list_bundled_svgs()`](https://strategicprojects.github.io/cardargus/reference/list_bundled_svgs.md) -
  List available bundled SVGs

#### Export

- [`save_svg()`](https://strategicprojects.github.io/cardargus/reference/save_svg.md) -
  Save card as SVG file
- [`svg_to_png()`](https://strategicprojects.github.io/cardargus/reference/svg_to_png.md) -
  Convert card to PNG
- [`svg_to_png_with_margin()`](https://strategicprojects.github.io/cardargus/reference/svg_to_png_with_margin.md) -
  Convert with margin
- [`batch_svg_to_png()`](https://strategicprojects.github.io/cardargus/reference/batch_svg_to_png.md) -
  Batch convert multiple cards

#### R Markdown / Quarto Integration

- [`include_card()`](https://strategicprojects.github.io/cardargus/reference/include_card.md) -
  Display card inline as SVG
- [`include_card_png()`](https://strategicprojects.github.io/cardargus/reference/include_card_png.md) -
  Display card inline as PNG
- [`save_card_for_knitr()`](https://strategicprojects.github.io/cardargus/reference/save_card_for_knitr.md) -
  Save for knitr::include_graphics()
- [`register_cardargus_knitr()`](https://strategicprojects.github.io/cardargus/reference/register_cardargus_knitr.md) -
  Register custom knitr engine
- [`card_to_grob()`](https://strategicprojects.github.io/cardargus/reference/card_to_grob.md) -
  Convert to grid graphical object

#### Font Management

- [`setup_fonts()`](https://strategicprojects.github.io/cardargus/reference/setup_fonts.md) -
  Quick setup for showtext
- [`register_google_font()`](https://strategicprojects.github.io/cardargus/reference/register_google_font.md) -
  Register Google Fonts
- [`font_available()`](https://strategicprojects.github.io/cardargus/reference/font_available.md) -
  Check font availability
- [`install_fonts()`](https://strategicprojects.github.io/cardargus/reference/install_fonts.md) -
  Install fonts locally
