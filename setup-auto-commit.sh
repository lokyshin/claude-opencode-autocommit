#!/bin/bash

# ══════════════════════════════════════════════════════════════
# AI Coding Tool Auto-Commit + Permission Config Installer
# AI 编程工具自动提交 + 权限配置 安装脚本
# Compatible with OpenCode >= 1.x (autosave key removed)
# ══════════════════════════════════════════════════════════════

# ──────────────────────────────────────────────────────────────
# STEP 0 / 第零步：Language Selection / 语言选择
# ──────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Please select installation language / 请选择安装语言"
echo ""
echo " 1) 中文"
echo " 2) English"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -p " [1/2] (default 默认: 1): " LANG_CHOICE
LANG_CHOICE=${LANG_CHOICE:-1}

# ── 语言文本函数 ──────────────────────────────────────────────
msg() {
  local ZH="$1"
  local EN="$2"
  [ "$LANG_CHOICE" = "1" ] && echo "$ZH" || echo "$EN"
}

# ══════════════════════════════════════════════════════════════
# STEP 1 / 第一步：Tool Selection / 工具选择
# ══════════════════════════════════════════════════════════════
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
msg "【第一步】请选择要配置的工具：" "【Step 1】Please select the tool to configure:"
echo ""
msg " 1) Claude Code 专用" " 1) Claude Code only"
msg "    配置内容：CLAUDE.md + .claude/settings.json + hooks" \
    "    Configures: CLAUDE.md + .claude/settings.json + hooks"
msg "    权限语法：allow/deny 数组，第一条匹配规则生效" \
    "    Permission syntax: allow/deny array, first match wins"
echo ""
msg " 2) OpenCode 专用" " 2) OpenCode only"
msg "    配置内容：AGENTS.md + opencode.json" \
    "    Configures: AGENTS.md + opencode.json"
msg "    权限语法：permission 对象，最后匹配规则生效（与 Claude Code 相反）" \
    "    Permission syntax: permission object, last match wins (opposite of Claude Code)"
msg "    默认行为：不配置则默认 allow 所有操作" \
    "    Default behavior: allows all operations if unconfigured"
echo ""
msg " 3) 两者都安装" " 3) Install both"
msg "    以上两套配置同时写入，互不干扰" \
    "    Both configurations written simultaneously, no conflicts"
echo ""
read -p "$(msg '请输入选项 [1/2/3]（默认 1）: ' 'Enter option [1/2/3] (default 1): ')" TOOL_CHOICE
TOOL_CHOICE=${TOOL_CHOICE:-1}

# ══════════════════════════════════════════════════════════════
# STEP 2 / 第二步：Installation Level / 安装级别
# ══════════════════════════════════════════════════════════════
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
msg "【第二步】请选择安装级别：" "【Step 2】Please select installation level:"
echo ""
msg " 1) 用户级（全局）—— 所有项目生效，个人私有，不提交 Git" \
    " 1) User level (global) —— affects all projects, private, not committed to Git"
msg "    Claude Code：~/.claude/settings.json" \
    "    Claude Code: ~/.claude/settings.json"
msg "    OpenCode： ~/.config/opencode/opencode.json" \
    "    OpenCode: ~/.config/opencode/opencode.json"
echo ""
msg " 2) 项目级-团队共享 —— 当前项目生效，提交 Git，团队共享" \
    " 2) Project level (shared) —— current project only, committed to Git, shared with team"
msg "    Claude Code：./.claude/settings.json" \
    "    Claude Code: ./.claude/settings.json"
msg "    OpenCode： ./opencode.json" \
    "    OpenCode: ./opencode.json"
echo ""
msg " 3) 项目级-个人私有 —— 当前项目生效，自动 gitignore，不影响他人" \
    " 3) Project level (private) —— current project only, auto-gitignored, won't affect others"
msg "    Claude Code：./.claude/settings.local.json" \
    "    Claude Code: ./.claude/settings.local.json"
msg "    OpenCode： ./opencode.local.json" \
    "    OpenCode: ./opencode.local.json"
echo ""
msg " 4) 全部安装 —— 用户级 + 项目级团队共享，双重覆盖，最完整" \
    " 4) Install all —— user level + project shared, dual override, most complete"
msg "    优先级：项目级 > 用户级（两个工具均如此）" \
    "    Priority: project level > user level (applies to both tools)"
echo ""
read -p "$(msg '请输入选项 [1/2/3/4]（默认 3）: ' 'Enter option [1/2/3/4] (default 3): ')" LEVEL_CHOICE
LEVEL_CHOICE=${LEVEL_CHOICE:-3}

# ══════════════════════════════════════════════════════════════
# STEP 3 / 第三步：Permission Strategy / 权限策略
# ══════════════════════════════════════════════════════════════
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
msg "【第三步】请选择权限配置策略：" "【Step 3】Please select permission strategy:"
echo ""
msg " 1) 宽松模式（推荐新手）" " 1) Relaxed mode (recommended for beginners)"
msg "    git add / commit / status / log / diff → 自动放行（allow）" \
    "    git add / commit / status / log / diff → auto allow"
msg "    git push / rebase / reset --hard → 需手动确认（ask）" \
    "    git push / rebase / reset --hard → manual confirm (ask)"
msg "    其他 bash 命令 → 需手动确认（ask）" \
    "    other bash commands → manual confirm (ask)"
echo ""
msg " 2) 严格模式（推荐团队）" " 2) Strict mode (recommended for teams)"
msg "    仅 git add / commit → 自动放行（allow）" \
    "    only git add / commit → auto allow"
msg "    git push / reset / rebase / merge → 明确拒绝（deny）" \
    "    git push / reset / rebase / merge → explicitly denied (deny)"
msg "    其他所有操作 → 需手动确认（ask）" \
    "    all other operations → manual confirm (ask)"
echo ""
msg " 3) 完全开放模式（个人实验项目）" " 3) Full open mode (personal experiments)"
msg "    所有 git 操作 → 自动放行（包括 push）" \
    "    all git operations → auto allow (including push)"
msg "    ⚠️ 不推荐在团队或生产项目中使用" \
    "    ⚠️ Not recommended for team or production projects"
echo ""
msg " 4) 跳过权限配置（手动设置）" " 4) Skip permission config (manual setup)"
msg "    Claude Code：使用内置默认（遇到操作会询问）" \
    "    Claude Code: uses built-in defaults (will ask per operation)"
msg "    OpenCode：默认全部 allow，无需额外配置" \
    "    OpenCode: defaults to allow all, no extra config needed"
echo ""
read -p "$(msg '请输入选项 [1/2/3/4]（默认 1）: ' 'Enter option [1/2/3/4] (default 1): ')" PERM_CHOICE
PERM_CHOICE=${PERM_CHOICE:-1}

# ══════════════════════════════════════════════════════════════
# 工具函数 / Utility Functions：Claude Code
# ══════════════════════════════════════════════════════════════

write_claude_md() {
  local DIR="$1"
  cat > "${DIR}/CLAUDE.md" << 'EOF'
## Auto-Commit Rules for Claude Code / Claude Code 自动提交规则

**After every logical change, automatically run: / 每次完成逻辑改动后，自动执行：**
1. git add -A
2. git commit -m "<type>: <short description>"

Conventional commit types / 提交类型规范:
- feat: new feature / 新功能
- fix: bug fix / 修复 bug
- refactor: code restructure / 代码重构
- docs: documentation / 文档更新
- chore: maintenance / 维护配置
- test: add or fix tests / 测试相关

Do NOT auto-push. / 不要自动 push，等待人工 review 后再推送。
EOF
  msg " ✅ CLAUDE.md → ${DIR}/CLAUDE.md" \
      " ✅ CLAUDE.md → ${DIR}/CLAUDE.md"
}

write_claude_hooks() {
  local SETTINGS_FILE="$1"
  local DIR
  DIR=$(dirname "${SETTINGS_FILE}")
  mkdir -p "${DIR}"

  local PERM_BLOCK
  case "$PERM_CHOICE" in
    1)
      PERM_BLOCK='"permissions": {
    "allow": [
      "Bash(git add *)",
      "Bash(git add -A)",
      "Bash(git commit *)",
      "Bash(git status)",
      "Bash(git log *)",
      "Bash(git diff *)",
      "Bash(git branch *)",
      "Bash(git switch *)",
      "Bash(git checkout *)"
    ],
    "deny": [
      "Bash(git push *)",
      "Bash(git reset --hard *)",
      "Bash(git rebase *)"
    ]
  }'
      ;;
    2)
      PERM_BLOCK='"permissions": {
    "allow": [
      "Bash(git add *)",
      "Bash(git add -A)",
      "Bash(git commit *)",
      "Bash(git status)"
    ],
    "deny": [
      "Bash(git push *)",
      "Bash(git reset --hard *)",
      "Bash(git rebase *)",
      "Bash(git merge *)"
    ]
  }'
      ;;
    3)
      PERM_BLOCK='"permissions": {
    "allow": [ "Bash(git *)" ],
    "deny": []
  }'
      ;;
    4)
      PERM_BLOCK='"permissions": {
    "allow": [],
    "deny": []
  }'
      ;;
  esac

  cat > "${SETTINGS_FILE}" << EOF
{
  ${PERM_BLOCK},
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "cd \"\$CLAUDE_PROJECT_DIR\" && git add -A && git diff-index --quiet HEAD || git commit -m \"feat: Claude task complete \$(date +%H:%M)\" || true"
      }]
    }]
  }
}
EOF
  msg " ✅ Claude Code 配置 → ${SETTINGS_FILE}" \
      " ✅ Claude Code config → ${SETTINGS_FILE}"
  case "$PERM_CHOICE" in
    1) msg " 🔓 权限：宽松（add/commit 放行，push/reset 需确认）" \
           " 🔓 Permission: relaxed (add/commit allowed, push/reset asks)" ;;
    2) msg " 🔒 权限：严格（仅 add/commit 放行，push/reset 拒绝）" \
           " 🔒 Permission: strict (only add/commit allowed, push/reset denied)" ;;
    3) msg " ⚠️  权限：完全开放（所有 git 操作放行）" \
           " ⚠️  Permission: full open (all git operations allowed)" ;;
    4) msg " ⏭️  权限：已跳过，使用 Claude Code 内置默认" \
           " ⏭️  Permission: skipped, using Claude Code built-in defaults" ;;
  esac
}

install_claude() {
  local LEVEL="$1"
  echo ""
  msg "📦 [Claude Code] 安装中..." "📦 [Claude Code] Installing..."
  msg "   权限规则：deny > ask > allow，第一条匹配规则生效" \
      "   Permission rule: deny > ask > allow, first match wins"
  case "$LEVEL" in
    1)
      mkdir -p ~/.claude
      write_claude_md ~/.claude
      write_claude_hooks ~/.claude/settings.json
      ;;
    2)
      mkdir -p .claude
      write_claude_md .
      write_claude_hooks .claude/settings.json
      msg " 💡 请记得：git add .claude/settings.json CLAUDE.md && git commit" \
          " 💡 Remember: git add .claude/settings.json CLAUDE.md && git commit"
      ;;
    3)
      mkdir -p .claude
      write_claude_md .
      write_claude_hooks .claude/settings.local.json
      grep -q "settings.local.json" .gitignore 2>/dev/null \
        || echo ".claude/settings.local.json" >> .gitignore
      msg " 💡 settings.local.json 已加入 .gitignore，不会提交到 Git" \
          " 💡 settings.local.json added to .gitignore, will not be committed"
      ;;
    4)
      mkdir -p ~/.claude .claude
      write_claude_md ~/.claude
      write_claude_hooks ~/.claude/settings.json
      write_claude_md .
      write_claude_hooks .claude/settings.json
      msg " 💡 项目级优先于用户级；项目 settings.json 请提交 Git" \
          " 💡 Project level overrides user level; commit project settings.json to Git"
      ;;
  esac
}

# ══════════════════════════════════════════════════════════════
# 工具函数 / Utility Functions：OpenCode
# ══════════════════════════════════════════════════════════════

write_agents_md() {
  local DIR="$1"
  cat > "${DIR}/AGENTS.md" << 'EOF'
## Auto-Commit Rules for OpenCode / OpenCode 自动提交规则

**After every logical change, automatically run: / 每次完成逻辑改动后，自动执行：**
1. git add -A
2. git commit -m "<type>: <short description>"

Conventional commit types / 提交类型规范:
- feat / fix / refactor / docs / chore / test

Do NOT auto-push. / 不要自动 push，等待人工 review 后再推送。
EOF
  msg " ✅ AGENTS.md → ${DIR}/AGENTS.md" \
      " ✅ AGENTS.md → ${DIR}/AGENTS.md"
}

write_opencode_config() {
  local CONFIG_FILE="$1"
  local DIR
  DIR=$(dirname "${CONFIG_FILE}")
  mkdir -p "${DIR}"

  # ── OpenCode >= 1.x: "autosave" key is removed.
  # Auto-commit is driven by AGENTS.md instructions to the AI agent.
  # Only "permission" is written here.
  local PERM_BLOCK
  case "$PERM_CHOICE" in
    1)
      # Relaxed: wildcard "ask" first (last-match-wins), specific allows override
      PERM_BLOCK='"permission": {
    "bash": {
      "*":                  "ask",
      "git status":         "allow",
      "git log *":          "allow",
      "git diff *":         "allow",
      "git branch *":       "allow",
      "git add *":          "allow",
      "git add -A":         "allow",
      "git commit *":       "allow",
      "git switch *":       "allow",
      "git checkout *":     "allow",
      "git push *":         "ask",
      "git reset --hard *": "ask",
      "git rebase *":       "ask"
    },
    "edit": "allow",
    "read": "allow"
  }'
      ;;
    2)
      # Strict: wildcard "ask", allow only add/commit, deny push/reset/rebase/merge
      PERM_BLOCK='"permission": {
    "bash": {
      "*":                  "ask",
      "git status":         "allow",
      "git add *":          "allow",
      "git add -A":         "allow",
      "git commit *":       "allow",
      "git push *":         "deny",
      "git reset --hard *": "deny",
      "git rebase *":       "deny",
      "git merge *":        "deny"
    },
    "edit": "allow",
    "read": "allow"
  }'
      ;;
    3)
      # Full open: only git wildcard allow
      PERM_BLOCK='"permission": {
    "bash": {
      "git *": "allow"
    },
    "edit": "allow",
    "read": "allow"
  }'
      ;;
    4)
      # Skip: empty permission object (OpenCode defaults to allow all)
      PERM_BLOCK='"permission": {}'
      ;;
  esac

  cat > "${CONFIG_FILE}" << EOF
{
  ${PERM_BLOCK}
}
EOF
  msg " ✅ OpenCode 配置 → ${CONFIG_FILE}" \
      " ✅ OpenCode config → ${CONFIG_FILE}"
  case "$PERM_CHOICE" in
    1) msg " 🔓 权限：宽松（add/commit 放行，push/reset 需确认）" \
           " 🔓 Permission: relaxed (add/commit allowed, push/reset asks)" ;;
    2) msg " 🔒 权限：严格（push/reset/rebase/merge 拒绝）" \
           " 🔒 Permission: strict (push/reset/rebase/merge denied)" ;;
    3) msg " ⚠️  权限：完全开放（所有 git 操作放行）" \
           " ⚠️  Permission: full open (all git operations allowed)" ;;
    4) msg " ⏭️  权限：已跳过，OpenCode 默认全部 allow" \
           " ⏭️  Permission: skipped, OpenCode defaults to allow all" ;;
  esac
}

install_opencode() {
  local LEVEL="$1"
  echo ""
  msg "📦 [OpenCode] 安装中..." "📦 [OpenCode] Installing..."
  msg "   权限规则：最后匹配规则生效（与 Claude Code 相反）" \
      "   Permission rule: last match wins (opposite of Claude Code)"
  msg "   默认行为：不配置则全部 allow，无需额外授权" \
      "   Default behavior: allows all if unconfigured, no extra auth needed"
  case "$LEVEL" in
    1)
      mkdir -p ~/.config/opencode
      write_agents_md ~
      write_opencode_config ~/.config/opencode/opencode.json
      ;;
    2)
      write_agents_md .
      write_opencode_config ./opencode.json
      msg " 💡 请记得：git add opencode.json AGENTS.md && git commit" \
          " 💡 Remember: git add opencode.json AGENTS.md && git commit"
      ;;
    3)
      write_agents_md .
      write_opencode_config ./opencode.local.json
      grep -q "opencode.local.json" .gitignore 2>/dev/null \
        || echo "opencode.local.json" >> .gitignore
      msg " 💡 opencode.local.json 已加入 .gitignore，不会提交到 Git" \
          " 💡 opencode.local.json added to .gitignore, will not be committed"
      ;;
    4)
      mkdir -p ~/.config/opencode
      write_agents_md ~
      write_opencode_config ~/.config/opencode/opencode.json
      write_agents_md .
      write_opencode_config ./opencode.json
      msg " 💡 项目级优先于用户级；项目 opencode.json 请提交 Git" \
          " 💡 Project level overrides user level; commit project opencode.json to Git"
      ;;
  esac
}

# ══════════════════════════════════════════════════════════════
# 执行安装 / Execute Installation
# ══════════════════════════════════════════════════════════════
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
msg "⚙️ 正在安装..." "⚙️ Installing..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

case "$TOOL_CHOICE" in
  1) install_claude "$LEVEL_CHOICE" ;;
  2) install_opencode "$LEVEL_CHOICE" ;;
  3) install_claude "$LEVEL_CHOICE"
     install_opencode "$LEVEL_CHOICE" ;;
  *)
    msg "❌ 无效的工具选项，退出" "❌ Invalid tool option, exiting"
    exit 1
    ;;
esac

# ══════════════════════════════════════════════════════════════
# 完成提示 / Completion Summary
# ══════════════════════════════════════════════════════════════
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
msg "✅ 安装完成！请重启对应工具使配置生效。" \
    "✅ Installation complete! Restart your tool for changes to take effect."
echo ""
msg "📋 验证方法：" "📋 Verification:"
[ "$TOOL_CHOICE" != "2" ] && \
  msg "   Claude Code：输入 /permissions 查看当前生效的权限规则及来源文件" \
      "   Claude Code: type /permissions to view active rules and their source files"
[ "$TOOL_CHOICE" != "1" ] && \
  msg "   OpenCode：完成一次任务后运行 git log 确认是否自动 commit" \
      "   OpenCode: complete a task then run git log to confirm auto-commit"
echo ""
msg "⚠️  注意事项 + 最佳实践" "⚠️  Tips + Best Practices"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
msg "1. 权限优先级差异（重要）：" "1. Permission priority differences (important):"
msg "   Claude Code：deny > ask > allow，第一条匹配规则生效" \
    "   Claude Code: deny > ask > allow, first match wins"
msg "   OpenCode： 最后匹配规则生效，* 通配符需放最前面" \
    "   OpenCode: last match wins, put * wildcard first as default"
echo ""
msg "2. 不要自动 push：" "2. Do not auto-push:"
msg "   只 auto commit，push 等你 review 后手动执行 git push" \
    "   Only auto-commit; push manually after review with git push"
echo ""
msg "3. Commit message 规范：" "3. Commit message convention:"
msg "   使用 conventional commits（feat/fix/refactor/docs/chore）" \
    "   Use conventional commits (feat/fix/refactor/docs/chore)"
echo ""
msg "4. 定期清理细碎 commit：" "4. Periodically clean up minor commits:"
msg "   使用 git rebase -i HEAD~N 合并过多自动 commit" \
    "   Use git rebase -i HEAD~N to squash excessive auto-commits"
echo ""
msg "5. 团队协作：" "5. Team collaboration:"
msg "   只在个人分支用 auto-commit，main 分支慎用" \
    "   Use auto-commit on personal branches only; be cautious on main"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
msg "💡 设置完成后，AI 工具就像'自带 Git 的程序员'" \
    "💡 Once configured, your AI tool works like a 'programmer with built-in Git'"
msg "   改完自动保存版本，你只管 review 和 push。" \
    "   Changes are auto-versioned; you just review and push."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
