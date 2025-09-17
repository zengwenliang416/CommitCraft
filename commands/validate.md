---
name: validate
description: Quality validation for commit messages and conventions
---

## Usage

```
/validate [MESSAGE] [OPTIONS]
```

Ensure commit messages meet quality standards and follow conventions before execution.

## Options

- `--strict` - Enforce all rules (require 100 score)
- `--security` - Focus on security validation
- `--format` - Check format compliance only

## Workflow

Execute the **commit-validator** agent to validate commit quality and ensure professional standards.

The agent will:
1. Parse and analyze the commit message structure
2. Validate format compliance (type, scope, emoji, length)
3. Check content quality (clarity, grammar, completeness)
4. Perform security scanning for sensitive data
5. Score overall quality (must achieve ≥90/100)

## Validation Process

### Phase 1: Format Validation
Check structural elements:
- Valid commit type (feat/fix/docs/etc.)
- Meaningful scope
- Appropriate emoji
- Header ≤72 characters
- Proper body formatting

### Phase 2: Content Quality
Assess message quality:
- Clarity of description
- Grammar and spelling
- Completeness of information
- Appropriate detail level

### Phase 3: Security Validation
Scan for sensitive data:
- API keys and tokens
- Passwords and secrets
- Private keys
- Connection strings
- Personal information

## Quality Scoring System

```
📊 Validation Report
━━━━━━━━━━━━━━━━━━━

Format:      25/25 ✅
Clarity:     23/25 ✅
Security:    25/25 ✅
Convention:  22/25 ✅
━━━━━━━━━━━━━━━━━━━
Total:       95/100

Grade: A (Excellent)
Status: PASSED ✅
```

## Quality Gate Mechanism

### Scoring Thresholds
- **95-100**: Perfect, proceed immediately
- **90-94**: Excellent, minor improvements optional
- **80-89**: Good, improvements recommended
- **<80**: Failed, must fix issues

### Iteration Process
If score <90:
1. Provide specific improvement suggestions
2. Allow message editing
3. Re-validate after changes
4. Maximum 3 iterations

## Error Handling

When validation fails, provide:
- Specific issues identified
- Clear fix suggestions
- Auto-correction options where possible
- Examples of proper format

## Output Requirements

### Success Case
Display validation passed with score and breakdown

### Failure Case
Show:
- Failed checks with explanations
- Suggested corrections
- Option to auto-fix or manual edit
- Re-validation pathway

## Integration Context

Validation integrates with:
- `/commit-pilot` - Part of quality gate system
- `/batch-commit` - Validates each commit
- Message generation for quality assurance

## Success Criteria

Validation succeeds when:
- Score ≥90/100 achieved
- No security issues detected
- Format fully compliant
- User approves message
- All conventions followed