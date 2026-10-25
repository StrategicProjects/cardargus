# themes.R - Preset visual themes for svg_card()

# Registro interno de temas. Cada tema fornece defaults para os argumentos
# visuais de svg_card(); o que o usuário passar explicitamente sempre vence.
# `font = NULL` significa "não mexer na fonte" (fica o default de svg_card()
# ou o que o usuário passar).
.cardargus_themes <- list(
  default = list(
    bg_color           = "#fab255",
    font               = NULL,
    title_color        = "white",
    label_color        = "white",
    value_bg_color     = "#f8f8ff",
    value_text_color   = "#212529",
    value_border_color = "#dee2e6",
    footer_color       = "white"
  ),
  light = list(
    bg_color           = "#f8f9fa",
    font               = NULL,
    title_color        = "#212529",
    label_color        = "#495057",
    value_bg_color     = "#ffffff",
    value_text_color   = "#212529",
    value_border_color = "#dee2e6",
    footer_color       = "#6c757d"
  ),
  dark = list(
    bg_color           = "#1e1e2e",
    font               = NULL,
    title_color        = "#cdd6f4",
    label_color        = "#a6adc8",
    value_bg_color     = "#313244",
    value_text_color   = "#cdd6f4",
    value_border_color = "#45475a",
    footer_color       = "#7f849c"
  ),
  slate = list(
    bg_color           = "linear-gradient(135deg, #334155, #0f172a)",
    font               = NULL,
    title_color        = "white",
    label_color        = "#cbd5e1",
    value_bg_color     = "#1e293b",
    value_text_color   = "#e2e8f0",
    value_border_color = "#475569",
    footer_color       = "#94a3b8"
  ),
  ocean = list(
    bg_color           = "linear-gradient(135deg, #0284c7, #1e3a8a)",
    font               = NULL,
    title_color        = "white",
    label_color        = "white",
    value_bg_color     = "#f0f9ff",
    value_text_color   = "#0c4a6e",
    value_border_color = "#bae6fd",
    footer_color       = "white"
  ),
  forest = list(
    bg_color           = "linear-gradient(to right, #1a5a3a, #2e7d32)",
    font               = NULL,
    title_color        = "white",
    label_color        = "white",
    value_bg_color     = "#f1f8e9",
    value_text_color   = "#1b5e20",
    value_border_color = "#c5e1a5",
    footer_color       = "white"
  ),
  sunset = list(
    bg_color           = "linear-gradient(135deg, #f59e0b, #dc2626)",
    font               = NULL,
    title_color        = "white",
    label_color        = "white",
    value_bg_color     = "#fff7ed",
    value_text_color   = "#7c2d12",
    value_border_color = "#fed7aa",
    footer_color       = "white"
  ),
  violet = list(
    bg_color           = "linear-gradient(135deg, #667eea, #764ba2)",
    font               = NULL,
    title_color        = "white",
    label_color        = "white",
    value_bg_color     = "#f5f3ff",
    value_text_color   = "#4c1d95",
    value_border_color = "#ddd6fe",
    footer_color       = "white"
  )
)

#' List available preset card themes
#'
#' @return Character vector with the names of the preset themes accepted by
#'   [card_theme()] and by the `theme` argument of [svg_card()].
#' @export
#' @examples
#' card_themes()
card_themes <- function() {
  names(.cardargus_themes)
}

#' Create (or customize) a card theme
#'
#' A theme is a named list of defaults for the visual arguments of
#' [svg_card()]: `bg_color`, `font`, `title_color`, `label_color`,
#' `value_bg_color`, `value_text_color`, `value_border_color` and
#' `footer_color`. Arguments set explicitly in the [svg_card()] call always
#' win over the theme.
#'
#' @param name Name of a preset theme (see [card_themes()]) or an existing
#'   theme object to use as base.
#' @param ... Named theme components overriding the base theme
#'   (e.g. `bg_color = "#123456"`).
#' @return An object of class `cardargus_theme`.
#' @export
#' @examples
#' card_theme("dark")
#'
#' # Customize a preset
#' my_theme <- card_theme("ocean", footer_color = "#cceeff")
#'
#' # Use it in a card
#' svg <- svg_card("FAR", theme = my_theme, show_viewer = FALSE)
card_theme <- function(name = "default", ...) {
  if (inherits(name, "cardargus_theme")) {
    base <- unclass(name)
  } else {
    if (!is.character(name) || length(name) != 1 || is.na(name)) {
      cli::cli_abort(
        "{.arg name} must be a single theme name. See {.fn card_themes}."
      )
    }
    key <- tolower(name)
    if (!key %in% names(.cardargus_themes)) {
      cli::cli_abort(c(
        "x" = "Unknown theme {.val {name}}.",
        "i" = "Available themes: {.val {card_themes()}}."
      ))
    }
    base <- .cardargus_themes[[key]]
  }

  overrides <- list(...)
  if (length(overrides)) {
    nms <- names(overrides)
    if (is.null(nms) || any(!nzchar(nms))) {
      cli::cli_abort("All theme components passed via {.arg ...} must be named.")
    }
    unknown <- setdiff(nms, names(base))
    if (length(unknown)) {
      cli::cli_abort(c(
        "x" = "Unknown theme component{?s}: {.val {unknown}}.",
        "i" = "Valid components: {.val {names(base)}}."
      ))
    }
    base[nms] <- overrides
  }

  structure(base, class = "cardargus_theme")
}

#' @export
print.cardargus_theme <- function(x, ...) {
  cli::cli_h3("cardargus theme")
  for (nm in names(x)) {
    val <- if (is.null(x[[nm]])) "NULL" else as.character(x[[nm]])
    cli::cli_text("{.field {nm}}: {.val {val}}")
  }
  invisible(x)
}
