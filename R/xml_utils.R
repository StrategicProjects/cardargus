# xml_utils.R - Robust SVG parsing helpers.
#
# Reading geometry and fonts out of arbitrary SVG strings with regular
# expressions is fragile: attribute order, single vs double quotes, units
# (`px`, `%`), whitespace and multiline tags all break naive patterns. These
# helpers parse with `xml2` when it is available and the document is
# well-formed, and fall back to the original regex behaviour otherwise (e.g.
# `xml2` not installed, or editor SVGs with undeclared namespace prefixes).

#' Extract the leading number from a dimension string
#'
#' @param x A character such as `"500"`, `"40px"`, `"100%"`, or `NA`.
#' @return Numeric value, or `NA_real_` if none is found.
#' @keywords internal
num_lead <- function(x) {
  if (length(x) != 1 || is.na(x) || !nzchar(x)) return(NA_real_)
  suppressWarnings(as.numeric(sub(".*?([0-9.]+).*", "\\1", x)))
}

#' Parse a viewBox string into width/height
#'
#' @param vb A viewBox string `"minx miny width height"` or `NA`.
#' @return Numeric vector `c(width, height)`, possibly `c(NA, NA)`.
#' @keywords internal
parse_viewbox <- function(vb) {
  if (length(vb) != 1 || is.na(vb) || !nzchar(vb)) return(c(NA_real_, NA_real_))
  parts <- suppressWarnings(as.numeric(strsplit(trimws(vb), "[ ,]+")[[1]]))
  if (length(parts) == 4 && all(!is.na(parts))) return(parts[3:4])
  c(NA_real_, NA_real_)
}

#' Parse an SVG string into an xml2 document
#'
#' @param svg_content SVG string (or object coercible to character).
#' @return An `xml_document`, or `NULL` if `xml2` is unavailable or parsing
#'   fails (including editor SVGs with undeclared namespace prefixes).
#' @keywords internal
svg_xml_parse <- function(svg_content) {
  if (!requireNamespace("xml2", quietly = TRUE)) return(NULL)
  svg <- as.character(svg_content)
  if (length(svg) != 1 || is.na(svg) || !nzchar(svg)) return(NULL)
  # Editor SVGs (Inkscape) may use undeclared namespace prefixes
  # (sodipodi:, inkscape:), which strict parsing rejects. Retry in libxml2
  # RECOVER mode and silence its warnings; on any failure, return NULL so the
  # caller falls back to regex parsing.
  suppressWarnings(tryCatch(
    xml2::read_xml(svg),
    error = function(e) tryCatch(
      xml2::read_xml(svg, options = c("RECOVER", "NOERROR", "NOWARNING", "NOBLANKS")),
      error = function(e2) NULL
    )
  ))
}

#' Read SVG root geometry (attribute and viewBox dimensions)
#'
#' @param svg_content SVG string.
#' @return A list with numeric `attr_w`, `attr_h`, `vb_w`, `vb_h` (any may be NA).
#' @keywords internal
svg_geometry <- function(svg_content) {
  doc <- svg_xml_parse(svg_content)
  if (!is.null(doc)) {
    root <- xml2::xml_root(doc)
    vbwh <- parse_viewbox(xml2::xml_attr(root, "viewBox"))
    return(list(
      attr_w = num_lead(xml2::xml_attr(root, "width")),
      attr_h = num_lead(xml2::xml_attr(root, "height")),
      vb_w = vbwh[1],
      vb_h = vbwh[2]
    ))
  }
  svg_geometry_regex(svg_content)
}

#' Regex fallback for [svg_geometry()]
#' @param svg_content SVG string.
#' @keywords internal
svg_geometry_regex <- function(svg_content) {
  svg <- as.character(svg_content)

  attr_num <- function(attr) {
    m <- regexpr(paste0(attr, '\\s*=\\s*"[^"]*"'), svg, perl = TRUE)
    if (m[1] == -1) return(NA_real_)
    num_lead(regmatches(svg, m))
  }

  vb <- regmatches(svg, regexec('viewBox\\s*=\\s*"([^"]+)"', svg))[[1]]
  vbwh <- if (length(vb) > 1) parse_viewbox(vb[2]) else c(NA_real_, NA_real_)

  list(attr_w = attr_num("width"), attr_h = attr_num("height"),
       vb_w = vbwh[1], vb_h = vbwh[2])
}

#' Read a single root SVG dimension robustly
#'
#' @param svg_content SVG string.
#' @param attr `"width"` or `"height"`.
#' @param prefer Which source to try first: `"attr"` (width/height attribute,
#'   the default) or `"viewBox"`.
#' @return Numeric value in CSS px, or `NA_real_` if not found.
#' @keywords internal
svg_dimension <- function(svg_content, attr = c("width", "height"),
                          prefer = c("attr", "viewBox")) {
  attr <- match.arg(attr)
  prefer <- match.arg(prefer)
  g <- svg_geometry(svg_content)

  from_attr <- if (attr == "width") g$attr_w else g$attr_h
  from_vb   <- if (attr == "width") g$vb_w else g$vb_h

  order <- if (prefer == "attr") list(from_attr, from_vb) else list(from_vb, from_attr)
  for (val in order) {
    if (length(val) == 1 && !is.na(val)) return(val)
  }
  NA_real_
}

#' Read SVG width and height robustly
#'
#' @param svg_content SVG string.
#' @param prefer Which source to try first per dimension (see [svg_dimension()]).
#' @return A list with numeric `width` and `height` (either may be NA).
#' @keywords internal
svg_dims <- function(svg_content, prefer = c("attr", "viewBox")) {
  prefer <- match.arg(prefer)
  list(
    width  = svg_dimension(svg_content, "width", prefer),
    height = svg_dimension(svg_content, "height", prefer)
  )
}

#' Detect font families referenced by an SVG
#'
#' @param svg_content SVG string.
#' @return Unique character vector of font family names (generics removed).
#' @keywords internal
svg_font_families <- function(svg_content) {
  doc <- svg_xml_parse(svg_content)
  if (is.null(doc)) return(svg_font_families_regex(svg_content))

  families <- character()

  # Presentation attribute: font-family="Jost" (any element, any namespace)
  attr_nodes <- xml2::xml_find_all(doc, "//*[@font-family]")
  if (length(attr_nodes)) {
    families <- c(families, xml2::xml_attr(attr_nodes, "font-family"))
  }

  # CSS inside <style> elements: font-family: "Jost", sans-serif;
  style_nodes <- xml2::xml_find_all(doc, "//*[local-name()='style']")
  if (length(style_nodes)) {
    css <- paste(xml2::xml_text(style_nodes), collapse = "\n")
    css_matches <- regmatches(
      css, gregexpr("font-family\\s*:\\s*([^;}{]+)", css, perl = TRUE)
    )[[1]]
    for (m in css_matches) {
      families <- c(families, sub("^font-family\\s*:\\s*", "", m))
    }
  }

  normalize_font_families(families)
}

#' Regex fallback for [svg_font_families()]
#' @param svg_content SVG string.
#' @keywords internal
svg_font_families_regex <- function(svg_content) {
  svg <- as.character(svg_content)
  families <- character()

  css_matches <- regmatches(
    svg, gregexpr("font-family\\s*:\\s*([^;}{]+)", svg, perl = TRUE)
  )[[1]]
  for (m in css_matches) {
    families <- c(families, sub("^font-family\\s*:\\s*", "", m))
  }

  attr_matches <- regmatches(
    svg, gregexpr('font-family\\s*=\\s*"([^"]+)"', svg, perl = TRUE)
  )[[1]]
  for (m in attr_matches) {
    families <- c(families, sub('"$', "", sub('^font-family\\s*=\\s*"', "", m)))
  }

  normalize_font_families(families)
}

#' Normalize a vector of raw font-family values
#'
#' Takes the first family of each declaration, strips quotes/whitespace, dedups,
#' and drops CSS generic family names.
#'
#' @param families Character vector of raw font-family values.
#' @keywords internal
normalize_font_families <- function(families) {
  if (!length(families)) return(character())
  families <- vapply(families, function(v) {
    first <- strsplit(v, ",", fixed = TRUE)[[1]][1]
    gsub("[\"']", "", trimws(first))
  }, character(1), USE.NAMES = FALSE)

  families <- unique(families[nzchar(families)])
  generics <- c("sans-serif", "serif", "monospace", "cursive", "fantasy", "system-ui")
  families[!(tolower(families) %in% generics)]
}
