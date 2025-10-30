# CommitCraft 测试指南

## 快速开始

### 1. 安装 CommitCraft 到当前项目

在项目根目录运行:

```bash
cd /Users/wenliang_zeng/workspace/open_sources/Claude-Code-Workflow

# 方式1: 交互式安装(推荐)
./Install-Claude.sh

# 方式2: 非交互式安装到当前项目
./Install-Claude.sh -InstallMode Path -TargetPath . -NonInteractive

# 方式3: 全局安装到 ~/.claude
./Install-Claude.sh -InstallMode Global -NonInteractive
```

### 2. 验证安装

```bash
# 检查本地组件(agents, commands, output-styles)
ls -la .claude/agents/commit-*.md
ls -la .claude/commands/commit-pilot.md
ls -la .claude/output-styles/commitcraft-workflow.md

# 检查全局组件(scripts, templates)
ls -la ~/.claude/scripts/commitcraft-doc-generator.sh
ls -la ~/.claude/workflows/cli-templates/prompts/commitcraft/*.txt
```

**预期结果**:
- ✅ 5个智能体文件: commit-analyzer.md, commit-grouper.md, commit-message.md, commit-validator.md, commit-executor.md
- ✅ 1个命令文件: commit-pilot.md
- ✅ 1个输出样式: commitcraft-workflow.md
- ✅ 1个脚本: commitcraft-doc-generator.sh (在 ~/.claude/scripts/)
- ✅ 3个模板: conventional-commits.txt, quality-criteria.txt, security-patterns.txt (在 ~/.claude/workflows/cli-templates/prompts/commitcraft/)

---

## 基础测试

### 测试 1: 创建测试变更

```bash
# 在项目中创建一些测试文件
mkdir -p test-commits/src/auth
echo "// Test login module" > test-commits/src/auth/login.js
echo "// Test auth service" > test-commits/src/auth/auth.service.js
echo "# Auth Documentation" > test-commits/docs/auth.md

# 初始化 git(如果还没有)
cd test-commits
git init
git add -A
```

### 测试 2: 运行 commit-pilot (预览模式)

在 Claude Code 中执行:

```
/commit-pilot --preview --language=en
```

**预期输出**:
1. 创建会话目录: `.claude/commitcraft/commitcraft-YYYYMMDD-HHMMSS/`
2. 生成5个阶段的输出文件:
   - `00-repository-analysis.md` + `data/repository-analysis.json`
   - `01-grouping-strategy.md` + `data/grouping-strategy.json`
   - `02-commit-messages.md` + `data/commit-messages.json`
   - `03-validation-report.md` + `data/validation-report.json`
   - (预览模式不会执行提交)

### 测试 3: 检查会话输出

```bash
# 查找最新的会话目录
ls -lt .claude/commitcraft/ | head -5

# 进入会话目录
cd .claude/commitcraft/commitcraft-YYYYMMDD-HHMMSS/

# 查看分析结果
cat 00-repository-analysis.md

# 查看分组策略
cat 01-grouping-strategy.md

# 查看生成的提交消息
cat 02-commit-messages.md

# 查看验证报告
cat 03-validation-report.md

# 检查 JSON 数据
cat data/repository-analysis.json | jq '.summary'
cat data/grouping-strategy.json | jq '.groups | length'
cat data/commit-messages.json | jq '.groups[0].message'
cat data/validation-report.json | jq '.overall_score'
```

### 测试 4: 生成会话摘要

```bash
# 运行文档生成器
~/.claude/scripts/commitcraft-doc-generator.sh .claude/commitcraft/commitcraft-YYYYMMDD-HHMMSS

# 查看摘要
cat .claude/commitcraft/commitcraft-YYYYMMDD-HHMMSS/05-session-summary.md
```

**预期结果**:
- ✅ 摘要文件包含所有阶段的状态
- ✅ 统计信息正确(文件数、行数变更)
- ✅ 链接到所有会话文件

### 测试 5: 执行提交(真实模式)

⚠️ **警告**: 这将创建真实的 git commit

```
/commit-pilot --language=en
```

**预期结果**:
1. 所有前4个阶段完成
2. 第5阶段(执行)创建 git commits
3. 生成 `04-execution-log.md` + `data/execution-log.json`
4. 工作目录变为 clean

**验证提交**:
```bash
# 查看提交历史
git log --oneline -5

# 查看最新提交的完整消息
git log -1 --format="%B"

# 验证 Conventional Commits 格式
git log -1 --format="%s" | grep -E "^(feat|fix|docs|style|refactor|test|chore|perf|ci|build)\("

# 验证 Co-Author 归属
git log -1 --format="%B" | grep "Co-Authored-By: Claude"
```

---

## 高级测试

### 测试 6: 批量模式

```bash
# 创建多个功能的变更
mkdir -p test-commits/src/{auth,api,ui}
echo "// Auth code" > test-commits/src/auth/index.js
echo "// API code" > test-commits/src/api/index.js
echo "// UI code" > test-commits/src/ui/index.js
git add -A
```

在 Claude Code 中:
```
/commit-pilot --batch --language=en
```

**预期**: 为每个功能创建独立的提交

### 测试 7: 中文消息

```bash
echo "// 新功能" > test-commits/src/feature.js
git add -A
```

在 Claude Code 中:
```
/commit-pilot --language=ch
```

**预期**: 生成中文提交消息

### 测试 8: 安全检测

```bash
# 创建包含敏感信息的文件
echo 'const apiKey = "sk_live_abc123def456ghi789jkl012"' > test-commits/src/config.js
git add test-commits/src/config.js
```

在 Claude Code 中:
```
/commit-pilot
```

**预期**:
- ✅ 验证报告显示 CRITICAL 安全问题
- ✅ Overall status: "blocked"
- ✅ 提交被阻止
- ✅ 提供修复指导

**清理**:
```bash
git reset HEAD test-commits/src/config.js
rm test-commits/src/config.js
```

---

## 测试检查清单

运行完所有测试后,验证:

### 功能测试
- [ ] commit-analyzer 正确检测文件变更
- [ ] commit-grouper 合理分组文件
- [ ] commit-message 生成符合 Conventional Commits 格式
- [ ] commit-validator 正确评分(format/clarity/completeness/convention)
- [ ] commit-executor 成功创建 git commits

### 输出文件测试
- [ ] 所有 JSON 文件格式正确(`jq` 可解析)
- [ ] 所有 Markdown 文件可读且格式正确
- [ ] 会话摘要包含所有阶段链接

### 质量测试
- [ ] 提交消息 ≤72 字符
- [ ] 提交消息使用 imperative mood
- [ ] 提交消息包含详细 body
- [ ] 提交消息包含 co-author attribution
- [ ] 验证分数 ≥ 80

### 安全测试
- [ ] 检测到 API keys
- [ ] 检测到 passwords
- [ ] 检测到 private keys
- [ ] 阻止包含敏感信息的提交
- [ ] 提供修复指导

### 集成测试
- [ ] 预览模式不创建提交
- [ ] 批量模式创建多个提交
- [ ] 中英文消息正确生成
- [ ] 会话目录正确创建
- [ ] 文档生成器正常工作

---

## 故障排查

### 问题: Agent not found

```bash
# 检查 agent 是否存在
ls .claude/agents/commit-*.md

# 重新安装
./Install-Claude.sh -InstallMode Path -TargetPath . -Force
```

### 问题: MCP tools 不可用

在 Claude Code 中测试:
```javascript
mcp__code-index__get_settings_info()
mcp__sequential-thinking__sequentialthinking(
  thought="test",
  thoughtNumber=1,
  totalThoughts=1,
  nextThoughtNeeded=false
)
```

### 问题: 会话目录未创建

```bash
# 检查权限
ls -ld .claude
mkdir -p .claude/commitcraft

# 手动创建测试会话
mkdir -p .claude/commitcraft/commitcraft-test-001/data
```

### 问题: 脚本不可执行

```bash
# 添加执行权限
chmod +x ~/.claude/scripts/commitcraft-doc-generator.sh
```

### 问题: Git 命令失败

```bash
# 验证 git 仓库
git status

# 重新初始化
cd test-commits
git init
```

---

## 性能基准

### 预期执行时间 (小型项目 <10文件)

| 阶段 | 时间 |
|------|------|
| Analysis | 10-20秒 |
| Grouping | 5-10秒 |
| Messages | 10-20秒 |
| Validation | 5-10秒 |
| Execution | 5-10秒 |
| **总计** | **~40-70秒** |

### 预期资源使用

- **内存**: ~500MB-1GB (MCP code-index 缓存)
- **磁盘**: ~100KB-1MB per session
- **网络**: 最小 (仅 MCP 通信)

---

## 清理测试数据

```bash
# 删除测试目录
rm -rf test-commits

# 删除会话目录
rm -rf .claude/commitcraft/commitcraft-*

# 重置 git(如果需要)
git reset --hard HEAD
git clean -fd
```

---

## 参考文档

- **输出格式规范**: `.claude/output-styles/commitcraft-workflow.md`
- **Conventional Commits**: `.claude/workflows/cli-templates/prompts/commitcraft/conventional-commits.txt`
- **质量标准**: `.claude/workflows/cli-templates/prompts/commitcraft/quality-criteria.txt`
- **安全模式**: `.claude/workflows/cli-templates/prompts/commitcraft/security-patterns.txt`

---

## 下一步

测试完成后:

1. **查看会话报告** - 检查 `.claude/commitcraft/` 中的所有会话
2. **分析质量分数** - 查看哪些消息需要改进
3. **优化分组策略** - 调整文件分组规则
4. **定制模板** - 修改 `conventional-commits.txt` 等模板
5. **集成 CI/CD** - 考虑在 pre-commit hook 中使用

---

*最后更新: 2025-01-21*
