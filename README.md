# michaelfjoseph.com — Quarto site

This is your website, built with [Quarto](https://quarto.org) (the modern,
R-Markdown-style static-site generator). You edit plain text files, run one
command to build, and push the result to GitHub Pages. No database, no server,
no Wix.

---

## One-time setup

1. Install **Quarto**: <https://quarto.org/docs/get-started/>
2. You already have **R**. Install the one package the site needs:
   ```r
   install.packages("yaml")
   ```
3. (For publishing) install **git** and make a free GitHub account.

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

That's it. Edit a `.qmd` file, watch it update in the preview, and when you're
happy, render and publish.

---

## How the "backend" works (your files)

There is no backend. Every file the site serves — a pre-print PDF, a working
paper, a citation file, an image — just lives in a folder here, and you link to
it with a **relative path**. Drop the file in the folder, reference the path,
render. When you publish, those files are copied to the live site automatically.

| Put this kind of file… | …in this folder | …and link it as |
|---|---|---|
| Pre-print / published PDF | `files/preprints/` | `files/preprints/name.pdf` |
| Working paper PDF | `files/working-papers/` | `files/working-papers/name.pdf` |
| Citation file (from Mendeley) | `files/ris/` | `files/ris/name.ris` |
| Your CV | `files/cv/` | `files/cv/CV.pdf` |
| Book covers | `images/book/` | `images/book/cover-published.jpg` |
| Your photo | `images/profile/` | `images/profile/headshot.jpg` |

## How to add a publication

1. Open **`_data/publications.yml`**.
2. Copy an existing entry and edit the fields (title, authors, journal, year,
   links…). Every field except `title` is optional — leave one out and that
   link just won't show.
3. Optional extras:
   - **Cite me button:** export the `.ris` from Mendeley, save it in
     `files/ris/`, and set `ris: files/ris/yourpaper.ris`.
   - **Pre-print:** save the PDF in `files/preprints/` and set `preprint_url:`.
   - **Video:** set `video_url:` to the YouTube link.
   - **Abstract:** paste it into `abstract:` and a collapsible "Abstract"
     toggle appears.
4. Run `quarto render`. Done — the Research page rebuilds itself from the file.

You never touch HTML: `research.qmd` reads `_data/publications.yml` and lays out
every entry identically via `R/render-pubs.R`.

---

## Directory map

```
site/
├── _quarto.yml            site config + top navigation
├── index.qmd              Home
├── research.qmd           Research (book, articles, commentary, working papers)
├── teaching-learning.qmd  Teaching/Learning (draft)
├── policy.qmd             Policy
├── fun-docs.qmd           Fun Docs
├── _data/
│   └── publications.yml   ← ALL publications live here (edit this)
├── R/
│   └── render-pubs.R      renders each publication consistently
├── theme/
│   └── custom.scss        colors/fonts (placeholder for now)
├── files/                 PDFs, RIS citation files, CV
├── images/                book covers, headshot, brand assets
└── docs/                  the built site (created by `quarto render`)
```

## To-do before this goes live

- Replace the placeholder **book covers** in `images/book/`.
- Replace the placeholder **headshot** in `images/profile/`.
- Copy your **CV.pdf** into `files/cv/`.
- Re-host the ungated PDFs currently linked from the old Wix site (see the notes
  inside `_data/publications.yml` and `fun-docs.qmd`).
- Add your Google Scholar link on the Home page (`index.qmd`).

## Publishing to GitHub Pages

Once you're happy locally:

1. Create a GitHub repo and push this `site/` folder to it.
2. In the repo: **Settings → Pages → Build from branch → `main` / `docs`**.
3. Point `www.michaelfjoseph.com` at GitHub Pages (a DNS change at your domain
   registrar). I'll walk you through this step when we get there.

Every future update is then: edit → `quarto render` → `git push`.

---

## Styling

Colors and fonts are a **placeholder** right now (a clean default with a pink
accent). The brand palette and fonts from the video theme are noted at the top of
`theme/custom.scss`, ready to switch on when we do the design pass together.
