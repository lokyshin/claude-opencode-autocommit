# claude-opencode-autocommit
Auto-commit + permission config installer for Claude Code &amp; OpenCode. Interactive shell script supporting user/project level setup with bilingual (EN/ZH) prompts. | Claude Code &amp; OpenCode 自动提交 + 权限配置安装脚本，支持中英双语交互，覆盖用户级与项目级配置。
# 🤖 ai-commit-setup

**Auto-commit + Git permission config installer for Claude Code & OpenCode**  
**Claude Code & OpenCode 自动提交 + Git 权限配置 一键安装脚本**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://img.shields.io/badge/shell-bash-blue.svg)](https://www.gnu.org/software/bash/)
[![Claude Code](https://img.shields.io/badge/Claude-Code-orange.svg)](https://code.claude.com)
[![OpenCode](https://img.shields.io/badge/Open-Code-green.svg)](https://opencode.ai)

[English](#english) · [中文](#中文)

---

## English

### ✨ Features

- 🌐 **Bilingual interactive prompts** — Choose Chinese or English at startup
- 🛠️ **Multi-tool support** — Claude Code, OpenCode, or both simultaneously
- 📁 **Multi-level installation** — Global (user-level) or project-level (shared/private)
- 🔐 **Three permission modes** — Relaxed / Strict / Full open
- 🔄 **Auto-commit on task complete** — AI tools automatically run `git add` + `git commit` after each change
- 🚫 **Push protection** — `git push` always requires manual confirmation
- 📝 **Conventional commits** — Auto-generated messages follow `feat/fix/refactor/docs/chore` convention
- 🔒 **gitignore-aware** — Private config files auto-added to `.gitignore`

---

### 📋 Prerequisites

| Requirement | Version |
|-------------|---------|
| Git | ≥ 2.x |
| Bash | ≥ 4.x |
| Claude Code | Latest ([install](https://code.claude.com/docs)) |
| OpenCode | Latest ([install](https://opencode.ai/docs)) |

> Claude Code and OpenCode are optional — install only what you use.

---

### 🚀 Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/ai-commit-setup.git
cd ai-commit-setup

# 2. Grant execute permission
chmod +x setup-auto-commit.sh

# 3. Navigate to your project directory
cd /path/to/your/project

# 4. Run the installer
/path/to/ai-commit-setup/setup-auto-commit.sh
```

Or run directly without cloning:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/ai-commit-setup/main/setup-auto-commit.sh)
```

---

### 🎮 Interactive Setup Flow

```
Step 0 │ Language Selection
       │ [1] 中文  [2] English
       │
Step 1 │ Tool Selection
       │ [1] Claude Code only
       │ [2] OpenCode only
       │ [3] Both
       │
Step 2 │ Installation Level
       │ [1] User level (global, all projects)
       │ [2] Project level - team shared (committed to Git)
       │ [3] Project level - private (gitignored)  ← default
       │ [4] All (global + project shared)
       │
Step 3 │ Permission Strategy
       │ [1] Relaxed  (add/commit auto-allow, push asks)  ← default
       │ [2] Strict   (only add/commit allowed, push denied)
       │ [3] Full open (all git operations allowed)
       │ [4] Skip     (configure manually)
```

---

### 📁 Files Generated

#### Claude Code

| File | Location | Purpose |
|------|----------|---------|
| `CLAUDE.md` | Project root or `~/.claude/` | Auto-commit instructions for Claude |
| `settings.json` | `.claude/` or `~/.claude/` | Hooks + permission rules |
| `settings.local.json` | `.claude/` | Private config (gitignored) |

#### OpenCode

| File | Location | Purpose |
|------|----------|---------|
| `AGENTS.md` | Project root or `~/` | Auto-commit instructions for OpenCode |
| `opencode.json` | Project root or `~/.config/opencode/` | Permission + autosave rules |
| `opencode.local.json` | Project root | Private config (gitignored) |

---

### 🔐 Permission Modes Explained

#### Relaxed Mode (Default — Recommended for beginners)

| Operation | Behavior |
|-----------|----------|
| `git add`, `git commit` | ✅ Auto allow |
| `git status`, `git log`, `git diff` | ✅ Auto allow |
| `git push` | ⚠️ Ask for confirmation |
| `git reset --hard`, `git rebase` | ⚠️ Ask for confirmation |

#### Strict Mode (Recommended for teams)

| Operation | Behavior |
|-----------|----------|
| `git add`, `git commit` | ✅ Auto allow |
| `git push`, `git reset`, `git rebase`, `git merge` | ❌ Denied |
| All others | ⚠️ Ask for confirmation |

#### Full Open Mode (Personal experiments only)

| Operation | Behavior |
|-----------|----------|
| All `git *` operations | ✅ Auto allow |

> ⚠️ Not recommended for team or production projects.

---

### ⚠️ Important: Permission Priority Differences

| Tool | Priority Rule |
|------|--------------|
| **Claude Code** | `deny > ask > allow`, **first match wins** |
| **OpenCode** | **Last match wins** — `*` wildcard must be placed first as default |

This difference is handled automatically by the installer.

---

### 💡 Best Practices

1. **Never auto-push** — Only auto-commit; always push manually after review
2. **Use conventional commits** — `feat/fix/refactor/docs/chore` format
3. **Clean up commits periodically** — `git rebase -i HEAD~N` to squash minor auto-commits
4. **Personal branches only** — Use auto-commit on feature branches; be cautious on `main`
5. **Verify with `/permissions`** — In Claude Code, type `/permissions` to view active rules

---

### 🧪 Verify Installation

**Claude Code:**
```bash
# Open Claude Code in your project, then type:
/permissions
# Should show: git add/commit in allow list
```

**OpenCode:**
```bash
# Complete any task in OpenCode, then check:
git log --oneline -5
# Should show auto-generated commits
```

---

### 📄 License

MIT License © 2026 YOUR_NAME

See [LICENSE](./LICENSE) for details.

---

## 中文

### ✨ 功能特性

- 🌐 **中英双语交互** — 启动时选择语言，全程提示无障碍
- 🛠️ **多工具支持** — 支持 Claude Code、OpenCode 或同时配置两者
- 📁 **多级安装** — 用户级（全局）或项目级（团队共享/个人私有）
- 🔐 **三种权限模式** — 宽松 / 严格 / 完全开放
- 🔄 **任务完成自动提交** — AI 工具每次改动后自动执行 `git add` + `git commit`
- 🚫 **Push 保护** — `git push` 始终需要手动确认，避免意外推送
- 📝 **规范提交信息** — 自动生成符合 `feat/fix/refactor/docs/chore` 约定的 commit message
- 🔒 **自动 gitignore** — 私有配置文件自动加入 `.gitignore`

---

### 📋 前置要求

| 依赖项 | 版本要求 |
|--------|---------|
| Git | ≥ 2.x |
| Bash | ≥ 4.x |
| Claude Code | 最新版（[安装文档](https://code.claude.com/docs)） |
| OpenCode | 最新版（[安装文档](https://opencode.ai/docs)） |

> Claude Code 和 OpenCode 按需安装，脚本会根据选择只配置你使用的工具。

---

### 🚀 快速开始

```bash
# 1. 克隆仓库
git clone https://github.com/YOUR_USERNAME/ai-commit-setup.git
cd ai-commit-setup

# 2. 授予执行权限
chmod +x setup-auto-commit.sh

# 3. 进入你的项目目录
cd /path/to/your/project

# 4. 运行安装脚本
/path/to/ai-commit-setup/setup-auto-commit.sh
```

或直接在线执行（无需克隆）：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/ai-commit-setup/main/setup-auto-commit.sh)
```

---

### 🎮 交互安装流程

```
第零步 │ 语言选择
       │ [1] 中文  [2] English
       │
第一步 │ 工具选择
       │ [1] 仅 Claude Code
       │ [2] 仅 OpenCode
       │ [3] 两者都安装
       │
第二步 │ 安装级别
       │ [1] 用户级（全局，所有项目生效）
       │ [2] 项目级 - 团队共享（提交 Git）
       │ [3] 项目级 - 个人私有（自动 gitignore）← 默认
       │ [4] 全部（用户级 + 项目级共享）
       │
第三步 │ 权限策略
       │ [1] 宽松模式（add/commit 放行，push 需确认）← 默认
       │ [2] 严格模式（仅 add/commit 放行，push 拒绝）
       │ [3] 完全开放（所有 git 操作放行）
       │ [4] 跳过（手动配置）
```

---

### 📁 生成的文件说明

#### Claude Code

| 文件 | 位置 | 用途 |
|------|------|------|
| `CLAUDE.md` | 项目根目录或 `~/.claude/` | 告知 Claude 自动提交规则 |
| `settings.json` | `.claude/` 或 `~/.claude/` | Hooks + 权限规则 |
| `settings.local.json` | `.claude/` | 私有配置（已 gitignore） |

#### OpenCode

| 文件 | 位置 | 用途 |
|------|------|------|
| `AGENTS.md` | 项目根目录或 `~/` | 告知 OpenCode 自动提交规则 |
| `opencode.json` | 项目根目录或 `~/.config/opencode/` | 权限 + 自动保存规则 |
| `opencode.local.json` | 项目根目录 | 私有配置（已 gitignore） |

---

### 🔐 权限模式说明

#### 宽松模式（默认，推荐新手）

| 操作 | 行为 |
|------|------|
| `git add`、`git commit` | ✅ 自动放行 |
| `git status`、`git log`、`git diff` | ✅ 自动放行 |
| `git push` | ⚠️ 需手动确认 |
| `git reset --hard`、`git rebase` | ⚠️ 需手动确认 |

#### 严格模式（推荐团队）

| 操作 | 行为 |
|------|------|
| `git add`、`git commit` | ✅ 自动放行 |
| `git push`、`git reset`、`git rebase`、`git merge` | ❌ 明确拒绝 |
| 其他所有操作 | ⚠️ 需手动确认 |

#### 完全开放模式（仅限个人实验项目）

| 操作 | 行为 |
|------|------|
| 所有 `git *` 操作 | ✅ 全部放行 |

> ⚠️ 不推荐在团队或生产项目中使用。

---

### ⚠️ 重要：两个工具的权限优先级不同

| 工具 | 优先级规则 |
|------|-----------|
| **Claude Code** | `deny > ask > allow`，**第一条匹配规则生效** |
| **OpenCode** | **最后匹配规则生效**，`*` 通配符必须放最前面作为默认值 |

此差异由安装脚本自动处理，无需手动干预。

---

### 💡 最佳实践

1. **不要自动 push** — 只自动 commit，push 在 review 后手动执行
2. **规范 commit message** — 使用 `feat/fix/refactor/docs/chore` 格式
3. **定期整理 commit** — 使用 `git rebase -i HEAD~N` 合并细碎的自动 commit
4. **仅在个人分支使用** — 功能分支上用 auto-commit，`main` 分支慎用
5. **验证权限配置** — 在 Claude Code 中输入 `/permissions` 查看当前生效规则

---

### 🧪 验证安装是否成功

**Claude Code：**
```bash
# 在项目目录打开 Claude Code，输入：
/permissions
# 应显示：git add/commit 在 allow 列表中
```

**OpenCode：**
```bash
# 在 OpenCode 中完成任意任务，然后检查：
git log --oneline -5
# 应显示自动生成的 commit 记录
```

---

### 📄 开源许可

MIT License © 2026 Lokyshin Zhao

详见 [LICENSE](./LICENSE) 文件。

---

如果这个项目对你有帮助，欢迎 ⭐ Star！  
If this project helps you, please consider giving it a ⭐ Star!
