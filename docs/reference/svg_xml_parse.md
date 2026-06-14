# Parse an SVG string into an xml2 document

Parse an SVG string into an xml2 document

## Usage

``` r
svg_xml_parse(svg_content)
```

## Arguments

- svg_content:

  SVG string (or object coercible to character).

## Value

An `xml_document`, or `NULL` if `xml2` is unavailable or parsing fails
(including editor SVGs with undeclared namespace prefixes).
