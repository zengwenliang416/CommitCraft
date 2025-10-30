# Commit Message Body 改进方案

## 问题描述

用户反馈当前生成的提交消息 body 部分只是罗列文件名和行数,缺少功能价值和业务意义的描述。

### 问题示例

**当前输出(无意义)**:
```
docs(tradingview): 添加TradingView学习系统文档

主要变更:
- 新增 tools/tradingview/README.md (216 行)
- 新增 tools/tradingview/indicators/README.md (46 行)
- 新增 tools/tradingview/strategies/README.md (49 行)
- 新增 tools/tradingview/notes/getting-started.md (261 行)
```

**用户期望(有意义)**:
```
docs(tradingview): 添加TradingView学习系统文档

主要变更:
- 建立TradingView学习系统完整框架,提供Pine Script开发入门指南
- 添加技术指标开发最佳实践,包括RSI/MACD/布林带示例代码
- 实现交易策略回测框架,支持历史数据验证和性能分析
- 集成学习路线图,从基础语法到高级策略开发全覆盖
```

## 解决方案

### 1. 修改 commit-message.md

**位置**: `.claude/agents/commit-message.md`

**修改内容**:

#### A. 添加核心原则(第22-75行)

在 "Core Message Generation Philosophy" 后添加:

```markdown
- **🎯 Functional focus** - Describe **功能价值和业务意义**, NOT file paths or line counts

## 🚨 Critical: Body Content Requirements

**What to INCLUDE in commit body**:
- ✅ **功能价值**: What capability does this add?
- ✅ **业务意义**: Why is this change important?
- ✅ **技术影响**: What does this enable?
- ✅ **使用场景**: When/where is this used?

**What to EXCLUDE from commit body**:
- ❌ 文件路径列表 (e.g., `新增 tools/tradingview/README.md`)
- ❌ 行数统计 (e.g., `(216 行)` or `+318/-67`)
- ❌ 文件名罗列 (e.g., `修改 src/auth/login.js`)
- ❌ 技术细节堆砌 (e.g., `修改第123行的函数签名`)
```

#### B. 替换 Body Generation 实现(第169-228行)

**旧实现(删除)**:
```javascript
function generateBody(group, analysis, language) {
  const lines = []
  if (language === 'ch') {
    lines.push('主要变更:')
    groupFiles.forEach(f => {
      if (f.status === 'added') {
        lines.push(`- 新增 ${f.file} (${f.lines_added} 行)`)  // ❌ 文件路径+行数
      }
    })
  }
  return lines.join('\n')
}
```

**新实现(添加)**:
```javascript
function generateFunctionalBody(group, analysis, language) {
  const fileDetails = group.file_details || []

  const lines = []
  if (language === 'ch') {
    lines.push('主要变更:')
    fileDetails.forEach(f => {
      const desc = f.description  // ✅ 使用功能描述
      lines.push(`- ${desc}`)
    })
  }
  return lines.join('\n')
}
```

### 2. 数据流保证

确保 `file_details[].description` 包含有意义的功能描述:

#### commit-grouper 已经生成(无需修改)

**当前输出** (`.claude/commitcraft/*/data/grouping-strategy.json`):
```json
{
  "groups": [
    {
      "group_id": "group-1",
      "file_details": [
        {
          "file": ".claude/CLAUDE_CODE_INTERACTION_GUIDE.md",
          "status": "added",
          "description": "Claude Code交互机制完整指南"  // ✅ 有意义的描述
        }
      ]
    }
  ]
}
```

#### commit-analyzer 需要生成 change_summary(未来改进)

**当前不足**:
如果 `grouper` 的 `description` 过于简单(如只有文件名),`message` agent 无法增强。

**改进方向**:
在 `commit-analyzer` 中为每个文件生成 `change_summary`:
```json
{
  "changes": [
    {
      "file": "tools/tradingview/README.md",
      "status": "added",
      "lines_added": 216,
      "change_summary": "建立TradingView学习系统完整框架,提供Pine Script开发入门指南"
    }
  ]
}
```

### 3. 验证机制

在 `commit-validator` 中添加检查:

**新增验证规则**:
```javascript
function validateBodyContent(message) {
  const bodyLines = message.split('\n').slice(2)  // 跳过 header 和空行

  const violations = []

  bodyLines.forEach(line => {
    // ❌ 检测文件路径
    if (/新增.*\.(md|js|ts|py|go)/.test(line)) {
      violations.push('Body contains file paths')
    }

    // ❌ 检测行数
    if (/\(\d+\s*行\)/.test(line) || /\+\d+\/-\d+/.test(line)) {
      violations.push('Body contains line counts')
    }

    // ❌ 检测文件名罗列
    if (/^-\s*修改\s+[a-zA-Z0-9_\/\.]+$/.test(line)) {
      violations.push('Body contains file name listing')
    }
  })

  return violations
}
```

## 实施步骤

### Phase 1: 立即改进(已完成)

- [x] 修改 `commit-message.md` 添加核心原则
- [x] 替换 `generateBody()` 为 `generateFunctionalBody()`
- [x] 添加 `isSimpleFileDescription()` 检测简单描述
- [x] 添加 `enhanceDescription()` 增强简单描述

### Phase 2: 中期改进(待实施)

- [ ] 修改 `commit-analyzer` 生成 `change_summary` 字段
- [ ] 修改 `commit-grouper` 使用 `change_summary` 作为 `description`
- [ ] 添加 `commit-validator` 检查 body 内容质量

### Phase 3: 长期优化(未来)

- [ ] 使用 LLM 从 git diff 自动生成功能描述
- [ ] 支持用户自定义 body 生成模板
- [ ] 添加历史提交消息学习机制

## 测试验证

### 测试用例 1: 新增文档

**输入**:
```json
{
  "group_id": "group-1",
  "feature": "tradingview-docs",
  "type": "docs",
  "file_details": [
    {
      "file": "tools/tradingview/README.md",
      "status": "added",
      "description": "建立TradingView学习系统完整框架,提供Pine Script开发入门指南"
    }
  ]
}
```

**预期输出**:
```
docs(tradingview): 添加TradingView学习系统文档

主要变更:
- 建立TradingView学习系统完整框架,提供Pine Script开发入门指南
```

### 测试用例 2: 修改核心功能

**输入**:
```json
{
  "group_id": "group-2",
  "feature": "auth-oauth",
  "type": "feat",
  "file_details": [
    {
      "file": "src/auth/oauth.js",
      "status": "modified",
      "lines_changed": 120,
      "description": "实现OAuth2.0第三方登录支持Google/GitHub/微信"
    },
    {
      "file": "src/auth/session.js",
      "status": "modified",
      "lines_changed": 45,
      "description": "添加会话持久化机制支持跨设备登录状态同步"
    }
  ]
}
```

**预期输出**:
```
feat(auth): 实现OAuth第三方登录支持

主要变更:
- 实现OAuth2.0第三方登录支持Google/GitHub/微信
- 添加会话持久化机制支持跨设备登录状态同步
```

## 用户反馈

### 原始反馈

> "这些东西没有意义啊,我要的信息是和功能相关的"

**分析**:
用户需要的是**功能价值描述**,而非技术实现细节(文件路径、行数)。

### 解决确认

通过修改 `commit-message.md`,确保:
1. ✅ Body 中描述功能价值和业务意义
2. ✅ 禁止文件路径和行数罗列
3. ✅ 从 `file_details[].description` 获取有意义的描述
4. ✅ 提供 fallback 机制增强简单描述

## 相关文档

- [commit-message.md](./.claude/agents/commit-message.md) - 提交消息生成器(已修改)
- [commit-grouper.md](./.claude/agents/commit-grouper.md) - 文件分组器(提供 description)
- [commit-validator.md](./.claude/agents/commit-validator.md) - 验证器(待添加 body 检查)

---

**修改时间**: 2025-10-22
**修改人**: Claude Code
**问题来源**: 用户反馈 #commitcraft-feedback
