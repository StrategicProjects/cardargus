# Range sidecar files: remember the unicode-range of a cached font file

Fontes baixadas da CSS API ganham um arquivo `.range` ao lado (o caminho
completo + `.range`, ex. `Jost.woff2.range`) com o conteúdo do
`unicode-range` do bloco de origem. O sidecar marca a PROVENIÊNCIA: só
fontes com `.range` são blocos parciais da CSS API e podem ganhar blocos
extras (#29). Fontes do `gfonts` e locais via
[`register_font()`](https://strategicprojects.github.io/cardargus/reference/register_font.md)
não têm sidecar e são tratadas como completas. O sidecar é POR ARQUIVO
(a extensão fica no nome): registrar um `Jost.ttf` local não altera a
proveniência de um `Jost.woff2` baixado da CSS API que continue no
cache.

## Usage

``` r
font_range_sidecar(font_path)

read_font_range(font_path)

write_font_range(font_path, range)
```

## Arguments

- font_path:

  Caminho do arquivo de fonte cacheado.

- range:

  Conteúdo do `unicode-range` a gravar.

## Value

`read_font_range()`: o range, ou `NA_character_` sem sidecar.
