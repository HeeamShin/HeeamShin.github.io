# GitHub Pages 기본 내장 Jekyll로 꾸미는 방법 (2026년 11월 기준)

Context for the writer: the user's repo is a username.github.io repo with plain Markdown, **no `_config.yml`**, posts under `docs/books/*.md`, and images under `/images/` at the repo root. Notes are mostly in English with key Korean terms. All config and code snippets below are either quoted or paraphrased from the cited sources. Snippets marked "(example, not from a source)" are my own syntheses.

---

## Q1. What does GitHub Pages render when there is no `_config.yml`?

### Takeaway
Even without `_config.yml`, the branch-based Pages build still runs Jekyll in "github-pages" mode. It uses the default theme **`jekyll-theme-primer`**, and nine plugins are always on and cannot be turned off. Because of those plugins, plain `.md` files without front matter still become HTML pages, and each page gets its title from its first heading. A README becomes the index page, and links to `.md` files are rewritten to `.html`. That is why the user's site already "works" as an unstyled-looking Primer site.

### Cited Findings
- pages-gem `DEFAULTS` sets `"theme" => "jekyll-theme-primer"`, `"markdown" => "kramdown"`, `"future" => true`, and `"exclude" => ["CNAME"]`. A theme the user sets takes precedence. A theme can be turned off explicitly with `theme: null`. — [pages-gem configuration.rb](https://github.com/github/pages-gem/blob/master/lib/github-pages/configuration.rb)
- `OVERRIDES` are forced regardless of user config: `lsi: false`, `safe: true`, `highlighter: rouge`, `kramdown.math_engine: mathjax`, and more. Production also forces `sass: { style: compressed }`. — [pages-gem configuration.rb](https://github.com/github/pages-gem/blob/master/lib/github-pages/configuration.rb)
- The plugins that are "enabled by default and cannot be disabled" are jekyll-coffeescript, jekyll-default-layout, jekyll-gist, jekyll-github-metadata, jekyll-optional-front-matter, jekyll-paginate, jekyll-readme-index, jekyll-titles-from-headings, and jekyll-relative-links. — [GitHub Docs: About GitHub Pages and Jekyll](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll). The pages-gem `DEFAULT_PLUGINS` list also includes `jekyll-commonmark-ghpages`. — [pages-gem plugins.rb](https://github.com/github/pages-gem/blob/master/lib/github-pages/plugins.rb)
- **jekyll-optional-front-matter**: any Markdown file is rendered as a Page even without YAML front matter. README, CONTRIBUTING, CODE_OF_CONDUCT, and LICENSE are excluded unless they have front matter or are listed in `include`. Options under `optional_front_matter:` are `remove_originals: true`, which drops the raw .md files from output, and `enabled: false`. — [jekyll-optional-front-matter](https://github.com/benbalter/jekyll-optional-front-matter)
- **jekyll-readme-index**: if there is no other index file, the README becomes the site index. Candidate locations in priority order are `.github/README.md`, `README.md`, and `docs/README.md`. Options under `readme_index:` are `enabled`, `remove_originals`, `with_frontmatter`, `append_html`, and `readme_pattern`. — [jekyll-readme-index](https://github.com/benbalter/jekyll-readme-index)
- **jekyll-titles-from-headings**: if front matter has no `title` and the first non-blank line is an H1, H2, or H3, that heading becomes `page.title`. Options under `titles_from_headings:` are `enabled`, `strip_title`, which removes the heading from the body so the title does not appear twice when the theme prints `page.title`, and `collections`. — [jekyll-titles-from-headings](https://github.com/benbalter/jekyll-titles-from-headings)
- **jekyll-default-layout**: Markdown files without a `layout` get one automatically. `/index.md` gets `home`, then `page`, then `default`. Other pages get `page`, then `default`. Posts get `post`, then `default`. Collection documents get a layout named after the collection, then `default`. HTML files get no layout unless `html_pages: true` is set. `layout: null` opts a file out. — [jekyll-default-layout](https://github.com/benbalter/jekyll-default-layout)
- **jekyll-relative-links**: `[foo](bar.md)` becomes `bar.html`. A target's `permalink` is respected, and with `permalink: pretty` the `.html` is dropped. Options under `relative_links:` are `enabled`, `collections` (default false; set true to process links in collections and posts), and `exclude`. Links that contain hard line breaks are not processed, but reference-style links are. The README only talks about `.md` links and says nothing about images. — [jekyll-relative-links](https://github.com/benbalter/jekyll-relative-links)
- Jekyll skips `/node_modules`, `/vendor`, names starting with `_`, `.`, or `#`, names ending with `~`, and anything in `exclude`. Use `include` to process these. — [GitHub Docs: About GitHub Pages and Jekyll](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll)

### Inferences
- The user's site, with no config, is rendered with Primer. Each `docs/books/*.md` becomes `docs/books/<name>.html` with a title taken from its first `#` heading. Cross-links like `[x](other.md)` work after conversion to `.html`.
- Only `.md` links are rewritten. Image links (`![](...)`) are copied as-is, so image paths must be correct relative to the URL of the **rendered HTML page**. Root-absolute paths like `/images/foo.png` are the safest choice for a username.github.io site, because the baseurl is empty.
- Adding even a minimal `_config.yml` (title, description, theme) is the first step for any customization. None of the default plugins need to be listed in `plugins:`.

### Gaps
- The full exclusion list in jekyll-optional-front-matter (`lib/jekyll-optional-front-matter.rb`) was not fetched.
- I did not confirm whether Primer's layout prints `page.title` automatically. That matters for whether `strip_title` is needed.

---

## Q2. How to pick a theme: officially supported themes vs `remote_theme`

### Takeaway
Officially supported themes are set with `theme: <gem-name>`. Any public Jekyll theme repository on GitHub can be used with `remote_theme: owner/repo@tag` plus the `jekyll-remote-theme` plugin, which is whitelisted. The supported set has not changed in years: 13 "jekyll-theme-*" themes plus minima and swiss.

### Cited Findings
- The docs list these supported themes: Architect, Cayman, Dinky, Hacker, Leap day, Merlot, Midnight, Minima, Minimal, Modernist, Slate, Tactile, and Time machine. The syntax is `theme: jekyll-theme-minimal` for supported themes and `remote_theme: THEME-NAME` for other themes hosted on GitHub. — [GitHub Docs: Adding a theme](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/adding-a-theme-to-your-github-pages-site-using-jekyll)
- Theme versions on the Pages dependency page: jekyll-theme-* 0.2.0 (architect, cayman, dinky, hacker, leap-day, merlot, midnight, minimal, modernist, slate, tactile, time-machine), jekyll-theme-primer 0.6.0, minima 2.5.1, and jekyll-swiss 1.0.0. — [pages.github.com/versions](https://pages.github.com/versions/). The `THEMES` hash in pages-gem matches these versions. — [pages-gem plugins.rb](https://github.com/github/pages-gem/blob/master/lib/github-pages/plugins.rb)
- Remote-theme usage from the Cayman README:
  ```yaml
  remote_theme: pages-themes/cayman@v0.2.0
  plugins:
  - jekyll-remote-theme
  ```
  The theme's config variables are `title`, `description`, `show_downloads` (true or false, unquoted), and `google_analytics`. — [pages-themes/cayman](https://github.com/pages-themes/cayman)
- `jekyll-remote-theme` is in the pages-gem `PLUGIN_WHITELIST`. — [pages-gem plugins.rb](https://github.com/github/pages-gem/blob/master/lib/github-pages/plugins.rb). It is version 0.4.3 on the versions page. — [pages.github.com/versions](https://pages.github.com/versions/). pages-gem v233 bumps it to 0.6.2, which requires Ruby 3.0+. — [pages-gem releases](https://github.com/github/pages-gem/releases)

Minimal `_config.yml` with a built-in theme (example, not from a source; keys come from the docs and theme README above):
```yaml
title: 독서 노트
description: 읽은 책 정리
theme: jekyll-theme-cayman      # or: minima, jekyll-theme-minimal, ...
lang: ko
plugins:
  - jekyll-seo-tag            # whitelisted; most pages-themes use {% seo %}
  - jekyll-sitemap
```

### Inferences
- Use `theme:` for a supported theme. It is simpler and has no network fetch at build time. Use `remote_theme:` for popular third-party themes such as Minimal Mistakes, Just the Docs, or Chirpy, but a remote theme only works on the branch build if every plugin it needs is whitelisted. Many modern themes, Chirpy for example, need non-whitelisted plugins or Jekyll 4 and therefore need an Actions build (see Q4).
- Pin `remote_theme` to a tag (`@v0.2.0`) so builds are reproducible.
- `lang: ko` is used by pages-themes layouts (`<html lang="{{ site.lang | default: "en-US" }}">`, seen in the Cayman layout), which is good for Korean text.

### Gaps
- The old "Theme chooser" UI in repository Settings was removed years ago. The current docs only describe editing `_config.yml`, and I did not find an official removal date in this session.

---

## Q3. Overriding theme CSS, `_layouts`, and `_includes`

### Takeaway
Create `/assets/css/style.scss` containing **empty front matter plus `@import "{{ site.theme }}";`** and put custom CSS after it. Override Sass variables *before* the import. For HTML, copy the theme's `_layouts/default.html` into your repo's `_layouts/`. For small additions such as fonts, a favicon, or analytics, pages-themes include an empty hook, `_includes/head-custom.html`, at the end of `<head>`.

### Cited Findings
- Official CSS override (docs and Cayman README):
  ```scss
  ---
  ---

  @import "{{ site.theme }}";

  /* custom CSS/Sass below */
  ```
  Add custom CSS after the `@import`. To change theme Sass variables, set them before the `@import`. — [GitHub Docs: Adding a theme](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/adding-a-theme-to-your-github-pages-site-using-jekyll); [pages-themes/cayman](https://github.com/pages-themes/cayman)
- To override the layout, copy the theme's `_layouts/default.html` into `/_layouts/default.html` in your site and edit it. — [GitHub Docs: Adding a theme](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/adding-a-theme-to-your-github-pages-site-using-jekyll). For small changes such as a favicon, add files to your local `_includes`. For the newest Google Analytics code, use `_includes/head-custom-google-analytics.html`. — [pages-themes/cayman](https://github.com/pages-themes/cayman)
- The Cayman `_layouts/default.html` loads its CSS from `{{ '/assets/css/style.css?v=' | append: site.github.build_revision | relative_url }}` and has `{% include head-custom.html %}` as the last line of `<head>`, plus `{% seo %}` from jekyll-seo-tag. The structure is `header.page-header` (h1.project-name, h2.project-tagline), then `main#content.main-content` containing `{{ content }}`, then `footer.site-footer` inside `<main>`. — [cayman default.html](https://raw.githubusercontent.com/pages-themes/cayman/master/_layouts/default.html)
- To override GitHub-generated URLs used by templates (e.g. `site.github.zip_url`), nest them under `github:` in `_config.yml`. — [pages-themes/cayman](https://github.com/pages-themes/cayman)

Example `_includes/head-custom.html` for Korean web fonts (example, not from a source):
```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link rel="icon" href="{{ '/images/favicon.png' | relative_url }}">
```
Then in `assets/css/style.scss`, after the import: `body { font-family: Pretendard, sans-serif; }`

### Inferences
- A file in your repo at the same path as a theme file (`_layouts/x.html`, `_includes/x.html`, `assets/css/style.scss`) wins over the theme's copy. This is standard Jekyll theme override behavior and is what both docs above rely on.
- Overriding `_includes/head-custom.html` is the least invasive change because the layout stays upstream. Copying `default.html` means you stop getting theme updates.
- With minima 2.5.1, the stylesheet entry point is `assets/main.scss` rather than `assets/css/style.scss`. Check each theme's README, because the override filename depends on the theme.

### Gaps
- The contents of `head-custom.html` in the Cayman repo were not fetched. It is presumably empty or a GA include.
- minima's exact override file names and paths were not verified in this session.

---

## Q4. Whitelisted plugins, version limits, and getting around them with GitHub Actions

### Takeaway
The built-in Pages build is pinned to **Jekyll 3.10.0** (github-pages gem 232, last listed update 2025-08-13). It runs in `safe` mode with about 20 whitelisted plugins. Custom `_plugins/*.rb` and non-whitelisted gems are ignored or fail. GitHub's docs now call GitHub Actions "the recommended approach." There are two Actions paths. **(a)** The `actions/jekyll-build-pages@v1` starter workflow ("Jekyll with GitHub Pages dependencies preinstalled") behaves the same as the branch build, so it has the same limits. **(b)** The "Deploy Jekyll site to Pages" starter (`ruby/setup-ruby` + `bundle exec jekyll build`) lets you use any Jekyll version (4.x) and any plugins from your own Gemfile.

### Cited Findings
- Versions page: github-pages **232**, Jekyll **3.10.0**, Ruby **3.3.4**, last updated 2025-08-13. Plugins: jekyll-avatar 0.8.0, jekyll-coffeescript 1.2.2, jekyll-commonmark-ghpages 0.5.1, jekyll-default-layout 0.1.5, jekyll-feed 0.17.0, jekyll-gist 1.5.0, jekyll-github-metadata 2.16.1, jekyll-include-cache 0.2.1, jekyll-mentions 1.6.0, jekyll-optional-front-matter 0.3.2, jekyll-paginate 1.1.0, jekyll-readme-index 0.3.0, jekyll-redirect-from 0.16.0, jekyll-relative-links 0.6.1, jekyll-remote-theme 0.4.3, jekyll-sass-converter 1.5.2, jekyll-seo-tag 2.8.0, jekyll-sitemap 1.4.0, jekyll-titles-from-headings 0.5.3, and jemoji 0.13.0. — [pages.github.com/versions](https://pages.github.com/versions/)
- `PLUGIN_WHITELIST` in pages-gem: jekyll-coffeescript, jekyll-commonmark-ghpages, jekyll-feed, jekyll-gist, jekyll-github-metadata, jekyll-paginate, jekyll-redirect-from, jekyll-seo-tag, jekyll-sitemap, jekyll-avatar, jemoji, jekyll-mentions, jekyll-relative-links, jekyll-optional-front-matter, jekyll-readme-index, jekyll-default-layout, jekyll-titles-from-headings, jekyll-include-cache, jekyll-octicons, and jekyll-remote-theme. — [pages-gem plugins.rb](https://github.com/github/pages-gem/blob/master/lib/github-pages/plugins.rb)
- Extra plugins go in `plugins:` in `_config.yml`, for example `jemoji`. "GitHub Pages cannot build sites using unsupported plugins." For those, build locally and push the static files. — [GitHub Docs: About GitHub Pages and Jekyll](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll)
- "While the github-pages gem remains supported for some workflows, GitHub Actions is now the recommended approach for deploying and automating GitHub Pages sites." — [GitHub Docs: About GitHub Pages and Jekyll](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll)
- pages-gem release history: v230 bumped Jekyll to 3.9.5; v232 added webrick, with a PR referencing "jekyll3.10"; v233 (dated "03 Nov", year not shown on the page) updated jekyll-redirect-from 0.17.0, jekyll-seo-tag 2.9.1, jekyll-feed 0.18.0, and jekyll-remote-theme 0.6.2 for security advisories. **No release mentions Jekyll 4.** — [pages-gem releases](https://github.com/github/pages-gem/releases)
- Starter workflow **"Deploy Jekyll with GitHub Pages dependencies preinstalled"** (`pages/jekyll-gh-pages.yml`): triggers on push to the default branch and on `workflow_dispatch`. Permissions are `contents: read`, `pages: write`, `id-token: write`. Concurrency group is `pages` with `cancel-in-progress: false`. The build job runs `actions/checkout@v4`, then `actions/configure-pages@v5`, then `actions/jekyll-build-pages@v1` (source `./`, destination `./_site`), then `actions/upload-pages-artifact@v3`. The deploy job runs `actions/deploy-pages@v5` in the `github-pages` environment. — [starter-workflows jekyll-gh-pages.yml](https://github.com/actions/starter-workflows/blob/main/pages/jekyll-gh-pages.yml)
- `actions/jekyll-build-pages` inputs are `source` (default `./`), `destination` (`./_site`), `future` (false), `build_revision` (`$GITHUB_SHA`), `verbose`, and `token`. It "produces Jekyll build artifacts compatible with GitHub Pages." — [actions/jekyll-build-pages](https://github.com/actions/jekyll-build-pages)
- Starter workflow **"Deploy Jekyll site to Pages"** (`pages/jekyll.yml`): build steps are `actions/checkout@v4`, then `ruby/setup-ruby` with Ruby 3.1 and bundler-cache, then `actions/configure-pages@v5` (id `pages`), then `bundle exec jekyll build --baseurl "${{ steps.pages.outputs.base_path }}"` with `JEKYLL_ENV=production`, then `actions/upload-pages-artifact@v3`. Deploy uses `actions/deploy-pages@v5`. — [starter-workflows jekyll.yml](https://github.com/actions/starter-workflows/blob/main/pages/jekyll.yml)
- A 2026 DEV tutorial uses a GitHub Actions workflow to run Jekyll 4.3 with full plugin support, because the built-in builder only accepts a limited set of gems. — [DEV: Deploy Jekyll to GitHub Pages in 2026](https://dev.to/pooyagolchian/deploy-jekyll-to-github-pages-in-2026-github-actions-custom-domain-cloudflare-55e9)

Custom-Actions workflow skeleton (example reconstructed from the jekyll.yml starter summary; save as `.github/workflows/pages.yml`; requires Settings → Pages → Source = "GitHub Actions"):
```yaml
name: Deploy Jekyll site to Pages
on:
  push:
    branches: [main]
  workflow_dispatch:
permissions:
  contents: read
  pages: write
  id-token: write
concurrency:
  group: pages
  cancel-in-progress: false
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.3'
          bundler-cache: true
      - id: pages
        uses: actions/configure-pages@v5
      - run: bundle exec jekyll build --baseurl "${{ steps.pages.outputs.base_path }}"
        env:
          JEKYLL_ENV: production
      - uses: actions/upload-pages-artifact@v3
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - id: deployment
        uses: actions/deploy-pages@v5
```
The Gemfile for this path (example) would contain `gem "jekyll", "~> 4.4"`, the chosen theme gem, and `group :jekyll_plugins do ... end` with any plugins. In that case do **not** use the `github-pages` gem.

### Inferences
- **Jekyll 3.x vs 4.x status:** As of Nov 2026, the built-in Pages build is still on Jekyll 3.x (3.10.0 on the versions page, last updated Aug 2025). There is no announced move to Jekyll 4. Treat any tutorial that assumes Jekyll 4 features on branch builds as wrong. Jekyll 4 only works through the custom Actions path.
- I believe GitHub's own "pages build and deployment" run for branch sites uses the same `jekyll-build-pages` machinery, which would explain the identical limits. This is not directly confirmed in the sources above.
- If the user only wants a supported theme, a few CSS tweaks, and seo/sitemap/feed, the branch build is enough. Switch to custom Actions only for Jekyll 4, non-whitelisted plugins (jekyll-archives, jekyll-toc, and similar), or themes that need them.
- `jekyll-paginate` (v1) only paginates `_posts` in `index.html`, not arbitrary pages. That is standard Jekyll behavior and was not re-verified here. It is irrelevant for `docs/books/*.md` unless those files move to `_posts`.

### Gaps
- **The year of pages-gem v233 ("03 Nov") was not visible.** It is most likely 2025, given that the versions page (updated 2025-08-13) still shows v232. That page has not been updated for v233, so the production plugin versions may be slightly newer than listed. Check `https://pages.github.com/versions.json` before quoting exact versions.
- The Gemfile.lock and Dockerfile of `actions/jekyll-build-pages` were not fetched, so its exact pinned github-pages version is unconfirmed.
- Action major versions (checkout@v4, upload-pages-artifact@v3, deploy-pages@v5) are as of the starter-workflow snapshot fetched. Newer majors may exist.

---

## Q5. Publishing source: branch root vs `/docs` vs GitHub Actions, and the `/images` pitfall

### Takeaway
There are three choices: **branch `/` (root)**, **branch `/docs`**, or **GitHub Actions**. With the `/docs` folder as source, **only the contents of `docs/` are built and served**. A root-level `/images/` folder is outside the site and returns 404, so every image breaks. For this repo, the simplest fix is to **publish from the branch root**. Then `/images/...` is served at `https://username.github.io/images/...` and books live at `/docs/books/<name>.html`.

### Cited Findings
- From a branch, you can choose any branch and either the root (`/`) or the `/docs` folder; pushes to the branch publish that folder's contents. Repos with symbolic links must use Actions. — [GitHub Docs: Configuring a publishing source](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)
- "Branch sites serve the contents of the selected folder (root or `/docs`). Action-based sites serve the files uploaded as the artifact." — [GitHub Docs: Configuring a publishing source](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)
- If you select `/docs` and later delete it, the build fails with a missing `/docs` folder error. "Commits pushed by a GitHub Actions workflow that uses the `GITHUB_TOKEN` do not trigger a GitHub Pages build." External CI often pushes built output to `gh-pages` with `.nojekyll`, which skips the Jekyll build. — [GitHub Docs: Configuring a publishing source](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)
- The Actions workflow pattern is checkout, then build, then `actions/upload-pages-artifact`, then `actions/deploy-pages`, using a `github-pages` environment. Pages settings point to the run that most recently deployed the site. — [GitHub Docs: Configuring a publishing source](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)
- The publishing source is also where `_config.yml` must live. The docs tell you to open "your site's repository and go to its publishing source" and edit `_config.yml` there. — [GitHub Docs: Adding a theme](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/adding-a-theme-to-your-github-pages-site-using-jekyll)

### Inferences
- **The pitfall is confirmed by the docs' wording.** With source = `/docs`, Jekyll's source directory is `docs/`. `/images/` at the repo root is never copied into the output, so `<img src="/images/x.png">` returns 404. Relative paths like `../../images/x.png` also fail, because they resolve outside the site root. In addition, `_config.yml`, `_layouts`, `_includes`, and `assets/` would all have to live inside `docs/`, and URLs would change: `docs/books/a.md` would be served at `/books/a.html`, not `/docs/books/a.html`.
- Fix options, from simplest to most involved:
  1. **Root source (recommended for this repo):** Settings → Pages → Deploy from a branch → `main` / `(root)`. Put `_config.yml`, `assets/css/style.scss`, and `_includes/` at the repo root. Images work as `/images/...`.
  2. Keep `/docs` and move images into `docs/images/`, then rewrite links.
  3. Use GitHub Actions with `source: ./` (jekyll-build-pages) or a custom build from the root. This is equivalent to option 1 but adds control.
- Pick one source only. Having `_config.yml` both at the root and in `docs/` causes confusion, because only the one in the publishing source is used.
- Exclude non-site files when publishing from root: `exclude: [research_notes, Gemfile, Gemfile.lock, vendor]` (example). Jekyll's defaults already skip names starting with `.` or `_` and the `vendor` folder.

### Gaps
- No official doc sentence explicitly says "files outside `/docs` are not served." The conclusion follows from "publish that folder's contents" and "serve the contents of the selected folder."

---

## Q6. Local preview with `bundle exec jekyll serve` and a Gemfile using the github-pages gem

### Takeaway
Add a Gemfile with `gem "github-pages", group: :jekyll_plugins` (plus `webrick` on Ruby 3+), then run `bundle install` and `bundle exec jekyll serve`, and open http://localhost:4000. Keep the gem updated so the local build matches production.

### Cited Findings
- Steps: `bundle install`, then `bundle exec jekyll serve`, then open `http://localhost:4000`. If `baseurl` is set, use `bundle exec jekyll serve --baseurl=""`. Ruby 3.0+ no longer ships `webrick`; run `bundle add webrick`. Update with `bundle update github-pages`. A local build that differs from GitHub's can make the site "look different when built locally than when published on GitHub." — [GitHub Docs: Testing locally](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/testing-your-github-pages-site-locally-with-jekyll)
- The same docs page says Ruby 3.2 or later may cause missing gem and method errors with the github-pages gem, and recommends Ruby 3.1.x or earlier. — [GitHub Docs: Testing locally](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/testing-your-github-pages-site-locally-with-jekyll). **This conflicts with** pages-gem v229, which "added Ruby 3.2+ support", and v232, which added webrick ([pages-gem releases](https://github.com/github/pages-gem/releases)), and with the versions page listing Ruby 3.3.4 as the production Ruby ([pages.github.com/versions](https://pages.github.com/versions/)).
- Gemfile line from the theme README: `gem "github-pages", group: :jekyll_plugins`. — [pages-themes/cayman](https://github.com/pages-themes/cayman)
- Jekyll is not officially supported on Windows. — [GitHub Docs: About GitHub Pages and Jekyll](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll)

Example Gemfile (example, not from a source; assembled from the lines above):
```ruby
source "https://rubygems.org"
gem "github-pages", group: :jekyll_plugins
gem "webrick"   # Ruby 3.x
```
On macOS: `brew install rbenv && rbenv install 3.3.4`, then `bundle install && bundle exec jekyll serve --livereload` (example).

### Inferences
- The docs' "use Ruby ≤3.1" advice looks outdated given github-pages 229+ and production Ruby 3.3.4. Matching production at Ruby 3.3.x is likely fine. If errors appear, fall back to 3.1.
- Add `Gemfile.lock`, `_site/`, `.jekyll-cache/`, and `vendor/` to `.gitignore` (example).

### Gaps
- I did not test locally whether github-pages 232 runs cleanly on Ruby 3.3 or 3.4.

---

## Q7. Navigation, index page, and post listings for a Markdown-notes site

### Takeaway
Because `docs/books/*.md` are ordinary **pages**, not `_posts`, list them with Liquid over `site.pages`. Make an `index.md` at the root, which takes priority over README as the index, and build a nav either in a custom `_includes/head-custom.html`/layout or with a hand-written link list. Titles come from the first heading automatically.

### Cited Findings
- readme-index only applies when no other index exists. — [jekyll-readme-index](https://github.com/benbalter/jekyll-readme-index)
- Front matter sets variables such as `title` and `layout`, and `site.github` exposes repository metadata. — [GitHub Docs: About GitHub Pages and Jekyll](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll)
- `index.md` gets the `home` layout if the theme has one, otherwise `page`, otherwise `default`. — [jekyll-default-layout](https://github.com/benbalter/jekyll-default-layout)
- Titles fall back to the first H1, H2, or H3. — [jekyll-titles-from-headings](https://github.com/benbalter/jekyll-titles-from-headings)
- Theme layouts show `site.title` and `site.description` in the header (Cayman's `project-name` and `project-tagline`). — [pages-themes/cayman](https://github.com/pages-themes/cayman)

Book index for `index.md` (example, not from a source; uses standard Jekyll Liquid filters):
```liquid
---
title: 독서 노트
---
## 책 목록
{% assign books = site.pages | where_exp: "p", "p.path contains 'docs/books/'" | sort: "title" %}
<ul>
{% for b in books %}
  <li><a href="{{ b.url | relative_url }}">{{ b.title }}</a>{% if b.date %} — {{ b.date | date: "%Y-%m-%d" }}{% endif %}</li>
{% endfor %}
</ul>
```
Optional front matter per book for sorting or metadata (example): `date: 2026-11-01`, `author: ...`, `rating: 4`, then `| sort: "date" | reverse`.

Site-wide defaults, so every book gets a layout or variables without per-file front matter (example; standard Jekyll `defaults`):
```yaml
defaults:
  - scope: { path: "docs/books" }
    values: { layout: default, category: book }
```

Collection alternative (example): rename `docs/books` to `_books`, add `collections: { books: { output: true, permalink: /books/:name/ } }`, and iterate `site.books`. This changes URLs, and relative links in collections need `relative_links.collections: true`. — [jekyll-relative-links](https://github.com/benbalter/jekyll-relative-links) (for the collections flag)

### Inferences
- The lowest-effort path for this user: root publishing source, `_config.yml` with `theme:` + `title`/`description`/`lang: ko`, a root `index.md` with the Liquid list above, `assets/css/style.scss` for typography, and `_includes/head-custom.html` for a Korean font and favicon. No Actions are needed.
- If a real sidebar or top nav, search, or tags are wanted, a remote theme like Just the Docs (built for docs-style notes) or Minimal Mistakes is a better fit than hand-coding. Check whether the theme works on the branch build or needs custom Actions.
- `where_exp` and `relative_url` exist in Jekyll 3.x, so the snippet should work on the built-in Jekyll 3.10. This is my knowledge, not verified in this session.

### Gaps
- Primer's or Cayman's built-in navigation support (e.g. a `header_pages` equivalent) was not checked. minima supports `header_pages` in config, but minima 2.5.1's exact behavior was not verified here.
- I found no Korean-language primary source that adds anything beyond the official docs. Korean results were mostly localized GitHub Docs pages ([docs.github.com/ko](https://docs.github.com/ko/pages/setting-up-a-github-pages-site-with-jekyll/adding-a-theme-to-your-github-pages-site-using-jekyll)), which can be cited for Korean readers.
