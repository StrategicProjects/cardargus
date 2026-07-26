# chrome.R - Chrome-based SVG conversion
#
# Convert SVG to PNG/PDF using headless Chrome via chromote package.
# Provides superior font rendering for Google Fonts.

#' Check if Chrome/Chromium is available for rendering
#'
#' @description
#' Checks whether the chromote package can find and use a Chrome or Chromium
#' installation for headless rendering.
#'
#' @param verbose Print status messages (default FALSE).
#'
#' @return TRUE if Chrome is available, FALSE otherwise.
#' @export
#'
#' @examples
#' if (chrome_available()) {
#'    cat("Using Chrome")
#' } else {
#'    cat("Using Magick")
#' }
#' 
chrome_available <- function(verbose = FALSE) {
  if (!requireNamespace("chromote", quietly = TRUE)) {
    if (verbose) cli::cli_alert_warning("Package {.pkg chromote} is not installed.")
    return(FALSE)
  }
  
  tryCatch({
    if (verbose) cli::cli_alert_success("Chrome found: {.path {find_chrome_path()}}")
    TRUE
  }, error = function(e) {
    if (verbose) cli::cli_alert_warning("Chrome not found: {e$message}")
    FALSE
  })
}

#' Find Chrome executable path
#'
#' @description
#' Attempts to find a Chrome or Chromium executable on the system.
#' Checks common installation paths and environment variables.
#'
#' @return Path to Chrome executable, or NULL if not found.
#' @export
#'
#' @examples
#' path <- find_chrome_path()
#' if (!is.null(path)) {
#'   message("Chrome found at: ", path)
#' }
find_chrome_path <- function() {
  # Check environment variable first
  env_path <- Sys.getenv("CHROMOTE_CHROME", "")
  if (nzchar(env_path) && file.exists(env_path)) {
    return(env_path)
  }
  
  # Try chromote's finder
  if (requireNamespace("chromote", quietly = TRUE)) {
    tryCatch({
      return(chromote::find_chrome())
    }, error = function(e) NULL)
  }
  
  # Manual search for common paths
  candidates <- c(
    # Linux
    "/usr/bin/google-chrome",
    "/usr/bin/google-chrome-stable",
    "/usr/bin/chromium",
    "/usr/bin/chromium-browser",
    "/snap/bin/chromium",
    # macOS
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    "/Applications/Chromium.app/Contents/MacOS/Chromium",
    # Windows
    file.path(Sys.getenv("PROGRAMFILES"), "Google/Chrome/Application/chrome.exe"),
    file.path(Sys.getenv("PROGRAMFILES(X86)"), "Google/Chrome/Application/chrome.exe"),
    file.path(Sys.getenv("LOCALAPPDATA"), "Google/Chrome/Application/chrome.exe")
  )
  
  for (path in candidates) {
    if (file.exists(path)) {
      return(path)
    }
  }
  
  # Try 'which' on Unix-like systems
  if (.Platform$OS.type == "unix") {
    for (cmd in c("google-chrome", "google-chrome-stable", "chromium", "chromium-browser")) {
      result <- tryCatch({
        path <- system2("which", cmd, stdout = TRUE, stderr = FALSE)
        if (length(path) > 0 && file.exists(path[1])) path[1] else NULL
      }, error = function(e) NULL, warning = function(w) NULL)
      if (!is.null(result)) return(result)
    }
  }
  
  NULL
}

#' Ensure Chrome is available, downloading if necessary
#'
#' @description
#' Checks if Chrome is available and optionally downloads a standalone
#' Chrome for Testing if not found. This ensures Chrome-based rendering
#' works without requiring a system-wide Chrome installation.
#'
#' @param download If TRUE and Chrome is not found, attempt to download
#'   Chrome for Testing (default FALSE).
#' @param verbose Print status messages (default TRUE).
#'
#' @return TRUE if Chrome is available (or was successfully downloaded),
#'   FALSE otherwise.
#' @export
#'
#' @details
#' When `download = TRUE`, this function will download "Chrome for Testing",
#' a standalone Chrome distribution designed for automation. The download
#' is approximately 150MB and is cached in the user's data directory.
#'
#' Alternatively, you can:
#' - Install Chrome/Chromium system-wide
#' - Set the `CHROMOTE_CHROME` environment variable to point to an existing installation
#'
#' @examples
#' # Check and report status
#' ensure_chrome()
#'
#' # Download Chrome if not available
#' \dontrun{
#' ensure_chrome(download = TRUE)
#' }
ensure_chrome <- function(download = FALSE, verbose = TRUE) {
  # Check if already available
  if (chrome_available(verbose = FALSE)) {
    if (verbose) {
      cli::cli_alert_success("Chrome is available: {.path {find_chrome_path()}}")
    }
    return(TRUE)
  }
  
  if (!download) {
    if (verbose) {
      cli::cli_alert_warning("Chrome/Chromium not found on this system.")
      cli::cli_h3("Options to enable Chrome rendering")
      cli::cli_bullets(c(
        "1" = "Install Chrome or Chromium:",
        " " = "Linux: {.code sudo apt install chromium-browser}",
        " " = "macOS: {.code brew install --cask google-chrome}",
        " " = "Windows: Download from {.url https://www.google.com/chrome/}",
        "2" = "Or set path to existing Chrome:",
        " " = '{.code Sys.setenv(CHROMOTE_CHROME = "/path/to/chrome")}',
        "3" = "Or download Chrome for Testing:",
        " " = "{.code ensure_chrome(download = TRUE)}"
      ))
    }
    return(FALSE)
  }
  
  # Attempt to download Chrome for Testing
  if (verbose) cli::cli_alert_info("Downloading Chrome for Testing...")
  
  if (!requireNamespace("chromote", quietly = TRUE)) {
    if (verbose) {
      cli::cli_alert_danger("Package {.pkg chromote} is required.")
      cli::cli_alert_info("Install with: {.code install.packages('chromote')}")
    }
    return(FALSE)
  }
  
  # Get platform-specific download URL
  download_info <- get_chrome_download_info()
  if (is.null(download_info)) {
    if (verbose) cli::cli_alert_danger("Could not determine download URL for this platform.")
    return(FALSE)
  }
  
  # Create cache directory
  cache_dir <- chrome_cache_dir()
  if (!dir.exists(cache_dir)) {
    dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
  }
  
  zip_path <- file.path(cache_dir, download_info$filename)
  chrome_dir <- file.path(cache_dir, "chrome")
  
  # Download if not already cached
  if (!dir.exists(chrome_dir)) {
    if (verbose) cli::cli_progress_step("Downloading Chrome for Testing (~150MB)...")
    
    tryCatch({
      download.file(download_info$url, zip_path, mode = "wb", quiet = !verbose)
      
      if (verbose) cli::cli_progress_step("Extracting...")
      unzip(zip_path, exdir = cache_dir)
      
      # Rename extracted folder
      extracted <- list.dirs(cache_dir, recursive = FALSE, full.names = TRUE)
      extracted <- extracted[grepl("chrome", basename(extracted), ignore.case = TRUE)]
      if (length(extracted) > 0 && extracted[1] != chrome_dir) {
        file.rename(extracted[1], chrome_dir)
      }
      
      # Clean up zip
      unlink(zip_path)
      
    }, error = function(e) {
      if (verbose) cli::cli_alert_danger("Download failed: {e$message}")
      return(FALSE)
    })
  }
  
  # Find the executable
  chrome_exe <- find_chrome_in_dir(chrome_dir)
  
  if (!is.null(chrome_exe) && file.exists(chrome_exe)) {
    # Make executable on Unix
    if (.Platform$OS.type == "unix") {
      Sys.chmod(chrome_exe, mode = "0755")
    }
    
    # Set environment variable
    Sys.setenv(CHROMOTE_CHROME = chrome_exe)
    
    if (verbose) {
      cli::cli_alert_success("Chrome for Testing installed successfully!")
      cli::cli_alert_info("Location: {.path {chrome_exe}}")
    }
    return(TRUE)
  }
  
  if (verbose) cli::cli_alert_danger("Could not find Chrome executable after extraction.")
  FALSE
}

#' Get Chrome cache directory
#' @keywords internal
chrome_cache_dir <- function() {
  tryCatch(
    tools::R_user_dir("cardargus", which = "cache"),
    error = function(e) file.path(tempdir(), "cardargus-chrome")
  )
}

#' Get Chrome for Testing download info
#' @keywords internal
get_chrome_download_info <- function() {
  # Chrome for Testing URLs (stable channel)
  base_url <- "https://storage.googleapis.com/chrome-for-testing-public"
  version <- "131.0.6778.87"
  
  platform <- get_chrome_platform()
  if (is.null(platform)) return(NULL)
  
  list(
    url = sprintf("%s/%s/%s/chrome-%s.zip", base_url, version, platform, platform),
    filename = sprintf("chrome-%s.zip", platform),
    platform = platform
  )
}

#' Get platform identifier for Chrome downloads
#' @keywords internal
get_chrome_platform <- function() {
  os <- Sys.info()["sysname"]
  arch <- Sys.info()["machine"]
  
  if (os == "Linux") {
    return("linux64")
  } else if (os == "Darwin") {
    if (arch == "arm64") {
      return("mac-arm64")
    } else {
      return("mac-x64")
    }
  } else if (os == "Windows") {
    if (grepl("64", arch)) {
      return("win64")
    } else {
      return("win32")
    }
  }
  
  NULL
}

#' Find Chrome executable in a directory
#' @keywords internal
find_chrome_in_dir <- function(dir) {
  if (!dir.exists(dir)) return(NULL)
  
  os <- Sys.info()["sysname"]
  
  if (os == "Windows") {
    candidates <- list.files(dir, pattern = "chrome\\.exe$", 
                             recursive = TRUE, full.names = TRUE)
  } else if (os == "Darwin") {
    candidates <- list.files(dir, pattern = "^Google Chrome for Testing$|^Chromium$|^chrome$", 
                             recursive = TRUE, full.names = TRUE)
    app_dirs <- list.dirs(dir, recursive = TRUE)
    for (app in app_dirs) {
      if (grepl("\\.app/Contents/MacOS$", app)) {
        bins <- list.files(app, full.names = TRUE)
        candidates <- c(candidates, bins)
      }
    }
  } else {
    candidates <- list.files(dir, pattern = "^chrome$", 
                             recursive = TRUE, full.names = TRUE)
  }
  
  for (cand in candidates) {
    if (file.exists(cand)) {
      info <- file.info(cand)
      if (!info$isdir) return(cand)
    }
  }
  
  NULL
}

# ------------------------------------------------------------------------------
# Internal helper: wrap SVG in minimal HTML
# ------------------------------------------------------------------------------

#' Build an HTML document wrapping an SVG
#'
#' @description
#' Returns the HTML as an in-memory string (loaded into Chrome via a
#' `data:` URL), avoiding temp-file I/O and `file://` path issues on Windows.
#'
#' @param svg_string SVG content as character string.
#' @param width_px Width in pixels. If NULL, extracted from SVG.
#' @param height_px Height in pixels. If NULL, extracted from SVG.
#' @param background Background color (default "transparent").
#'
#' @return A list with html, width, and height.
#' @keywords internal
build_svg_html <- function(svg_string,
                           width_px = NULL,
                           height_px = NULL,
                           background = "transparent") {
  svg_string <- as.character(svg_string)
  
  if (is.null(width_px)) {
    width_px <- parse_svg_root_dim(svg_string, "width")
  }
  if (is.null(height_px)) {
    height_px <- parse_svg_root_dim(svg_string, "height")
  }
  
  if (is.na(width_px) || is.null(width_px)) width_px <- 800
  if (is.na(height_px) || is.null(height_px)) height_px <- 500
  
  width_px <- as.integer(ceiling(width_px))
  height_px <- as.integer(ceiling(height_px))
  
  html <- sprintf(
    '<!doctype html>
<html>
<head>
<meta charset="utf-8"/>
<style>
  html, body {
    margin: 0; padding: 0;
    width: %dpx; height: %dpx;
    background: %s;
    overflow: hidden;
  }
  .wrap {
    width: %dpx; height: %dpx;
    display: flex;
    align-items: flex-start;
    justify-content: flex-start;
  }
  svg { display: block; }
</style>
</head>
<body>
  <div class="wrap">
    %s
  </div>
</body>
</html>',
    width_px, height_px, background,
    width_px, height_px,
    svg_string
  )

  list(html = html, width = width_px, height = height_px)
}

# ------------------------------------------------------------------------------
# Internal: sanitize SVG metadata only (not @import)
# ------------------------------------------------------------------------------

#' Sanitize SVG metadata for Chrome rendering
#'
#' @description
#' Removes problematic Inkscape/Sodipodi metadata that can cause issues,
#' but preserves @import rules since Chrome handles them correctly.
#'
#' @param svg_content SVG string.
#' @return Sanitized SVG string.
#' @keywords internal
sanitize_svg_metadata <- function(svg_content) {
  svg <- as.character(svg_content)
  
  svg <- gsub("<sodipodi:namedview[^>]*?/\\s*>", "", svg, perl = TRUE)
  svg <- gsub("<sodipodi:namedview[\\s\\S]*?</sodipodi:namedview\\s*>", "", svg, perl = TRUE)
  svg <- gsub("<inkscape:page[^>]*?/\\s*>", "", svg, perl = TRUE)
  svg <- gsub("<inkscape:page[\\s\\S]*?</inkscape:page\\s*>", "", svg, perl = TRUE)
  svg <- gsub("<metadata[\\s\\S]*?</metadata\\s*>", "", svg, perl = TRUE)
  
  svg <- gsub("\\s+sodipodi:[a-zA-Z0-9_.-]+\\s*=\\s*\"[^\"]*\"", "", svg, perl = TRUE)
  svg <- gsub("\\s+inkscape:[a-zA-Z0-9_.-]+\\s*=\\s*\"[^\"]*\"", "", svg, perl = TRUE)
  
  svg
}

# ------------------------------------------------------------------------------
# Internal: Chrome session management
# ------------------------------------------------------------------------------

#' Safely close a Chromote session
#'
#' @description
#' Closes a chromote session handling pending promises to avoid
#' "Unhandled promise error: timed out waiting for response" warnings.
#' This function processes pending async operations before closing
#' and silently ignores any timeout errors during cleanup.
#'
#' @param session A ChromoteSession object to close.
#' @param timeout_before Seconds to wait for pending promises before closing (default 2).
#' @param timeout_after Seconds to wait for cleanup after closing (default 1).
#'
#' @return NULL (invisibly). Called for side effects.
#' @keywords internal
cleanup_chromote_session <- function(session, 
                                     timeout_before = 2, 
                                     timeout_after = 1) {
  tryCatch({
    if (requireNamespace("later", quietly = TRUE)) {
      later::run_now(timeoutSecs = timeout_before)
    }
    if (!is.null(session)) {
      session$close()
    }
    if (requireNamespace("later", quietly = TRUE)) {
      later::run_now(timeoutSecs = timeout_after)
    }
  }, error = function(e) NULL)
  
  invisible(NULL)
}


# Package-level holder for the persistent Chrome session
.chrome_env <- new.env(parent = emptyenv())

#' Check that a ChromoteSession is alive and responsive
#'
#' @description
#' Verifies the session is active and answers a trivial CDP command within a
#' short timeout. Used before reusing the persistent session so a dead or hung
#' Chrome is replaced transparently instead of failing the conversion.
#'
#' @param b A ChromoteSession object (or NULL).
#' @param timeout Seconds to wait for the health-check command (default 2).
#'
#' @return TRUE if the session is usable, FALSE otherwise.
#' @keywords internal
chrome_session_alive <- function(b, timeout = 2) {
  if (is.null(b)) return(FALSE)
  active <- tryCatch(isTRUE(b$is_active()), error = function(e) FALSE)
  if (!active) return(FALSE)
  tryCatch({
    r <- b$Runtime$evaluate("1", returnByValue = TRUE, timeout_ = timeout)
    !is.null(r$result$value)
  }, error = function(e) FALSE)
}

#' Get (or create) the persistent Chrome session
#'
#' @description
#' Returns a package-level ChromoteSession, creating one on first use and
#' replacing it if it is no longer responsive (health-checked via
#' [chrome_session_alive()]). Reusing one session across conversions avoids
#' the ~1-2s startup cost of a new session per call.
#'
#' @param reset Force-close the current session and start a fresh one.
#'
#' @return A live ChromoteSession object.
#' @keywords internal
chrome_session <- function(reset = FALSE) {
  b <- .chrome_env$session
  if (!reset && chrome_session_alive(b)) {
    return(b)
  }
  if (!is.null(b)) {
    tryCatch(cleanup_chromote_session(b), error = function(e) NULL)
    .chrome_env$session <- NULL
    Sys.sleep(0.3)
  }
  b <- chromote::ChromoteSession$new()
  .chrome_env$session <- b
  b
}

#' Close the persistent Chrome session (if any)
#' @return NULL (invisibly).
#' @keywords internal
close_chrome_session <- function() {
  b <- .chrome_env$session
  if (!is.null(b)) {
    tryCatch(cleanup_chromote_session(b), error = function(e) NULL)
    .chrome_env$session <- NULL
  }
  invisible(NULL)
}

#' Wait until all fonts on the page are loaded
#'
#' @description
#' Deterministic readiness wait: resolves once `document.fonts.ready` fires
#' (all `@font-face` fonts loaded, including web fonts fetched over the
#' network). This replaces fixed `Sys.sleep()` waits, guaranteeing
#' screenshots/PDFs are never captured before fonts render, while returning
#' as soon as the page is actually ready. Falls back to a short fixed wait
#' (with a warning) if the readiness signal times out.
#'
#' @param b ChromoteSession object.
#' @param timeout Maximum seconds to wait for readiness (default 10).
#'
#' @return NULL (invisibly).
#' @keywords internal
wait_for_page_ready <- function(b, timeout = 10) {
  ok <- tryCatch({
    b$Runtime$evaluate(
      "document.fonts.ready.then(() => true)",
      awaitPromise = TRUE,
      returnByValue = TRUE,
      timeout_ = timeout
    )
    TRUE
  }, error = function(e) FALSE)

  if (!ok) {
    cli::cli_warn(c(
      "!" = "Font readiness signal timed out after {timeout}s; using a fixed wait.",
      "i" = "Fonts may not be fully rendered. Consider increasing {.arg timeout}."
    ))
    Sys.sleep(0.5)
  }
  invisible(NULL)
}

#' Load an SVG into a Chrome session and wait until it is rendered
#'
#' @description
#' Sanitizes the SVG, wraps it in HTML, and navigates to it via a `data:` URL
#' (no temp files / file:// URLs; a temp file is used only for very large
#' documents). Blocks until the load event fires and all fonts are loaded.
#'
#' @param b ChromoteSession object.
#' @param svg_content SVG content string.
#' @param background Background color.
#' @param timeout Maximum seconds to wait for load and font readiness.
#' @param extra_wait Additional fixed wait (seconds) after readiness (default 0).
#'
#' @return A list with width and height (CSS px) of the page.
#' @keywords internal
load_svg_page <- function(b, svg_content, background,
                          timeout = 10, extra_wait = 0) {
  svg_content <- sanitize_svg_metadata(svg_content)
  page <- build_svg_html(svg_content, background = background)

  # enc2utf8: the HTML declares charset=utf-8, so the bytes must be UTF-8
  # regardless of the session's native encoding
  url <- paste0(
    "data:text/html;base64,",
    base64enc::base64encode(charToRaw(enc2utf8(page$html)))
  )
  # Very large documents: navigate via a temp file instead of a data: URL
  if (nchar(url) > 2e6) {
    tf <- tempfile(fileext = ".html")
    writeLines(page$html, tf, useBytes = TRUE)
    url <- paste0("file://", normalizePath(tf, winslash = "/"))
  }

  loaded <- b$Page$loadEventFired(wait_ = FALSE, timeout_ = timeout)
  b$Page$navigate(url, wait_ = FALSE)
  tryCatch(b$wait_for(loaded), error = function(e) {
    cli::cli_warn("Page load event timed out after {timeout}s; continuing anyway.")
  })

  wait_for_page_ready(b, timeout = timeout)
  if (extra_wait > 0) Sys.sleep(extra_wait)

  list(width = page$width, height = page$height)
}

#' Convert a single SVG using an existing Chrome session
#'
#' @description
#' Internal helper that renders an SVG to PNG using an existing Chrome session.
#' Waits deterministically for load/fonts via [load_svg_page()]. When
#' `background` is transparent, the PNG is captured with a real alpha channel.
#'
#' @param b ChromoteSession object.
#' @param svg_content SVG content string (already sanitized).
#' @param scale DPI scale factor.
#' @param background Background color.
#' @param load_wait Extra fixed wait in seconds after readiness (default 0).
#' @param timeout Maximum seconds to wait for page readiness (default 10).
#'
#' @return Base64 encoded PNG string.
#' @keywords internal
convert_svg_with_session <- function(b, svg_content, scale, background,
                                     load_wait = 0, timeout = 10) {
  # Transparent background: capture with a real alpha channel
  bg_transparent <- tolower(background) %in% c("transparent", "none", "")
  if (bg_transparent) {
    b$Emulation$setDefaultBackgroundColorOverride(
      color = list(r = 0, g = 0, b = 0, a = 0)
    )
  } else {
    b$Emulation$setDefaultBackgroundColorOverride()
  }

  page <- load_svg_page(b, svg_content, background,
                        timeout = timeout, extra_wait = load_wait)

  # Set viewport at the requested scale
  b$Emulation$setDeviceMetricsOverride(
    width = as.integer(page$width),
    height = as.integer(page$height),
    deviceScaleFactor = scale,
    mobile = FALSE
  )

  # Capture screenshot (fromSurface produces a fresh frame at the new metrics)
  shot <- b$Page$captureScreenshot(format = "png", fromSurface = TRUE)

  shot$data
}

# ------------------------------------------------------------------------------
# Public API: Chrome-based conversion (single file)
# ------------------------------------------------------------------------------

#' Convert SVG to PNG using headless Chrome
#'
#' @description
#' Renders an SVG to PNG using headless Chrome via the chromote package.
#' This method provides superior font rendering compared to librsvg/ImageMagick,
#' as Chrome properly handles @font-face rules, web fonts, and CSS features.
#'
#' @param svg_input SVG string or path to an SVG file.
#' @param output_path Output path for the PNG file. If NULL, a temp file is used.
#' @param dpi Resolution in dots per inch (default 300). Chrome uses 96 DPI as base,
#'   so dpi = 300 results in approximately 3.125x scaling.
#' @param background Background color for the HTML page (default "transparent").
#'   Use "white", "#FFFFFF", etc. for a solid background.
#' @param load_wait Extra seconds to wait after the page reports ready
#'   (default 0). Readiness (fonts loaded, layout painted) is detected
#'   automatically; this is only a safety margin for edge cases.
#' @param timeout Maximum seconds to wait for page readiness (default 10).
#'
#' @details
#' The Chrome session is kept alive and reused across calls (with an automatic
#' health check), so repeated conversions avoid the session startup cost. The
#' screenshot is only captured after `document.fonts.ready` resolves, ensuring
#' web fonts are fully rendered.
#'
#' @return Path to the generated PNG file.
#' @export
#'
#' @examples
#' svg <- svg_card("FAR", list(), list())
#' file_name <- tempfile(fileext = ".png")
#' \dontrun{
#' if (chrome_available()) {
#'   png_path <- svg_to_png_chrome(svg, file_name, dpi = 300)
#' }
#' }
svg_to_png_chrome <- function(svg_input,
                              output_path = NULL,
                              dpi = 300,
                              background = "transparent",
                              load_wait = 0,
                              timeout = 10) {

  if (!requireNamespace("chromote", quietly = TRUE)) {
    cli::cli_abort(c(
      "x" = "Package {.pkg chromote} is required.",
      "i" = "Install with: {.code install.packages('chromote')}"
    ))
  }
  if (!requireNamespace("base64enc", quietly = TRUE)) {
    cli::cli_abort(c(
      "x" = "Package {.pkg base64enc} is required.",
      "i" = "Install with: {.code install.packages('base64enc')}"
    ))
  }

  # Read SVG content
  if (is.character(svg_input) && length(svg_input) == 1 && file.exists(svg_input)) {
    svg_content <- paste(readLines(svg_input, warn = FALSE), collapse = "\n")
  } else {
    svg_content <- as.character(svg_input)
  }

  if (is.null(output_path)) {
    output_path <- tempfile(fileext = ".png")
  }
  ensure_output_dir(output_path)

  scale <- dpi / 96

  # Persistent session; on failure retry once with a fresh session
  b64 <- tryCatch({
    convert_svg_with_session(chrome_session(), svg_content, scale, background,
                             load_wait, timeout)
  }, error = function(e) {
    convert_svg_with_session(chrome_session(reset = TRUE), svg_content, scale,
                             background, load_wait, timeout)
  })

  raw <- base64enc::base64decode(b64)
  writeBin(raw, output_path)

  output_path
}


#' Convert SVG to PDF using headless Chrome
#'
#' @description
#' Renders an SVG to PDF using headless Chrome via the chromote package.
#' This method produces vector PDFs with perfect font rendering.
#'
#' @param svg_input SVG string or path to an SVG file.
#' @param output_path Output path for the PDF file.
#' @param background Background color for the HTML page (default "transparent").
#' @param print_background Whether to include CSS backgrounds in PDF (default TRUE).
#' @param load_wait Extra seconds to wait after the page reports ready
#'   (default 0). Readiness (fonts loaded, layout painted) is detected
#'   automatically; this is only a safety margin for edge cases.
#' @param timeout Maximum seconds to wait for page readiness (default 10).
#'
#' @details
#' The Chrome session is kept alive and reused across calls (with an automatic
#' health check). The PDF is only generated after `document.fonts.ready`
#' resolves, ensuring web fonts are fully rendered.
#'
#' @return Path to the generated PDF file.
#' @export
#'
#' @examples
#' \dontrun{
#' svg <- svg_card("FAR", list(), list())
#' if (chrome_available()) {
#'   pdf_path <- svg_to_pdf_chrome(svg, tempfile(fileext = ".pdf"))
#' }
#' }
svg_to_pdf_chrome <- function(svg_input,
                              output_path,
                              background = "transparent",
                              print_background = TRUE,
                              load_wait = 0,
                              timeout = 10) {

  if (!requireNamespace("chromote", quietly = TRUE)) {
    cli::cli_abort(c(
      "x" = "Package {.pkg chromote} is required.",
      "i" = "Install with: {.code install.packages('chromote')}"
    ))
  }
  if (!requireNamespace("base64enc", quietly = TRUE)) {
    cli::cli_abort(c(
      "x" = "Package {.pkg base64enc} is required.",
      "i" = "Install with: {.code install.packages('base64enc')}"
    ))
  }

  # Read SVG content
  if (is.character(svg_input) && length(svg_input) == 1 && file.exists(svg_input)) {
    svg_content <- paste(readLines(svg_input, warn = FALSE), collapse = "\n")
  } else {
    svg_content <- as.character(svg_input)
  }

  ensure_output_dir(output_path)

  print_svg_pdf <- function(b) {
    page <- load_svg_page(b, svg_content, background,
                          timeout = timeout, extra_wait = load_wait)
    b$Page$printToPDF(
      printBackground = print_background,
      marginTop = 0,
      marginBottom = 0,
      marginLeft = 0,
      marginRight = 0,
      paperWidth = page$width / 96,
      paperHeight = page$height / 96,
      preferCSSPageSize = TRUE
    )
  }

  # Persistent session; on failure retry once with a fresh session
  pdf <- tryCatch(
    print_svg_pdf(chrome_session()),
    error = function(e) print_svg_pdf(chrome_session(reset = TRUE))
  )

  raw <- base64enc::base64decode(pdf$data)
  writeBin(raw, output_path)

  output_path
}

# ------------------------------------------------------------------------------
# Public API: Batch conversion
# ------------------------------------------------------------------------------

#' Batch convert SVGs to PNG base64 using headless Chrome
#'
#' @description
#' Converts multiple SVGs to base64-encoded PNG strings using a single
#' Chrome session. Much faster than calling svg_to_png_chrome() repeatedly.
#'
#' @param svg_list List of SVG strings or file paths.
#' @param dpi Resolution (default 300).
#' @param background Background color (default "transparent").
#' @param load_wait Extra seconds to wait after each page reports ready
#'   (default 0). Readiness (fonts loaded, layout painted) is detected
#'   automatically; increased automatically on retries.
#' @param restart_every Restart Chrome session every N conversions (default 50).
#'   Helps prevent memory issues and stale connections.
#' @param retry_attempts Number of retry attempts on failure (default 3).
#' @param timeout Maximum seconds to wait for page readiness (default 10).
#' @param progress Show progress bar (default TRUE).
#'
#' @return Character vector of base64-encoded PNGs (data URI format).
#'   Returns NA for failed conversions.
#' @export
batch_svg_to_base64_chrome <- function(svg_list,
                                       dpi = 300,
                                       background = "transparent",
                                       load_wait = 0,
                                       restart_every = 50,
                                       retry_attempts = 3,
                                       timeout = 10,
                                       progress = TRUE) {

  if (!requireNamespace("chromote", quietly = TRUE)) {
    cli::cli_abort(c(
      "x" = "Package {.pkg chromote} is required.",
      "i" = "Install with: {.code install.packages('chromote')}"
    ))
  }
  if (!requireNamespace("base64enc", quietly = TRUE)) {
    cli::cli_abort(c(
      "x" = "Package {.pkg base64enc} is required.",
      "i" = "Install with: {.code install.packages('base64enc')}"
    ))
  }

  n <- length(svg_list)
  results <- rep(NA_character_, n)
  scale <- dpi / 96

  if (progress) cli::cli_progress_bar("Converting SVGs", total = n)

  b <- chrome_session()

  for (i in seq_len(n)) {
    # Restart session periodically
    if (i > 1 && ((i - 1) %% restart_every == 0)) {
      if (progress) cli::cli_alert_info("Restarting Chrome session at item {i}...")
      b <- chrome_session(reset = TRUE)
    }

    svg_input <- svg_list[[i]]
    success <- FALSE
    attempt <- 0
    current_wait <- load_wait

    # Read SVG content once
    if (is.character(svg_input) && length(svg_input) == 1 && file.exists(svg_input)) {
      svg_content <- paste(readLines(svg_input, warn = FALSE), collapse = "\n")
    } else {
      svg_content <- as.character(svg_input)
    }

    while (!success && attempt < retry_attempts) {
      attempt <- attempt + 1

      result <- tryCatch({
        b64 <- convert_svg_with_session(b, svg_content, scale, background,
                                        current_wait, timeout)
        list(success = TRUE, data = paste0("data:image/png;base64,", b64))
      }, error = function(e) {
        list(success = FALSE, error = e$message)
      })

      if (result$success) {
        results[[i]] <- result$data
        success <- TRUE
      } else {
        if (attempt < retry_attempts) {
          if (progress) {
            cli::cli_alert_warning(
              "Item {i} failed (attempt {attempt}/{retry_attempts}). Restarting session..."
            )
          }
          b <- chrome_session(reset = TRUE)
          current_wait <- current_wait + 0.3  # Increase wait time on retry
        } else {
          if (progress) {
            cli::cli_alert_danger("Item {i} failed: {result$error}")
          }
        }
      }
    }

    if (progress) cli::cli_progress_update()
  }
  
  if (progress) {
    cli::cli_progress_done()
    n_success <- sum(!is.na(results))
    n_failed <- n - n_success
    if (n_failed > 0) {
      cli::cli_alert_warning("Completed: {n_success} successful, {n_failed} failed")
    } else {
      cli::cli_alert_success("All {n} conversions completed successfully")
    }
  }
  
  results
}


#' Batch convert SVGs to PNG files using headless Chrome
#'
#' @description
#' Converts multiple SVGs to PNG files using a single Chrome session.
#' Much faster than calling svg_to_png_chrome() repeatedly.
#'
#' @param svg_list List of SVG strings or file paths.
#' @param output_paths Character vector of output paths. If NULL, temp files are created.
#' @param dpi Resolution (default 300).
#' @param background Background color (default "transparent").
#' @param load_wait Extra seconds to wait after each page reports ready
#'   (default 0). Readiness (fonts loaded, layout painted) is detected
#'   automatically; increased automatically on retries.
#' @param restart_every Restart Chrome session every N conversions (default 50).
#' @param retry_attempts Number of retry attempts on failure (default 3).
#' @param timeout Maximum seconds to wait for page readiness (default 10).
#' @param progress Show progress bar (default TRUE).
#'
#' @return Character vector of output file paths. Returns NA for failed conversions.
#' @export
batch_svg_to_png_chrome <- function(svg_list,
                                    output_paths = NULL,
                                    dpi = 300,
                                    background = "transparent",
                                    load_wait = 0,
                                    restart_every = 50,
                                    retry_attempts = 3,
                                    timeout = 10,
                                    progress = TRUE) {
  
  if (!requireNamespace("chromote", quietly = TRUE)) {
    cli::cli_abort(c(
      "x" = "Package {.pkg chromote} is required.",
      "i" = "Install with: {.code install.packages('chromote')}"
    ))
  }
  if (!requireNamespace("base64enc", quietly = TRUE)) {
    cli::cli_abort(c(
      "x" = "Package {.pkg base64enc} is required.",
      "i" = "Install with: {.code install.packages('base64enc')}"
    ))
  }
  
  n <- length(svg_list)
  
  if (is.null(output_paths)) {
    output_paths <- vapply(seq_len(n), function(i) tempfile(fileext = ".png"), character(1))
  }
  
  if (length(output_paths) != n) {
    cli::cli_abort("Length of output_paths must match length of svg_list.")
  }
  
  results <- rep(NA_character_, n)
  scale <- dpi / 96
  
  if (progress) cli::cli_progress_bar("Converting SVGs", total = n)

  b <- chrome_session()

  for (i in seq_len(n)) {
    # Restart session periodically
    if (i > 1 && ((i - 1) %% restart_every == 0)) {
      if (progress) cli::cli_alert_info("Restarting Chrome session at item {i}...")
      b <- chrome_session(reset = TRUE)
    }

    svg_input <- svg_list[[i]]
    output_path <- output_paths[[i]]
    success <- FALSE
    attempt <- 0
    current_wait <- load_wait

    # Read SVG content once
    if (is.character(svg_input) && length(svg_input) == 1 && file.exists(svg_input)) {
      svg_content <- paste(readLines(svg_input, warn = FALSE), collapse = "\n")
    } else {
      svg_content <- as.character(svg_input)
    }

    while (!success && attempt < retry_attempts) {
      attempt <- attempt + 1

      result <- tryCatch({
        ensure_output_dir(output_path)
        b64 <- convert_svg_with_session(b, svg_content, scale, background,
                                        current_wait, timeout)
        raw <- base64enc::base64decode(b64)
        writeBin(raw, output_path)
        list(success = TRUE, path = output_path)
      }, error = function(e) {
        list(success = FALSE, error = e$message)
      })

      if (result$success) {
        results[[i]] <- result$path
        success <- TRUE
      } else {
        if (attempt < retry_attempts) {
          if (progress) {
            cli::cli_alert_warning(
              "Item {i} failed (attempt {attempt}/{retry_attempts}). Restarting session..."
            )
          }
          b <- chrome_session(reset = TRUE)
          current_wait <- current_wait + 0.3
        } else {
          if (progress) {
            cli::cli_alert_danger("Item {i} failed: {result$error}")
          }
        }
      }
    }

    if (progress) cli::cli_progress_update()
  }
  
  if (progress) {
    cli::cli_progress_done()
    n_success <- sum(!is.na(results))
    n_failed <- n - n_success
    if (n_failed > 0) {
      cli::cli_alert_warning("Completed: {n_success} successful, {n_failed} failed")
    } else {
      cli::cli_alert_success("All {n} conversions completed successfully")
    }
  }
  
  results
}