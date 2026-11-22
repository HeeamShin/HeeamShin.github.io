# GitHub Pages(username.github.io)용 기성 테마와 한글 타이포그래피 (2026년 11월 기준)

참고: 아래 GitHub 별 수, 마지막 push 날짜, 최신 릴리스는 2026-11-23에 `gh api`(GitHub REST API)로 직접 조회한 값이다. 링크는 각 저장소를 가리킨다.

## 1. Jekyll 테마 비교: 설치 방법, Actions 필요 여부, 관리 상태, 기능

### Takeaway
2026년 11월에도 활발히 관리되는 테마는 Chirpy, Minimal Mistakes, al-folio, Just the Docs다. Beautiful Jekyll은 커밋은 계속 들어오지만 정식 릴리스가 2023년에 멈췄다. TeXt는 릴리스가 2020년에 멈춘 사실상 유지보수 모드이고, Hydejack은 2024-09 이후 활동이 없다. 사용자의 저장소는 `docs/books/*.md` 형태의 문서 구조라서, 이 구조를 그대로 살리려면 Just the Docs가 가장 잘 맞는다. 블로그처럼 꾸미려면 Chirpy나 Minimal Mistakes가 맞지만, 글을 `_posts/YYYY-MM-DD-title.md` 형식으로 옮겨야 한다.

### Cited Findings

**관리 상태 스냅샷 (2026-11-23 조회)**

| 테마 | 별 | 최신 릴리스 | 기본 브랜치 마지막 커밋 | 비고 |
|---|---|---|---|---|
| al-folio | 16,371 | v1.2 (2026-08-09) | push 2026-11-16 | 템플릿 저장소, 학술/포트폴리오용 |
| Minimal Mistakes | 13,601 | 4.28.1 (2026-08-11) | 2026-10-09 "Fix #5538" | |
| Chirpy (jekyll-theme-chirpy) | 10,336 | v7.6.0 (2026-06-20) | 2026-09-06 "fix(pwa)..." | |
| chirpy-starter | 1,115 | (릴리스 없음) | push 2026-06-20 | 템플릿 저장소 (is_template=true) |
| Just the Docs | 9,244 | v0.12.0 (2026-01-23) | 2026-11-12 (의존성 bump) | |
| Beautiful Jekyll | 5,835 | 6.0.1 (2023-06-08) | 2026-10-15 "remove inactive sponsor" | 릴리스 정체, 커밋은 사소함 |
| TeXt | 3,341 | v2.2.6 (2020-02-02) | 2026-06-08 "Revert Sass @use changes for GitHub Pages compatibility" | 릴리스 6년 정체 |
| Hydejack | 1,641 | v9.2.1 (2024-09-14) | 2024-09-14 | 2년 넘게 활동 없음 |
| jekyll/minima (GitHub 기본) | (미조회) | (미조회) | 2026-04-07 | |
| pages-themes/minimal | 1,818 | v0.2.0 (2021-07-26) | push 2024-08-20 | GitHub 공식 지원 테마, 사실상 정체 |

출처: [Chirpy](https://github.com/cotes2020/jekyll-theme-chirpy), [chirpy-starter](https://github.com/cotes2020/chirpy-starter), [Minimal Mistakes](https://github.com/mmistakes/minimal-mistakes), [al-folio](https://github.com/alshedivat/al-folio), [Just the Docs](https://github.com/just-the-docs/just-the-docs), [Beautiful Jekyll](https://github.com/daattali/beautiful-jekyll), [TeXt](https://github.com/kitian616/jekyll-TeXt-theme), [Hydejack](https://github.com/hydecorp/hydejack), [minima](https://github.com/jekyll/minima), [pages-themes/minimal](https://github.com/pages-themes/minimal)

**GitHub Pages 기본 동작**
- GitHub Pages가 바로 지원하는 테마는 13개다: Architect, Cayman, Dinky, Hacker, Leap day, Merlot, Midnight, Minima, Minimal, Modernist, Slate, Tactile, Time machine. — [GitHub Docs](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/adding-a-theme-to-your-github-pages-site-using-jekyll)
- 그 밖의 테마는 `jekyll-remote-theme` 플러그인으로 불러온다. `_config.yml`에 `remote_theme: OWNER/REPO`를 쓰면 된다. — [GitHub Docs](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/adding-a-theme-to-your-github-pages-site-using-jekyll)
- GitHub는 "GitHub Actions is now the recommended approach for deploying and automating GitHub Pages sites"라고 밝힌다. — [GitHub Docs](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/adding-a-theme-to-your-github-pages-site-using-jekyll)

**Chirpy**
- 설치 방법은 두 가지다. (1) chirpy-starter 템플릿(권장): "This approach simplifies upgrades, isolates unnecessary files." (2) 테마 포크: 많이 고칠 사람용이며 "presents challenges during upgrades." — [Chirpy Getting Started](https://chirpy.cotes.page/posts/getting-started/)
- Chirpy gemspec은 `jekyll ~> 4.3`과 `jekyll-archives` 등을 런타임 의존성으로 요구한다. GitHub Pages 기본 빌드(github-pages gem)는 `"jekyll" => "3.10.0"`에 고정돼 있다. 따라서 Chirpy는 기본 브랜치 빌드로는 돌아가지 않고 Actions 빌드가 필요하다. — [Chirpy gemspec](https://github.com/cotes2020/jekyll-theme-chirpy/blob/master/jekyll-theme-chirpy.gemspec), [pages-gem dependencies.rb](https://github.com/github/pages-gem/blob/master/lib/github-pages/dependencies.rb)
- 배포에는 GitHub Actions를 쓴다. 저장소 Settings에서 Pages 소스를 "GitHub Actions"로 바꿔야 한다. 무료 플랜이면 저장소를 public으로 유지해야 한다. Linux가 아닌 환경에서 `Gemfile.lock`을 커밋했다면 platform 목록을 갱신해야 한다. — [Chirpy Getting Started](https://chirpy.cotes.page/posts/getting-started/)
- chirpy-starter에는 `.github/workflows/pages-deploy.yml`이 들어 있다. Gemfile은 `gem "jekyll-theme-chirpy", "~> 7.6"` 기반이라 gem 버전만 올리면 업데이트된다. — [chirpy-starter](https://github.com/cotes2020/chirpy-starter)
- 한국어 로케일 파일 `_data/locales/ko-KR.yml`이 있다(로케일 30여 개 중 하나). `_config.yml`의 `lang:`으로 지정하고, 기본값은 `lang: en`, `timezone: Asia/Shanghai`다. 한국 사용자는 `ko-KR`, `Asia/Seoul`로 바꾸면 된다. — [Chirpy 저장소 _data/locales](https://github.com/cotes2020/jekyll-theme-chirpy/tree/master/_data/locales)
- `_config.yml`이 보여주는 기능: 댓글 `comments.provider: [disqus | utterances | giscus]`, `toc: true`(포스트 오른쪽 TOC 칼럼), `theme_mode: [light | dark]`(비워 두면 시스템 설정을 따름), PWA와 오프라인 캐시(`pwa.enabled: true`), `paginate: 10`. — [Chirpy _config.yml](https://github.com/cotes2020/jekyll-theme-chirpy/blob/master/_config.yml)
- 헤더에서 Light, Dark, System 모드를 고를 수 있다. — [Chirpy Getting Started](https://chirpy.cotes.page/posts/getting-started/)
- `_includes`에 `search-loader.html`, `toc.html`, `trending-tags.html`, `related-posts.html`, `read-time.html`이 있어 검색, TOC, 태그, 관련 글, 읽기 시간을 기본으로 지원한다. — [Chirpy _includes](https://github.com/cotes2020/jekyll-theme-chirpy/tree/master/_includes)
- 커스텀 CSS를 넣으려면 `assets/css/jekyll-theme-chirpy.scss`를 사이트의 같은 경로로 복사하고 "add your custom styles at the end of the file". — [Chirpy Getting Started](https://chirpy.cotes.page/posts/getting-started/)
- `head.html` 마지막에 `{% include metadata-hook.html %}`가 있다. 원본 `metadata-hook.html`은 "A placeholder to allow defining custom metadata"라는 빈 파일이다. 사이트에 `_includes/metadata-hook.html`을 만들면 웹폰트 `<link>` 같은 태그를 `<head>`에 넣을 수 있다. — [Chirpy head.html](https://github.com/cotes2020/jekyll-theme-chirpy/blob/master/_includes/head.html)
- Minimal Mistakes에서 Chirpy로 옮긴 사용자는 Mermaid 기본 지원을 이유로 들었다("Native Mermaid support: was able to drop jekyll-spaceship dependency"). — [josecastillolema.github.io](https://josecastillolema.github.io/chirpy/)
- RubyGems 방식으로만 설치하면 "To fully use all the features of Chirpy, you need to copy the other critical files from the theme's gem". — [rubydoc jekyll-theme-chirpy](https://rubydoc.info/gems/jekyll-theme-chirpy)

**Minimal Mistakes**
- 설치 방법은 세 가지다. (1) gem 방식: `gem "minimal-mistakes-jekyll"`을 쓰고 `theme: minimal-mistakes-jekyll`로 지정하며, `bundle update`로 업데이트한다. (2) remote_theme: `remote_theme: "mmistakes/minimal-mistakes@4.28.1"`과 `github-pages`, `jekyll-include-cache` gem을 쓴다. 이 방식은 "100% compatible with GitHub Pages when used as a remote theme"이다. (3) 포크해서 USERNAME.github.io로 이름 바꾸기(`/docs`, `/test` 삭제 권장). — [MM Quick-Start Guide](https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/)
- v4.5.0부터 로컬라이제이션 데이터 파일이 gem에 포함됐다. `_data/ui-text.yml`에 `ko:`와 `ko-KR:` 항목이 있다. — [MM Quick-Start](https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/), [ui-text.yml](https://github.com/mmistakes/minimal-mistakes/blob/master/_data/ui-text.yml)
- 기능: 헤더 이미지, 커스텀 사이드바, TOC, 갤러리, 관련 글 등을 선택해서 쓸 수 있는 유연한 2단 레이아웃이다. — [MM README](https://github.com/mmistakes/minimal-mistakes)
- `<head>`에 태그를 넣는 지점은 `_includes/head/custom.html`이다. — [MM _includes/head](https://github.com/mmistakes/minimal-mistakes/tree/master/_includes/head)

**Just the Docs**
- 설치: "Just the Docs Template"(GitHub의 "use the template")이 가장 간단한 방법이고, 템플릿은 `just-the-docs` gem을 쓴다. 템플릿으로 만든 사이트는 GitHub Pages/Actions 워크플로로 배포한다. 포크나 클론은 기여용일 때만 필요하다. — [just-the-docs.com](https://just-the-docs.com/)
- 중첩 페이지 내비게이션(부모, 자식, 조부모), 순서 지정, 브레드크럼, 컬렉션, 내장 검색을 지원한다. — [just-the-docs.com](https://just-the-docs.com/)
- `color_scheme: dark`로 다크 테마를 켤 수 있다. 기본값은 light다. — [JtD Customization](https://just-the-docs.com/docs/customization/)
- `_includes/head_custom.html`에 넣은 HTML은 "will be inserted before the closing `<head>` tag". 스타일 오버라이드는 `_sass/custom/custom.scss`에 넣으면 테마 업데이트가 그대로 반영된다. — [JtD Customization](https://just-the-docs.com/docs/customization/)
- 검색 placeholder 문구를 현지화하려면 `_includes/search_placeholder_custom.html`을 쓴다. — [JtD Customization](https://just-the-docs.com/docs/customization/)

**Beautiful Jekyll / TeXt / Hydejack / al-folio**
- Beautiful Jekyll의 마지막 정식 릴리스는 6.0.1(2023-06-08)이다. 2026-10의 최근 커밋은 "remove inactive sponsor"로 기능 개발과 무관하다. — [Beautiful Jekyll](https://github.com/daattali/beautiful-jekyll)
- TeXt의 마지막 릴리스는 v2.2.6(2020-02-02)이다. 2026-06 커밋은 "Revert Sass @use changes for GitHub Pages compatibility"로, GitHub Pages 빌드와의 호환성을 유지하는 수준이다. — [TeXt](https://github.com/kitian616/jekyll-TeXt-theme)
- Hydejack은 v9.2.1(2024-09-14) 이후 커밋이 없다. — [Hydejack](https://github.com/hydecorp/hydejack)
- al-folio는 별이 가장 많고(16,371) 2026-11에도 push가 있다. 템플릿 저장소 형태로 제공된다. — [al-folio](https://github.com/alshedivat/al-folio)

### Inferences
- Chirpy는 Jekyll 4가 필요해 Actions 배포가 사실상 필수다(위 gemspec 근거). 반면 Minimal Mistakes는 공식 문서가 "100% compatible with GitHub Pages when used as a remote theme"이라고 하므로 Actions 없이 브랜치 배포("Deploy from a branch")로도 동작할 것으로 추론된다. 문서가 Actions를 명시적으로 언급하지는 않는다. 그렇다면 설정 부담은 MM(remote_theme)이 가장 적다.
- 사용자의 콘텐츠는 날짜 없는 `docs/books/*.md` 노트다. Chirpy와 MM은 블로그형이라 `_posts/YYYY-MM-DD-*.md`로 옮기고 front matter(title, date, categories, tags)를 추가해야 제 기능(카테고리/태그 아카이브, 최신 글)이 나온다. MM은 pages/collections도 지원하므로 `docs/books`를 컬렉션으로 둘 수도 있다. Just the Docs는 현재 폴더 구조와 개념이 가장 비슷해(책별 페이지, 부모/자식 내비게이션) 마이그레이션 비용이 가장 낮다.
- al-folio는 학술 포트폴리오(논문, CV 중심)용이다. TeXt와 Hydejack은 관리가 정체돼 있어 새로 시작하는 블로그에는 권하기 어렵다. Beautiful Jekyll은 단순하고 쉽지만 릴리스가 3년 넘게 멈춰 있다는 점을 표시해야 한다.

### Gaps
- Just the Docs README에는 `remote_theme` 언급이 없다(gh api로 README grep 결과). remote_theme 지원 여부는 확인하지 못했다. 4절의 "Just the Docs remote_theme" 추론은 검증되지 않았으며, 공식 경로는 템플릿과 gem, Actions 배포다.
- al-folio와 Just the Docs의 Actions 필수 여부를 공식 문서에서 문장으로 확인하지는 못했다. al-folio는 일반적으로 Actions 배포를 쓴다고 알려져 있으나 이번에는 검증하지 않았다.
- Just the Docs 내장 검색(lunr 기반)이 한글을 얼마나 잘 검색하는지(형태소, 부분 일치) 확인하지 못했다.
- Chirpy 검색(simple-jekyll-search 계열)의 한글 처리도 검증하지 못했다.
- jekyll/minima의 별 수와 릴리스 날짜는 조회하지 않았다.

## 2. 한국 개발자 블로그에서 많이 쓰는 테마와 그 이유

### Takeaway
이번 검색에서 찾은 GitHub Pages 블로그용 한국어 튜토리얼은 대부분 Chirpy였다. 다만 검색어가 Chirpy 중심이어서 상대 빈도를 측정했다고 볼 수 없고, Minimal Mistakes의 한국 점유율은 측정하지 못했다(정량 통계 없음). Chirpy는 기본 디자인이 세련되고 다크모드, 카테고리 트리, 태그, 검색, TOC가 내장돼 있으며 ko-KR 로케일도 있다. Minimal Mistakes는 ko 로케일이 있고 remote_theme으로 시작하기 쉽다.

### Cited Findings
- 한국어 검색 결과에 Chirpy 설치기와 커스터마이징 글이 다수 나온다: velog [coastby](https://velog.io/@coastby/Git-GitBlog-Chirpy-Jekyll-Theme-적용하기), [velog lzlko(오류 모음)](https://velog.io/@lzlko/github-블로그), [momo1108.github.io](https://momo1108.github.io/posts/github-%EB%B8%94%EB%A1%9C%EA%B7%B8-%EB%A7%8C%EB%93%A4%EA%B8%B0-4), [woon7.github.io 커스터마이징](https://woon7.github.io/posts/jekyll-theme-chirpy-customizing), [woon7 Windows](https://woon7.github.io/posts/jekyll-theme-chirpy-windows), [beomine.github.io (Windows)](https://beomine.github.io/posts/Github-blog-theme-적용-(chirpy)-for-window), [daeheeseol.github.io (2025-01 기준)](https://daeheeseol.github.io/posts/github-blog-1), [mjkmain.github.io](https://mjkmain.github.io/posts/chirpy-blog), [euansterling.github.io](https://euansterling.github.io/posts/github-pages-with-jekyll)
- coastby의 velog 글은 두 방식을 이렇게 요약한다. "Chirpy starter: 업그레이드하기 쉬우며, 관련 없는 프로젝트 파일과 분리하여 작성에 집중할 수 있다. Fork: 커스텀에 편리하나 업그레이드하기 어렵다." — [velog coastby](https://velog.io/@coastby/Git-GitBlog-Chirpy-Jekyll-Theme-적용하기)
- Windows에서는 `bash tools/init.sh`를 쓸 수 없어 수동으로 작업해야 한다는 후기가 있다(구버전 fork 방식 기준). — [beomine.github.io](https://beomine.github.io/posts/Github-blog-theme-적용-(chirpy)-for-window)
- 한국어 글들의 기준 버전은 6.3.1부터 v7.x까지 제각각이다. 오래된 튜토리얼을 따라 하면 현재 절차(v7.6, starter+Actions)와 어긋날 수 있다. — [daeheeseol.github.io](https://daeheeseol.github.io/posts/github-blog-1), [velog lzlko](https://velog.io/@lzlko/github-블로그)
- Chirpy에는 공식 ko-KR 로케일이 있다. — [Chirpy locales](https://github.com/cotes2020/jekyll-theme-chirpy/tree/master/_data/locales)
- Minimal Mistakes에는 ko, ko-KR UI 텍스트가 있다. — [MM ui-text.yml](https://github.com/mmistakes/minimal-mistakes/blob/master/_data/ui-text.yml)

### Inferences
- 튜토리얼이 많다는 것은 "막혔을 때 한국어로 답을 찾기 쉽다"는 실질적인 장점이다. 다만 대부분 v6 이하, fork 방식 기준이라 공식 Getting Started를 우선해야 한다.
- 사용자 네트워크(국내 개발자) 안에서는 Chirpy 블로그가 흔해서 "어디서 본 듯한" 인상을 줄 수 있다. 차별화하려면 폰트와 색 커스터마이징이 효과적이다.

### Gaps
- "한국 github.io 블로그 중 X% 가 Chirpy"와 같은 정량 통계는 찾지 못했다. 인기는 검색 결과의 튜토리얼 빈도에 근거한 정성적 판단이다.
- tistory와 velog의 2026년 최신 글은 확인하지 못했다. 검색에서 velog 2025~2026년 Chirpy 글은 확인되지 않았다.

## 3. 한글 타이포그래피: 웹폰트(Pretendard, Noto Sans KR, Spoqa Han Sans Neo)와 주입 방법, 줄바꿈 팁

### Takeaway
한국어 블로그에서 사실상의 표준 웹폰트는 Pretendard다(SIL OFL, jsDelivr CDN, 동적 서브셋 제공). 테마의 head 주입 지점(Chirpy `_includes/metadata-hook.html`, MM `_includes/head/custom.html`, Just the Docs `_includes/head_custom.html`)에 `<link>`를 넣고 커스텀 SCSS에서 `font-family`를 덮어쓰면 된다. 본문에는 `word-break: keep-all; overflow-wrap: break-word;`를 기본으로 적용한다.

### Cited Findings

**Pretendard** (별 3,664개, 최신 릴리스 v1.3.9 2023-11-05, 저장소 push 2026-07-23) — [Pretendard GitHub](https://github.com/orioncactus/pretendard)
- 권장 CDN은 jsDelivr다. 가장 가볍게 쓰려면 가변(variable) 동적 서브셋을 쓴다:
  ```html
  <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable-dynamic-subset.min.css" />
  ```
  이 경우 font-family는 `"Pretendard Variable"`이다. 정적 동적 서브셋은 `.../dist/web/static/pretendard-dynamic-subset.min.css`이고 font-family는 `Pretendard`다. cdnjs와 UNPKG도 쓸 수 있다. — [Pretendard README](https://github.com/orioncactus/pretendard)
- 어느 플랫폼에서나 같은 모양으로 보이게 하는 권장 스택:
  ```css
  font-family: "Pretendard Variable", Pretendard, -apple-system, BlinkMacSystemFont, system-ui, Roboto, "Helvetica Neue", "Segoe UI", "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", sans-serif;
  ```
  — [Pretendard README](https://github.com/orioncactus/pretendard)
- 라이선스는 SIL Open Font License다. 상업적 사용, 수정, 재배포가 가능하고 폰트 자체를 단독 판매하는 것만 금지된다. — [Pretendard README](https://github.com/orioncactus/pretendard)

**Spoqa Han Sans Neo** (별 412개, 최신 릴리스 v3.3.0 2021-06-07, 마지막 push 2022-06-15. 2022년 이후 업데이트 없음) — [spoqa-han-sans](https://github.com/spoqa/spoqa-han-sans)
- `<link href='//spoqa.github.io/spoqa-han-sans/css/SpoqaHanSansNeo.css' rel='stylesheet' type='text/css'>` 또는 `@import url(//spoqa.github.io/spoqa-han-sans/css/SpoqaHanSansNeo.css);`로 불러온다. SIL OFL이라 상업적 사용도 무료다. — [spoqa-han-sans README](https://github.com/spoqa/spoqa-han-sans)

**Noto Sans KR**
- Pretendard 권장 스택에서도 `"Noto Sans KR"`을 대체 폰트로 쓴다. — [Pretendard README](https://github.com/orioncactus/pretendard)

**테마별 주입 지점** (위 1절 출처 참조)
- Chirpy: `_includes/metadata-hook.html`에 `<link>`를 넣는다(head.html이 마지막에 include함). CSS는 `assets/css/jekyll-theme-chirpy.scss` 끝에 추가한다. — [Chirpy head.html](https://github.com/cotes2020/jekyll-theme-chirpy/blob/master/_includes/head.html), [Chirpy Getting Started](https://chirpy.cotes.page/posts/getting-started/)
- Minimal Mistakes: `_includes/head/custom.html`. — [MM _includes/head](https://github.com/mmistakes/minimal-mistakes/tree/master/_includes/head)
- Just the Docs: `_includes/head_custom.html`, `_sass/custom/custom.scss`. — [JtD Customization](https://just-the-docs.com/docs/customization/)
- Chirpy의 head.html은 원래 `site.data.origin[type].webfonts`(기본 웹폰트 CSS)를 로드한다. 따라서 Pretendard를 추가하려면 `font-family`도 덮어써야 한다. — [Chirpy head.html](https://github.com/cotes2020/jekyll-theme-chirpy/blob/master/_includes/head.html)

**한글 줄바꿈과 가독성 CSS**
- 기본 규칙:
  ```css
  body { word-break: keep-all; overflow-wrap: break-word; }
  ```
  `keep-all`은 어절을 유지한다. `overflow-wrap: break-word`는 긴 URL이나 단어가 넘칠 때만 쪼개는 안전장치다. — [daleseo.com](https://daleseo.com/css-text-wrap/)
- 제목, 캡션, 인용에는 `text-wrap: balance`를, 본문 `p, li`에는 `text-wrap: pretty`를 쓴다. `balance`는 `keep-all` 없이 쓰면 한국어에서 효과가 미미하다. — [daleseo.com](https://daleseo.com/css-text-wrap/)
- 브라우저 지원: `word-break: keep-all`은 2015년부터 지원돼 안전하다. `text-wrap`은 2024년 3월 Baseline에 들어갔다. `balance`는 Chromium에서 6줄, Firefox에서 10줄까지만 적용된다. 지원하지 않는 값은 무시되므로 점진적 향상으로 쓰면 된다. — [daleseo.com](https://daleseo.com/css-text-wrap/)
- `keep-all`은 CJK 텍스트에만 영향을 주고, 비CJK 텍스트에서는 `normal`처럼 동작한다. — [MDN word-break](https://developer.mozilla.org/docs/Web/CSS/Reference/Properties/word-break)
- 크롬 개발자 블로그에도 CSS 국제화 기능(한국어판) 소개가 있다. — [Chrome for Developers](https://developer.chrome.com/blog/css-i18n-features?hl=ko)

### Inferences
- 제안 스니펫 예시(Chirpy 기준): `_includes/metadata-hook.html`에 Pretendard variable dynamic-subset `<link>`를 넣는다. `assets/css/jekyll-theme-chirpy.scss` 끝에는 `body { font-family: "Pretendard Variable", Pretendard, ...; word-break: keep-all; overflow-wrap: break-word; }`를 둔다. 동적 서브셋은 실제 페이지에 쓰인 글자 범위만 받으므로 전체 한글 폰트를 받을 때보다 초기 로딩이 가볍다(Pretendard README의 동적 서브셋 제공 취지에서 추정).
- Spoqa Han Sans Neo는 2022년 이후 업데이트가 없어 "관리 정체"로 표시하는 것이 적절하다. Pretendard도 최신 릴리스는 2023-11이지만 저장소 활동은 2026-07까지 이어지고, 폰트는 완성된 상태로 보는 것이 맞다.

### Gaps
- 한글 본문의 권장 `line-height`(흔히 1.6~1.8로 알려짐)를 뒷받침하는 신뢰할 만한 출처는 이번 조사에서 찾지 못했다. 값을 제시하려면 경험칙임을 밝혀야 한다.
- Noto Sans KR의 Google Fonts 공식 임베드 스니펫은 직접 확인하지 않았다(일반적으로 `https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap` 형식이지만 미검증).
- Google Fonts가 한글을 자동 슬라이싱(unicode-range 분할)하는지는 이번 조사에서 확인하지 않았다.

## 4. 테마를 둘러볼 곳과 주의할 점 (fork vs template, 이후 업데이트)

### Takeaway
테마 목록은 jamstackthemes.dev(Jekyll 328개), GitHub 토픽 `jekyll-themes`(공개 저장소 467개), jekyllthemes.io에서 볼 수 있다. 가장 중요한 함정은 업데이트다. fork해서 테마 파일을 통째로 들고 오면 나중에 업스트림 업데이트를 받기 어렵다. starter/템플릿, gem, remote_theme 방식은 테마 코드와 내 콘텐츠를 분리해 버전만 올리면 된다.

### Cited Findings
- jamstackthemes.dev의 Jekyll 섹션에는 테마, 스타터, 템플릿이 328개 있다(전체 840개). — [jamstackthemes.dev/ssg/jekyll](https://jamstackthemes.dev/ssg/jekyll)
- GitHub `jekyll-themes` 토픽에는 공개 저장소 467개가 있다. `jekyll-theme` 토픽은 테마가 아닌 개인 사이트가 많이 섞여 있어 탐색 효율이 낮다. — [GitHub topic jekyll-themes](https://github.com/topics/jekyll-themes)
- jekyllthemes.io는 포트폴리오와 블로그 등 인기 테마를 큐레이션하는 사이트다. — [jekyllthemes.io/about](https://jekyllthemes.io/about)
- Chirpy 공식 문서: fork 방식은 "presents challenges during upgrades", starter 방식은 "simplifies upgrades". — [Chirpy Getting Started](https://chirpy.cotes.page/posts/getting-started/)
- Minimal Mistakes: gem/remote_theme 방식은 "easier installation and updating as you don't have to manage any of the theme files". remote_theme은 `@4.28.1`처럼 버전 태그를 고정할 수 있다. — [MM README](https://raw.githubusercontent.com/mmistakes/minimal-mistakes/master/README.md), [MM Quick-Start](https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/)
- Just the Docs: 템플릿과 gem 방식을 권장하고, 커스터마이징은 `_sass/custom/custom.scss`에 모으면 "upstream theme updates still apply". — [just-the-docs.com](https://just-the-docs.com/), [JtD Customization](https://just-the-docs.com/docs/customization/)
- chirpy-starter는 GitHub "template repository"(is_template=true)다. — [chirpy-starter](https://github.com/cotes2020/chirpy-starter)

### Inferences
- 사용자는 이미 콘텐츠가 있는 기존 저장소(username.github.io)를 갖고 있다. 템플릿으로 새 저장소를 만드는 것보다, 기존 저장소에 `_config.yml`, `Gemfile`, 워크플로 파일만 추가하는 방식(MM의 remote_theme, Just the Docs의 gem+Actions(remote_theme 지원은 미확인), Chirpy는 starter 파일 복사)이 기존 커밋 이력을 지키기 쉽다.
- fork 방식에는 업스트림 레포 기준의 PR 기본 대상 혼동이나 fork 표시 같은 부수적인 불편이 있을 수 있다. 다만 이번에는 공식 출처로 확인하지 않았다.
- 테마 파일을 오버라이드할 때(예: `_includes/head.html` 통째로 복사)는 업데이트 때 충돌하기 쉽다. 각 테마가 제공하는 "빈 훅" 파일(metadata-hook.html, head/custom.html, head_custom.html)만 쓰는 것이 업데이트에 안전하다.

### Gaps
- fork 저장소의 커밋이 GitHub 기여 그래프(잔디)에 반영되지 않는 조건은 GitHub Docs로 확인하지 않았다.
- jekyllthemes.io의 실제 목록과 인기 순위는 페이지를 가져오지 못해 확인하지 못했다.
- Hugo, Astro 등 Jekyll이 아닌 대안은 이번 범위에서 다루지 않았다.
