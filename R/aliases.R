# aliases.R - Backward compatibility aliases and imports
#
# Maintains old function names while transitioning to new ones.

#' @importFrom cli cli_alert_success cli_alert_info cli_alert_warning
#' @importFrom cli cli_alert_danger cli_progress_step
#' @importFrom cli cli_h1 cli_h2 cli_h3 cli_bullets cli_warn cli_abort
#' @importFrom grDevices col2rgb as.raster
#' @importFrom stats runif setNames
#' @importFrom utils download.file unzip
#' @keywords internal
NULL

# Backward compatibility aliases

#' @rdname icon_house
#' @usage NULL
#' @export
house_icon_svg <- function(...) icon_house(...)

#' @rdname icon_building
#' @usage NULL
#' @export
building_icon_svg <- function(...) icon_building(...)

#' @rdname icon_construction
#' @usage NULL
#' @export
construction_icon_svg <- function(...) icon_construction(...)

#' @rdname icon_map_pin
#' @usage NULL
#' @export
map_pin_icon_svg <- function(...) icon_map_pin(...)

#' @rdname icon_money
#' @usage NULL
#' @export
money_icon_svg <- function(...) icon_money(...)

#' @rdname setup_fonts
#' @usage NULL
#' @export
setup_cardargus_fonts <- function(...) setup_fonts(...)

#' @rdname install_fonts
#' @usage NULL
#' @export
install_cardargus_fonts <- function(...) install_fonts(...)

#' @rdname font_cache_dir
#' @usage NULL
#' @export
cardargus_font_cache_dir <- function() font_cache_dir()

#' @rdname register_knitr_engine
#' @usage NULL
#' @export
register_cardargus_knitr <- function() register_knitr_engine()

#' @rdname create_badge
#' @usage NULL
#' @export
badge_svg <- function(...) create_badge(...)

#' @rdname create_badge_row
#' @usage NULL
#' @export
badge_row_svg <- function(...) create_badge_row(...)
