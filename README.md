# 🚀 CommitCraft - Intelligent Git Commit Multi-Agent System

<div align="center">

[![Version](https://img.shields.io/badge/version-3.0.0-blue)]()
[![License](https://img.shields.io/badge/license-MIT-green)]()
[![Claude Code](https://img.shields.io/badge/Claude-Code-purple)]()
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)]()

**Transform your Git workflow from manual commits to intelligent orchestration with 95% quality assurance**

[🇨🇳 中文文档](docs/README-zh.md) | [🇬🇧 English](README.md) | [📖 User Guide](PILOT-USER-GUIDE.md)

</div>

---

## 🎯 Why CommitCraft?

> **"From chaotic commits to professional precision in one command"**

Traditional Git workflows suffer from:
- 😩 Inconsistent commit messages across teams
- 🎯 Poor commit scope and organization
- 📝 Missing context and documentation
- 🔀 Mixed features in single commits
- ⚠️ Security risks from exposed credentials

**CommitCraft solves this with:**
- ✅ **95% Quality Guarantee** - Every commit meets professional standards
- 🤖 **5 Expert AI Agents** - Specialized analysis, grouping, generation, validation, execution
- 🚀 **One-Command Workflow** - `/commit-pilot` orchestrates everything
- 📚 **Process Documentation** - Automatic execution tracking and audit trail
- 🔒 **Security First** - Built-in credential detection and dangerous operation blocking
- 🌍 **True Cross-Platform** - Native support for Windows, macOS, Linux

## 🌟 Revolutionary Features

### 🎭 Multi-Agent Orchestration
```mermaid
graph LR
    A[Your Changes] --> B[Analyzer Agent]
    B --> C[Grouper Agent]
    C --> D[Message Agent]
    D --> E[Validator Agent]
    E --> F[Executor Agent]
    F --> G[Perfect Commit ✅]
```

### 🎯 Intelligent Workflows

#### 1️⃣ **Smart Commit Pilot** - Complete automation with documentation
```bash
/commit-pilot
# → Analyzes all changes
# → Groups by features
# → Generates messages
# → Validates quality (90+ score)
# → Executes commits
# → Creates process documentation (.claude/commitcraft/session-*)
```

#### 2️⃣ **Batch Processing** - Multiple features, separate commits
```bash
/batch-commit
# → Detects multiple features
# → Creates separate perfect commits
# → Maintains dependencies
# → Documents each commit process
```

#### 3️⃣ **History Learning** - Improve from the past
```bash
/commit-history --score
# → Analyzes past commits
# → Identifies patterns
# → Suggests improvements
```

#### 4️⃣ **Process Documentation** - Complete traceability (NEW!)
```bash
# Automatically generated for each session
.claude/commitcraft/
└── commitcraft-20240117-143025/
    ├── 00-repository-analysis.md   # Repository scan
    ├── 01-grouping-strategy.md     # Grouping decisions
    ├── 02-commit-messages.md       # Generated messages
    ├── 03-validation-report.md     # Quality validation
    ├── 04-execution-log.md         # Execution details
    └── summary.json                # Session summary
```

## ⚡ Quick Start

### 📦 Installation (30 seconds)

<details>
<summary><b>🪟 Windows</b></summary>

```powershell
# Option 1: Batch installer
./install.bat

# Option 2: PowerShell
powershell -ExecutionPolicy Bypass -File install.ps1
```
</details>

<details>
<summary><b>🍎 macOS / 🐧 Linux</b></summary>

```bash
# Make executable and run
chmod +x install.sh && ./install.sh
```
</details>

### 🚀 Your First Professional Commit

```bash
# 1. Make your changes
code src/feature.js

# 2. Run CommitCraft
/commit-pilot

# 3. Watch the magic ✨
```

**Output:**
```
📊 Repository Analysis Complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━
Changed files: 5
Features detected: 2
Quality forecast: 94/100

Continue with orchestration? (Y/n)
```

## 🏗️ Architecture Deep Dive

### 🤖 The Five Expert Agents

| Agent | Role | Specialization |
|-------|------|----------------|
| 🔍 **commit-analyzer** | Repository Scanner | Change detection, dependency mapping, risk assessment |
| 📁 **commit-grouper** | Organization Expert | Feature separation, logical grouping, coupling detection |
| ✍️ **commit-message** | Message Craftsman | Professional messages, bilingual support, convention compliance |
| ✅ **commit-validator** | Quality Guardian | 90+ scoring, security checks, format validation |
| 🚀 **commit-executor** | Safe Operator | Atomic commits, rollback capability, verification |

### 🔄 Workflow Pipeline

```
┌─────────────────────────────────────────────────────┐
│                  PHASE 0: SCANNING                   │
│         Comprehensive repository analysis            │
└─────────────────────────┬───────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────┐
│                 PHASE 1: GROUPING                    │
│      Intelligent file organization by feature        │
│                  [User Gate 🚪]                      │
└─────────────────────────┬───────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────┐
│                PHASE 2: GENERATION                   │
│        Professional message creation                 │
│              Quality Gate (≥90) 🎯                   │
└─────────────────────────┬───────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────┐
│                PHASE 3: EXECUTION                    │
│          Safe commit with verification               │
│               [Final Gate 🚪]                        │
└─────────────────────────┬───────────────────────────┘
                          ↓
                    ✅ SUCCESS
```

## 📊 Real-World Examples

### Example 1: Multi-Feature Development
```bash
$ /commit-pilot --batch

🔄 Batch Commit Progress
════════════════════════
✅ Infrastructure setup     [Score: 96]
⏳ User authentication      [Processing...]
⌛ API documentation        [Pending]

Current: feat(auth): ✨ implement OAuth2 flow
[████████░░░░] 66% Complete
```

### Example 2: Quality Validation
```bash
$ /validate "fix: bug"

📊 Validation Report
━━━━━━━━━━━━━━━━━━━
Format:      15/25 ❌
Clarity:     10/25 ❌
Security:    25/25 ✅
Convention:  12/25 ❌
━━━━━━━━━━━━━━━━━━━
Total:       62/100

Status: FAILED ❌

Suggestions:
1. Add specific scope: fix(auth): ...
2. Describe the actual bug fixed
3. Consider adding emoji: 🐛
```

## 🛡️ Security Features

### 🔐 Built-in Protection
- **Credential Detection** - Blocks API keys, passwords, tokens
- **Dangerous Operation Prevention** - No `rm -rf`, force push protection
- **Sensitive File Guards** - Protects .env, config files
- **Pre-commit Validation** - Security scan before every commit

### 🪝 Cross-Platform Hooks
```javascript
// Automatic security validation
hooks/pre-tool-use.js     → Command validation
hooks/user-prompt-submit.js → Input enhancement
```

## 📈 Quality Metrics

### Scoring System (0-100)
```
95-100: 🏆 Perfect   - Ship immediately
90-94:  ✅ Excellent - Minor improvements optional
80-89:  ⚠️ Good      - Improvements recommended
<80:    ❌ Failed    - Must fix issues
```

### What We Measure
- **Format Compliance** - Type, scope, emoji usage
- **Message Clarity** - Descriptive, specific, grammatical
- **Security Standards** - No exposed secrets, safe operations
- **Convention Adherence** - Team standards, consistency

## 🎨 Customization

### Commit Types & Emojis
```javascript
feat:     ✨ New feature
fix:      🐛 Bug fix
docs:     📝 Documentation
style:    💄 Formatting
refactor: ♻️  Code refactoring
perf:     ⚡ Performance
test:     ✅ Testing
chore:    🔧 Maintenance
build:    📦 Build system
ci:       💚 CI/CD
```

### Language Support
```bash
# Auto-detect from repository
/commit-pilot

# Force language
/commit-pilot --language en  # English
/commit-pilot --language ch  # Chinese
```

## 📚 Advanced Usage

### 🔄 Workflow Modes

<details>
<summary><b>Interactive Mode (Default)</b></summary>

```bash
/commit-pilot
# → Step-by-step with confirmations
# → Perfect for important commits
# → Maximum control
```
</details>

<details>
<summary><b>Quick Mode</b></summary>

```bash
/commit-pilot --quick
# → Smart defaults
# → Skip confirmations
# → Fast workflow
```
</details>

<details>
<summary><b>Preview Mode</b></summary>

```bash
/commit-pilot --preview
# → Dry run
# → No actual commits
# → Safe testing
```
</details>

### 📊 History Analysis
```bash
# Analyze team patterns
/commit-history --last 100 --export markdown

# Personal improvement
/commit-history --author me --score
```

## 🚦 Integration

### Works Seamlessly With:
- ✅ **Git Hooks** - Pre-commit, commit-msg validation
- ✅ **CI/CD** - GitHub Actions, GitLab CI, Jenkins
- ✅ **Issue Trackers** - Auto-links (#123)
- ✅ **Conventional Commits** - Full compliance
- ✅ **GPG Signing** - Signed commit support

## 📖 Documentation

- 📘 [Complete User Guide](PILOT-USER-GUIDE.md)
- 🔧 [Agent Documentation](agents/)
- 📝 [Command Reference](commands/)
- 🇨🇳 [中文文档](docs/README-zh.md)

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md)

```bash
# Run quality checks before PR
/validate
/commit-pilot --preview
```

## 📄 License

MIT License - see [LICENSE](LICENSE)

## 🙏 Acknowledgments

Built with ❤️ for the Claude Code community

Special thanks to:
- Anthropic Claude team for the amazing platform
- Open source contributors
- Early adopters and feedback providers

## 📮 Support

- 🐛 **Issues**: [GitHub Issues](https://github.com/your-username/commitcraft/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/your-username/commitcraft/discussions)
- 📧 **Email**: support@commitcraft.dev

---

<div align="center">

### 🌟 Star us on GitHub!

**CommitCraft** - Where every commit tells a perfect story

`Version 3.0.0` | `MIT License` | `Made for Claude Code`

</div>