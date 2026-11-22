# 어느 Technical Writer의 일기장

좋은 글을 적기 위해서는 많이 적어봐야 된다는 격언을 실천하기 위해 운영하는 repository입니다.

👉 **[블로그 바로가기: heeamshin.github.io](https://heeamshin.github.io/)**

[docs 폴더](./docs/) 이하의 markdown(`.md`) 파일을 클릭하시면 작성 글들을 열람하실 수 있습니다.

## 브랜치·PR 운영 방식

GitHub Pages는 `main` 브랜치의 루트(`/`)를 그대로 빌드합니다. 그래서 **`main`에 들어간 내용이 곧 블로그에 공개되는 내용**입니다.

### main 브랜치 관리

- **main 히스토리는 선형으로 유지합니다.** PR은 squash merge만 쓰고, 머지 커밋은 만들지 않습니다.
- **main에 직접 커밋·푸시하지 않습니다.** GitHub 브랜치 보호 규칙은 쓰지 않으므로 이 문서의 규칙으로 main을 보호합니다. 글 하나를 고치더라도 브랜치를 따서 PR로 올립니다.
- force-push와 브랜치 삭제는 저장소 주인이 요청할 때만 합니다.

### Pull Request 처리

1. **브랜치 만들기**: 최신 `main`에서 작업 브랜치를 땁니다. 글 하나 또는 변경 주제 하나에 브랜치 하나를 씁니다.
2. **PR 열기**: 제목은 변경 요지를 짧게 적습니다. 본문에는 무엇을 왜 바꿨는지, 참고 링크(책·자료 등)를 적습니다.
3. **main 따라가기**: 작업 중에 `main`이 앞서 나가면 작업 브랜치에 `main`을 merge하지 않고 **rebase**합니다. rebase 뒤 force-push가 필요하면 force-push하지 말고, `main`에서 새 브랜치를 따 커밋을 cherry-pick해 새 PR로 올립니다.
4. **머지 전 확인**
   - 충돌(`CONFLICTING`)이 있거나 실패한 검사가 있으면 머지하지 않습니다.
   - PR 커밋에 머지 커밋이 섞여 있으면 머지하지 않고 rebase 또는 cherry-pick으로 정리합니다.
   - Draft PR은 Ready for review로 바꾼 뒤 머지합니다.
5. **squash merge**: 커밋 메시지 1행은 변경 요지에 ` (#PR번호)`를 붙이고, 본문은 커밋 목록을 그대로 나열하지 않고 주제별 bullet로 묶습니다.

   ```bash
   gh pr merge <PR번호> --squash --subject "<제목> (#<PR번호>)" --body-file <메시지파일>
   ```

### PR merge 후 처리

머지하면 GitHub Pages가 `main`을 다시 빌드해 몇 분 뒤 [블로그](https://heeamshin.github.io/)에 반영됩니다. 이후 아래 순서로 정리합니다.

1. **로컬 main 최신화**: 메인 체크아웃에서 `main`을 fast-forward합니다.

   ```bash
   git switch main
   git pull --ff-only
   ```

2. **원격 브랜치 삭제**: 저장소 설정에서 머지 후 자동 삭제를 쓰지 않으므로 직접 지웁니다.

   ```bash
   git push origin --delete <브랜치>
   git fetch --prune
   ```

3. **worktree·로컬 브랜치 삭제**: `.claude/worktrees/` 아래 worktree에서 작업했다면 worktree를 먼저 지운 뒤 로컬 브랜치를 지웁니다. squash merge라서 `git branch -d`는 "머지되지 않았다"고 거부하므로, PR이 머지된 것을 확인한 뒤 `-D`를 씁니다.

   ```bash
   git worktree remove .claude/worktrees/<이름>
   git branch -D <브랜치>
   ```

   커밋하지 않은 변경이나 PR에 없는 커밋이 남아 있는 브랜치·worktree는 지우지 않고 남깁니다.

4. **반영 확인**: [블로그](https://heeamshin.github.io/)에서 새 글이나 수정한 내용이 보이는지 확인합니다.
