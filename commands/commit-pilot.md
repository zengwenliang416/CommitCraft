---
name: commit-pilot
description: Multi-agent orchestrator for intelligent git commit workflow with process documentation
arguments: "[COMMIT_DESCRIPTION]"
options: "[--help] [--batch] [--quick] [--preview] [--skip-validation] [--skip-docs] [--language <en|ch>]"
tools: Task, Write, Bash, Glob, Grep
---

# Usage

```
/commit-pilot [COMMIT_DESCRIPTION] [OPTIONS]
```

Create professional git commits through multi-agent orchestration with intelligent analysis, grouping, and validation.

## Options

- `--help`: Show this help message and usage examples
- `--batch`: Process multiple features as separate commits sequentially
- `--quick`: Skip interactive confirmations, use smart defaults
- `--preview`: Dry run mode, show what would be committed without executing
- `--skip-validation`: Skip quality validation (not recommended)
- `--skip-docs`: Skip process documentation generation
- `--language <en|ch>`: Force commit message language (default: auto-detect)

## Quick Start

```bash
# Show help and usage guide
/commit-pilot --help

# Standard interactive workflow
/commit-pilot

# Quick commit with description
/commit-pilot "implement user authentication feature"

# Batch mode for multiple features
/commit-pilot --batch

# Preview mode for safety
/commit-pilot --preview

# Force Chinese commit messages
/commit-pilot --language ch
```

## Help Output

When using `--help`, displays:

```
CommitCraft Pilot - Intelligent Git Commit Orchestrator
════════════════════════════════════════════════════════

USAGE:
  /commit-pilot [DESCRIPTION] [OPTIONS]

DESCRIPTION:
  Multi-agent system that analyzes, groups, validates, and
  executes perfect git commits through intelligent orchestration.

OPTIONS:
  --help              Show this help message
  --batch             Process multiple features separately
  --quick             Use smart defaults, skip confirmations
  --preview           Dry run without actual commits
  --skip-validation   Skip quality checks (not recommended)
  --language <en|ch>  Force message language

AGENTS:
  • commit-analyzer   - Analyzes repository changes
  • commit-grouper    - Groups files intelligently
  • commit-message    - Generates commit messages
  • commit-validator  - Validates quality (90+ required)
  • commit-executor   - Executes commits safely

WORKFLOW:
  1. Analyze repository changes
  2. Group files by feature/module
  3. Generate professional messages
  4. Validate quality standards
  5. Execute commits with verification

EXAMPLES:
  Basic:       /commit-pilot
  With desc:   /commit-pilot "fix login bug"
  Batch:       /commit-pilot --batch
  Preview:     /commit-pilot --preview
  Quick mode:  /commit-pilot --quick
  Chinese:     /commit-pilot --language ch

QUALITY STANDARDS:
  • Format compliance required
  • Quality score must be ≥ 90/100
  • Security validation enforced
  • Convention adherence checked

MORE INFO:
  Repository: https://github.com/your-username/commitcraft
  Docs: See README.md for detailed documentation
```

## Your Role
You are the Commit Workflow Orchestrator managing an intelligent Git commit pipeline using Claude Code Sub-Agents. **Your primary responsibility is analyzing repository changes, ensuring commit quality through interactive confirmation, and maintaining comprehensive process documentation.** You coordinate specialized agents to achieve 95%+ commit quality standards.

## Initial Repository Scanning Phase

### Automatic Repository Analysis
Upon receiving this command, FIRST analyze the repository to understand current changes:

```
Use Task tool with commit-analyzer agent: "Perform comprehensive change analysis for intelligent commit workflow.

## Analysis Tasks:
1. **Repository Status**:
   - Current branch and upstream status
   - Modified, added, deleted, renamed files
   - Staged vs unstaged changes

2. **Change Classification**:
   - Code changes: features, fixes, refactoring, performance
   - Documentation changes: README, API docs, comments
   - Configuration changes: build, environment, dependencies

3. **Feature Detection**:
   - Identify logical feature boundaries
   - Detect module dependencies
   - Map component relationships

Output: Comprehensive change analysis report including:
- Repository state summary
- Files categorized by type and feature
- Dependency relationships
- Recommended grouping strategy

DO NOT save files yet - return the analysis content directly."
```

### Session Setup
After receiving analysis results:
```bash
# Generate session ID based on timestamp
session_name="commitcraft-$(date +%Y%m%d-%H%M%S)"

# Create session directory
Ensure directory ./.claude/commitcraft/{session_name}/ exists

# Save analysis results
Save analysis to: ./.claude/commitcraft/{session_name}/00-repository-analysis.md
```

## Workflow Phases

### Phase 0: Repository Analysis (Automatic)
Analyze current repository state and all pending changes.
Save results to: `./.claude/commitcraft/{session_name}/00-repository-analysis.md`

### Phase 1: Change Grouping & Planning (Interactive)
Group related changes and plan commit strategy.
Document grouping to: `./.claude/commitcraft/{session_name}/01-grouping-strategy.md`

### 🛑 CRITICAL STOP POINT: Grouping Approval Gate 🛑
**IMPORTANT**: After presenting grouping strategy, MUST STOP and wait for user approval.

### Phase 2: Message Generation & Validation
Generate professional commit messages and validate quality.
Save messages to: `./.claude/commitcraft/{session_name}/02-commit-messages.md`
Save validation to: `./.claude/commitcraft/{session_name}/03-validation-report.md`

### 🛑 CRITICAL STOP POINT: Commit Approval Gate 🛑
**IMPORTANT**: After achieving 90+ quality score, MUST STOP and wait for user approval before executing.

### Phase 3: Execution (Only After Approval)
Execute commits ONLY after user explicitly confirms.
Save execution log to: `./.claude/commitcraft/{session_name}/04-execution-log.md`

## Phase 1: Change Grouping Process

After analysis completes, orchestrate the grouping process:

### 1. Execute Grouping Agent
```
Use Task tool with commit-grouper agent: "
Session Path: ./.claude/commitcraft/{session_name}/
Previous Analysis: Repository analysis has been saved to 00-repository-analysis.md

Task: Read the analysis and propose logical commit groups
Instructions:
1. First read ./.claude/commitcraft/{session_name}/00-repository-analysis.md to understand changes
2. Create intelligent file groupings based on features/modules found in analysis
3. Ensure atomic commits (each group is independently functional)
4. Order groups by dependency (utilities first, features second)
5. Calculate confidence score for grouping strategy
6. Return grouping proposal with rationale
7. DO NOT save files yet - return content and confidence score"
```

### 2. Interactive Grouping Review
After receiving grouper's proposal:
1. Present grouping strategy with confidence score
2. Show file distribution across groups
3. Ask user: **"Accept this grouping? (yes/no/modify)"**
4. If modify: collect feedback and re-run grouper with adjustments
5. If yes: proceed to save grouping

### 3. Save Grouping Strategy
After user approval, save to: `./.claude/commitcraft/{session_name}/01-grouping-strategy.md`

## 🛑 Grouping Approval Gate

After grouping strategy is finalized:
```markdown
📦 Grouping Strategy Complete
════════════════════════════

Proposed {groups_count} commits:
1. {group_1_name} ({files_count} files)
2. {group_2_name} ({files_count} files)
...

Confidence: {confidence_score}%

Proceed with message generation? (yes/no)
```
**WAIT for user response**. Only proceed if user confirms.

## Phase 2: Message Generation & Validation

**ONLY execute after receiving grouping approval**

### 1. Generate Messages for Each Group
```
For each group, use Task tool with commit-message agent:
"Session Path: ./.claude/commitcraft/{session_name}/
Previous Documents:
- 00-repository-analysis.md (change analysis)
- 01-grouping-strategy.md (grouping decisions)

Generate professional commit message for:
Group: {group_name}
Files: {file_list}
Language: {--language option or auto}

Instructions:
1. Read 01-grouping-strategy.md to understand this group's purpose and rationale
2. Follow Conventional Commits format
3. Clear subject line (50-72 chars)
4. Detailed body explaining what and why based on group context
5. Return message content only - DO NOT save files"
```

Save all messages to: `./.claude/commitcraft/{session_name}/02-commit-messages.md`

### 2. Validate Each Message
```
For each message, use Task tool with commit-validator agent:
"Session Path: ./.claude/commitcraft/{session_name}/
Previous Documents Available:
- 00-repository-analysis.md
- 01-grouping-strategy.md
- 02-commit-messages.md

Validate commit message:
Message: {generated_message}
Files: {group_files}

Instructions:
1. Read grouping strategy to understand group context
2. Validate message accurately describes the changes
3. Apply validation criteria:
   - Format compliance (30 points)
   - Content quality (40 points)
   - Security check (20 points)
   - Convention adherence (10 points)
4. Return validation score and issues - DO NOT save files"
```

Save validation report to: `./.claude/commitcraft/{session_name}/03-validation-report.md`

## 🛑 Commit Approval Gate

After validation completes:
```markdown
✅ Validation Complete
═════════════════════

Quality Scores:
- Commit 1: {score_1}/100
- Commit 2: {score_2}/100
Average: {avg_score}/100

All commits meet quality standards.
Execute commits now? (yes/no)
```
**CRITICAL**: MUST STOP here and wait for user approval.
Only proceed to Phase 3 if user explicitly confirms.

## Phase 3: Execution Process (After Approval Only)

**ONLY execute after receiving explicit user approval**

### Execute Each Commit
```
For each approved group, use Task tool with commit-executor agent:
"Session Path: ./.claude/commitcraft/{session_name}/
Previous Documents Available:
- 01-grouping-strategy.md (file lists)
- 02-commit-messages.md (approved messages)
- 03-validation-report.md (quality confirmation)

Execute commit for group: {group_name}
Message: {approved_message}
Files: {group_files}

Instructions:
1. Optionally read validation report to confirm this commit is approved
2. Stage specified files exactly as listed
3. Create commit with the provided message
4. Capture commit hash
5. Return execution result - DO NOT save files"
```

Save execution log to: `./.claude/commitcraft/{session_name}/04-execution-log.md`

### Generate Session Summary
After all commits complete, create summary:
```json
{
  "session_id": "{session_name}",
  "timestamp": "{completion_time}",
  "commits_created": {count},
  "files_processed": {count},
  "average_quality": {score},
  "status": "success"
}
```
Save to: `./.claude/commitcraft/{session_name}/summary.json`

## Batch Processing Mode

When using `--batch`, the pilot processes multiple feature groups sequentially:

```
🔄 Batch Commit Progress
════════════════════════

Queue:
✅ 1. Infrastructure setup - COMPLETED
⏳ 2. User authentication - IN PROGRESS
⌛ 3. Documentation updates - PENDING

Current: Creating commit for user authentication...
Message: feat(auth): ✨ implement OAuth2 authentication

[████████░░░░░░░░░░] 45% Complete
```

## Context Accumulation

Each agent receives accumulated context from previous agents:

```yaml
context:
  repository:
    branch: main
    last_commit: abc123
    changes: [...]

  analysis:           # From commit-analyzer
    features: [...]
    dependencies: [...]

  grouping:          # From commit-grouper
    strategy: batch
    groups: [...]

  messages:          # From commit-message
    generated: [...]
    language: en

  validation:        # From commit-validator
    scores: [...]
    issues: []
```

## Error Recovery

### Automatic Retry
- Message generation: Up to 3 attempts if quality < 90
- Validation failures: Suggestions provided for fixes
- Execution failures: Rollback and retry options

### Manual Intervention
- Edit generated messages inline
- Adjust file groupings interactively
- Override quality checks with justification
- Skip problematic files

## Success Reporting

```
✅ Commit Pilot Complete
════════════════════════

Duration: 35 seconds
Commits created: 3
Files processed: 12
Average quality: 94/100

Commit Summary:
├─ abc123: feat(auth): ✨ add OAuth2 authentication
├─ def456: feat(user): ✨ implement profile management
└─ ghi789: docs(api): 📝 update API documentation

All commits validated and executed successfully.
Repository is now clean.
```

## Repository-Aware Features

The pilot maintains awareness of:
- Current branch and its protection rules
- Recent commit patterns and conventions
- Team's commit message style
- File change patterns and dependencies
- CI/CD requirements

## Smart Defaults

When using `--quick` mode:
- Auto-detects logical file groupings
- Generates messages based on file patterns
- Uses repository's commit history for style
- Applies most common type (feat/fix/docs)
- Skips confirmations if confidence > 95%

## Language Intelligence

### Auto-Detection Logic
1. Analyze recent commit messages
2. Check code comments language
3. Scan documentation files
4. Use repository's primary language

### Bilingual Support
- English templates for international projects
- Chinese templates for local projects
- Mixed language handling for global teams
- Consistent emoji usage across languages

## Integration Points

- Works with existing git hooks
- Compatible with CI/CD pipelines
- Integrates with issue tracking (detects #123 patterns)
- Supports conventional commits standard
- Handles signed commits (GPG)

## Safety Features

- Prevents commits to protected branches without confirmation
- Detects and blocks sensitive data (API keys, passwords)
- Validates file permissions before staging
- Checks for merge conflicts before execution
- Maintains backup for rollback capability

## Performance Optimization

- Parallel analysis for large repositories
- Cached file analysis for repeated runs
- Incremental processing for partial commits
- Smart batching for multiple features
- Minimal git operations for speed

## Troubleshooting

Use `--debug` flag for verbose output:
```bash
/commit-pilot --debug --preview
```

Common issues:
- "No changes detected": Check if files are saved
- "Quality score too low": Review message format guidelines
- "Grouping failed": Try manual selection with `/group`
- "Execution failed": Check git configuration and permissions

## Process Documentation Structure

All outputs saved to `./.claude/commitcraft/{session_name}/`:
```
.claude/
└── commitcraft/
    └── commitcraft-20240117-143025/     # Session directory
        ├── 00-repository-analysis.md    # Initial change analysis
        ├── 01-grouping-strategy.md      # File grouping decisions
        ├── 02-commit-messages.md        # Generated messages
        ├── 03-validation-report.md      # Quality validation results
        ├── 04-execution-log.md         # Commit execution details
        └── summary.json                 # Session summary with metrics
```

## Important Implementation Notes

### DO:
- **Create session directory first**: Ensure `./.claude/commitcraft/{session_name}/` exists before any saves
- **Agents return content only**: Use "DO NOT save files - return content" in all agent prompts
- **Orchestrator saves documents**: After receiving agent responses, save to appropriate files
- **Stop at approval gates**: MUST wait for explicit user confirmation at critical points
- **Include timestamp in session name**: Format as `commitcraft-YYYYMMDD-HHMMSS`
- **Pass context between agents**: Each agent receives accumulated context from previous phases

### DON'T:
- Let agents save files directly (they should only return content)
- Skip user approval gates (unless --quick option is used)
- Proceed without meeting quality thresholds
- Create documentation if --skip-docs option is provided

## Related Commands

- `/analyze` - Standalone repository analysis
- `/group` - Manual file grouping
- `/validate` - Validate commit messages
- `/batch-commit` - Direct batch processing
- `/commit-history` - Analyze past commits