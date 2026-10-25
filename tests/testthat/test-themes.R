test_that("card_themes lists the presets", {
  themes <- card_themes()
  expect_true(all(c("default", "light", "dark", "ocean", "forest") %in% themes))
})

test_that("card_theme returns a complete theme for every preset", {
  required <- c("bg_color", "title_color", "label_color", "value_bg_color",
                "value_text_color", "value_border_color", "footer_color")
  for (nm in card_themes()) {
    th <- card_theme(nm)
    expect_s3_class(th, "cardargus_theme")
    expect_true(all(required %in% names(th)), info = nm)
  }
})

test_that("card_theme applies named overrides", {
  th <- card_theme("dark", bg_color = "#000000", footer_color = "red")
  expect_equal(th$bg_color, "#000000")
  expect_equal(th$footer_color, "red")
  # Untouched components keep the preset value
  expect_equal(th$value_bg_color, card_theme("dark")$value_bg_color)
})

test_that("card_theme accepts a theme object as base", {
  base <- card_theme("ocean", footer_color = "#cceeff")
  th <- card_theme(base, bg_color = "#111111")
  expect_equal(th$footer_color, "#cceeff")
  expect_equal(th$bg_color, "#111111")
})

test_that("card_theme validates its input via cli", {
  expect_error(card_theme("naoexiste"), "Unknown theme")
  expect_error(card_theme(42), "single theme name")
  expect_error(card_theme("dark", "#fff"), "must be named")
  expect_error(card_theme("dark", not_a_component = "x"), "Unknown theme component")
})

test_that("theme names are case-insensitive", {
  expect_identical(card_theme("Dark"), card_theme("dark"))
})
