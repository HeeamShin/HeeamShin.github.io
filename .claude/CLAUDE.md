# 어느 Technical Writer의 일기장

GitHub Pages 사용자 사이트(https://heeamshin.github.io)의 저장소다. GitHub Pages가 main 브랜치 루트(`/`)를 내장 Jekyll(legacy 빌드, Jekyll 3.10)로 빌드한다. **main에 들어가는 순간 사이트에 배포된다.**

- 이 규칙 파일이 `.claude/` 안에 있는 이유: Jekyll은 front matter 없는 `.md`도 페이지로 게시하지만, 점으로 시작하는 폴더는 빌드에서 뺀다. 루트에 문서용 `.md`를 새로 두면 공개 페이지가 된다.
- 커밋 메시지·PR은 한국어로 짧게 쓴다.

## 브랜치·PR
- **main 히스토리는 선형으로 유지한다.** PR은 squash merge만 쓰고, 작업 브랜치에 main을 merge하지 않는다 (머지 커밋 금지).
- GitHub 브랜치 보호 규칙은 쓰지 않는다. **main 보호는 이 문서의 규칙으로 대신한다:** Claude는 main에 직접 커밋·푸시하지 않고, PR을 만들어 사용자가 머지를 요청할 때만 squash merge한다 (`pr-merge`). force-push·브랜치 삭제는 사용자가 요청할 때만.
- **새 작업은 항상 최신 `origin/main`에서 브랜치를 딴다.** 머지되지 않은 PR 브랜치 위에 다음 기능을 쌓지 않는다 (스택 PR 금지). 앞 PR의 변경이 필요하면 먼저 그 PR의 머지를 요청한다.
- 브랜치를 main 최신에 맞춰야 하면 rebase한다. force-push가 필요하면 하지 말고, main에서 새 브랜치를 따 cherry-pick해 새 PR로 올린다.
