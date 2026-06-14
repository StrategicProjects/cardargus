# Register cardargus knitr engine

Registers a custom knitr engine named `"cardargus"` so that SVG cards
can be rendered directly from chunks.

## Usage

``` r
register_cardargus_knitr()
```

## Value

Invisible NULL.

## Examples

``` r
# In your setup chunk:
register_cardargus_knitr()

# Then use cardargus as chunk engine:
# ```{cardargus}
# svg_card(title = "My Card", ...)
# ```
```
