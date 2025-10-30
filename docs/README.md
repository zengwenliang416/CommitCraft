# CommitCraft 开发文档

本目录包含 CommitCraft 的开发过程文档和架构设计文档,**仅供开发参考,不会被安装到用户系统**。

## 📁 目录结构

```
docs/
├── README.md                          # 本文件
├── development-notes/                 # 开发笔记
│   ├── ATTRIBUTION_CLEANING_SUMMARY.md
│   ├── COMMIT_MESSAGE_BODY_IMPROVEMENT.md
│   └── VALIDATION_NO_ATTRIBUTION_CHECK.md
└── architecture/                      # 架构设计文档
    ├── commitcraft-architecture.md
    ├── COMMITCRAFT_BRANCH_STRATEGY.md
    ├── COMMITCRAFT_WORKFLOW_IMPLEMENTATION.md
    └── COMMITCRAFT_WORKFLOW_SUMMARY.md
```

## 📚 文档说明

### 开发笔记 (development-notes/)

记录了 CommitCraft 开发过程中的重要决策和问题解决方案:

- **ATTRIBUTION_CLEANING_SUMMARY.md**: 归属信息清理方案
  - 问题: 如何从提交消息中移除 Claude Code 归属
  - 解决: commit-executor agent 的清理逻辑

- **COMMIT_MESSAGE_BODY_IMPROVEMENT.md**: 提交消息 body 规范改进
  - 优化提交消息的 body 部分内容生成
  - 确保符合 Conventional Commits 规范

- **VALIDATION_NO_ATTRIBUTION_CHECK.md**: 验证器不检查归属信息
  - 说明为什么 commit-validator 不检查归属信息
  - 归属清理在 commit-executor 中处理

### 架构设计 (architecture/)

CommitCraft 系统的架构设计和工作流文档:

- **commitcraft-architecture.md**: 整体架构设计
  - 5-agent pipeline 架构
  - Agent 之间的数据流
  - 交互机制设计

- **COMMITCRAFT_BRANCH_STRATEGY.md**: 分支策略设计
  - 3 种分支策略 (Direct/Feature/Hotfix)
  - 策略选择逻辑
  - 合并策略配置

- **COMMITCRAFT_WORKFLOW_IMPLEMENTATION.md**: 工作流实现细节
  - 完整的工作流步骤
  - Session 管理
  - 错误处理机制

- **COMMITCRAFT_WORKFLOW_SUMMARY.md**: 工作流总结
  - 系统概览
  - 核心特性
  - 使用场景

## 🔗 运行时文档

以下文档是 CommitCraft 运行时必需的,会被安装到用户系统:

- `.claude/agents/` - 5 个核心 agent 的实现
- `.claude/commands/commit-pilot.md` - 主命令入口
- `.claude/output-styles/` - 输出格式定义
- `.claude/workflows/cli-templates/` - Prompt 模板
- `CLAUDE.md` - 开发准则
- `README.md` - 使用说明

## 🎯 文档维护

- 开发过程中的新笔记应添加到 `development-notes/`
- 架构变更应更新 `architecture/` 中的相关文档
- 所有开发文档应保持简洁,聚焦于"为什么"而非"是什么"
