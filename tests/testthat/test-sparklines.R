test_that("create_sparkline returns well-formed standalone SVG", {
  svg <- create_sparkline(c(3, 5, 2, 8, 7))
  expect_type(svg, "character")
  doc <- xml2::read_xml(svg)
  root <- xml2::xml_root(doc)
  expect_equal(xml2::xml_name(root), "svg")
  expect_equal(xml2::xml_attr(root, "width"), "120")
  expect_equal(xml2::xml_attr(root, "height"), "36")

  line <- xml2::xml_find_first(doc, "//*[local-name()='polyline']")
  expect_false(inherits(line, "xml_missing"))
})

test_that("sparkline types produce the expected marks", {
  area <- create_sparkline(c(1, 4, 2, 6), type = "area")
  doc <- xml2::read_xml(area)
  expect_length(xml2::xml_find_all(doc, "//*[local-name()='polygon']"), 1)
  expect_length(xml2::xml_find_all(doc, "//*[local-name()='polyline']"), 1)

  bars <- create_sparkline(c(5, 2, 8, 3, 7), type = "bar")
  doc <- xml2::read_xml(bars)
  expect_length(xml2::xml_find_all(doc, "//*[local-name()='rect']"), 5)
})

test_that("show_last_point controls the end dot", {
  with_dot <- create_sparkline(c(1, 2, 3))
  without <- create_sparkline(c(1, 2, 3), show_last_point = FALSE)
  expect_match(with_dot, "<circle")
  expect_false(grepl("<circle", without, fixed = TRUE))
})

test_that("constant and minimal series are handled", {
  # Constant series: flat mid-height line, no division by zero
  expect_s3_class(xml2::read_xml(create_sparkline(c(5, 5, 5))), "xml_document")
  # Single value is enough for bars
  expect_s3_class(xml2::read_xml(create_sparkline(7, type = "bar")), "xml_document")
  # Zero bars still render a sliver
  expect_match(create_sparkline(c(0, 0), type = "bar"), "<rect")
})

test_that("create_sparkline validates its input via cli", {
  expect_error(create_sparkline(NULL), "numeric vector")
  expect_error(create_sparkline(c(1, NA, 3)), "numeric vector")
  expect_error(create_sparkline("abc"), "numeric vector")
  expect_error(create_sparkline(1), "at least 2")           # line needs 2 points
  expect_error(create_sparkline(numeric(0)), "numeric vector")
  expect_error(create_sparkline(c(1, 2), width = -10), "positive")
})
