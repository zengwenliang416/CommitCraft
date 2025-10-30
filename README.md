# CommitCraft - 智能 Git 提交工作流系统

> 这是一个独立的 CommitCraft 分支,专注于提供智能化的 Git 提交工作流功能

## 概述

CommitCraft 是一个多智能体协作系统,通过智能分析、分组、验证和执行,实现专业的 git 提交流程,并提供完整的过程文档。

### 核心特性

- **5 智能体流水线**: 顺序专家协调
- **质量优先**: 90/100 分最低质量要求
- **安全感知**: 自动阻止包含敏感数据的提交
- **双语支持**: 英文/中文提交消息
- **过程文档**: 完整的会话可追溯性
- **分支策略**: 支持 feature 分支或当前分支提交

## 工作流程

```
分析 → 分组 → 生成消息 → 验证 → 执行
```

1. **commit-analyzer**: 分析仓库变更并检测功能
2. **commit-grouper**: 将文件分组为逻辑提交单元
3. **commit-message**: 生成符合规范的提交消息
4. **commit-validator**: 验证质量和安全性
5. **commit-executor**: 安全执行 git 提交

## 快速开始

### 使用 commit-pilot 命令

```bash
# 基础使用
/commit-pilot

# 快速模式(跳过交互确认)
/commit-pilot --quick

# 预览模式(不执行提交)
/commit-pilot --preview

# 指定语言
/commit-pilot --language ch
```

### 选项说明

- `--batch`: 批量处理多个功能为独立提交
- `--quick`: 跳过交互确认,使用智能默认值
- `--preview`: 预览模式,不执行提交
- `--skip-validation`: 跳过质量验证(不推荐)
- `--skip-docs`: 跳过过程文档生成
- `--language <en|ch>`: 强制指定提交消息语言

## 文件结构

```
.
├── .claude/                        # 运行时文件(会被安装)
│   ├── agents/                    # 5 个核心智能体
│   │   ├── commit-analyzer.md
│   │   ├── commit-grouper.md
│   │   ├── commit-message.md
│   │   ├── commit-validator.md
│   │   └── commit-executor.md
│   ├── commands/
│   │   └── commit-pilot.md        # 主编排命令
│   ├── workflows/cli-templates/   # Prompt 模板
│   │   └── prompts/commitcraft/
│   │       ├── conventional-commits.txt
│   │       ├── quality-criteria.txt
│   │       └── security-patterns.txt
│   └── output-styles/
│       └── commitcraft-workflow.md
├── docs/                          # 开发文档(不会被安装)
│   ├── development-notes/         # 开发笔记
│   └── architecture/              # 架构设计
├── CLAUDE.md                      # 开发准则
├── README.md                      # 本文件
└── LICENSE
```

## 核心智能体

### 1. commit-analyzer
- 分析 git 状态和差异
- 按类型分类变更(代码/文档/配置/资源)
- 使用 MCP code-index 检测功能和模块
- 映射文件依赖关系
- 计算复杂度和风险

### 2. commit-grouper
- 按功能/模块分组文件
- 尊重依赖关系
- 应用分组规则(每组最多 10 个文件)
- 生成 git add 命令

### 3. commit-message
- 生成符合 Conventional Commits 规范的消息
- 支持多种类型: feat|fix|docs|style|refactor|test|chore|perf|ci|build
- 使用祈使语气,主题 <72 字符
- 提供详细的正文说明
- 双语支持(英文/中文)

### 4. commit-validator
- 验证 4 个维度:
  - 格式合规性(25 分)
  - 清晰度(25 分)
  - 完整性(25 分)
  - 约定遵守(25 分)
- 安全检查(阻断性):
  - API 密钥、密码、令牌
  - AWS 凭证、私钥
  - 阻止严重问题

### 5. commit-executor
- 验证验证状态为"已批准"
- 创建备份分支
- 支持 feature 分支或当前分支提交
- 安全执行 git 提交
- 处理 pre-commit hook 修改
- 失败时回滚

## 交互式确认

### 分组确认
在生成消息前,系统会显示分组策略并询问:
- 继续生成消息
- 重新分组
- 取消操作

### 分支策略
系统会建议 feature 分支名称并提供选项:
- 使用建议分支
- 自定义分支名
- 当前分支提交
- 取消操作

### 合并策略
执行完成后,如果使用了 feature 分支:
- AI 自动合并
- 显示合并命令
- 保留分支不合并
- 回滚所有提交

## 会话文档

每次执行都会创建完整的文档:

```
.claude/commitcraft/commitcraft-YYYYMMDD-HHMMSS/
├── 00-repository-analysis.md      # 变更内容
├── 01-grouping-strategy.md        # 分组方式 + git add 命令
├── 02-commit-messages.md          # 消息 + git commit 命令
├── 03-validation-report.md        # 质量评分和问题
├── 04-execution-log.md            # 执行结果
├── 05-session-summary.md          # 总体摘要
├── data/                          # JSON 数据文件
│   ├── repository-analysis.json
│   ├── grouping-strategy.json
│   ├── commit-messages.json
│   ├── validation-report.json
│   └── execution-log.json
└── summary.json                   # 会话元数据
```

## 安全特性

CommitCraft 包含安全检查,会自动检测并阻止包含以下内容的提交:
- API 密钥和访问令牌
- 密码和凭证
- AWS 访问密钥
- 私钥文件
- 其他敏感信息

## 质量标准

提交消息必须达到以下标准才能通过验证:
- **总分 ≥ 90/100**
- 符合 Conventional Commits 格式
- 清晰、具体、使用祈使语气
- 完整解释所有变更
- 遵守行长度、footer 格式等约定

## 错误处理

### 验证失败
如果质量评分 < 90,系统会提供选项:
- 重新生成消息(使用更严格的质量标准)
- 继续执行(不推荐)
- 取消操作

### 安全检查阻断
如果检测到敏感数据,系统会:
- 显示具体问题
- 提供修复建议
- 阻止提交执行

## 最佳实践

1. **提交前运行**: 使用 `/commit-pilot` 替代手动 `git commit`
2. **审查分析**: 检查 `00-repository-analysis.md` 验证检测到的功能
3. **信任验证**: 如果评分 < 90,审查并改进消息
4. **使用预览模式**: 不确定时先尝试 `--preview`
5. **批处理多功能**: 对不相关功能使用 `--batch`

## 许可证

见 [LICENSE](LICENSE) 文件

## 开发文档

详细的架构设计和开发笔记请查看 [docs/](docs/) 目录:

- [CommitCraft 架构](docs/architecture/commitcraft-architecture.md)
- [工作流实现](docs/architecture/COMMITCRAFT_WORKFLOW_IMPLEMENTATION.md)
- [工作流摘要](docs/architecture/COMMITCRAFT_WORKFLOW_SUMMARY.md)
- [分支策略](docs/architecture/COMMITCRAFT_BRANCH_STRATEGY.md)
- [开发笔记](docs/development-notes/)

> 注意: `docs/` 目录仅供开发参考,不会被安装脚本安装到用户系统

---

*通过多智能体协作实现专业的 git 提交*
