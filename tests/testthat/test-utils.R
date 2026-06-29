test_that("compress_number formats with Brazilian locale and suffixes", {
  expect_equal(compress_number(0), "0,0")
  expect_equal(compress_number(999), "999,0")
  expect_match(compress_number(1234567), "milh")
  expect_match(compress_number(36400000), "milh")
  expect_match(compress_number(2.5e9), "bilh")
  expect_match(compress_number(1500), "mil")
})

test_that("compress_number handles NULL / NA / non-scalar safely", {
  expect_equal(compress_number(NA), "S/I")
  expect_equal(compress_number(NULL), "S/I")
  # Non-scalar input must not error (regression: issue #2)
  expect_equal(compress_number(c(1500, 2e6)), "S/I")
})

test_that("is_light_color classifies hex and named colors", {
  expect_true(is_light_color("#FFFFFF"))
  expect_false(is_light_color("#000000"))
  expect_true(is_light_color("#FFF"))   # 3-digit shorthand
  expect_true(is_light_color("white"))
  expect_false(is_light_color("black"))
})

test_that("is_light_color rejects invalid input (issue #5)", {
  expect_error(is_light_color(NA))
  expect_error(is_light_color(NULL))
  expect_error(is_light_color("#GGGGGG"))
  expect_error(is_light_color(c("#fff", "#000")))
})

test_that("is_light_color rejects an unknown color name via cli (issue #20)", {
  expect_error(is_light_color("notacolor"), "valid color")
})

test_that("escape_xml escapes special characters and tolerates NA/NULL (issue #2)", {
  expect_equal(escape_xml("a & b < c > d"), "a &amp; b &lt; c &gt; d")
  expect_equal(escape_xml("\"x\" 'y'"), "&quot;x&quot; &apos;y&apos;")
  expect_equal(escape_xml(NULL), "")
  expect_equal(escape_xml(NA), "")
  # Vectorized: must not error on length > 1
  expect_equal(escape_xml(c("a&b", NA)), c("a&amp;b", ""))
})

test_that("generate_id is deterministic within a session and unique per call (issue #12)", {
  st <- cardargus:::.cardargus_state
  st$id_counter <- 0L
  a1 <- cardargus:::generate_id("x", "y")
  a2 <- cardargus:::generate_id("x", "y")
  expect_false(identical(a1, a2))  # unique across calls

  st$id_counter <- 0L
  b1 <- cardargus:::generate_id("x", "y")
  expect_identical(a1, b1)         # reproducible from same counter state
})
