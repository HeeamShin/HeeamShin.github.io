---
name: pr-merge
description: 사용자가 "pr merge해", "PR 머지해", "머지해줘"처럼 PR 병합을 요청하면 사용. squash 커밋 메시지 작성, squash merge, 로컬 base 브랜치 최신화, 머지된 브랜치·worktree의 원격·로컬 정리를 한 번에 한다. "머지된 브랜치 정리해줘"처럼 정리만 요청해도 사용.
---

# PR squash merge

사용자가 PR 병합을 요청한 것 자체가 merge 승인이다. 다시 묻지 않는다.

1. **PR 고르기**: 번호를 말했으면 그 PR. 아니면 `gh pr list --json number,title,headRefName`로 열린 PR을 보고, 하나면 그것, 현재 브랜치의 PR이 있으면 그것. 여러 개라 애매할 때만 묻는다.
2. **한 번만 조회**: `gh pr view <N> --json title,body,commits,mergeable,statusCheckRollup,isDraft`
   - `mergeable`이 `CONFLICTING`이거나 실패한 체크가 있으면 merge하지 말고 이유를 알린다.
   - `isDraft`가 true면 `merge.sh`가 `gh pr ready`로 ready 전환한 뒤 병합한다 (병합 요청이 곧 승인이므로 따로 묻지 않는다).
   - PR 커밋에 머지 커밋이 있으면(`git rev-list --merges --count origin/<base>..<head>`) `merge.sh`가 경고하고 중단한다 (main 선형 유지). 초안 전환도 하지 않는다. 사용자에게 rebase 또는 새 브랜치 cherry-pick을 안내한다.
3. **메시지 작성**: 파일 하나에 쓴다 (`$CLAUDE_JOB_DIR/tmp/` 또는 `${TMPDIR:-/tmp}/`의 `pr-<N>-msg.txt`).
   - 1행 제목: 저장소의 기존 커밋 언어로 변경 요지를 짧게, 끝에 ` (#<N>)`.
   - 2행 빈 줄, 3행부터 본문: 커밋 목록을 그대로 나열하지 말고 주제별로 묶은 bullet. 확인한 것(테스트 등)이 PR 본문에 있으면 한 줄.
   - 커밋 attribution 규칙이 있으면 마지막 줄에 붙인다.
4. **worktree 밖으로**: 지금 세션이 `.claude/worktrees/` 아래 worktree 안에 있으면 먼저 `ExitWorktree`(action: `keep`)로 메인 체크아웃으로 나온다. 스크립트는 실행 위치의 worktree를 지우지 않기 때문이다.
5. **실행**: `bash "$(git rev-parse --show-toplevel)/.claude/skills/pr-merge/merge.sh" <N> <메시지파일>`
   - merge → 로컬 base 브랜치 fast-forward → 머지된 PR의 원격 브랜치 삭제 → `.claude/worktrees/`의 머지된 worktree 삭제(잠금 해제 포함) → 머지된 로컬 브랜치 삭제.
   - 이번 PR뿐 아니라 이전에 머지되고 남은 브랜치·worktree도 함께 정리한다. 커밋하지 않은 변경·추적하지 않은 파일이 있거나 PR에 없는 커밋이 있으면 남긴다. 아직 커밋이 없는 새 세션 worktree도 건드리지 않는다.
   - 이미 머지된 PR이면(또는 정리만 요청받으면 가장 최근 머지된 PR로) `merge.sh --cleanup <N>`으로 정리만 한다.
6. **보고**: 스크립트 출력의 ✓/! 줄을 요약해 몇 줄로. `!` 줄이 있으면 무엇을 해야 하는지 함께.
