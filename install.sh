#!/bin/bash

# CommitCraft Installation Script
# Installs multi-agent commit system for Claude Code

set -euo pipefail

# Colors for output
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Configuration
readonly CLAUDE_DIR="$HOME/.claude"
readonly AGENTS_DIR="$CLAUDE_DIR/agents"
readonly COMMANDS_DIR="$CLAUDE_DIR/commands"
readonly HOOKS_DIR="$CLAUDE_DIR/hooks"
readonly PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Logging functions
log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[⚠]${NC} $1"
}

log_error() {
  echo -e "${RED}[✗]${NC} $1"
}

# Banner
show_banner() {
  cat << 'EOF'

 ╔═══════════════════════════════════════╗
 ║      CommitCraft Installation         ║
 ║   Multi-Agent Git Commit System       ║
 ╚═══════════════════════════════════════╝

EOF
}

# Check prerequisites
check_prerequisites() {
  log_info "Checking prerequisites..."

  # Check if git is installed
  if ! command -v git &> /dev/null; then
    log_error "Git is not installed. Please install git first."
    exit 1
  fi

  # Check if Node.js is installed (for hooks)
  if ! command -v node &> /dev/null; then
    log_warning "Node.js is not installed. Hooks may not function properly."
    log_info "Install Node.js from: https://nodejs.org"
  fi

  log_success "Prerequisites check passed"
}

# Create directories
create_directories() {
  log_info "Creating Claude Code directories..."

  mkdir -p "$AGENTS_DIR"
  mkdir -p "$COMMANDS_DIR"
  mkdir -p "$HOOKS_DIR"

  log_success "Directories created"
}

# Install agents
install_agents() {
  log_info "Installing agents..."

  local agents=(
    "commit-analyzer.md"
    "commit-grouper.md"
    "commit-message.md"
    "commit-validator.md"
    "commit-executor.md"
  )


  for agent in "${agents[@]}"; do
    if [ -f "$PROJECT_DIR/agents/$agent" ]; then
      cp "$PROJECT_DIR/agents/$agent" "$AGENTS_DIR/"
      log_success "Installed agent: $agent"
    else
      log_warning "Agent not found: $agent"
    fi
  done

}

# Install commands
install_commands() {
  log_info "Installing commands..."

  local commands=(
    "commit-pilot.md"
    "analyze.md"
    "group.md"
    "validate.md"
    "batch-commit.md"
    "commit-history.md"
  )

  for command in "${commands[@]}"; do
    if [ -f "$PROJECT_DIR/commands/$command" ]; then
      cp "$PROJECT_DIR/commands/$command" "$COMMANDS_DIR/"
      log_success "Installed command: /$command"
    else
      log_warning "Command not found: $command"
    fi
  done
}

# Install hooks
install_hooks() {
  log_info "Installing hooks..."

  # Install Node.js hooks for cross-platform compatibility
  local hooks=(
    "pre-tool-use.js"
    "user-prompt-submit.js"
  )

  for hook in "${hooks[@]}"; do
    if [ -f "$PROJECT_DIR/hooks/$hook" ]; then
      cp "$PROJECT_DIR/hooks/$hook" "$HOOKS_DIR/"
      chmod +x "$HOOKS_DIR/$hook"
      log_success "Installed hook: $hook"
    else
      log_warning "Hook not found: $hook"
    fi
  done

  # Create hooks configuration
  create_hooks_config
}

# Create hooks configuration
create_hooks_config() {
  log_info "Creating hooks configuration..."

  cat > "$CLAUDE_DIR/hooks.json" << 'EOF'
{
  "hooks": {
    "PreToolUse": {
      "script": "node $HOME/.claude/hooks/pre-tool-use.js",
      "enabled": true,
      "description": "Validates tool usage for security and safety"
    },
    "UserPromptSubmit": {
      "script": "node $HOME/.claude/hooks/user-prompt-submit.js",
      "enabled": true,
      "description": "Enhances user input with commit context"
    }
  }
}
EOF

  log_success "Hooks configuration created"
}

# Verify installation
verify_installation() {
  log_info "Verifying installation..."

  local errors=0

  # Check agents
  for agent in commit-analyzer commit-grouper commit-message commit-validator commit-executor; do
    if [ ! -f "$AGENTS_DIR/$agent.md" ]; then
      log_error "Agent missing: $agent.md"
      ((errors++))
    fi
  done

  # Check commands
  for command in commit-pilot analyze group validate batch-commit commit-history; do
    if [ ! -f "$COMMANDS_DIR/$command.md" ]; then
      log_error "Command missing: $command.md"
      ((errors++))
    fi
  done

  # Check hooks
  for hook in pre-tool-use user-prompt-submit; do
    if [ ! -f "$HOOKS_DIR/$hook.js" ]; then
      log_error "Hook missing: $hook.js"
      ((errors++))
    fi
  done

  if [ $errors -eq 0 ]; then
    log_success "Installation verified successfully"
    return 0
  else
    log_error "Installation verification failed with $errors errors"
    return 1
  fi
}

# Show usage instructions
show_usage() {
  cat << EOF

${GREEN}═══════════════════════════════════════════════════════════${NC}
${GREEN}Installation Complete!${NC}
${GREEN}═══════════════════════════════════════════════════════════${NC}

${BLUE}Available Commands:${NC}

  ${GREEN}/commit-pilot${NC}        - Full commit workflow orchestrator
  ${GREEN}/analyze${NC}             - Analyze repository changes
  ${GREEN}/group${NC}               - Group files for commits
  ${GREEN}/validate${NC}            - Validate commit messages
  ${GREEN}/batch-commit${NC}        - Process multiple commits
  ${GREEN}/commit-history${NC}      - Analyze commit history

${BLUE}Quick Start:${NC}

  1. Make some changes to your files
  2. Run: ${GREEN}/commit-pilot${NC}
  3. Follow the interactive prompts

${BLUE}For help:${NC}
  Run: ${GREEN}/commit-pilot --help${NC}

${BLUE}Features:${NC}

  ✨ Multi-agent orchestration
  📊 Intelligent file grouping
  🌐 Bilingual support (EN/CH)
  ✅ Quality validation (≥90 score)
  🔒 Security hooks
  📦 Batch processing

${BLUE}Documentation:${NC}

  README: ${PROJECT_DIR}/README.md
  中文文档: ${PROJECT_DIR}/docs/README-zh.md

${YELLOW}Note:${NC} Restart Claude Code for changes to take effect.

EOF
}

# Uninstall function
uninstall() {
  log_warning "Uninstalling CommitCraft..."

  # Remove agents
  for agent in commit-analyzer commit-grouper commit-message commit-validator commit-executor; do
    rm -f "$AGENTS_DIR/$agent.md"
  done

  # Remove commands
  for command in commit-pilot analyze group validate batch-commit commit-history; do
    rm -f "$COMMANDS_DIR/$command.md"
  done

  # Remove hooks
  rm -f "$HOOKS_DIR/pre-tool-use.js"
  rm -f "$HOOKS_DIR/user-prompt-submit.js"


  log_success "Uninstallation complete"
}

# Main installation flow
main() {
  show_banner

  # Parse arguments
  if [ $# -gt 0 ] && [ "$1" = "--uninstall" ]; then
    uninstall
    exit 0
  fi

  log_info "Starting installation..."

  check_prerequisites
  create_directories
  install_agents
  install_commands
  install_hooks

  if verify_installation; then
    show_usage
    log_success "CommitCraft installed successfully!"
  else
    log_error "Installation completed with errors. Please check the logs."
    exit 1
  fi
}

# Run main function
main "$@"