# Download the extra @font-face blocks needed by a set of code points

Busca a resposta da CSS API e baixa cada bloco cujo `unicode-range`
cubra algum dos code points pedidos (ex. *latin-ext* para "Łódź",
*vietnamese* para "Việt"). Cada bloco é validado por magic bytes e
cacheado como `<key>_blk-<slug>.<ext>` com sidecar `.range` (#29).

## Usage

``` r
download_google_font_blocks(family, codepoints)
```

## Arguments

- family:

  Font family name.

- codepoints:

  Code points ainda não cobertos pelos blocos já embutidos.

## Value

data.frame com colunas `path` e `range` dos blocos obtidos (0 linhas em
falha); blocos cujos ranges não cobrem nenhum code point pedido não são
baixados.
