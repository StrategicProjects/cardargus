# One-time quarantine of full fonts cached before 0.3.1

Versões \< 0.3.1 salvavam como fonte "completa" o primeiro bloco
`@font-face` da resposta do Google, que é o subset CIRÍLICO (#27). Esta
migração roda uma única vez por diretório de cache (marker `.cache-v2`)
e move as fontes completas para a subpasta `stale-pre-0.3.1/` — elas
serão re-baixadas sob demanda. Nada é apagado: fontes locais registradas
via
[`register_font()`](https://strategicprojects.github.io/cardargus/reference/register_font.md)
vivem no mesmo diretório com o mesmo padrão de nome e podem ser
restauradas da quarentena (ou re-registradas). Subsets de glifos
("\_sub") não são afetados e ficam no cache.

## Usage

``` r
migrate_font_cache(dir)
```

## Arguments

- dir:

  Diretório de cache de fontes.

## Value

`TRUE` (invisível) se a migração rodou nesta chamada.
