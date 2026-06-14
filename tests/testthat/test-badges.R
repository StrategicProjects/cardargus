test_that("css_gradient_to_svg parses direction keywords", {
  out <- cardargus:::css_gradient_to_svg("linear-gradient(to right, #1a5a3a, #2e7d32)")
  expect_match(out, "<linearGradient")
  expect_match(out, 'x1="0%"')
  expect_match(out, 'x2="100%"')
  expect_match(out, "#1a5a3a")
  expect_match(out, "#2e7d32")
})

test_that("css_gradient_to_svg handles degree angles", {
  out <- cardargus:::css_gradient_to_svg("linear-gradient(135deg, #667eea, #764ba2)")
  expect_match(out, "<linearGradient")
  expect_match(out, "#667eea")
})

test_that("css_gradient_to_svg keeps a single color instead of inventing black (issue #4)", {
  out <- cardargus:::css_gradient_to_svg("linear-gradient(to right, #abcdef)")
  expect_match(out, "#abcdef")
  expect_false(grepl("#000000", out))
})

test_that("css_gradient_to_svg falls back when no colors are present", {
  out <- cardargus:::css_gradient_to_svg("linear-gradient(to right)")
  expect_match(out, "#ffffff")
  expect_match(out, "#000000")
})

test_that("create_badge accepts gradient background colors (issue #14)", {
  expect_no_error(b1 <- create_badge("Test", "OK", "linear-gradient(to right, #4CAF50)"))
  expect_match(b1, "#4CAF50")

  expect_no_error(b2 <- create_badge("Test", "OK", "linear-gradient(135deg, #1a5a3a, #2e7d32)"))
  expect_match(b2, "linearGradient")
  expect_match(b2, "#2e7d32")
})

test_that("create_badge works with solid colors", {
  b <- create_badge("UH", "192", "white")
  expect_match(b, "<svg")
  expect_match(b, "192")
})
