# Bundled SVG Files

This directory contains SVG files bundled with the cardargus package for use as logos and icons.

## Available Files

| File | Description | Original Source |
|------|-------------|-----------------|
| `morar_bem.svg` | Morar Bem Pernambuco program logo | SEDUH/PE |
| `seduh.svg` | SEDUH PE logo (Secretaria de Desenvolvimento Urbano e Habitação) | SEDUH/PE |
| `gov_pe3.svg` | Governo de Pernambuco logo | Governo de PE |
| `tree.svg` | Tree icon/logo | - |
| `example_card.svg` | Example card output | Generated |

## Usage

### Get path to a bundled SVG

```r
library(cardargus)

# Get full path to a specific SVG
path <- get_svg_path("morar_bem.svg")

# List all available SVGs
list_bundled_svgs()
```

### Use in cards

```r
# Use bundled logos in a card
card <- svg_card(
  empreendimento = "My Project",
  # ... other fields ...
  logos = c(get_svg_path("morar_bem.svg"), get_svg_path("seduh.svg")),
  bottom_logos = c(get_svg_path("gov_pe3.svg"))
)
```

### Use with svg_card()

```r
card <- svg_card(
  title = "FAR",
  badges_data = badges,
  fields = fields,
  bg_color = "#fab255",
  logos = c(get_svg_path("morar_bem.svg")),
  logos_height = 40,
  bottom_logos = c(get_svg_path("gov_pe3.svg")),
  bottom_logos_height = 35
)
```

## Adding Custom SVGs

You can also use your own SVG files by providing the full file path:

```r
card <- svg_card(
  # ... fields ...
  logos = c("/path/to/my/logo.svg", get_svg_path("seduh.svg")),
  bottom_logos = c("/path/to/company/logo.svg")
)
```

## Notes

- All bundled SVGs are designed to work well with both light and dark card backgrounds
- SVGs are embedded directly into the card SVG (not linked), making cards self-contained
- The `load_svg_for_embed()` function handles proper scaling and namespace cleanup
