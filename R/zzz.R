# zzz.R - Package load and attach hooks

#' @keywords internal
"_PACKAGE"

.onLoad <- function(libname, pkgname) {
  # 1) Register knitr helpers only if knitr is installed
  if (requireNamespace("knitr", quietly = TRUE)) {
    tryCatch(
      register_knitr_engine(),
      error = function(e) {
        # Silently ignore to avoid breaking package load
      }
    )
  }
  
  # 2) Check for required system fonts
  if (requireNamespace("systemfonts", quietly = TRUE)) {
    tryCatch({
      fonts <- systemfonts::system_fonts()
      jost_available <- "Jost" %in% fonts$family
      
      if (!jost_available) {
        # Try to register Jost from Google Fonts if sysfonts is available
        if (requireNamespace("sysfonts", quietly = TRUE)) {
          tryCatch({
            sysfonts::font_add_google("Jost", "Jost")
          }, error = function(e) {
            # Silently ignore - user will be notified at attach
          })
        }
      }
    }, error = function(e) {
      # Silently ignore font check errors
    })
  }
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "cardargus: Generate beautiful SVG cards with embedded styles\n",
    "Use svg_card() to create cards\n",
    "Use svg_to_png() or svg_to_png_chrome() to export to PNG\n",
    "For best font support: setup_fonts()"
  )
}