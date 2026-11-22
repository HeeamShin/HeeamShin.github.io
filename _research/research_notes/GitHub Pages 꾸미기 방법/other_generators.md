# Jekyll Alternatives for a GitHub Pages (username.github.io) Markdown Notes Site, as of Nov 2026

Context: plain-Markdown repo, book notes in `docs/books/*.md`, images in `/images/`. Research date: 2026-11-23.
How to read this: "Cited Findings" were checked against a source during this session. "Inferences" combine those findings with general knowledge of the tools; the writer should present them as recommendations, not verified facts.

## 1. Generator comparison: setup effort, themes, build speed, runtime

### Takeaway
Hugo (one Go binary, fastest builds, large theme catalogue) and Astro (Node, most flexible, broadly recommended for new content sites in 2026) are the main blog options. For documentation-style notes the main choice is Material for MkDocs or its successor Zensical. Starlight, Docusaurus and VitePress are Node-based docs options. Quartz is the specialist tool for Obsidian-style linked notes. Eleventy is minimal and flexible but takes more DIY work.

### Cited Findings
**Hugo**
- The official Hugo GitHub Pages guide (built with Hugo v0.170.1) pins `HUGO_VERSION` 0.170.0 in its sample workflow. It also pins Dart Sass 1.108.2, Go 1.27.4 and Node.js 24.22.3 as optional extras, and builds with `hugo build --gc --minify` into `./public`. — [Hugo docs: Host on GitHub Pages](https://gohugo.io/host-and-deploy/host-on-github-pages/)
- Search snippets show versions 0.162–0.164 earlier in 2026; Wikipedia's "0.163.1 as of June 2026" is an older snapshot. 0.162.0 added AVIF image support. — [Chocolatey hugo 0.164.0](https://community.chocolatey.org/packages/hugo/0.164.0); [Wikipedia](https://en.wikipedia.org/wiki/Hugo_(software)); [GitLab MR mentioning 0.162 AVIF](https://gitlab.com/graphviz/graphviz.gitlab.io/-/merge_requests/763)
- PaperMod: a third-party listing describes it as actively maintained in early 2026. Star History shows about 13.8k stars in July 2026. — [Star History](https://www.star-history.com/adityatelange/hugo-papermod/); [AdminLTE Hugo themes 2026](https://adminlte.io/blog/hugo-themes/)
- Stack: about 6.5k stars on GitHub. I found no maintenance notice on the repo page. — [GitHub CaiJimmy/hugo-theme-stack](https://github.com/CaiJimmy/hugo-theme-stack). AdminLTE claims Stack has been "maintenance-only since Sept 2025" — [AdminLTE](https://adminlte.io/blog/hugo-themes/). That claim is **unverified and doubtful**: the repo shows no such notice, and the article's layout is jumbled.
- Blowfish is described as one of the most actively developed Hugo themes in 2026, but that source's layout is jumbled. Star counts conflict between sources (about 2.6k vs about 1.1k on the 2024-dated theme directory). — [AdminLTE](https://adminlte.io/blog/hugo-themes/); [Hugo Themes: Blowfish](https://themes.gohugo.io/themes/blowfish)
- Korean/English 2026 overviews say Hugo is the choice when build speed or large sites matter. Benchmark numbers vary widely by source: one dev.to benchmark even has Astro faster than Hugo at 10k pages, which contradicts the usual consensus. Treat all benchmarks as anecdotal. — [youngju.dev 2026-05 SSG comparison (KR)](https://www.youngju.dev/blog/culture/2026-05-14-static-site-generators-2026-hugo-eleventy-astro-mkdocs-docusaurus-mintlify-starlight-comparison-deep-dive); [dev.to benchmark](https://dev.to/johalputt/benchmark-astro-5-vs-hugo-0120-vs-jekyll-4-for-static-site-build-time-and-bundle-size-5bfl)

**Astro (+ AstroPaper, Starlight)**
- Cloudflare acquired Astro (The Astro Technology Company) on 2026-01-16, and Astro is to remain open source (the MIT license is my understanding; the sources only say "open source"). — [Cloudflare press release](https://www.cloudflare.com/press/press-releases/2026/cloudflare-acquires-astro-to-accelerate-the-future-of-high-performance-web-development/); [Cloudflare blog](https://blog.cloudflare.com/astro-joins-cloudflare/); [heise](https://heise.de/-11145912)
- Astro 6 is released ("Astro 6 is here!"). It requires Node 22+, its dev server is based on the Vite Environments API, Live Content Collections and the CSP API are stable, and it ships an experimental Rust compiler. — [Astro blog: Astro 6](https://astro.build/blog/astro-6); [InfoQ Astro v6 beta](https://www.infoq.com/news/2026/02/astro-v6-beta-cloudflare); [heise Astro 6.0](https://heise.de/-11207142)
- The official deploy guide uses `withastro/action@v6`, which defaults to Node 24 and auto-detects npm/yarn/pnpm/bun from the lockfile. For `username.github.io` you set only `site: 'https://<username>.github.io'` and no `base`. — [Astro docs: Deploy to GitHub Pages](https://docs.astro.build/en/guides/deploy/github/)
- Starlight is Astro's docs framework; for example, Stainless-generated docs sites use Astro + Starlight. — [Cloudflare blog](https://blog.cloudflare.com/astro-joins-cloudflare/)
- A Korean case study (Jekyll to Astro) reports build time falling from 209s to 30s and praises instant hot reload. — [deku.posstree.com (KR)](https://deku.posstree.com/ko/astro/migration-reason/)
- 2026 overviews commonly recommend Astro as the default for new content sites. — [eastondev blog framework guide (KR)](https://eastondev.com/blog/ko/posts/dev/20251123-blog-framework-guide/); [dev.to 2026 SSG comparison](https://dev.to/_6638a39c349d7e9c85ee20/best-static-site-generators-2026-astro-vs-hugo-vs-11ty-vs-jekyll-1abb)

**Material for MkDocs / MkDocs / Zensical (biggest 2026 status change)**
- Material for MkDocs entered **maintenance mode** on 2025-11-05, when Zensical launched. 9.7.0 was the last release with new features. Critical bug fixes and security updates were promised for 12 months, i.e. through about 2026-11-05. **UPDATE: the Zensical newsletter (Aug 2026) says "Material for MkDocs EOL extended until May 5, 2027."** It doesn't say whether that means security fixes only. Latest stable 9.7.6 (Mar 2026) is per a search aggregate and unverified. — [Zensical Monthly Aug 2026: What changes on November 5](https://mail.zensical.org/monthly/2026/08/); [Material blog: Zensical](https://squidfunk.github.io/mkdocs-material/blog/2025/11/05/zensical/); [Insiders now free](https://squidfunk.github.io/mkdocs-material/blog/2025/11/11/insiders-now-free-for-everyone/); [privacyguides discussion](https://discuss.privacyguides.net/t/mkdocs-material-is-now-in-maintenance-mode/32736)
- Upstream **MkDocs 1.x is "unmaintained"**, with no releases in about 18 months as of Feb 2026. MkDocs 2.0 is a pre-release, ground-up rewrite with potentially major breaking changes, and Material does not control MkDocs. — [Material blog: What MkDocs 2.0 means (2026-02-18, updated 2026-10-02)](https://squidfunk.github.io/mkdocs-material/blog/archive/2026)
- **Zensical** comes from the Material team. It is written in Rust, reads existing `mkdocs.yml`, and is installed with `pip install zensical`. The newsletter timeline: module system first version (Mar 2026), "What changes on November 5" (Aug 2026, announces that Zensical 0.1.0 ships on 2026-11-05, that Zensical and the team's OSS stay "free forever", and that Zensical Studio leaves beta with Free/Pro/Team editions), "Zensical 0.1.0" (Oct 2026 issue). 0.1.0 is described as closing major MkDocs compatibility gaps, including widely used plugins. — [Zensical newsletter index](https://zensical.org/about/newsletter/); [Zensical Monthly Mar 2026](https://mail.zensical.org/monthly/2026/03/index.html); [newreleases: zensical 0.1.0](https://newreleases.io/project/pypi/zensical/release/0.1.0)
- Some third parties call Zensical still immature and incompatible with parts of the MkDocs plugin ecosystem; this is one project's opinion. Community forks such as "MaterialX" exist. — [mkdocs-materialx: Why MaterialX](https://jaywhj.github.io/mkdocs-materialx/differences)

**Quartz**
- Quartz 5.2.0 ("22 Nov", latest) and 5.1.0 ("09 Nov"); the releases page shows no year, so 2026 is inferred. v5 moved configuration from TypeScript to YAML (`quartz.config.yaml`) and has a plugin system (`npx quartz plugin install/doctor`). It supports Obsidian Flavored Markdown 2.0, Bases and Canvas. Since 5.1.0, a single line break renders as `<br>` (opt out with `strictLineBreaks: true`) and `permalink` sets a page's URL. — [GitHub releases jackyzha0/quartz](https://github.com/jackyzha0/quartz/releases); [Quartz v4 docs: what's new](https://four.quartz.jzhao.xyz/getting-started/whats-new); [newreleases v5.1.0](https://newreleases.io/project/github/jackyzha0/quartz/release/v5.1.0)
- Runtime: Node 24 is used in the official workflow. — [Quartz docs: Hosting](https://quartz.jzhao.xyz/hosting)

**Docusaurus / VitePress / Eleventy**
- Docusaurus 3.10 is the last 3.x minor and prepares for v4; 3.10.1 shipped 2026-04-30. v4 is still in development, with future flags for Docusaurus Faster by default and MDX v1 compatibility turned off. — [Docusaurus 3.10 release](https://docusaurus.io/blog/releases/3.10); [Docusaurus changelog](https://docusaurus.io/changelog)
- VitePress: 1.6.x is stable. 2.0 has been in alpha all year (v2.0.0-alpha.19 around 2026-08-02, per an aggregator, not verified on npm). — [opentechhub VitePress](https://www.opentechhub.io/vitepress/); [GitHub vuejs/vitepress](https://github.com/vuejs/vitepress)
- Eleventy: 4.x alpha pre-releases started July 2025; I found no stable v4. — [11ty 2025 review](https://www.11ty.dev/blog/review-2025/). (That v3 is the current stable line is my inference; not cited.)
- Rspress 2.0 (Rsbuild-based React docs SSG) released 2026-01-30 and is another docs option. — [InfoQ](https://infoq.com/news/2026/03/rspress-docs-2-release)

### Inferences
- Runtime summary:
  - Hugo: a single Go binary with no runtime needed; the Extended edition is needed for Sass themes.
  - MkDocs/Zensical: Python, pip.
  - Astro, Starlight, Docusaurus, VitePress, Eleventy, Quartz: Node (22+ for Astro 6; Quartz workflow uses 24).
- Setup effort:
  - Lowest: MkDocs Material / Zensical (one YAML file) and Hugo + a theme via git submodule or Hugo Module.
  - Medium: Astro templates (AstroPaper, clone and edit), Starlight, VitePress.
  - Higher: Docusaurus (React, heavier) and Eleventy (bring your own layout).
- Customization: Astro and Eleventy are the most flexible. Hugo templating (Go templates) has a learning curve. MkDocs/Zensical customize mainly through config plus overrides.
- **Recommendation caveat:** for a new MkDocs-style site in late 2026, recommend Zensical, or Material 9.7.x knowing it gets no further updates. Material + MkDocs 1.x still works, but both upstreams are frozen.

### Gaps
- Exact current version numbers for Astro (6.x minor), AstroPaper, Starlight, Blowfish, PaperMod, Eleventy and VitePress as of Nov 2026 were not verified.
- Material's EOL was extended to 2027-05-05 per the Zensical newsletter. I couldn't confirm what support level (security-only?) applies, or whether the Material blog itself announced it.
- I found no reliable, apples-to-apples build-speed benchmark; published numbers conflict.

## 2. Deploying to GitHub Pages via GitHub Actions

### Takeaway
Every generator uses the same pattern: set Settings > Pages > Source to **GitHub Actions**, run a build job that ends with `upload-pages-artifact` (pointing at the output dir), then a deploy job with `deploy-pages`, with permissions `pages: write` and `id-token: write`. Action major versions differ between official docs in 2026, so use the latest ones.

### Cited Findings
- GitHub's starter `static.yml` (as fetched) uses `actions/checkout@v4`, `configure-pages@v5`, `upload-pages-artifact@v3` and `deploy-pages@v5`, with permissions `contents: read, pages: write, id-token: write` and concurrency group `pages` with `cancel-in-progress: false`. — [actions/starter-workflows pages/static.yml](https://raw.githubusercontent.com/actions/starter-workflows/main/pages/static.yml)
- The newer official docs reference higher versions:
  - Zensical: `configure-pages@v6`, `checkout@v7`, `setup-python@v6`, `upload-pages-artifact@v5`, `deploy-pages@v5`. — [Zensical: Publish your site](https://zensical.org/docs/publish-your-site/)
  - Astro: `checkout@v7`, `withastro/action@v6`, `deploy-pages@v5`. — [Astro docs](https://docs.astro.build/en/guides/deploy/github/)
  - Quartz: `checkout@v6`, `setup-node@v6`, `cache@v5`, `upload-pages-artifact@v3`, `deploy-pages@v4`. — [Quartz Hosting](https://quartz.jzhao.xyz/hosting)
- `actions/starter-workflows/pages/` also contains generator-specific templates (e.g. Hugo, Astro, Next.js, Gatsby, Nuxt, Jekyll). Only `static.yml` was fetched here, and it pins older majors than current generator docs. The template list is from general knowledge and was not re-verified.
- **Conflict:** pinned major versions vary across sources (upload-pages-artifact v3 vs v5, deploy-pages v4 vs v5). Advise checking each action's releases page.
- Hugo: set Source to GitHub Actions; workflow at `.github/workflows/hugo.yaml`. Set `caches.images.dir: :cacheDir/images` in config; build with `hugo build --gc --minify`; upload `./public`; don't commit `public/`. — [Hugo docs](https://gohugo.io/host-and-deploy/host-on-github-pages/)
- Zensical: `zensical new` auto-generates `.github/workflows/docs.yml`, which builds with `zensical build --clean` into `site/`. The docs advise against CI caches. — [Zensical: Publish](https://zensical.org/docs/publish-your-site/)
- Quartz: workflow runs `npm ci`, `npx quartz plugin install` and `npx quartz build`, outputting `public/`. Checkout uses `fetch-depth: 0` (git history feeds dates). Set `baseUrl` in `quartz.config.yaml`. **Caveats for this user:**
  - The official workflow triggers on pushes to the **`v5` branch**, so change it to `main`.
  - The doc's `<username>.github.io/<repository-name>` URL applies to project sites. For a `username.github.io` user site, the site serves from root and `baseUrl` should be `<username>.github.io`.

  GitHub Pages doesn't redirect trailing-slash URLs, so some links may break; Cloudflare Pages avoids this. — [Quartz Hosting](https://quartz.jzhao.xyz/hosting)
- Astro's sample workflow (condensed from the docs; step `name:` lines removed):
```yaml
name: Deploy to GitHub Pages
on:
  push:
    branches: [ main ]
  workflow_dispatch:
permissions:
  contents: read
  pages: write
  id-token: write
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
      - uses: withastro/action@v6
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v5
```
— [Astro docs](https://docs.astro.build/en/guides/deploy/github/)

### Inferences
- A generic Hugo workflow, simplified by me (the official one is longer: Dart Sass, Go and Node installs, caching):
```yaml
name: Deploy Hugo site to Pages
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
    env:
      HUGO_VERSION: 0.170.0
    steps:
      - uses: actions/checkout@v7          # verify latest major
        with:
          submodules: recursive            # if the theme is a git submodule
          fetch-depth: 0                   # for .GitInfo / lastmod
      - name: Install Hugo (extended)
        run: |
          wget -O ${{ runner.temp }}/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb
          sudo dpkg -i ${{ runner.temp }}/hugo.deb
      - id: pages
        uses: actions/configure-pages@v6
      - run: hugo build --gc --minify --baseURL "${{ steps.pages.outputs.base_url }}/"
      - uses: actions/upload-pages-artifact@v5
        with:
          path: ./public
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v5
```
- MkDocs Material (legacy path) can still use `mkdocs gh-deploy` (pushes to a `gh-pages` branch, Source = branch). The Actions + artifact pattern above is cleaner and consistent with the others.
- For `username.github.io` (a user site) the site is served at the root, so no base path is needed in Astro, VitePress (`base: '/'`), Docusaurus (`baseUrl: '/'`) or Hugo. This avoids the most common GitHub Pages pitfall.
- VitePress, Docusaurus and Eleventy follow the same pattern: `setup-node`, `npm ci`, build, then upload the output dir (`.vitepress/dist`, `build`, `_site` respectively). Their official deploy guides (vitepress.dev/guide/deploy, docusaurus.io/docs/deployment) include GitHub Pages sections; I didn't re-verify them this session.

### Gaps
- GitHub's docs.github.com page on custom workflows was not fetched this session. The starter-workflows file I got may be stale relative to the newer action majors other docs cite.
- VitePress, Docusaurus and Eleventy workflow YAML were not verified against current docs.

## 3. Migration effort from existing plain Markdown (front matter, image paths)

### Takeaway
MkDocs/Zensical and Quartz need the least migration: they read plain `.md` folders with no front matter required, and Quartz also handles Obsidian wikilinks. Hugo and Astro blog themes generally expect front matter (`title`, `date`, and for Astro content collections a schema-validated set such as `pubDatetime`/`description`), so expect to add front matter to every note. Root-absolute image paths (`/images/...`) need the images moved into a static/public folder.

### Cited Findings
- Quartz v5 front matter handling moved into `configuration.frontmatter`. `publishAssets` can be `all` or `referenced` (copy only linked files). Wikilink resolution is configured under `configuration.links`. — [Quartz releases](https://github.com/jackyzha0/quartz/releases)
- Quartz Syncer (an Obsidian plugin) publishes notes, Bases and Canvas to Quartz v5. It needs Obsidian 1.13.0+. — [Obsidian community: Quartz Syncer](https://community.obsidian.md/plugins/quartz-syncer); [changelog](https://saberzero1.github.io/quartz-syncer-docs/changelog)
- Quartz 5.1.0's change to rendering single line breaks as `<br>` changes how existing plain Markdown renders unless you set `strictLineBreaks: true`. — [Quartz releases](https://github.com/jackyzha0/quartz/releases)
- Zensical reads existing `mkdocs.yml` and is "compatible with MkDocs 1.x". — [Material blog 2026](https://squidfunk.github.io/mkdocs-material/blog/archive/2026); [Material Zensical post](https://squidfunk.github.io/mkdocs-material/blog/2025/11/05/zensical/)

### Inferences
These come from general knowledge of the tools and were not individually re-verified this session.
- **MkDocs/Zensical:** set `docs_dir: docs` (the default is already `docs/`). `docs/books/*.md` work as-is, the sidebar is generated from the folder structure, and H1 is used as the title. Images must live inside `docs/` (e.g. `docs/images/`), and relative links (`../images/x.png`) are preferred. A root `/images/` folder outside `docs/` won't be copied, so move it.
- **Hugo:** move notes to `content/books/`. Hugo renders files without front matter, but most themes (PaperMod, Blowfish) need `title`/`date` for lists and sorting. Move `/images/` to `static/images/` so `/images/x.png` URLs keep working. A Page Bundle is an alternative.
- **Astro (AstroPaper):** notes go into `src/content/blog/` (or a custom collection). The Zod schema typically *requires* front matter fields, so the build fails without them. Put `/images/` in `public/images/` for root paths to keep working, or use relative imports for optimized images.
- **Starlight:** content goes in `src/content/docs/`, and front matter `title` is required.
- **Docusaurus:** `docs/` is the default folder, so the current layout matches. MDX parsing is strict (bare `<` or `{` in notes can break builds). Images go in `static/images/`.
- **VitePress:** the docs root can be `docs/` and front matter is optional. Root-absolute images go in `docs/public/images/`.
- **Eleventy:** works on plain .md without front matter. Use passthrough copy for `images`. Layouts must be supplied.
- **Quartz:** content goes in `content/`. Front matter is optional (the title falls back to the filename). Wikilinks, backlinks and graph view work out of the box, and images are handled via asset copy.
- A small script (e.g. bash/Python) can add `title:` front matter, derived from the first H1 or filename, to all `docs/books/*.md` in one pass.

### Gaps
- I didn't verify per-generator behavior for files missing front matter against current docs (e.g. Hugo 0.170 or AstroPaper's current schema).

## 4. Best fit for (a) simple blog, (b) documentation-style book notes with sidebar, (c) digital garden; plus 2026 status

### Takeaway
(a) Simple blog: Hugo + PaperMod (zero JS runtime, fastest), or Astro + AstroPaper (more modern and flexible, Node needed). (b) Book notes with sidebar: Zensical / Material for MkDocs (closest to the current folder layout), or Astro Starlight if Node is fine; VitePress and Docusaurus are alternatives. (c) Linked notes: Quartz v5. Biggest 2026 status flags: Material/MkDocs 1.x frozen with Zensical as successor, Astro now owned by Cloudflare, and Quartz v5 released.

### Cited Findings
- Korean 2026 guides recommend Astro for typical personal blogs, Hugo for speed or large sites, and Jekyll only for minimal setup. — [eastondev (KR)](https://eastondev.com/blog/ko/posts/dev/20251123-blog-framework-guide/); [youngju.dev (KR)](https://www.youngju.dev/blog/culture/2026-05-14-static-site-generators-2026-hugo-eleventy-astro-mkdocs-docusaurus-mintlify-starlight-comparison-deep-dive)
- Quartz is positioned as an Obsidian-style digital garden publisher with OFM 2.0, Bases and Canvas support. — [Quartz releases](https://github.com/jackyzha0/quartz/releases); [Quartz Syncer](https://community.obsidian.md/plugins/quartz-syncer)
- Status flags as of Nov 2026:
  - Material 9.7.x is in maintenance; its EOL was originally about 2026-11-05 and is now extended to 2027-05-05 per the Zensical newsletter.
  - MkDocs 1.x is unmaintained and 2.0 is a breaking pre-release.
  - Zensical 0.1.0 shipped (announced for 2026-11-05).
  - Astro 6 is out, and Cloudflare owns Astro (Jan 2026).
  - Hugo docs are on 0.170.
  - Docusaurus 3.10 is the last 3.x, with v4 pending.
  - VitePress 2 is still alpha.
  - Eleventy 4 is in alpha.
  - Quartz 5.2.0 came out 2026-11-22.

  — sources as cited in sections 1–3.

### Inferences
- For this user (Korean, plain Markdown book notes, existing `docs/books/` layout), the **lowest-friction docs-style choice is Zensical** (or Material for MkDocs 9.7.x). It needs almost no file changes: move `images/` under `docs/`, and you get a built-in sidebar, search and dark mode. Python only.
  - Caveat: Material is frozen (EOL 2027-05-05). Zensical is young (0.1.x), but it is the maintained path.
  - Korean search: Material's lunr-based search had weak Korean tokenization historically. Zensical's search may differ. **Unverified; worth checking.**
- If the user wants a "blog" look with tags and a post list, choose **Hugo + PaperMod**: one binary, no Node, fast, needs front matter on each note. If they want maximum design freedom or a modern component approach, choose **Astro + AstroPaper/Starlight**.
- If the notes will start cross-linking (e.g. books ↔ concepts) or are written in Obsidian, choose **Quartz v5**. Note the line-break rendering change and the trailing-slash issue on GitHub Pages.
- Docusaurus is overkill for personal book notes (React/MDX strictness, heavier). VitePress is fine but Vue-centric, and 2.0 is still alpha. Eleventy suits people who want to hand-build layouts.

### Gaps
- No source compared Korean-language search quality across generators (Pagefind in Starlight/Quartz-style tools vs lunr in MkDocs vs Zensical's search). The writer should flag this as a consideration, not a finding.
- No verified 2026 usage/popularity statistics (stars/downloads) for Astro themes or for Quartz.
