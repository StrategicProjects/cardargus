# Resolve the extra @font-face blocks a text needs beyond the primary font

A fonte "completa" baixada da CSS API cobre só o bloco *latin* (#29).
Dado o arquivo primário em cache e os code points usados no SVG, devolve
os blocos extras (cacheados ou baixados) cujos `unicode-range` cobrem o
que o primário não cobre. Só age quando o primário tem sidecar `.range`
— sem sidecar a fonte veio do `gfonts` ou de
[`register_font()`](https://strategicprojects.github.io/cardargus/reference/register_font.md)
e é tratada como completa, para nunca sobrepor glifos de uma fonte local
do usuário.

## Usage

``` r
ensure_font_extra_blocks(family, primary_path, codepoints)
```

## Arguments

- family:

  Font family name.

- primary_path:

  Caminho do arquivo primário em cache.

- codepoints:

  Code points usados no texto do SVG (não-ASCII).

## Value

data.frame com colunas `path` e `range` (0 linhas quando nada é preciso
ou possível).
