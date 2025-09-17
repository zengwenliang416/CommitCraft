---
name: commit-history
description: Comprehensive commit history analysis and quality assessment
---

## Usage

```
/commit-history [OPTIONS]
```

Analyze repository commit history to identify patterns, measure quality, and provide improvement insights.

## Options

- `--last <n>` - Analyze last N commits (default: 10)
- `--author <name>` - Filter by specific author
- `--branch <name>` - Analyze specific branch
- `--score` - Include quality scoring for each commit
- `--export <format>` - Export analysis (markdown/json/csv)
- `--since <date>` - Analyze commits since date
- `--pattern <type>` - Focus on specific patterns

## Workflow

Execute a comprehensive multi-agent analysis chain to assess commit history quality and provide actionable improvements.

### Phase 1: History Collection
First use the **commit-analyzer** sub agent to collect and parse git history, extracting commit metadata, messages, and change patterns from the repository log.

### Phase 2: Quality Assessment
Then use the **commit-validator** sub agent to score each historical commit, evaluating format compliance, message clarity, and convention adherence.

### Phase 3: Pattern Analysis
Finally, use a specialized analysis process to identify trends, common issues, and improvement opportunities across the commit history.

## Analysis Pipeline

### Initial Data Gathering
```
🔍 Analyzing Commit History
━━━━━━━━━━━━━━━━━━━━━━━━━

Fetching commits...
Branch: main
Range: Last 30 days
Authors: All

Processing: [████████░░] 80%
```

### Quality Scoring Process
Each commit undergoes comprehensive evaluation:
1. Format validation (type, scope, emoji)
2. Message clarity assessment
3. Convention compliance check
4. Security scanning for sensitive data
5. Overall quality score calculation

## Output Display

### Summary Dashboard
```
📊 Commit History Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━

Period: 2024-01-01 to 2024-01-31
Total Commits: 142
Unique Authors: 5
Average Quality: 87/100

Quality Trend: ↑ Improving
Best Day: Tuesday (avg 91/100)
Peak Hours: 10am-12pm

Top Types:
├─ feat (45%) - 64 commits
├─ fix (28%) - 40 commits
├─ docs (15%) - 21 commits
└─ other (12%) - 17 commits
```

### Detailed Quality Metrics
```
📈 Quality Breakdown
━━━━━━━━━━━━━━━━━━━

Format Compliance:    92% ████████░░
Message Clarity:      88% ████████░░
Convention Following: 95% █████████░
Security Validation: 100% ██████████

Issues Detected:
⚠️ 8 commits missing scope
⚠️ 5 commits with vague messages
⚠️ 3 commits exceeding 72 chars
✅ 0 security issues found
```

## Pattern Recognition

### Trend Analysis
```
📊 Commit Patterns
━━━━━━━━━━━━━━━━━

Weekly Distribution:
Mon ████░░░░░░ 15%
Tue █████████░ 28%
Wed ███████░░░ 22%
Thu ██████░░░░ 18%
Fri █████░░░░░ 17%

Type Evolution (30 days):
Week 1: feat-heavy (60%)
Week 2: fix-focused (45%)
Week 3: balanced (mixed)
Week 4: docs surge (35%)
```

### Author Analytics
```
👥 Contributor Analysis
━━━━━━━━━━━━━━━━━━━━━

Top Contributors:
1. Alice Chen (35%)
   Quality: 94/100 ⭐
   Specialty: Features
   Best practice follower

2. Bob Smith (28%)
   Quality: 88/100
   Specialty: Bug fixes
   Improving trend ↑

3. Carol Davis (20%)
   Quality: 91/100
   Specialty: Documentation
   Consistent quality
```

## Quality Insights

### Best Practices Identification
```
🌟 Exemplary Commits
━━━━━━━━━━━━━━━━━━━

1. feat(auth): ✨ implement OAuth2 authentication
   Score: 98/100

   Strengths:
   • Clear, specific scope
   • Appropriate emoji usage
   • Detailed body explanation
   • References issue #123

2. fix(api): 🐛 resolve rate limiting race condition
   Score: 96/100

   Strengths:
   • Precise problem description
   • Technical accuracy
   • Includes reproduction steps
```

### Common Issues Detection
```
⚠️ Improvement Areas
━━━━━━━━━━━━━━━━━━

1. Message Clarity (affects 23% of commits)
   Problem: "fix bug" → Too vague
   Solution: "fix(auth): resolve login timeout issue"

2. Missing Context (affects 31% of commits)
   Problem: No body details
   Solution: Add 2-3 bullet points explaining changes

3. Inconsistent Format (affects 15% of commits)
   Problem: Mixed conventions
   Solution: Adopt team standard consistently
```

## Learning Recommendations

### Personalized Suggestions
Based on historical analysis, generate targeted improvements:

```
📚 Your Improvement Plan
━━━━━━━━━━━━━━━━━━━━━

Based on your last 50 commits:

Priority 1: Message Clarity
• Current: 75% clear messages
• Target: 90% clarity
• Action: Use specific verbs and scopes

Priority 2: Body Details
• Current: 45% have bodies
• Target: 70% with context
• Action: Add bullet points for complex changes

Priority 3: Convention Compliance
• Current: 85% compliant
• Target: 95% compliance
• Action: Review team conventions guide
```

## Export Capabilities

### Report Generation
Execute export workflow to create shareable analysis:

```
📄 Export Options
━━━━━━━━━━━━━━━━

Format: Markdown
Content: Full analysis
Period: Last 30 days

Sections included:
✅ Summary statistics
✅ Quality metrics
✅ Author breakdown
✅ Pattern analysis
✅ Recommendations

Generating report...
Output: commit-history-2024-01.md
```

## Integration Points

### Workflow Connections
This analysis integrates with:
- **commit-validator**: Apply quality standards learned from history
- **commit-message**: Use patterns from high-scoring commits
- **commit-pilot**: Incorporate best practices into new commits
- **batch-commit**: Avoid historical mistakes in batch processing

### Continuous Improvement Loop
```
History Analysis → Pattern Recognition → Quality Standards → Better Commits
        ↑                                                           ↓
        ←←←←←←←←←←← Feedback Loop ←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←
```

## Success Criteria

History analysis succeeds when:
- All requested commits are analyzed
- Quality scores are calculated accurately
- Patterns and trends are identified
- Actionable improvements are provided
- Export format is generated correctly

## Advanced Features

### Comparative Analysis
Compare different time periods or branches:
```
/commit-history --compare "last-month vs this-month"
/commit-history --compare "main vs develop"
```

### Team Benchmarking
Establish quality baselines:
```
/commit-history --benchmark --team
```

### Custom Scoring Rules
Apply project-specific quality criteria:
```
/commit-history --rules ./commit-rules.yaml
```