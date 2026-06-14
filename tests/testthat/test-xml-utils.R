# Robustness tests for the xml2-backed SVG parsing helpers (issue #13).

test_that("svg_dimension reads width/height in CSS px", {
  svg <- '<svg xmlns="http://www.w3.org/2000/svg" width="500" height="320"></svg>'
  expect_equal(cardargus:::svg_dimension(svg, "width"), 500)
  expect_equal(cardargus:::svg_dimension(svg, "height"), 320)
})

test_that("svg_dimension handles units and single quotes", {
  svg <- "<svg xmlns='http://www.w3.org/2000/svg' width='40px' height='100%'></svg>"
  expect_equal(cardargus:::svg_dimension(svg, "width"), 40)
  expect_equal(cardargus:::svg_dimension(svg, "height"), 100)
})

test_that("svg_dimension is robust to attribute order and multiline tags", {
  svg <- '<svg\n  xmlns="http://www.w3.org/2000/svg"\n  viewBox="0 0 640 480"\n  height="240"\n  width="320">\n</svg>'
  expect_equal(cardargus:::svg_dimension(svg, "width", prefer = "attr"), 320)
  expect_equal(cardargus:::svg_dimension(svg, "width", prefer = "viewBox"), 640)
  expect_equal(cardargus:::svg_dimension(svg, "height", prefer = "viewBox"), 480)
})

test_that("svg_dimension falls back to viewBox (incl. comma separators)", {
  svg <- '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0,0,200,100"></svg>'
  expect_equal(cardargus:::svg_dimension(svg, "width"), 200)
  expect_equal(cardargus:::svg_dimension(svg, "height"), 100)
})

test_that("svg_dims returns both dimensions", {
  svg <- '<svg xmlns="http://www.w3.org/2000/svg" width="80" height="40"></svg>'
  d <- cardargus:::svg_dims(svg)
  expect_equal(d$width, 80)
  expect_equal(d$height, 40)
})

test_that("regex fallback matches xml2 path for dimensions", {
  svg <- '<svg width="123" height="45" viewBox="0 0 246 90"></svg>'
  expect_equal(cardargus:::svg_geometry_regex(svg)$attr_w, 123)
  expect_equal(cardargus:::svg_geometry_regex(svg)$attr_h, 45)
  expect_equal(cardargus:::svg_geometry_regex(svg)$vb_w, 246)
  expect_equal(cardargus:::svg_geometry_regex(svg)$vb_h, 90)
})

test_that("svg_font_families finds attribute and CSS families, drops generics", {
  svg <- paste0(
    '<svg xmlns="http://www.w3.org/2000/svg">',
    '<style>.t{font-family:"Jost", sans-serif;}</style>',
    '<text font-family="Montserrat">hi</text>',
    '<text font-family=\'Open Sans, serif\'>yo</text>',
    '</svg>'
  )
  fams <- cardargus:::svg_font_families(svg)
  expect_true(all(c("Jost", "Montserrat", "Open Sans") %in% fams))
  expect_false(any(c("sans-serif", "serif") %in% fams))
})

test_that("svg_font_families_regex agrees with the xml2 path", {
  svg <- '<svg><text font-family="Jost">x</text></svg>'
  expect_equal(cardargus:::svg_font_families_regex(svg), "Jost")
})

test_that("helpers tolerate non-parseable / empty input via fallback", {
  expect_equal(cardargus:::svg_dimension("not xml at all", "width"), NA_real_)
  expect_equal(cardargus:::svg_font_families(""), character())
})
