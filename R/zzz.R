# zzz.R - Package load and attach hooks

#' @importFrom cli cli_alert_success cli_alert_info cli_alert_warning
#' @importFrom cli cli_alert_danger cli_progress_step
#' @importFrom cli cli_h1 cli_h2 cli_h3 cli_bullets cli_warn cli_abort
#' @importFrom grDevices col2rgb as.raster
#' @importFrom stats setNames
#' @importFrom utils download.file unzip
#' @keywords internal
"_PACKAGE"

.onLoad <- function(libname, pkgname) {
  # Register knitr helpers only if knitr is installed.
  # NOTE: nenhum acesso a rede aqui (politica do CRAN) — o registro da fonte
  # Jost acontece sob demanda em fonts.R quando um card e gerado.
  if (requireNamespace("knitr", quietly = TRUE)) {
    tryCatch(
      register_cardargus_knitr(),
      error = function(e) {
        # Silently ignore to avoid breaking package load
      }
    )
  }
}

.onUnload <- function(libpath) {
  # Close the persistent Chrome session, if one was created
  tryCatch(close_chrome_session(), error = function(e) NULL)
}
