#!/usr/bin/env bash
# PR을 squash merge하고, 로컬 base 브랜치를 최신화한 뒤, 머지된 브랜치·worktree를 원격·로컬에서 정리한다.
# 사용법: merge.sh <PR번호> <메시지파일>
#         merge.sh --cleanup <PR번호>   이미 머지된 PR이면 merge 없이 정리만 한다
#   메시지파일: 1행 = 커밋 제목, 2행 = 빈 줄, 3행부터 = 본문
# 저장소 안(어느 worktree든)에서 실행한다. 지금 서 있는 worktree는 지우지 않으므로 지울 worktree 밖에서 실행한다.
#
# 정리 대상 (커밋하지 않은 변경·추적하지 않은 파일이 있으면 남긴다)
#   - 머지된 PR의 head까지만 있는 브랜치: 원격 브랜치, 로컬 브랜치, 그 브랜치를 체크아웃한 .claude/worktrees/ 아래 worktree
#   - .claude/worktrees/ 아래 detached worktree 중 HEAD가 origin/<base>나 머지된 PR head에 이미 들어 있는 것
#   - 어디에도 체크아웃되지 않은 로컬 브랜치 중 origin/<base>에 이미 들어 있는 것
#   브랜치를 체크아웃했지만 아직 커밋이 없는 worktree(막 시작한 세션)는 건드리지 않는다.
set -euo pipefail

cleanup_only=false
if [ "${1:-}" = --cleanup ]; then cleanup_only=true; shift; fi
pr=${1:?PR 번호가 필요합니다}
if [ "$cleanup_only" = false ]; then
  msg=${2:?메시지 파일이 필요합니다}
  [ -s "$msg" ] || { echo "메시지 파일이 비어 있습니다: $msg" >&2; exit 1; }
fi

# 모든 git 명령은 메인 체크아웃에서 실행한다 — 실행 위치의 worktree가 지워져도 이어서 동작하도록
main=$(git worktree list --porcelain | awk 'NR==1{print substr($0,10)}')
here=$(git rev-parse --show-toplevel)
g() { git -C "$main" "$@"; }

IFS=$'\t' read -r state head head_oid base cross draft < <(
  gh pr view "$pr" --json state,headRefName,headRefOid,baseRefName,isCrossRepository,isDraft \
    -q '[.state, .headRefName, .headRefOid, .baseRefName, (.isCrossRepository|tostring), (.isDraft|tostring)] | @tsv')
if [ "$cleanup_only" = true ]; then
  [ "$state" = MERGED ] || { echo "PR #$pr 상태가 MERGED가 아닙니다: $state" >&2; exit 1; }
else
  [ "$state" = OPEN ] || { echo "PR #$pr 상태가 OPEN이 아닙니다: $state" >&2; exit 1; }
fi

# 1. squash merge
if [ "$cleanup_only" = false ]; then
  # main 선형 유지: PR에 머지 커밋이 있으면 병합하지 않고 중단한다 (초안 전환도 하지 않는다)
  g fetch --quiet origin "$base" "pull/$pr/head"
  merges=$(g rev-list --merges --count "origin/$base..$head_oid")
  if [ "$merges" -gt 0 ]; then
    echo "! PR #$pr 에 머지 커밋이 ${merges}개 있어 병합하지 않습니다 (main 선형 유지). 브랜치를 main에 rebase하거나, force-push 대신 새 브랜치에 cherry-pick해 새 PR로 올리세요." >&2
    exit 1
  fi
  # 초안이면 병합 요청 자체가 승인이므로 ready로 바꾼 뒤 병합한다
  if [ "$draft" = true ]; then
    gh pr ready "$pr"
    echo "✓ PR #$pr 초안 → ready"
  fi
  gh pr merge "$pr" --squash --subject "$(head -n 1 "$msg")" --body "$(tail -n +3 "$msg")"
  echo "✓ PR #$pr squash merge ($head → $base)"
fi

g fetch --quiet --prune origin
g fetch --quiet origin "pull/$pr/head" 2>/dev/null || true

# 이 저장소에서 머지된 PR의 "브랜치<TAB>head 커밋" 목록 (방금 머지한 PR 포함)
merged=$(gh pr list --state merged --limit 200 --json headRefName,headRefOid,isCrossRepository \
  -q '.[] | select(.isCrossRepository | not) | [.headRefName, .headRefOid] | @tsv')
[ "$cross" = true ] || merged=$(printf '%s\n%s\t%s' "$merged" "$head" "$head_oid")

# <브랜치> <커밋>: 그 이름으로 머지된 PR의 head까지만 있는가
is_merged_branch() {
  local oid
  for oid in $(printf '%s\n' "$merged" | awk -F'\t' -v b="$1" '$1==b{print $2}'); do
    [ "$2" = "$oid" ] && return 0
    g merge-base --is-ancestor "$2" "$oid" 2>/dev/null && return 0
  done
  return 1
}

# <커밋>: origin/<base>나 머지된 PR head에 이미 들어 있는가
is_merged_commit() {
  local oid
  g merge-base --is-ancestor "$1" "origin/$base" 2>/dev/null && return 0
  for oid in $(printf '%s\n' "$merged" | cut -f2); do
    [ "$1" = "$oid" ] && return 0
    g merge-base --is-ancestor "$1" "$oid" 2>/dev/null && return 0
  done
  return 1
}

# "경로<TAB>HEAD<TAB>브랜치" (detached면 브랜치가 빈 문자열)
worktrees() {
  g worktree list --porcelain | awk '
    /^worktree /{p=substr($0,10); h=""; b=""}
    /^HEAD /{h=$2}
    /^branch /{b=substr($2,12)}
    /^$/{if (p!="") print p"\t"h"\t"b; p=""}
    END{if (p!="") print p"\t"h"\t"b}'
}

# 브랜치를 체크아웃하고 있는 worktree 경로 (없으면 빈 문자열)
worktree_of() { worktrees | awk -F'\t' -v b="$1" '$3==b{print $1}'; }

# 2. 원격 브랜치 정리 — 머지된 PR의 head까지만 있는 것
while read -r name oid; do
  [ "$name" = HEAD ] || [ "$name" = "$base" ] && continue
  if is_merged_branch "$name" "$oid"; then
    if g push --quiet origin --delete "$name" 2>/dev/null; then
      echo "✓ 원격 브랜치 삭제: $name"
    elif [ -z "$(g ls-remote --heads origin "$name")" ]; then
      # 머지 직후 GitHub가 이미 지웠다 (fetch --prune 뒤에 지워지면 로컬 원격 추적 참조만 남는다)
      g update-ref -d "refs/remotes/origin/$name" 2>/dev/null || true
      echo "✓ 원격 브랜치는 이미 삭제됨: $name"
    else
      echo "! 원격 브랜치를 삭제하지 못했습니다: $name" >&2
    fi
  fi
done < <(g for-each-ref --format='%(refname:lstrip=3) %(objectname)' refs/remotes/origin)

# 3. 로컬 base 브랜치 최신화 (fast-forward만)
base_wt=$(worktree_of "$base")
if [ -n "$base_wt" ]; then
  if git -C "$base_wt" merge --quiet --ff-only "origin/$base"; then
    echo "✓ 로컬 $base 최신화: $(git -C "$base_wt" log --oneline -1)"
  else
    echo "! $base_wt 의 $base 를 fast-forward하지 못했습니다 (로컬 변경 또는 분기 확인)" >&2
  fi
elif g show-ref --verify --quiet "refs/heads/$base"; then
  if g fetch --quiet origin "$base:$base"; then
    echo "✓ 로컬 $base 최신화: $(g log --oneline -1 "$base")"
  else
    echo "! 로컬 $base 를 fast-forward하지 못했습니다" >&2
  fi
fi

# 4. worktree 정리
while IFS=$'\t' read -r wt wt_head branch; do
  if [ -n "$branch" ]; then
    [ "$branch" != "$base" ] && is_merged_branch "$branch" "$wt_head" || continue
  else
    is_merged_commit "$wt_head" || continue
  fi

  if [ -n "$(git -C "$wt" status --porcelain)" ]; then
    echo "! ${wt#"$main"/} 에 커밋하지 않은 변경이 있어 남겨 둡니다" >&2
  elif [ "$wt" = "$main" ]; then
    # 메인 체크아웃은 지우지 않고 base로 옮겨 브랜치만 지울 수 있게 한다
    if [ -n "$branch" ]; then
      if g show-ref --verify --quiet "refs/heads/$base" && [ -z "$(worktree_of "$base")" ]; then
        g switch --quiet "$base"
      else
        g switch --quiet --detach "origin/$base"
      fi
    fi
  elif [ "$wt" = "$here" ]; then
    echo "! 지금 실행 중인 worktree라 남겨 둡니다: ${wt#"$main"/} (밖에서 merge.sh --cleanup $pr)" >&2
  elif [ "${wt#"$main"/.claude/worktrees/}" = "$wt" ]; then
    # .claude/worktrees/ 밖은 직접 만든 worktree — 지우지 않고 브랜치만 놓게 한다
    [ -z "$branch" ] || git -C "$wt" switch --quiet --detach "origin/$base"
  else
    g worktree unlock "$wt" 2>/dev/null || true
    if g worktree remove "$wt"; then
      echo "✓ worktree 삭제: ${wt#"$main"/}"
    else
      echo "! worktree를 삭제하지 못했습니다: ${wt#"$main"/}" >&2
    fi
  fi
done < <(worktrees)
g worktree prune

# 5. 로컬 브랜치 정리 — 체크아웃되지 않았고, 머지된 PR의 head나 origin/<base>까지만 있는 것
while read -r branch oid; do
  [ "$branch" = "$base" ] && continue
  [ -z "$(worktree_of "$branch")" ] || continue
  if is_merged_branch "$branch" "$oid" || g merge-base --is-ancestor "$oid" "origin/$base"; then
    g branch -D --quiet "$branch"
    echo "✓ 로컬 브랜치 삭제: $branch"
  elif [ "$branch" = "$head" ]; then
    echo "! 로컬 $head 에 PR에 없는 커밋이 있어 남겨 둡니다" >&2
  fi
done < <(g for-each-ref --format='%(refname:lstrip=2) %(objectname)' refs/heads)
