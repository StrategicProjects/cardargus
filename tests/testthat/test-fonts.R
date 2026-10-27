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

test_that("is_ttf_file checks sfnt magic bytes", {
  ttf <- tempfile(fileext = ".ttf")
  writeBin(c(as.raw(c(0x00, 0x01, 0x00, 0x00)), as.raw(0:9)), ttf)
  expect_true(cardargus:::is_ttf_file(ttf))

  otf <- tempfile(fileext = ".otf")
  writeBin(c(charToRaw("OTTO"), as.raw(0:9)), otf)
  expect_true(cardargus:::is_ttf_file(otf))

  bad <- tempfile(fileext = ".ttf")
  writeLines("<html>captive portal</html>", bad)
  expect_false(cardargus:::is_ttf_file(bad))

  expect_false(cardargus:::is_ttf_file(tempfile()))
  unlink(c(ttf, otf, bad))
})

test_that("google_css_latin_url tries every URL pattern per block", {
  # Estilos de URL misturados entre blocos: o cirílico com .woff2 explícito,
  # o latin com URL sem extensão — o bloco latin ainda deve vencer.
  css_mixed <- paste(
    "/* cyrillic */",
    "@font-face {",
    "  src: url(https://fonts.gstatic.com/s/jost/v19/cyr.woff2) format('woff2');",
    "  unicode-range: U+0400-045F;",
    "}",
    "/* latin */",
    "@font-face {",
    "  src: url(https://fonts.gstatic.com/l/font?kit=latin123) format('woff2');",
    "  unicode-range: U+0000-00FF;",
    "}",
    sep = "\n"
  )
  expect_identical(
    cardargus:::google_css_latin_url(css_mixed, c(
      woff2_url_pattern,
      'url\\(["\']?([^)"\']+)["\']?\\)\\s*format\\([\'"]woff2[\'"]\\)'
    )),
    "https://fonts.gstatic.com/l/font?kit=latin123"
  )
})

test_that("migrate_font_cache quarantines pre-0.3.1 full fonts once, keeping subsets", {
  # Diretório isolado: o teste não toca o cache compartilhado da sessão.
  d <- file.path(tempfile("fontcache"), "cardargus-fonts")
  dir.create(d, recursive = TRUE)

  # Simula um cache de versão anterior: fonte completa (possivelmente o
  # subset cirílico, #27) + um subset de glifos legítimo, sem o marker.
  full <- file.path(d, "Jost.woff2")
  subs <- file.path(d, "Jost_sub0123456789.woff2")
  file.create(full, subs)

  expect_message(cardargus:::migrate_font_cache(d), "re-downloaded")
  expect_false(file.exists(full))
  expect_true(file.exists(file.path(d, "stale-pre-0.3.1", "Jost.woff2")))
  expect_true(file.exists(subs))
  expect_true(file.exists(file.path(d, ".cache-v2")))

  # Com o marker presente, nada mais é movido
  file.create(full)
  expect_silent(cardargus:::migrate_font_cache(d))
  expect_true(file.exists(full))

  unlink(dirname(d), recursive = TRUE)
})

# ---- Extra @font-face blocks for non-latin text (#29) ------------------------

test_that("google_css_font_blocks returns url, range and subset per block", {
  blocks <- cardargus:::google_css_font_blocks(css2_multiblock, woff2_url_pattern)

  expect_equal(nrow(blocks), 4L)
  expect_identical(
    blocks$subset,
    c("cyrillic-ext", "cyrillic", "latin-ext", "latin")
  )
  expect_identical(
    blocks$url[3],
    "https://fonts.gstatic.com/s/jost/v19/latin-ext.woff2"
  )
  expect_match(blocks$range[3], "U\\+0100-02BA")
  # Bloco único sem unicode-range: range NA, subset NA
  css_single <- "@font-face { src: url(https://x.test/f.woff2) format('woff2'); }"
  single <- cardargus:::google_css_font_blocks(
    css_single,
    'url\\(["\']?([^)"\']+)["\']?\\)\\s*format\\([\'"]woff2[\'"]\\)'
  )
  expect_equal(nrow(single), 1L)
  expect_true(is.na(single$range))
  expect_true(is.na(single$subset))
})

test_that("google_css_latin_block returns the latin block's url AND range", {
  blk <- cardargus:::google_css_latin_block(css2_multiblock, woff2_url_pattern)
  expect_identical(blk$url, "https://fonts.gstatic.com/s/jost/v19/latin.woff2")
  expect_match(blk$range, "U\\+0000-00FF")
  # Sem match algum: NA/NA
  blk_na <- cardargus:::google_css_latin_block("body{}", woff2_url_pattern)
  expect_true(is.na(blk_na$url))
  expect_true(is.na(blk_na$range))
})

test_that("font_block_slug uses the subset name, hashing only as fallback", {
  expect_identical(cardargus:::font_block_slug("latin-ext", "U+0100-02BA"), "latin-ext")
  expect_identical(cardargus:::font_block_slug("Latin Ext!", "U+0100"), "latin-ext")
  hashed <- cardargus:::font_block_slug(NA_character_, "U+0100-02BA")
  expect_match(hashed, "^[0-9a-f]{8}$")
  # Determinístico para o mesmo range
  expect_identical(hashed, cardargus:::font_block_slug(NA_character_, "U+0100-02BA"))
})

test_that("font range sidecars round-trip next to the font file", {
  fp <- tempfile(fileext = ".woff2")
  file.create(fp)

  expect_true(is.na(cardargus:::read_font_range(fp)))
  cardargus:::write_font_range(fp, "U+0000-00FF, U+0131")
  expect_identical(cardargus:::read_font_range(fp), "U+0000-00FF, U+0131")
  # NA não grava nada
  fp2 <- tempfile(fileext = ".woff2")
  cardargus:::write_font_range(fp2, NA_character_)
  expect_false(file.exists(cardargus:::font_range_sidecar(fp2)))

  unlink(c(fp, cardargus:::font_range_sidecar(fp)))
})

test_that("ensure_font_extra_blocks is inert without a primary .range sidecar", {
  # Sem sidecar a fonte primária pode ser local (register_font) ou do gfonts:
  # é tratada como completa e NADA é baixado ou sobreposto.
  fp <- tempfile(fileext = ".woff2")
  file.create(fp)
  out <- cardargus:::ensure_font_extra_blocks("Jost", fp, utf8ToInt("Łódź"))
  expect_equal(nrow(out), 0L)
  unlink(fp)
})

test_that("ensure_font_extra_blocks is a no-op when the primary covers the text", {
  fp <- tempfile(fileext = ".woff2")
  file.create(fp)
  cardargus:::write_font_range(fp, "U+0000-00FF, U+0131, U+2000-206F")
  # pt-BR: todos os acentos estão no Latin-1 Supplement
  out <- cardargus:::ensure_font_extra_blocks(
    "Jost", fp, utf8ToInt(cardargus:::font_subset_charset("Educação"))
  )
  expect_equal(nrow(out), 0L)
  unlink(c(fp, cardargus:::font_range_sidecar(fp)))
})

test_that("ensure_font_extra_blocks serves cached blocks offline", {
  old <- Sys.getenv("_R_CHECK_PACKAGE_NAME_", unset = NA)
  on.exit(
    if (is.na(old)) Sys.unsetenv("_R_CHECK_PACKAGE_NAME_")
    else Sys.setenv("_R_CHECK_PACKAGE_NAME_" = old),
    add = TRUE
  )
  Sys.setenv("_R_CHECK_PACKAGE_NAME_" = "cardargus")  # cache em tempdir

  cache_dir <- font_cache_dir()

  fp <- file.path(cache_dir, "Testfam29.woff2")
  file.create(fp)
  cardargus:::write_font_range(fp, "U+0000-00FF")

  blk <- file.path(cache_dir, "Testfam29_blk-latin-ext.woff2")
  file.create(blk)
  cardargus:::write_font_range(blk, "U+0100-024F, U+1E00-1EFF")

  out <- cardargus:::ensure_font_extra_blocks(
    "Testfam29", fp, utf8ToInt(cardargus:::font_subset_charset("Łódź"))
  )
  expect_equal(nrow(out), 1L)
  expect_identical(out$path, blk)
  expect_identical(out$range, "U+0100-024F, U+1E00-1EFF")

  unlink(c(fp, blk, cardargus:::font_range_sidecar(fp),
           cardargus:::font_range_sidecar(blk)))
})

test_that("embed_svg_fonts embeds several faces with their unicode-ranges", {
  skip_if_not_installed("base64enc")

  svg <- "<svg xmlns='http://www.w3.org/2000/svg'><defs><style>\n</style></defs><text>Ł</text></svg>"

  primary <- tempfile(fileext = ".woff2")
  writeBin(c(charToRaw("wOF2"), as.raw(0:9)), primary)
  extra <- tempfile(fileext = ".woff2")
  writeBin(c(charToRaw("wOF2"), as.raw(9:0)), extra)

  out <- cardargus:::embed_svg_fonts(
    svg, "Jost", c(primary, extra),
    unicode_range = c("U+0000-00FF", "U+0100-024F")
  )

  faces <- gregexpr("@font-face", out, fixed = TRUE)[[1]]
  expect_length(faces, 2L)
  expect_match(out, "unicode-range:U\\+0000-00FF;", perl = TRUE)
  expect_match(out, "unicode-range:U\\+0100-024F;", perl = TRUE)
  # Primário antes do bloco extra
  expect_lt(
    regexpr("U+0000-00FF", out, fixed = TRUE)[1],
    regexpr("U+0100-024F", out, fixed = TRUE)[1]
  )
  # Caminhos inexistentes são ignorados sem derrubar os válidos
  out2 <- cardargus:::embed_svg_fonts(
    svg, "Jost", c(primary, tempfile()),
    unicode_range = c(NA_character_, "U+0100-024F")
  )
  expect_length(gregexpr("@font-face", out2, fixed = TRUE)[[1]], 1L)
  expect_false(grepl("unicode-range", out2, fixed = TRUE))

  unlink(c(primary, extra))
})

test_that("embed_svg_fonts keeps its single-font behavior (no unicode-range)", {
  skip_if_not_installed("base64enc")

  svg <- "<svg xmlns='http://www.w3.org/2000/svg'><text>Oi</text></svg>"
  fp <- tempfile(fileext = ".woff2")
  writeBin(c(charToRaw("wOF2"), as.raw(0:9)), fp)

  out <- cardargus:::embed_svg_fonts(svg, "Jost", fp)
  expect_match(out, '@font-face\\{font-family:"Jost"')
  expect_false(grepl("unicode-range", out, fixed = TRUE))

  # NA/arquivo ausente: SVG devolvido intacto
  expect_identical(cardargus:::embed_svg_fonts(svg, "Jost", NA_character_), svg)

  unlink(fp)
})

test_that("register_font removes a stale .range sidecar left by the CSS API", {
  old <- Sys.getenv("_R_CHECK_PACKAGE_NAME_", unset = NA)
  on.exit(
    if (is.na(old)) Sys.unsetenv("_R_CHECK_PACKAGE_NAME_")
    else Sys.setenv("_R_CHECK_PACKAGE_NAME_" = old),
    add = TRUE
  )
  Sys.setenv("_R_CHECK_PACKAGE_NAME_" = "cardargus")  # cache em tempdir

  cache_dir <- font_cache_dir()
  cached <- file.path(cache_dir, "Testreg29.woff2")
  file.create(cached)
  cardargus:::write_font_range(cached, "U+0000-00FF")

  # Usuário registra a própria fonte (completa) para a mesma família
  local_font <- tempfile(fileext = ".woff2")
  writeBin(c(charToRaw("wOF2"), as.raw(0:9)), local_font)
  suppressMessages(register_font(local_font, family = "Testreg29"))

  # Sem sidecar, nenhum bloco do Google pode sobrepor a fonte local
  expect_false(file.exists(cardargus:::font_range_sidecar(cached)))
  out <- cardargus:::ensure_font_extra_blocks("Testreg29", cached, utf8ToInt("Ł"))
  expect_equal(nrow(out), 0L)

  unlink(c(cached, local_font))
})
