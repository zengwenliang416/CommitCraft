---
name: commit-pilot
description: Multi-agent orchestrator for intelligent git commit workflow
arguments: "[COMMIT_DESCRIPTION]"
options: "[--help] [--batch] [--quick] [--preview] [--skip-validation] [--language <en|ch>]"
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

## Workflow Phases

### Phase 0: Repository Context Scanning
The pilot begins with comprehensive repository analysis to understand the current state and changes.

### Phase 1: Change Analysis & Grouping
Intelligent file grouping based on features, dependencies, and logical boundaries.

### Phase 2: Commit Planning
Generate professional commit messages with quality validation and user confirmation.

### Phase 3: Execution
Safe, verified commit execution with rollback capabilities.

## Sub-Agent Chain Execution

Execute the following sub-agent chain:

First use the **commit-analyzer** sub agent to analyze repository changes and identify feature boundaries, then use the **commit-grouper** sub agent to organize files into logical commit groups with user confirmation, then use the **commit-message** sub agent to generate professional commit messages in the appropriate language, then use the **commit-validator** sub agent to validate quality (must achieve 90+ score), and finally use the **commit-executor** sub agent to safely stage and commit the changes.

The workflow includes quality gates between phases requiring explicit user approval before proceeding.

## Quality Gates

### Gate 1: Grouping Confirmation (Phase 1)
- **Requirement**: User must approve file grouping strategy
- **Options**: Approve, regroup, or manual selection
- **Bypass**: Use `--quick` to auto-approve sensible groupings

### Gate 2: Message Quality (Phase 2)
- **Requirement**: Quality score must be ≥ 90/100
- **Validation**: Format, clarity, security, conventions
- **Bypass**: Use `--skip-validation` (not recommended)

### Gate 3: Execution Approval (Phase 3)
- **Requirement**: Final user confirmation before commit
- **Preview**: Complete diff and message shown
- **Bypass**: Use `--quick` for auto-confirmation

## Interactive Decision Flow

```
┌─────────────────────────────────────┐
│  📊 Repository Analysis Complete     │
│  ═══════════════════════════════    │
│  Changed files: 12                  │
│  Features detected: 3                │
│  Recommended strategy: Batch         │
│                                      │
│  Continue with analysis? (Y/n)      │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│  📁 File Grouping Proposal          │
│  ═══════════════════════════════    │
│  Group 1: Authentication (4 files)  │
│  Group 2: User Profile (5 files)    │
│  Group 3: Shared Utils (3 files)    │
│                                      │
│  [1] Approve grouping               │
│  [2] Modify grouping                 │
│  [3] View details                   │
│  Select: _                          │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│  ✅ Quality Validation Passed       │
│  ═══════════════════════════════    │
│  Score: 95/100                      │
│  Format: ✓ | Security: ✓ | Style: ✓ │
│                                      │
│  Proceed with commit? (Y/n)         │
└─────────────────────────────────────┘
```

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

## Related Commands

- `/analyze` - Standalone repository analysis
- `/group` - Manual file grouping
- `/validate` - Validate commit messages
- `/batch-commit` - Direct batch processing
- `/commit-history` - Analyze past commits