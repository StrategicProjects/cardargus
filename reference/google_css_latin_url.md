# Extract the Latin-script font URL from a Google Fonts CSS response

O Google divide a resposta da CSS API em um bloco `@font-face` por
script (cyrillic-ext, cyrillic, ..., latin), com o cirílico PRIMEIRO.
Pegar a primeira [`url()`](https://rdrr.io/r/base/connections.html) da
resposta devolvia o subset cirílico como se fosse a fonte completa
(#27). Este helper examina todos os blocos e devolve a URL do bloco cujo
`unicode-range` cobre o Latin básico (testa `U+0041`, "A"). Quando
nenhum bloco declara `unicode-range` cobrindo Latin (respostas de bloco
único, ex. subsets via `&text=` ou TTF), vale a primeira URL.

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
  esconde o bloco latin).

## Value

A URL da fonte, ou `NA_character_`.
