# Tests for chrome.R helpers.
# Pure helpers are tested everywhere; rendering tests need Chrome and are
# skipped on CRAN.

test_that("build_svg_html wraps the SVG and extracts dimensions", {
  svg <- '<svg xmlns="http://www.w3.org/2000/svg" width="500" height="130"><rect/></svg>'
  page <- build_svg_html(svg)

  expect_type(page$html, "character")
  expect_equal(page$width, 500L)
  expect_equal(page$height, 130L)
  expect_match(page$html, "width: 500px", fixed = TRUE)
  expect_match(page$html, "height: 130px", fixed = TRUE)
  expect_match(page$html, "<rect/>", fixed = TRUE)
})

test_that("build_svg_html falls back to default dimensions", {
  page <- build_svg_html('<svg xmlns="http://www.w3.org/2000/svg"><rect/></svg>')
  expect_equal(page$width, 800L)
  expect_equal(page$height, 500L)
})

test_that("build_svg_html applies the requested background", {
  svg <- '<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10"/>'
  page <- build_svg_html(svg, background = "white")
  expect_match(page$html, "background: white", fixed = TRUE)
})

test_that("chrome_session_alive is FALSE for NULL", {
  expect_false(chrome_session_alive(NULL))
})

test_that("svg_to_png_chrome renders a card deterministically", {
  skip_on_cran()
  skip_if_not_installed("chromote")
  skip_if_not_installed("base64enc")
  skip_if_not(chrome_available(), "Chrome not available")

  svg <- svg_card("Chrome test")
  p1 <- svg_to_png_chrome(svg, tempfile(fileext = ".png"), dpi = 96)
  p2 <- svg_to_png_chrome(svg, tempfile(fileext = ".png"), dpi = 96)

  expect_true(file.exists(p1))
  expect_gt(file.size(p1), 1000)
  # Persistent session: repeated conversions give byte-identical output
  expect_identical(readBin(p1, "raw", file.size(p1)),
                   readBin(p2, "raw", file.size(p2)))
})

test_that("svg_to_png_chrome self-heals after a dead session", {
  skip_on_cran()
  skip_if_not_installed("chromote")
  skip_if_not_installed("base64enc")
  skip_if_not(chrome_available(), "Chrome not available")

  svg <- svg_card("Heal test")
  b <- chrome_session()
  b$close()

  p <- svg_to_png_chrome(svg, tempfile(fileext = ".png"), dpi = 96)
  expect_true(file.exists(p))
  expect_gt(file.size(p), 1000)
})

test_that("svg_to_pdf_chrome produces a PDF", {
  skip_on_cran()
  skip_if_not_installed("chromote")
  skip_if_not_installed("base64enc")
  skip_if_not(chrome_available(), "Chrome not available")

  svg <- svg_card("PDF test")
  p <- svg_to_pdf_chrome(svg, tempfile(fileext = ".pdf"))
  expect_true(file.exists(p))
  expect_identical(readBin(p, "raw", 4), charToRaw("%PDF"))
})
