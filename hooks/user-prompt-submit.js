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

// Enhance prompt with context
function enhancePrompt(originalPrompt) {
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