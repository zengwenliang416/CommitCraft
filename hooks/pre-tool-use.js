#!/usr/bin/env node

/**
 * Pre-Tool Use Hook for CommitCraft
 * Cross-platform Node.js version
 * Purpose: Validate and enhance tool usage before execution
 */

const fs = require('fs');
const path = require('path');

// Configuration
const DANGEROUS_COMMANDS = [
  'rm -rf',
  'git push --force',
  'git reset --hard',
  '> /dev/null 2>&1',
  'chmod 777',
  'curl | bash',
  'wget | sh',
  'Remove-Item -Recurse -Force',
  'Format-',
  'del /f /s /q'
];

const PROTECTED_BRANCHES = [
  'main',
  'master',
  'production',
  'release'
];

const SENSITIVE_PATTERNS = [
  '.env',
  '.git/config',
  'id_rsa',
  '.ssh/',
  '.aws/',
  'credentials',
  'secrets',
  'password',
  'token'
];

// Logging functions
function log(level, message) {
  const timestamp = new Date().toISOString();
  console.error(`[${timestamp}] [${level}] ${message}`);
}

// Validate Bash/Shell commands
function validateBashCommand(command) {
  // Check for dangerous commands
  for (const dangerous of DANGEROUS_COMMANDS) {
    if (command.includes(dangerous)) {
      log('ERROR', `Dangerous command blocked: ${dangerous}`);
      return {
        decision: 'deny',
        message: 'Dangerous command blocked for safety'
      };
    }
  }

  // Check for operations on protected branches
  const branchCheckRegex = /(git checkout|git switch|git branch -[dD])/;
  if (branchCheckRegex.test(command)) {
    for (const branch of PROTECTED_BRANCHES) {
      if (command.includes(branch)) {
        log('WARNING', `Protected branch operation: ${branch}`);
        return {
          decision: 'allow',
          message: `Caution: Protected branch operation on ${branch}`
        };
      }
    }
  }

  // Check for credential exposure
  const credentialRegex = /(password|token|secret|api[_-]?key)\s*=/i;
  if (credentialRegex.test(command)) {
    log('ERROR', 'Potential credential exposure detected');
    return {
      decision: 'deny',
      message: 'Potential credential exposure'
    };
  }

  // Validate git add commands
  if (command === 'git add .' || command === 'git add -A') {
    log('WARNING', 'Broad staging command detected');
    return {
      decision: 'allow',
      message: 'Consider using specific file staging'
    };
  }

  log('INFO', `Command validated: ${command.substring(0, 50)}...`);
  return { decision: 'allow' };
}

// Validate file operations
function validateFileOperation(filePath) {
  // Check for sensitive file paths
  for (const pattern of SENSITIVE_PATTERNS) {
    if (filePath.includes(pattern)) {
      log('ERROR', `Operation on sensitive file blocked: ${filePath}`);
      return {
        decision: 'deny',
        message: 'Sensitive file protection'
      };
    }
  }

  // Check for system files (cross-platform)
  const systemPaths = [
    '/etc/',
    '/usr/',
    '/System/',
    'C:\\Windows\\',
    'C:\\Program Files\\',
    '%WINDIR%',
    '%PROGRAMFILES%'
  ];

  for (const sysPath of systemPaths) {
    if (filePath.startsWith(sysPath) || filePath.includes(sysPath)) {
      log('ERROR', `System file modification blocked: ${filePath}`);
      return {
        decision: 'deny',
        message: 'System file protection'
      };
    }
  }

  log('INFO', `File operation validated: ${filePath}`);
  return { decision: 'allow' };
}

// Main validation function
function validateToolUse(toolName, toolParams) {
  let result = { decision: 'allow' };

  switch (toolName.toLowerCase()) {
    case 'bash':
    case 'shell':
    case 'cmd':
      if (toolParams.command) {
        result = validateBashCommand(toolParams.command);
      }
      break;

    case 'write':
    case 'edit':
    case 'multiedit':
      if (toolParams.file_path || toolParams.filePath) {
        result = validateFileOperation(toolParams.file_path || toolParams.filePath);
      }
      break;

    default:
      // Allow other tools by default
      result = { decision: 'allow' };
  }

  return result;
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
      // Parse input
      const eventData = input ? JSON.parse(input) : {};
      const tool = eventData.tool || '';
      const params = eventData.params || {};

      // Debug logging
      if (process.env.DEBUG) {
        log('DEBUG', `Tool: ${tool}`);
        log('DEBUG', `Params: ${JSON.stringify(params)}`);
      }

      // Validate tool usage
      const result = validateToolUse(tool, params);

      // Output result
      console.log(JSON.stringify(result));
      process.exit(0);

    } catch (error) {
      log('ERROR', `Hook error: ${error.message}`);
      // On error, allow the operation but log the issue
      console.log(JSON.stringify({
        decision: 'allow',
        message: 'Hook error, allowing operation'
      }));
      process.exit(0);
    }
  });

  // Handle timeout
  setTimeout(() => {
    log('WARNING', 'Hook timeout, allowing operation');
    console.log(JSON.stringify({
      decision: 'allow',
      message: 'Hook timeout'
    }));
    process.exit(0);
  }, 5000); // 5 second timeout
}

// Check if running as main module
if (require.main === module) {
  main();
}

// Export for testing
module.exports = {
  validateBashCommand,
  validateFileOperation,
  validateToolUse
};