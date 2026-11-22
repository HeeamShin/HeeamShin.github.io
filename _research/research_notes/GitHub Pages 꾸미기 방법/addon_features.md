# GitHub Pages (username.github.io) Add-on Features: Comments, Analytics, SEO, Search, UX, Custom Domain (as of Nov 2026)

Scope note: The user's repo is a plain-Markdown github.io repo of reading notes, most likely built by GitHub Pages' default Jekyll. Two points shape every recommendation below. (1) The built-in GitHub Pages Jekyll build allows only whitelisted plugins. (2) Anything outside that list, such as Pagefind, a newer Jekyll, or custom plugins, needs a GitHub Actions build.

## 0. Baseline: what the default GitHub Pages Jekyll build supports

### Takeaway
GitHub Pages' built-in build still runs Jekyll 3.10.0. It supports jekyll-seo-tag, jekyll-sitemap, jekyll-feed, Rouge, and kramdown out of the box. Unsupported plugins require a custom build: build locally, or use GitHub Actions, which GitHub now recommends for deploying Pages.

### Cited Findings
- Dependency versions on the GitHub Pages build: Jekyll 3.10.0, jekyll-seo-tag 2.8.0, jekyll-sitemap 1.4.0, jekyll-feed 0.17.0, kramdown 2.4.0, rouge 3.30.0, jekyll-github-metadata 2.16.1, jemoji 0.13.0, jekyll-relative-links 0.6.1, jekyll-optional-front-matter 0.3.2, jekyll-readme-index 0.3.0, jekyll-titles-from-headings 0.5.3. The page was last updated 2025-08-13. — [GitHub Pages Dependency versions](https://pages.github.com/versions/)
- These plugins are enabled by default and cannot be disabled: jekyll-coffeescript, jekyll-default-layout, jekyll-gist, jekyll-github-metadata, jekyll-optional-front-matter, jekyll-paginate, jekyll-readme-index, jekyll-titles-from-headings, jekyll-relative-links. Other plugins are added through `plugins:` in `_config.yml`, and only whitelisted ones build: "GitHub Pages cannot build sites using unsupported plugins." — [GitHub Docs: About GitHub Pages and Jekyll](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll)
- Rouge is the default highlighter. Other highlighters (for example highlight.js) require disabling Rouge via `kramdown: syntax_highlighter_opts: disable: true`. — [GitHub Docs: About GitHub Pages and Jekyll](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll)
- GitHub Actions is the recommended way to deploy and automate Pages sites. The official `actions/jekyll-build-pages` action outputs to `./_site`. — [GitHub Docs](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll); [Using custom workflows](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages)

### Inferences
- Because jekyll-optional-front-matter, jekyll-titles-from-headings, jekyll-readme-index, and jekyll-relative-links are on by default, plain `.md` files without front matter still render as pages. That is probably how the user's repo works today.
- Most add-ons below are "paste a `<script>` into the layout" features. To inject them, the user needs a layout file they control: either override the theme's `_layouts/default.html`, or use the theme's include hooks such as `_includes/head-custom.html` (minima uses `custom-head.html`). Hook names differ by theme, so check the theme's README. This is general Jekyll knowledge and was not verified against a specific theme in this session.

### Gaps
- Whether GitHub will upgrade the built-in build to Jekyll 4.x. No source found. The versions page still shows 3.10.0.

---

## 1. Comments: giscus vs utterances vs Disqus

### Takeaway
giscus (GitHub Discussions-based, ad-free, open source) is the 2026 default pick for developer or tech-reader blogs. utterances (GitHub Issues-based) still works but has fewer features. Disqus is not recommended for new privacy-conscious sites, because its free plan shows ads and it describes itself as a marketing and data company. The trade-off: giscus and utterances need commenters to have a GitHub account, which may not suit a general Korean book-reading audience.

### Cited Findings
- giscus requirements: (1) the repo must be public, (2) the giscus GitHub app must be installed on the repo, and (3) Discussions must be enabled. — [giscus.app](https://giscus.app/)
- giscus snippet format: a `<script src="https://giscus.app/client.js">` tag with `data-repo`, `data-repo-id`, `data-category`, `data-category-id`, `data-mapping="pathname"`, `data-strict="0"`, `data-reactions-enabled="1"`, `data-emit-metadata="0"`, `data-input-position="bottom"`, `data-theme="preferred_color_scheme"`, `data-lang="en"`, `crossorigin="anonymous" async`. The configurator on giscus.app generates the IDs. — [giscus.app](https://giscus.app/)
- giscus mapping options: pathname, URL, `<title>`, `og:title`, a specific term, or a specific discussion number, plus a strict title-matching option. Themes include GitHub light and dark variants, `preferred_color_scheme` (the default), transparent dark, noborder, gruvbox, catppuccin, and custom. An optional lazy-loading setting adds `loading="lazy"` to the iframe. — [giscus.app](https://giscus.app/)
- giscus stores comments in GitHub Discussions, while utterances uses GitHub Issues. giscus adds reactions and nested replies, which utterances lacks. — [brennerm: Moving from utterances to giscus](https://brennerm.github.io/posts/from-utterances-to-giscus.html); [0andwild comments guide](https://0andwild.github.io/en/posts/251017_comments_guide)
- A June 2026 comparison calls giscus "the strongest zero-cost option when GitHub identity is acceptable": open source, ad-free, and it "does not collect data itself." It says utterances "is still viable in 2026, but mostly as the lowest-friction GitHub-native option." Disqus's free Basic plan is ad-supported, and its privacy policy describes Disqus as "a marketing and data company," which "alone disqualifies it for many privacy-sensitive blogs." The article does not recommend Disqus as a default for new projects. — [MerginIT, 2026-06-21](https://merginit.com/blog/21062026-free-commenting-platforms-comparison)
- When migrating from utterances to giscus, the key issue is keeping the page-to-discussion mapping intact. — [brennerm](https://brennerm.github.io/posts/from-utterances-to-giscus.html)

### Example snippet (fill values from the giscus.app configurator; use `data-lang="ko"` for Korean UI)
```html
<script src="https://giscus.app/client.js"
        data-repo="USERNAME/USERNAME.github.io"
        data-repo-id="R_xxxx"
        data-category="Comments"
        data-category-id="DIC_xxxx"
        data-mapping="pathname"
        data-strict="0"
        data-reactions-enabled="1"
        data-emit-metadata="0"
        data-input-position="bottom"
        data-theme="preferred_color_scheme"
        data-lang="ko"
        data-loading="lazy"
        crossorigin="anonymous"
        async>
</script>
```

### Inferences
- `data-lang="ko"` and `data-loading="lazy"` are the configurator's attribute names as I understand them. The fetched page confirmed that a language option and a lazy-loading option exist, but not the exact attribute spelling. The configurator output is authoritative.
- `data-theme="preferred_color_scheme"` makes giscus follow the OS dark mode automatically. That pairs well with a CSS-only dark mode (section 5).
- For a Korean audience without GitHub accounts, giscus and utterances limit who can comment. Disqus allows social logins but brings ads and tracking.

### Gaps
- No official 2026 maintenance-status statement was found for utterances or giscus, such as last release dates.
- No Korean-native comment widget (for example a Kakao- or Naver-login comment system) was researched.

---

## 2. Analytics: GA4, GoatCounter, Plausible, Umami, Cloudflare Web Analytics

### Takeaway
Universal Analytics is fully dead. Any `UA-` tracking ID is non-functional, and GA4 (`G-` measurement IDs) is the only Google option. For a personal reading-notes blog, the lightweight free choices are GoatCounter (free for reasonable public use, cookieless, one-line script) and Cloudflare Web Analytics (free, works without proxying through Cloudflare). GA4 is the most powerful and free, but uses cookies and is the most privacy-invasive. Plausible and Umami are good privacy-first tools, but they are either paid in the cloud or need self-hosting, which a static GitHub Pages site cannot provide by itself.

### Cited Findings
- Universal Analytics: standard UA properties stopped processing on July 1, 2023. UA 360 properties got a one-time extension to July 1, 2024. Starting July 1, 2024, all UA interface and API access ended and the data was deleted. — [Google Analytics Help: GA4 has replaced UA](https://support.google.com/analytics/answer/11583528); [Search Engine Land](https://searchengineland.com/reminder-google-universal-analytics-services-api-turn-off-439040)
- UA properties are identified by tracking codes starting with "UA-". — [Search Engine Land](https://searchengineland.com/reminder-google-universal-analytics-services-api-turn-off-439040)
- GoatCounter is "currently offered for free for reasonable public usage." Personal sites and small-to-medium businesses are fine, but "millions of pageviews/day" is not. It "doesn't track users with unique identifiers and doesn't need a GDPR notice," and identifies unique visits "without cookies or persistently storing any personal data." The snippet is:
  `<script data-goatcounter="https://yoursite.goatcounter.com/count" async src="//gc.zgo.at/count.js"></script>` — [goatcounter.com](https://www.goatcounter.com/)
- GoatCounter is open source and self-hostable, supports CSV export, and is described as "best for minimalists." — [goatcounter.com](https://www.goatcounter.com/); [2026 comparison roundup (dev.to)](https://dev.to/vikasprogrammer/6-best-google-analytics-alternatives-in-2026-i-checked-every-price-2i5m)
- Cloudflare Web Analytics has an explicit setup path for "Sites not proxied through Cloudflare": Dashboard, then Web Analytics, then Add a site, enter the hostname, copy the JS snippet from "Manage site," and add it "before the ending body tag." — [Cloudflare Docs: Get started](https://developers.cloudflare.com/web-analytics/get-started/)
- Vendor and blog comparisons describe Cloudflare Web Analytics as free and cookieless. One vendor review claims data retention of about 6 months. This is an unverified competitor claim. — [Swetrix: Cloudflare vs Plausible](https://swetrix.com/comparison/cloudflare-analytics/vs-plausible)
- Plausible has a free self-hosted Community Edition (AGPL-3.0). Its cloud plan is roughly $9/month with a 30-day trial. Umami is MIT-licensed, self-hostable for free, and also offered as a cloud service. — [OpenPanel: open-source analytics by license (2026)](https://openpanel.dev/articles/open-source-web-analytics); [dev.to: Umami vs Plausible vs Fathom 2026](https://dev.to/alanwest/google-analytics-alternatives-umami-vs-plausible-vs-fathom-in-2026-280i)

### GA4 snippet (standard gtag.js; replace G-XXXXXXX)
```html
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXX');
</script>
```
(This is the widely published standard gtag.js form, from general knowledge. It was not re-fetched from Google docs in this session.)

### Inferences
- Inject it in `<head>` (GA4 recommends this placement) or before `</body>` (Cloudflare). Put it in an include, and wrap it in `{% if jekyll.environment == "production" %}` so local `jekyll serve` visits are not counted. GitHub Pages builds with `JEKYLL_ENV=production`. This is general Jekyll knowledge.
- Practical ranking for this user: GoatCounter (simplest, free, privacy-friendly), Cloudflare Web Analytics (free, slightly more setup), GA4 (if they want Google ecosystem integration with Search Console), then Umami Cloud or Plausible (paid or self-hosted).
- Under Korea's PIPA, cookie-based GA4 may call for a privacy notice. Cookieless tools avoid this. I did not research Korean law specifically.

### Gaps
- Current free-tier limits for Umami Cloud were not verified against the vendor pricing page.
- Cloudflare Web Analytics retention, site limits, and the exact beacon snippet were not confirmed from Cloudflare docs. The snippet is only shown in the dashboard.

---

## 3. SEO: jekyll-seo-tag, jekyll-sitemap, jekyll-feed, OG/Twitter, Google Search Console, Naver Search Advisor, robots.txt

### Takeaway
Enable the three whitelisted plugins: jekyll-seo-tag adds title, description, canonical, OG, Twitter, and JSON-LD tags; jekyll-sitemap generates `/sitemap.xml`; jekyll-feed generates `/feed.xml`. Then register the site with Google Search Console and, for Korean readers, Naver Search Advisor. Verify ownership with an HTML meta tag in `<head>` or an uploaded HTML file, then submit both sitemap.xml and the RSS feed. jekyll-seo-tag's `webmaster_verifications` does not include Naver, so add the Naver meta tag manually.

### Cited Findings
- jekyll-seo-tag `_config.yml` keys: `title`, `tagline`, `description`, `url`, `author`, `twitter` (`card`, `username`), `facebook`, `logo`, `social` (`name`, `links`), `google_site_verification`, `webmaster_verifications` (google, bing, alexa, yandex, baidu, facebook; **no naver**), and `locale` (default `en_US`). Front matter `image` is the "URL to an image associated with the post." — [jekyll-seo-tag usage docs](https://github.com/jekyll/jekyll-seo-tag/blob/master/docs/usage.md)
- Plugin versions on GitHub Pages: jekyll-seo-tag 2.8.0, jekyll-sitemap 1.4.0, jekyll-feed 0.17.0. — [pages.github.com/versions](https://pages.github.com/versions/)
- New github.io blogs have few inbound links, so crawlers have little to find them through. Registering directly is advised. — [WikiDocs](https://wikidocs.net/366632)
- Naver Search Advisor ownership is commonly verified with an HTML meta tag, which must sit inside `<head>`. Sitemaps are submitted under "요청 > 사이트맵 제출" (usually `/sitemap.xml`). — [AMPM Insight](https://inside.ampm.co.kr/insight/58757); [Cafe24 support](https://support.cafe24.com/hc/ko/articles/8465600011929)
- RSS is submitted under "요청 > RSS 제출." Naver sometimes rejects feeds as "올바른 RSS가 아니다" ("not a valid RSS feed"), in which case check the feed address. — [extrememanual.net](https://extrememanual.net/5854)
- Indexing can take hours to 1-3 days, sometimes 7+ days. — [Cafe24 support](https://support.cafe24.com/hc/ko/articles/8465600011929); [adsensefarm](https://adsensefarm.kr/naver-searchadvisor-register/)
- One blog says sitemap submission relates to Naver "웹문서" (web documents) results and RSS to "블로그" (blog) results. This is a personal blog claim and unverified. — [extrememanual.net](https://extrememanual.net/5854)

### Example config
```yaml
# _config.yml
title: "책 읽기 노트"
description: "읽은 책에 대한 메모"
url: "https://USERNAME.github.io"
lang: ko
locale: ko_KR
author: USERNAME
plugins:
  - jekyll-seo-tag
  - jekyll-sitemap
  - jekyll-feed
google_site_verification: "GOOGLE_CODE"
```
```html
<!-- _includes/head-custom.html (or the theme's equivalent head hook) -->
{% seo %}
{% feed_meta %}
<meta name="naver-site-verification" content="NAVER_CODE" />
```
```text
# robots.txt (repo root)
User-agent: *
Allow: /
Sitemap: https://USERNAME.github.io/sitemap.xml
```

### Inferences
- `{% seo %}` and `{% feed_meta %}` go in `<head>`. Many themes (minima, and themes using jekyll-seo-tag) already include `{% seo %}`, so check before adding it twice. This is general knowledge; the fetched usage page did not cover placement.
- The Naver meta tag name `naver-site-verification` is what Naver issues, per general knowledge and Korean tutorials. Copy it from Search Advisor exactly.
- Alternative: Naver also offers HTML-file verification. Committing the `naver*.html` file to the repo root works on GitHub Pages, and so does the Google `google*.html` file.
- jekyll-feed only includes `_posts` items. A notes repo without `_posts/` gets an empty or near-empty feed, and Naver's RSS submission is only worthwhile if notes live in `_posts/YYYY-MM-DD-title.md`. jekyll-sitemap covers all pages regardless. This is general Jekyll knowledge.
- Social preview images: set front matter `image:` (or the site-wide `logo`) so jekyll-seo-tag emits `og:image` and Twitter card tags.

### Gaps
- The official Naver Search Advisor guide (searchadvisor.naver.com) could not be fetched; it blocks automated access. Naver's crawler name (Yeti) and any robots.txt specifics were not confirmed from Naver docs in this session.
- Google Search Console verification steps were not re-fetched. The HTML tag, HTML file, and DNS TXT methods are standard.

---

## 4. Site search: Lunr.js / Simple-Jekyll-Search / Pagefind / Algolia DocSearch

### Takeaway
Pagefind is the modern default for static sites: it runs after the build and indexes the output HTML. On GitHub Pages it requires a GitHub Actions workflow, because it runs a binary after Jekyll. Its Korean support is limited (UI translation yes, stemming no, unspaced segmentation unconfirmed). If the user wants to stay on the zero-config branch build, the client-side JSON approach (Simple-Jekyll-Search or Lunr.js) works without Actions. Algolia DocSearch targets documentation sites and needs an application.

### Cited Findings
- Pagefind with Jekyll: add `pagefind.yml` with `site: _site` and run `npx pagefind` after the Jekyll build in a GitHub Actions workflow. — [Zenn guide](https://zenn.dev/tenax66/articles/4f4c568ee2ad41)
- A `jekyll-pagefind` gem exists. Its docs say it fits the default Jekyll GitHub Actions workflow and needs the x86_64 musl Linux binary on Pages. — [gemdocs: jekyll-pagefind 0.2.1](https://gemdocs.org/gems/jekyll-pagefind/0.2.1/); [0.3.3](https://gemdocs.org/gems/jekyll-pagefind/0.3.3/)
- Pagefind language support: Korean (`ko`) has UI translations ✅ and stemming ❌, so "search results won't match across root words." Segmentation for unspaced text is documented for Chinese, Japanese, and Thai only. — [Pagefind multilingual docs](https://pagefind.app/docs/multilingual/)

### Inferences
- Korean is space-delimited but agglutinative. Without stemming, a search for "독서" may not match "독서를" or "독서는". Partial-prefix matching may mitigate this, but it is untested. Simple-Jekyll-Search, which does substring matching over a Liquid-generated `search.json`, may actually behave better for Korean particles. Recommend testing both.
- Simple-Jekyll-Search pattern (general knowledge): a `search.json` page built with Liquid `{% for post in site.posts %}` (or `site.pages`) plus a small JS library. No plugin is needed, so it works on the default branch build.
- Algolia DocSearch is free but intended for public technical documentation and needs an application. It is likely overkill for reading notes.

### Gaps
- The current status of Simple-Jekyll-Search and Lunr.js maintenance was not verified in this session.
- The current Algolia DocSearch eligibility rules were not fetched.

---

## 5. Dark mode, favicon, code highlighting, math, diagrams, TOC

### Takeaway
All of these are client-side additions that work on the default build. Rouge highlighting is built in. Math needs a MathJax or KaTeX script. Mermaid needs the Mermaid JS, because GitHub renders Mermaid only in its repository view, not on Pages. Dark mode can be pure CSS via `prefers-color-scheme`, with an optional JS toggle.

### Cited Findings
- Rouge is the default and only supported built-in highlighter. Disable it via kramdown options to use highlight.js or similar. — [GitHub Docs](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll)
- Rouge version on Pages is 3.30.0, and kramdown is 2.4.0. — [pages.github.com/versions](https://pages.github.com/versions/)
- giscus supports `preferred_color_scheme` so comments follow the OS theme. — [giscus.app](https://giscus.app/)

### Snippets (general knowledge, not re-verified against official docs this session)
```css
/* CSS-only dark mode */
:root { --bg:#fff; --fg:#222; }
@media (prefers-color-scheme: dark) {
  :root { --bg:#111; --fg:#ddd; }
}
body { background:var(--bg); color:var(--fg); }
```
```bash
# Generate a Rouge theme stylesheet locally
rougify style github > assets/css/syntax.css        # light
rougify style github.dark > assets/css/syntax-dark.css  # dark (theme names vary; `rougify help style` lists them)
```
```html
<!-- Math: kramdown outputs \( \) / \[ \] for $$...$$ ; load MathJax 3 -->
<script async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>

<!-- Mermaid: render ```mermaid fenced blocks -->
<script type="module">
  import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
  mermaid.initialize({ startOnLoad: true });
</script>
```
- TOC: kramdown's built-in `* TOC\n{:toc}` marker in Markdown generates a table of contents with no plugin. jekyll-toc is not on the GitHub Pages whitelist as far as I know; verify against versions.json.
- Favicon: realfavicongenerator.net produces the icon set plus the `<link rel="icon">` and `apple-touch-icon` tags. Drop the files in the repo root and the tags into the head include.

### Inferences
- Kramdown wraps Mermaid fences as `<pre><code class="language-mermaid">`, not `<div class="mermaid">`. A small JS shim converting those blocks, or a `{% raw %}<div class="mermaid">` block in Markdown, may be needed for Mermaid's `startOnLoad`. This is a common pitfall from general knowledge; test it.
- KaTeX is faster than MathJax, but its auto-render needs extra configuration for kramdown's `\(`/`\[` output. MathJax 3 handles that output directly.
- Mermaid major version (v11) and MathJax version (v3 vs v4) were not verified for Nov 2026. Check the CDN for the current major version.

### Gaps
- Official docs for MathJax, KaTeX, Mermaid, and realfavicongenerator were not fetched in this session (tool-call budget). The snippets above are from general knowledge and should be verified.

---

## 6. Custom domain: CNAME, DNS A/AAAA, verification, Enforce HTTPS

### Takeaway
For an apex domain, add four A records and optionally four AAAA records pointing to GitHub's IPs. For `www`, add a CNAME to `USERNAME.github.io`. Set the domain in Settings, then Pages. Verify the domain first to prevent takeover, then tick "Enforce HTTPS," which can take up to 24 hours to become available.

### Cited Findings
- Apex A records: `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`. AAAA records: `2606:50c0:8000::153`, `2606:50c0:8001::153`, `2606:50c0:8002::153`, `2606:50c0:8003::153`. GitHub advises keeping A records alongside AAAA because IPv6 adoption is slow. — [GitHub Docs: Managing a custom domain](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site)
- For `www` or another subdomain, use a CNAME to `<user>.github.io`, "without including the repository name," and not the `*.pages.github.io` subdomain. — [GitHub Docs](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site)
- With branch publishing, saving the custom domain commits a `CNAME` file to the root of the source branch. With a custom GitHub Actions workflow, "no `CNAME` file is created" and an existing one is ignored. — [GitHub Docs](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site)
- Enforce HTTPS: "It can take up to 24 hours before this option is available." — [GitHub Docs](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site)
- "We recommend verifying your custom domain prior to adding it to your repository" to prevent takeover. If the domain is unverified and Pages is disabled, update or remove the DNS records immediately. — [GitHub Docs](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site)

### Inferences
- After a domain change, update `url:` in `_config.yml`, then re-register or re-verify in Google Search Console and Naver Search Advisor, and resubmit the sitemap, since it uses absolute URLs. Cloudflare Web Analytics and GoatCounter site settings also need the new hostname.
- Domain verification is done under GitHub account Settings, then Pages, by adding a DNS TXT record `_github-pages-challenge-USERNAME`. This is general knowledge; the record name was not quoted on the fetched page.

### Gaps
- Korean registrar-specific DNS steps (Gabia, Cafe24, etc.) were not researched.

---

## 7. Image optimization and responsive images

### Takeaway
GitHub Pages does no image processing, and the whitelisted plugins include no image optimizer. Optimize before committing: convert to WebP or AVIF, resize to roughly the content width, and add `loading="lazy"` plus `width`/`height`. Plugins such as jekyll_picture_tag require a GitHub Actions build.

### Cited Findings
- No image-processing plugin appears in the GitHub Pages dependency list. — [pages.github.com/versions](https://pages.github.com/versions/)
- Unsupported plugins cannot build on the default Pages pipeline. — [GitHub Docs](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll)

### Snippets (general HTML knowledge)
```html
<picture>
  <source srcset="/assets/img/cover.avif" type="image/avif">
  <source srcset="/assets/img/cover.webp" type="image/webp">
  <img src="/assets/img/cover.jpg" alt="책 표지" width="600" height="900" loading="lazy" decoding="async">
</picture>
```
kramdown inline attribute form: `![책 표지](/assets/img/cover.webp){: loading="lazy" width="300"}`

### Inferences
- For a reading-notes site, book-cover images are the main asset. Resizing covers to about 600px wide WebP with tools like Squoosh or `cwebp`, plus lazy loading, covers most needs. GitHub's soft limits (1 GB recommended repo/site size, 100 MB per file) are general knowledge and were not re-verified this session.

### Gaps
- No 2026-specific source on jekyll_picture_tag maintenance or on GitHub Actions-based image pipelines was fetched.
- Current GitHub Pages size and bandwidth limits were not fetched this session.
