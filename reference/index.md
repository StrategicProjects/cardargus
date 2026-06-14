# Package index

## Card Creation

Main functions for creating SVG cards

- [`svg_card()`](https://strategicprojects.github.io/cardargus/reference/svg_card.md)
  : Create an Information Card in SVG Format

## Badges

Functions for creating shields.io-style badges

- [`create_badge()`](https://strategicprojects.github.io/cardargus/reference/create_badge.md)
  : Create an SVG Badge
- [`create_badge_row()`](https://strategicprojects.github.io/cardargus/reference/create_badge_row.md)
  : Create a row of SVG badges with uniform height

## Icons

SVG icons for use in cards (or use your own SVG file paths)

- [`icon_house()`](https://strategicprojects.github.io/cardargus/reference/icon_house.md)
  : House Icon SVG
- [`icon_building()`](https://strategicprojects.github.io/cardargus/reference/icon_building.md)
  : Building Icon SVG
- [`icon_construction()`](https://strategicprojects.github.io/cardargus/reference/icon_construction.md)
  : Construction Icon SVG
- [`icon_map_pin()`](https://strategicprojects.github.io/cardargus/reference/icon_map_pin.md)
  : Map Pin Icon SVG
- [`icon_money()`](https://strategicprojects.github.io/cardargus/reference/icon_money.md)
  : Dollar/Money Icon SVG

## Logos

Logo and SVG management

- [`load_svg_for_embed()`](https://strategicprojects.github.io/cardargus/reference/load_svg_for_embed.md)
  : Load and process external SVG file for embedding
- [`create_logo_row()`](https://strategicprojects.github.io/cardargus/reference/create_logo_row.md)
  : Create logo row for top-right corner of card
- [`create_bottom_logo_row()`](https://strategicprojects.github.io/cardargus/reference/create_bottom_logo_row.md)
  : Create logo row for bottom-left corner of card
- [`get_svg_path()`](https://strategicprojects.github.io/cardargus/reference/get_svg_path.md)
  : Get path to a bundled SVG file
- [`list_bundled_svgs()`](https://strategicprojects.github.io/cardargus/reference/list_bundled_svgs.md)
  : List available bundled SVG files
- [`svgs_dir()`](https://strategicprojects.github.io/cardargus/reference/svgs_dir.md)
  : Get the path to package SVGs directory

## Fonts

Google Fonts management

- [`setup_fonts()`](https://strategicprojects.github.io/cardargus/reference/setup_fonts.md)
  : Setup showtext for cardargus
- [`install_fonts()`](https://strategicprojects.github.io/cardargus/reference/install_fonts.md)
  : Pre-download fonts for offline use
- [`register_google_font()`](https://strategicprojects.github.io/cardargus/reference/register_google_font.md)
  : Register Google Font (sysfonts)
- [`register_font()`](https://strategicprojects.github.io/cardargus/reference/register_font.md)
  : Register a local font file for embedding
- [`font_available()`](https://strategicprojects.github.io/cardargus/reference/font_available.md)
  : Check if a font is available for embedding
- [`list_fonts()`](https://strategicprojects.github.io/cardargus/reference/list_fonts.md)
  : List registered/cached fonts
- [`font_cache_dir()`](https://strategicprojects.github.io/cardargus/reference/font_cache_dir.md)
  : Get font cache directory
- [`get_font_css()`](https://strategicprojects.github.io/cardargus/reference/get_font_css.md)
  : Get Google Font CSS for embedding in SVG

## Export

Functions for saving and converting cards

- [`save_svg()`](https://strategicprojects.github.io/cardargus/reference/save_svg.md)
  : Save SVG string to file (sanitized + embedded fonts)
- [`svg_to_png()`](https://strategicprojects.github.io/cardargus/reference/svg_to_png.md)
  : Convert SVG to PNG
- [`svg_to_png_with_margin()`](https://strategicprojects.github.io/cardargus/reference/svg_to_png_with_margin.md)
  : Convert SVG to PNG with optional margin and background
- [`svg_to_formats()`](https://strategicprojects.github.io/cardargus/reference/svg_to_formats.md)
  : Convert SVG to multiple formats
- [`batch_svg_to_png()`](https://strategicprojects.github.io/cardargus/reference/batch_svg_to_png.md)
  : Batch convert multiple SVG cards to PNG

## Chrome Rendering

High-fidelity conversion using headless Chrome

- [`svg_to_png_chrome()`](https://strategicprojects.github.io/cardargus/reference/svg_to_png_chrome.md)
  : Convert SVG to PNG using headless Chrome
- [`svg_to_pdf_chrome()`](https://strategicprojects.github.io/cardargus/reference/svg_to_pdf_chrome.md)
  : Convert SVG to PDF using headless Chrome
- [`chrome_available()`](https://strategicprojects.github.io/cardargus/reference/chrome_available.md)
  : Check if Chrome/Chromium is available for rendering
- [`ensure_chrome()`](https://strategicprojects.github.io/cardargus/reference/ensure_chrome.md)
  : Ensure Chrome is available, downloading if necessary
- [`find_chrome_path()`](https://strategicprojects.github.io/cardargus/reference/find_chrome_path.md)
  : Find Chrome executable path
- [`batch_svg_to_base64_chrome()`](https://strategicprojects.github.io/cardargus/reference/batch_svg_to_base64_chrome.md)
  : Batch convert SVGs to PNG base64 using headless Chrome
- [`batch_svg_to_png_chrome()`](https://strategicprojects.github.io/cardargus/reference/batch_svg_to_png_chrome.md)
  : Batch convert SVGs to PNG files using headless Chrome

## R Markdown / Quarto

Functions for displaying cards in documents

- [`include_card()`](https://strategicprojects.github.io/cardargus/reference/include_card.md)
  : Display card in knitr/Quarto document (SVG via data URI)
- [`include_card_png()`](https://strategicprojects.github.io/cardargus/reference/include_card_png.md)
  : Display card as PNG in knitr/Quarto document
- [`save_card_for_knitr()`](https://strategicprojects.github.io/cardargus/reference/save_card_for_knitr.md)
  : Save card and return path for knitr
- [`register_cardargus_knitr()`](https://strategicprojects.github.io/cardargus/reference/register_cardargus_knitr.md)
  : Register cardargus knitr engine
- [`card_to_grob()`](https://strategicprojects.github.io/cardargus/reference/card_to_grob.md)
  : Create a grob for grid/ggplot2

## Utilities

Helper functions

- [`is_light_color()`](https://strategicprojects.github.io/cardargus/reference/is_light_color.md)
  : Check if a color is light
- [`compress_number()`](https://strategicprojects.github.io/cardargus/reference/compress_number.md)
  : Compress number to abbreviated format
