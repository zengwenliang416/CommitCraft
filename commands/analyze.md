---
name: analyze
description: Deep repository analysis for understanding code changes
---

## Usage

```
/analyze [OPTIONS]
```

Perform comprehensive repository analysis to understand all changes, dependencies, and feature boundaries.

## Options

- `--detailed` - Include line-by-line diff analysis
- `--summary` - Quick summary only
- `--dependencies` - Focus on file dependencies

## Workflow

Execute the **commit-analyzer** agent to perform deep repository change analysis.

The agent will:
1. Execute `git status --porcelain` to capture all repository changes
2. Classify changes by type (modified/added/deleted/renamed)
3. Detect feature boundaries and logical groupings
4. Map file interdependencies and coupling
5. Assess risk levels and impact scope

## Output Requirements

### Summary Section
```
📊 Repository Analysis Complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total Changes: X files
Features Detected: Y
Dependencies: Z coupled files
Risk Level: Low/Medium/High
```

### Feature Breakdown
Display detected features with file counts and categorization:
- Group files by logical features
- Identify shared utilities
- Highlight coupled dependencies

### Recommendations
Provide actionable insights:
- Suggested commit strategy
- Warning about large changes
- Dependency order if relevant

## Integration Context

This analysis feeds directly into:
- `/group` - Uses analysis data for intelligent grouping
- `/commit-pilot` - Incorporates analysis into full workflow
- `/validate` - Leverages analysis for quality checks

## Success Criteria

The analysis is considered successful when:
- All changed files are identified and categorized
- Feature boundaries are clearly detected
- Dependencies are properly mapped
- Risk assessment is provided
- Clear recommendations are generated