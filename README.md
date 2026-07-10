# michaelfjoseph.com — Quarto site

Your website, built with [Quarto](https://quarto.org) (a modern, R-Markdown-style
static-site generator). You edit plain-text files, run one command to build, and
push the result to GitHub Pages. No database, no server, no Wix.

**It's live:** https://www.michaelfjoseph.com

> For a deeper technical briefing (architecture, branding spec, deployment gotchas),
> see `CLAUDE.md` in this folder.

---

## One-time setup (per computer)

1. Install **Quarto**: <https://quarto.org/docs/get-started/>
2. You already use **R**. Install the one package the site needs:
   ```r
   install.packages("yaml")
   ```
3. For publishing: install **GitHub Desktop** (or git) and sign in. The repo is
   `mfjoseph/michaelfjoseph-site`.

## The everyday workflow

From this `site/` folder:

- **Preview live while you edit** (auto-refreshes in your browser):
  ```
  quarto preview
  ```
- **Build the finished site** (writes HTML into `docs/`):
  ```
  quarto render
  ```
- **Publish:** in GitHub Desktop, **Commit to main** → **Push origin**. Live in ~1 min.

**The golden rule:** nothing goes live until you *both* re-render *and* push.
Editing a file alone changes nothing on the live site — `docs/` is the built output
that GitHub actually serves, so it has to be regenerated and pushed.

---

## How the "backend" works (your files)

There is no backend. Every file the site serves — a PDF, a citation file, an image —
just lives in a folder here, and you link it with a **relative path**. Drop the file
in, reference the path, render. On publish, those files are copied to the live site.

| Put this kind of file… | …in this folder | …and link it as |
|---|---|---|
| Pre-print / published PDF | `files/preprints/` | `files/preprints/name.pdf` |
| Working paper PDF | `files/working-papers/` | `files/working-papers/name.pdf` |
| BibTeX citation (.txt) | `files/bibtex/` | `files/bibtex/name.txt` |
| Your CV | `files/cv/` | `files/cv/CV.pdf` |
| Book covers | `images/book/` | `images/book/cover-published.jpg` |
| Your photo | `images/profile/` | `images/profile/headshot.jpg` |

## How to add a publication

You never touch HTML. `research.qmd` reads `_data/publications.yml` and lays out
every entry identically via `R/render-pubs.R`.

1. Open **`_data/publications.yml`**.
2. Copy an existing entry and edit the fields. Every field except `title` is
   optional — leave one out and that link simply won't appear.
3. Optional extras (each adds one item to the entry's action row):
   - **Article link:** `article_url:` (add `ungated: true` for a small "(ungated)" note).
   - **Pre-print:** save the PDF in `files/preprints/` and set `preprint_url:`.
   - **Video Summary:** set `video_url:` to a YouTube link → a "Video Summary" toggle
     that plays the video inline.
   - **BibTeX:** save a `.txt` in `files/bibtex/` and set `bibtex:` → a copy/download button.
   - **Abstract:** paste into `abstract:` → a collapsible "Abstract" toggle.
   - **Working papers:** use free-text `status:` (e.g. "R&R, APSR", "Under review").
4. Run `quarto render`. The Research page rebuilds itself from the file.

---

## Directory map

```
site/
├── _quarto.yml            site config + top navigation + CNAME resource
├── index.qmd              Home (dark cover with watermark)
├── research.qmd           Research (book feature + data-driven publication lists)
├── policy.qmd             Policy
├── fun-docs.qmd           Fun Docs
├── courses.qmd            Teaching/Learning → Courses
├── advice.qmd             Teaching/Learning → Advice for Students (menu item off until it has posts)
├── _data/
│   └── publications.yml   ← ALL publications live here (edit this)
├── R/
│   └── render-pubs.R      renders each publication consistently
├── theme/
│   └── custom.scss        the full "Redacted" brand theme (colors, fonts, components)
├── files/                 PDFs, BibTeX files, CV
├── images/                book covers, brand watermarks, headshot
├── CNAME                  custom-domain file (keeps www.michaelfjoseph.com on renders)
├── CLAUDE.md              technical briefing for picking the project up quickly
└── docs/                  the built site (created by `quarto render`; this is what's served)
```

---

## Publishing & domain (already set up)

- **Hosting:** GitHub Pages serves the `docs/` folder on the `main` branch
  (Settings → Pages → Deploy from branch → `main` / `/docs`).
- **Custom domain:** handled by the `CNAME` file, which is wired into `_quarto.yml`
  as a resource so every render preserves it. Don't delete it.
- **DNS lives at Squarespace** (your former Google Domains account), *not* Wix:
  `www` → `mfjoseph.github.io`, and the apex `@` → GitHub's four IPs.
- **HTTPS** is issued automatically by GitHub once DNS resolves; then tick
  **Enforce HTTPS** in Settings → Pages.

Every future update is just: **edit → `quarto render` → commit → push.**

---

## Styling

The site uses a finished custom theme called **"Redacted"** — a dark/light split
(dark cover, navbar, and footer as brand moments; a warm off-white for reading; pink
used sparingly as an accent). Everything — colors, fonts (Newsreader + Poppins),
and component styles — lives in **`theme/custom.scss`**, with the full palette and
philosophy documented at the top of that file. Change a value there and re-render to
see it. (The reading-page background is the `$paper` variable near the top.)
