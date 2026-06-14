# cran-comments — cardargus 0.2.4

## Submission summary

This is a maintenance release submitted shortly after 0.2.3 to resolve the
additional `donttest` issue reported by the CRAN auto-check service for the
previously released version.

The issue: some examples (`install_fonts()`, `svg_to_png()`, `save_svg()`)
downloaded Google Fonts into the persistent user cache
(`tools::R_user_dir("cardargus", "cache")`), which writes to the user's home
filespace during checks when network access is available on the check machine.

The fix: `font_cache_dir()` now detects `R CMD check` via the
`_R_CHECK_PACKAGE_NAME_` environment variable and routes all font downloads to a
session-specific temporary directory. Examples, tests and vignettes therefore no
longer write anything under `~/.cache`. Interactive and normal use is unchanged
(the persistent cache remains the default).

## R CMD check results

0 errors | 0 warnings | 0 notes

Verified locally with `R CMD check --as-cran --run-donttest`; the home cache
(`~/.cache/R/cardargus`) is left untouched by the check.

## Test environments

* local: macOS, R 4.6.0
* GitHub Actions: ubuntu-latest (R release), windows-latest (R release)
* win-builder: R-devel

## Reverse dependencies

There are no reverse dependencies.
