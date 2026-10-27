# Which code points does a CSS unicode-range cover?

Faz o parsing dos tokens UMA vez (em vetores lo/hi) e testa todos os
code points contra eles;
[`unicode_range_covers()`](https://strategicprojects.github.io/cardargus/reference/unicode_range_covers.md)
é o wrapper escalar.

## Usage

``` r
unicode_range_covers_v(range, codepoints)
```

## Arguments

- range:

  Conteúdo de uma declaração `unicode-range:`.

- codepoints:

  Vetor de code points (inteiros).

## Value

Vetor lógico paralelo a `codepoints`.
