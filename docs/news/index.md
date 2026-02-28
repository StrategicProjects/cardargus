# Changelog

## cardargus 0.2.0

CRAN release: 2026-01-31

### Breaking changes

#### Function renames (tidyverse style)

All functions now follow `snake_case` naming convention. The old
function names have been removed.

| Removed function | Use instead |
|----|----|
| `house_icon_svg()` | [`icon_house()`](https://monitoramento.pe.gov.br/cardargus/reference/icon_house.md) |
| `building_icon_svg()` | [`icon_building()`](https://monitoramento.pe.gov.br/cardargus/reference/icon_building.md) |
| `construction_icon_svg()` | [`icon_construction()`](https://monitoramento.pe.gov.br/cardargus/reference/icon_construction.md) |
| `map_pin_icon_svg()` | [`icon_map_pin()`](https://monitoramento.pe.gov.br/cardargus/reference/icon_map_pin.md) |
| `money_icon_svg()` | [`icon_money()`](https://monitoramento.pe.gov.br/cardargus/reference/icon_money.md) |
| `badge_svg()` | [`create_badge()`](https://monitoramento.pe.gov.br/cardargus/reference/create_badge.md) |
| `badge_row_svg()` | [`create_badge_row()`](https://monitoramento.pe.gov.br/cardargus/reference/create_badge_row.md) |
| `setup_cardargus_fonts()` | [`setup_fonts()`](https://monitoramento.pe.gov.br/cardargus/reference/setup_fonts.md) |
| `install_cardargus_fonts()` | [`install_fonts()`](https://monitoramento.pe.gov.br/cardargus/reference/install_fonts.md) |
| `cardargus_font_cache_dir()` | [`font_cache_dir()`](https://monitoramento.pe.gov.br/cardargus/reference/font_cache_dir.md) |
| `register_knitr_engine()` | [`register_cardargus_knitr()`](https://monitoramento.pe.gov.br/cardargus/reference/register_cardargus_knitr.md) |

### New features

#### Chrome-based rendering

Added headless Chrome support for superior font rendering via the
`chromote` package.

- [`svg_to_png_chrome()`](https://monitoramento.pe.gov.br/cardargus/reference/svg_to_png_chrome.md) -
  Convert SVG to PNG using headless Chrome
- [`svg_to_pdf_chrome()`](https://monitoramento.pe.gov.br/cardargus/reference/svg_to_pdf_chrome.md) -
  Convert SVG to vector PDF using headless Chrome
- [`chrome_available()`](https://monitoramento.pe.gov.br/cardargus/reference/chrome_available.md) -
  Check if Chrome/Chromium is available
- [`ensure_chrome()`](https://monitoramento.pe.gov.br/cardargus/reference/ensure_chrome.md) -
  Check and optionally download Chrome for Testing
- [`find_chrome_path()`](https://monitoramento.pe.gov.br/cardargus/reference/find_chrome_path.md) -
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

- [`include_card()`](https://monitoramento.pe.gov.br/cardargus/reference/include_card.md) -
  Added `engine` parameter
- [`include_card_png()`](https://monitoramento.pe.gov.br/cardargus/reference/include_card_png.md) -
  Added `engine` parameter
- [`save_card_for_knitr()`](https://monitoramento.pe.gov.br/cardargus/reference/save_card_for_knitr.md) -
  Added `engine` parameter
- [`card_to_grob()`](https://monitoramento.pe.gov.br/cardargus/reference/card_to_grob.md) -
  Added `engine` parameter

Engine options: - `"auto"` (default): Uses Chrome if available,
otherwise rsvg - `"chrome"`: Forces Chrome rendering - `"rsvg"`: Forces
rsvg/magick rendering

### Bug fixes

- Fixed duplicate `@font-face` declarations in
  [`embed_svg_fonts()`](https://monitoramento.pe.gov.br/cardargus/reference/embed_svg_fonts.md)
- Fixed double font embedding in
  [`svg_to_formats()`](https://monitoramento.pe.gov.br/cardargus/reference/svg_to_formats.md)
- Now uses modern CSS weight range syntax (`font-weight: 100 900`)
- Removed unused `inst/fonts/` directory

### Deprecated

- `fonts_dir()` - Use
  [`font_cache_dir()`](https://monitoramento.pe.gov.br/cardargus/reference/font_cache_dir.md)
  instead
- [`custom_logo_svg()`](https://monitoramento.pe.gov.br/cardargus/reference/custom_logo_svg.md) -
  Use
  [`load_svg_for_embed()`](https://monitoramento.pe.gov.br/cardargus/reference/load_svg_for_embed.md)
  or pass file paths directly

------------------------------------------------------------------------

## cardargus 0.1.0

### Initial release

#### Card Creation

- [`svg_card()`](https://monitoramento.pe.gov.br/cardargus/reference/svg_card.md) -
  Main function for creating SVG cards with badges, fields, and logos
- Support for Google Fonts via embedded CSS
- Shields.io-style badges with uniform height
- Top-right and bottom-left logo positioning

#### Icons

- [`icon_house()`](https://monitoramento.pe.gov.br/cardargus/reference/icon_house.md) -
  House/home icon
- [`icon_building()`](https://monitoramento.pe.gov.br/cardargus/reference/icon_building.md) -
  Building icon
- [`icon_construction()`](https://monitoramento.pe.gov.br/cardargus/reference/icon_construction.md) -
  Construction icon
- [`icon_map_pin()`](https://monitoramento.pe.gov.br/cardargus/reference/icon_map_pin.md) -
  Location pin icon
- [`icon_money()`](https://monitoramento.pe.gov.br/cardargus/reference/icon_money.md) -
  Money/currency icon

#### Logos

- [`load_svg_for_embed()`](https://monitoramento.pe.gov.br/cardargus/reference/load_svg_for_embed.md) -
  Load and process external SVG files
- [`create_logo_row()`](https://monitoramento.pe.gov.br/cardargus/reference/create_logo_row.md) -
  Create horizontal logo rows
- [`get_svg_path()`](https://monitoramento.pe.gov.br/cardargus/reference/get_svg_path.md) -
  Get paths to bundled SVGs
- [`list_bundled_svgs()`](https://monitoramento.pe.gov.br/cardargus/reference/list_bundled_svgs.md) -
  List available bundled SVGs

#### Export

- [`save_svg()`](https://monitoramento.pe.gov.br/cardargus/reference/save_svg.md) -
  Save card as SVG file
- [`svg_to_png()`](https://monitoramento.pe.gov.br/cardargus/reference/svg_to_png.md) -
  Convert card to PNG
- [`svg_to_png_with_margin()`](https://monitoramento.pe.gov.br/cardargus/reference/svg_to_png_with_margin.md) -
  Convert with margin
- [`batch_svg_to_png()`](https://monitoramento.pe.gov.br/cardargus/reference/batch_svg_to_png.md) -
  Batch convert multiple cards

#### R Markdown / Quarto Integration

- [`include_card()`](https://monitoramento.pe.gov.br/cardargus/reference/include_card.md) -
  Display card inline as SVG
- [`include_card_png()`](https://monitoramento.pe.gov.br/cardargus/reference/include_card_png.md) -
  Display card inline as PNG
- [`save_card_for_knitr()`](https://monitoramento.pe.gov.br/cardargus/reference/save_card_for_knitr.md) -
  Save for knitr::include_graphics()
- [`register_cardargus_knitr()`](https://monitoramento.pe.gov.br/cardargus/reference/register_cardargus_knitr.md) -
  Register custom knitr engine
- [`card_to_grob()`](https://monitoramento.pe.gov.br/cardargus/reference/card_to_grob.md) -
  Convert to grid graphical object

#### Font Management

- [`setup_fonts()`](https://monitoramento.pe.gov.br/cardargus/reference/setup_fonts.md) -
  Quick setup for showtext
- [`register_google_font()`](https://monitoramento.pe.gov.br/cardargus/reference/register_google_font.md) -
  Register Google Fonts
- [`font_available()`](https://monitoramento.pe.gov.br/cardargus/reference/font_available.md) -
  Check font availability
- [`install_fonts()`](https://monitoramento.pe.gov.br/cardargus/reference/install_fonts.md) -
  Install fonts locally
