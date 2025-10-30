# CommitCraft 分支策略改进方案

## 改进概述

本次改进为 CommitCraft 工作流引入了灵活的分支管理策略,支持在独立的 feature 分支上提交,并提供多种合并方式,符合 Git Flow 最佳实践。

## 核心改变

### 1. 新增文件
- `data/branch-strategy.json`: 存储分支策略配置

### 2. 新增门控点

#### Gate A - 分支命名策略 (在 Gate 1 分组确认后)
**位置**: commit-pilot.md 行210-281

**功能**:
- AI 自动生成基于 feature detection 的分支名
- 用户自定义分支名
- 选择在当前分支提交(传统模式)
- 取消操作

**输出**: `branch-strategy.json`
```json
{
  "use_feature_branch": true/false,
  "target_branch": "feature/xxx",
  "original_branch": "main"
}
```

#### Gate C - 合并策略 (在执行完成后)
**位置**: commit-pilot.md 行578-704

**功能**:
- AI 自动合并到原分支
- 显示手动合并命令
- 保留分支不合并(用于 PR)
- 回滚所有提交

**条件**: 仅在 `use_feature_branch` 为 true 时触发

### 3. 分支管理机制

#### 三分支模型
```
原始分支 (如 main)
├── backup/{features}      # 安全网,失败时恢复
└── feature/{feature-name} # 工作分支,提交所有 commits
```

#### 分支生命周期

**创建阶段** (commit-executor.md 步骤2-2.5):
1. 保存当前分支为 `original_branch`
2. 创建 `backup/{features}` 分支(安全网)
3. 如果 `use_feature_branch=true`:
   - 创建并切换到 `feature/{xxx}` 分支
   - 所有 commits 在 feature 分支执行
4. 如果 `use_feature_branch=false`:
   - 在当前分支直接提交(传统模式)

**执行阶段** (commit-executor.md 步骤3):
- 在目标分支(feature 或 current)执行所有 commits
- 失败时 rollback 到 backup 分支
- 成功后保留 backup 和 feature 分支

**合并阶段** (commit-pilot.md Gate C):
- AI 自动合并: `git merge --no-ff` + 删除分支
- 手动合并: 输出命令供用户执行
- 保留分支: 适用于 PR 流程
- 回滚: 恢复到 backup,删除 feature 分支

## 技术实现

### commit-pilot.md 改动

1. **Gate A 实现** (行212-281):
   - 生成建议分支名基于 features
   - AskUserQuestion 收集用户选择
   - 写入 `branch-strategy.json`

2. **执行阶段调整** (行516-560):
   - 加载 branch-strategy.json
   - 传递给 commit-executor
   - 保留 backup 和 feature 分支

3. **Gate C 实现** (行580-704):
   - 条件判断 `use_feature_branch`
   - 四种合并策略处理
   - 分支清理或保留

### commit-executor.md 改动

1. **输入验证** (行44,60):
   - 新增 branch-strategy.json 加载

2. **备份策略** (行86-94):
   - 保存 original_branch
   - 创建 backup 分支

3. **Feature 分支策略** (行107-135):
   - 新增步骤 2.5
   - 根据配置创建 feature 分支

4. **执行循环** (行174-180):
   - 记录 current_branch
   - 保留所有分支

5. **Rollback 机制** (行339-363):
   - 切换回 original_branch
   - 删除失败的 feature 分支
   - 重置到 backup

6. **输出增强** (行385-438):
   - 添加 original_branch, current_branch
   - 添加 use_feature_branch 标志

## 使用场景

### 场景1: 标准 Feature 开发
```bash
/commit-pilot

# Gate A: 选择 "使用建议分支" → feature/authentication
# 执行提交...
# Gate C: 选择 "AI自动合并" → 自动合并到 main
```

### 场景2: 团队协作 PR 流程
```bash
/commit-pilot

# Gate A: 自定义分支名 → feature/user-123-add-auth
# 执行提交...
# Gate C: 选择 "保留分支不合并" → 创建 PR
```

### 场景3: 传统直接提交
```bash
/commit-pilot

# Gate A: 选择 "当前分支提交"
# 执行提交...
# (跳过 Gate C)
```

### 场景4: 快速模式
```bash
/commit-pilot --quick

# 自动使用建议分支名
# 自动合并到原分支
```

## 优势

1. **符合 Git Flow**: feature 分支 + merge 策略
2. **灵活性**: 支持多种工作模式
3. **安全性**: backup 分支保障 + rollback 机制
4. **向后兼容**: 可选择传统模式
5. **团队友好**: 支持 PR 流程

## 风险控制

1. **合并冲突**: Gate C 捕获并提供手动解决方案
2. **执行失败**: rollback 到 backup,清理失败分支
3. **门控跳过**: `--quick` 模式使用安全默认值

## 验证清单

- [x] commit-pilot.md Gate A 实现
- [x] commit-pilot.md Gate C 实现
- [x] commit-pilot.md 执行逻辑调整
- [x] commit-executor.md 分支策略加载
- [x] commit-executor.md feature 分支创建
- [x] commit-executor.md rollback 机制更新
- [x] commit-executor.md 输出格式增强
- [x] 逻辑一致性检查
- [x] 文档完整性验证

## 后续建议

1. **测试场景**:
   - 单 feature 提交
   - 多 feature 提交
   - 合并冲突处理
   - rollback 验证

2. **文档更新**:
   - 更新 COMMITCRAFT-TESTING.md
   - 添加分支策略使用示例

3. **增强功能**(可选):
   - 自动创建 PR
   - 分支命名模板配置
   - 合并策略默认值配置

---

**实施状态**: ✅ 完成
**影响范围**: commit-pilot.md, commit-executor.md
**向后兼容**: 是(通过"当前分支提交"选项)
