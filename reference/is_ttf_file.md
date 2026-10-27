# Is a file a TTF/OTF font?

Confere os magic bytes de fontes sfnt: `00 01 00 00` (TrueType), `true`
(TrueType Mac), `ttcf` (collection) ou `OTTO` (OpenType/CFF). Mesmo
papel de
[`is_woff2_file()`](https://strategicprojects.github.io/cardargus/reference/is_woff2_file.md)
para o fallback TTF.

## Usage

``` r
is_ttf_file(path)
```

## Arguments

- path:

  Caminho do arquivo.

## Value

`TRUE` se o arquivo começa com uma assinatura sfnt conhecida.
