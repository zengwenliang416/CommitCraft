---
name: batch-commit
description: Sequential multi-feature commit orchestration with process documentation
tools: Task, Write, Bash, Glob, Grep
---

## Usage

```
/batch-commit [OPTIONS]
```

Process multiple features as separate commits in a single workflow session.

## Options

- `--auto` - Auto-detect and commit features without interaction
- `--plan` - Preview commit plan before execution
- `--continue` - Resume interrupted batch session
- `--order <strategy>` - Specify commit order (dependencies/size/alpha)
- `--skip-docs` - Skip process documentation generation

## Your Role
You are the Batch Commit Orchestrator managing sequential multi-feature commits. You coordinate specialized agents to process multiple features as separate commits while maintaining comprehensive documentation.

## Initial Setup Phase

### Session Initialization
Upon receiving this command, first create a session for documentation:

```bash
# Generate batch session ID
session_name="batch-$(date +%Y%m%d-%H%M%S)"

# Create session directory (unless --skip-docs)
mkdir -p ./.claude/commitcraft/{session_name}/
```

## Workflow

Execute a coordinated multi-agent chain for processing multiple feature commits sequentially.

### Phase 0: Repository Analysis
First use the **commit-analyzer** sub agent to perform comprehensive repository analysis:

```
Use Task tool with commit-analyzer agent: "
Perform comprehensive batch commit analysis.

Identify:
1. All changes in repository
2. Natural feature boundaries
3. Dependencies between files
4. Optimal commit order

Return analysis report - DO NOT save files"
```

Save analysis to: `./.claude/commitcraft/{session_name}/00-batch-analysis.md`

### Phase 1: Feature Group Detection
Use the **commit-grouper** sub agent to identify feature groups:

```
Use Task tool with commit-grouper agent: "
Session Path: ./.claude/commitcraft/{session_name}/
Previous Analysis: Available at 00-batch-analysis.md

Task: Create batch commit plan with multiple feature groups
Instructions:
1. Read analysis to understand all changes
2. Identify 2-5 natural feature boundaries
3. Order groups by dependencies
4. Return batch plan - DO NOT save files"
```

Save batch plan to: `./.claude/commitcraft/{session_name}/01-batch-plan.md`

### Phase 2: Sequential Commit Processing
For each identified feature group, execute this documented sub-chain:

```
For group N in groups:
    # 1. Generate message
    Use Task tool with commit-message agent:
    "Session: {session_name}, Group: {group_N}
     Generate message for files: {files}
     Return message - DO NOT save"

    Save to: ./.claude/commitcraft/{session_name}/02-group-{N}-message.md

    # 2. Validate
    Use Task tool with commit-validator agent:
    "Validate message: {message}
     Return score - DO NOT save"

    Save to: ./.claude/commitcraft/{session_name}/03-group-{N}-validation.md

    # 3. Execute if valid
    Use Task tool with commit-executor agent:
    "Execute commit with message: {message}
     Files: {files}
     Return result - DO NOT save"

    Save to: ./.claude/commitcraft/{session_name}/04-group-{N}-execution.md
```

Continue this process for all groups until all features are committed separately.

## Batch Planning Display

### Initial Analysis
```
🔄 Batch Commit Plan
━━━━━━━━━━━━━━━━━━━

Detected 3 feature groups:

1. Infrastructure (2 files)
   Priority: HIGH
   Dependencies: None

2. User Feature (4 files)
   Priority: MEDIUM
   Dependencies: Infrastructure

3. Documentation (3 files)
   Priority: LOW
   Dependencies: None

Commit Order: 1 → 2 → 3
```

### User Approval Gate
Require explicit confirmation before proceeding:
- Display complete batch plan
- Allow reordering if needed
- Confirm execution strategy

## Progress Tracking

```
📦 Batch Progress
━━━━━━━━━━━━━━━━

[✅] Infrastructure - COMPLETED
[⏳] User Feature - IN PROGRESS
[⌛] Documentation - PENDING

Current: Committing user feature...
Message: feat(user): ✨ add profile management

[████████░░░░░░░░] 66% Complete
```

## Quality Gate Mechanism

### Per-Commit Validation
Each commit must pass validation independently:
- Score ≥90/100 required
- Security checks passed
- Format compliance verified

### Iteration Handling
If validation fails for a group:
1. Provide improvement suggestions
2. Allow message editing
3. Re-validate after changes
4. Maximum 3 attempts per group

## Error Recovery

### Failure Scenarios
```
❌ Commit 2 of 4 failed

Options:
1. Retry this commit
2. Skip and continue
3. Rollback all commits
4. Pause batch

Select: _
```

### Resume Capability
- Save batch state after each successful commit
- Allow resuming from failure point
- Maintain commit order integrity

## Dependency Management

### Ordering Strategy
1. Analyze inter-file dependencies
2. Infrastructure/core changes first
3. Feature implementations second
4. Documentation/tests last

### Conflict Prevention
- Check for file conflicts between groups
- Warn about shared file modifications
- Suggest resolution strategies

## Output Requirements

### Batch Summary
Generate and save comprehensive summary after completion:

```
✅ Batch Complete
━━━━━━━━━━━━━━━━

Commits Created: 3
Total Files: 9
Time Taken: 45s
Average Quality: 94/100

Commit Log:
├─ abc123: feat(infra): ⚙️ update configuration
├─ def456: feat(user): ✨ add profile management
└─ ghi789: docs(api): 📝 update API documentation
```

### Individual Commit Details
For each commit provide:
- Commit hash
- Files included
- Quality score
- Validation status

## Success Criteria

Batch commit succeeds when:
- All groups are processed (or explicitly skipped)
- Each commit achieves ≥90 quality score
- No unresolved conflicts exist
- User confirms completion
- Repository is in clean state

## Process Documentation Structure

When documentation is enabled (default), all outputs saved to `./.claude/commitcraft/{session_name}/`:
```
.claude/
└── commitcraft/
    └── batch-20240117-143025/           # Batch session
        ├── 00-batch-analysis.md         # Initial analysis
        ├── 01-batch-plan.md            # Grouping plan
        ├── 02-group-1-message.md       # Group 1 message
        ├── 03-group-1-validation.md    # Group 1 validation
        ├── 04-group-1-execution.md     # Group 1 execution
        ├── 02-group-2-message.md       # Group 2 message
        ├── 03-group-2-validation.md    # Group 2 validation
        ├── 04-group-2-execution.md     # Group 2 execution
        └── summary.json                 # Batch summary
```

## Integration Context

This batch processing integrates with:
- Individual `/analyze` for initial analysis
- `/group` logic for feature separation
- `/validate` for quality assurance
- `/commit-pilot` as alternative for interactive mode