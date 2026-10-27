# Extract the Latin-script font URL from a Google Fonts CSS response

Wrapper de
[`google_css_latin_block()`](https://strategicprojects.github.io/cardargus/reference/google_css_latin_block.md)
que devolve só a URL.

## Usage

``` r
google_css_latin_url(css, url_patterns)
```

## Arguments

- css:

  Resposta CSS da Google Fonts API.

- url_patterns:

  Um ou mais regexes, cada um com um grupo de captura extraindo a URL da
  fonte de dentro de um bloco; em cada bloco, vale o primeiro padrão que
  casar (assim uma resposta misturando estilos de URL entre blocos não
  esconde nenhum bloco).

## Value

A URL da fonte, ou `NA_character_`.
