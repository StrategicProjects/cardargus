# sparklines.R - Inline mini-charts (sparklines) for cards

#' Create a sparkline SVG
#'
#' Generates a small, self-contained SVG mini-chart (line, area or bars) from a
#' numeric vector. The result is a plain SVG string that can be embedded
#' anywhere [svg_card()] accepts raw SVG content: the `with_icon` field slot,
#' `logos` or `bottom_logos`.
#'
#' @param values Numeric vector with the series to plot (no missing values).
#'   Line and area sparklines need at least 2 points; bars need at least 1.
#' @param width Total width of the sparkline in pixels.
#' @param height Total height of the sparkline in pixels.
#' @param color Stroke/fill color (any SVG color, e.g. "white" or "#0ea5e9").
#' @param type Chart type: `"line"` (default), `"area"` or `"bar"`.
#' @param stroke_width Line thickness in pixels (line/area types).
#' @param fill_opacity Fill opacity for the area under the curve (`"area"`) and
#'   for the bars (`"bar"`).
#' @param show_last_point Draw a dot on the last point (line/area types).
#' @param padding Inner padding in pixels so strokes/dots are not clipped.
#' @return A character string with a standalone `<svg>` element.
#' @export
#' @examples
#' # A line sparkline used as a field icon in a card
#' spark <- create_sparkline(c(3, 5, 2, 8, 7), color = "white")
#' fields <- list(
#'   list(list(label = "Tendência", value = "Alta", with_icon = spark))
#' )
#' svg <- svg_card("Vendas", fields = fields, show_viewer = FALSE)
#'
#' # Area and bar variants
#' create_sparkline(c(1, 4, 2, 6), type = "area", color = "#0ea5e9")
#' create_sparkline(c(5, 2, 8, 3, 7), type = "bar", color = "white")
create_sparkline <- function(values,
                             width = 120,
                             height = 36,
                             color = "white",
                             type = c("line", "area", "bar"),
                             stroke_width = 2,
                             fill_opacity = 0.3,
                             show_last_point = TRUE,
                             padding = 3) {
  type <- match.arg(type)

  if (is.null(values) || !is.numeric(values) || !length(values) || anyNA(values)) {
    cli::cli_abort(
      "{.arg values} must be a non-empty numeric vector without missing values."
    )
  }
  min_points <- if (type == "bar") 1L else 2L
  if (length(values) < min_points) {
    cli::cli_abort(
      "A {.val {type}} sparkline needs at least {min_points} value{?s}."
    )
  }
  if (!is.numeric(width) || length(width) != 1 || is.na(width) || width <= 0 ||
      !is.numeric(height) || length(height) != 1 || is.na(height) || height <= 0) {
    cli::cli_abort("{.arg width} and {.arg height} must be positive numbers.")
  }

  n <- length(values)
  inner_w <- width - 2 * padding
  inner_h <- height - 2 * padding
  baseline_y <- height - padding

  header <- sprintf(
    '<svg xmlns="http://www.w3.org/2000/svg" width="%.0f" height="%.0f" viewBox="0 0 %.0f %.0f" aria-hidden="true">',
    width, height, width, height
  )

  if (type == "bar") {
    # Barras escalam a partir de zero (ou do mínimo, se houver valores negativos).
    lo <- min(0, min(values))
    hi <- max(values, 0)
    span <- hi - lo
    slot_w <- inner_w / n
    bar_w <- slot_w * 0.75

    rects <- vapply(seq_len(n), function(i) {
      h <- if (span == 0) 1 else inner_h * (values[i] - lo) / span
      h <- max(h, 1)  # barra de valor zero ainda aparece como traço
      x <- padding + (i - 1) * slot_w + (slot_w - bar_w) / 2
      sprintf(
        '<rect x="%.2f" y="%.2f" width="%.2f" height="%.2f" fill="%s" fill-opacity="%.2f"/>',
        x, baseline_y - h, bar_w, h, color, fill_opacity
      )
    }, character(1))

    return(paste0(header, paste(rects, collapse = ""), "</svg>"))
  }

  # Line / area: pontos igualmente espaçados, y invertido (SVG cresce p/ baixo).
  rng <- range(values)
  span <- rng[2] - rng[1]
  xs <- padding + inner_w * (seq_len(n) - 1) / (n - 1)
  ys <- if (span == 0) {
    rep(height / 2, n)
  } else {
    padding + inner_h * (rng[2] - values) / span
  }
  points <- paste(sprintf("%.2f,%.2f", xs, ys), collapse = " ")

  parts <- character()

  if (type == "area") {
    area_points <- paste(
      points,
      sprintf("%.2f,%.2f", xs[n], baseline_y),
      sprintf("%.2f,%.2f", xs[1], baseline_y)
    )
    parts <- c(parts, sprintf(
      '<polygon points="%s" fill="%s" fill-opacity="%.2f" stroke="none"/>',
      area_points, color, fill_opacity
    ))
  }

  parts <- c(parts, sprintf(
    '<polyline points="%s" fill="none" stroke="%s" stroke-width="%.2f" stroke-linecap="round" stroke-linejoin="round"/>',
    points, color, stroke_width
  ))

  if (isTRUE(show_last_point)) {
    parts <- c(parts, sprintf(
      '<circle cx="%.2f" cy="%.2f" r="%.2f" fill="%s"/>',
      xs[n], ys[n], stroke_width * 1.5, color
    ))
  }

  paste0(header, paste(parts, collapse = ""), "</svg>")
}
