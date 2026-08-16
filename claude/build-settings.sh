#!/usr/bin/env bash
# 生成 ~/.claude/settings.json = 共享部分（本 repo，入 git）+ 本机覆盖（不入 git）
#
#   shared  : <repo>/claude/settings.shared.json   机器无关，git 同步
#   machine : ~/.claude/settings.machine.json      机器专属，只在本机（hooks、statusLine、敏感 env）
#
# 合并是 jq 的 `*`（递归深合并），**machine 覆盖 shared**。
# 所以本机想改任何一项（permissions.defaultMode / statusLine / hooks …），
# 写进 machine 文件即可，不用动 shared。
#
# 每次 git pull 之后跑一遍。旧文件会存成 settings.json.bak。
#
# ⚠️ Claude Code 会自己往 settings.json 里写东西（装插件 → enabledPlugins /
# extraKnownMarketplaces；「don't ask again」→ permissions）。这些写入落在生成物上，
# 直接重建会把它们冲掉。所以重建前先比对，发现会丢的 key 就停下来，让你先归位。
# 确认要丢弃可以 `--force`。
set -euo pipefail

SHARED="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/settings.shared.json"
MACHINE="$HOME/.claude/settings.machine.json"
OUT="$HOME/.claude/settings.json"

[ -f "$SHARED" ] || { echo "缺少 $SHARED" >&2; exit 1; }
[ -f "$MACHINE" ] || echo '{}' > "$MACHINE"

# Claude Code 自己拥有、且会频繁改写的 key：不托管，重建时原样保留现有值。
# 放进 shared 只会让 `/model` 每切一次就触发下面的闸门，最后养成习惯性 --force。
UNMANAGED='["model"]'

FIRST_RUN=false
[ -f "$OUT" ] || { echo '{}' > "$OUT"; FIRST_RUN=true; }

MERGED=$(jq -s --argjson u "$UNMANAGED" \
  '(.[0] * .[1]) + (.[2] | with_entries(select(.key | IN($u[]))))' \
  "$SHARED" "$MACHINE" "$OUT")

if [ "$FIRST_RUN" = false ] && [ "${1:-}" != "--force" ]; then
  LOST=$(jq -rn --slurpfile live "$OUT" --argjson merged "$MERGED" \
    '$live[0] | to_entries | map(select(.value != $merged[.key]) | .key) | join(" ")')
  if [ -n "$LOST" ]; then
    echo "⛔ 现有 $OUT 里这些 key 与重建结果不符，直接重建会丢掉：" >&2
    for k in $LOST; do echo "     - $k" >&2; done
    echo >&2
    echo "   多半是 Claude Code 自己写的（装插件 / don't-ask-again）。先归位：" >&2
    echo "     共享的（插件、marketplace、通用 permissions）→ 折进 $SHARED" >&2
    echo "     本机的（hooks、statusLine、本机路径、敏感 env）→ 折进 $MACHINE" >&2
    echo >&2
    echo "   折进 shared 的现成命令（把 KEY 换成上面某一项）：" >&2
    echo "     jq -s '.[0] * {KEY: .[1].KEY}' $SHARED $OUT | sponge $SHARED" >&2
    echo >&2
    echo "   确认要丢弃：$0 --force" >&2
    exit 1
  fi
fi

[ -f "$OUT" ] && cp "$OUT" "$OUT.bak"
printf '%s\n' "$MERGED" > "$OUT"
chmod 600 "$OUT"

echo "✅ $OUT 已生成（备份：$OUT.bak）"
echo "   shared  : $(jq -r 'keys | join(", ")' "$SHARED")"
echo "   machine : $(jq -r 'keys | join(", ")' "$MACHINE")"
