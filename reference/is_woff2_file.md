# Is a file a WOFF2 font?

Confere os magic bytes (`wOF2`) para não cachear como fonte uma página
de erro HTML que tenha passado pela checagem de tamanho.

## Usage

``` r
is_woff2_file(path)
```

## Arguments

- path:

  Caminho do arquivo.

## Value

`TRUE` se o arquivo começa com a assinatura WOFF2.
