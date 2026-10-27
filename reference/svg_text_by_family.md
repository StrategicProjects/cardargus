# Visible text grouped by the font family that renders it

Para cada nó de texto, resolve a família pelo atributo `font-family` (ou
por `style="font-family:..."`) mais próximo na cadeia ancestor-or-self.
Texto cuja família não pôde ser resolvida (ex. definida via classe CSS)
entra na chave especial `".unresolved"` — o chamador deve atribuí-lo a
todas as famílias. Usado para embutir blocos `@font-face` extras só nas
famílias cujo texto realmente os usa (#29).

## Usage

``` r
svg_text_by_family(svg_content)
```

## Arguments

- svg_content:

  SVG string.

## Value

Lista nomeada família (normalizada) -\> texto, ou `NULL` quando o SVG
não pôde ser parseado (o chamador deve usar o texto global).
