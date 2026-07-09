## ---------------------------------------------------------------------
## render-pubs.R
## Turns entries in _data/publications.yml into consistent HTML on the
## Research page. Called from research.qmd inside chunks like:
##
##     ```{r, results='asis', echo=FALSE}
##     render_pubs("published")
##     ```
##
## To add a paper: add an entry to _data/publications.yml (and, if you
## want a "Cite me" button, drop its .ris file in files/ris/). Nothing
## here needs to change.
## ---------------------------------------------------------------------

suppressPackageStartupMessages(library(yaml))

## small helper: TRUE only when x is a non-empty character string
.nz <- function(x) !is.null(x) && length(x) == 1 && is.character(x) && nzchar(x)

## Build the row of optional links: Article | Pre-print | Cite me | Video
.pub_links <- function(p) {
  parts <- character(0)
  if (.nz(p$article_url)) {
    note <- if (isTRUE(p$ungated)) " <span class=\"pub-note\">(ungated)</span>" else ""
    parts <- c(parts, sprintf("<a href=\"%s\">Article</a>%s", p$article_url, note))
  }
  if (.nz(p$preprint_url)) parts <- c(parts, sprintf("<a href=\"%s\">Pre-print</a>", p$preprint_url))
  if (.nz(p$ris))          parts <- c(parts, sprintf("<a href=\"%s\" download>Cite me</a>", p$ris))
  if (.nz(p$video_url))    parts <- c(parts, sprintf("<a href=\"%s\">Video</a>", p$video_url))
  if (!length(parts)) return("")
  paste0("<div class=\"pub-links\">",
         paste(parts, collapse = " <span class=\"sep\">&middot;</span> "),
         "</div>\n")
}

## Render one entry as a card.
## Published articles use journal + year (+ optional status_note).
## Working papers use a free-text `status` field instead.
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

  cat(.pub_links(p))

  if (.nz(p$abstract)) {
    cat("  <details class=\"pub-abstract\"><summary>Abstract</summary>\n")
    cat(sprintf("  <p>%s</p>\n", p$abstract))
    cat("  </details>\n")
  }
  cat("</div>\n\n")
}

## Render every entry in a section of the YAML file.
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
