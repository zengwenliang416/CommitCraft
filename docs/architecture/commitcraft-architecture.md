# CommitCraft Workflow Architecture

## Overview

CommitCraft is an intelligent Git commit multi-agent system that transforms manual commits into professionally orchestrated workflows with 95% quality assurance.

## Core Architecture

### Design Principles

1. **Multi-Agent Orchestration** - 5 specialized agents working in sequence
2. **Session-based Documentation** - Complete process traceability
3. **Quality-First** - 90+ score requirement before execution
4. **Security-Aware** - Built-in credential and sensitive data detection
5. **JSON-Only Data** - JSON as source of truth, Markdown as views

### Agent Pipeline

```
User Changes
    ↓
┌─────────────────────────────────────────────────────────────┐
│ 1. commit-analyzer                                          │
│    └─ Analyzes repository changes, detects features        │
│       Output: repository-analysis.json                      │
└──────────────────┬──────────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. commit-grouper                                           │
│    └─ Groups files by feature/module intelligently         │
│       Output: grouping-strategy.json + git add commands    │
└──────────────────┬──────────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. commit-message                                           │
│    └─ Generates professional commit messages               │
│       Output: commit-messages.json + git commit commands   │
└──────────────────┬──────────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. commit-validator                                         │
│    └─ Validates quality, format, security                  │
│       Output: validation-report.json (score ≥ 90 required) │
└──────────────────┬──────────────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────────────┐
│ 5. commit-executor                                          │
│    └─ Executes commits with verification                   │
│       Output: execution-log.json                            │
└──────────────────┬──────────────────────────────────────────┘
                   ▼
           Perfect Commit ✅
```

## Session Management

### Session Structure

```
.claude/commitcraft/
└── commitcraft-YYYYMMDD-HHMMSS/           # Timestamped session
    ├── 00-repository-analysis.md          # Stage 1: Change analysis
    ├── 01-grouping-strategy.md            # Stage 2: File grouping + commands
    ├── 02-commit-messages.md              # Stage 3: Message generation + commands
    ├── 03-validation-report.md            # Stage 4: Quality validation
    ├── 04-execution-log.md                # Stage 5: Execution results
    ├── 05-session-summary.md              # Final summary
    ├── data/                              # JSON data files
    │   ├── repository-analysis.json
    │   ├── grouping-strategy.json
    │   ├── commit-messages.json
    │   ├── validation-report.json
    │   └── execution-log.json
    └── summary.json                       # Session metadata
```

### Session Metadata (summary.json)

```json
{
  "session_id": "commitcraft-20250121-143025",
  "timestamp": "2025-01-21T14:30:25Z",
  "status": "completed|in_progress|failed",
  "total_files": 12,
  "total_commits": 3,
  "avg_quality_score": 94.5,
  "features": [
    {
      "name": "user-authentication",
      "files": 5,
      "commit_hash": "abc123",
      "quality_score": 95
    }
  ],
  "options": {
    "batch": false,
    "quick": false,
    "preview": false,
    "skip_validation": false,
    "language": "en"
  },
  "execution_time_ms": 12500
}
```

## Agent Specifications

### 1. commit-analyzer

**Role**: Change Analysis Specialist

**Responsibilities**:
- Execute `git status` and `git diff` analysis
- Classify changes (code/docs/config/assets)
- Detect features and modules
- Identify dependencies

**Output Schema**:
```json
{
  "summary": {
    "total_files": 10,
    "modified": 5,
    "added": 3,
    "deleted": 2,
    "unstaged": 4,
    "staged": 6
  },
  "changes": [
    {
      "file": "src/auth/login.js",
      "status": "modified",
      "category": "code",
      "feature": "authentication",
      "lines_added": 45,
      "lines_deleted": 12,
      "change_type": "feature"
    }
  ],
  "features_detected": [
    {
      "name": "authentication",
      "files": ["login.js", "auth.service.js"],
      "type": "feature",
      "priority": "high"
    }
  ],
  "dependencies": [
    {
      "file": "utils/crypto.js",
      "used_by": ["login.js", "register.js"]
    }
  ]
}
```

### 2. commit-grouper

**Role**: Intelligent File Grouping Specialist

**Responsibilities**:
- Group files by feature/module
- Respect dependencies
- Generate `git add` commands
- Create logical commit boundaries

**Output Schema**:
```json
{
  "groups": [
    {
      "group_id": "group-1",
      "feature": "authentication",
      "files": [
        "src/auth/login.js",
        "src/auth/auth.service.js",
        "tests/auth.test.js"
      ],
      "git_add_command": "git add src/auth/login.js src/auth/auth.service.js tests/auth.test.js",
      "rationale": "Files belong to authentication feature with shared dependencies"
    }
  ],
  "ungrouped": [],
  "warnings": []
}
```

### 3. commit-message

**Role**: Professional Commit Message Generator

**Responsibilities**:
- Generate Conventional Commits format
- Bilingual support (English/Chinese)
- Include scope, type, description
- Add body and footer when needed
- Generate `git commit` commands

**Output Schema**:
```json
{
  "messages": [
    {
      "group_id": "group-1",
      "message": {
        "type": "feat",
        "scope": "auth",
        "subject": "implement JWT-based user authentication",
        "body": "- Add login endpoint with JWT generation\n- Implement token validation middleware\n- Add comprehensive test coverage",
        "footer": "Closes #123\n\n🤖 Generated with [Claude Code](https://claude.com/claude-code)\n\nCo-Authored-By: Claude <noreply@anthropic.com>",
        "raw": "feat(auth): implement JWT-based user authentication\n\n- Add login endpoint with JWT generation\n- Implement token validation middleware\n- Add comprehensive test coverage\n\nCloses #123\n\n🤖 Generated with [Claude Code](https://claude.com/claude-code)\n\nCo-Authored-By: Claude <noreply@anthropic.com>"
      },
      "git_commit_command": "git commit -m \"feat(auth): implement JWT-based user authentication\" -m \"- Add login endpoint with JWT generation\n- Implement token validation middleware\n- Add comprehensive test coverage\" -m \"Closes #123\n\n🤖 Generated with [Claude Code](https://claude.com/claude-code)\n\nCo-Authored-By: Claude <noreply@anthropic.com>\""
    }
  ]
}
```

### 4. commit-validator

**Role**: Quality Validation and Best Practices Enforcement

**Responsibilities**:
- Validate Conventional Commits format
- Score quality (0-100)
- Check for security issues (credentials, API keys)
- Verify convention adherence
- Require ≥90 score to proceed

**Output Schema**:
```json
{
  "validations": [
    {
      "group_id": "group-1",
      "format_compliance": {
        "valid": true,
        "issues": []
      },
      "quality_score": 95,
      "quality_breakdown": {
        "format": 25,
        "clarity": 24,
        "completeness": 23,
        "convention": 23
      },
      "security_check": {
        "passed": true,
        "warnings": [],
        "blocked": []
      },
      "recommendations": [
        "Consider adding more detail in body"
      ],
      "approved": true
    }
  ],
  "overall_score": 95,
  "overall_status": "approved"
}
```

### 5. commit-executor

**Role**: Safe Commit Execution Specialist

**Responsibilities**:
- Execute `git add` commands
- Execute `git commit` commands
- Verify commit success
- Handle pre-commit hooks
- Rollback on failure

**Output Schema**:
```json
{
  "executions": [
    {
      "group_id": "group-1",
      "git_add": {
        "command": "git add src/auth/login.js src/auth/auth.service.js tests/auth.test.js",
        "exit_code": 0,
        "success": true
      },
      "git_commit": {
        "command": "git commit -m \"feat(auth): implement JWT-based user authentication\" ...",
        "exit_code": 0,
        "success": true,
        "commit_hash": "abc123def456",
        "hook_modified": false
      },
      "verification": {
        "commit_exists": true,
        "hash_matches": true
      }
    }
  ],
  "overall_success": true,
  "failed_groups": [],
  "rollback_performed": false
}
```

## Command Specifications

### /commit-pilot

**Main orchestrator command**

**Options**:
- `--help`: Show help and usage
- `--batch`: Process multiple features as separate commits
- `--quick`: Skip confirmations, use smart defaults
- `--preview`: Dry run mode, no actual commits
- `--skip-validation`: Skip quality validation (not recommended)
- `--skip-docs`: Skip process documentation generation
- `--language <en|ch>`: Force commit message language

**Workflow**:
1. Parse options
2. Create session directory
3. Invoke agents sequentially
4. Collect outputs
5. Generate documentation
6. Provide execution choice (auto/manual/preview)

### /batch-commit

**Batch processing for multiple features**

Automatically detects multiple features and creates separate commits for each, maintaining dependencies.

### /commit-history

**Historical commit analysis**

Analyzes past commits to identify patterns and suggest improvements.

**Options**:
- `--score`: Show quality scores for recent commits
- `--limit <n>`: Analyze last n commits (default: 20)
- `--since <date>`: Analyze commits since date

### /analyze, /group, /validate

**Independent agent commands**

Allow running individual agents for specific tasks without full orchestration.

## Integration Points

### MCP Tools Integration

```javascript
// Code search for existing patterns
mcp__code-index__search_code_advanced(
  pattern="commit.*message",
  file_pattern="*.js"
)

// Find commit message examples
mcp__exa__get_code_context_exa(
  query="conventional commits best practices",
  tokensNum="dynamic"
)

// Get library docs
mcp__context7__get-library-docs(
  context7CompatibleLibraryID="/conventional-commits/specification"
)
```

### Git Operations

All git operations use bash() commands for maximum compatibility:

```bash
# Analysis
bash(git status --porcelain)
bash(git diff --stat)
bash(git log --oneline -n 20)

# Execution
bash(git add file1.js file2.js)
bash(git commit -m "message" -m "body" -m "footer")
bash(git show --stat HEAD)
```

## Quality Standards

### Commit Message Format

**Required Structure** (Conventional Commits):
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**: feat, fix, docs, style, refactor, test, chore, perf, ci, build, revert

**Scope**: Module or feature name

**Subject**:
- Imperative mood
- No period at end
- Max 72 characters

**Body**:
- Bullet points for multiple changes
- Explain "why" not "what"

**Footer**:
- Breaking changes
- Issue references
- Co-author attribution

### Quality Scoring Criteria

- **Format (25%)**: Conventional Commits compliance
- **Clarity (25%)**: Clear, concise, unambiguous
- **Completeness (25%)**: All relevant information included
- **Convention (25%)**: Project-specific conventions followed

**Minimum Score**: 90/100 to proceed with commit

### Security Checks

**Blocked Patterns**:
- API keys (regex: `api[_-]?key.*=.*['"]\w{20,}['"]`)
- Passwords (regex: `password.*=.*['"].*['"]`)
- Tokens (regex: `token.*=.*['"].*['"]`)
- AWS credentials
- Private keys (.pem, .key files in diff)

**Warning Patterns**:
- Environment variables in code
- Database connection strings
- Email addresses in code (not comments)

## Error Handling

### Agent Failure

If any agent fails:
1. Log error to session documentation
2. Provide clear error message to user
3. Offer retry or skip option
4. Maintain partial session data

### Validation Failure

If validation score < 90:
1. Show detailed quality breakdown
2. Highlight specific issues
3. Offer manual override option
4. Suggest improvements

### Commit Hook Modification

If pre-commit hook modifies files:
1. Detect modified files
2. Check authorship
3. Amend commit if safe (author matches, not pushed)
4. Otherwise create new commit

## Future Enhancements

1. **Interactive Mode**: Web UI for commit review and editing
2. **Template Library**: Pre-defined commit message templates
3. **Team Analytics**: Commit quality trends and metrics
4. **AI Learning**: Improve from user feedback and corrections
5. **Integration**: GitHub/GitLab PR description generation
6. **Hooks**: Custom pre/post-commit workflows
7. **Multilingual**: Support for more languages beyond EN/CH
