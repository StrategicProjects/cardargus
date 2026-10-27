# Cache slug for an extra @font-face block

Cache slug for an extra @font-face block

## Usage

``` r
font_block_slug(subset, range)
```

## Arguments

- subset:

  Nome do subset no comentário do bloco (`"latin-ext"` etc.), ou `NA`.

- range:

  `unicode-range` do bloco (usado como fallback, via hash).

## Value

Slug estável para compor o nome do arquivo em cache.
