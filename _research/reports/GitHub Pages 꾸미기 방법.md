# 설정 파일 하나로 일기장을 다듬기

GitHub Pages 사이트를 꾸미는 길은 사실상 세 갈래다. 첫째, **`_config.yml` 한 장과 몇 개의 오버라이드 파일만으로 내장 Jekyll 빌드를 그대로 쓰는 방법**이 있다. 테마, CSS, `<head>` 훅을 쓰며 Actions가 필요 없다. 둘째, **GitHub Actions로 빌드를 바꿔 Chirpy·Just the Docs 같은 본격 테마를 쓰는 방법**이 있다. 셋째, **Hugo·Astro·Zensical처럼 아예 다른 생성기로 옮기는 방법**이 있다. 내장 빌드는 2026년 11월에도 **Jekyll 3.10.0과 화이트리스트 플러그인 약 20개**에 묶여 있다 ([GitHub Pages 의존성 버전](https://pages.github.com/versions/)). 따라서 갈래를 고르는 기준은 "원하는 테마나 기능이 이 제약 안에 들어가는가"다. HeeamShin.github.io 저장소는 2026-11-23 확인 기준으로 `_config.yml` 없이 기본 테마(Primer)로 렌더링되고 있고, 글은 한 편(『(사용자를) 생각하게 하지 마!』 독서 노트)뿐이다. 그래서 지금 가장 효과가 큰 투자는 화려한 테마 이사가 아니라 첫째 갈래다. 홈페이지, 한글 타이포그래피, 사이트 정보를 갖추는 일이다. 실제로 README가 가리키는 `/docs/` 주소는 현재 **404를 반환한다**(2026-11-23 직접 확인). 방문자가 첫 화면에서 길을 잃는 구조라는 뜻이다. 아래에서는 웹에서 찾은 방법들을 비용 순으로 정리하고, 마지막에 이 저장소에 맞춘 Claude의 의견을 별도 섹션으로 제시한다.

## 설정 파일이 없어도 이미 Jekyll이 돌고 있다

`_config.yml`이 없어도 브랜치 기반 Pages 빌드는 Jekyll을 "github-pages" 모드로 실행한다. 이때 기본 테마는 **`jekyll-theme-primer`**이고 마크다운 엔진은 kramdown이다 ([pages-gem configuration.rb](https://github.com/github/pages-gem/blob/master/lib/github-pages/configuration.rb)). 끌 수 없는 기본 플러그인도 9개 있다. 이 중 **jekyll-optional-front-matter**는 front matter 없는 `.md`도 페이지로 만든다. **jekyll-titles-from-headings**는 첫 제목을 `page.title`로 쓴다. **jekyll-readme-index**는 다른 index가 없으면 README를 홈으로 쓴다. **jekyll-relative-links**는 `.md` 링크를 `.html`로 바꾼다 ([GitHub Docs: About GitHub Pages and Jekyll](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll)). 사용자의 글이 front matter 없이도 제목이 붙은 HTML 페이지로 나오는 이유가 이것이다. 다만 jekyll-relative-links 문서는 `.md` 링크만 다루고 이미지는 언급하지 않는다 ([jekyll-relative-links](https://github.com/benbalter/jekyll-relative-links)). 따라서 `../../images/...` 같은 이미지 경로는 **변환되지 않고 렌더링된 페이지의 URL 기준으로 해석된다**.

이 빌드의 한계도 분명하다. `safe` 모드로 돌기 때문에 화이트리스트에 없는 gem과 `_plugins/*.rb`는 쓸 수 없다. GitHub는 "unsupported plugins"로는 사이트를 빌드할 수 없다고 명시하고, 지금은 **GitHub Actions를 "recommended approach"로 안내한다** ([GitHub Docs](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll)). pages-gem 릴리스 이력에도 Jekyll 4로 올린다는 언급은 없다 ([pages-gem releases](https://github.com/github/pages-gem/releases)). Jekyll 4를 전제로 한 튜토리얼은 브랜치 빌드에서 그대로 통하지 않는다.

게시 소스 선택에는 이 저장소에만 해당하는 함정이 있다. 브랜치 사이트는 "선택한 폴더(root 또는 `/docs`)의 내용만" 서비스한다 ([GitHub Docs: Configuring a publishing source](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)). 소스를 `/docs`로 바꾸면 저장소 루트의 `/images/` 폴더는 사이트 밖이 되어 모든 이미지가 깨진다. 글 URL도 `/docs/books/...`에서 `/books/...`로 바뀐다. 지금 설정(main 브랜치, 루트 `/`)이 이 저장소에는 맞는 선택이다.

## 테마·CSS·head 훅만으로 바꿀 수 있는 것들

가장 싼 단계는 `_config.yml`에 테마를 지정하는 것이다. 공식 지원 테마는 Architect, Cayman, Dinky, Hacker, Leap day, Merlot, Midnight, Minima, Minimal, Modernist, Slate, Tactile, Time machine의 13종이다. `theme: jekyll-theme-minimal`처럼 한 줄이면 적용되고, 그 밖의 공개 테마는 `remote_theme: owner/repo`로 불러온다 ([GitHub Docs: Adding a theme](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/adding-a-theme-to-your-github-pages-site-using-jekyll)). 지원 테마는 2021년 v0.2.0 이후 사실상 정체 상태다 ([pages-themes/minimal](https://github.com/pages-themes/minimal)). 그래도 화이트리스트 안에서 확실히 돈다는 장점이 있다. 서드파티 테마 중에서는 Minimal Mistakes가 remote_theme로 쓸 때 **"100% compatible with GitHub Pages"**라고 밝히고 있어 Actions 없이 쓸 수 있는 대표 선택지다 ([MM Quick-Start Guide](https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/)).

테마를 고른 뒤에는 오버라이드 파일로 손을 댄다. 공식 방식은 `/assets/css/style.scss`에 빈 front matter와 `@import "{{ site.theme }}";`를 쓰고, 그 아래에 원하는 CSS를 덧붙이는 것이다. Sass 변수는 import 앞에서 바꾼다 ([GitHub Docs: Adding a theme](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/adding-a-theme-to-your-github-pages-site-using-jekyll)). 폰트나 파비콘처럼 `<head>`에 태그를 넣는 작업은 레이아웃을 통째로 복사하지 말고 테마가 마련한 빈 훅을 쓰는 편이 업데이트에 안전하다. pages-themes 계열은 `<head>` 끝에서 `{% include head-custom.html %}`를 호출하고 `{% seo %}`도 이미 넣어 두었다. Cayman과 Minimal 레이아웃에서 모두 확인된다 ([cayman default.html](https://github.com/pages-themes/cayman/blob/master/_layouts/default.html), [minimal default.html](https://github.com/pages-themes/minimal/blob/master/_layouts/default.html)). 훅 이름은 테마마다 다르다. Chirpy는 `_includes/metadata-hook.html`, Minimal Mistakes는 `_includes/head/custom.html`, Just the Docs는 `_includes/head_custom.html`이다 ([Chirpy head.html](https://github.com/cotes2020/jekyll-theme-chirpy/blob/master/_includes/head.html), [MM _includes/head](https://github.com/mmistakes/minimal-mistakes/tree/master/_includes/head), [JtD Customization](https://just-the-docs.com/docs/customization/)).

한글 사이트에서 체감 효과가 가장 큰 것은 타이포그래피다. Pretendard는 SIL OFL 라이선스로 jsDelivr CDN과 **동적 서브셋**을 제공한다. 동적 서브셋 CSS(`pretendardvariable-dynamic-subset.min.css`)를 불러오면 font-family는 `"Pretendard Variable"`이 된다. README에는 운영체제마다 대체 폰트를 지정한 권장 스택도 실려 있다 ([Pretendard](https://github.com/orioncactus/pretendard)). 대안인 Spoqa Han Sans Neo는 2022년 이후 업데이트가 없다 ([spoqa-han-sans](https://github.com/spoqa/spoqa-han-sans)). 줄바꿈은 `word-break: keep-all; overflow-wrap: break-word;`가 기본 처방이다. 어절 단위로 줄을 넘기고, 긴 URL만 예외적으로 쪼갠다 ([daleseo.com](https://daleseo.com/css-text-wrap/)). `keep-all`은 CJK 텍스트에만 영향을 주므로 영문 단어에는 부작용이 없다 ([MDN word-break](https://developer.mozilla.org/docs/Web/CSS/Reference/Properties/word-break)). 제목에 쓰는 `text-wrap: balance`는 2024년 Baseline에 들어간 점진적 향상 기능이다. 한국어에서는 `keep-all`과 함께 써야 효과가 난다 ([daleseo.com](https://daleseo.com/css-text-wrap/)).

홈페이지와 글 목록도 이 단계에서 해결된다. 루트에 `index.md`가 있으면 README 대신 그 파일이 홈이 된다 ([jekyll-readme-index](https://github.com/benbalter/jekyll-readme-index)). `index.md`에는 테마의 `home` → `page` → `default` 레이아웃이 순서대로 자동 적용된다 ([jekyll-default-layout](https://github.com/benbalter/jekyll-default-layout)). `docs/books/*.md`는 `_posts`가 아닌 일반 페이지다. 그래서 목록은 `site.pages`를 경로로 걸러 Liquid로 만든다.

## 댓글·분석·검색 등록은 스크립트 한 줄씩 붙는다

부가 기능은 대부분 "`<head>`나 본문 끝에 스크립트 붙이기"라서 내장 빌드에서도 동작한다. 댓글은 2026년 기준 **giscus**가 기본값에 가깝다. GitHub Discussions에 댓글을 저장하고 광고가 없으며, 비교 글은 이를 "GitHub identity가 괜찮다면 가장 강력한 무료 선택지"로 평가한다. 반면 Disqus 무료 플랜은 광고가 붙고, Disqus 스스로 "marketing and data company"라고 밝힌다 ([MerginIT 2026-06](https://merginit.com/blog/21062026-free-commenting-platforms-comparison)). giscus를 쓰려면 저장소가 public이어야 하고, giscus 앱을 설치하고 Discussions를 켜야 한다. `data-theme="preferred_color_scheme"`을 쓰면 OS의 다크 모드를 따른다 ([giscus.app](https://giscus.app/)). 대신 **댓글을 달려면 GitHub 계정이 필요하다**는 점이 일반 독자층에는 진입 장벽이다.

방문 분석에서 먼저 정리할 것이 있다. Universal Analytics는 2024년 7월에 완전히 종료됐고 `UA-` ID는 동작하지 않는다 ([Google Analytics Help](https://support.google.com/analytics/answer/11583528)). 개인 블로그에는 **GoatCounter**가 가볍다. 합리적인 공개 사용은 무료이고, 쿠키 없이 고유 방문을 세며, 스크립트 한 줄이면 된다 ([goatcounter.com](https://www.goatcounter.com/)). Cloudflare Web Analytics도 Cloudflare 프록시 없이 스니펫만으로 붙일 수 있다 ([Cloudflare Docs](https://developers.cloudflare.com/web-analytics/get-started/)).

검색 노출은 화이트리스트 플러그인 세 개가 기본이다. **jekyll-seo-tag**(title·description·canonical·OG·JSON-LD), **jekyll-sitemap**, **jekyll-feed**다. jekyll-seo-tag의 `webmaster_verifications`에는 google·bing 등만 있고 **naver는 없다** ([jekyll-seo-tag usage](https://github.com/jekyll/jekyll-seo-tag/blob/master/docs/usage.md)). Naver Search Advisor 인증 메타 태그는 head 훅에 직접 넣어야 한다. 인증 태그는 `<head>` 안에 있어야 하고, 인증 뒤에는 "요청 > 사이트맵 제출"로 sitemap.xml을 등록한다 ([AMPM Insight](https://inside.ampm.co.kr/insight/58757), [Cafe24 지원](https://support.cafe24.com/hc/ko/articles/8465600011929)). 새 github.io 사이트는 들어오는 링크가 적어 직접 등록을 권한다 ([WikiDocs](https://wikidocs.net/366632)). 사이트 내 검색 중 Pagefind는 빌드 후 바이너리를 돌려야 하므로 Actions가 필요하다. 한국어는 UI 번역만 지원하고 **어간 처리(stemming)는 지원하지 않는다** ([Pagefind multilingual](https://pagefind.app/docs/multilingual/)). 글이 한 편뿐인 지금은 검색 기능의 우선순위가 낮다.

커스텀 도메인을 붙이려면 apex 도메인에 A 레코드 4개(`185.199.108–111.153`)를 설정한다. Enforce HTTPS는 활성화까지 최대 24시간이 걸리고, 도메인 탈취를 막기 위해 먼저 도메인 인증을 하라고 권장한다 ([GitHub Docs: custom domain](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site)). 지금은 github.io 주소로 충분하므로 선택 사항이다.

## 본격 테마나 다른 생성기로 옮기면 Actions가 필수다

| 선택지 | 성격 | 배포 방식 | 2026-11 상태 | 이 저장소와의 궁합 |
|---|---|---|---|---|
| Just the Docs | 문서형(사이드바, 부모/자식 내비, 내장 검색) | 템플릿/gem + Actions (remote_theme 지원은 미확인) | v0.12.0 (2026-01), 활발 | `docs/books/` 구조와 가장 비슷 |
| Chirpy | 블로그형(다크 모드, TOC, 태그, ko-KR 로케일) | Actions 필수 (`jekyll ~> 4.3` 요구) | v7.6.0 (2026-06), 활발 | `_posts/YYYY-MM-DD-*.md`로 이전 필요 |
| Minimal Mistakes | 블로그형, 2단 레이아웃 | remote_theme로 브랜치 빌드 가능 | 4.28.1 (2026-08), 활발 | 컬렉션으로 `docs/books` 유지 가능 |
| Zensical / Material for MkDocs | 문서형(Python) | Actions | Material은 유지보수 모드, Zensical 0.1.0 | 이미지를 `docs/` 안으로 옮겨야 함 |
| Hugo + PaperMod / Astro | 블로그형 | Actions | Hugo 0.170, Astro 6 | front matter 추가와 폴더 이전 필요 |

표의 근거는 다음과 같다. Just the Docs는 템플릿 사용을 권장하고, 중첩 내비게이션과 내장 검색을 제공하며, `color_scheme: dark`로 다크 모드를 켠다 ([just-the-docs.com](https://just-the-docs.com/), [JtD Customization](https://just-the-docs.com/docs/customization/)). Chirpy는 gemspec에서 Jekyll 4.3을 요구한다. 그래서 Jekyll 3.10에 고정된 내장 빌드로는 돌아가지 않고, Pages 소스를 "GitHub Actions"로 바꿔야 한다 ([Chirpy gemspec](https://github.com/cotes2020/jekyll-theme-chirpy/blob/master/jekyll-theme-chirpy.gemspec), [Chirpy Getting Started](https://chirpy.cotes.page/posts/getting-started/)). 공식 문서는 fork 방식이 업그레이드를 어렵게 한다며 **chirpy-starter 방식을 권한다** ([Chirpy Getting Started](https://chirpy.cotes.page/posts/getting-started/)). 한국어 튜토리얼이 많다는 것은 장점이다. 다만 버전이 v6~v7로 제각각이라 오래된 글을 따라 하면 현재 절차와 어긋난다 ([daeheeseol.github.io](https://daeheeseol.github.io/posts/github-blog-1)). 같은 이유로 국내 개발자 블로그 사이에서는 "어디서 본 듯한" 인상을 주기 쉽다. 관리 상태도 확인해야 한다. 2026-11-23 GitHub API 조회 기준으로 TeXt는 2020년, Hydejack은 2024-09, Beautiful Jekyll은 2023년 이후 정식 릴리스가 없다 ([TeXt](https://github.com/kitian616/jekyll-TeXt-theme), [Hydejack](https://github.com/hydecorp/hydejack), [Beautiful Jekyll](https://github.com/daattali/beautiful-jekyll)).

Jekyll 밖으로 나가면 상황이 크게 다르다. Material for MkDocs는 2025-11-05에 **유지보수 모드**에 들어갔고, 후속작인 Rust 기반 Zensical이 기존 `mkdocs.yml`을 읽는다 ([Material 블로그](https://squidfunk.github.io/mkdocs-material/blog/2025/11/05/zensical/)). Material의 EOL은 2027-05-05로 연장됐다 ([Zensical Monthly 2026-08](https://mail.zensical.org/monthly/2026/08/)). Astro는 2026-01 Cloudflare에 인수됐지만 오픈소스로 유지된다 ([Cloudflare 보도자료](https://www.cloudflare.com/press/press-releases/2026/cloudflare-acquires-astro-to-accelerate-the-future-of-high-performance-web-development/)). Jekyll에서 Astro로 옮긴 한 국내 사례는 빌드 시간이 209초에서 30초로 줄었다고 보고한다 ([deku.posstree.com](https://deku.posstree.com/ko/astro/migration-reason/)). 하지만 이는 글이 많은 사이트의 이야기다. 글 한 편짜리 사이트에서 생성기를 바꾸는 비용을 정당화하는 근거로 보기는 어렵다.

## Claude의 추천안

> 이 섹션은 위의 출처 기반 조사 결과와 구분되는 **Claude의 개인 의견**이다. 저장소 상태는 2026-11-23 저장소와 GitHub API, 라이브 사이트로 확인했다. 아래 설정 예시는 **실제로 빌드해 보지 않은 제안**이다.

### 원칙: 꾸미기보다 읽히기

첫 글이 『Don't Make Me Think』이고 운영자가 Technical Writer라는 점이 방향을 정해 준다고 본다. 이 사이트는 그 책이 말하는 원칙을 스스로 실천하는 쇼케이스가 될 수 있다. 첫 화면에서 무엇을 하는 사이트인지 바로 보이고, 글 목록이 한눈에 들어오고, 한글 본문이 편하게 읽히는 것이 화려한 테마보다 먼저다. 지금 가장 큰 사용성 결함은 디자인이 아니라 **README의 "docs 폴더" 링크가 라이브 사이트에서 404가 나는 것**이다. GitHub Pages는 폴더 목록을 보여 주지 않기 때문에 방문자가 홈에서 글로 갈 길이 없다. 그래서 1단계의 최우선 과제는 진짜 홈페이지다.

### 1단계: 이사 없이 내장 빌드에서 끝내기 (반나절 분량)

테마는 공식 지원 테마인 **`jekyll-theme-minimal`**을 권한다. 왼쪽에 사이트 제목과 설명, 오른쪽에 본문을 두는 차분한 2단 구성이라 "일기장"의 성격에 맞는다고 본다. 이 테마의 레이아웃에는 `head-custom.html` 훅과 `{% seo %}`가 이미 들어 있다는 것도 확인했다. 네트워크 fetch가 없는 `theme:` 방식이라 빌드도 단순하다. 취향에 따라 Cayman도 같은 구조로 쓸 수 있다.

한 가지 저장소 고유의 함정이 있다. 루트에 있는 `research_notes/`와 `reports/` 폴더다. jekyll-optional-front-matter 때문에 이 폴더의 `.md`는 커밋하는 순간 **공개 웹페이지로 게시된다**. `exclude`에 꼭 넣어야 한다.

만들거나 고칠 파일은 다음과 같다.

| 파일 | 역할 |
|---|---|
| `_config.yml` | 제목·설명·언어·테마·플러그인·제외 폴더 |
| `index.md` | 진짜 홈: 소개 한 단락과 글 목록 |
| `_includes/head-custom.html` | Pretendard 폰트, (나중에) 파비콘·분석·네이버 인증 태그 |
| `assets/css/style.scss` | 테마 CSS를 불러온 뒤 한글 타이포 보정 |
| `README.md` | 저장소 소개용으로 유지하고, 링크를 `https://heeamshin.github.io/`로 변경 |
| `docs/books/dont-make-me-think-3rd.md` | 이미지 경로를 `../../images/...`에서 `/images/...`로 변경(아래 "조심할 점" 참고) |

```yaml
# _config.yml — Claude의 제안, 미검증
title: 어느 Technical Writer의 일기장
description: 좋은 글을 적기 위해서는 많이 적어봐야 된다
lang: ko
url: https://heeamshin.github.io
theme: jekyll-theme-minimal
plugins:
  - jekyll-seo-tag
  - jekyll-sitemap
exclude:
  - research_notes
  - reports
  - Gemfile
  - Gemfile.lock
defaults:
  - scope:
      path: docs/books
    values:
      category: book
```

```liquid
---
title: 어느 Technical Writer의 일기장
---
좋은 글을 적기 위해서는 많이 적어봐야 된다는 격언을 실천하는 공간입니다.

## 독서 노트
{% assign books = site.pages | where_exp: "p", "p.path contains 'docs/books/'" | sort: "title" %}
<ul>
{% for b in books %}
  <li><a href="{{ b.url | relative_url }}">{{ b.title }}</a></li>
{% endfor %}
</ul>
```

```html
<!-- _includes/head-custom.html — Claude의 제안, 미검증 -->
<link rel="stylesheet" as="style" crossorigin
      href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable-dynamic-subset.min.css" />
```

```scss
---
---
@import "{{ site.theme }}";

body {
  font-family: "Pretendard Variable", Pretendard, -apple-system, BlinkMacSystemFont, system-ui,
               "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", sans-serif;
  word-break: keep-all;
  overflow-wrap: break-word;
}
h1, h2, h3 { text-wrap: balance; }
```

이 설정은 미검증이므로 푸시 전에 로컬에서 확인해 보길 권한다. `gem "github-pages", group: :jekyll_plugins`와 `gem "webrick"`을 담은 Gemfile을 만들고 `bundle exec jekyll serve`를 실행하면 http://localhost:4000에서 미리 볼 수 있다 ([GitHub Docs: Testing locally](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/testing-your-github-pages-site-locally-with-jekyll)). 이 경우 `Gemfile`과 `Gemfile.lock`도 `exclude`에 추가한다. 푸시한 뒤 빌드가 실패하면 저장소의 Actions 탭에 있는 "pages build and deployment" 실행 기록에서 오류를 볼 수 있다.

목차에 대해서는 판단이 조금 다르다. 라이브 사이트에서 확인해 보니 **손으로 쓴 목차의 한글 앵커가 실제 heading id와 정확히 일치해 지금도 잘 동작한다.** 그래서 자동 목차로 바꾸는 것은 버그 수정이 아니라 유지보수 편의다. kramdown의 `* TOC` + `{:toc}` 마커를 쓰면 목차가 자동으로 생성된다. 다만 GitHub 저장소 화면에서는 이 마커가 그대로 보인다. 사이트를 주 독서 화면으로 정한 뒤에 바꾸기를 권한다. `jekyll-feed`는 1단계에서 뺐다. 내 이해로는 jekyll-feed가 `_posts`만 피드에 담기 때문에, `docs/books/` 구조에서는 피드가 비게 된다(미검증).

### 2단계: 독자와 연결하기

홈과 타이포가 자리 잡으면 기능을 붙인다. 붙이는 위치는 모두 head 훅이다. 분석은 쿠키가 없고 설정이 한 줄인 **GoatCounter**를 먼저 권한다. Search Console과 연동하는 등 Google 생태계가 필요하면 GA4를 쓴다. 검색 노출은 Google Search Console과 **Naver Search Advisor**에 모두 등록하는 것을 권한다. 한국어 독자를 생각하면 네이버 쪽이 오히려 중요할 수 있다. 네이버 인증 메타 태그는 jekyll-seo-tag가 지원하지 않으니 head 훅에 직접 넣는다. 댓글은 giscus가 깔끔하다. 다만 독서 노트의 독자가 개발자만은 아니라는 점에서 GitHub 계정 장벽을 감수할지 먼저 정하길 권한다. 파비콘과 CSS `prefers-color-scheme` 기반 다크 모드도 이 단계에서 추가하면 된다. Minimal 테마 자체에는 다크 모드가 없는 것으로 알고 있어 직접 CSS로 보완해야 한다(미검증).

### 3단계(선택): 글이 쌓이면 테마 이사

글이 열 편 정도 쌓여 사이드바나 카테고리, 검색이 실제로 필요해지면 그때 이사를 검토하길 권한다. 한 편짜리 사이트에서 이사는 이르다. 후보로는 **Just the Docs**를 Chirpy보다 앞에 두겠다. `docs/books/` 같은 카테고리 구조를 부모/자식 내비게이션으로 그대로 옮길 수 있다. "문서"를 다루는 Technical Writer의 정체성에도 어울린다. 공식 경로는 템플릿/gem + Actions다. 날짜순 블로그, 태그, 다크 모드 토글을 원하면 Chirpy가 맞다. 대신 Actions 전환, `_posts/YYYY-MM-DD-제목.md`로의 이전, front matter 추가, 퍼머링크 변경을 모두 감수해야 한다.

### 이 저장소에서 특히 조심할 점

첫째는 **상대 이미지 경로**다. `../../images/...`는 렌더링된 페이지 URL의 깊이에 따라 해석된다. 지금 `/docs/books/dont-make-me-think-3rd.html`에서는 `/images/...`로 정확히 풀린다. 하지만 `permalink: pretty`를 켜거나 테마가 URL을 `/docs/books/dont-make-me-think-3rd/`로 바꾸면 같은 경로가 `/docs/images/...`로 풀려 404가 난다. Chirpy의 `/posts/slug/`처럼 우연히 깊이가 맞는 경우도 있지만 그것은 운이다. 이미지 경로를 `/images/docs/books/...` 같은 **루트 절대 경로로 바꿔 두면** 테마나 URL 구조가 바뀌어도 안전하다. 이 사이트는 baseurl이 비어 있는 사용자 사이트라 루트 경로가 그대로 통한다. 다만 GitHub 저장소 화면의 미리보기에서도 이 경로가 잘 보이는지는 확인이 필요하다. 둘째, 게시 소스를 `/docs`로 바꾸지 말아야 한다. 루트의 `/images/`가 서비스되지 않게 된다. 셋째, 앞서 말한 `research_notes/`와 `reports/`의 `exclude` 설정이다. 이 설정은 **커밋 순서가 중요하다.** 두 폴더의 문서(이 보고서 포함)에는 코드 예시로 쓴 `{% include ... %}`, `{% feed_meta %}` 같은 Liquid 태그가 들어 있다. Jekyll은 페이지가 된 `.md`를 Liquid로 처리한다. 그래서 `exclude`가 없는 상태에서 이 폴더들을 커밋하면 노트가 공개되는 데서 끝나지 않는다. Primer에 없는 include를 찾다가 **사이트 빌드 전체가 실패할 가능성이 높다**(Claude의 추론, 미검증). `_config.yml`을 먼저 커밋하거나 같은 커밋에 넣고, 아니면 두 폴더를 아예 커밋하지 않는 것이 안전하다. 넷째, `{% seo %}`는 Minimal 레이아웃에 이미 들어 있으니 head 훅에 다시 넣지 않는다.

## 결론

조사를 마치고 나니 질문 자체가 조금 바뀌었다. 처음 질문은 "어떤 테마로 꾸밀까"였지만, 이 저장소에 실제로 필요한 것은 "방문자가 어디서 시작하는가"다. 홈 링크가 404인 상태에서는 어떤 테마를 입혀도 첫인상이 깨진다. 반대로 `index.md`와 `_config.yml`, 폰트 한 줄만 고쳐도 사용성 책을 다룬 첫 글과 사이트 자체가 같은 메시지를 내게 된다. 내장 Jekyll이 3.10에 고정된 것은 한계처럼 보인다. 하지만 지금 규모에서는 Actions나 Gemfile 없이 끝낼 수 있게 해 주는 단순함이기도 하다.

앞으로의 판단 기준은 글 수다. 글이 한 자릿수인 동안은 1~2단계로 충분하다. 내비게이션과 검색이 실제 불편으로 드러날 때 Just the Docs 같은 문서형 테마로 옮기면 된다. 그 이사를 싸게 만드는 준비는 지금 할 수 있다. 이미지 경로를 루트 기준으로 통일하고, 글마다 `title`과 `date` 정도의 front matter를 붙여 두는 것이다.
