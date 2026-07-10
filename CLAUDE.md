# CLAUDE.md — project memory for michaelfjoseph.com

Read this first. It's the fast-start briefing for any Claude (or human) picking up
this project on a new computer. Last updated 2026-07-10.

## What this is

The personal academic website of **Michael F. Joseph**, Assistant Professor of
Political Science, UC San Diego (war, national security, secrecy, technology).
Built with **Quarto** (static-site generator, R/Markdown-style). No database, no
server. Replaces an old Wix site (being retired).

- **Live at:** https://www.michaelfjoseph.com (custom domain)
- **Repo:** `mfjoseph/michaelfjoseph-site` on GitHub (public), branch `main`
- **Hosting:** GitHub Pages, served from the `/docs` folder on `main`
- **Project root:** the `site/` folder (this folder). Synced via Dropbox **and** git.

## How to work on it (the everyday loop)

From inside `site/`:

1. Edit a `.qmd`, `.yml`, `.scss`, or data file.
2. `quarto preview` — live local preview while editing, OR `quarto render` — build final HTML into `docs/`.
3. Commit + push (GitHub Desktop, or `git push`). Live in ~1 minute.

**Nothing goes live until you re-render AND push.** Editing source alone does
nothing to the live site — `docs/` is the served output and must be regenerated
and pushed.

### Toolchain / environment notes
- Needs **Quarto** installed and **R** with the `yaml` package (`install.packages("yaml")`). `engine: knitr`.
- **Claude's sandbox cannot run Quarto or R** — verify rendering logic by simulating it, and hand the actual `quarto render` back to Michael.
- If a render suddenly breaks, the terminal error names the offending file + line; check the most recently edited file first.

## Architecture

```
site/
├── _quarto.yml          site config, top navbar, format, includes, CNAME resource
├── index.qmd            Home (dark full-bleed cover + explosion watermark)
├── research.qmd         Research: book feature + data-driven publication lists
├── policy.qmd           Policy
├── fun-docs.qmd         Fun Docs (archival curiosities + "fun facts")
├── courses.qmd          Teaching/Learning → Courses
├── advice.qmd           Teaching/Learning → Advice for Students (see toggle note)
├── teaching-learning.qmd  (draft landing)
├── _data/publications.yml   ← ALL publications live here; edit this, never HTML
├── R/render-pubs.R          renders each publication card identically
├── theme/custom.scss        the entire brand theme (colors, fonts, components)
├── files/               PDFs, RIS citations, CV, bibtex/  (linked by relative path)
├── images/              book/ covers, brand/ watermarks, profile/ headshot
├── CNAME                custom-domain file (www.michaelfjoseph.com) — see Deploy
├── docs/                BUILT SITE (generated; committed; this is what Pages serves)
├── README.md            human setup/workflow guide
└── GIT_GUIDE.md         click-by-click GitHub Desktop + Pages + DNS guide
```

### The research page is data-driven — key thing to understand
`research.qmd` contains the book feature as hand-written markup, then calls
`render_pubs("published")`, `render_pubs("working_papers")`, etc. Those pull from
`_data/publications.yml` and render every entry through `R/render-pubs.R`. **To
add/edit a paper, edit `_data/publications.yml` only** — never touch HTML.

Each publication renders one compact action row:
**Abstract | Article | Pre-print | Video Summary | BibTeX**
- `abstract:` → collapsible "Abstract" toggle
- `article_url:` (+ `ungated: true`) → "Article" link
- `preprint_url:` → "Pre-print" link
- `video_url:` (YouTube) → "Video Summary" toggle that plays the video **inline**
  (article-level videos embed in an expanding panel; handles youtube.com & youtu.be)
- `bibtex:` (path to a `.txt` in `files/bibtex/`) → "BibTeX" toggle w/ download
- Working papers use a free-text `status:` (e.g. "R&R, APSR").

## Branding — theme "Redacted"

Full spec + all variables live at the top of `theme/custom.scss`. Philosophy:
**dark = brand moments** (home cover, navbar, footer); **warm off-white = reading
surfaces**; **pink is an event, not a default** (ration it).

- **Page background (reading pages):** `$paper: #f7f5f1` (wired via `$body-bg`).
- **Home cover / navbar / footer:** black (`$dark: #000`). Home forces full black via `body:has(.cover)`.
- **Ink/body/meta text:** `$ink #16181b`, `$body-text #45484f`, `$meta #74777f`, `$muted #9a9da4`.
- **Accents:** `$pink #c40064` (on light surfaces), `$pink-bright #ff2e9a` (on dark only). Rule line `$rule #e5e1d9`.
- **Fonts:** headings/body = **Newsreader** (serif); nav/labels/UI = **Poppins** (sans). Base size `1.05rem`.
- **Watermark:** mushroom-cloud / hexagon brand assets in `images/brand/`; the home cover shows one at low opacity (`.cover-wm`).
- Expanded-abstract text size is `.pub-x-panel p { font-size }` (currently `.85rem`).

To change the reading-page background, edit `$paper` (line ~15 of custom.scss).
Any `.scss` edit requires a re-render to take effect.

## Notable custom features (already built)

- **Book "Video summary"** (research.qmd, book-left): a small thumbnail with a play
  badge that opens a **large centered modal/lightbox** on click (native `<dialog>`,
  `openBookVideo()`/`closeBookVideo()` inline script; closes on ✕, backdrop, or Esc;
  fullscreen-capable). Styled by `.book-video-thumb` / `.video-modal` in custom.scss.
- **Email button** (navbar, `_quarto.yml`): opens **Gmail compose** pre-addressed to
  `mfjoseph@ucsd.edu` in a new tab (was `mailto:`, which did nothing without a default
  mail app).
- **Teaching/Learning menu:** dropdown with Courses + Advice for Students. The Advice
  entry is currently **commented out** in `_quarto.yml` (toggle it by removing the `#`
  on those two lines) because the blog has no posts yet.
- **CV** opens in a new tab (`files/cv/CV.pdf`); **Fun** page tab is labeled "Fun".

## Deployment & domain (important gotchas)

- **GitHub Pages** serves `docs/` on `main`. `docs/` **is committed** (not ignored).
- **Custom domain:** the `CNAME` file (contains `www.michaelfjoseph.com`) is registered
  as a Quarto **resource** in `_quarto.yml`, so every `quarto render` copies it into
  `docs/`. This is essential — without it, a render would wipe `docs/CNAME` and break
  the domain. Don't remove it.
- **DNS is at Squarespace** (formerly Google Domains), **not Wix**. Records:
  `www` CNAME → `mfjoseph.github.io`; apex `@` A records → GitHub IPs
  `185.199.108.153 / .109.153 / .110.153 / .111.153`.
- **HTTPS:** GitHub auto-issues the Let's Encrypt cert once DNS resolves; then tick
  **Enforce HTTPS** in Settings → Pages. If it's ever stuck, remove + re-add the custom
  domain to force re-issue.
- **Wix** hosted the old site and is being cancelled. The domain does NOT belong to Wix,
  so cancelling is safe. No live links depend on Wix-hosted files (the one legacy
  Secret Innovation PDF reference is commented out in publications.yml).

## Working style with Michael

- He's not a developer — explain clearly, give exact click paths, avoid jargon.
- He prefers concise, direct answers.
- When editing files, always verify (simulate render logic, check tag/brace balance)
  since the sandbox can't run Quarto.
- Remind him of the render → commit → push loop; it's the #1 thing that trips him up.
