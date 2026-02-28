# Create logo row for top-right corner of card

Takes a list of SVG logos and arranges them horizontally with proper
spacing. Returns the SVG elements positioned for the top-right corner.

## Usage

``` r
create_logo_row(
  logos,
  target_height = 40,
  spacing = 10,
  card_width = 500,
  x_offset = 20,
  y_offset = 20
)
```

## Arguments

- logos:

  List of SVG strings or file paths

- target_height:

  Height for all logos (default 40)

- spacing:

  Horizontal spacing between logos (default 10)

- card_width:

  Total card width to calculate positioning

- x_offset:

  Right margin from card edge

- y_offset:

  Top margin

## Value

A list with svg_content and total_width
