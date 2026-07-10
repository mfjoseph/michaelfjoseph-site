# Publishing & backing up your site with GitHub

## Is git hard? (short answer: no — the way we'll do it)
In plain English: **git** keeps a complete history of your files, and **GitHub**
stores that history in the cloud. That gives you two things at once — a permanent
backup (so a dead laptop can't lose your site) and **free hosting** for the live
website. We'll use **GitHub Desktop**, a click-based app, so you won't touch the
command line for any of the git steps.

Reassurance: your files are already backed up in **Dropbox** right now. GitHub
adds a second, versioned backup *plus* the hosting.

---

## One-time setup (~20 minutes)
1. Create a free account at **github.com**.
2. Install **GitHub Desktop** from **desktop.github.com**, and sign in.
3. To *build* the site you also need **Quarto** (quarto.org/docs/get-started) and,
   in R, run once: `install.packages("yaml")`. (You already use R.)

---

## Step 1 — Put the site under version control (click-based)
1. Open **GitHub Desktop** → **File → Add local repository**.
2. Choose this folder: `C:\Users\micha\Dropbox\website\site`
3. It will say *"this isn't a git repository — create one?"* → click **Create a
   repository** → leave the defaults → **Create repository**.
   (A `.gitignore` is already in the folder, so build junk is skipped.)
4. Click **Publish repository** (top-right). Name it e.g. `michaelfjoseph-site`.
   You can keep it **Private** — GitHub Pages still works — then **Publish**.

✅ Your whole site is now backed up on GitHub. That's the "never lose it" part done.

---

## Step 2 — Build the site (turn `.qmd` files into HTML in `docs/`)

Two separate things happen here — one you *type in R*, one you *click*.

**a) The one thing you type in R.** Open **RStudio**. Find the **Console** pane
(bottom-left, where R waits for input). Click into it, type this, press Enter —
one time only:
```r
install.packages("yaml")
```
Let it finish (it prints messages, then a fresh `>` prompt). That is the *only*
thing you type in R.

**b) Build the site — this is Quarto, driven by RStudio's buttons (Quarto is a
separate program, not an R package).**
1. Install **Quarto** if you don't have it: <https://quarto.org/docs/get-started/>.
   (Recent RStudio bundles it — if the **Render** button appears in step 4, you're set.)
2. In RStudio: **File → New Project… → Existing Directory** → browse to
   `C:\Users\micha\Dropbox\website\site` → **Create Project**. RStudio now "sees" the site.
3. In the **Files** pane (bottom-right), click **`index.qmd`** to open it.
4. Click the **Render** button at the top of the editor — or, to build *every* page,
   open the **Build** tab (top-right pane) and click **Render Website**.
5. RStudio builds the pages into the `docs/` folder and opens a live preview.

> No **Render** button? Quarto isn't installed yet — do step b1, restart RStudio, retry.
> Prefer no RStudio? Open a terminal in the `site` folder and run `quarto render`.

---

## Step 3 — Turn on the live website (GitHub Pages)
1. Back in **GitHub Desktop** you'll see the newly built files listed. Type a short
   summary (e.g. "build site"), click **Commit to main**, then **Push origin**.
2. On **github.com**, open your repo → **Settings → Pages**.
3. Under *Build and deployment*: **Source = Deploy from a branch**;
   **Branch = main**, **folder = /docs** → **Save**.
4. Wait ~1 minute — your site goes live at `https://<username>.github.io/<repo>/`.

---

## Step 4 — Point michaelfjoseph.com at it (when you're ready)
Your domain is currently on Wix. When you want to switch it over:
1. Repo **Settings → Pages → Custom domain** → enter `www.michaelfjoseph.com` → Save.
2. At your domain registrar, add the DNS records GitHub shows (a `CNAME` to
   `<username>.github.io`, plus the apex `A` records).
3. After DNS propagates, tick **Enforce HTTPS**.

> Tell me when you reach this step and I'll give you the exact records to paste.

---

## Your everyday update loop (after setup)
1. Edit a `.qmd` file (or add a paper in `_data/publications.yml`).
2. **Render** (RStudio "Render" button, or `quarto render`).
3. In **GitHub Desktop**: **Commit** → **Push**. Live in ~1 minute.

## Even simpler, later (optional)
Once you're comfortable, a single command does render + publish in one go:
```
quarto publish gh-pages
```

**Tip:** commit often — every commit is a restore point you can roll back to.
