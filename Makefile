# CommitCraft Makefile
# Multi-Agent Git Commit System for Claude Code
# Version: 3.0.0

# Configuration
SHELL := /bin/bash
CLAUDE_DIR := $(HOME)/.claude
AGENTS_DIR := $(CLAUDE_DIR)/agents
COMMANDS_DIR := $(CLAUDE_DIR)/commands
HOOKS_DIR := $(CLAUDE_DIR)/hooks
PROJECT_DIR := $(shell pwd)

# Colors for output (use with printf %b)
GREEN := \033[0;32m
BLUE := \033[0;34m
RED := \033[0;31m
YELLOW := \033[1;33m
CYAN := \033[0;36m
BOLD := \033[1m
NC := \033[0m

# Consistent printer that interprets escapes
PRINTF := printf "%b\n"

# Default target
.PHONY: all
all: help

# Help target - shows available commands with detailed descriptions
.PHONY: help
help:
	@printf "\n"
	@$(PRINTF) "$(CYAN)╔═══════════════════════════════════════════════════════════════════╗$(NC)"
	@$(PRINTF) "$(CYAN)║$(NC)$(BOLD)                   CommitCraft Installation System                 $(NC)$(CYAN)║$(NC)"
	@$(PRINTF) "$(CYAN)║$(NC)$(BOLD)              Multi-Agent Git Commit Workflow for Claude           $(NC)$(CYAN)║$(NC)"
	@$(PRINTF) "$(CYAN)╚═══════════════════════════════════════════════════════════════════╝$(NC)"
	@printf "\n"
	@$(PRINTF) "$(GREEN)USAGE:$(NC)"
	@$(PRINTF) "  make [target] [options]"
	@printf "\n"
	@$(PRINTF) "$(GREEN)INSTALLATION TARGETS:$(NC)"
	@$(PRINTF) "  $(BLUE)install$(NC)           Install all components (agents, commands, hooks)"
	@$(PRINTF) "  $(BLUE)install-mac$(NC)      macOS-specific installation with optimizations"
	@$(PRINTF) "  $(BLUE)install-linux$(NC)    Linux-specific installation with systemd support"
	@$(PRINTF) "  $(BLUE)install-windows$(NC)  Show Windows installation instructions"
	@$(PRINTF) "  $(BLUE)dev$(NC)              Development mode (uses symlinks for live updates)"
	@$(PRINTF) "  $(BLUE)update$(NC)           Update existing installation (backs up current)"
	@$(PRINTF) "  $(BLUE)uninstall$(NC)        Remove all CommitCraft components"
	@printf "\n"
	@$(PRINTF) "$(GREEN)COMPONENT TARGETS:$(NC)"
	@$(PRINTF) "  $(BLUE)install-agents$(NC)   Install only agent components"
	@$(PRINTF) "  $(BLUE)install-commands$(NC) Install only command components"
	@$(PRINTF) "  $(BLUE)install-hooks$(NC)    Install only hook components"
	@$(PRINTF) "  $(BLUE)install-config$(NC)   Install only configuration files"
	@printf "\n"
	@$(PRINTF) "$(GREEN)MAINTENANCE TARGETS:$(NC)"
	@$(PRINTF) "  $(BLUE)verify$(NC)           Verify installation integrity"
	@$(PRINTF) "  $(BLUE)status$(NC)           Show installation status and statistics"
	@$(PRINTF) "  $(BLUE)backup$(NC)           Create backup of current installation"
	@$(PRINTF) "  $(BLUE)restore$(NC)          Restore from most recent backup"
	@$(PRINTF) "  $(BLUE)clean$(NC)            Clean temporary and cache files"
	@$(PRINTF) "  $(BLUE)clean-all$(NC)        Remove all generated files and backups"
	@printf "\n"
	@$(PRINTF) "$(GREEN)DEVELOPMENT TARGETS:$(NC)"
	@$(PRINTF) "  $(BLUE)test$(NC)             Run installation tests"
	@$(PRINTF) "  $(BLUE)lint$(NC)             Check code quality (requires eslint)"
	@$(PRINTF) "  $(BLUE)format$(NC)           Format code files"
	@$(PRINTF) "  $(BLUE)watch$(NC)            Watch for changes in dev mode"
	@printf "\n"
	@$(PRINTF) "$(GREEN)DOCUMENTATION TARGETS:$(NC)"
	@$(PRINTF) "  $(BLUE)docs$(NC)             Generate documentation"
	@$(PRINTF) "  $(BLUE)man$(NC)              Generate man page"
	@$(PRINTF) "  $(BLUE)readme$(NC)           Display README in terminal"
	@$(PRINTF) "  $(BLUE)version$(NC)          Show version information"
	@printf "\n"
	@$(PRINTF) "$(GREEN)EXAMPLES:$(NC)"
	@$(PRINTF) "  $(CYAN)# Standard installation$(NC)"
	@$(PRINTF) "  make install"
	@printf "\n"
	@$(PRINTF) "  $(CYAN)# Development setup with live updates$(NC)"
	@$(PRINTF) "  make dev"
	@printf "\n"
	@$(PRINTF) "  $(CYAN)# Update existing installation$(NC)"
	@$(PRINTF) "  make update"
	@printf "\n"
	@$(PRINTF) "  $(CYAN)# Check installation status$(NC)"
	@$(PRINTF) "  make status"
	@printf "\n"
	@$(PRINTF) "  $(CYAN)# Complete cleanup$(NC)"
	@$(PRINTF) "  make uninstall clean-all"
	@printf "\n"
	@$(PRINTF) "$(GREEN)QUICK START:$(NC)"
	@$(PRINTF) "  1. Run: $(CYAN)make install$(NC)"
	@$(PRINTF) "  2. Restart Claude Code"
	@$(PRINTF) "  3. Use: $(CYAN)/commit-pilot$(NC) to start"
	@printf "\n"
	@$(PRINTF) "$(GREEN)MORE INFORMATION:$(NC)"
	@$(PRINTF) "  Documentation: https://github.com/zengwenliang416/CommitCraft"
	@$(PRINTF) "  Issues: https://github.com/zengwenliang416/CommitCraft/issues"
	@$(PRINTF) "  Version: 3.0.0"
	@printf "\n"

# Install target - full installation
.PHONY: install
install: prereq dirs install-agents install-commands install-hooks install-config verify show-success
	@$(PRINTF) "$(GREEN)[✓]$(NC) Installation complete!"

# Show success message with instructions
.PHONY: show-success
show-success:
	@printf "\n"
	@$(PRINTF) "$(GREEN)═══════════════════════════════════════════════════════════$(NC)"
	@$(PRINTF) "$(GREEN)            Installation Successful!                       $(NC)"
	@$(PRINTF) "$(GREEN)═══════════════════════════════════════════════════════════$(NC)"
	@printf "\n"
	@$(PRINTF) "$(BLUE)Installed Commands:$(NC)"
	@$(PRINTF) "  $(GREEN)/commit-pilot$(NC)     Full commit workflow orchestrator"
	@$(PRINTF) "  $(GREEN)/analyze$(NC)          Analyze repository changes"
	@$(PRINTF) "  $(GREEN)/group$(NC)            Group files for commits"
	@$(PRINTF) "  $(GREEN)/validate$(NC)         Validate commit messages"
	@$(PRINTF) "  $(GREEN)/batch-commit$(NC)     Process multiple commits"
	@$(PRINTF) "  $(GREEN)/commit-history$(NC)   Analyze commit history"
	@printf "\n"
	@$(PRINTF) "$(BLUE)Features:$(NC)"
	@$(PRINTF) "  ✨ Multi-agent orchestration"
	@$(PRINTF) "  📊 Intelligent file grouping"
	@$(PRINTF) "  🌐 Bilingual support (EN/CH)"
	@$(PRINTF) "  ✅ Quality validation (≥90 score)"
	@$(PRINTF) "  🔒 Security hooks"
	@$(PRINTF) "  📦 Batch processing"
	@printf "\n"
	@$(PRINTF) "$(BLUE)Next Steps:$(NC)"
	@$(PRINTF) "  1. Restart Claude Code"
	@$(PRINTF) "  2. Make changes to your files"
	@$(PRINTF) "  3. Run: $(GREEN)/commit-pilot$(NC)"
	@printf "\n"
	@$(PRINTF) "$(YELLOW)Note:$(NC) For help, run: $(CYAN)/commit-pilot --help$(NC)"
	@printf "\n"

# Development mode - uses symlinks
.PHONY: dev
dev: prereq dirs dev-agents dev-commands dev-hooks install-config verify
	@printf "\n"
	@$(PRINTF) "$(GREEN)[✓]$(NC) Development mode installation complete"
	@$(PRINTF) "$(YELLOW)Note:$(NC) Using symlinks - changes in source files will be reflected immediately"
	@printf "\n"

# Update existing installation
.PHONY: update
update: backup install
	@$(PRINTF) "$(GREEN)[✓]$(NC) Update complete"
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Previous version backed up to $(CLAUDE_DIR).backup.*"

# Uninstall
.PHONY: uninstall
uninstall:
	@$(PRINTF) "$(YELLOW)[⚠]$(NC) Uninstalling CommitCraft..."
	@rm -f $(AGENTS_DIR)/commit-*.md
	@rm -f $(COMMANDS_DIR)/commit-pilot.md
	@rm -f $(COMMANDS_DIR)/analyze.md
	@rm -f $(COMMANDS_DIR)/group.md
	@rm -f $(COMMANDS_DIR)/validate.md
	@rm -f $(COMMANDS_DIR)/batch-commit.md
	@rm -f $(COMMANDS_DIR)/commit-history.md
	@rm -f $(HOOKS_DIR)/pre-tool-use.js
	@rm -f $(HOOKS_DIR)/user-prompt-submit.js
	@rm -f $(CLAUDE_DIR)/hooks.json
	@$(PRINTF) "$(GREEN)[✓]$(NC) Uninstallation complete"

# Check prerequisites
.PHONY: prereq
prereq:
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Checking prerequisites..."
	@command -v git >/dev/null 2>&1 || { printf "%b\n" "$(RED)[✗]$(NC) Git is not installed. Please install git first."; exit 1; }
	@$(PRINTF) "$(GREEN)[✓]$(NC) Git is installed"
	@if command -v node >/dev/null 2>&1; then \
		printf "%b\n" "$(GREEN)[✓]$(NC) Node.js is installed"; \
	else \
		printf "%b\n" "$(YELLOW)[⚠]$(NC) Node.js is not installed. Hooks may not function properly."; \
		printf "%b\n" "$(BLUE)[INFO]$(NC) Install Node.js from: https://nodejs.org"; \
	fi
	@$(PRINTF) "$(GREEN)[✓]$(NC) Prerequisites check passed"

# Create directories
.PHONY: dirs
dirs:
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Creating Claude Code directories..."
	@mkdir -p $(AGENTS_DIR)
	@mkdir -p $(COMMANDS_DIR)
	@mkdir -p $(HOOKS_DIR)
	@$(PRINTF) "$(GREEN)[✓]$(NC) Directories created"

# Install agents
.PHONY: install-agents
install-agents:
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Installing agents..."
	@for agent in commit-analyzer commit-grouper commit-message commit-validator commit-executor; do \
		if [ -f "$(PROJECT_DIR)/agents/$$agent.md" ]; then \
			cp "$(PROJECT_DIR)/agents/$$agent.md" "$(AGENTS_DIR)/"; \
			printf "%b\n" "$(GREEN)[✓]$(NC) Installed agent: $$agent.md"; \
		else \
			printf "%b\n" "$(YELLOW)[⚠]$(NC) Agent not found: $$agent.md"; \
		fi \
	done

# Install agents in dev mode (symlinks)
.PHONY: dev-agents
dev-agents:
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Installing agents (dev mode)..."
	@for agent in commit-analyzer commit-grouper commit-message commit-validator commit-executor; do \
		if [ -f "$(PROJECT_DIR)/agents/$$agent.md" ]; then \
			ln -sf "$(PROJECT_DIR)/agents/$$agent.md" "$(AGENTS_DIR)/$$agent.md"; \
			printf "%b\n" "$(GREEN)[✓]$(NC) Linked agent: $$agent.md"; \
		fi \
	done

# Install commands
.PHONY: install-commands
install-commands:
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Installing commands..."
	@for cmd in commit-pilot analyze group validate batch-commit commit-history; do \
		if [ -f "$(PROJECT_DIR)/commands/$$cmd.md" ]; then \
			cp "$(PROJECT_DIR)/commands/$$cmd.md" "$(COMMANDS_DIR)/"; \
			printf "%b\n" "$(GREEN)[✓]$(NC) Installed command: /$$cmd"; \
		else \
			printf "%b\n" "$(YELLOW)[⚠]$(NC) Command not found: $$cmd.md"; \
		fi \
	done

# Install commands in dev mode (symlinks)
.PHONY: dev-commands
dev-commands:
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Installing commands (dev mode)..."
	@for cmd in commit-pilot analyze group validate batch-commit commit-history; do \
		if [ -f "$(PROJECT_DIR)/commands/$$cmd.md" ]; then \
			ln -sf "$(PROJECT_DIR)/commands/$$cmd.md" "$(COMMANDS_DIR)/$$cmd.md"; \
			printf "%b\n" "$(GREEN)[✓]$(NC) Linked command: /$$cmd"; \
		fi \
	done

# Install hooks
.PHONY: install-hooks
install-hooks:
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Installing hooks..."
	@for hook in pre-tool-use user-prompt-submit; do \
		if [ -f "$(PROJECT_DIR)/hooks/$$hook.js" ]; then \
			cp "$(PROJECT_DIR)/hooks/$$hook.js" "$(HOOKS_DIR)/"; \
			chmod +x "$(HOOKS_DIR)/$$hook.js"; \
			printf "%b\n" "$(GREEN)[✓]$(NC) Installed hook: $$hook.js"; \
		else \
			printf "%b\n" "$(YELLOW)[⚠]$(NC) Hook not found: $$hook.js"; \
		fi \
	done

# Install hooks in dev mode (symlinks)
.PHONY: dev-hooks
dev-hooks:
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Installing hooks (dev mode)..."
	@for hook in pre-tool-use user-prompt-submit; do \
		if [ -f "$(PROJECT_DIR)/hooks/$$hook.js" ]; then \
			ln -sf "$(PROJECT_DIR)/hooks/$$hook.js" "$(HOOKS_DIR)/$$hook.js"; \
			chmod +x "$(HOOKS_DIR)/$$hook.js"; \
			printf "%b\n" "$(GREEN)[✓]$(NC) Linked hook: $$hook.js"; \
		fi \
	done

# Install configuration
.PHONY: install-config
install-config:
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Creating hooks configuration..."
	@echo '{\n  "hooks": {\n    "PreToolUse": {\n      "script": "node $$HOME/.claude/hooks/pre-tool-use.js",\n      "enabled": true,\n      "description": "Validates tool usage for security and safety"\n    },\n    "UserPromptSubmit": {\n      "script": "node $$HOME/.claude/hooks/user-prompt-submit.js",\n      "enabled": true,\n      "description": "Enhances user input with commit context"\n    }\n  }\n}' > $(CLAUDE_DIR)/hooks.json
	@$(PRINTF) "$(GREEN)[✓]$(NC) Hooks configuration created"

# Verify installation
.PHONY: verify
verify:
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Verifying installation..."
	@errors=0; \
	for agent in commit-analyzer commit-grouper commit-message commit-validator commit-executor; do \
		if [ ! -e "$(AGENTS_DIR)/$$agent.md" ]; then \
			printf "%b\n" "$(RED)[✗]$(NC) Agent missing: $$agent.md"; \
			errors=$$((errors + 1)); \
		fi \
	done; \
	for cmd in commit-pilot analyze group validate batch-commit commit-history; do \
		if [ ! -e "$(COMMANDS_DIR)/$$cmd.md" ]; then \
			printf "%b\n" "$(RED)[✗]$(NC) Command missing: $$cmd.md"; \
			errors=$$((errors + 1)); \
		fi \
	done; \
	for hook in pre-tool-use user-prompt-submit; do \
		if [ ! -e "$(HOOKS_DIR)/$$hook.js" ]; then \
			printf "%b\n" "$(RED)[✗]$(NC) Hook missing: $$hook.js"; \
			errors=$$((errors + 1)); \
		fi \
	done; \
	if [ $$errors -eq 0 ]; then \
		printf "%b\n" "$(GREEN)[✓]$(NC) Installation verified successfully"; \
	else \
		printf "%b\n" "$(RED)[✗]$(NC) Installation verification failed with $$errors errors"; \
		exit 1; \
	fi

# Backup existing installation
.PHONY: backup
backup:
	@if [ -d "$(CLAUDE_DIR)" ]; then \
		backup_dir="$(CLAUDE_DIR).backup.$$(date +%Y%m%d_%H%M%S)"; \
		printf "%b\n" "$(BLUE)[INFO]$(NC) Creating backup at $$backup_dir"; \
		cp -r "$(CLAUDE_DIR)" "$$backup_dir"; \
		printf "%b\n" "$(GREEN)[✓]$(NC) Backup created"; \
	fi

# Restore from backup
.PHONY: restore
restore:
	@latest_backup=$$(ls -td $(CLAUDE_DIR).backup.* 2>/dev/null | head -n1); \
	if [ -n "$$latest_backup" ]; then \
		printf "%b\n" "$(BLUE)[INFO]$(NC) Restoring from $$latest_backup"; \
		rm -rf "$(CLAUDE_DIR)"; \
		cp -r "$$latest_backup" "$(CLAUDE_DIR)"; \
		printf "%b\n" "$(GREEN)[✓]$(NC) Restore complete"; \
	else \
		printf "%b\n" "$(RED)[✗]$(NC) No backup found"; \
		exit 1; \
	fi

# Clean temporary files
.PHONY: clean
clean:
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Cleaning temporary files..."
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@find . -name "*~" -delete 2>/dev/null || true
	@find . -name ".DS_Store" -delete 2>/dev/null || true
	@$(PRINTF) "$(GREEN)[✓]$(NC) Cleanup complete"

# Clean all generated files
.PHONY: clean-all
clean-all: clean
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Removing all backups..."
	@rm -rf $(CLAUDE_DIR).backup.* 2>/dev/null || true
	@$(PRINTF) "$(GREEN)[✓]$(NC) All generated files removed"

# Run tests
.PHONY: test
test: verify
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Running installation tests..."
	@$(PRINTF) "$(CYAN)Testing Node.js compatibility...$(NC)"
	@if command -v node >/dev/null 2>&1; then \
		node -e "console.log('[✓] Node.js hooks can execute')"; \
	fi
	@$(PRINTF) "$(CYAN)Testing configuration...$(NC)"
	@if [ -f "$(CLAUDE_DIR)/hooks.json" ]; then \
		printf "%b\n" "$(GREEN)[✓]$(NC) Configuration file exists"; \
	else \
		printf "%b\n" "$(RED)[✗]$(NC) Configuration file missing"; \
		exit 1; \
	fi
	@$(PRINTF) "$(CYAN)Testing command accessibility...$(NC)"
	@if [ -f "$(COMMANDS_DIR)/commit-pilot.md" ]; then \
		printf "%b\n" "$(GREEN)[✓]$(NC) Commands are accessible"; \
	fi
	@$(PRINTF) "$(GREEN)[✓]$(NC) All tests passed"

# Lint JavaScript files
.PHONY: lint
lint:
	@if command -v eslint >/dev/null 2>&1; then \
		printf "%b\n" "$(BLUE)[INFO]$(NC) Running ESLint..."; \
		eslint hooks/*.js --fix; \
		printf "%b\n" "$(GREEN)[✓]$(NC) Linting complete"; \
	else \
		printf "%b\n" "$(YELLOW)[⚠]$(NC) ESLint not installed. Run: npm install -g eslint"; \
	fi

# Format code files
.PHONY: format
format:
	@if command -v prettier >/dev/null 2>&1; then \
		printf "%b\n" "$(BLUE)[INFO]$(NC) Formatting code..."; \
		prettier --write "**/*.{js,md,json}"; \
		printf "%b\n" "$(GREEN)[✓]$(NC) Formatting complete"; \
	else \
		printf "%b\n" "$(YELLOW)[⚠]$(NC) Prettier not installed. Run: npm install -g prettier"; \
	fi

# Watch for changes (dev mode)
.PHONY: watch
watch:
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Watching for changes (Ctrl+C to stop)..."
	@while true; do \
		inotifywait -e modify -r agents/ commands/ hooks/ 2>/dev/null || \
		fswatch -r agents/ commands/ hooks/ 2>/dev/null || \
		{ printf "%b\n" "$(RED)[✗]$(NC) Install inotifywait or fswatch for file watching"; exit 1; }; \
		printf "%b\n" "$(YELLOW)[!]$(NC) Changes detected, reinstalling..."; \
		$(MAKE) dev; \
	done

# Platform-specific installations
.PHONY: install-mac
install-mac: install
	@$(PRINTF) "$(GREEN)[✓]$(NC) macOS installation complete"
	@if ! command -v fswatch >/dev/null 2>&1; then \
		printf "%b\n" "$(YELLOW)Tip:$(NC) Install fswatch for file watching: brew install fswatch"; \
	fi

.PHONY: install-linux
install-linux: install
	@$(PRINTF) "$(GREEN)[✓]$(NC) Linux installation complete"
	@if ! command -v inotifywait >/dev/null 2>&1; then \
		printf "%b\n" "$(YELLOW)Tip:$(NC) Install inotify-tools for file watching: apt-get install inotify-tools"; \
	fi

.PHONY: install-windows
install-windows:
	@$(PRINTF) "$(CYAN)╔═══════════════════════════════════════════════════════════╗$(NC)"
	@$(PRINTF) "$(CYAN)║               Windows Installation Guide                   ║$(NC)"
	@$(PRINTF) "$(CYAN)╚═══════════════════════════════════════════════════════════╝$(NC)"
	@printf "\n"
	@$(PRINTF) "$(BLUE)For Windows users, please use WSL (Windows Subsystem for Linux):$(NC)"
	@printf "\n"
	@$(PRINTF) "$(BLUE)1. Install WSL:$(NC)"
	@$(PRINTF) "   Open PowerShell as Administrator and run:"
	@$(PRINTF) "   $(CYAN)wsl --install$(NC)"
	@printf "\n"
	@$(PRINTF) "$(BLUE)2. Open WSL terminal and run:$(NC)"
	@$(PRINTF) "   $(CYAN)make install$(NC)"
	@printf "\n"
	@$(PRINTF) "$(BLUE)Alternative: Use Git Bash$(NC)"
	@$(PRINTF) "   If you have Git for Windows installed, you can use Git Bash:"
	@$(PRINTF) "   $(CYAN)make install$(NC)"
	@printf "\n"
	@$(PRINTF) "$(YELLOW)Note:$(NC) Native Windows support requires WSL or Git Bash"
	@printf "\n"

# Show installation status
.PHONY: status
status:
	@printf "\n"
	@$(PRINTF) "$(CYAN)CommitCraft Installation Status$(NC)"
	@$(PRINTF) "$(CYAN)════════════════════════════════$(NC)"
	@printf "\n"
	@$(PRINTF) "$(BLUE)System Information:$(NC)"
	@$(PRINTF) "  OS: $$(uname -s)"
	@$(PRINTF) "  User: $$(whoami)"
	@$(PRINTF) "  Claude Dir: $(CLAUDE_DIR)"
	@printf "\n"
	@$(PRINTF) "$(BLUE)Components:$(NC)"
	@if [ -d "$(AGENTS_DIR)" ]; then \
		agent_count=$$(ls -1 $(AGENTS_DIR)/commit-*.md 2>/dev/null | wc -l | tr -d ' '); \
		if [ "$$agent_count" = "5" ]; then \
			printf "%b\n" "  Agents:   $(GREEN)$$agent_count/5 ✓$(NC)"; \
		else \
			printf "%b\n" "  Agents:   $(YELLOW)$$agent_count/5$(NC)"; \
		fi \
	else \
		printf "%b\n" "  Agents:   $(RED)0/5 ✗$(NC)"; \
	fi
	@if [ -d "$(COMMANDS_DIR)" ]; then \
		cmd_count=$$(ls -1 $(COMMANDS_DIR)/*.md 2>/dev/null | grep -E "(commit-pilot|analyze|group|validate|batch-commit|commit-history)" | wc -l | tr -d ' '); \
		if [ "$$cmd_count" = "6" ]; then \
			printf "%b\n" "  Commands: $(GREEN)$$cmd_count/6 ✓$(NC)"; \
		else \
			printf "%b\n" "  Commands: $(YELLOW)$$cmd_count/6$(NC)"; \
		fi \
	else \
		printf "%b\n" "  Commands: $(RED)0/6 ✗$(NC)"; \
	fi
	@if [ -d "$(HOOKS_DIR)" ]; then \
		hook_count=$$(ls -1 $(HOOKS_DIR)/*.js 2>/dev/null | wc -l | tr -d ' '); \
		if [ "$$hook_count" = "2" ]; then \
			printf "%b\n" "  Hooks:    $(GREEN)$$hook_count/2 ✓$(NC)"; \
		else \
			printf "%b\n" "  Hooks:    $(YELLOW)$$hook_count/2$(NC)"; \
		fi \
	else \
		printf "%b\n" "  Hooks:    $(RED)0/2 ✗$(NC)"; \
	fi
	@if [ -f "$(CLAUDE_DIR)/hooks.json" ]; then \
		printf "%b\n" "  Config:   $(GREEN)✓$(NC)"; \
	else \
		printf "%b\n" "  Config:   $(RED)✗$(NC)"; \
	fi
	@printf "\n"
	@$(PRINTF) "$(BLUE)Prerequisites:$(NC)"
	@if command -v git >/dev/null 2>&1; then \
		git_version=$$(git --version | cut -d' ' -f3); \
		printf "%b\n" "  Git:      $(GREEN)✓$(NC) ($$git_version)"; \
	else \
		printf "%b\n" "  Git:      $(RED)✗$(NC)"; \
	fi
	@if command -v node >/dev/null 2>&1; then \
		node_version=$$(node --version); \
		printf "%b\n" "  Node.js:  $(GREEN)✓$(NC) ($$node_version)"; \
	else \
		printf "%b\n" "  Node.js:  $(YELLOW)⚠$(NC) (optional)"; \
	fi
	@printf "\n"

# Generate documentation
.PHONY: docs
docs:
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Generating documentation..."
	@if command -v pandoc >/dev/null 2>&1; then \
		pandoc README.md -o docs/manual.html; \
		printf "%b\n" "$(GREEN)[✓]$(NC) Documentation generated at docs/manual.html"; \
	else \
		printf "%b\n" "$(YELLOW)[⚠]$(NC) Pandoc not installed. Using markdown viewer..."; \
		$(MAKE) readme; \
	fi

# Manual output directory (can be overridden by user)
MANUAL_DIR ?= $(CLAUDE_DIR)

# Generate manual (Markdown format)
.PHONY: man
man:
	@$(PRINTF) "$(BLUE)[INFO]$(NC) Generating manual in Markdown format..."
	@$(PRINTF) "$(CYAN)[INFO]$(NC) Output directory: $(MANUAL_DIR)"
	@mkdir -p $(MANUAL_DIR)
	@{ \
		echo "# CommitCraft Manual"; \
		echo ""; \
		echo "**Version:** 3.0.0"; \
		echo "**Date:** $$(date +'%B %Y')"; \
		echo "**License:** MIT"; \
		echo ""; \
		echo "## 📖 Table of Contents"; \
		echo ""; \
		echo "- [Overview](#overview)"; \
		echo "- [Installation](#installation)"; \
		echo "- [Commands](#commands)"; \
		echo "- [Make Targets](#make-targets)"; \
		echo "- [Configuration](#configuration)"; \
		echo "- [Examples](#examples)"; \
		echo "- [Troubleshooting](#troubleshooting)"; \
		echo ""; \
		echo "## Overview"; \
		echo ""; \
		echo "CommitCraft is an intelligent Git commit system that uses multiple AI agents to analyze, group, validate, and execute perfect git commits with 95% quality guarantee."; \
		echo ""; \
		echo "### ✨ Features"; \
		echo ""; \
		echo "- 🤖 **5 Expert AI Agents** - Specialized for different tasks"; \
		echo "- 📊 **Intelligent Grouping** - Automatically groups related changes"; \
		echo "- ✅ **Quality Validation** - Ensures 90+ quality score"; \
		echo "- 🌐 **Bilingual Support** - English and Chinese"; \
		echo "- 🔒 **Security Hooks** - Prevents dangerous operations"; \
		echo "- 📦 **Batch Processing** - Handle multiple commits efficiently"; \
		echo ""; \
		echo "## Installation"; \
		echo ""; \
		echo "### Quick Install"; \
		echo ""; \
		echo '```bash'; \
		echo "# Standard installation"; \
		echo "make install"; \
		echo ""; \
		echo "# Development mode (with symlinks)"; \
		echo "make dev"; \
		echo '```'; \
		echo ""; \
		echo "### Platform-Specific"; \
		echo ""; \
		echo '```bash'; \
		echo "# macOS"; \
		echo "make install-mac"; \
		echo ""; \
		echo "# Linux"; \
		echo "make install-linux"; \
		echo ""; \
		echo "# Windows (via WSL)"; \
		echo "make install-windows  # Shows instructions"; \
		echo '```'; \
		echo ""; \
		echo "## Commands"; \
		echo ""; \
		echo "After installation, these commands are available in Claude Code:"; \
		echo ""; \
		echo "| Command | Description |"; \
		echo "|---------|-------------|"; \
		echo "| \`/commit-pilot\` | Full commit workflow orchestrator |"; \
		echo "| \`/analyze\` | Analyze repository changes |"; \
		echo "| \`/group\` | Group files for commits |"; \
		echo "| \`/validate\` | Validate commit messages |"; \
		echo "| \`/batch-commit\` | Process multiple commits |"; \
		echo "| \`/commit-history\` | Analyze commit history |"; \
		echo ""; \
		echo "### Command Options"; \
		echo ""; \
		echo '```bash'; \
		echo "# Show help"; \
		echo "/commit-pilot --help"; \
		echo ""; \
		echo "# Quick mode (skip confirmations)"; \
		echo "/commit-pilot --quick"; \
		echo ""; \
		echo "# Preview mode (dry run)"; \
		echo "/commit-pilot --preview"; \
		echo ""; \
		echo "# Force language"; \
		echo "/commit-pilot --language ch  # Chinese"; \
		echo "/commit-pilot --language en  # English"; \
		echo '```'; \
		echo ""; \
		echo "## Make Targets"; \
		echo ""; \
		echo "### Installation Targets"; \
		echo ""; \
		echo "| Target | Description |"; \
		echo "|--------|-------------|"; \
		echo "| \`make install\` | Install all components |"; \
		echo "| \`make dev\` | Development mode with symlinks |"; \
		echo "| \`make update\` | Update existing installation |"; \
		echo "| \`make uninstall\` | Remove all components |"; \
		echo ""; \
		echo "### Maintenance Targets"; \
		echo ""; \
		echo "| Target | Description |"; \
		echo "|--------|-------------|"; \
		echo "| \`make verify\` | Verify installation integrity |"; \
		echo "| \`make status\` | Show installation status |"; \
		echo "| \`make backup\` | Create backup |"; \
		echo "| \`make restore\` | Restore from backup |"; \
		echo "| \`make clean\` | Clean temporary files |"; \
		echo "| \`make clean-all\` | Remove all generated files |"; \
		echo ""; \
		echo "### Development Targets"; \
		echo ""; \
		echo "| Target | Description |"; \
		echo "|--------|-------------|"; \
		echo "| \`make test\` | Run installation tests |"; \
		echo "| \`make lint\` | Check code quality |"; \
		echo "| \`make format\` | Format code files |"; \
		echo "| \`make watch\` | Watch for changes |"; \
		echo ""; \
		echo "### Documentation Targets"; \
		echo ""; \
		echo "| Target | Description |"; \
		echo "|--------|-------------|"; \
		echo "| \`make docs\` | Generate documentation |"; \
		echo "| \`make man\` | Generate this manual |"; \
		echo "| \`make readme\` | Display README |"; \
		echo "| \`make version\` | Show version info |"; \
		echo "| \`make help\` | Show help menu |"; \
		echo ""; \
		echo "## Configuration"; \
		echo ""; \
		echo "### Directory Structure"; \
		echo ""; \
		echo '```'; \
		echo "~/.claude/"; \
		echo "├── agents/          # AI agents"; \
		echo "├── commands/        # Claude commands"; \
		echo "├── hooks/           # Security hooks"; \
		echo "└── hooks.json       # Hooks configuration"; \
		echo '```'; \
		echo ""; \
		echo "### Session Documentation"; \
		echo ""; \
		echo '```'; \
		echo ".claude/commitcraft/"; \
		echo "└── commitcraft-YYYYMMDD-HHMMSS/"; \
		echo "    ├── 00-repository-analysis.md"; \
		echo "    ├── 01-grouping-strategy.md"; \
		echo "    ├── 02-commit-messages.md"; \
		echo "    ├── 03-validation-report.md"; \
		echo "    ├── 04-execution-log.md"; \
		echo "    └── summary.json"; \
		echo '```'; \
		echo ""; \
		echo "## Examples"; \
		echo ""; \
		echo "### Basic Workflow"; \
		echo ""; \
		echo '```bash'; \
		echo "# 1. Install CommitCraft"; \
		echo "make install"; \
		echo ""; \
		echo "# 2. Make your changes"; \
		echo "vim src/feature.js"; \
		echo ""; \
		echo "# 3. Run commit pilot"; \
		echo "/commit-pilot"; \
		echo ""; \
		echo "# 4. Follow interactive prompts"; \
		echo '```'; \
		echo ""; \
		echo "### Batch Processing"; \
		echo ""; \
		echo '```bash'; \
		echo "# Process multiple features"; \
		echo "/batch-commit"; \
		echo ""; \
		echo "# Or use pilot in batch mode"; \
		echo "/commit-pilot --batch"; \
		echo '```'; \
		echo ""; \
		echo "### Development Mode"; \
		echo ""; \
		echo '```bash'; \
		echo "# Install with symlinks"; \
		echo "make dev"; \
		echo ""; \
		echo "# Watch for changes"; \
		echo "make watch"; \
		echo ""; \
		echo "# Test changes"; \
		echo "make test"; \
		echo '```'; \
		echo ""; \
		echo "## Troubleshooting"; \
		echo ""; \
		echo "### Common Issues"; \
		echo ""; \
		echo "#### Installation Failed"; \
		echo '```bash'; \
		echo "# Check prerequisites"; \
		echo "make verify"; \
		echo ""; \
		echo "# Check status"; \
		echo "make status"; \
		echo '```'; \
		echo ""; \
		echo "#### Commands Not Working"; \
		echo '```bash'; \
		echo "# Restart Claude Code after installation"; \
		echo "# Verify installation"; \
		echo "make verify"; \
		echo '```'; \
		echo ""; \
		echo "#### Quality Score Too Low"; \
		echo '```bash'; \
		echo "# Validate message before commit"; \
		echo '/validate "your commit message"'; \
		echo ""; \
		echo "# Check commit history for patterns"; \
		echo "/commit-history --score"; \
		echo '```'; \
		echo ""; \
		echo "### Getting Help"; \
		echo ""; \
		echo "- **Documentation**: https://github.com/zengwenliang416/CommitCraft"; \
		echo "- **Issues**: https://github.com/zengwenliang416/CommitCraft/issues"; \
		echo "- **Command Help**: \`/commit-pilot --help\`"; \
		echo "- **Make Help**: \`make help\`"; \
		echo ""; \
		echo "## License"; \
		echo ""; \
		echo "MIT License - Copyright © 2024 CommitCraft"; \
		echo ""; \
		echo "---"; \
		echo ""; \
		echo "*Generated: $$(date)*"; \
	} > $(MANUAL_DIR)/MANUAL.md
	@$(PRINTF) "$(GREEN)[✓]$(NC) Manual generated at $(MANUAL_DIR)/MANUAL.md"
	@$(PRINTF) "$(BLUE)[INFO]$(NC) View with: cat $(MANUAL_DIR)/MANUAL.md | less"
	@$(PRINTF) ""
	@$(PRINTF) "$(CYAN)Usage Examples:$(NC)"
	@$(PRINTF) "  $(GREEN)# Generate to default location (~/.claude/)$(NC)"
	@$(PRINTF) "  make man"
	@$(PRINTF) ""
	@$(PRINTF) "  $(GREEN)# Generate to current directory$(NC)"
	@$(PRINTF) "  make man MANUAL_DIR=."
	@$(PRINTF) ""
	@$(PRINTF) "  $(GREEN)# Generate to custom location$(NC)"
	@$(PRINTF) "  make man MANUAL_DIR=/path/to/output"

# Display README
.PHONY: readme
readme:
	@if [ -f "README.md" ]; then \
		cat README.md | less; \
	else \
		printf "%b\n" "$(RED)[✗]$(NC) README.md not found"; \
		exit 1; \
	fi

# Version information
.PHONY: version
version:
	@printf "\n"
	@$(PRINTF) "$(CYAN)CommitCraft$(NC) version $(GREEN)3.0.0$(NC)"
	@printf "\n"
	@$(PRINTF) "Multi-Agent Git Commit System for Claude Code"
	@$(PRINTF) "Copyright © 2024 CommitCraft"
	@printf "\n"
	@$(PRINTF) "Repository: https://github.com/zengwenliang416/CommitCraft"
	@$(PRINTF) "License: MIT"
	@printf "\n"
	@$(PRINTF) "Components:"
	@$(PRINTF) "  • 5 AI Agents for commit workflow"
	@$(PRINTF) "  • 6 Commands for Claude Code"
	@$(PRINTF) "  • 2 Security hooks"
	@$(PRINTF) "  • Bilingual support (EN/CH)"
	@printf "\n"

# Default goal - show help
.DEFAULT_GOAL := help
