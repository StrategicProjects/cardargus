# fonts.R - Font management functions
#
# Download, register, and manage Google Fonts for use with cardargus.

#' Get the path to fonts directory
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#' 
#' This function is deprecated. Use [font_cache_dir()] instead to get the
#' directory where fonts are cached.
#'
#' @return Character string with the path to font cache directory
#' @keywords internal
fonts_dir <- function() {
  cli::cli_warn(c(
    "!" = "{.fn fonts_dir} is deprecated.",
    "i" = "Use {.fn font_cache_dir} instead."
  ))
  font_cache_dir()
}

#' Get the path to package SVGs directory
#'
#' Returns the path to the inst/svgs directory where SVG files are stored.
#'
#' @return Character string with the path to SVGs directory
#' @export
svgs_dir <- function() {
  system.file("svgs", package = "cardargus")
}

#' Get path to a bundled SVG file
#'
#' Returns the full path to a SVG file bundled with the package.
#'
#' @param filename Name of the SVG file (e.g., "morar_bem.svg")
#' @param height Optional target height (px). If provided, returns the SVG content resized
#'   for embedding instead of the file path.
#' @param width Optional target width (px). Only used when returning resized SVG content.
#'
#' @return If `height` and `width` are both NULL, returns the full file path.
#'   Otherwise returns the resized SVG content (character string).
#' @export
get_svg_path <- function(filename, height = NULL, width = NULL) {
  path <- system.file("svgs", filename, package = "cardargus")
  if (path == "") {
    available <- list.files(svgs_dir(), pattern = "\\.svg$", full.names = FALSE)
    cli::cli_abort(c(
      "x" = "SVG file {.val {filename}} not found.",
      "i" = "Available files: {.val {available}}"
    ))
  }
  
  if (is.null(height) && is.null(width)) {
    return(path)
  }
  
  if (!exists("load_svg_for_embed", mode = "function")) {
    cli::cli_abort("Internal helper {.fn load_svg_for_embed} was not found.")
  }
  
  if (is.null(height)) height <- 40
  load_svg_for_embed(svg_path = path, target_height = height, target_width = width)$svg_content
}

#' List available bundled SVG files
#'
#' @return Character vector of available SVG filenames
#' @export
list_bundled_svgs <- function() {
  dir <- svgs_dir()
  if (dir == "") return(character(0))
  list.files(dir, pattern = "\\.svg$", full.names = FALSE)
}

# ------------------------------------------------------------------------------
# Optional: register fonts for interactive devices (showtext/sysfonts)
# ------------------------------------------------------------------------------

#' Register Google Font (sysfonts)
#'
#' Registers a Google Font using \pkg{sysfonts}.
#'
#' @param font_family Font family name (e.g., "Jost")
#' @return Invisible NULL
#' @export
register_google_font <- function(font_family) {
  if (!requireNamespace("sysfonts", quietly = TRUE)) {
    cli::cli_abort(c(
      "x" = "Package {.pkg sysfonts} is required.",
      "i" = "Install with: {.code install.packages('sysfonts')}"
    ))
  }
  tryCatch(
    sysfonts::font_add_google(name = font_family, family = font_family),
    error = function(e) cli::cli_warn("Could not register font {.val {font_family}}: {e$message}")
  )
  invisible(NULL)
}

#' Setup showtext for cardargus
#'
#' Registers fonts (via sysfonts) and optionally enables showtext auto mode.
#'
#' @param fonts Character vector of Google Font names to register.
#' @param auto Enable showtext auto mode.
#' @return Invisible NULL
#' @export
setup_fonts <- function(fonts = c("Jost", "Montserrat"), auto = TRUE) {
  if (!requireNamespace("showtext", quietly = TRUE)) {
    cli::cli_abort(c(
      "x" = "Package {.pkg showtext} is required.",
      "i" = "Install with: {.code install.packages('showtext')}"
    ))
  }
  if (!requireNamespace("sysfonts", quietly = TRUE)) {
    cli::cli_abort(c(
      "x" = "Package {.pkg sysfonts} is required.",
      "i" = "Install with: {.code install.packages('sysfonts')}"
    ))
  }
  
  for (fam in fonts) {
    tryCatch(
      sysfonts::font_add_google(name = fam, family = fam),
      error = function(e) cli::cli_warn("Could not register font {.val {fam}}: {e$message}")
    )
  }
  
  if (isTRUE(auto)) showtext::showtext_auto()
  invisible(NULL)
}

# ------------------------------------------------------------------------------
# Internal: cache + download WOFF2 from Google Fonts
# ------------------------------------------------------------------------------

#' Get font cache directory
#'
#' Returns the directory where cardargus caches downloaded font files.
#' Fonts in this directory are automatically embedded in SVG/PNG exports.
#'
#' @return A character path to the cache directory.
#' @export
#' @examples
#' \dontrun{
#' font_cache_dir()
#' # List cached fonts
#' list.files(font_cache_dir())
#' }
font_cache_dir <- function() {
  dir <- tryCatch(
    tools::R_user_dir("cardargus", which = "cache"),
    error = function(e) file.path(path.expand("~"), ".cache", "cardargus")
  )
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  dir
}

#' Build a cache filename for a font family
#' @keywords internal
font_cache_path <- function(family) {
  key <- gsub("[^A-Za-z0-9._-]+", "_", family)
  file.path(font_cache_dir(), paste0(key, ".woff2"))
}

#' Download a Google Font as WOFF2 to the cache
#'
#' @param family Font family name.
#' @param weight Numeric/character weight (default "400").
#' @return Path to cached WOFF2 file or NA_character_.
#' @keywords internal
download_google_font_woff2 <- function(family, weight = "400") {
  out <- font_cache_path(family)
  if (file.exists(out)) return(out)
  
  # Try gfonts package if available
  if (requireNamespace("gfonts", quietly = TRUE)) {
    ok <- tryCatch({
      tmp <- tempfile("cardargus_font_")
      dir.create(tmp)
      
      gfonts::download_font(
        family = family,
        output_dir = tmp,
        variants = "regular"
      )
      
      candidates <- list.files(tmp, pattern = "\\.(woff2|ttf|woff)$", 
                                full.names = TRUE, recursive = TRUE)
      
      if (!length(candidates)) stop("No font files downloaded.")
      file.copy(candidates[1], out, overwrite = TRUE)
      TRUE
    }, error = function(e) FALSE)
    
    if (isTRUE(ok) && file.exists(out)) return(out)
  }
  
  # Fallback: fetch CSS from Google Fonts API
  family_encoded <- gsub(" ", "+", family)
  
  # URLs to try (different API formats)
  urls_to_try <- c(
    sprintf("https://fonts.googleapis.com/css2?family=%s:wght@400&display=swap", family_encoded),
    sprintf("https://fonts.googleapis.com/css2?family=%s&display=swap", family_encoded),
    sprintf("https://fonts.googleapis.com/css?family=%s:400&display=swap", family_encoded),
    sprintf("https://fonts.googleapis.com/css?family=%s&display=swap", family_encoded)
  )
  
  # User-Agent that triggers woff2 response
  ua <- "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
  
  for (css_url in urls_to_try) {
    css <- NULL
    
    # Try with curl package first (more reliable for headers)
    if (requireNamespace("curl", quietly = TRUE)) {
      css <- tryCatch({
        h <- curl::new_handle()
        curl::handle_setheaders(h, "User-Agent" = ua)
        req <- curl::curl_fetch_memory(css_url, handle = h)
        if (req$status_code == 200) rawToChar(req$content) else NULL
      }, error = function(e) NULL)
    }
    
    # Fallback to base R (may not get woff2 on all systems)
    if (is.null(css) || !nzchar(css)) {
      css <- tryCatch({
        paste(readLines(css_url, warn = FALSE), collapse = "\n")
      }, error = function(e) NULL)
    }
    
    if (is.null(css) || !nzchar(css)) next
    
    # Extract woff2 URL from CSS
    # Pattern matches: url(https://...woff2) or url("https://...woff2")
    m <- regexec('url\\(["\']?([^)"\']+\\.woff2)["\']?\\)', css)
    hit <- regmatches(css, m)[[1]]
    
    if (length(hit) >= 2) {
      font_url <- hit[2]
      
      ok <- tryCatch({
        utils::download.file(font_url, out, mode = "wb", quiet = TRUE)
        TRUE
      }, error = function(e) FALSE)
      
      if (isTRUE(ok) && file.exists(out) && file.info(out)$size > 1000) {
        return(out)
      }
    }
  }
  
  # If woff2 not found, try ttf as last resort and convert if possible
  # (most systems can use ttf directly anyway)
  for (css_url in urls_to_try) {
    css <- tryCatch({
      paste(readLines(css_url, warn = FALSE), collapse = "\n")
    }, error = function(e) NULL)
    
    if (is.null(css) || !nzchar(css)) next
    
    # Try ttf
    m <- regexec('url\\(["\']?([^)"\']+\\.ttf)["\']?\\)', css)
    hit <- regmatches(css, m)[[1]]
    
    if (length(hit) >= 2) {
      font_url <- hit[2]
      ttf_out <- sub("\\.woff2$", ".ttf", out)
      
      ok <- tryCatch({
        utils::download.file(font_url, ttf_out, mode = "wb", quiet = TRUE)
        TRUE
      }, error = function(e) FALSE)
      
      if (isTRUE(ok) && file.exists(ttf_out) && file.info(ttf_out)$size > 1000) {
        # Return ttf path - embed_svg_fonts will need to handle this
        return(ttf_out)
      }
    }
  }
  
  NA_character_
}

# ------------------------------------------------------------------------------
# Internal: detect fonts used by SVG
# ------------------------------------------------------------------------------

#' Detect font families used in an SVG
#'
#' @param svg_content Character SVG.
#' @return Character vector of font family names (unique).
#' @keywords internal
detect_svg_fonts <- function(svg_content) {
  svg <- as.character(svg_content)
  families <- character()
  
  # CSS: font-family: "Jost", sans-serif;
  css_hits <- gregexpr("font-family\\s*:\\s*([^;}{]+)", svg, perl = TRUE)
  css_matches <- regmatches(svg, css_hits)[[1]]
  if (length(css_matches)) {
    for (m in css_matches) {
      val <- sub("^font-family\\s*:\\s*", "", m)
      val <- strsplit(val, ",", fixed = TRUE)[[1]][1]
      val <- gsub("[\"']", "", trimws(val))
      if (nzchar(val)) families <- c(families, val)
    }
  }
  
  # Attributes: font-family="Jost"
  attr_hits <- gregexpr('font-family\\s*=\\s*"([^"]+)"', svg, perl = TRUE)
  attr_matches <- regmatches(svg, attr_hits)[[1]]
  if (length(attr_matches)) {
    for (m in attr_matches) {
      val <- sub('^font-family\\s*=\\s*"', "", m)
      val <- sub('"$', "", val)
      val <- strsplit(val, ",", fixed = TRUE)[[1]][1]
      val <- gsub("[\"']", "", trimws(val))
      if (nzchar(val)) families <- c(families, val)
    }
  }
  
  families <- unique(families[nzchar(families)])
  generics <- c("sans-serif", "serif", "monospace", "cursive", "fantasy", "system-ui")
  families[!(tolower(families) %in% generics)]
}

# ------------------------------------------------------------------------------
# Internal: ensure fonts exist (family -> woff2 path)
# ------------------------------------------------------------------------------

#' Ensure cardargus fonts are available (WOFF2 cache)
#'
#' @param families Character vector of font families.
#' @param weight Weight to request when downloading (default "400").
#' @return Named character vector family -> font file path (NA if unavailable).
#' @keywords internal
ensure_cardargus_fonts <- function(families, weight = "400") {
  families <- unique(as.character(families))
  out <- setNames(rep(NA_character_, length(families)), families)
  
  cache_dir <- font_cache_dir()
  
  for (fam in families) {
    # Check for existing cached file in various formats
    key <- gsub("[^A-Za-z0-9._-]+", "_", fam)
    
    # Try different extensions
    for (ext in c("woff2", "ttf", "woff", "otf")) {
      fp <- file.path(cache_dir, paste0(key, ".", ext))
      if (file.exists(fp)) {
        out[[fam]] <- fp
        break
      }
    }
    
    # If not found, try to download
    if (is.na(out[[fam]])) {
      fp <- download_google_font_woff2(fam, weight = weight)
      out[[fam]] <- if (!is.na(fp) && file.exists(fp)) fp else NA_character_
    }
  }
  
  out
}

#' Check if a font is available for embedding
#'
#' @param family Font family name
#' @return TRUE if font is cached (any supported format), FALSE otherwise
#' @export
#' @examples
#' \dontrun{
#' font_available("Jost")
#' font_available("Montserrat")
#' }
font_available <- function(family) {
  cache_dir <- font_cache_dir()
  key <- gsub("[^A-Za-z0-9._-]+", "_", family)
  
  for (ext in c("woff2", "ttf", "woff", "otf")) {
    if (file.exists(file.path(cache_dir, paste0(key, ".", ext)))) {
      return(TRUE)
    }
  }
  FALSE
}

#' List registered/cached fonts
#'
#' @return Character vector of font family names that are cached
#' @export
#' @examples
#' \dontrun{
#' list_fonts()
#' }
list_fonts <- function() {
  cache_dir <- font_cache_dir()
  files <- list.files(cache_dir, pattern = "\\.(woff2|ttf|woff|otf)$", full.names = FALSE)
  unique(gsub("\\.(woff2|ttf|woff|otf)$", "", files))
}

#' Pre-download fonts for offline use
#'
#' Downloads and caches the specified fonts (or default fonts)
#' so they are available for PNG conversion without internet access.
#'
#' @param fonts Character vector of Google Font names to download.
#'   Default is c("Jost", "Montserrat", "Roboto", "Open Sans").
#' @param verbose Print status messages
#' @return Named logical vector indicating success for each font
#' @export
#' @examples
#' \dontrun{
#' install_fonts()
#' install_fonts(c("Jost", "Roboto"))
#' }
install_fonts <- function(fonts = c("Jost", "Montserrat", "Roboto", "Open Sans"), 
                          verbose = TRUE) {
  results <- setNames(logical(length(fonts)), fonts)
  
  if (verbose) {
    cli::cli_h2("Downloading fonts from Google Fonts")
    cli::cli_alert_info("Requires internet connection")
    
    if (requireNamespace("curl", quietly = TRUE)) {
      cli::cli_alert_info("Using {.pkg curl} package for downloads")
    } else if (requireNamespace("gfonts", quietly = TRUE)) {
      cli::cli_alert_info("Using {.pkg gfonts} package for downloads")
    } else {
      cli::cli_alert_warning("Tip: Install {.pkg curl} or {.pkg gfonts} for more reliable downloads")
    }
  }
  
  for (fam in fonts) {
    if (verbose) cli::cli_progress_step("Downloading {.val {fam}}...")
    
    fp <- download_google_font_woff2(fam)
    success <- !is.na(fp) && file.exists(fp)
    results[[fam]] <- success
    
    if (verbose) {
      if (success) {
        format_type <- if (grepl("\\.ttf$", fp)) "TTF" else "WOFF2"
        cli::cli_alert_success("{fam} ({format_type})")
      } else {
        cli::cli_alert_danger("{fam} - check internet connection")
      }
    }
  }
  
  if (verbose) {
    n_ok <- sum(results)
    n_total <- length(results)
    
    cli::cli_h3("Summary")
    cli::cli_alert_info("Downloaded {n_ok}/{n_total} fonts")
    cli::cli_alert_info("Cache: {.path {font_cache_dir()}}")
    
    if (n_ok < n_total) {
      cli::cli_bullets(c(
        "i" = "Tip: Install {.pkg gfonts} for more reliable downloads:",
        " " = "{.code install.packages('gfonts')}",
        "i" = "Or use {.fn register_font} to register local font files."
      ))
    }
  }
  
  invisible(results)
}

#' Register a local font file for embedding
#'
#' Copies a local font file (TTF or WOFF2) to the cardargus cache directory
#' so it can be embedded in SVG exports.
#'
#' @param font_path Path to a local .ttf or .woff2 font file
#' @param family Font family name to register (e.g., "Jost"). If NULL,
#'   the filename without extension is used.
#' @return Path to the cached font file (invisible)
#' @export
#' @examples
#' \dontrun{
#' # Download Jost font from Google Fonts website, then:
#' register_font("~/Downloads/Jost-Regular.ttf", "Jost")
#' 
#' # Now svg_to_png will use this font
#' card <- svg_card("FAR", list(), list())
#' svg_to_png(card, "card.png")
#' }
register_font <- function(font_path, family = NULL) {
  if (!file.exists(font_path)) {
    stop("Font file not found: ", font_path)
  }
  
  ext <- tolower(tools::file_ext(font_path))
  if (!ext %in% c("ttf", "woff2", "woff", "otf")) {
    stop("Unsupported font format. Use TTF, WOFF2, WOFF, or OTF files.")
  }
  
  if (is.null(family)) {
    family <- tools::file_path_sans_ext(basename(font_path))
    # Clean up common suffixes like -Regular, -Bold, etc.
    family <- gsub("-?(Regular|Bold|Italic|Light|Medium|SemiBold|ExtraBold|Black|Thin).*$", "", family, ignore.case = TRUE)
  }
  
  # Determine output path
  cache_dir <- font_cache_dir()
  key <- gsub("[^A-Za-z0-9._-]+", "_", family)
  out_path <- file.path(cache_dir, paste0(key, ".", ext))
  
  # Copy file
  file.copy(font_path, out_path, overwrite = TRUE)
  
  if (file.exists(out_path)) {
    message(sprintf("Font '%s' registered successfully.", family))
    message(sprintf("Cached at: %s", out_path))
  } else {
    stop("Failed to copy font file to cache.")
  }
  
  invisible(out_path)
}

# ------------------------------------------------------------------------------
# Internal: embed fonts into SVG
# ------------------------------------------------------------------------------

#' Embed a font file into an SVG via @font-face
#'
#' @param svg_content Character SVG.
#' @param font_family Font family name to embed.
#' @param woff2_path Path to a font file (.woff2, .ttf, .woff, or .otf).
#' @return SVG string with embedded @font-face rule.
#' @keywords internal
embed_svg_fonts <- function(svg_content, font_family, woff2_path) {
  if (!requireNamespace("base64enc", quietly = TRUE)) {
    stop("Package 'base64enc' is required to embed fonts.")
  }
  if (is.na(woff2_path) || !file.exists(woff2_path)) {
    return(as.character(svg_content))
  }
  
  svg <- as.character(svg_content)
  
  # FIRST: Remove ALL existing @font-face declarations for this font family

  # This prevents duplication when embedding fonts multiple times
  # Pattern matches @font-face blocks that contain this font family name
  # Handles both single and double quotes around font-family name
  escaped_family <- gsub("([\\[\\](){}|.+*?^$\\\\])", "\\\\\\1", font_family, perl = TRUE)
  
  # Remove @font-face blocks for this font family (double quotes)
  pattern_dq <- sprintf('@font-face\\s*\\{[^}]*font-family\\s*:\\s*"%s"[^}]*\\}', escaped_family)
  svg <- gsub(pattern_dq, "", svg, perl = TRUE)
  
  # Remove @font-face blocks for this font family (single quotes)
  pattern_sq <- sprintf("@font-face\\s*\\{[^}]*font-family\\s*:\\s*'%s'[^}]*\\}", escaped_family)
  svg <- gsub(pattern_sq, "", svg, perl = TRUE)
  
  # Clean up any resulting empty lines or excessive whitespace
  svg <- gsub("\n{3,}", "\n\n", svg, perl = TRUE)
  
  raw <- readBin(woff2_path, "raw", n = file.info(woff2_path)$size)
  b64 <- base64enc::base64encode(raw)
  
  # Determine format based on file extension
  ext <- tolower(tools::file_ext(woff2_path))
  
  mime_and_format <- switch(ext,
    "woff2" = c("font/woff2", "woff2"),
    "ttf"   = c("font/ttf", "truetype"),
    "woff"  = c("font/woff", "woff"),
    "otf"   = c("font/otf", "opentype"),
    c("font/woff2", "woff2")  # default
  )
  mime_type <- mime_and_format[1]
  format_str <- mime_and_format[2]
  
  # Create a SINGLE @font-face rule with a weight range
  # Modern browsers support font-weight ranges: "400 700" covers normal to bold
  # This is much cleaner than creating multiple identical declarations
  css <- sprintf(
    '@font-face{font-family:"%s";src:url("data:%s;base64,%s") format("%s");font-weight:100 900;font-style:normal;}',
    font_family, mime_type, b64, format_str
  )
  
  # Insert at the BEGINNING of <style> tag for priority
  if (grepl("<style[^>]*>", svg, perl = TRUE)) {
    svg <- sub("(<style[^>]*>)", paste0("\\1\n", css, "\n"), svg, perl = TRUE)
  } else if (grepl("<defs>", svg, fixed = TRUE)) {
    svg <- sub("<defs>", paste0("<defs>\n<style>\n", css, "\n</style>\n"), svg, fixed = TRUE)
  } else if (grepl("<defs[^>]*>", svg, perl = TRUE)) {
    svg <- sub("(<defs[^>]*>)", paste0("\\1\n<style>\n", css, "\n</style>\n"), svg, perl = TRUE)
  } else {
    # No <defs> - insert after <svg> opening tag
    svg <- sub("(<svg[^>]*>)", paste0("\\1\n<defs><style>\n", css, "\n</style></defs>\n"), svg, perl = TRUE)
  }
  
  svg
}

#' Prepare SVG for rasterization (sanitize + embed fonts)
#'
#' @description
#' Removes Google Fonts @import rules (not supported by librsvg), sanitizes
#' editor metadata (handled by sanitize_svg_for_raster()), then embeds fonts
#' referenced by the SVG into @font-face blocks.
#'
#' @param svg_content Character SVG.
#' @return A sanitized SVG with embedded WOFF2 fonts.
#' @keywords internal
prepare_svg_for_raster <- function(svg_content) {
  svg <- as.character(svg_content)
  
  # sanitize (defined in conversion.R) - also removes @import
  if (!exists("sanitize_svg_for_raster", mode = "function")) {
    stop("sanitize_svg_for_raster() was not found (it should live in conversion.R).")
  }
  svg <- sanitize_svg_for_raster(svg)
  
  families <- detect_svg_fonts(svg)
  if (!length(families)) return(svg)
  
  paths <- ensure_cardargus_fonts(families)
  for (fam in names(paths)) {
    fp <- paths[[fam]]
    if (!is.na(fp) && file.exists(fp)) {
      svg <- embed_svg_fonts(svg, font_family = fam, woff2_path = fp)
    } else {
      # Font not available - warn user
      warning(sprintf("Font '%s' could not be embedded. PNG may use fallback font.", fam))
    }
  }
  
  svg
}