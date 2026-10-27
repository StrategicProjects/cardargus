#' Get the path to package SVGs directory
#'
#' Returns the path to the inst/svgs directory where SVG files are stored.
#'
#' @return Character string with the path to SVGs directory
#' @export
svgs_dir <- function() {
  system.file("svgs", package = "cardargus")
}

#' Get path to a bundled SVG file
#'
#' Returns the full path to a SVG file bundled with the package.
#'
#' @param filename Name of the SVG file (e.g., "morar_bem.svg")
#' @param height Optional target height (px). If provided, returns the SVG content resized
#'   for embedding instead of the file path.
#' @param width Optional target width (px). Only used when returning resized SVG content.
#'
#' @return If `height` and `width` are both NULL, returns the full file path.
#'   Otherwise returns the resized SVG content (character string).
#' @export
get_svg_path <- function(filename, height = NULL, width = NULL) {
  path <- system.file("svgs", filename, package = "cardargus")
  if (path == "") {
    available <- list.files(svgs_dir(), pattern = "\\.svg$", full.names = FALSE)
    cli::cli_abort(c(
      "x" =  glue::glue("SVG file {.val {filename}} not found.", filename = filename),
      "i" = glue::glue("Available files: {.val {available}}", available = available)
    ))
  }
  
  if (is.null(height) && is.null(width)) {
    return(path)
  }
  
  if (!exists("load_svg_for_embed", mode = "function")) {
    cli::cli_abort("Internal helper {.fn load_svg_for_embed} was not found.")
  }
  
  if (is.null(height)) height <- 40
  load_svg_for_embed(svg_path = path, target_height = height, target_width = width)$svg_content
}

#' List available bundled SVG files
#'
#' @return Character vector of available SVG filenames
#' @export
list_bundled_svgs <- function() {
  dir <- svgs_dir()
  if (dir == "") return(character(0))
  list.files(dir, pattern = "\\.svg$", full.names = FALSE)
}

# ------------------------------------------------------------------------------
# Optional: register fonts for interactive devices (showtext/sysfonts)
# ------------------------------------------------------------------------------

#' Register Google Font (sysfonts)
#'
#' Registers a Google Font using \pkg{sysfonts}.
#'
#' @param font_family Font family name (e.g., "Jost")
#' @return Invisible NULL
#' @export
register_google_font <- function(font_family) {
  if (!requireNamespace("sysfonts", quietly = TRUE)) {
    cli::cli_abort(c(
      "x" = "Package {.pkg sysfonts} is required.",
      "i" = "Install with: {.code install.packages('sysfonts')}"
    ))
  }
  tryCatch(
    sysfonts::font_add_google(name = font_family, family = font_family),
    error = function(e) cli::cli_warn("Could not register font {.val {font_family}}: {e$message}")
  )
  invisible(NULL)
}

#' Setup showtext for cardargus
#'
#' Registers fonts (via sysfonts) and optionally enables showtext auto mode.
#'
#' @param fonts Character vector of Google Font names to register.
#' @param auto Enable showtext auto mode.
#' @return Invisible NULL
#' @export
setup_fonts <- function(fonts = c("Jost", "Montserrat"), auto = TRUE) {
  if (!requireNamespace("showtext", quietly = TRUE)) {
    cli::cli_abort(c(
      "x" = "Package {.pkg showtext} is required.",
      "i" = "Install with: {.code install.packages('showtext')}"
    ))
  }
  if (!requireNamespace("sysfonts", quietly = TRUE)) {
    cli::cli_abort(c(
      "x" = "Package {.pkg sysfonts} is required.",
      "i" = "Install with: {.code install.packages('sysfonts')}"
    ))
  }
  
  for (fam in fonts) {
    tryCatch(
      sysfonts::font_add_google(name = fam, family = fam),
      error = function(e) cli::cli_warn("Could not register font {.val {fam}}: {e$message}")
    )
  }
  
  if (isTRUE(auto)) showtext::showtext_auto()
  invisible(NULL)
}

# ------------------------------------------------------------------------------
# Internal: cache + download WOFF2 from Google Fonts
# ------------------------------------------------------------------------------

#' Get font cache directory
#'
#' Returns the directory where cardargus caches downloaded font files.
#' Fonts in this directory are automatically embedded in SVG/PNG exports.
#'
#' @param persistent Logical. If TRUE (default), uses persistent cache via
#'   \code{tools::R_user_dir()}. If FALSE or if persistent cache is unavailable,
#'   uses a session-specific temporary directory.
#'
#'   When running under \code{R CMD check} (detected via the
#'   \code{_R_CHECK_PACKAGE_NAME_} environment variable), a session-specific
#'   temporary directory is always used, so examples, tests and vignettes never
#'   write to the user's home filespace (per CRAN policy).
#' @return A character path to the cache directory.
#' @export
font_cache_dir <- function(persistent = TRUE) {
  # Never write to the user's home filespace during R CMD check / examples.
  if (persistent && running_under_check()) {
    persistent <- FALSE
  }

  if (persistent) {
    dir <- tryCatch(
      tools::R_user_dir("cardargus", which = "cache"),
      error = function(e) NULL
    )
  } else {
    dir <- NULL
  }

  if (is.null(dir)) {
    dir <- file.path(tempdir(), "cardargus-fonts")
  }

  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE, showWarnings = FALSE)

  migrate_font_cache(dir)

  dir
}

#' One-time quarantine of full fonts cached before 0.3.1
#'
#' Versões < 0.3.1 salvavam como fonte "completa" o primeiro bloco
#' `@font-face` da resposta do Google, que é o subset CIRÍLICO (#27). Esta
#' migração roda uma única vez por diretório de cache (marker `.cache-v2`) e
#' move as fontes completas para a subpasta `stale-pre-0.3.1/` — elas serão
#' re-baixadas sob demanda. Nada é apagado: fontes locais registradas via
#' [register_font()] vivem no mesmo diretório com o mesmo padrão de nome e
#' podem ser restauradas da quarentena (ou re-registradas). Subsets de glifos
#' ("_sub<hash>") não são afetados e ficam no cache.
#'
#' @param dir Diretório de cache de fontes.
#' @return `TRUE` (invisível) se a migração rodou nesta chamada.
#' @keywords internal
migrate_font_cache <- function(dir) {
  marker <- file.path(dir, ".cache-v2")
  if (file.exists(marker)) return(invisible(FALSE))

  # Diretório só-leitura: não insista (os renames falhariam) e não fique
  # re-escaneando o diretório a cada chamada.
  if (!file.create(marker, showWarnings = FALSE)) return(invisible(FALSE))

  stale <- list.files(dir, pattern = "\\.(woff2|ttf|woff|otf)$", full.names = TRUE)
  stale <- stale[!grepl("_sub[0-9a-f]{10}\\.", basename(stale))]
  stale <- stale[!grepl("_blk-", basename(stale), fixed = TRUE)]

  if (length(stale)) {
    quarantine <- file.path(dir, "stale-pre-0.3.1")
    dir.create(quarantine, showWarnings = FALSE)
    file.rename(stale, file.path(quarantine, basename(stale)))
    cli::cli_alert_info(paste(
      "cardargus: {length(stale)} cached full font{?s} moved to",
      "{.path {quarantine}} and will be re-downloaded (fonts cached by",
      "versions < 0.3.1 could be a Cyrillic-only subset, see issue #27).",
      "If you had registered local fonts with {.fn register_font},",
      "restore them from that folder or register them again."
    ))
  }

  invisible(TRUE)
}

#' Is the package being checked by `R CMD check`?
#'
#' @description
#' `R CMD check` sets the `_R_CHECK_PACKAGE_NAME_` environment variable for the
#' duration of the check (including while running examples, tests and
#' vignettes). We use it to route the font cache to a temporary directory so the
#' check never writes to the user's home filespace.
#'
#' @return `TRUE` when running under `R CMD check`, otherwise `FALSE`.
#' @keywords internal
running_under_check <- function() {
  nzchar(Sys.getenv("_R_CHECK_PACKAGE_NAME_"))
}

#' Sanitize a font family name into its cache key
#'
#' Todo caminho de cache (primário, subsets `_sub`, blocos `_blk-` e sidecars
#' `.range`) deriva DESTA mesma chave — mudanças aqui realinham todos os
#' arquivos de uma vez.
#'
#' @param family Font family name.
#' @return Chave estável para nomes de arquivo.
#' @keywords internal
font_cache_key <- function(family) {
  gsub("[^A-Za-z0-9._-]+", "_", family)
}

#' Build a cache filename for a font family
#'
#' @param family Font family name.
#' @param text Optional normalized character set (see [font_subset_charset()]).
#'   When supplied, the cache key gets a stable suffix derived from the
#'   character set, so each subset is cached separately from the full font.
#' @return Path to the cached font file.
#' @keywords internal
font_cache_path <- function(family, text = NULL) {
  key <- font_cache_key(family)
  if (!is.null(text) && nzchar(text)) {
    key <- paste0(key, "_sub", substr(digest::digest(text, algo = "md5"), 1, 10))
  }
  file.path(font_cache_dir(), paste0(key, ".woff2"))
}

#' Normalize text into a stable character set for font subsetting
#'
#' Collapses the input, deduplicates and sorts its characters. Two texts using
#' the same glyphs therefore map to the same subset (and the same cache file),
#' regardless of character order or repetition.
#'
#' @param text Character vector (or NULL).
#' @return A single string with the sorted unique characters, or `NULL` when
#'   there is no usable text.
#' @keywords internal
font_subset_charset <- function(text) {
  if (is.null(text)) return(NULL)
  text <- paste(as.character(text), collapse = "")
  if (is.na(text) || !nzchar(text)) return(NULL)
  chars <- sort(unique(strsplit(text, "")[[1]]))
  paste(chars, collapse = "")
}

#' Does a CSS unicode-range cover a given code point?
#'
#' @param range Conteúdo de uma declaração `unicode-range:` (sem o nome da
#'   propriedade), ex. `"U+0000-00FF, U+0131, U+4??"`.
#' @param codepoint Code point (inteiro) a testar.
#' @return `TRUE` se algum token do range cobre o code point.
#' @keywords internal
unicode_range_covers <- function(range, codepoint) {
  tokens <- strsplit(gsub("\\s", "", range), ",", fixed = TRUE)[[1]]
  for (tok in tokens) {
    tok <- toupper(sub("^U\\+", "", tok, ignore.case = TRUE))
    if (grepl("?", tok, fixed = TRUE)) {
      # Wildcard: U+4?? cobre 0x400-0x4FF.
      lo <- strtoi(gsub("?", "0", tok, fixed = TRUE), base = 16L)
      hi <- strtoi(gsub("?", "F", tok, fixed = TRUE), base = 16L)
    } else if (grepl("-", tok, fixed = TRUE)) {
      parts <- strsplit(tok, "-", fixed = TRUE)[[1]]
      lo <- strtoi(parts[1], base = 16L)
      hi <- strtoi(parts[2], base = 16L)
    } else {
      lo <- hi <- strtoi(tok, base = 16L)
    }
    if (!is.na(lo) && !is.na(hi) && codepoint >= lo && codepoint <= hi) {
      return(TRUE)
    }
  }
  FALSE
}

#' Parse the @font-face blocks of a Google Fonts CSS response
#'
#' O Google divide a resposta da CSS API em um bloco `@font-face` por script
#' (cyrillic-ext, cyrillic, ..., latin, latin-ext, vietnamese...), cada um
#' precedido por um comentário `/* nome-do-subset */` e com seu próprio
#' `unicode-range`. Este helper devolve um data.frame com uma linha por bloco
#' que tenha URL extraível: `url`, `range` (conteúdo do `unicode-range`, ou
#' `NA` em respostas de bloco único, ex. subsets via `&text=`) e `subset`
#' (nome do comentário, ou `NA`).
#'
#' @param css Resposta CSS da Google Fonts API.
#' @param url_patterns Um ou mais regexes, cada um com um grupo de captura
#'   extraindo a URL da fonte de dentro de um bloco; em cada bloco, vale o
#'   primeiro padrão que casar (assim uma resposta misturando estilos de URL
#'   entre blocos não esconde nenhum bloco).
#' @return data.frame com colunas `url`, `range`, `subset` (0 linhas se nada
#'   casar).
#' @keywords internal
google_css_font_blocks <- function(css, url_patterns) {
  # O comentário é incluído no match e extraído depois, bloco a bloco.
  pat <- "(?:/\\*\\s*[^*]*?\\s*\\*/\\s*)?@font-face\\s*\\{[^}]*\\}"
  blocks <- regmatches(css, gregexpr(pat, css, perl = TRUE))[[1]]
  if (!length(blocks)) blocks <- css

  urls <- vapply(blocks, function(b) {
    for (p in url_patterns) {
      hit <- regmatches(b, regexec(p, b))[[1]]
      if (length(hit) >= 2) return(hit[2])
    }
    NA_character_
  }, character(1), USE.NAMES = FALSE)

  ranges <- vapply(blocks, function(b) {
    r <- regmatches(b, regexec("unicode-range:\\s*([^;}]+)", b))[[1]]
    if (length(r) >= 2) trimws(r[2]) else NA_character_
  }, character(1), USE.NAMES = FALSE)

  subsets <- vapply(blocks, function(b) {
    r <- regmatches(b, regexec("^/\\*\\s*([^*]*?)\\s*\\*/", b))[[1]]
    if (length(r) >= 2 && nzchar(r[2])) r[2] else NA_character_
  }, character(1), USE.NAMES = FALSE)

  keep <- !is.na(urls)
  data.frame(url = urls[keep], range = ranges[keep], subset = subsets[keep],
             stringsAsFactors = FALSE)
}

#' Extract the Latin-script @font-face block from a Google CSS response
#'
#' Devolve URL e `unicode-range` do bloco cujo range cobre o Latin básico
#' (testa `U+0041`, "A") — pegar a primeira `url()` da resposta devolvia o
#' subset cirílico como se fosse a fonte completa (#27). Quando nenhum bloco
#' declara `unicode-range` cobrindo Latin (respostas de bloco único, ex.
#' subsets via `&text=` ou TTF), vale o primeiro bloco com URL.
#'
#' @inheritParams google_css_font_blocks
#' @return `list(url =, range =)`; ambos `NA` se nada casar.
#' @keywords internal
google_css_latin_block <- function(css, url_patterns) {
  blocks <- google_css_font_blocks(css, url_patterns)
  if (!nrow(blocks)) return(list(url = NA_character_, range = NA_character_))

  covers <- vapply(seq_len(nrow(blocks)), function(i) {
    !is.na(blocks$range[i]) && unicode_range_covers(blocks$range[i], 0x41L)
  }, logical(1))

  i <- if (any(covers)) which(covers)[1] else 1L
  list(url = blocks$url[i], range = blocks$range[i])
}

#' Extract the Latin-script font URL from a Google Fonts CSS response
#'
#' Wrapper de [google_css_latin_block()] que devolve só a URL.
#'
#' @inheritParams google_css_font_blocks
#' @return A URL da fonte, ou `NA_character_`.
#' @keywords internal
google_css_latin_url <- function(css, url_patterns) {
  google_css_latin_block(css, url_patterns)$url
}

#' Range sidecar files: remember the unicode-range of a cached font file
#'
#' Fontes baixadas da CSS API ganham um arquivo `.range` ao lado (mesmo nome,
#' extensão trocada) com o conteúdo do `unicode-range` do bloco de origem. O
#' sidecar marca a PROVENIÊNCIA: só fontes com `.range` são blocos parciais da
#' CSS API e podem ganhar blocos extras (#29). Fontes do `gfonts` e locais via
#' [register_font()] não têm sidecar e são tratadas como completas.
#'
#' @param font_path Caminho do arquivo de fonte cacheado.
#' @param range Conteúdo do `unicode-range` a gravar.
#' @return `read_font_range()`: o range, ou `NA_character_` sem sidecar.
#' @keywords internal
font_range_sidecar <- function(font_path) {
  paste0(tools::file_path_sans_ext(font_path), ".range")
}

#' @rdname font_range_sidecar
#' @keywords internal
read_font_range <- function(font_path) {
  sidecar <- font_range_sidecar(font_path)
  if (!file.exists(sidecar)) return(NA_character_)
  out <- tryCatch(readLines(sidecar, n = 1L, warn = FALSE),
                  error = function(e) character(0))
  if (length(out) && nzchar(out)) out[1] else NA_character_
}

#' @rdname font_range_sidecar
#' @keywords internal
write_font_range <- function(font_path, range) {
  if (is.na(range) || !nzchar(range)) return(invisible(NULL))
  tryCatch(writeLines(range, font_range_sidecar(font_path)),
           error = function(e) NULL)
  invisible(NULL)
}

#' Is a file a WOFF2 font?
#'
#' Confere os magic bytes (`wOF2`) para não cachear como fonte uma página de
#' erro HTML que tenha passado pela checagem de tamanho.
#'
#' @param path Caminho do arquivo.
#' @return `TRUE` se o arquivo começa com a assinatura WOFF2.
#' @keywords internal
is_woff2_file <- function(path) {
  if (!file.exists(path)) return(FALSE)
  con <- tryCatch(file(path, "rb"), error = function(e) NULL,
                  warning = function(w) NULL)
  if (is.null(con)) return(FALSE)
  on.exit(close(con), add = TRUE)
  identical(readBin(con, "raw", 4L), charToRaw("wOF2"))
}

#' Is a file a TTF/OTF font?
#'
#' Confere os magic bytes de fontes sfnt: `00 01 00 00` (TrueType), `true`
#' (TrueType Mac), `ttcf` (collection) ou `OTTO` (OpenType/CFF). Mesmo papel
#' de [is_woff2_file()] para o fallback TTF.
#'
#' @param path Caminho do arquivo.
#' @return `TRUE` se o arquivo começa com uma assinatura sfnt conhecida.
#' @keywords internal
is_ttf_file <- function(path) {
  if (!file.exists(path)) return(FALSE)
  con <- tryCatch(file(path, "rb"), error = function(e) NULL,
                  warning = function(w) NULL)
  if (is.null(con)) return(FALSE)
  on.exit(close(con), add = TRUE)
  magic <- readBin(con, "raw", 4L)
  sigs <- list(as.raw(c(0x00, 0x01, 0x00, 0x00)), charToRaw("true"),
               charToRaw("ttcf"), charToRaw("OTTO"))
  any(vapply(sigs, identical, logical(1), x = magic))
}

#' Download a Google Font as WOFF2 to the cache
#'
#' @param family Font family name.
#' @param weight Numeric/character weight (default "400").
#' @param text Optional normalized character set (see [font_subset_charset()]).
#'   When supplied, the Google Fonts CSS API is asked for a *subset* containing
#'   only those glyphs (`&text=` parameter), which is dramatically smaller than
#'   the full font. Subsets are cached per character set.
#' @return Path to cached WOFF2 file or NA_character_.
#' @keywords internal
download_google_font_woff2 <- function(family, weight = "400", text = NULL) {
  if (!is.null(text) && !nzchar(text)) text <- NULL

  out <- font_cache_path(family, text)
  if (file.exists(out)) return(out)

  # A fonte pode ter sido cacheada em outro formato (fallback TTF desta
  # função, ou gfonts sem woff2): devolva-a em vez de re-baixar a cada chamada.
  for (alt_ext in c("ttf", "woff", "otf")) {
    alt <- sub("\\.woff2$", paste0(".", alt_ext), out)
    if (file.exists(alt)) return(alt)
  }

  key <- tools::file_path_sans_ext(basename(out))

  # Try gfonts package if available (full fonts only: gfonts has no subsetting)
  if (is.null(text) && requireNamespace("gfonts", quietly = TRUE)) {
    res <- tryCatch({
      tmp <- tempfile("cardargus_font_")
      dir.create(tmp)

      gfonts::download_font(
        family = family,
        output_dir = tmp,
        variants = "regular"
      )

      candidates <- list.files(tmp, pattern = "\\.(woff2|ttf|woff|otf)$",
                               full.names = TRUE, recursive = TRUE)

      if (!length(candidates)) stop("No font files downloaded.")

      # Prefer a real woff2; otherwise keep the actual extension so that
      # embed_svg_fonts() declares the correct @font-face format().
      woff2 <- candidates[grepl("\\.woff2$", candidates, ignore.case = TRUE)]
      src <- if (length(woff2)) woff2[1] else candidates[1]
      ext <- tolower(tools::file_ext(src))
      dest <- file.path(font_cache_dir(), paste0(key, ".", ext))

      file.copy(src, dest, overwrite = TRUE)
      # Fonte do gfonts é completa: um sidecar .range órfão de um download
      # anterior da CSS API a marcaria como bloco parcial (#29).
      unlink(font_range_sidecar(dest))
      dest
    }, error = function(e) NULL)

    if (!is.null(res) && file.exists(res)) return(res)
  }
  
  # Fallback: fetch CSS from Google Fonts API
  urls_to_try <- google_css_urls(family, text = text)

  for (css_url in urls_to_try) {
    css <- fetch_google_css(css_url)
    if (is.null(css) || !nzchar(css)) next

    # Extract the woff2 URL of the LATIN block from the CSS (#27). Both URL
    # styles are tried PER BLOCK: url(https://...woff2) and the extensionless
    # URLs of subset responses (fonts.gstatic.com/l/font?kit=..., identified
    # by format('woff2')) — so a response mixing styles across blocks cannot
    # hide the latin block.
    blk <- google_css_latin_block(css, c(
      'url\\(["\']?([^)"\']+\\.woff2)["\']?\\)',
      'url\\(["\']?([^)"\']+)["\']?\\)\\s*format\\([\'"]woff2[\'"]\\)'
    ))

    if (!is.na(blk$url)) {
      ok <- tryCatch({
        utils::download.file(blk$url, out, mode = "wb", quiet = TRUE)
        TRUE
      }, error = function(e) FALSE)

      if (isTRUE(ok) && file.exists(out) && file.info(out)$size > 1000 &&
          is_woff2_file(out)) {
        # Marca a proveniência/cobertura do bloco baixado, para o embed poder
        # completar com blocos extras (latin-ext etc.) quando o texto pedir (#29).
        if (is.null(text)) write_font_range(out, blk$range)
        return(out)
      }
      # Nunca deixe um download parcial/inválido no cache: a checagem
      # file.exists() na entrada da função o devolveria para sempre.
      unlink(out)
    }
  }

  # If woff2 not found, try ttf as last resort
  for (css_url in urls_to_try) {
    css <- tryCatch({
      paste(readLines(css_url, warn = FALSE), collapse = "\n")
    }, error = function(e) NULL)

    if (is.null(css) || !nzchar(css)) next

    # Try ttf (also picking the Latin block, #27)
    blk <- google_css_latin_block(css, 'url\\(["\']?([^)"\']+\\.ttf)["\']?\\)')

    if (!is.na(blk$url)) {
      ttf_out <- sub("\\.woff2$", ".ttf", out)

      ok <- tryCatch({
        utils::download.file(blk$url, ttf_out, mode = "wb", quiet = TRUE)
        TRUE
      }, error = function(e) FALSE)

      if (isTRUE(ok) && file.exists(ttf_out) && file.info(ttf_out)$size > 1000 &&
          is_ttf_file(ttf_out)) {
        if (is.null(text)) write_font_range(ttf_out, blk$range)
        return(ttf_out)
      }
      unlink(ttf_out)
    }
  }

  NA_character_
}

#' Google Fonts CSS API URLs to try for a family
#'
#' @param family Font family name.
#' @param text Optional normalized character set; when supplied, the `&text=`
#'   parameter asks the API for a glyph subset.
#' @return Character vector of URLs (css2 and legacy css formats).
#' @keywords internal
google_css_urls <- function(family, text = NULL) {
  family_encoded <- gsub(" ", "+", family)

  urls <- c(
    sprintf("https://fonts.googleapis.com/css2?family=%s:wght@400&display=swap", family_encoded),
    sprintf("https://fonts.googleapis.com/css2?family=%s&display=swap", family_encoded),
    sprintf("https://fonts.googleapis.com/css?family=%s:400&display=swap", family_encoded),
    sprintf("https://fonts.googleapis.com/css?family=%s&display=swap", family_encoded)
  )

  # Subsetting: the CSS API returns a font with only the requested glyphs.
  if (!is.null(text)) {
    urls <- paste0(urls, "&text=", utils::URLencode(text, reserved = TRUE))
  }

  urls
}

#' Fetch a Google Fonts CSS response (curl, with base-R fallback)
#'
#' @param css_url URL da CSS API.
#' @return O CSS como string, ou `NULL` em falha.
#' @keywords internal
fetch_google_css <- function(css_url) {
  # User-Agent that triggers woff2 response
  ua <- "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

  css <- NULL

  # Try with curl package first (more reliable for headers)
  if (requireNamespace("curl", quietly = TRUE)) {
    css <- tryCatch({
      h <- curl::new_handle()
      curl::handle_setheaders(h, "User-Agent" = ua)
      curl::handle_setopt(h, connecttimeout = 15L, timeout = 60L)
      req <- curl::curl_fetch_memory(css_url, handle = h)
      if (req$status_code == 200) rawToChar(req$content) else NULL
    }, error = function(e) NULL)
  }

  # Fallback to base R (may not get woff2 on all systems)
  if (is.null(css) || !nzchar(css)) {
    css <- tryCatch({
      paste(readLines(css_url, warn = FALSE), collapse = "\n")
    }, error = function(e) NULL)
  }

  css
}

#' Which code points does a CSS unicode-range cover?
#'
#' Versão vetorizada de [unicode_range_covers()].
#'
#' @param range Conteúdo de uma declaração `unicode-range:`.
#' @param codepoints Vetor de code points (inteiros).
#' @return Vetor lógico paralelo a `codepoints`.
#' @keywords internal
unicode_range_covers_v <- function(range, codepoints) {
  vapply(codepoints, function(cp) unicode_range_covers(range, cp), logical(1))
}

#' Cache slug for an extra @font-face block
#'
#' @param subset Nome do subset no comentário do bloco (`"latin-ext"` etc.),
#'   ou `NA`.
#' @param range `unicode-range` do bloco (usado como fallback, via hash).
#' @return Slug estável para compor o nome do arquivo em cache.
#' @keywords internal
font_block_slug <- function(subset, range) {
  if (!is.na(subset) && nzchar(subset)) {
    slug <- gsub("-+", "-", gsub("[^a-z0-9-]+", "-", tolower(subset)))
    slug <- gsub("^-|-$", "", slug)
    if (nzchar(slug)) return(slug)
  }
  substr(digest::digest(range, algo = "md5"), 1, 8)
}

#' Download the extra @font-face blocks needed by a set of code points
#'
#' Busca a resposta da CSS API e baixa cada bloco cujo `unicode-range` cubra
#' algum dos code points pedidos (ex. *latin-ext* para "Łódź", *vietnamese*
#' para "Việt"). Cada bloco é validado por magic bytes e cacheado como
#' `<key>_blk-<slug>.<ext>` com sidecar `.range` (#29).
#'
#' @param family Font family name.
#' @param codepoints Code points ainda não cobertos pelos blocos já embutidos.
#' @return data.frame com colunas `path` e `range` dos blocos obtidos (0
#'   linhas em falha); blocos cujos ranges não cobrem nenhum code point pedido
#'   não são baixados.
#' @keywords internal
download_google_font_blocks <- function(family, codepoints) {
  found <- data.frame(path = character(0), range = character(0),
                      stringsAsFactors = FALSE)
  if (!length(codepoints)) return(found)

  key <- font_cache_key(family)
  cache_dir <- font_cache_dir()

  url_patterns <- c(
    'url\\(["\']?([^)"\']+\\.woff2)["\']?\\)',
    'url\\(["\']?([^)"\']+)["\']?\\)\\s*format\\([\'"]woff2[\'"]\\)',
    'url\\(["\']?([^)"\']+\\.ttf)["\']?\\)'
  )

  for (css_url in google_css_urls(family)) {
    css <- fetch_google_css(css_url)
    if (is.null(css) || !nzchar(css)) next

    blocks <- google_css_font_blocks(css, url_patterns)

    for (i in seq_len(nrow(blocks))) {
      if (is.na(blocks$range[i])) next
      hit <- unicode_range_covers_v(blocks$range[i], codepoints)
      if (!any(hit)) next

      is_ttf <- grepl("\\.ttf(\\?|$)", blocks$url[i])
      ext <- if (is_ttf) "ttf" else "woff2"
      slug <- font_block_slug(blocks$subset[i], blocks$range[i])
      dest <- file.path(cache_dir, paste0(key, "_blk-", slug, ".", ext))

      # Arquivo cacheado só é reusado se ainda for uma fonte válida; nesse
      # caso o sidecar existente descreve OS BYTES cacheados e prevalece
      # sobre o range do CSS recém-buscado (o Google pode ter alargado o
      # range numa versão nova da fonte que não baixamos).
      reused <- file.exists(dest) &&
        (if (is_ttf) is_ttf_file(dest) else is_woff2_file(dest))
      if (file.exists(dest) && !reused) {
        unlink(dest)
        unlink(font_range_sidecar(dest))
      }

      ok <- reused
      if (!ok) {
        ok <- tryCatch({
          utils::download.file(blocks$url[i], dest, mode = "wb", quiet = TRUE)
          TRUE
        }, error = function(e) FALSE)
        ok <- isTRUE(ok) && file.exists(dest) && file.info(dest)$size > 200 &&
          (if (is_ttf) is_ttf_file(dest) else is_woff2_file(dest))
        if (!ok) {
          unlink(dest)
          next
        }
        write_font_range(dest, blocks$range[i])
      }

      range_use <- read_font_range(dest)
      if (is.na(range_use)) {
        write_font_range(dest, blocks$range[i])
        range_use <- blocks$range[i]
      }

      covered <- unicode_range_covers_v(range_use, codepoints)
      if (any(covered)) {
        found <- rbind(found, data.frame(path = dest, range = range_use,
                                         stringsAsFactors = FALSE))
        codepoints <- codepoints[!covered]
        if (!length(codepoints)) return(found)
      }
    }

    # Esta resposta foi parseada com blocos; tentar outro formato de URL não
    # traria cobertura nova para o que sobrou.
    if (nrow(blocks)) break
  }

  found
}

#' Resolve the extra @font-face blocks a text needs beyond the primary font
#'
#' A fonte "completa" baixada da CSS API cobre só o bloco *latin* (#29). Dado
#' o arquivo primário em cache e os code points usados no SVG, devolve os
#' blocos extras (cacheados ou baixados) cujos `unicode-range` cobrem o que o
#' primário não cobre. Só age quando o primário tem sidecar `.range` — sem
#' sidecar a fonte veio do `gfonts` ou de [register_font()] e é tratada como
#' completa, para nunca sobrepor glifos de uma fonte local do usuário.
#'
#' @param family Font family name.
#' @param primary_path Caminho do arquivo primário em cache.
#' @param codepoints Code points usados no texto do SVG (não-ASCII).
#' @return data.frame com colunas `path` e `range` (0 linhas quando nada é
#'   preciso ou possível).
#' @keywords internal
ensure_font_extra_blocks <- function(family, primary_path, codepoints) {
  none <- data.frame(path = character(0), range = character(0),
                     stringsAsFactors = FALSE)
  if (!length(codepoints)) return(none)

  primary_range <- read_font_range(primary_path)
  if (is.na(primary_range)) return(none)

  remaining <- codepoints[!unicode_range_covers_v(primary_range, codepoints)]
  if (!length(remaining)) return(none)

  key <- font_cache_key(family)
  cache_dir <- font_cache_dir()
  out <- none

  # Blocos extras já cacheados cobrem primeiro (funciona offline).
  cached <- list.files(cache_dir, pattern = "\\.(woff2|ttf|woff|otf)$",
                       full.names = TRUE)
  cached <- cached[startsWith(basename(cached), paste0(key, "_blk-"))]
  for (fp in cached) {
    r <- read_font_range(fp)
    if (is.na(r)) next
    hit <- unicode_range_covers_v(r, remaining)
    if (!any(hit)) next
    out <- rbind(out, data.frame(path = fp, range = r, stringsAsFactors = FALSE))
    remaining <- remaining[!hit]
    if (!length(remaining)) return(out)
  }

  rbind(out, download_google_font_blocks(family, remaining))
}

# ------------------------------------------------------------------------------
# Internal: detect fonts used by SVG
# ------------------------------------------------------------------------------

#' Detect font families used in an SVG
#'
#' @param svg_content Character SVG.
#' @return Character vector of font family names (unique).
#' @keywords internal
detect_svg_fonts <- function(svg_content) {
  # Parsing is delegated to xml2 (with a regex fallback); see R/xml_utils.R.
  svg_font_families(svg_content)
}

# ------------------------------------------------------------------------------
# Internal: ensure fonts exist (family -> woff2 path)
# ------------------------------------------------------------------------------

#' Ensure cardargus fonts are available (WOFF2 cache)
#'
#' @param families Character vector of font families.
#' @param weight Weight to request when downloading (default "400").
#' @param text Optional normalized character set (see [font_subset_charset()]).
#'   When supplied, a glyph subset is downloaded/cached instead of the full
#'   font; if the subset cannot be obtained, the full font is used as fallback.
#' @return Named character vector family -> font file path (NA if unavailable).
#' @keywords internal
ensure_cardargus_fonts <- function(families, weight = "400", text = NULL) {
  families <- unique(as.character(families))
  out <- setNames(rep(NA_character_, length(families)), families)

  cache_dir <- font_cache_dir()

  for (fam in families) {
    # Subset requested: try the subset first, fall back to the full font below.
    if (!is.null(text) && nzchar(text)) {
      fp <- download_google_font_woff2(fam, weight = weight, text = text)
      if (!is.na(fp) && file.exists(fp)) {
        out[[fam]] <- fp
        next
      }
      cli::cli_warn(
        "Could not download a subset of font {.val {fam}}; using the full font."
      )
    }

    key <- font_cache_key(fam)

    for (ext in c("woff2", "ttf", "woff", "otf")) {
      fp <- file.path(cache_dir, paste0(key, ".", ext))
      if (file.exists(fp)) {
        out[[fam]] <- fp
        break
      }
    }

    if (is.na(out[[fam]])) {
      fp <- download_google_font_woff2(fam, weight = weight)
      out[[fam]] <- if (!is.na(fp) && file.exists(fp)) fp else NA_character_
    }
  }

  out
}

#' Check if a font is available for embedding
#'
#' @param family Font family name
#' @return TRUE if font is cached (any supported format), FALSE otherwise
#' @export
#' @examples
#' font_available("Jost")
#' font_available("Montserrat")
font_available <- function(family) {
  cache_dir <- font_cache_dir()
  key <- font_cache_key(family)
  
  for (ext in c("woff2", "ttf", "woff", "otf")) {
    if (file.exists(file.path(cache_dir, paste0(key, ".", ext)))) {
      return(TRUE)
    }
  }
  FALSE
}

#' List registered/cached fonts
#'
#' @return Character vector of font family names that are cached
#' @export
#' @examples
#' list_fonts()
list_fonts <- function() {
  cache_dir <- font_cache_dir()
  files <- list.files(cache_dir, pattern = "\\.(woff2|ttf|woff|otf)$", full.names = FALSE)
  # Blocos extras (#29) complementam uma família já listada pelo arquivo primário.
  files <- files[!grepl("_blk-", files, fixed = TRUE)]
  unique(gsub("\\.(woff2|ttf|woff|otf)$", "", files))
}

#' Pre-download fonts for offline use
#'
#' Downloads and caches the specified fonts (or default fonts)
#' so they are available for PNG conversion without internet access.
#'
#' @param fonts Character vector of Google Font names to download.
#'   Default is c("Jost", "Montserrat", "Roboto", "Open Sans").
#' @param verbose Print status messages
#' @return Named logical vector indicating success for each font
#' @export
#' @examples
#' \donttest{
#' install_fonts()
#' install_fonts(c("Jost", "Roboto"))
#' }
install_fonts <- function(fonts = c("Jost", "Montserrat", "Roboto", "Open Sans"), 
                          verbose = TRUE) {
  results <- setNames(logical(length(fonts)), fonts)
  
  if (verbose) {
    cli::cli_h2("Downloading fonts from Google Fonts")
    cli::cli_alert_info("Requires internet connection")
    
    if (requireNamespace("curl", quietly = TRUE)) {
      cli::cli_alert_info("Using {.pkg curl} package for downloads")
    } else if (requireNamespace("gfonts", quietly = TRUE)) {
      cli::cli_alert_info("Using {.pkg gfonts} package for downloads")
    } else {
      cli::cli_alert_warning("Tip: Install {.pkg curl} or {.pkg gfonts} for more reliable downloads")
    }
  }
  
  for (fam in fonts) {
    if (verbose) cli::cli_progress_step("Downloading {.val {fam}}...")
    
    fp <- download_google_font_woff2(fam)
    success <- !is.na(fp) && file.exists(fp)
    results[[fam]] <- success
    
    if (verbose) {
      if (success) {
        format_type <- if (grepl("\\.ttf$", fp)) "TTF" else "WOFF2"
        cli::cli_alert_success(glue::glue("{fam} ({format_type})", format_type = format_type))
      } else {
        cli::cli_alert_danger("{fam} - check internet connection")
      }
    }
  }
  
  if (verbose) {
    n_ok <- sum(results)
    n_total <- length(results)
    
    cli::cli_h3("Summary")
    cli::cli_alert_info("Downloaded {n_ok}/{n_total} fonts")
    cli::cli_alert_info("Cache: {.path {font_cache_dir()}}")
    
    if (n_ok < n_total) {
      cli::cli_bullets(c(
        "i" = "Tip: Install {.pkg gfonts} for more reliable downloads:",
        " " = "{.code install.packages('gfonts')}",
        "i" = "Or use {.fn register_font} to register local font files."
      ))
    }
  }
  
  invisible(results)
}

#' Register a local font file for embedding
#'
#' Copies a local font file (TTF or WOFF2) to the cardargus cache directory
#' so it can be embedded in SVG exports.
#'
#' @param font_path Path to a local .ttf or .woff2 font file
#' @param family Font family name to register (e.g., "Jost"). If NULL,
#'   the filename without extension is used.
#' @return Path to the cached font file (invisible)
#' @export
register_font <- function(font_path, family = NULL) {
  if (!file.exists(font_path)) {
    cli::cli_abort("Font file not found: {.path {font_path}}")
  }
  
  ext <- tolower(tools::file_ext(font_path))
  if (!ext %in% c("ttf", "woff2", "woff", "otf")) {
    cli::cli_abort("Unsupported font format. Use TTF, WOFF2, WOFF, or OTF files.")
  }
  
  if (is.null(family)) {
    family <- tools::file_path_sans_ext(basename(font_path))
    family <- gsub("-?(Regular|Bold|Italic|Light|Medium|SemiBold|ExtraBold|Black|Thin).*$", "", family, ignore.case = TRUE)
  }
  
  cache_dir <- font_cache_dir()
  key <- font_cache_key(family)
  out_path <- file.path(cache_dir, paste0(key, ".", ext))
  
  file.copy(font_path, out_path, overwrite = TRUE)

  # A fonte local do usuário é tratada como completa: um sidecar .range órfão
  # de um download anterior da CSS API faria blocos do Google sobreporem seus
  # glifos (#29). O sidecar é compartilhado por chave, independente da extensão.
  unlink(font_range_sidecar(out_path))

  if (file.exists(out_path)) {
    cli::cli_alert_success("Font {.val {family}} registered successfully.")
    cli::cli_alert_info("Cached at: {.path {out_path}}")
  } else {
    cli::cli_abort("Failed to copy font file to cache.")
  }
  
  invisible(out_path)
}

# ------------------------------------------------------------------------------
# Internal: embed fonts into SVG
# ------------------------------------------------------------------------------

#' Embed font files into an SVG via @font-face
#'
#' @param svg_content Character SVG.
#' @param font_family Font family name to embed.
#' @param woff2_path Path(s) to font file(s) (.woff2, .ttf, .woff, or .otf).
#'   Pode ser um vetor: uma regra `@font-face` é gerada por arquivo, na ordem
#'   dada (primário primeiro, blocos extras depois).
#' @param unicode_range Optional `unicode-range` value(s), parallel to
#'   `woff2_path` (`NA` = sem declaração). Com múltiplos arquivos, os ranges
#'   dizem ao renderizador qual face usar para cada code point (#29).
#' @return SVG string with embedded @font-face rule(s).
#' @keywords internal
embed_svg_fonts <- function(svg_content, font_family, woff2_path,
                            unicode_range = NULL) {
  if (!requireNamespace("base64enc", quietly = TRUE)) {
    cli::cli_abort(c(
      "x" = "Package {.pkg base64enc} is required to embed fonts.",
      "i" = "Install with: {.code install.packages('base64enc')}"
    ))
  }
  if (is.null(unicode_range)) {
    unicode_range <- rep(NA_character_, length(woff2_path))
  }

  usable <- !is.na(woff2_path) & file.exists(woff2_path)
  if (!any(usable)) {
    return(as.character(svg_content))
  }
  woff2_path <- woff2_path[usable]
  unicode_range <- unicode_range[usable]

  svg <- as.character(svg_content)

  escaped_family <- gsub("([\\[\\](){}|.+*?^$\\\\])", "\\\\\\1", font_family, perl = TRUE)

  pattern_dq <- sprintf('@font-face\\s*\\{[^}]*font-family\\s*:\\s*"%s"[^}]*\\}', escaped_family)
  svg <- gsub(pattern_dq, "", svg, perl = TRUE)

  pattern_sq <- sprintf("@font-face\\s*\\{[^}]*font-family\\s*:\\s*'%s'[^}]*\\}", escaped_family)
  svg <- gsub(pattern_sq, "", svg, perl = TRUE)

  svg <- gsub("\n{3,}", "\n\n", svg, perl = TRUE)

  rules <- vapply(seq_along(woff2_path), function(i) {
    fp <- woff2_path[i]
    raw <- readBin(fp, "raw", n = file.info(fp)$size)
    b64 <- base64enc::base64encode(raw)

    ext <- tolower(tools::file_ext(fp))

    mime_and_format <- switch(ext,
                              "woff2" = c("font/woff2", "woff2"),
                              "ttf"   = c("font/ttf", "truetype"),
                              "woff"  = c("font/woff", "woff"),
                              "otf"   = c("font/otf", "opentype"),
                              c("font/woff2", "woff2")
    )
    mime_type <- mime_and_format[1]
    format_str <- mime_and_format[2]

    range_decl <- if (!is.na(unicode_range[i]) && nzchar(unicode_range[i])) {
      sprintf("unicode-range:%s;", unicode_range[i])
    } else {
      ""
    }

    sprintf(
      '@font-face{font-family:"%s";src:url("data:%s;base64,%s") format("%s");font-weight:100 900;font-style:normal;%s}',
      font_family, mime_type, b64, format_str, range_decl
    )
  }, character(1))

  css <- paste(rules, collapse = "\n")

  if (grepl("<style[^>]*>", svg, perl = TRUE)) {
    svg <- sub("(<style[^>]*>)", paste0("\\1\n", css, "\n"), svg, perl = TRUE)
  } else if (grepl("<defs>", svg, fixed = TRUE)) {
    svg <- sub("<defs>", paste0("<defs>\n<style>\n", css, "\n</style>\n"), svg, fixed = TRUE)
  } else if (grepl("<defs[^>]*>", svg, perl = TRUE)) {
    svg <- sub("(<defs[^>]*>)", paste0("\\1\n<style>\n", css, "\n</style>\n"), svg, perl = TRUE)
  } else {
    svg <- sub("(<svg[^>]*>)", paste0("\\1\n<defs><style>\n", css, "\n</style></defs>\n"), svg, perl = TRUE)
  }
  
  svg
}

#' Prepare SVG for rasterization (sanitize + embed fonts)
#'
#' @description
#' Removes Google Fonts @import rules (not supported by librsvg), sanitizes
#' editor metadata (handled by sanitize_svg_for_raster()), then embeds fonts
#' referenced by the SVG into @font-face blocks.
#'
#' @param svg_content Character SVG.
#' @param subset_fonts If TRUE, embed a glyph *subset* covering only the
#'   characters that actually appear in the SVG text, instead of the full font
#'   (much smaller output). Subsets are downloaded from the Google Fonts CSS
#'   API and cached per character set; when a subset cannot be obtained, the
#'   full font is embedded as fallback.
#' @return A sanitized SVG with embedded WOFF2 fonts.
#' @keywords internal
prepare_svg_for_raster <- function(svg_content, subset_fonts = FALSE) {
  svg <- as.character(svg_content)

  if (!exists("sanitize_svg_for_raster", mode = "function")) {
    cli::cli_abort("Internal function {.fn sanitize_svg_for_raster} was not found.")
  }
  svg <- sanitize_svg_for_raster(svg)

  families <- detect_svg_fonts(svg)
  if (!length(families)) return(svg)

  charset <- font_subset_charset(svg_text_content(svg))

  subset_text <- NULL
  if (isTRUE(subset_fonts)) {
    subset_text <- charset
  }

  # Fonte completa da CSS API cobre só o bloco latin: code points fora do
  # ASCII podem pedir blocos extras (latin-ext, vietnamese...) (#29). Os code
  # points são atribuídos POR FAMÍLIA (texto não atribuível conta para
  # todas), para não embutir blocos numa família cujo texto não os usa.
  non_ascii_codepoints <- function(txt) {
    cs <- font_subset_charset(txt)
    if (is.null(cs)) return(integer(0))
    cp <- utf8ToInt(cs)
    cp[cp > 0x7FL]
  }

  global_cp <- if (is.null(charset)) integer(0) else {
    cp <- utf8ToInt(charset)
    cp[cp > 0x7FL]
  }

  text_by_family <- if (length(global_cp)) svg_text_by_family(svg) else NULL
  family_codepoints <- function(fam) {
    # Parse indisponível: vale o texto global (atribuição conservadora).
    if (is.null(text_by_family)) return(global_cp)
    unique(c(
      non_ascii_codepoints(text_by_family[[fam]]),
      non_ascii_codepoints(text_by_family[[".unresolved"]])
    ))
  }

  paths <- ensure_cardargus_fonts(families, text = subset_text)
  for (fam in names(paths)) {
    fp <- paths[[fam]]
    if (!is.na(fp) && file.exists(fp)) {
      # O gate é o ARQUIVO embutido, não o modo pedido: com subset_fonts, a
      # falha do download do subset cai na fonte completa latin-only, que
      # precisa dos blocos extras do mesmo jeito (#29).
      is_subset_file <- grepl("_sub[0-9a-f]{10}\\.", basename(fp))
      cps <- if (is_subset_file) integer(0) else family_codepoints(fam)
      extra <- if (length(cps)) {
        ensure_font_extra_blocks(fam, fp, cps)
      } else {
        NULL
      }
      if (!is.null(extra) && nrow(extra)) {
        # Com blocos extras, o primário também leva seu unicode-range: cada
        # face fica com cobertura explícita e a ordem das regras não importa.
        svg <- embed_svg_fonts(
          svg, font_family = fam,
          woff2_path = c(fp, extra$path),
          unicode_range = c(read_font_range(fp), extra$range)
        )
      } else {
        svg <- embed_svg_fonts(svg, font_family = fam, woff2_path = fp)
      }
    } else {
      cli::cli_warn("Font {.val {fam}} could not be embedded. PNG may use fallback font.")
    }
  }

  svg
}