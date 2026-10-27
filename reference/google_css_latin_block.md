# Extract the Latin-script @font-face block from a Google CSS response

Devolve URL e `unicode-range` do bloco cujo range cobre o Latin básico
(testa `U+0041`, "A") — pegar a primeira
[`url()`](https://rdrr.io/r/base/connections.html) da resposta devolvia
o subset cirílico como se fosse a fonte completa (#27). Quando nenhum
bloco declara `unicode-range` cobrindo Latin (respostas de bloco único,
ex. subsets via `&text=` ou TTF), vale o primeiro bloco com URL.

## Usage

``` r
google_css_latin_block(css, url_patterns)
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

`list(url =, range =)`; ambos `NA` se nada casar.
