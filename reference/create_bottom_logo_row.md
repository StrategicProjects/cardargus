# Create logo row for bottom-left corner of card

Takes a list of SVG logos and arranges them horizontally for the
bottom-left.

## Usage

``` r
create_bottom_logo_row(
  logos,
  target_height = 30,
  spacing = 10,
  x_offset = 20,
  card_height = 400,
  y_offset = 20
)
```

## Arguments

- logos:

  List of SVG strings or file paths

- target_height:

  Height for all logos (default 30)

- spacing:

  Horizontal spacing between logos (default 10)

- x_offset:

  Left margin from card edge

- card_height:

  Total card height for y positioning

- y_offset:

  Bottom margin

## Value

A list with svg_content and total_width
