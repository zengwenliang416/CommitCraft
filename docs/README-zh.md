# 🚀 CommitCraft - 智能 Git 提交多智能体系统

<div align="center">

[![Version](https://img.shields.io/badge/version-3.0.0-blue)]()
[![License](https://img.shields.io/badge/license-MIT-green)]()
[![Claude Code](https://img.shields.io/badge/Claude-Code-purple)]()
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)]()

**将你的 Git 工作流从手动提交转变为智能编排，质量保证达 95%**

[🇬🇧 English](../README.md) | [🇨🇳 中文文档](README-zh.md) | [📖 用户指南](../PILOT-USER-GUIDE-zh.md)

</div>

---

## 🎯 为什么选择 CommitCraft？

> **"一条命令，从混乱的提交到专业精准"**

传统 Git 工作流的痛点：
- 😩 团队间提交消息不一致
- 🎯 提交范围和组织混乱
- 📝 缺少上下文和文档
- 🔀 单个提交混合多个功能
- ⚠️ 暴露凭据的安全风险

**CommitCraft 的解决方案：**
- ✅ **95% 质量保证** - 每个提交都符合专业标准
- 🤖 **5 个专家 AI 智能体** - 专业分析、分组、生成、验证、执行
- 🚀 **一键工作流** - `/commit-pilot` 编排一切
- 🔒 **安全优先** - 内置凭据检测和危险操作拦截
- 🌍 **真正跨平台** - 原生支持 Windows、macOS、Linux

## 🌟 革命性功能

### 🎭 多智能体编排

```mermaid
graph LR
    A[你的变更] --> B[分析智能体]
    B --> C[分组智能体]
    C --> D[消息智能体]
    D --> E[验证智能体]
    E --> F[执行智能体]
    F --> G[完美提交]
```

### 🎯 智能工作流

#### 1️⃣ **智能提交导航** - 完全自动化
```bash
/commit-pilot
# → 分析所有变更
# → 按功能分组
# → 生成消息
# → 验证质量（90+ 分）
# → 执行提交
```

#### 2️⃣ **批量处理** - 多功能，独立提交
```bash
/commit-pilot --batch
# → 检测 3 个功能
# → 创建 3 个完美提交
# → 维护依赖关系
```

#### 3️⃣ **历史学习** - 从过去改进
```bash
/commit-history --score
# → 分析过去提交
# → 识别模式
# → 提供改进建议
```

## ⚡ 快速开始

### 📦 安装（30 秒）

<details>
<summary><b>🪟 Windows</b></summary>

```powershell
# 选项 1：批处理安装器
./install.bat

# 选项 2：PowerShell
powershell -ExecutionPolicy Bypass -File install.ps1
```
</details>

<details>
<summary><b>🍎 macOS / 🐧 Linux</b></summary>

```bash
# 设置可执行权限并运行
chmod +x install.sh && ./install.sh
```
</details>

### 🚀 你的第一个专业提交

```bash
# 1. 进行你的更改
code src/feature.js

# 2. 运行 CommitCraft
/commit-pilot

# 3. 见证魔法 ✨
```

**输出：**
```
📊 仓库分析完成
━━━━━━━━━━━━━━━━━━━━━━━━━━━
变更文件：5
检测功能：2
质量预测：94/100

继续编排？(Y/n)
```

## 🏗️ 架构深度解析

### 🤖 五大专家智能体

| 智能体 | 角色 | 专长 |
|-------|------|------|
| 🔍 **commit-analyzer** | 仓库扫描器 | 变更检测、依赖映射、风险评估 |
| 📁 **commit-grouper** | 组织专家 | 功能分离、逻辑分组、耦合检测 |
| ✍️ **commit-message** | 消息工匠 | 专业消息、双语支持、约定合规 |
| ✅ **commit-validator** | 质量守护者 | 90+ 评分、安全检查、格式验证 |
| 🚀 **commit-executor** | 安全操作员 | 原子提交、回滚能力、验证 |

### 🔄 工作流管道

```
┌─────────────────────────────────────────────────────┐
│                  阶段 0：扫描                         │
│             全面的仓库分析                            │
└─────────────────────────┬───────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────┐
│                 阶段 1：分组                         │
│         按功能智能组织文件                            │
│                  [用户关卡 🚪]                        │
└─────────────────────────┬───────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────┐
│                阶段 2：生成                          │
│           专业消息创建                               │
│              质量关卡 (≥90) 🎯                       │
└─────────────────────────┬───────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────┐
│                阶段 3：执行                          │
│          安全提交与验证                              │
│               [最终关卡 🚪]                          │
└─────────────────────────┬───────────────────────────┘
                          ↓
                    ✅ 成功
```

## 📊 真实案例

### 示例 1：多功能开发
```bash
$ /commit-pilot --batch

🔄 批量提交进度
════════════════════════
✅ 基础设施设置         [分数：96]
⏳ 用户认证             [处理中...]
⌛ API 文档             [等待中]

当前：feat(auth): ✨ 实现 OAuth2 流程
[████████░░░░] 66% 完成
```

### 示例 2：质量验证
```bash
$ /validate "fix: bug"

📊 验证报告
━━━━━━━━━━━━━━━━━━━
格式：     15/25 ❌
清晰度：   10/25 ❌
安全性：   25/25 ✅
约定：     12/25 ❌
━━━━━━━━━━━━━━━━━━━
总分：     62/100

状态：失败 ❌

建议：
1. 添加具体范围：fix(auth): ...
2. 描述实际修复的错误
3. 考虑添加表情：🐛
```

## 🛡️ 安全特性

### 🔐 内置保护
- **凭据检测** - 拦截 API 密钥、密码、令牌
- **危险操作预防** - 禁止 `rm -rf`、强制推送保护
- **敏感文件守护** - 保护 .env、配置文件
- **提交前验证** - 每次提交前的安全扫描

### 🪝 跨平台钩子
```javascript
// 自动安全验证
hooks/pre-tool-use.js     → 命令验证
hooks/user-prompt-submit.js → 输入增强
```

## 📈 质量指标

### 评分系统（0-100）
```
95-100：🏆 完美   - 立即发布
90-94： ✅ 优秀   - 小改进可选
80-89： ⚠️ 良好   - 建议改进
<80：   ❌ 失败   - 必须修复
```

### 评估维度
- **格式合规** - 类型、范围、表情使用
- **消息清晰度** - 描述性、具体性、语法
- **安全标准** - 无暴露密钥、安全操作
- **约定遵守** - 团队标准、一致性

## 🎨 自定义配置

### 提交类型与表情
```javascript
feat:     ✨ 新功能
fix:      🐛 错误修复
docs:     📝 文档
style:    💄 格式化
refactor: ♻️  代码重构
perf:     ⚡ 性能优化
test:     ✅ 测试
chore:    🔧 维护
build:    📦 构建系统
ci:       💚 CI/CD
```

### 语言支持
```bash
# 从仓库自动检测
/commit-pilot

# 强制语言
/commit-pilot --language en  # 英文
/commit-pilot --language ch  # 中文
```

## 📚 高级用法

### 🔄 工作流模式

<details>
<summary><b>交互模式（默认）</b></summary>

```bash
/commit-pilot
# → 逐步确认
# → 适合重要提交
# → 最大控制权
```
</details>

<details>
<summary><b>快速模式</b></summary>

```bash
/commit-pilot --quick
# → 智能默认值
# → 跳过确认
# → 快速工作流
```
</details>

<details>
<summary><b>预览模式</b></summary>

```bash
/commit-pilot --preview
# → 演练模式
# → 不实际提交
# → 安全测试
```
</details>

### 📊 历史分析
```bash
# 分析团队模式
/commit-history --last 100 --export markdown

# 个人改进
/commit-history --author me --score
```

## 🚦 集成

### 无缝对接：
- ✅ **Git 钩子** - Pre-commit、commit-msg 验证
- ✅ **CI/CD** - GitHub Actions、GitLab CI、Jenkins
- ✅ **问题跟踪** - 自动链接 (#123)
- ✅ **约定式提交** - 完全合规
- ✅ **GPG 签名** - 支持签名提交

## 📖 文档

- 📘 [完整用户指南](../PILOT-USER-GUIDE-zh.md)
- 🔧 [智能体文档](../agents/)
- 📝 [命令参考](../commands/)
- 🇬🇧 [English Documentation](../README.md)

## 🤝 贡献

欢迎贡献！查看 [CONTRIBUTING.md](../CONTRIBUTING.md)

```bash
# PR 前运行质量检查
/validate
/commit-pilot --preview
```

## 📄 许可证

MIT 许可证 - 查看 [LICENSE](../LICENSE)

## 🙏 致谢

为 Claude Code 社区用心打造 ❤️

特别感谢：
- Anthropic Claude 团队提供的卓越平台
- 开源贡献者们
- 早期采用者和反馈提供者

## 📮 支持

- 🐛 **问题反馈**：[GitHub Issues](https://github.com/your-username/commitcraft/issues)
- 💬 **讨论**：[GitHub Discussions](https://github.com/your-username/commitcraft/discussions)
- 📧 **邮箱**：support@commitcraft.dev

---

<div align="center">

### 🌟 在 GitHub 上给我们 Star！

**CommitCraft** - 每个提交都讲述完美的故事

`版本 3.0.0` | `MIT 许可证` | `为 Claude Code 打造`

</div>