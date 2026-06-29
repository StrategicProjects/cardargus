# cran-comments — cardargus 0.2.5

## Submission summary

This is a minor feature release.

* New `svg_to_pdf()` exports a card to a vector PDF via `rsvg::rsvg_pdf()`,
  mirroring `svg_to_png()` (the SVG is sanitized and required fonts are embedded).
  `save_card_for_knitr()` gains `format = "pdf"`, and `svg_to_formats()` reuses
  `svg_to_pdf()` for the vector path.
* `magick` and `rsvg` moved from `Imports` to `Suggests`: they are only used for
  raster/PDF export, which is already guarded with `requireNamespace()`. Examples
  that need them are conditioned on the package being available, so the package
  checks cleanly with `_R_CHECK_DEPENDS_ONLY_`.
* Minor fixes: `svg_card()` sizes badges using `value_fontsize` (no longer a
  hard-coded `10`); `is_light_color()` reports an unknown color name via `cli`
  instead of a raw `col2rgb()` error.

## R CMD check results

0 errors | 0 warnings | 0 notes

Verified locally with `R CMD check --as-cran --run-donttest`. The font cache fix
from 0.2.4 is retained: checks do not write to the user's home filespace.

## Test environments

* local: macOS, R 4.6.0
* GitHub Actions: ubuntu-latest (R release), windows-latest (R release)
* win-builder: R-devel

## Reverse dependencies

There are no reverse dependencies.
