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
