library(testthat)
library(cardargus)

test_that("is_light_color works correctly", {
  expect_true(is_light_color("#FFFFFF"))
  expect_true(is_light_color("#fff"))
  expect_true(is_light_color("white"))
  expect_false(is_light_color("#000000"))
  expect_false(is_light_color("black"))
  expect_true(is_light_color("#fab255"))
})

test_that("compress_number formats correctly", {
  expect_equal(compress_number(1000000000), "1,0 bilhões")
  expect_equal(compress_number(36400000), "36,4 milhões")
  expect_equal(compress_number(1500), "1,5 mil")
  expect_equal(compress_number(500), "500,0")
  expect_equal(compress_number(0), "0,0")
  expect_equal(compress_number(NA), "S/I")
})

test_that("badge_svg generates valid SVG", {
  badge <- badge_svg("Test", "Value", "white")
  expect_true(grepl("<svg", badge))
  expect_true(grepl("</svg>", badge))
  expect_true(grepl("Test", badge))
  expect_true(grepl("Value", badge))
})

test_that("badge_svg handles different colors", {
  badge_light <- badge_svg("Test", "Value", "#FFFFFF")
  badge_dark <- badge_svg("Test", "Value", "#000000")
  
  # Light background should have dark text
  expect_true(grepl('fill="#333"', badge_light))
  # Dark background should have white text
  expect_true(grepl('fill="#fff"', badge_dark))
})

test_that("house_icon_svg generates valid SVG", {
  icon <- house_icon_svg(50, 56)
  expect_true(grepl("<svg", icon))
  expect_true(grepl("</svg>", icon))
  expect_true(grepl('width="50"', icon))
  expect_true(grepl('height="56"', icon))
})

test_that("svg_card generates valid SVG", {
  card <- svg_card(
    title = "TEST",
    badges_data = list(
      list(label = "A", value = "1")
    ),
    fields = list(
      list(list(label = "Field", value = "Value"))
    )
  )
  
  expect_true(grepl("<svg", card))
  expect_true(grepl("</svg>", card))
  expect_true(grepl("TEST", card))
  expect_true(grepl("Field", card))
  expect_true(grepl("Value", card))
})

test_that("svg_card generates complete card", {
  card <- svg_card(
    title = "FAR",
    badges_data = list(list(label = "Units", value = "100")),
    fields = list(
      list(list(label = "Project", value = "Test Project")),
      list(list(label = "City", value = "Test City"))
    ),
    bg_color = "#fab255",
    width = 500
  )
  
  expect_true(grepl("<svg", card))
  expect_true(grepl("FAR", card))
  expect_true(grepl("Test Project", card))
  expect_true(grepl("Test City", card))
})

test_that("escape_xml escapes special characters", {
  # This is an internal function
  result <- cardargus:::escape_xml("Test & <value>")
  expect_equal(result, "Test &amp; &lt;value&gt;")
})

test_that("badge_row_svg combines multiple badges", {
  badges <- list(
    list(label = "A", value = "1"),
    list(label = "B", value = "2")
  )
  row <- badge_row_svg(badges)
  
  expect_true(grepl("<svg", row))
  expect_true(grepl("</svg>", row))
})
