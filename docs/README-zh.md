# CommitCraft - 智能 Git 提交助手

<div align="center">

[![Version](https://img.shields.io/badge/version-1.0.0-blue)]()
[![License](https://img.shields.io/badge/license-MIT-green)]()
[![Claude Code](https://img.shields.io/badge/Claude-Code-purple)]()

**智能化 Git 提交消息生成器，支持交互式文件分组和质量验证**

[English](README.md) | [中文文档](README-zh.md)

</div>

---

## 🎯 项目简介

CommitCraft 是一个为 Claude Code 设计的智能 Git 提交助手，它通过智能文件分析、交互式确认和质量验证系统，帮助开发者创建标准化、专业的提交消息。特别适合处理多功能并行开发但需要分别提交的场景。

## ✨ 核心特性

- **🤖 智能文件分析** - 自动识别并按功能/模块分组文件
- **📊 交互式工作流** - 每个关键步骤都需要用户明确确认
- **🌐 双语支持** - 支持中英文提交消息，自动识别语言参数
- **🎯 精确暂存** - 选择性暂存文件，避免盲目使用 `git add .`
- **✅ 质量验证** - 内置质量评分系统，得分≥90才能继续
- **🔄 批量处理** - 智能处理多功能分离提交
- **🚫 无签名输出** - 专业、干净的输出，不添加任何归属文本
- **📁 耦合文件处理** - 智能识别并处理影响多个功能的共享文件

## 🚀 快速开始

### 安装步骤

1. **克隆或下载项目**
```bash
git clone https://github.com/zengwenliang416/CommitCraft.git
cd CommitCraft
```

2. **添加智能体配置到 Claude Code**
```bash
# 创建 Claude Code 配置目录（如果不存在）
mkdir -p ~/.claude/agents
mkdir -p ~/.claude/commands

# 复制配置文件
cp agents/git-commit-generator.md ~/.claude/agents/
cp commands/commit.md ~/.claude/commands/
```

3. **验证安装**
```bash
# 在任意 git 仓库中测试命令
/commit --preview
```

### 基本用法

```bash
/commit                    # 交互模式，自动分析并提供选项
/commit ch                 # 生成中文提交消息
/commit en                 # 生成英文提交消息
/commit --preview          # 预览模式，只显示不执行
/commit --batch            # 批量模式，处理多个功能
/commit --interactive      # 完全交互模式，逐个选择文件
```

## 📋 工作流程

```
┌──────────────┐
│ 1. 文件分析  │ ← 执行 git status 分析所有变更
└──────┬───────┘
       ▼
┌──────────────┐
│ 2. 智能分组  │ ← 按功能/模块自动分组文件
└──────┬───────┘
       ▼
┌──────────────┐
│ 3. 交互确认  │ ← 显示分组选项，等待用户选择
└──────┬───────┘
       ▼
┌──────────────┐
│ 4. 语言选择  │ ← 选择提交消息语言（中/英）
└──────┬───────┘
       ▼
┌──────────────┐
│ 5. 消息预览  │ ← 显示生成的提交消息
└──────┬───────┘
       ▼
┌──────────────┐
│ 6. 质量验证  │ ← 评分必须≥90分
└──────┬───────┘
       ▼
┌──────────────┐
│ 7. 执行提交  │ ← 用户确认后执行
└──────────────┘
```

## 💡 使用场景示例

### 场景 1：多功能同时完成

您同时完成了用户管理和产品目录两个功能，现在需要分别提交：

```
📊 变更分析完成
━━━━━━━━━━━━━━━━━━━━━━━━━
总计修改文件: 5
检测到功能: 2

文件分组:
┌─ 用户功能 (2 个文件)
│  • src/components/UserList.jsx
│  • src/api/userService.js
├─ 产品功能 (2 个文件)
│  • src/components/ProductCard.jsx
│  • src/api/productService.js
└─ 共享文件 (1 个文件)
   • src/utils/common.js

选项:
1. 分别提交每个功能
2. 全部一起提交
3. 自定义选择
4. 取消操作

您的选择 (1-4): _
```

### 场景 2：处理耦合文件

当存在影响多个功能的共享文件时：

```
检测到共享文件: src/utils/validation.js

该文件影响多个功能，请选择处理方式:
1. 包含在用户功能提交中
2. 包含在产品功能提交中
3. 单独提交共享文件
4. 暂时跳过此文件

您的选择 (1-4): _
```

### 场景 3：预览模式

查看将要生成的提交消息而不实际执行：

```bash
/commit --preview
```

输出示例：
```
📝 提交预览
━━━━━━━━━━━━━━━━━━━━━━━━━
待暂存文件: 
  • src/components/UserList.jsx
  • src/api/userService.js

消息内容:
feat(user): ✨ 添加用户列表组件


- 实现用户列表展示功能
- 添加分页和搜索支持
- 集成用户服务 API

确认提交? (yes/no): _
```

## 📝 提交消息格式

### 标准格式
```
<类型>(<范围>): <表情> <描述>


- 详细说明点 1
- 详细说明点 2
- 详细说明点 3
```

### 示例

```
feat(user): ✨ 添加用户管理系统


- 实现用户注册和登录功能
- 添加用户资料编辑界面
- 集成头像上传功能
- 创建用户权限管理模块
```

## 🎨 提交类型对照表

| 类型 | 表情 | 说明 | 示例 |
|------|------|------|------|
| `feat` | ✨ | 新功能 | `feat(auth): ✨ 添加 OAuth 登录` |
| `fix` | 🐛 | 修复 Bug | `fix(api): 🐛 修复用户数据加载问题` |
| `docs` | 📝 | 文档更新 | `docs(readme): 📝 更新安装指南` |
| `style` | 💄 | 代码格式 | `style(css): 💄 改进按钮样式` |
| `refactor` | ♻️ | 代码重构 | `refactor(utils): ♻️ 优化数据处理逻辑` |
| `perf` | ⚡ | 性能优化 | `perf(api): ⚡ 优化查询性能` |
| `test` | ✅ | 添加测试 | `test(user): ✅ 添加单元测试` |
| `chore` | 🔧 | 维护任务 | `chore(deps): 🔧 更新依赖包` |
| `ci` | 👷 | CI/CD | `ci(github): 👷 添加自动化测试` |
| `build` | 📦 | 构建相关 | `build(webpack): 📦 更新构建配置` |

[查看完整表情列表（45种）](agents/git-commit-generator.md#commit-types-and-emojis)

## 🧪 测试

要测试功能，您可以：

1. **创建测试仓库**
```bash
mkdir test-repo && cd test-repo
git init
```

2. **创建测试文件并进行修改**
```bash
echo "test" > file1.js
echo "test" > file2.js
git add . && git commit -m "initial"
echo "change" >> file1.js
echo "change" >> file2.js
```

3. **测试提交命令**
```bash
/commit --preview
```

## ⚙️ 配置说明

### 智能体配置
- **位置**: `agents/git-commit-generator.md`
- **工具**: Bash, Grep, Glob
- **核心功能**: 交互式提交生成、质量验证

### 命令配置
- **位置**: `commands/commit.md`
- **触发命令**: `/commit`
- **参数支持**: 语言选择、模式标志

## 🔧 高级功能

### 自定义文件分组规则

系统使用智能模式识别来分组文件：

```
文件路径分析:
• /components/User* → 用户功能
• /api/*user* → 用户功能
• /components/Product* → 产品功能
• /api/*product* → 产品功能
• /utils/* → 共享工具
• /config/* → 配置文件
• /tests/* → 测试文件
```

### 质量评分系统

每次提交前都会进行质量验证：

```
质量检查清单:
✓ 文件正确分组
✓ 类型匹配变更
✓ 范围反映模块
✓ 表情匹配类型
✓ 描述遵循格式
✓ 无签名文本
✓ 长度低于72字符

得分: 95/100
继续? (yes/no): _
```

## 📊 最佳实践

1. **及时提交** - 完成一个功能立即提交，避免积压
2. **逻辑分组** - 相关文件一起提交，无关文件分开
3. **清晰描述** - 使用准确的动词描述变更内容
4. **质量优先** - 确保每个提交都通过质量验证

## 🤝 贡献指南

欢迎贡献！您可以：
- 报告问题
- 提交 Pull Request
- 建议新功能
- 改进文档

## 📄 许可证

MIT 许可证 - 可自由用于您的项目

## 🙏 致谢

为重视 Git 工作流程规范的 Claude Code 用户而构建。

## 📮 联系方式

- GitHub Issues: [报告问题或请求功能](https://github.com/zengwenliang416/CommitCraft/issues)

---

<div align="center">

**CommitCraft** - 让 Git 提交智能且专业

用 ❤️ 打造更好的版本控制

</div>