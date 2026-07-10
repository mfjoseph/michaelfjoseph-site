## ---------------------------------------------------------------------
## render-pubs.R
## Turns entries in _data/publications.yml into a compact card:
##   title
##   authors. journal, year
##   award            (its own line, with a star)
##   one row of small links:  Abstract · Article · Pre-print · BibTeX · Video
##
## To add a paper: add an entry to _data/publications.yml. For a BibTeX
## link, drop a .txt file in files/bibtex/ and set  bibtex: files/bibtex/key.txt
## For a video summary, set  video_url: <YouTube link>  -> shows a
## "Video Summary" toggle that plays the video inline (like Abstract).
## ---------------------------------------------------------------------

suppressPackageStartupMessages(library(yaml))

## TRUE only when x is a non-empty character string
.nz <- function(x) !is.null(x) && length(x) == 1 && is.character(x) && nzchar(x)

## escape a few characters so BibTeX shows literally inside <pre>
.html_escape <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;",  x, fixed = TRUE)
  x <- gsub(">", "&gt;",  x, fixed = TRUE)
  x
}

## Turn a YouTube watch/share URL into an embeddable /embed/ URL.
## Accepts youtube.com/watch?v=ID, youtu.be/ID, or an existing /embed/ID URL.
## Unknown formats are returned unchanged so the iframe still points somewhere.
.yt_embed <- function(url) {
  id <- NA_character_
  for (pat in c("[?&]v=([A-Za-z0-9_-]{6,})",
                "youtu\\.be/([A-Za-z0-9_-]{6,})",
                "youtube\\.com/embed/([A-Za-z0-9_-]{6,})")) {
    m <- regmatches(url, regexec(pat, url))[[1]]
    if (length(m) == 2) { id <- m[2]; break }
  }
  if (is.na(id)) return(url)
  paste0("https://www.youtube.com/embed/", id)
}

## One compact inline row: Abstract | Article | Pre-print | Video Summary | BibTeX
## Abstract, Video Summary and BibTeX are toggles (expand a panel below);
## the rest are links.
.pub_actions <- function(p) {
  items <- character(0)

  if (.nz(p$abstract)) {
    items <- c(items, paste0(
      "<details class=\"pub-x\"><summary>Abstract</summary>",
      "<div class=\"pub-x-panel\"><p>", p$abstract, "</p></div></details>"))
  }
  if (.nz(p$article_url)) {
    note <- if (isTRUE(p$ungated)) " <span class=\"pub-note\">(ungated)</span>" else ""
    items <- c(items, paste0("<a href=\"", p$article_url, "\">Article</a>", note))
  }
  if (.nz(p$preprint_url)) {
    items <- c(items, paste0("<a href=\"", p$preprint_url, "\">Pre-print</a>"))
  }
  if (.nz(p$video_url)) {
    items <- c(items, paste0(
      "<details class=\"pub-x\"><summary>Video Summary</summary>",
      "<div class=\"pub-x-panel\"><div class=\"pub-video\">",
      "<iframe src=\"", .yt_embed(p$video_url), "\" title=\"Video summary\" ",
      "frameborder=\"0\" allowfullscreen ",
      "allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; ",
      "gyroscope; picture-in-picture; web-share\" ",
      "referrerpolicy=\"strict-origin-when-cross-origin\"></iframe>",
      "</div></div></details>"))
  }
  if (.nz(p$bibtex) && file.exists(p$bibtex)) {
    txt <- .html_escape(paste(readLines(p$bibtex, warn = FALSE), collapse = "\n"))
    items <- c(items, paste0(
      "<details class=\"pub-x\"><summary>BibTeX</summary>",
      "<div class=\"pub-x-panel\"><pre>", txt, "</pre>",
      "<a class=\"bib-dl\" href=\"", p$bibtex, "\" download>Download .txt</a></div></details>"))
  }

  if (!length(items)) return("")
  paste0("<div class=\"pub-actions\">", paste(items, collapse = ""), "</div>\n")
}

## Render one entry as a compact card.
.pub_card <- function(p) {
  cat("<div class=\"pub\">\n")
  cat(sprintf("  <div class=\"pub-title\">%s</div>\n", p$title))

  meta <- character(0)
  if (.nz(p$authors)) meta <- c(meta, p$authors)
  jy <- paste(Filter(nzchar, c(if (.nz(p$journal)) p$journal else "",
                               if (!is.null(p$year)) as.character(p$year) else "")),
              collapse = ", ")
  if (.nz(p$status_note) && nzchar(jy)) jy <- paste0(jy, " (", p$status_note, ")")
  venue <- if (.nz(p$status)) p$status else jy   # working papers -> free-text status
  if (nzchar(venue)) meta <- c(meta, sprintf("<em>%s</em>", venue))
  if (length(meta)) cat(sprintf("  <div class=\"pub-meta\">%s</div>\n",
                                paste(meta, collapse = ". ")))

  if (.nz(p$award)) cat(sprintf("  <div class=\"pub-award\">%s</div>\n", p$award))

  cat(.pub_actions(p))
  cat("</div>\n\n")
}

render_pubs <- function(section, file = "_data/publications.yml") {
  data  <- yaml::read_yaml(file)
  items <- data[[section]]
  if (is.null(items) || !length(items)) {
    cat("<p class=\"pub-note\">Coming soon.</p>\n")
    return(invisible())
  }
  for (p in items) .pub_card(p)
  invisible()
}
