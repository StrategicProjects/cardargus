# Introduction to cardargus

## What is cardargus?

**cardargus** is an R package for creating informative cards in SVG
format. Cards are self-contained, with all styles, fonts, and graphic
elements embedded in the SVG file itself.

## Installation

``` r

# Install from GitHub
devtools::install_github("castlab/cardargus")
```

``` r

library(cardargus)
```

## Creating your first card

The simplest way to create a card is using the
[`svg_card()`](https://monitoramento.pe.gov.br/cardargus/reference/svg_card.md)
function:

``` r

library(cardargus)

card <- svg_card(
  title = "PROJECT",
  badges_data = list(
    list(label = "Units", value = "192", color = "white"),
    list(label = "Budget", value = "$5.2M", color = "white"),
    list(label = "Status", value = "Active", color = "#4CAF50")
  ),
  fields = list(
    list(
      list(label = "Project Name", value = "Downtown Housing", with_icon = TRUE)
    ),
    list(
      list(label = "Address", value = "123 Main Street, City Center")
    ),
    list(
      list(label = "City", value = "New York"),
      list(label = "State", value = "NY")
    ),
    list(
      list(label = "Developer", value = "ABC Construction"),
      list(label = "Owner", value = "City Housing Authority")
    )
  ),
  bg_color = "#3498db",
  width = 500,
  footer = "Source: Housing Department - January 2026"
)
```

## Displaying cards in R Markdown / Quarto

Use
[`include_card()`](https://monitoramento.pe.gov.br/cardargus/reference/include_card.md)
to display cards inline in your documents:

``` r

# Display card as SVG (best quality)
include_card(card)

# Display card as PNG (better compatibility)
include_card_png(card, dpi = 150)
```

For chunk-based workflow, register the cardargus engine:

``` r

# In setup chunk
register_cardargus_knitr()

# Then use cardargus chunks:
# ```{cardargus}
# svg_card(title = "My Card", ...)
# ```
```

## Saving cards

### As SVG

``` r

save_svg(card, "my_card.svg")
```

### As PNG

``` r

# Standard conversion (uses rsvg)
svg_to_png(card, "my_card.png", dpi = 300)

# Chrome-based conversion (best font rendering)
svg_to_png_chrome(card, "my_card.png", dpi = 300)

# PNG with white background
svg_to_png(card, "my_card.png", dpi = 300, background = "white")
```

### Chrome rendering (recommended)

For **perfect font rendering** with Google Fonts, use headless Chrome:

``` r

# Check if Chrome is available
chrome_available()

# PNG with Chrome (best quality)
svg_to_png_chrome(card, "my_card.png", dpi = 300)

# Vector PDF with Chrome
svg_to_pdf_chrome(card, "my_card.pdf")

# In R Markdown / Quarto
include_card_png(card, dpi = 300, engine = "chrome")
```

Install `chromote` for Chrome support: `install.packages("chromote")`

## Using bundled logos

The package includes several SVG logos ready to use:

``` r

# List available logos
list_bundled_svgs()

# Use in a card
card <- svg_card(
  title = "FAR",
  badges_data = list(...),
  fields = list(...),
  bg_color = "#fab255",
  logos = c(get_svg_path("morar_bem.svg"), get_svg_path("seduh.svg")),
  logos_height = 40,
  bottom_logos = c(get_svg_path("gov_pe3.svg")),
  bottom_logos_height = 35
)
```

## Custom cards

For more control, use
[`svg_card()`](https://monitoramento.pe.gov.br/cardargus/reference/svg_card.md)
directly with all options:

``` r

# Define badges
badges <- list(
  list(label = "Units", value = "500", color = "white"),
  list(label = "Investment", value = "$50M", color = "#4CAF50")
)

# Define fields with custom icons
fields <- list(
  list(
    list(label = "Project", value = "Housing Development", 
         with_icon = icon_building())  # Or use a file path: "/path/to/icon.svg"
  ),
  list(
    list(label = "City", value = "Boston"),
    list(label = "State", value = "MA")
  ),
  list(
    list(label = "Start", value = "Jan/2024"),
    list(label = "End", value = "Dec/2025"),
    list(label = "Progress", value = "45%")
  )
)

# Create card
card <- svg_card(
  title = "HOUSING",
  badges_data = badges,
  fields = fields,
  bg_color = "#2c3e50",
  title_color = "#ecf0f1",
  width = 500
)
```

## Next steps

- [Customizing
  Cards](https://monitoramento.pe.gov.br/cardargus/articles/customization.md) -
  Colors, fonts, and styles
- [Working with
  Badges](https://monitoramento.pe.gov.br/cardargus/articles/badges.md) -
  Shields.io-style badges
- [Icons and
  Logos](https://monitoramento.pe.gov.br/cardargus/articles/icons.md) -
  Using custom icons
- [Font
  Management](https://monitoramento.pe.gov.br/cardargus/articles/fonts.md) -
  Google Fonts integration
- [Export and
  Conversion](https://monitoramento.pe.gov.br/cardargus/articles/export.md) -
  PNG, PDF, and batch processing
