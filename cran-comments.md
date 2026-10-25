# cran-comments — cardargus 0.3.0

## Submission summary

This is a minor feature release.

* **Preset themes.** `svg_card()` gains a `theme` argument; `card_theme()` /
  `card_themes()` provide eight customizable presets. Arguments set explicitly
  in the call always override the theme.
* **Sparklines.** New `create_sparkline()` generates small line/area/bar
  mini-charts as standalone SVG strings for embedding in cards.
* **Font subsetting.** `save_svg()` and `svg_to_formats()` gain
  `subset_fonts`: instead of the full WOFF2, embed a glyph subset covering
  only the characters used by the card (Google Fonts CSS API), with fallback
  to the full font. Off by default; tests of this feature are offline
  (cache-key/charset helpers only) and no example or test downloads a subset
  during checks.
* **Accessibility.** Cards now embed an SVG `<title>` (and optional `<desc>`
  via the new `alt` argument) and carry `role="img"`/`aria-labelledby`.
* New *Theme Gallery* vignette. Its card images are pre-rendered,
  self-contained SVGs shipped as static vignette figures, so building the
  vignette requires no network access.
* All new `svg_card()` arguments were appended to the end of the signature,
  preserving existing positional calls.

## R CMD check results

0 errors | 0 warnings | 0 notes

Verified locally with `R CMD check --as-cran --run-donttest`. The font cache
policy from previous releases is retained: checks never write to the user's
home filespace (cache is routed to a session temp dir under `R CMD check`).

## Test environments

* local: macOS, R 4.6.0
* win-builder: R-devel

## Reverse dependencies

There are no reverse dependencies.
