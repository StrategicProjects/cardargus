# Package index

## Card Creation

Main functions for creating SVG cards

- [`svg_card()`](https://monitoramento.pe.gov.br/cardargus/reference/svg_card.md)
  : Create an Information Card in SVG Format

## Badges

Functions for creating shields.io-style badges

- [`create_badge()`](https://monitoramento.pe.gov.br/cardargus/reference/create_badge.md)
  : Create an SVG Badge
- [`create_badge_row()`](https://monitoramento.pe.gov.br/cardargus/reference/create_badge_row.md)
  : Create a row of SVG badges with uniform height

## Icons

SVG icons for use in cards (or use your own SVG file paths)

- [`icon_house()`](https://monitoramento.pe.gov.br/cardargus/reference/icon_house.md)
  : House Icon SVG
- [`icon_building()`](https://monitoramento.pe.gov.br/cardargus/reference/icon_building.md)
  : Building Icon SVG
- [`icon_construction()`](https://monitoramento.pe.gov.br/cardargus/reference/icon_construction.md)
  : Construction Icon SVG
- [`icon_map_pin()`](https://monitoramento.pe.gov.br/cardargus/reference/icon_map_pin.md)
  : Map Pin Icon SVG
- [`icon_money()`](https://monitoramento.pe.gov.br/cardargus/reference/icon_money.md)
  : Dollar/Money Icon SVG

## Logos

Logo and SVG management

- [`load_svg_for_embed()`](https://monitoramento.pe.gov.br/cardargus/reference/load_svg_for_embed.md)
  : Load and process external SVG file for embedding
- [`create_logo_row()`](https://monitoramento.pe.gov.br/cardargus/reference/create_logo_row.md)
  : Create logo row for top-right corner of card
- [`create_bottom_logo_row()`](https://monitoramento.pe.gov.br/cardargus/reference/create_bottom_logo_row.md)
  : Create logo row for bottom-left corner of card
- [`get_svg_path()`](https://monitoramento.pe.gov.br/cardargus/reference/get_svg_path.md)
  : Get path to a bundled SVG file
- [`list_bundled_svgs()`](https://monitoramento.pe.gov.br/cardargus/reference/list_bundled_svgs.md)
  : List available bundled SVG files
- [`svgs_dir()`](https://monitoramento.pe.gov.br/cardargus/reference/svgs_dir.md)
  : Get the path to package SVGs directory

## Fonts

Google Fonts management

- [`setup_fonts()`](https://monitoramento.pe.gov.br/cardargus/reference/setup_fonts.md)
  : Setup showtext for cardargus
- [`install_fonts()`](https://monitoramento.pe.gov.br/cardargus/reference/install_fonts.md)
  : Pre-download fonts for offline use
- [`register_google_font()`](https://monitoramento.pe.gov.br/cardargus/reference/register_google_font.md)
  : Register Google Font (sysfonts)
- [`register_font()`](https://monitoramento.pe.gov.br/cardargus/reference/register_font.md)
  : Register a local font file for embedding
- [`font_available()`](https://monitoramento.pe.gov.br/cardargus/reference/font_available.md)
  : Check if a font is available for embedding
- [`list_fonts()`](https://monitoramento.pe.gov.br/cardargus/reference/list_fonts.md)
  : List registered/cached fonts
- [`font_cache_dir()`](https://monitoramento.pe.gov.br/cardargus/reference/font_cache_dir.md)
  : Get font cache directory
- [`get_font_css()`](https://monitoramento.pe.gov.br/cardargus/reference/get_font_css.md)
  : Get Google Font CSS for embedding in SVG

## Export

Functions for saving and converting cards

- [`save_svg()`](https://monitoramento.pe.gov.br/cardargus/reference/save_svg.md)
  : Save SVG string to file (sanitized + embedded fonts)
- [`svg_to_png()`](https://monitoramento.pe.gov.br/cardargus/reference/svg_to_png.md)
  : Convert SVG to PNG
- [`svg_to_png_with_margin()`](https://monitoramento.pe.gov.br/cardargus/reference/svg_to_png_with_margin.md)
  : Convert SVG to PNG with optional margin and background
- [`svg_to_formats()`](https://monitoramento.pe.gov.br/cardargus/reference/svg_to_formats.md)
  : Convert SVG to multiple formats
- [`batch_svg_to_png()`](https://monitoramento.pe.gov.br/cardargus/reference/batch_svg_to_png.md)
  : Batch convert multiple SVG cards to PNG

## Chrome Rendering

High-fidelity conversion using headless Chrome

- [`svg_to_png_chrome()`](https://monitoramento.pe.gov.br/cardargus/reference/svg_to_png_chrome.md)
  : Convert SVG to PNG using headless Chrome
- [`svg_to_pdf_chrome()`](https://monitoramento.pe.gov.br/cardargus/reference/svg_to_pdf_chrome.md)
  : Convert SVG to PDF using headless Chrome
- [`chrome_available()`](https://monitoramento.pe.gov.br/cardargus/reference/chrome_available.md)
  : Check if Chrome/Chromium is available for rendering
- [`ensure_chrome()`](https://monitoramento.pe.gov.br/cardargus/reference/ensure_chrome.md)
  : Ensure Chrome is available, downloading if necessary
- [`find_chrome_path()`](https://monitoramento.pe.gov.br/cardargus/reference/find_chrome_path.md)
  : Find Chrome executable path

## R Markdown / Quarto

Functions for displaying cards in documents

- [`include_card()`](https://monitoramento.pe.gov.br/cardargus/reference/include_card.md)
  : Display card in knitr/Quarto document (SVG via data URI)
- [`include_card_png()`](https://monitoramento.pe.gov.br/cardargus/reference/include_card_png.md)
  : Display card as PNG in knitr/Quarto document
- [`save_card_for_knitr()`](https://monitoramento.pe.gov.br/cardargus/reference/save_card_for_knitr.md)
  : Save card and return path for knitr
- [`register_cardargus_knitr()`](https://monitoramento.pe.gov.br/cardargus/reference/register_cardargus_knitr.md)
  : Register cardargus knitr engine
- [`card_to_grob()`](https://monitoramento.pe.gov.br/cardargus/reference/card_to_grob.md)
  : Create a grob for grid/ggplot2

## Utilities

Helper functions

- [`is_light_color()`](https://monitoramento.pe.gov.br/cardargus/reference/is_light_color.md)
  : Check if a color is light
- [`compress_number()`](https://monitoramento.pe.gov.br/cardargus/reference/compress_number.md)
  : Compress number to abbreviated format
