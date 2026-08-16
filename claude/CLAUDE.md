# 全局上下文

## Second Brain
用户的中心化项目记忆在 **`~/second-brain`**（obsidian-second-brain 管理）。
- 核心 notes: `wiki/concepts/`, `wiki/projects/`, `wiki/logs/`, `wiki/guidelines/`
- 原始素材: `raw/inbox/`, `raw/literature/`, `raw/meetings/`
- 看板: `boards/`
- Vault 索引: `~/second-brain/index.md`（由 `/obsidian-init` 生成后可用）
- 需要项目/知识上下文时先读 `~/second-brain/index.md`（或 `_CLAUDE.md` 若存在），再按结构读对应文件。工单详情用 Linear MCP 获取。

用户常用话术：「拉 context」「项目进度」「second brain」「查 second-brain 里关于 XXX」「更新 second-brain 的 project XXX」。

## Notion Workspaces

**Work Notion (Quandri)** — MCP: `mcp__plugin_Notion_notion__*` (connected)
- Sean's personal space: `1f966e42-0bb3-8093-8336-c2455fb6a387`
- Work tasks → **Linear** (engineering tickets); Sean does NOT use Asana for personal tasks
- Full page ID map: see memory `reference-notion-workspaces`

**Personal/Family Notion** — MCP: `mcp__notion-personal__*` (connected 2026-06-20 on work MacBook)
- Purpose: shopping list + household todos + personal life content, shared with wife
- Root page: Lailai Space (`44e4469f-d93d-4f55-8106-1ae676c68dad`)
- Config: `~/.claude.json` via `claude mcp add notion-personal` (server: `@notionhq/notion-mcp-server`)
- ⚠️ Token needs rotation — old token exposed in chat; regenerate at notion.so/my-integrations

用户常用话术：「Notion」「购物清单」「家庭 todo」「工作 Notion」→ check workspace first.

## 规则

- 在Linear上创建comment之前必须先confirm用户
