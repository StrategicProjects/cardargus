# Structural tests for svg_card(). We assert on the generated SVG's structure
# (via xml2) instead of snapshotting bytes: font metrics from gdtools vary
# across platforms, so exact coordinates are not portable.

sample_fields <- list(
  list(
    list(label = "Empreendimento", value = "CAIARA II", with_icon = TRUE)
  )
)

sample_badges <- list(
  list(label = "UH", value = "192"),
  list(label = "Recurso", value = "36,4 milhões")
)

test_that("svg_card returns well-formed XML with expected content", {
  svg <- svg_card("FAR", sample_badges, sample_fields,
                  footer = "Atualizado em 2026-10-25", show_viewer = FALSE)
  expect_type(svg, "character")

  doc <- xml2::read_xml(svg)
  root <- xml2::xml_root(doc)
  expect_equal(xml2::xml_name(root), "svg")
  expect_equal(xml2::xml_attr(root, "width"), "500")

  txt <- xml2::xml_text(doc)
  expect_match(txt, "FAR")
  expect_match(txt, "CAIARA II")
  expect_match(txt, "Empreendimento")
  expect_match(txt, "Atualizado em 2026-10-25")
})

test_that("svg_card embeds accessibility nodes (title/desc, role, aria)", {
  svg <- svg_card("FAR", list(), list(), show_viewer = FALSE,
                  alt = "Resumo do programa FAR")
  doc <- xml2::read_xml(svg)
  root <- xml2::xml_root(doc)

  expect_equal(xml2::xml_attr(root, "role"), "img")

  title_node <- xml2::xml_find_first(doc, "//*[local-name()='title']")
  desc_node <- xml2::xml_find_first(doc, "//*[local-name()='desc']")
  expect_equal(xml2::xml_text(title_node), "FAR")
  expect_equal(xml2::xml_text(desc_node), "Resumo do programa FAR")

  # aria-labelledby must reference both node ids
  labelled_by <- strsplit(xml2::xml_attr(root, "aria-labelledby"), " ")[[1]]
  expect_setequal(labelled_by,
                  c(xml2::xml_attr(title_node, "id"), xml2::xml_attr(desc_node, "id")))
})

test_that("svg_card without alt has <title> but no <desc>", {
  svg <- svg_card("FNHIS", list(), list(), show_viewer = FALSE)
  doc <- xml2::read_xml(svg)
  expect_equal(
    xml2::xml_text(xml2::xml_find_first(doc, "//*[local-name()='title']")),
    "FNHIS"
  )
  expect_length(xml2::xml_find_all(doc, "//*[local-name()='desc']"), 0)
})

test_that("svg_card escapes XML special characters in user text", {
  svg <- svg_card("A & B <teste>", list(),
                  list(list(list(label = "L'abel", value = "x > y"))),
                  footer = "\"foo\"", show_viewer = FALSE)
  doc <- xml2::read_xml(svg)  # would fail to parse if unescaped
  txt <- xml2::xml_text(doc)
  expect_match(txt, "A & B <teste>", fixed = TRUE)
  expect_match(txt, "x > y", fixed = TRUE)
})

test_that("gradient backgrounds generate an SVG gradient def", {
  svg <- svg_card("MCMV", list(), list(), show_viewer = FALSE,
                  bg_color = "linear-gradient(to right, #1a5a3a, #2e7d32)")
  doc <- xml2::read_xml(svg)
  grad <- xml2::xml_find_first(doc, "//*[local-name()='linearGradient']")
  expect_false(inherits(grad, "xml_missing"))

  bg_rect <- xml2::xml_find_first(doc, "//*[local-name()='rect'][@fill]")
  expect_match(xml2::xml_attr(bg_rect, "fill"), "^url\\(#")
})

test_that("theme= applies preset colors and explicit args win over it", {
  th <- card_theme("dark")
  svg <- svg_card("FAR", list(), sample_fields, theme = "dark", show_viewer = FALSE)
  expect_match(svg, sprintf('fill="%s"', th$bg_color), fixed = TRUE)
  expect_match(svg, sprintf('fill="%s"', th$value_bg_color), fixed = TRUE)
  expect_match(svg, sprintf('stroke="%s"', th$value_border_color), fixed = TRUE)

  # Explicit argument beats the theme
  svg2 <- svg_card("FAR", list(), sample_fields, theme = "dark",
                   bg_color = "#123456", show_viewer = FALSE)
  expect_match(svg2, 'fill="#123456"', fixed = TRUE)
  expect_false(grepl(sprintf('fill="%s"', th$bg_color), svg2, fixed = TRUE))
})

test_that("theme= accepts a cardargus_theme object", {
  my <- card_theme("ocean", footer_color = "#cceeff")
  svg <- svg_card("FAR", list(), list(), theme = my,
                  footer = "nota", show_viewer = FALSE)
  expect_match(svg, "fill: #cceeff", fixed = TRUE)
})

test_that("value_border_color is honored", {
  svg <- svg_card("FAR", list(), sample_fields,
                  value_border_color = "#ff0000", show_viewer = FALSE)
  expect_match(svg, 'stroke="#ff0000"', fixed = TRUE)
})
