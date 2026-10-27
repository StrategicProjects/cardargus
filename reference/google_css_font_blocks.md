# Parse the @font-face blocks of a Google Fonts CSS response

O Google divide a resposta da CSS API em um bloco `@font-face` por
script (cyrillic-ext, cyrillic, ..., latin, latin-ext, vietnamese...),
cada um precedido por um comentário `/* nome-do-subset */` e com seu
próprio `unicode-range`. Este helper devolve um data.frame com uma linha
por bloco que tenha URL extraível: `url`, `range` (conteúdo do
`unicode-range`, ou `NA` em respostas de bloco único, ex. subsets via
`&text=`) e `subset` (nome do comentário, ou `NA`).

## Usage

``` r
google_css_font_blocks(css, url_patterns)
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

data.frame com colunas `url`, `range`, `subset` (0 linhas se nada
casar).
