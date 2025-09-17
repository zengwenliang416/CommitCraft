---
name: group
description: Intelligent file grouping for logical commit organization
---

## Usage

```
/group [OPTIONS]
```

Organize changed files into logical groups for clean, focused commits.

## Options

- `--auto` - Automatic grouping without interaction
- `--by-feature` - Group by detected features
- `--by-layer` - Group by architecture layers
- `--custom` - Manual file selection

## Workflow

Execute the **commit-grouper** agent to intelligently organize files based on features, dependencies, and logical boundaries.

The agent will:
1. Analyze file relationships and dependencies from previous analysis
2. Detect feature boundaries and module separations
3. Identify coupled files that span multiple features
4. Present interactive grouping options for user confirmation
5. Handle dependency ordering for clean commits

## Interactive Process

### Step 1: Present Grouping Analysis
Display initial grouping confidence and statistics

### Step 2: Show Grouping Proposals
```
📁 File Grouping Options
━━━━━━━━━━━━━━━━━━━━━━

Detected Groups:
1. Feature A (N files)
2. Feature B (M files)
3. Shared Utils (K files)

Actions:
[1] Commit separately
[2] Combine groups
[3] Custom selection
[4] View dependencies
```

### Step 3: Handle Coupled Files
For files affecting multiple features, provide resolution options:
- Include with specific feature
- Create separate commit
- Custom handling

## Grouping Strategies

### Feature-Based
Files belonging to the same feature or module

### Layer-Based
Frontend / Backend / Database / Configuration

### Dependency-Based
Core changes before dependent changes

## Output Requirements

### Grouping Result
Return structured grouping with:
- Group names and descriptions
- File lists per group
- Suggested commit order
- Coupling warnings

### User Confirmation
Require explicit approval before proceeding:
- Display final grouping
- Allow modifications
- Confirm selection

## Quality Criteria

Grouping quality is measured by:
- **Cohesion**: Files in same group are related (target: >85%)
- **Separation**: Minimal coupling between groups
- **Size**: Groups are reasonably sized (2-10 files ideal)
- **Order**: Dependency chain is respected

## Integration Context

This grouping feeds into:
- `/commit-pilot` - Uses grouping for organized commits
- `/batch-commit` - Enables multiple sequential commits
- Message generation for appropriate commit scope