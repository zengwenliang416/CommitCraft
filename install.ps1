# CommitCraft Installation Script for Windows
# PowerShell script for installing multi-agent commit system for Claude Code

param(
    [switch]$Uninstall
)

# Set strict mode
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Configuration
$CLAUDE_DIR = "$env:USERPROFILE\.claude"
$AGENTS_DIR = "$CLAUDE_DIR\agents"
$COMMANDS_DIR = "$CLAUDE_DIR\commands"
$HOOKS_DIR = "$CLAUDE_DIR\hooks"
$PROJECT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

# Color functions
function Write-Info { Write-Host "[INFO]" -ForegroundColor Blue -NoNewline; Write-Host " $args" }
function Write-Success { Write-Host "[✓]" -ForegroundColor Green -NoNewline; Write-Host " $args" }
function Write-Warning { Write-Host "[⚠]" -ForegroundColor Yellow -NoNewline; Write-Host " $args" }
function Write-Error { Write-Host "[✗]" -ForegroundColor Red -NoNewline; Write-Host " $args" }

# Show banner
function Show-Banner {
    Write-Host @"

 ╔═══════════════════════════════════════╗
 ║      CommitCraft Installation         ║
 ║   Multi-Agent Git Commit System       ║
 ╚═══════════════════════════════════════╝

"@ -ForegroundColor Cyan
}

# Check prerequisites
function Test-Prerequisites {
    Write-Info "Checking prerequisites..."

    # Check if git is installed
    try {
        git --version | Out-Null
        Write-Success "Git is installed"
    }
    catch {
        Write-Error "Git is not installed. Please install Git first."
        Write-Host "Download from: https://git-scm.com/download/win"
        exit 1
    }

    # Check if Node.js is installed (for hooks)
    try {
        node --version | Out-Null
        Write-Success "Node.js is installed"
    }
    catch {
        Write-Warning "Node.js is not installed. Hooks will use PowerShell fallback."
        Write-Host "For better performance, install Node.js from: https://nodejs.org"
    }

    Write-Success "Prerequisites check passed"
}

# Create directories
function New-Directories {
    Write-Info "Creating Claude Code directories..."

    @($AGENTS_DIR, $COMMANDS_DIR, $HOOKS_DIR) | ForEach-Object {
        if (!(Test-Path $_)) {
            New-Item -ItemType Directory -Path $_ -Force | Out-Null
            Write-Success "Created directory: $_"
        } else {
            Write-Info "Directory exists: $_"
        }
    }
}

# Install agents
function Install-Agents {
    Write-Info "Installing agents..."

    $agents = @(
        "commit-analyzer.md",
        "commit-grouper.md",
        "commit-message.md",
        "commit-validator.md",
        "commit-executor.md"
    )

    foreach ($agent in $agents) {
        $sourcePath = Join-Path $PROJECT_DIR "agents\$agent"
        $destPath = Join-Path $AGENTS_DIR $agent

        if (Test-Path $sourcePath) {
            Copy-Item -Path $sourcePath -Destination $destPath -Force
            Write-Success "Installed agent: $agent"
        } else {
            Write-Warning "Agent not found: $agent"
        }
    }
}

# Install commands
function Install-Commands {
    Write-Info "Installing commands..."

    $commands = @(
        "commit-pilot.md",
        "analyze.md",
        "group.md",
        "validate.md",
        "batch-commit.md",
        "commit-history.md"
    )

    foreach ($command in $commands) {
        $sourcePath = Join-Path $PROJECT_DIR "commands\$command"
        $destPath = Join-Path $COMMANDS_DIR $command

        if (Test-Path $sourcePath) {
            Copy-Item -Path $sourcePath -Destination $destPath -Force
            Write-Success "Installed command: /$($command -replace '\.md$','')"
        } else {
            Write-Warning "Command not found: $command"
        }
    }
}

# Install hooks (PowerShell versions)
function Install-Hooks {
    Write-Info "Installing hooks..."

    # Copy Node.js hooks
    $hooks = @(
        "pre-tool-use.js",
        "user-prompt-submit.js"
    )

    foreach ($hook in $hooks) {
        $sourcePath = Join-Path $PROJECT_DIR "hooks\$hook"
        $destPath = Join-Path $HOOKS_DIR $hook

        if (Test-Path $sourcePath) {
            Copy-Item -Path $sourcePath -Destination $destPath -Force
            Write-Success "Installed hook: $hook"
        } else {
            Write-Warning "Hook not found: $hook"
        }
    }

    # Create PowerShell version of pre-tool-use hook
    $preToolUseContent = @'
# Pre-Tool Use Hook for CommitCraft (PowerShell version)
param(
    [string]$JsonInput
)

$eventData = $JsonInput | ConvertFrom-Json
$tool = $eventData.tool
$params = $eventData.params

# Dangerous commands to block
$dangerousCommands = @(
    "rm -rf",
    "git push --force",
    "git reset --hard",
    "Remove-Item -Recurse -Force",
    "Format-"
)

# Check Bash commands
if ($tool -eq "Bash") {
    $command = $params.command

    foreach ($dangerous in $dangerousCommands) {
        if ($command -like "*$dangerous*") {
            @{
                decision = "deny"
                message = "Dangerous command blocked for safety"
            } | ConvertTo-Json
            exit 0
        }
    }

    # Check for credential exposure
    if ($command -match "(password|token|secret|api[_-]key).*=") {
        @{
            decision = "deny"
            message = "Potential credential exposure"
        } | ConvertTo-Json
        exit 0
    }
}

# Allow by default
@{ decision = "allow" } | ConvertTo-Json
'@

    $preToolUsePath = Join-Path $HOOKS_DIR "pre-tool-use.ps1"
    $preToolUseContent | Out-File -FilePath $preToolUsePath -Encoding UTF8
    Write-Success "Installed hook: pre-tool-use.ps1"

    # Create PowerShell version of user-prompt-submit hook
    $userPromptContent = @'
# User Prompt Submit Hook for CommitCraft (PowerShell version)
param(
    [string]$UserPrompt
)

$commitKeywords = @("commit", "提交", "git commit", "/commit")
$enhanced = $false

foreach ($keyword in $commitKeywords) {
    if ($UserPrompt -like "*$keyword*") {
        $enhanced = $true
        break
    }
}

if ($enhanced) {
    $enhancedPrompt = @"
$UserPrompt

[CommitCraft Context]
- Multi-agent workflow enabled
- Quality validation: Required (>=90 score)
- Interactive mode: Enabled

Workflow agents:
1. commit-analyzer - Analyze changes
2. commit-grouper - Group files
3. commit-message - Generate messages
4. commit-validator - Validate quality
5. commit-executor - Execute commits
"@

    @{
        decision = "allow"
        enhanced_prompt = $enhancedPrompt
    } | ConvertTo-Json
} else {
    @{ decision = "allow" } | ConvertTo-Json
}
'@

    $userPromptPath = Join-Path $HOOKS_DIR "user-prompt-submit.ps1"
    $userPromptContent | Out-File -FilePath $userPromptPath -Encoding UTF8
    Write-Success "Installed hook: user-prompt-submit.ps1"

    # Create hooks configuration
    Create-HooksConfig
}


# Create hooks configuration
function Create-HooksConfig {
    Write-Info "Creating hooks configuration..."

    $hooksConfig = @{
        hooks = @{
            PreToolUse = @{
                script = "`$HOME/.claude/hooks/pre-tool-use.ps1"
                enabled = $true
                description = "Validates tool usage for security and safety"
            }
            UserPromptSubmit = @{
                script = "`$HOME/.claude/hooks/user-prompt-submit.ps1"
                enabled = $true
                description = "Enhances user input with commit context"
            }
        }
    } | ConvertTo-Json -Depth 3

    $configPath = Join-Path $CLAUDE_DIR "hooks.json"
    $hooksConfig | Out-File -FilePath $configPath -Encoding UTF8
    Write-Success "Hooks configuration created"
}

# Verify installation
function Test-Installation {
    Write-Info "Verifying installation..."

    $errors = 0

    # Check agents
    @("commit-analyzer", "commit-grouper", "commit-message", "commit-validator", "commit-executor") | ForEach-Object {
        if (!(Test-Path "$AGENTS_DIR\$_.md")) {
            Write-Error "Agent missing: $_.md"
            $errors++
        }
    }

    # Check commands
    @("commit-pilot", "analyze", "group", "validate", "batch-commit", "commit-history") | ForEach-Object {
        if (!(Test-Path "$COMMANDS_DIR\$_.md")) {
            Write-Error "Command missing: $_.md"
            $errors++
        }
    }

    # Check hooks
    @("pre-tool-use", "user-prompt-submit") | ForEach-Object {
        if (!(Test-Path "$HOOKS_DIR\$_.ps1")) {
            Write-Error "Hook missing: $_.ps1"
            $errors++
        }
    }

    if ($errors -eq 0) {
        Write-Success "Installation verified successfully"
        return $true
    } else {
        Write-Error "Installation verification failed with $errors errors"
        return $false
    }
}

# Show usage instructions
function Show-Usage {
    Write-Host @"

$(Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green)
$(Write-Host "Installation Complete!" -ForegroundColor Green)
$(Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green)

Available Commands:

  /commit-pilot        - Full commit workflow orchestrator
  /analyze             - Analyze repository changes
  /group               - Group files for commits
  /validate            - Validate commit messages
  /batch-commit        - Process multiple commits
  /commit-history      - Analyze commit history

Quick Start:

  1. Make some changes to your files
  2. Run: /commit-pilot
  3. Follow the interactive prompts

For help:
  Run: /commit-pilot --help

Features:

  ✨ Multi-agent orchestration
  📊 Intelligent file grouping
  🌐 Bilingual support (EN/CH)
  ✅ Quality validation (≥90 score)
  🔒 Security hooks
  📦 Batch processing

Documentation:

  README: $PROJECT_DIR\README.md

Note: Restart Claude Code for changes to take effect.

"@ -ForegroundColor Cyan
}

# Uninstall function
function Uninstall-CommitCraft {
    Write-Warning "Uninstalling CommitCraft..."

    # Remove agents
    @("commit-analyzer", "commit-grouper", "commit-message", "commit-validator", "commit-executor") | ForEach-Object {
        Remove-Item -Path "$AGENTS_DIR\$_.md" -Force -ErrorAction SilentlyContinue
    }

    # Remove commands
    @("commit-pilot", "analyze", "group", "validate", "batch-commit", "commit-history") | ForEach-Object {
        Remove-Item -Path "$COMMANDS_DIR\$_.md" -Force -ErrorAction SilentlyContinue
    }

    # Remove hooks
    Remove-Item -Path "$HOOKS_DIR\pre-tool-use.ps1" -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$HOOKS_DIR\user-prompt-submit.ps1" -Force -ErrorAction SilentlyContinue

    Write-Success "Uninstallation complete"
}

# Main execution
function Main {
    Show-Banner

    if ($Uninstall) {
        Uninstall-CommitCraft
        exit 0
    }

    Write-Info "Starting installation..."

    Test-Prerequisites
    New-Directories
    Install-Agents
    Install-Commands
    Install-Hooks

    if (Test-Installation) {
        Show-Usage
        Write-Success "CommitCraft installed successfully!"
    } else {
        Write-Error "Installation completed with errors. Please check the logs."
        exit 1
    }
}

# Run main function
Main