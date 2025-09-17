---
name: batch-commit
description: Sequential multi-feature commit orchestration
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

## Workflow

Execute a coordinated multi-agent chain for processing multiple feature commits sequentially.

### Phase 0: Repository Analysis
First use the **commit-analyzer** sub agent to perform comprehensive repository analysis, identifying all changes, feature boundaries, and dependencies.

### Phase 1: Feature Group Detection
Then use the **commit-grouper** sub agent to identify and separate feature groups, establishing the optimal commit order based on dependencies and logical boundaries.

### Phase 2: Sequential Commit Processing
For each identified feature group, execute this sub-chain:

1. Use the **commit-message** sub agent to generate an appropriate commit message for the feature
2. Use the **commit-validator** sub agent to validate quality (must achieve 90+ score)
3. If validation passes, use the **commit-executor** sub agent to stage and commit the files

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

## Integration Context

This batch processing integrates with:
- Individual `/analyze` for initial analysis
- `/group` logic for feature separation
- `/validate` for quality assurance
- `/commit-pilot` as alternative for interactive mode