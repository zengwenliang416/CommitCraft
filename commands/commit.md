---
name: commit
description: Interactive git commit with smart file grouping and quality validation
---

Generate professional git commit messages with intelligent file analysis and user confirmation.

## Usage

```
/commit [language] [options]
```

**Language Options:**
- `en` or `eng` - English (default)
- `ch` or `中文` - Chinese
- No parameter - Will prompt for language selection

**Mode Options:**
- `--interactive` - Full file-by-file selection
- `--preview` - Preview mode without committing
- `--batch` - Handle multiple feature commits

## Interactive Workflow

### 1. File Analysis
Automatically analyzes all changed files and groups them by feature/module.

### 2. User Confirmation
```
📊 Change Analysis
━━━━━━━━━━━━━━━━━━━
Modified: X files
Features detected: Y

Options:
1. Commit by feature
2. Commit all together
3. Custom selection

Your choice: _
```

### 3. Commit Preview
Shows the complete commit message before execution for approval.

### 4. Quality Validation
Validates format compliance and provides a quality score (must be ≥90 to proceed).

## Examples

**Basic usage:**
```
/commit
```
Analyzes changes and provides interactive options.

**Chinese commit:**
```
/commit ch
```
Generates commit message in Chinese.

**Preview only:**
```
/commit --preview
```
Shows what would be committed without executing.

**Batch mode:**
```
/commit --batch
```
Handles multiple features with separate commits.

## Output Format

The agent provides structured output:
- Clear analysis of changes
- Interactive selection options
- Preview before execution
- Quality validation score
- No signatures or attribution

## Commit Message Format

```
<type>(<scope>): <emoji> <description>


- Detail point 1
- Detail point 2
- Detail point 3
```

**Types:** feat, fix, docs, style, refactor, perf, test, chore, ci, build

The agent ensures all commits follow this standardized format with proper validation.