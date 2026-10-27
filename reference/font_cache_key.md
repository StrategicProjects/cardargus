# Sanitize a font family name into its cache key

Todo caminho de cache (primário, subsets `_sub`, blocos `_blk-` e
sidecars `.range`) deriva DESTA mesma chave — mudanças aqui realinham
todos os arquivos de uma vez.

## Usage

``` r
font_cache_key(family)
```

## Arguments

- family:

  Font family name.

## Value

Chave estável para nomes de arquivo.
