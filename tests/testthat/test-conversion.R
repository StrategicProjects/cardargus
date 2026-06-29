test_that("parse_svg_root_dim reads width/height attributes", {
  svg <- '<svg xmlns="http://www.w3.org/2000/svg" width="500" height="320"></svg>'
  expect_equal(cardargus:::parse_svg_root_dim(svg, "width"), 500)
  expect_equal(cardargus:::parse_svg_root_dim(svg, "height"), 320)
})

test_that("parse_svg_root_dim falls back to viewBox", {
  svg <- '<svg viewBox="0 0 640 480"></svg>'
  expect_equal(cardargus:::parse_svg_root_dim(svg, "width"), 640)
  expect_equal(cardargus:::parse_svg_root_dim(svg, "height"), 480)
})

test_that("sanitize_svg_for_raster strips Inkscape metadata and @import", {
  svg <- paste0(
    '<svg xmlns="http://www.w3.org/2000/svg">',
    '<sodipodi:namedview id="nv"/>',
    '<style>@import url("https://fonts.googleapis.com/css2?family=Jost");</style>',
    '<rect sodipodi:role="line" width="10" height="10"/>',
    '</svg>'
  )
  out <- cardargus:::sanitize_svg_for_raster(svg)
  expect_false(grepl("sodipodi", out))
  expect_false(grepl("@import", out))
  expect_match(out, "<rect")
})

test_that("detect_svg_fonts finds families and drops generics", {
  svg <- paste0(
    '<svg><style>.t{font-family:"Jost", sans-serif;}</style>',
    '<text font-family="Montserrat">hi</text></svg>'
  )
  fams <- cardargus:::detect_svg_fonts(svg)
  expect_true("Jost" %in% fams)
  expect_true("Montserrat" %in% fams)
  expect_false("sans-serif" %in% fams)
})

test_that("svg_to_pdf writes a vector PDF", {
  skip_if_not_installed("rsvg")
  svg <- '<svg xmlns="http://www.w3.org/2000/svg" width="120" height="80"><rect width="120" height="80" fill="#4CAF50"/></svg>'
  out <- tempfile(fileext = ".pdf")
  res <- svg_to_pdf(svg, out)
  expect_identical(res, out)
  expect_true(file.exists(out))
  expect_gt(file.info(out)$size, 0)
  # PDF files start with the "%PDF" magic header
  hdr <- readBin(out, "raw", n = 4)
  expect_identical(rawToChar(hdr), "%PDF")
})

test_that("svg_to_pdf infers a temp output path when NULL", {
  skip_if_not_installed("rsvg")
  svg <- '<svg xmlns="http://www.w3.org/2000/svg" width="50" height="50"><circle cx="25" cy="25" r="20"/></svg>'
  out <- svg_to_pdf(svg)
  expect_true(file.exists(out))
  expect_match(out, "\\.pdf$")
})
