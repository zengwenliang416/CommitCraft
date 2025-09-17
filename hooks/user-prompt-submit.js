#!/usr/bin/env node

/**
 * User Prompt Submit Hook for CommitCraft
 * Cross-platform Node.js version
 * Purpose: Enhance and validate user input for commit operations
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Configuration
const COMMIT_KEYWORDS = [
  'commit',
  '提交',
  'git commit',
  '/commit'
];

const CONTEXT_INDICATORS = [
  'feat',
  'fix',
  'docs',
  'refactor',
  'test',
  'chore',
  'style',
  'perf'
];

// Detect commit intent
function detectCommitIntent(prompt) {
  const promptLower = prompt.toLowerCase();
  return COMMIT_KEYWORDS.some(keyword => promptLower.includes(keyword));
}

// Extract context from prompt
function extractContext(prompt) {
  const promptLower = prompt.toLowerCase();

  // Check for explicit type indicators
  for (const indicator of CONTEXT_INDICATORS) {
    if (promptLower.includes(indicator)) {
      return indicator;
    }
  }

  // Infer from keywords
  if (promptLower.match(/bug|fix|修复|问题/)) {
    return 'fix';
  } else if (promptLower.match(/feature|add|implement|功能|添加/)) {
    return 'feat';
  } else if (promptLower.match(/document|docs|readme|文档/)) {
    return 'docs';
  } else if (promptLower.match(/refactor|reorganize|重构/)) {
    return 'refactor';
  } else if (promptLower.match(/test|测试/)) {
    return 'test';
  }

  return 'general';
}

// Get git status (cross-platform)
function getGitStatus() {
  try {
    const status = execSync('git status --porcelain', { encoding: 'utf8' });
    return status.split('\n').slice(0, 5).join('\n');
  } catch (error) {
    return 'Unable to get git status';
  }
}

// Check current git branch
function getCurrentBranch() {
  try {
    const branch = execSync('git branch --show-current', { encoding: 'utf8' }).trim();
    return branch;
  } catch (error) {
    return null;
  }
}

// Detect language preference
function detectLanguagePreference(prompt) {
  if (prompt.match(/中文|chinese|zh/i)) {
    return 'chinese';
  } else if (prompt.match(/english|en/i)) {
    return 'english';
  }
  return 'auto';
}

// Check if this is a help command
function isHelpCommand(prompt) {
  // Match any CommitCraft command with --help, -h, or help flag
  const helpPatterns = [
    /^\s*\/commit-pilot\s+(--help|-h|help)\s*$/i,
    /^\s*\/analyze\s+(--help|-h|help)\s*$/i,
    /^\s*\/group\s+(--help|-h|help)\s*$/i,
    /^\s*\/validate\s+(--help|-h|help)\s*$/i,
    /^\s*\/batch-commit\s+(--help|-h|help)\s*$/i,
    /^\s*\/commit-history\s+(--help|-h|help)\s*$/i
  ];

  return helpPatterns.some(pattern => pattern.test(prompt));
}

// Extract command name from help request
function extractCommandFromHelp(prompt) {
  const match = prompt.match(/^\s*\/(\S+)\s+(--help|-h|help)\s*$/i);
  return match ? match[1].toLowerCase() : null;
}

// Generate help text based on command
function generateHelpText(command) {
  const helpTexts = {
    'commit-pilot': generateCommitPilotHelp(),
    'analyze': generateAnalyzeHelp(),
    'group': generateGroupHelp(),
    'validate': generateValidateHelp(),
    'batch-commit': generateBatchCommitHelp(),
    'commit-history': generateCommitHistoryHelp()
  };

  return helpTexts[command] || generateGeneralHelp();
}

// Generate general help for all commands
function generateGeneralHelp() {
  return `
CommitCraft - Multi-Agent Git Commit System
═════════════════════════════════════════════

Available Commands:

  /commit-pilot        Full commit workflow orchestrator
  /analyze             Analyze repository changes
  /group               Group files for commits
  /validate            Validate commit messages
  /batch-commit        Process multiple commits
  /commit-history      Analyze commit history

Use '/[command] --help' for detailed information about each command.

Examples:
  /commit-pilot --help
  /analyze --help
  /group --help
`;
}

// Generate help text for commit-pilot
function generateCommitPilotHelp() {
  return `
CommitCraft Pilot - Intelligent Git Commit Orchestrator
════════════════════════════════════════════════════════

USAGE:
  /commit-pilot [DESCRIPTION] [OPTIONS]

DESCRIPTION:
  Multi-agent system that analyzes, groups, validates, and
  executes perfect git commits through intelligent orchestration.

OPTIONS:
  --help              Show this help message
  --batch             Process multiple features separately
  --quick             Use smart defaults, skip confirmations
  --preview           Dry run without actual commits
  --skip-validation   Skip quality checks (not recommended)
  --language <en|ch>  Force message language

AGENTS:
  • commit-analyzer   - Analyzes repository changes
  • commit-grouper    - Groups files intelligently
  • commit-message    - Generates commit messages
  • commit-validator  - Validates quality (90+ required)
  • commit-executor   - Executes commits safely

WORKFLOW:
  1. Analyze repository changes
  2. Group files by feature/module
  3. Generate professional messages
  4. Validate quality standards
  5. Execute commits with verification

EXAMPLES:
  Basic:       /commit-pilot
  With desc:   /commit-pilot "fix login bug"
  Batch:       /commit-pilot --batch
  Preview:     /commit-pilot --preview
  Quick mode:  /commit-pilot --quick
  Chinese:     /commit-pilot --language ch

QUALITY STANDARDS:
  • Format compliance required
  • Quality score must be ≥ 90/100
  • Security validation enforced
  • Convention adherence checked

MORE INFO:
  Repository: https://github.com/zengwenliang416/CommitCraft
  Docs: See README.md for detailed documentation
`;
}

// Generate help text for analyze command
function generateAnalyzeHelp() {
  return `
/analyze - Repository Change Analyzer
══════════════════════════════════════

USAGE:
  /analyze [OPTIONS]

DESCRIPTION:
  Analyzes all changes in your repository and provides detailed
  insights about modified files, their relationships, and impact.

OPTIONS:
  --deep              Perform deep analysis with dependency tracking
  --summary           Show only summary without details
  --format <format>   Output format: text, json, markdown (default: text)

OUTPUT INCLUDES:
  • File change statistics
  • Module dependency analysis
  • Feature boundary detection
  • Change classification (feat/fix/docs/etc)
  • Recommended commit strategy

EXAMPLES:
  /analyze
  /analyze --deep
  /analyze --format json
`;
}

// Generate help text for group command
function generateGroupHelp() {
  return `
/group - Intelligent File Grouper
═══════════════════════════════

USAGE:
  /group [OPTIONS]

DESCRIPTION:
  Groups related files into logical commits based on features,
  modules, and dependencies.

OPTIONS:
  --strategy <type>   Grouping strategy: feature, module, type (default: feature)
  --max-files <n>     Maximum files per group (default: 10)
  --interactive       Interactive mode for manual adjustments

STRATEGIES:
  • feature   - Group by feature/functionality
  • module    - Group by code module/component
  • type      - Group by change type (feat/fix/docs)

EXAMPLES:
  /group
  /group --strategy module
  /group --interactive
`;
}

// Generate help text for validate command
function generateValidateHelp() {
  return `
/validate - Commit Message Validator
═════════════════════════════════════

USAGE:
  /validate <message> [OPTIONS]

DESCRIPTION:
  Validates commit messages against quality standards and
  conventional commits format.

OPTIONS:
  --strict            Enforce strict validation (score ≥ 95)
  --fix               Suggest fixes for issues
  --format <type>     Expected format: conventional, angular, custom

VALIDATION CRITERIA:
  • Format compliance (30 points)
  • Content quality (40 points)
  • Security check (20 points)
  • Convention adherence (10 points)

EXAMPLES:
  /validate "feat: add user authentication"
  /validate --strict
  /validate --fix
`;
}

// Generate help text for batch-commit command
function generateBatchCommitHelp() {
  return `
/batch-commit - Batch Commit Processor
═══════════════════════════════════════

USAGE:
  /batch-commit [OPTIONS]

DESCRIPTION:
  Processes multiple features as separate commits in sequence,
  ideal for large changesets with multiple logical units.

OPTIONS:
  --auto              Automatic mode without confirmations
  --preview           Preview all commits before execution
  --parallel <n>      Process n commits in parallel (default: 1)

WORKFLOW:
  1. Analyzes all changes
  2. Groups into multiple commits
  3. Generates messages for each
  4. Validates all messages
  5. Executes commits sequentially

EXAMPLES:
  /batch-commit
  /batch-commit --preview
  /batch-commit --auto
`;
}

// Generate help text for commit-history command
function generateCommitHistoryHelp() {
  return `
/commit-history - Commit History Analyzer
══════════════════════════════════════════

USAGE:
  /commit-history [OPTIONS]

DESCRIPTION:
  Analyzes commit history to understand patterns, conventions,
  and team practices for better commit message generation.

OPTIONS:
  --limit <n>         Number of commits to analyze (default: 50)
  --author <name>     Filter by author
  --since <date>      Analyze commits since date
  --stats             Show detailed statistics

OUTPUT:
  • Common commit patterns
  • Message format preferences
  • Language usage (EN/CH)
  • Type distribution (feat/fix/docs)
  • Average message quality

EXAMPLES:
  /commit-history
  /commit-history --limit 100
  /commit-history --since "2024-01-01"
`;
}

// Enhance prompt with context
function enhancePrompt(originalPrompt) {
  // Check if this is a help command first
  if (isHelpCommand(originalPrompt)) {
    return generateCommitPilotHelp();
  }

  if (!detectCommitIntent(originalPrompt)) {
    return originalPrompt;
  }

  const context = extractContext(originalPrompt);
  const gitStatus = getGitStatus();
  const currentBranch = getCurrentBranch();
  const language = detectLanguagePreference(originalPrompt);

  let enhancedPrompt = `${originalPrompt}

[CommitCraft Context]
- Detected Type: ${context}
- Multi-agent workflow enabled
- Quality validation: Required (≥90 score)
- Interactive mode: Enabled
- Language: ${language === 'auto' ? 'Auto-detect from content' : language}
`;

  if (currentBranch) {
    enhancedPrompt += `\n- Current branch: ${currentBranch}`;
  }

  enhancedPrompt += `

Current changes preview:
${gitStatus}

Available agents:
1. commit-analyzer - Analyze repository changes
2. commit-grouper - Group files logically
3. commit-message - Generate commit messages
4. commit-validator - Validate quality
5. commit-executor - Execute commits

Workflow will:
1. Analyze all changes comprehensively
2. Group files by feature/module
3. Request user confirmation at each step
4. Generate professional commit messages
5. Validate quality before execution`;

  // Add workflow hints based on prompt
  if (originalPrompt.match(/batch|multiple|批量/i)) {
    enhancedPrompt += '\n\n[Workflow Mode] Batch mode: Will process multiple features separately';
  } else if (originalPrompt.match(/preview|dry|预览/i)) {
    enhancedPrompt += '\n\n[Workflow Mode] Preview mode: Will show changes without committing';
  } else if (originalPrompt.match(/quick|fast|快速/i)) {
    enhancedPrompt += '\n\n[Workflow Mode] Quick mode: Minimal interaction, automated decisions';
  }

  // Add warnings for dangerous operations
  if (originalPrompt.match(/force|--force/i)) {
    enhancedPrompt += '\n\n⚠️ WARNING: Force operation requested. Extra confirmation will be required.';
  }

  // Add protected branch warning
  if (currentBranch && ['main', 'master'].includes(currentBranch)) {
    enhancedPrompt += `\n\n⚠️ CAUTION: You are on the ${currentBranch} branch.`;
  }

  // Add suggestions
  const fileCount = (gitStatus.match(/\n/g) || []).length;
  if (fileCount > 10) {
    enhancedPrompt += '\n\n💡 Suggestion: Consider grouping changes into multiple commits';
  } else if (fileCount === 0) {
    enhancedPrompt += '\n\n💡 Suggestion: No changes detected. Check if files are saved';
  }

  return enhancedPrompt;
}

// Main execution
function main() {
  let input = '';

  // Read from stdin
  process.stdin.setEncoding('utf8');

  process.stdin.on('data', (chunk) => {
    input += chunk;
  });

  process.stdin.on('end', () => {
    try {
      // Use input as user prompt
      const userPrompt = input.trim() || 'commit my changes';

      // Check if this is a help command
      if (isHelpCommand(userPrompt)) {
        // For help commands, directly output the help text and block the command
        const commandName = extractCommandFromHelp(userPrompt);
        const helpText = generateHelpText(commandName);
        const result = {
          decision: 'block',
          message: helpText,
          metadata: {
            is_help_command: true,
            command: commandName,
            timestamp: new Date().toISOString()
          }
        };
        console.log(JSON.stringify(result, null, 2));
        process.exit(0);
      }

      // Process the prompt
      const enhancedPrompt = enhancePrompt(userPrompt);
      const commitIntentDetected = detectCommitIntent(userPrompt);
      const contextType = extractContext(userPrompt);
      const languagePreference = detectLanguagePreference(userPrompt);

      // Output result
      const result = {
        decision: 'allow',
        enhanced_prompt: enhancedPrompt,
        metadata: {
          language_preference: languagePreference,
          commit_intent_detected: commitIntentDetected,
          context_type: contextType,
          timestamp: new Date().toISOString()
        }
      };

      console.log(JSON.stringify(result, null, 2));
      process.exit(0);

    } catch (error) {
      console.error(`[UserPromptHook] Error: ${error.message}`);
      // On error, pass through original prompt
      console.log(JSON.stringify({ decision: 'allow' }));
      process.exit(0);
    }
  });

  // Handle timeout
  setTimeout(() => {
    console.error('[UserPromptHook] Timeout, passing through');
    console.log(JSON.stringify({ decision: 'allow' }));
    process.exit(0);
  }, 3000); // 3 second timeout
}

// Check if running as main module
if (require.main === module) {
  main();
}

// Export for testing
module.exports = {
  detectCommitIntent,
  extractContext,
  detectLanguagePreference,
  enhancePrompt
};