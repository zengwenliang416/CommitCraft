# CommitCraft - Intelligent Git Commit Assistant

<div align="center">

[![Version](https://img.shields.io/badge/version-1.0.0-blue)]()
[![License](https://img.shields.io/badge/license-MIT-green)]()
[![Claude Code](https://img.shields.io/badge/Claude-Code-purple)]()

**Intelligent Git commit generator with interactive file grouping and quality validation**

[中文文档](/docs/README-zh.md) | [English](README.md)

</div>

---

## 🎯 Overview

CommitCraft is an intelligent Git commit assistant designed for Claude Code that helps developers create standardized, professional commit messages through smart file analysis, interactive confirmation, and quality validation systems. It's particularly useful for handling scenarios where multiple features are developed in parallel but need to be committed separately.

## ✨ Key Features

- **🤖 Intelligent File Analysis** - Automatically identifies and groups files by feature/module
- **📊 Interactive Workflow** - Requires explicit user confirmation at each critical step
- **🌐 Bilingual Support** - Supports both English and Chinese commit messages with auto-detection
- **🎯 Precise Staging** - Selective file staging, avoiding blind `git add .`
- **✅ Quality Validation** - Built-in quality scoring system, must score ≥90 to proceed
- **🔄 Batch Processing** - Smart handling of multi-feature separate commits
- **🚫 No Signatures** - Professional, clean output without any attribution text
- **📁 Coupled File Handling** - Intelligent detection and handling of shared files affecting multiple features

## 🚀 Quick Start

### Installation

1. **Clone or download the project**
```bash
git clone https://github.com/zengwenliang416/CommitCraft.git
cd CommitCraft
```

2. **Add agent configuration to Claude Code**
```bash
# Create Claude Code config directories if they don't exist
mkdir -p ~/.claude/agents
mkdir -p ~/.claude/commands

# Copy configuration files
cp agents/git-commit-generator.md ~/.claude/agents/
cp commands/commit.md ~/.claude/commands/
```

3. **Verify installation**
```bash
# Test the command in any git repository
/commit --preview
```

### Basic Usage

```bash
/commit                    # Interactive mode with auto-analysis
/commit en                 # Generate English commit message
/commit ch                 # Generate Chinese commit message
/commit --preview          # Preview mode, display only
/commit --batch            # Batch mode for multiple features
/commit --interactive      # Full interactive mode, file by file
```

## 📋 Workflow

```
┌──────────────┐
│ 1. Analysis  │ ← Execute git status to analyze changes
└──────┬───────┘
       ▼
┌──────────────┐
│ 2. Grouping  │ ← Auto-group files by feature/module
└──────┬───────┘
       ▼
┌──────────────┐
│3. Interaction│ ← Display options, wait for selection
└──────┬───────┘
       ▼
┌──────────────┐
│ 4. Language  │ ← Choose commit language (EN/CH)
└──────┬───────┘
       ▼
┌──────────────┐
│ 5. Preview   │ ← Display generated message
└──────┬───────┘
       ▼
┌──────────────┐
│6. Validation │ ← Score must be ≥90
└──────┬───────┘
       ▼
┌──────────────┐
│ 7. Execute   │ ← Execute after confirmation
└──────────────┘
```

## 💡 Usage Examples

### Scenario 1: Multiple Features Completed

You've completed both user management and product catalog features:

```
📊 Change Analysis Complete
━━━━━━━━━━━━━━━━━━━━━━━━━
Total files changed: 5
Features detected: 2

File Grouping:
┌─ User Feature (2 files)
│  • src/components/UserList.jsx
│  • src/api/userService.js
├─ Product Feature (2 files)
│  • src/components/ProductCard.jsx
│  • src/api/productService.js
└─ Shared Files (1 file)
   • src/utils/common.js

Options:
1. Commit each feature separately
2. Commit all together
3. Custom selection
4. Cancel operation

Your choice (1-4): _
```

### Scenario 2: Handling Coupled Files

When shared files affect multiple features:

```
Shared file detected: src/utils/validation.js

This file affects multiple features. Choose handling:
1. Include with user feature commit
2. Include with product feature commit
3. Commit shared file separately
4. Skip this file for now

Your choice (1-4): _
```

### Scenario 3: Preview Mode

View the commit message without executing:

```bash
/commit --preview
```

Sample output:
```
📝 Commit Preview
━━━━━━━━━━━━━━━━━━━━━━━━━
Files to stage:
  • src/components/UserList.jsx
  • src/api/userService.js

Message:
feat(user): ✨ add user list component


- Implement user list display functionality
- Add pagination and search support
- Integrate user service API

Confirm? (yes/no): _
```

## 📝 Commit Message Format

### Standard Format
```
<type>(<scope>): <emoji> <description>


- Detail point 1
- Detail point 2
- Detail point 3
```

### Example

```
feat(user): ✨ add user management system


- Implement user registration and login
- Add user profile editing interface
- Integrate avatar upload functionality
- Create user permission management module
```

## 🎨 Commit Types

| Type | Emoji | Description | Example |
|------|-------|-------------|---------|
| `feat` | ✨ | New feature | `feat(auth): ✨ add OAuth login` |
| `fix` | 🐛 | Bug fix | `fix(api): 🐛 resolve user data loading issue` |
| `docs` | 📝 | Documentation | `docs(readme): 📝 update installation guide` |
| `style` | 💄 | Code formatting | `style(css): 💄 improve button styling` |
| `refactor` | ♻️ | Code refactoring | `refactor(utils): ♻️ optimize data processing` |
| `perf` | ⚡ | Performance | `perf(api): ⚡ optimize query performance` |
| `test` | ✅ | Add tests | `test(user): ✅ add unit tests` |
| `chore` | 🔧 | Maintenance | `chore(deps): 🔧 update dependencies` |
| `ci` | 👷 | CI/CD | `ci(github): 👷 add automated testing` |
| `build` | 📦 | Build related | `build(webpack): 📦 update build config` |

[View complete emoji list (45 types)](agents/git-commit-generator.md#commit-types-and-emojis)

## 🧪 Testing

To test the functionality, you can:

1. **Create a test repository**
```bash
mkdir test-repo && cd test-repo
git init
```

2. **Create some test files and make changes**
```bash
echo "test" > file1.js
echo "test" > file2.js
git add . && git commit -m "initial"
echo "change" >> file1.js
echo "change" >> file2.js
```

3. **Test the commit command**
```bash
/commit --preview
```

## ⚙️ Configuration

### Agent Configuration
- **Location**: `agents/git-commit-generator.md`
- **Tools**: Bash, Grep, Glob
- **Core Features**: Interactive commit generation, quality validation

### Command Configuration
- **Location**: `commands/commit.md`
- **Trigger**: `/commit`
- **Parameters**: Language selection, mode flags

## 🔧 Advanced Features

### Custom File Grouping Rules

The system uses intelligent pattern recognition:

```
File Path Analysis:
• /components/User* → User feature
• /api/*user* → User feature
• /components/Product* → Product feature
• /api/*product* → Product feature
• /utils/* → Shared utilities
• /config/* → Configuration
• /tests/* → Test files
```

### Quality Scoring System

Quality validation before each commit:

```
Quality Checklist:
✓ Files properly grouped
✓ Type matches changes
✓ Scope reflects module
✓ Emoji matches type
✓ Description follows format
✓ No signature text
✓ Length under 72 chars

Score: 95/100
Proceed? (yes/no): _
```

## 📊 Best Practices

1. **Timely Commits** - Commit immediately after completing a feature
2. **Logical Grouping** - Related files together, unrelated files separate
3. **Clear Descriptions** - Use accurate verbs to describe changes
4. **Quality First** - Ensure every commit passes quality validation

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report issues
- Submit pull requests
- Suggest new features
- Improve documentation

## 📄 License

MIT License - Feel free to use in your projects

## 🙏 Acknowledgments

Built for Claude Code users who value clean, professional Git workflows.

## 📮 Contact

- GitHub Issues: [Report bugs or request features](https://github.com/zengwenliang416/CommitCraft/issues)

---

<div align="center">

**CommitCraft** - Making Git commits intelligent and professional

Made with ❤️ for better version control

</div>