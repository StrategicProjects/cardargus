# Create (or customize) a card theme

A theme is a named list of defaults for the visual arguments of
[`svg_card()`](https://strategicprojects.github.io/cardargus/reference/svg_card.md):
`bg_color`, `font`, `title_color`, `label_color`, `value_bg_color`,
`value_text_color`, `value_border_color` and `footer_color`. Arguments
set explicitly in the
[`svg_card()`](https://strategicprojects.github.io/cardargus/reference/svg_card.md)
call always win over the theme.

## Usage

``` r
card_theme(name = "default", ...)
```

## Arguments

- name:

  Name of a preset theme (see
  [`card_themes()`](https://strategicprojects.github.io/cardargus/reference/card_themes.md))
  or an existing theme object to use as base.

- ...:

  Named theme components overriding the base theme (e.g.
  `bg_color = "#123456"`).

## Value

An object of class `cardargus_theme`.

## Examples

``` r
card_theme("dark")
#> 
#> ── cardargus theme 
#> bg_color: "#1e1e2e"
#> font: "NULL"
#> title_color: "#cdd6f4"
#> label_color: "#a6adc8"
#> value_bg_color: "#313244"
#> value_text_color: "#cdd6f4"
#> value_border_color: "#45475a"
#> footer_color: "#7f849c"

# Customize a preset
my_theme <- card_theme("ocean", footer_color = "#cceeff")

# Use it in a card
svg <- svg_card("FAR", theme = my_theme, show_viewer = FALSE)
```
