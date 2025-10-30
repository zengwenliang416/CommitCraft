---
name: commit-pilot
description: Multi-agent orchestrator for intelligent git commit workflow with process documentation
argument-hint: "[COMMIT_DESCRIPTION] [--batch] [--quick] [--preview] [--skip-validation] [--skip-docs] [--language <en|ch>]"
allowed-tools: Task(commit-analyzer, commit-grouper, commit-message, commit-validator, commit-executor), TodoWrite(*), Read(*), Write(*), Bash(*)
---

# CommitCraft Pilot - Intelligent Git Commit Orchestrator

## Overview
Multi-agent orchestration for professional git commits through intelligent analysis, grouping, validation, and execution with complete process documentation.

**Strategy**: Analyze → Group → Message → Validate → Execute
- **5-agent pipeline**: Sequential specialist coordination
- **Quality-first**: 90/100 minimum score requirement
- **Security-aware**: Blocks commits with sensitive data
- **Bilingual**: English/Chinese message support
- **Process documentation**: Complete session traceability

## Phase 1: Setup & Configuration

### Step 1: Parse Options & Create Session
```javascript
// Parse command-line options
const options = {
  batch: args.includes('--batch'),
  quick: args.includes('--quick'),
  preview: args.includes('--preview'),
  skip_validation: args.includes('--skip-validation'),
  skip_docs: args.includes('--skip-docs'),
  language: extractLanguage(args) || detectLanguageFromGit()
}

// Create timestamped session
const sessionId = `commitcraft-${formatTimestamp(new Date())}`
const sessionDir = `.claude/commitcraft/${sessionId}`

bash(`mkdir -p ${sessionDir}/data`)
```

**Output**: `sessionId`, `sessionDir`, `options`

### Step 2: Initialize TODO Tracking
```javascript
TodoWrite({
  todos: [
    {
      content: "Analyze repository changes and detect features",
      status: "in_progress",
      activeForm: "Analyzing repository"
    },
    {
      content: "Group files into logical commit units",
      status: "pending",
      activeForm: "Grouping files"
    },
    {
      content: "Generate professional commit messages",
      status: "pending",
      activeForm: "Generating messages"
    },
    {
      content: "Validate commit quality and security",
      status: "pending",
      activeForm: "Validating commits"
    },
    {
      content: "Execute git commits safely",
      status: "pending",
      activeForm: "Executing commits"
    }
  ]
})
```

## Phase 2: Multi-Agent Pipeline Execution

### Step 1: Analyze Repository (Agent 1)
**Executor**: `Task(commit-analyzer)`

```javascript
const analysisResult = await Task({
  subagent_type: "commit-analyzer",
  description: "Analyze repository changes for commit workflow",
  prompt: `
    Analyze all changes in the current git repository.

    SESSION: ${sessionId}
    OUTPUT_DIR: ${sessionDir}

    ## Task
    1. Run git status and git diff analysis (READ-ONLY operations, safe to execute)
    2. Classify changes by type (code/docs/config/assets)
    3. Detect features and modules using MCP code-index
    4. Map file dependencies
    5. Calculate complexity and risk

    ## Output Files
    - ${sessionDir}/data/repository-analysis.json
    - ${sessionDir}/00-repository-analysis.md

    **Note**: All git commands are read-only analysis operations. No confirmation needed.

    Return the analysis results when complete.
  `
})

// Update TODO
TodoWrite: Mark "Analyze repository" completed, "Group files" in_progress

// Parse results
const analysis = JSON.parse(Read(`${sessionDir}/data/repository-analysis.json`))
console.log(`✅ Analysis complete: ${analysis.summary.total_files} files, ${analysis.features_detected.length} features`)
```

**Output**: `repository-analysis.json`, `00-repository-analysis.md`

### Step 2: Group Files by Feature (Agent 2)
**Executor**: `Task(commit-grouper)`

**Gate Check**: Verify analysis completed
```javascript
// GATE: Verify prerequisites from commit-analyzer
if (!fileExists(`${sessionDir}/data/repository-analysis.json`)) {
  throw new Error('❌ GATE FAILED: Missing repository-analysis.json - run commit-analyzer first')
}

const analysis = JSON.parse(Read(`${sessionDir}/data/repository-analysis.json`))
if (!analysis.features_detected || analysis.features_detected.length === 0) {
  throw new Error('❌ GATE FAILED: No features detected - cannot group files')
}

console.log('✅ GATE PASSED: commit-grouper can proceed')
```

```javascript
const groupingResult = await Task({
  subagent_type: "commit-grouper",
  description: "Group files by feature for logical commits",
  prompt: `
    Group the analyzed files into logical commit groups.

    SESSION: ${sessionId}
    INPUT: ${sessionDir}/data/repository-analysis.json
    OPTIONS: ${JSON.stringify(options)}

    ## Task
    1. Load repository-analysis.json
    2. Group files by feature/module
    3. Respect dependencies (ensure dependent files in same group)
    4. Apply grouping rules:
       - Max 10 files per group
       - Separate code/docs/config if too large
       - Keep tests with source files
    5. Generate git add commands for each group

    ## Output Files
    - ${sessionDir}/data/grouping-strategy.json
    - ${sessionDir}/01-grouping-strategy.md

    Return the grouping strategy when complete.
  `
})

// Update TODO
TodoWrite: Mark "Group files" completed

// Parse results
const grouping = JSON.parse(Read(`${sessionDir}/data/grouping-strategy.json`))
console.log(`✅ Grouping complete: ${grouping.groups.length} logical commits`)
```

**Output**: `grouping-strategy.json`, `01-grouping-strategy.md`

---

## 🚨 MANDATORY STEP: Interactive Gate - Grouping Confirmation

**⚠️ IMPORTANT**: Before proceeding to Step 3, you MUST pause and interact with the user.

**Required Actions** (skip only if `--quick` flag is present):

### Action 1: Display Grouping Strategy
Read and show the complete grouping strategy to the user:
```javascript
const strategy = Read(`${sessionDir}/01-grouping-strategy.md`)
// Display to user
```

### Action 2: Ask for User Confirmation
You MUST use the `AskUserQuestion` tool with the following configuration:

**Question Text**: "已生成 {N} 个提交分组,是否满意?" (replace {N} with actual number from grouping.groups.length)

**Question Header**: "分组确认"

**Options** (exactly 3 options, multiSelect: false):
1. **"继续生成消息"** - Description: "分组合理,继续生成提交消息"
2. **"重新分组"** - Description: "分组不合理,调整策略后重新分组"
3. **"取消操作"** - Description: "停止工作流,保留当前生成的文件"

### Action 3: Handle User Response
Based on user's answer:
- **"继续生成消息"** → Proceed to Gate B (Branch Naming)
- **"重新分组"** → Stop and report error: "USER_REQUESTED_REGROUPING"
- **"取消操作"** → Stop and report error: "用户取消操作"

**Note**: If `--quick` flag is set, skip this gate entirely and proceed to Gate B.

---

## 🚨 MANDATORY STEP: Interactive Gate B - Branch Naming Strategy

**⚠️ IMPORTANT**: Before generating commit messages, you MUST decide the branch strategy.

**Required Actions** (skip only if `--quick` flag is present):

### Action 1: Generate Branch Name Suggestion
Use features detected in grouping strategy to suggest a branch name:
```javascript
const grouping = JSON.parse(Read(`${sessionDir}/data/grouping-strategy.json`))

// Extract top 2-3 features for branch name
const features = grouping.groups
  .slice(0, 3)
  .map(g => g.feature)
  .join('-')
  .replace(/[^a-zA-Z0-9-]/g, '-')
  .toLowerCase()

const suggestedBranch = `feature/${features}`
console.log(`建议的分支名: ${suggestedBranch}`)
```

### Action 2: Ask for Branch Strategy
You MUST use the `AskUserQuestion` tool with the following configuration:

**Question Text**: "选择分支提交策略(建议: {suggestedBranch})?" (replace {suggestedBranch} with generated name)

**Question Header**: "分支策略"

**Options** (exactly 4 options, multiSelect: false):
1. **"使用建议分支"** - Description: "在AI生成的feature分支提交: {suggestedBranch}"
2. **"自定义分支名"** - Description: "手动输入分支名称(通过Other选项)"
3. **"当前分支提交"** - Description: "不创建新分支,直接在当前分支提交(传统模式)"
4. **"取消操作"** - Description: "停止工作流"

### Action 3: Handle User Response
```javascript
const branchChoice = userAnswer['分支策略']
let targetBranch = null
let useFeatureBranch = false

if (branchChoice === '使用建议分支') {
  targetBranch = suggestedBranch
  useFeatureBranch = true
} else if (branchChoice === '自定义分支名') {
  // User provides custom name via "Other" option
  targetBranch = userAnswer['分支策略_Other']
  if (!targetBranch || targetBranch.trim() === '') {
    throw new Error('自定义分支名不能为空')
  }
  useFeatureBranch = true
} else if (branchChoice === '当前分支提交') {
  useFeatureBranch = false
  console.log('将在当前分支直接提交')
} else if (branchChoice === '取消操作') {
  throw new Error('用户取消操作')
}

// Save branch strategy to session
const branchStrategy = {
  use_feature_branch: useFeatureBranch,
  target_branch: targetBranch,
  original_branch: bash('git branch --show-current').trim()
}
Write(`${sessionDir}/data/branch-strategy.json`, JSON.stringify(branchStrategy, null, 2))
```

**Note**: If `--quick` flag is set, use suggested branch name automatically.

---

### Step 3: Generate Commit Messages (Agent 3)
**Executor**: `Task(commit-message)`

**Gate Check**: Verify grouping completed
```javascript
// GATE: Verify prerequisites from commit-grouper
if (!fileExists(`${sessionDir}/data/grouping-strategy.json`)) {
  throw new Error('❌ GATE FAILED: Missing grouping-strategy.json - run commit-grouper first')
}

const grouping = JSON.parse(Read(`${sessionDir}/data/grouping-strategy.json`))
if (!grouping.groups || grouping.groups.length === 0) {
  throw new Error('❌ GATE FAILED: No file groups - cannot generate messages')
}

console.log('✅ GATE PASSED: commit-message can proceed')
```

```javascript
const messageResult = await Task({
  subagent_type: "commit-message",
  description: "Generate professional commit messages",
  prompt: `
    Generate Conventional Commits format messages for each group.

    SESSION: ${sessionId}
    INPUT: ${sessionDir}/data/grouping-strategy.json
    LANGUAGE: ${options.language}

    ## Task
    1. Load grouping-strategy.json
    2. For each group, generate commit message:
       - Type: feat|fix|docs|style|refactor|test|chore|perf|ci|build
       - Scope: Module or feature name
       - Subject: Imperative mood, <72 chars
       - Body: Bullet points explaining changes
       - Footer: Issue refs, breaking changes, co-author
    3. Generate git commit commands using HEREDOC format
    4. Support bilingual (EN/CH) based on language setting

    ## Templates
    - Conventional Commits: Read('~/.claude/workflows/cli-templates/prompts/commitcraft/conventional-commits.txt')

    ## Output Files
    - ${sessionDir}/data/commit-messages.json
    - ${sessionDir}/02-commit-messages.md

    Return the commit messages when complete.
  `
})

// Update TODO
TodoWrite: Mark "Generate messages" completed, "Validate commits" in_progress

// Parse results
const messages = JSON.parse(Read(`${sessionDir}/data/commit-messages.json`))
console.log(`✅ Messages generated: ${messages.groups.length} commit messages`)
```

**Output**: `commit-messages.json`, `02-commit-messages.md`

### Step 4: Validate Quality & Security (Agent 4)
**Executor**: `Task(commit-validator)` (unless `--skip-validation`)

**Gate Check**: Verify messages generated
```javascript
// GATE: Verify prerequisites from commit-message
if (!fileExists(`${sessionDir}/data/commit-messages.json`)) {
  throw new Error('❌ GATE FAILED: Missing commit-messages.json - run commit-message first')
}

const messages = JSON.parse(Read(`${sessionDir}/data/commit-messages.json`))
if (!messages.groups || !messages.groups.every(g => g.commit_message)) {
  throw new Error('❌ GATE FAILED: Incomplete commit messages - some groups missing messages')
}

console.log('✅ GATE PASSED: commit-validator can proceed')
```

```javascript
let validationResult = null

if (!options.skip_validation) {
  validationResult = await Task({
    subagent_type: "commit-validator",
    description: "Validate commit quality and security",
    prompt: `
      Validate commit messages for quality and security.

      SESSION: ${sessionId}
      INPUT: ${sessionDir}/data/commit-messages.json
      MIN_SCORE: 90/100

      ## Task
      1. Load commit-messages.json
      2. For each message, validate 4 dimensions:
         - Format compliance (25 points): Conventional Commits format
         - Clarity (25 points): Clear, specific, imperative mood
         - Completeness (25 points): All changes explained
         - Convention (25 points): Line length, footer format, body structure
           **DO NOT check**: Co-author, attribution, or Claude Code references
           **REASON**: These were intentionally removed by commit-message agent
      3. Security checks (BLOCKING):
         - API keys, passwords, tokens in git diff
         - AWS credentials, private keys
         - Block CRITICAL issues
      4. Calculate overall score and status

      **CRITICAL**: Attribution (Co-Authored-By, Claude Code) was removed in Step 3.
      DO NOT deduct points for missing attribution. Use validation criteria from commit-validator.md.

      ## Templates
      - Quality criteria: Read('~/.claude/workflows/cli-templates/prompts/commitcraft/quality-criteria.txt')
      - Security patterns: Read('~/.claude/workflows/cli-templates/prompts/commitcraft/security-patterns.txt')

      ## Output Files
      - ${sessionDir}/data/validation-report.json
      - ${sessionDir}/03-validation-report.md

      Return validation results. BLOCK if security issues or score < 90.
    `
  })

  // Update TODO
  TodoWrite: Mark "Validate commits" completed

  // Check validation results
  const validation = JSON.parse(Read(`${sessionDir}/data/validation-report.json`))

  if (validation.overall_status === 'blocked') {
    const report = Read(`${sessionDir}/03-validation-report.md`)
    console.log(report)
    throw new Error('❌ Validation BLOCKED - Security issues detected')
  }

  if (validation.overall_status === 'needs_improvement') {
    const report = Read(`${sessionDir}/03-validation-report.md`)
    console.log(report)

    if (!options.quick) {
      // Interactive gate: Ask user how to proceed
      const userChoice = AskUserQuestion({
        questions: [
          {
            question: "验证未通过(质量分数 < 90),如何处理?",
            header: "验证失败",
            multiSelect: false,
            options: [
              {
                label: "重新生成消息",
                description: "使用更严格的质量标准重新生成所有提交消息"
              },
              {
                label: "继续执行",
                description: "忽略质量警告继续执行提交(不推荐,可能影响提交历史质量)"
              },
              {
                label: "取消操作",
                description: "停止工作流,保留当前生成的文件供手动调整"
              }
            ]
          }
        ]
      })

      if (userChoice.answers['验证失败'] === '重新生成消息') {
        // Regenerate with stricter quality standards
        console.log('🔄 重新生成提交消息...')
        // Jump back to message generation step
        throw new Error('USER_REQUESTED_REGENERATION')
      } else if (userChoice.answers['验证失败'] === '取消操作') {
        throw new Error('❌ 用户取消操作 - 已保存会话数据到 ' + sessionDir)
      }
      // If "继续执行", fall through to execution
    } else {
      throw new Error('❌ Validation failed in quick mode')
    }
  }

  console.log(`✅ Validation passed: Score ${validation.overall_score}/100`)
}
```

**Output**: `validation-report.json`, `03-validation-report.md`

### Step 5: Execute Commits (Agent 5)
**Executor**: `Task(commit-executor)` (unless `--preview`)

**CRITICAL Gate Check**: Verify validation approved
```javascript
// CRITICAL GATE: Verify validation status
if (!fileExists(`${sessionDir}/data/validation-report.json`)) {
  throw new Error('❌ GATE FAILED: Missing validation-report.json - run commit-validator first')
}

const validation = JSON.parse(Read(`${sessionDir}/data/validation-report.json`))

// BLOCKING: Security issues detected
if (validation.overall_status === 'blocked') {
  console.log('❌ GATE BLOCKED: Critical security issues detected')
  console.log(validation.blocking_issues.map(i => `  - ${i.message}`).join('\n'))
  throw new Error('Cannot execute commits - fix security issues first')
}

// APPROVED: Validation passed
if (validation.overall_status === 'approved') {
  console.log('✅ GATE PASSED: commit-executor can proceed')
} else {
  // WARNING: Quality issues but not blocking
  console.log('⚠️ GATE WARNING: Quality score below threshold')
  if (!options.quick && !options.skip_validation) {
    // Would prompt user for confirmation in production
    throw new Error('Quality issues detected - manual confirmation required')
  }
}
```

```javascript
let executionResult = null

if (!options.preview) {
  // Preview messages before execution
  if (!options.quick) {
    const messages = Read(`${sessionDir}/02-commit-messages.md`)
    console.log('\n📋 Commit Messages Preview:\n')
    console.log(messages)
    console.log('\n准备执行提交...\n')
  }

  // Update TODO
  TodoWrite: Mark "Execute commits" in_progress

  // Load branch strategy
  const branchStrategy = JSON.parse(Read(`${sessionDir}/data/branch-strategy.json`))

  executionResult = await Task({
    subagent_type: "commit-executor",
    description: "Execute git commits safely",
    prompt: `
      Execute git commits for validated groups.

      SESSION: ${sessionId}
      INPUT: ${sessionDir}/data/commit-messages.json
      VALIDATION: ${sessionDir}/data/validation-report.json
      BRANCH_STRATEGY: ${sessionDir}/data/branch-strategy.json

      ## Task
      1. Verify validation status is 'approved'
      2. Load branch strategy from branch-strategy.json
      3. Create backup branch: backup/{features}
      4. If use_feature_branch is true:
         a. Create and checkout target feature branch
         b. Execute all commits on feature branch
      5. If use_feature_branch is false:
         a. Execute all commits on current branch
      6. For each group:
         a. Execute git add command
         b. Execute git commit command (using HEREDOC)
         c. Verify commit hash
         d. Handle pre-commit hook modifications (amend if needed)
      7. Rollback on any failure
      8. Keep backup branch and feature branch for merge confirmation

      ## Safety Rules
      - Create backup before any git operations
      - Verify each commit hash
      - Only amend if authored by Claude and not pushed
      - Rollback to backup on any error
      - Do NOT delete backup or feature branch (user will decide merge strategy)

      ## Output Files
      - ${sessionDir}/data/execution-log.json
      - ${sessionDir}/04-execution-log.md

      Return execution results with commit hashes and branch information.
    `
  })

  // Update TODO
  TodoWrite: Mark "Execute commits" completed

  // Parse results
  const execution = JSON.parse(Read(`${sessionDir}/data/execution-log.json`))
  console.log(`✅ Commits executed: ${execution.executions.length} commits`)

} else {
  console.log('\n🔍 PREVIEW MODE - No commits will be executed')
  const messages = Read(`${sessionDir}/02-commit-messages.md`)
  console.log(messages)
}
```

**Output**: `execution-log.json`, `04-execution-log.md`

---

## 🚨 MANDATORY STEP: Interactive Gate C - Merge Strategy

**⚠️ IMPORTANT**: After successful execution, if feature branch was used, you MUST decide merge strategy.

**Required Actions** (skip only if `--quick` flag or `use_feature_branch` is false):

### Condition Check
```javascript
// Only show merge gate if feature branch was used
if (executionResult && branchStrategy.use_feature_branch && !options.quick) {
  const execution = JSON.parse(Read(`${sessionDir}/data/execution-log.json`))
  const currentBranch = execution.current_branch || branchStrategy.target_branch
  const originalBranch = branchStrategy.original_branch

  console.log(`\n✅ 所有提交已在分支 '${currentBranch}' 完成`)
  console.log(`原始分支: ${originalBranch}`)
  console.log(`提交数量: ${execution.executions.length}`)
```

### Action 1: Display Execution Summary
Show commit hashes and changes:
```javascript
  console.log('\n📊 提交摘要:\n')
  execution.executions.forEach((exec, i) => {
    console.log(`${i + 1}. ${exec.git_commit.commit_hash.substring(0, 7)} - ${exec.feature}`)
  })
  console.log('')
```

### Action 2: Ask for Merge Strategy
You MUST use the `AskUserQuestion` tool with the following configuration:

**Question Text**: "提交完成,选择合并策略?"

**Question Header**: "合并策略"

**Options** (exactly 4 options, multiSelect: false):
1. **"AI自动合并"** - Description: "自动合并到原分支并删除feature分支(快速模式)"
2. **"显示合并命令"** - Description: "生成git merge命令供手动执行"
3. **"保留分支不合并"** - Description: "保留feature分支供后续PR或手动处理"
4. **"回滚所有提交"** - Description: "恢复到执行前状态(使用backup分支)"

### Action 3: Handle User Response
```javascript
  const mergeChoice = userAnswer['合并策略']

  if (mergeChoice === 'AI自动合并') {
    console.log(`\n🔄 自动合并 ${currentBranch} 到 ${originalBranch}...\n`)

    // Checkout original branch
    bash(`git checkout ${originalBranch}`)

    // Merge feature branch
    try {
      const mergeResult = bash(`git merge --no-ff ${currentBranch}`)
      console.log(mergeResult)

      // Delete feature branch
      bash(`git branch -d ${currentBranch}`)

      // Delete backup branch
      bash(`git branch -D ${execution.backup_branch}`)

      console.log(`✅ 合并完成,已删除分支 ${currentBranch}`)

    } catch (error) {
      console.log('⚠️ 合并冲突,需要手动解决')
      console.log('使用以下命令手动合并:')
      console.log(`  git checkout ${originalBranch}`)
      console.log(`  git merge ${currentBranch}`)
      console.log('解决冲突后:')
      console.log(`  git branch -d ${currentBranch}`)
      throw new Error('Merge conflict - manual intervention required')
    }

  } else if (mergeChoice === '显示合并命令') {
    console.log('\n📝 手动合并命令:\n')
    console.log(`# 1. 切换到原始分支`)
    console.log(`git checkout ${originalBranch}`)
    console.log(``)
    console.log(`# 2. 合并feature分支(保留合并记录)`)
    console.log(`git merge --no-ff ${currentBranch}`)
    console.log(``)
    console.log(`# 3. 删除feature分支(可选)`)
    console.log(`git branch -d ${currentBranch}`)
    console.log(``)
    console.log(`# 4. 删除backup分支`)
    console.log(`git branch -D ${execution.backup_branch}`)
    console.log(``)
    console.log(`当前停留在分支: ${currentBranch}`)

  } else if (mergeChoice === '保留分支不合并') {
    console.log(`\n📦 分支保留策略:\n`)
    console.log(`Feature分支: ${currentBranch}`)
    console.log(`原始分支: ${originalBranch}`)
    console.log(`Backup分支: ${execution.backup_branch}`)
    console.log(``)
    console.log(`提示: 可以创建Pull Request或稍后手动合并`)

  } else if (mergeChoice === '回滚所有提交') {
    console.log(`\n⚠️ 回滚到执行前状态...\n`)

    // Checkout original branch
    bash(`git checkout ${originalBranch}`)

    // Reset to backup
    bash(`git reset --hard ${execution.backup_branch}`)

    // Delete feature branch
    bash(`git branch -D ${currentBranch}`)

    // Delete backup branch
    bash(`git branch -D ${execution.backup_branch}`)

    console.log(`✅ 已回滚到 ${execution.backup_branch},所有更改已撤销`)
  }
}
```

**Note**:
- If `--quick` flag is set, auto-merge feature branch
- If `use_feature_branch` is false, skip this gate entirely
- Always keep backup branch until merge/rollback decision is made

---

## Phase 3: Documentation & Summary

### Step 1: Generate Session Summary (unless `--skip-docs`)
```javascript
if (!options.skip_docs) {
  const summaryData = {
    session_id: sessionId,
    timestamp: new Date().toISOString(),
    status: executionResult ? 'completed' : 'preview',
    total_files: analysis.summary.total_files,
    total_commits: grouping.groups.length,
    avg_quality_score: validationResult ? validationResult.overall_score : null,
    features: grouping.groups.map(g => ({
      name: g.feature,
      files: g.files.length,
      commit_hash: executionResult ?
        executionResult.executions.find(e => e.group_id === g.group_id)?.git_commit.commit_hash :
        null,
      quality_score: validationResult ?
        validationResult.validations.find(v => v.group_id === g.group_id)?.quality_score :
        null
    })),
    options: options,
    execution_time_ms: Date.now() - startTime
  }

  Write(`${sessionDir}/summary.json`, JSON.stringify(summaryData, null, 2))

  // Generate markdown summary
  bash(`~/.claude/scripts/commitcraft-doc-generator.sh ${sessionDir}`)

  console.log(`\n✅ Session documentation: ${sessionDir}`)
}
```

**Output**: `summary.json`, `05-session-summary.md`

### Step 2: Display Results
```javascript
if (executionResult) {
  console.log('\n✅ Commit Workflow Complete!')
  console.log(`\nCommits created: ${executionResult.executions.length}`)

  executionResult.executions.forEach((exec, i) => {
    console.log(`  ${i + 1}. ${exec.git_commit.commit_hash.substring(0, 7)} - ${exec.feature}`)
  })

  if (validationResult) {
    console.log(`\nAverage Quality Score: ${validationResult.overall_score}/100`)
  }

  console.log(`\nSession: ${sessionId}`)
  console.log(`Documentation: .claude/commitcraft/${sessionId}/`)

} else if (options.preview) {
  console.log('\n📋 Preview complete. No commits were executed.')
  console.log(`\nTo execute, run: /commit-pilot (without --preview)`)
  console.log(`Manual commands: ${sessionDir}/02-commit-messages.md`)
}
```

## Session Documentation Structure

Every execution creates complete documentation:

```
.claude/commitcraft/commitcraft-YYYYMMDD-HHMMSS/
├── 00-repository-analysis.md      # What changed
├── 01-grouping-strategy.md        # How grouped + git add commands
├── 02-commit-messages.md          # Messages + git commit commands
├── 03-validation-report.md        # Quality scores and issues
├── 04-execution-log.md            # Execution results
├── 05-session-summary.md          # Overall summary
├── data/                          # JSON data files
│   ├── repository-analysis.json
│   ├── grouping-strategy.json
│   ├── commit-messages.json
│   ├── validation-report.json
│   └── execution-log.json
└── summary.json                   # Session metadata
```

## Options Reference

- `--help`: Show detailed help and usage examples
- `--batch`: Process multiple features as separate commits sequentially
- `--quick`: Skip interactive confirmations, use smart defaults
- `--preview`: Dry run - show what would be committed without executing
- `--skip-validation`: Skip quality validation (NOT recommended)
- `--skip-docs`: Skip process documentation generation
- `--language <en|ch>`: Force commit message language (default: auto-detect)

## Examples

### Basic Usage
```bash
/commit-pilot

# Output:
# ✅ Analysis complete: 5 files, 2 features
# ✅ Grouping complete: 2 logical commits
# ✅ Messages generated: 2 commit messages
# ✅ Validation passed: Score 95/100
# ✅ Commits executed: 2 commits
#   1. abc123d - authentication
#   2. def456g - documentation
# Session: commitcraft-20250121-143025
```

### Quick Mode
```bash
/commit-pilot --quick

# Auto-execute with smart defaults, no confirmations
```

### Preview Mode
```bash
/commit-pilot --preview

# Shows what would be committed without executing
```

### Batch Mode
```bash
/commit-pilot --batch

# Creates separate commits for each feature
```

### Chinese Messages
```bash
/commit-pilot --language ch

# Generates Chinese commit messages
```

## Error Handling

### No Changes Detected
```
❌ No changes detected in repository.
Working directory is clean.
Suggestion: Make some changes before running commit workflow.
```

### Validation Failed
```
⚠️ Validation failed (Score: 75/100)

Issues:
  - Missing scope in commit message [-10]
  - Subject too vague [-10]
  - No body text for multi-file commit [-5]

Options:
[R] Regenerate messages
[P] Proceed anyway (not recommended)
[C] Cancel
```

### Security Check Blocked
```
🔒 Security check BLOCKED commit

Issue: API key detected in diff
File: src/config.js
Pattern: api_key = "sk_live_abc123..."

Required Actions:
1. Remove sensitive data from code
2. Use environment variables
3. Add to .gitignore if needed

Commit workflow aborted for security.
```

## Best Practices

1. **Run before committing**: Use `/commit-pilot` instead of manual `git commit`
2. **Review analysis**: Check `00-repository-analysis.md` to verify detected features
3. **Trust validation**: If score < 90, review and improve messages
4. **Use preview mode**: Try `--preview` first if unsure
5. **Batch for multiple features**: Use `--batch` for unrelated features
6. **Learn from history**: Run `/commit-history` periodically

## See Also

- `/batch-commit` - Batch processing for multiple features
- `/commit-history` - Analyze past commit quality
- `/analyze` - Run only analysis phase
- `/group` - Run only grouping phase
- `/validate` - Run only validation phase
- `.claude/output-styles/commitcraft-workflow.md` - Output format standards
- `.claude/workflows/commitcraft-architecture.md` - Complete architecture

---

*Multi-agent orchestration for professional git commits*
