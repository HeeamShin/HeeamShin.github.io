# 어느 Technical Writer의 일기장

GitHub Pages 사용자 사이트(https://heeamshin.github.io)의 저장소다. main에 푸시되면 GitHub Actions(`.github/workflows/hugo.yml`)가 Hugo로 빌드해 Pages에 배포한다. **main에 들어가는 순간 사이트에 배포된다.** PR에서는 빌드만 돌아 깨지는 변경을 잡는다.

- 사이트에 올라가는 것은 `hugo.toml`의 마운트뿐이다: `content/`(홈), `docs/`(글, `docs/README.md`는 `/docs/` 목록), `images/`, `assets/`(CSS). 루트 README.md, `_research/` 등은 게시되지 않는다.
- `docs/` 글은 GitHub 저장소 화면에서도 읽히도록 front matter 없이 쓰고, 제목은 첫 `#` 제목에서 가져온다. 글끼리는 `./books/글.md` 같은 상대 링크, 이미지는 `../../images/…` 상대 경로로 쓴다.
- 주소는 Jekyll 시절과 같은 `/docs/books/글.html`이다(`uglyURLs`). 바꾸면 이미지 상대 경로와 공유된 링크가 깨진다.
- 로컬 미리보기: `script/preview` (PR은 `script/preview <PR번호>`). Hugo 버전을 올리면 워크플로의 `HUGO_VERSION`도 맞춘다.
- Hugo·Bulma·Pretendard·Actions 버전은 Renovate(`.github/renovate.json5`)가 매주 월요일 업데이트 PR로 올린다. 버전 표기(`HUGO_VERSION: x.y.z`, `cdn.jsdelivr.net/npm/이름@버전/`)를 바꾸면 그 정규식도 고친다.
- 커밋 메시지·PR은 한국어로 짧게 쓴다.

## 브랜치·PR
- **main 히스토리는 선형으로 유지한다.** PR은 squash merge만 쓰고, 작업 브랜치에 main을 merge하지 않는다 (머지 커밋 금지).
- GitHub 브랜치 보호 규칙은 쓰지 않는다. **main 보호는 이 문서의 규칙으로 대신한다:** Claude는 main에 직접 커밋·푸시하지 않고, PR을 만들어 사용자가 머지를 요청할 때만 squash merge한다 (`pr-merge`). force-push·브랜치 삭제는 사용자가 요청할 때만.
- **새 작업은 항상 최신 `origin/main`에서 브랜치를 딴다.** 머지되지 않은 PR 브랜치 위에 다음 기능을 쌓지 않는다 (스택 PR 금지). 앞 PR의 변경이 필요하면 먼저 그 PR의 머지를 요청한다.
- 브랜치를 main 최신에 맞춰야 하면 rebase한다. force-push가 필요하면 하지 말고, main에서 새 브랜치를 따 cherry-pick해 새 PR로 올린다.
