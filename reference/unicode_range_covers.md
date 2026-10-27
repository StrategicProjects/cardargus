# Does a CSS unicode-range cover a given code point?

Does a CSS unicode-range cover a given code point?

## Usage

``` r
unicode_range_covers(range, codepoint)
```

## Arguments

- range:

  Conteúdo de uma declaração `unicode-range:` (sem o nome da
  propriedade), ex. `"U+0000-00FF, U+0131, U+4??"`.

- codepoint:

  Code point (inteiro) a testar.

## Value

`TRUE` se algum token do range cobre o code point.
