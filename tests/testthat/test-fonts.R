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
