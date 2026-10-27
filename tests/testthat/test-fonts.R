# Ensures the font cache never writes to the user's home filespace during
# R CMD check / examples / tests (CRAN policy; donttest additional issue).

test_that("running_under_check reflects _R_CHECK_PACKAGE_NAME_", {
  old <- Sys.getenv("_R_CHECK_PACKAGE_NAME_", unset = NA)
  on.exit(
    if (is.na(old)) Sys.unsetenv("_R_CHECK_PACKAGE_NAME_")
    else Sys.setenv("_R_CHECK_PACKAGE_NAME_" = old),
    add = TRUE
  )

  Sys.setenv("_R_CHECK_PACKAGE_NAME_" = "cardargus")
  expect_true(cardargus:::running_under_check())

  Sys.unsetenv("_R_CHECK_PACKAGE_NAME_")
  expect_false(cardargus:::running_under_check())
})

test_that("font_cache_dir uses a temp dir under R CMD check even if persistent=TRUE", {
  old <- Sys.getenv("_R_CHECK_PACKAGE_NAME_", unset = NA)
  on.exit(
    if (is.na(old)) Sys.unsetenv("_R_CHECK_PACKAGE_NAME_")
    else Sys.setenv("_R_CHECK_PACKAGE_NAME_" = old),
    add = TRUE
  )

  Sys.setenv("_R_CHECK_PACKAGE_NAME_" = "cardargus")
  d <- font_cache_dir(persistent = TRUE)
  tmp <- normalizePath(tempdir(), winslash = "/", mustWork = FALSE)
  expect_true(startsWith(normalizePath(d, winslash = "/", mustWork = FALSE), tmp))
  expect_true(dir.exists(d))
})

test_that("font_cache_dir(persistent = FALSE) is a temp dir", {
  d <- font_cache_dir(persistent = FALSE)
  tmp <- normalizePath(tempdir(), winslash = "/", mustWork = FALSE)
  expect_true(startsWith(normalizePath(d, winslash = "/", mustWork = FALSE), tmp))
})

# ---- font subsetting (offline: cache keys and charset normalization only) ----

test_that("font_subset_charset normalizes to sorted unique characters", {
  expect_equal(cardargus:::font_subset_charset("baa"), "ab")
  # Same glyphs, different order/repetition -> same charset
  expect_identical(
    cardargus:::font_subset_charset("CAIARA II"),
    cardargus:::font_subset_charset("IRA CAI A")
  )
  expect_null(cardargus:::font_subset_charset(NULL))
  expect_null(cardargus:::font_subset_charset(""))
  # Multiple elements are collapsed
  expect_equal(cardargus:::font_subset_charset(c("ab", "bc")), "abc")
})

test_that("font_cache_path separates subsets from the full font", {
  full <- cardargus:::font_cache_path("Jost")
  sub1 <- cardargus:::font_cache_path("Jost", text = "abc")
  sub2 <- cardargus:::font_cache_path("Jost", text = "abd")

  expect_match(basename(full), "^Jost\\.woff2$")
  expect_false(sub1 == full)
  expect_false(sub1 == sub2)
  # Deterministic for the same charset
  expect_identical(sub1, cardargus:::font_cache_path("Jost", text = "abc"))
  # Empty/NULL text behaves like the full font
  expect_identical(cardargus:::font_cache_path("Jost", text = NULL), full)
})

# ---- Latin block selection from the Google Fonts CSS response (#27) ---------

# Resposta real (abreviada) da CSS2 API: um bloco @font-face por script,
# com o cirílico PRIMEIRO e o latin por último.
css2_multiblock <- paste(
  "/* cyrillic-ext */",
  "@font-face {",
  "  font-family: 'Jost';",
  "  font-style: normal;",
  "  font-weight: 400;",
  "  font-display: swap;",
  "  src: url(https://fonts.gstatic.com/s/jost/v19/cyr-ext.woff2) format('woff2');",
  "  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F;",
  "}",
  "/* cyrillic */",
  "@font-face {",
  "  font-family: 'Jost';",
  "  src: url(https://fonts.gstatic.com/s/jost/v19/cyr.woff2) format('woff2');",
  "  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;",
  "}",
  "/* latin-ext */",
  "@font-face {",
  "  font-family: 'Jost';",
  "  src: url(https://fonts.gstatic.com/s/jost/v19/latin-ext.woff2) format('woff2');",
  "  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+1E00-1E9F;",
  "}",
  "/* latin */",
  "@font-face {",
  "  font-family: 'Jost';",
  "  src: url(https://fonts.gstatic.com/s/jost/v19/latin.woff2) format('woff2');",
  "  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+2000-206F;",
  "}",
  sep = "\n"
)

woff2_url_pattern <- 'url\\(["\']?([^)"\']+\\.woff2)["\']?\\)'

test_that("unicode_range_covers parses ranges, single points and wildcards", {
  # 'A' (U+0041) está no Basic Latin, não no cirílico
  expect_true(cardargus:::unicode_range_covers("U+0000-00FF, U+0131", 0x41L))
  expect_false(cardargus:::unicode_range_covers("U+0400-045F, U+2116", 0x41L))
  # Code point isolado
  expect_true(cardargus:::unicode_range_covers("U+0041", 0x41L))
  expect_false(cardargus:::unicode_range_covers("U+0042", 0x41L))
  # Wildcard: U+4?? cobre 0x400-0x4FF
  expect_true(cardargus:::unicode_range_covers("U+4??", 0x410L))
  expect_false(cardargus:::unicode_range_covers("U+4??", 0x41L))
  # Minúsculas e espaçamento irregular são tolerados
  expect_true(cardargus:::unicode_range_covers(" u+0000-00ff ,u+0131", 0x41L))
  # Token inválido não cobre nada (e não erra)
  expect_false(cardargus:::unicode_range_covers("U+ZZZZ", 0x41L))
})

test_that("google_css_latin_url picks the latin block, not the first (cyrillic)", {
  expect_identical(
    cardargus:::google_css_latin_url(css2_multiblock, woff2_url_pattern),
    "https://fonts.gstatic.com/s/jost/v19/latin.woff2"
  )
})

test_that("google_css_latin_url falls back to the first URL without unicode-range", {
  # Respostas de bloco único (ex.: subsets via &text=) não têm unicode-range
  css_subset <- paste(
    "@font-face {",
    "  font-family: 'Jost';",
    "  src: url(https://fonts.gstatic.com/l/font?kit=abc123) format('woff2');",
    "}",
    sep = "\n"
  )
  pattern_extensionless <-
    'url\\(["\']?([^)"\']+)["\']?\\)\\s*format\\([\'"]woff2[\'"]\\)'
  expect_identical(
    cardargus:::google_css_latin_url(css_subset, pattern_extensionless),
    "https://fonts.gstatic.com/l/font?kit=abc123"
  )
  # Sem nenhum match, NA
  expect_identical(
    cardargus:::google_css_latin_url("body { color: red; }", woff2_url_pattern),
    NA_character_
  )
})

test_that("google_css_latin_url also works for the ttf fallback", {
  css_ttf <- paste(
    "/* cyrillic */",
    "@font-face {",
    "  src: url(https://fonts.gstatic.com/s/jost/v19/cyr.ttf);",
    "  unicode-range: U+0400-045F;",
    "}",
    "/* latin */",
    "@font-face {",
    "  src: url(https://fonts.gstatic.com/s/jost/v19/latin.ttf);",
    "  unicode-range: U+0000-00FF;",
    "}",
    sep = "\n"
  )
  expect_identical(
    cardargus:::google_css_latin_url(css_ttf, 'url\\(["\']?([^)"\']+\\.ttf)["\']?\\)'),
    "https://fonts.gstatic.com/s/jost/v19/latin.ttf"
  )
})

test_that("is_woff2_file checks the magic bytes", {
  good <- tempfile(fileext = ".woff2")
  writeBin(c(charToRaw("wOF2"), as.raw(0:9)), good)
  expect_true(cardargus:::is_woff2_file(good))

  bad <- tempfile(fileext = ".woff2")
  writeLines("<html>404 Not Found</html>", bad)
  expect_false(cardargus:::is_woff2_file(bad))

  expect_false(cardargus:::is_woff2_file(tempfile()))
  unlink(c(good, bad))
})

test_that("font_cache_dir invalidates pre-0.3.1 full fonts once, keeping subsets", {
  d <- font_cache_dir(persistent = FALSE)
  marker <- file.path(d, ".cache-v2")

  # Simula um cache de versão anterior: fonte completa (possivelmente o
  # subset cirílico, #27) + um subset de glifos legítimo, sem o marker.
  full <- file.path(d, "Jost.woff2")
  subs <- file.path(d, "Jost_sub0123456789.woff2")
  file.create(full, subs)
  unlink(marker)

  d2 <- font_cache_dir(persistent = FALSE)
  expect_identical(d2, d)
  expect_false(file.exists(full))
  expect_true(file.exists(subs))
  expect_true(file.exists(marker))

  # Com o marker presente, nada mais é apagado
  file.create(full)
  font_cache_dir(persistent = FALSE)
  expect_true(file.exists(full))
  unlink(c(full, subs))
})
