#Requires -Version 5.1

<#
.SYNOPSIS
    CommitCraft Interactive Installer

.DESCRIPTION
    Installation script for CommitCraft with intelligent git commit workflow with 5-agent pipeline.
    Installs globally to user profile directory (~/.claude) by default.

.PARAMETER InstallMode
    Installation mode: "Global" (default and only supported mode)

.PARAMETER TargetPath
    Target path for Custom installation mode

.PARAMETER Force
    Skip confirmation prompts

.PARAMETER NonInteractive
    Run in non-interactive mode with default options

.PARAMETER BackupAll
    Automatically backup all existing files without confirmation prompts (enabled by default)

.PARAMETER NoBackup
    Disable automatic backup functionality

.EXAMPLE
    .\Install-Claude.ps1
    Interactive installation with mode selection

.EXAMPLE
    .\Install-Claude.ps1 -InstallMode Global -Force
    Global installation without prompts

.EXAMPLE
    .\Install-Claude.ps1 -Force -NonInteractive
    Global installation without prompts

.EXAMPLE
    .\Install-Claude.ps1 -BackupAll
    Global installation with automatic backup of all existing files

.EXAMPLE
    .\Install-Claude.ps1 -NoBackup
    Installation without any backup (overwrite existing files)
#>

param(
    [ValidateSet("Global", "Path")]
    [string]$InstallMode = "",

    [string]$TargetPath = "",

    [switch]$Force,

    [switch]$NonInteractive,

    [switch]$BackupAll,

    [switch]$NoBackup,

    [string]$SourceVersion = "",

    [string]$SourceBranch = "",

    [string]$SourceCommit = ""
)

# Set encoding for proper Unicode support
if ($PSVersionTable.PSVersion.Major -ge 6) {
    $OutputEncoding = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    [Console]::InputEncoding = [System.Text.Encoding]::UTF8
} else {
    # For Windows PowerShell 5.1
    chcp 65001 | Out-Null
}

# Script metadata
$ScriptName = "CommitCraft Installer"
$ScriptVersion = "2.2.0"  # Installer script version

# Default version (will be overridden by -SourceVersion from install-remote.ps1)
$DefaultVersion = "unknown"

# Initialize backup behavior - backup is enabled by default unless NoBackup is specified
if (-not $BackupAll -and -not $NoBackup) {
    $BackupAll = $true
    Write-Verbose "Auto-backup enabled by default. Use -NoBackup to disable."
}

# Colors for output
$ColorSuccess = "Green"
$ColorInfo = "Cyan"
$ColorWarning = "Yellow"
$ColorError = "Red"
$ColorPrompt = "Magenta"

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Show-Banner {
    Write-Host ""
    Write-Host '╔═══════════════════════════════════════════════════════════════════════════════╗' -ForegroundColor Cyan
    Write-Host '║                                                                               ║' -ForegroundColor Cyan
    Write-Host '║   ██████╗ ██████╗ ███╗   ███╗███╗   ███╗██╗████████╗ ██████╗██████╗  █████╗ ║' -ForegroundColor Cyan
    Write-Host '║  ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██║╚══██╔══╝██╔════╝██╔══██╗██╔══██╗║' -ForegroundColor Cyan
    Write-Host '║  ██║     ██║   ██║██╔████╔██║██╔████╔██║██║   ██║   ██║     ██████╔╝███████║║' -ForegroundColor Cyan
    Write-Host '║  ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██║   ██║   ██║     ██╔══██╗██╔══██║║' -ForegroundColor Cyan
    Write-Host '║  ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║██║   ██║   ╚██████╗██║  ██║██║  ██║║' -ForegroundColor Cyan
    Write-Host '║   ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝║' -ForegroundColor Cyan
    Write-Host '║                                                                               ║' -ForegroundColor Cyan
    Write-Host '║              ██████╗██████╗  █████╗ ███████╗████████╗                        ║' -ForegroundColor Green
    Write-Host '║             ██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝                        ║' -ForegroundColor Green
    Write-Host '║             ██║     ██████╔╝███████║█████╗     ██║                           ║' -ForegroundColor Green
    Write-Host '║             ██║     ██╔══██╗██╔══██║██╔══╝     ██║                           ║' -ForegroundColor Green
    Write-Host '║             ╚██████╗██║  ██║██║  ██║██║        ██║                           ║' -ForegroundColor Green
    Write-Host '║              ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝                           ║' -ForegroundColor Green
    Write-Host '║                                                                               ║' -ForegroundColor Cyan
    Write-Host '║           Intelligent Git Commit Workflow with 5-Agent Pipeline              ║' -ForegroundColor Yellow
    Write-Host '║        Analyzer → Grouper → Message → Validator → Executor                   ║' -ForegroundColor Yellow
    Write-Host '║                                                                               ║' -ForegroundColor Cyan
    Write-Host '╚═══════════════════════════════════════════════════════════════════════════════╝' -ForegroundColor Cyan
    Write-Host ""
}

function Show-Header {
    param(
        [string]$InstallVersion = $DefaultVersion
    )

    Show-Banner
    Write-ColorOutput "    $ScriptName v$ScriptVersion" $ColorInfo
    if ($InstallVersion -ne "unknown") {
        Write-ColorOutput "    Installing CommitCraft v$InstallVersion" $ColorInfo
    }
    Write-ColorOutput "    Intelligent Git Commit Workflow with 5-Agent Pipeline" $ColorInfo
    Write-ColorOutput "========================================================================" $ColorInfo
    if ($NoBackup) {
        Write-ColorOutput "WARNING: Backup disabled - existing files will be overwritten!" $ColorWarning
    } else {
        Write-ColorOutput "Auto-backup enabled - existing files will be backed up" $ColorSuccess
    }
    Write-Host ""
}

function Test-Prerequisites {
    # Test PowerShell version
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        Write-ColorOutput "ERROR: PowerShell 5.1 or higher is required" $ColorError
        Write-ColorOutput "Current version: $($PSVersionTable.PSVersion)" $ColorError
        return $false
    }

    # Test source files exist
    $sourceDir = $PSScriptRoot
    $claudeDir = Join-Path $sourceDir ".claude"
    $claudeMd = Join-Path $sourceDir "CLAUDE.md"

    if (-not (Test-Path $claudeDir)) {
        Write-ColorOutput "ERROR: .claude directory not found in $sourceDir" $ColorError
        return $false
    }

    if (-not (Test-Path $claudeMd)) {
        Write-ColorOutput "ERROR: CLAUDE.md file not found in $sourceDir" $ColorError
        return $false
    }

    # CommitCraft only requires .claude directory and CLAUDE.md
    # No need for .codex, .gemini, or .qwen directories

    Write-ColorOutput "Prerequisites check passed" $ColorSuccess
    return $true
}

function Get-UserChoiceWithArrows {
    param(
        [string]$Prompt,
        [string[]]$Options,
        [int]$DefaultIndex = 0
    )

    if ($NonInteractive) {
        Write-ColorOutput "Non-interactive mode: Using default '$($Options[$DefaultIndex])'" $ColorInfo
        return $Options[$DefaultIndex]
    }

    # Test if we can use console features (interactive terminal)
    $canUseConsole = $true
    try {
        $null = [Console]::CursorVisible
        $null = $Host.UI.RawUI.ReadKey
    }
    catch {
        $canUseConsole = $false
    }

    # Fallback to simple numbered menu if console not available
    if (-not $canUseConsole) {
        Write-ColorOutput "Arrow navigation not available in this environment. Using numbered menu." $ColorWarning
        return Get-UserChoice -Prompt $Prompt -Options $Options -Default $Options[$DefaultIndex]
    }

    $selectedIndex = $DefaultIndex
    $cursorVisible = $true

    try {
        $cursorVisible = [Console]::CursorVisible
        [Console]::CursorVisible = $false
    }
    catch {
        # Silently continue if cursor control fails
    }

    try {
        Write-Host ""
        Write-ColorOutput $Prompt $ColorPrompt
        Write-Host ""

        while ($true) {
            # Display options
            for ($i = 0; $i -lt $Options.Count; $i++) {
                $prefix = if ($i -eq $selectedIndex) { "  > " } else { "    " }
                $color = if ($i -eq $selectedIndex) { $ColorSuccess } else { "White" }

                # Clear line and write option
                Write-Host "`r$prefix$($Options[$i])".PadRight(80) -ForegroundColor $color
            }

            Write-Host ""
            Write-Host "  Use " -NoNewline -ForegroundColor DarkGray
            Write-Host "UP/DOWN" -NoNewline -ForegroundColor Yellow
            Write-Host " arrows to navigate, " -NoNewline -ForegroundColor DarkGray
            Write-Host "ENTER" -NoNewline -ForegroundColor Yellow
            Write-Host " to select, or type " -NoNewline -ForegroundColor DarkGray
            Write-Host "1-$($Options.Count)" -NoNewline -ForegroundColor Yellow
            Write-Host "" -ForegroundColor DarkGray

            # Read key
            $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

            # Handle arrow keys
            if ($key.VirtualKeyCode -eq 38) {
                # Up arrow
                $selectedIndex = if ($selectedIndex -gt 0) { $selectedIndex - 1 } else { $Options.Count - 1 }
            }
            elseif ($key.VirtualKeyCode -eq 40) {
                # Down arrow
                $selectedIndex = if ($selectedIndex -lt ($Options.Count - 1)) { $selectedIndex + 1 } else { 0 }
            }
            elseif ($key.VirtualKeyCode -eq 13) {
                # Enter key
                Write-Host ""
                return $Options[$selectedIndex]
            }
            elseif ($key.Character -match '^\d$') {
                # Number key
                $num = [int]::Parse($key.Character)
                if ($num -ge 1 -and $num -le $Options.Count) {
                    Write-Host ""
                    return $Options[$num - 1]
                }
            }

            # Move cursor back up to redraw menu
            $linesToMove = $Options.Count + 2
            try {
                for ($i = 0; $i -lt $linesToMove; $i++) {
                    [Console]::SetCursorPosition(0, [Console]::CursorTop - 1)
                }
            }
            catch {
                # If cursor positioning fails, just continue
                break
            }
        }
    }
    finally {
        try {
            [Console]::CursorVisible = $cursorVisible
        }
        catch {
            # Silently continue if cursor control fails
        }
    }
}

function Get-UserChoice {
    param(
        [string]$Prompt,
        [string[]]$Options,
        [string]$Default = $null
    )

    if ($NonInteractive -and $Default) {
        Write-ColorOutput "Non-interactive mode: Using default '$Default'" $ColorInfo
        return $Default
    }

    Write-ColorOutput $Prompt $ColorPrompt
    for ($i = 0; $i -lt $Options.Count; $i++) {
        if ($Default -and $Options[$i] -eq $Default) {
            $marker = " (default)"
        } else {
            $marker = ""
        }
        Write-Host "  $($i + 1). $($Options[$i])$marker"
    }

    do {
        $input = Read-Host "Please select (1-$($Options.Count))"
        if ([string]::IsNullOrWhiteSpace($input) -and $Default) {
            return $Default
        }

        $index = $null
        if ([int]::TryParse($input, [ref]$index) -and $index -ge 1 -and $index -le $Options.Count) {
            return $Options[$index - 1]
        }

        Write-ColorOutput "Invalid selection. Please enter a number between 1 and $($Options.Count)" $ColorWarning
    } while ($true)
}

function Confirm-Action {
    param(
        [string]$Message,
        [switch]$DefaultYes
    )
    
    if ($Force) {
        Write-ColorOutput "Force mode: Proceeding with '$Message'" $ColorInfo
        return $true
    }
    
    if ($NonInteractive) {
        if ($DefaultYes) {
            $result = $true
        } else {
            $result = $false
        }
        if ($result) {
            $resultText = 'Yes'
        } else {
            $resultText = 'No'
        }
        Write-ColorOutput "Non-interactive mode: $Message - $resultText" $ColorInfo
        return $result
    }
    
    if ($DefaultYes) {
        $defaultChar = "Y"
        $prompt = "(Y/n)"
    } else {
        $defaultChar = "N"
        $prompt = "(y/N)"
    }
    
    do {
        $response = Read-Host "$Message $prompt"
        if ([string]::IsNullOrWhiteSpace($response)) {
            return $DefaultYes
        }
        
        switch ($response.ToLower()) {
            { $_ -in @('y', 'yes') } { return $true }
            { $_ -in @('n', 'no') } { return $false }
            default {
                Write-ColorOutput "Please answer 'y' or 'n'" $ColorWarning
            }
        }
    } while ($true)
}

function Get-BackupDirectory {
    param(
        [string]$TargetDirectory
    )
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backupDirName = "claude-backup-$timestamp"
    $backupPath = Join-Path $TargetDirectory $backupDirName
    
    # Ensure backup directory exists
    if (-not (Test-Path $backupPath)) {
        New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
    }
    
    return $backupPath
}

function Backup-FileToFolder {
    param(
        [string]$FilePath,
        [string]$BackupFolder
    )
    
    if (-not (Test-Path $FilePath)) {
        return $false
    }
    
    try {
        $fileName = Split-Path $FilePath -Leaf
        $relativePath = ""
        
        # Try to determine relative path structure for better organization
        $fileDir = Split-Path $FilePath -Parent
        if ($fileDir -match '\.claude') {
            # Extract path relative to .claude directory
            $claudeIndex = $fileDir.LastIndexOf('.claude')
            if ($claudeIndex -ge 0) {
                $relativePath = $fileDir.Substring($claudeIndex + 7) # +7 for ".claude\"
                if ($relativePath.StartsWith('\')) {
                    $relativePath = $relativePath.Substring(1)
                }
            }
        }
        
        # Create subdirectory structure in backup if needed
        $backupSubDir = $BackupFolder
        if (-not [string]::IsNullOrEmpty($relativePath)) {
            $backupSubDir = Join-Path $BackupFolder $relativePath
            if (-not (Test-Path $backupSubDir)) {
                New-Item -ItemType Directory -Path $backupSubDir -Force | Out-Null
            }
        }
        
        $backupFilePath = Join-Path $backupSubDir $fileName
        Copy-Item -Path $FilePath -Destination $backupFilePath -Force
        
        Write-ColorOutput "Backed up: $fileName" $ColorInfo
        return $true
    } catch {
        Write-ColorOutput "WARNING: Failed to backup file $FilePath`: $($_.Exception.Message)" $ColorWarning
        return $false
    }
}

function Backup-DirectoryToFolder {
    param(
        [string]$DirectoryPath,
        [string]$BackupFolder
    )
    
    if (-not (Test-Path $DirectoryPath)) {
        return $false
    }
    
    try {
        $dirName = Split-Path $DirectoryPath -Leaf
        $backupDirPath = Join-Path $BackupFolder $dirName
        
        Copy-Item -Path $DirectoryPath -Destination $backupDirPath -Recurse -Force
        Write-ColorOutput "Backed up directory: $dirName" $ColorInfo
        return $true
    } catch {
        Write-ColorOutput "WARNING: Failed to backup directory $DirectoryPath`: $($_.Exception.Message)" $ColorWarning
        return $false
    }
}

function Copy-DirectoryRecursive {
    param(
        [string]$Source,
        [string]$Destination
    )
    
    if (-not (Test-Path $Source)) {
        throw "Source directory does not exist: $Source"
    }
    
    # Create destination directory if it doesn't exist
    if (-not (Test-Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }
    
    try {
        # Copy all items recursively
        Copy-Item -Path "$Source\*" -Destination $Destination -Recurse -Force
        Write-ColorOutput "Directory copied: $Source -> $Destination" $ColorSuccess
    } catch {
        throw "Failed to copy directory: $($_.Exception.Message)"
    }
}

function Copy-FileToDestination {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$Description = "file",
        [string]$BackupFolder = $null
    )
    
    if (Test-Path $Destination) {
        # Use BackupAll mode for automatic backup without confirmation (default behavior)
        if ($BackupAll -and -not $NoBackup) {
            if ($BackupFolder -and (Backup-FileToFolder -FilePath $Destination -BackupFolder $BackupFolder)) {
                Write-ColorOutput "Auto-backed up: $Description" $ColorSuccess
            }
            Copy-Item -Path $Source -Destination $Destination -Force
            Write-ColorOutput "$Description updated (with backup)" $ColorSuccess
            return $true
        } elseif ($NoBackup) {
            # No backup mode - ask for confirmation
            if (Confirm-Action "$Description already exists. Replace it? (NO BACKUP)" -DefaultYes:$false) {
                Copy-Item -Path $Source -Destination $Destination -Force
                Write-ColorOutput "$Description updated (no backup)" $ColorWarning
                return $true
            } else {
                Write-ColorOutput "Skipping $Description installation" $ColorWarning
                return $false
            }
        } elseif (Confirm-Action "$Description already exists. Replace it?" -DefaultYes:$false) {
            if ($BackupFolder -and (Backup-FileToFolder -FilePath $Destination -BackupFolder $BackupFolder)) {
                Write-ColorOutput "Existing $Description backed up" $ColorSuccess
            }
            Copy-Item -Path $Source -Destination $Destination -Force
            Write-ColorOutput "$Description updated" $ColorSuccess
            return $true
        } else {
            Write-ColorOutput "Skipping $Description installation" $ColorWarning
            return $false
        }
    } else {
        # Ensure destination directory exists
        $destinationDir = Split-Path $Destination -Parent
        if (-not (Test-Path $destinationDir)) {
            New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
        }
        Copy-Item -Path $Source -Destination $Destination -Force
        Write-ColorOutput "$Description installed" $ColorSuccess
        return $true
    }
}

function Backup-AndReplaceDirectory {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$Description = "directory",
        [string]$BackupFolder = $null
    )

    if (-not (Test-Path $Source)) {
        Write-ColorOutput "WARNING: Source $Description not found: $Source" $ColorWarning
        return $false
    }

    # Backup destination if it exists
    if (Test-Path $Destination) {
        Write-ColorOutput "Found existing $Description at: $Destination" $ColorInfo

        # Backup entire directory if backup is enabled
        if (-not $NoBackup -and $BackupFolder) {
            Write-ColorOutput "Backing up entire $Description..." $ColorInfo
            if (Backup-DirectoryToFolder -DirectoryPath $Destination -BackupFolder $BackupFolder) {
                Write-ColorOutput "Backed up $Description to: $BackupFolder" $ColorSuccess
            }
        } elseif ($NoBackup) {
            if (-not (Confirm-Action "Replace existing $Description without backup?" -DefaultYes:$false)) {
                Write-ColorOutput "Skipping $Description installation" $ColorWarning
                return $false
            }
        }

        # Get all items from source to determine what to clear in destination
        Write-ColorOutput "Clearing conflicting items in destination $Description..." $ColorInfo
        $sourceItems = Get-ChildItem -Path $Source -Force

        foreach ($sourceItem in $sourceItems) {
            $destItemPath = Join-Path $Destination $sourceItem.Name
            if (Test-Path $destItemPath) {
                Write-ColorOutput "Removing existing: $($sourceItem.Name)" $ColorInfo
                Remove-Item -Path $destItemPath -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
        Write-ColorOutput "Cleared conflicting items in destination" $ColorSuccess
    } else {
        # Create destination directory if it doesn't exist
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
        Write-ColorOutput "Created destination directory: $Destination" $ColorInfo
    }

    # Copy all items from source to destination
    Write-ColorOutput "Copying $Description from $Source to $Destination..." $ColorInfo
    $sourceItems = Get-ChildItem -Path $Source -Force
    foreach ($item in $sourceItems) {
        $destPath = Join-Path $Destination $item.Name
        Copy-Item -Path $item.FullName -Destination $destPath -Recurse -Force
    }
    Write-ColorOutput "$Description installed successfully" $ColorSuccess

    return $true
}

function Merge-DirectoryContents {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$Description = "directory contents",
        [string]$BackupFolder = $null
    )

    if (-not (Test-Path $Source)) {
        Write-ColorOutput "WARNING: Source $Description not found: $Source" $ColorWarning
        return $false
    }

    # Create destination directory if it doesn't exist
    if (-not (Test-Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
        Write-ColorOutput "Created destination directory: $Destination" $ColorInfo
    }

    # Get all items in source directory
    $sourceItems = Get-ChildItem -Path $Source -Recurse -File
    $mergedCount = 0
    $skippedCount = 0

    foreach ($item in $sourceItems) {
        # Calculate relative path from source
        $relativePath = $item.FullName.Substring($Source.Length + 1)
        $destinationPath = Join-Path $Destination $relativePath

        # Ensure destination directory exists
        $destinationDir = Split-Path $destinationPath -Parent
        if (-not (Test-Path $destinationDir)) {
            New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
        }

        # Handle file merging
        if (Test-Path $destinationPath) {
            $fileName = Split-Path $relativePath -Leaf
            # Use BackupAll mode for automatic backup without confirmation (default behavior)
            if ($BackupAll -and -not $NoBackup) {
                if ($BackupFolder -and (Backup-FileToFolder -FilePath $destinationPath -BackupFolder $BackupFolder)) {
                    Write-ColorOutput "Auto-backed up: $fileName" $ColorInfo
                }
                Copy-Item -Path $item.FullName -Destination $destinationPath -Force
                $mergedCount++
            } elseif ($NoBackup) {
                # No backup mode - ask for confirmation
                if (Confirm-Action "File '$relativePath' already exists. Replace it? (NO BACKUP)" -DefaultYes:$false) {
                    Copy-Item -Path $item.FullName -Destination $destinationPath -Force
                    $mergedCount++
                } else {
                    Write-ColorOutput "Skipped $fileName (no backup)" $ColorWarning
                    $skippedCount++
                }
            } elseif (Confirm-Action "File '$relativePath' already exists. Replace it?" -DefaultYes:$false) {
                if ($BackupFolder -and (Backup-FileToFolder -FilePath $destinationPath -BackupFolder $BackupFolder)) {
                    Write-ColorOutput "Backed up existing $fileName" $ColorInfo
                }
                Copy-Item -Path $item.FullName -Destination $destinationPath -Force
                $mergedCount++
            } else {
                Write-ColorOutput "Skipped $fileName" $ColorWarning
                $skippedCount++
            }
        } else {
            Copy-Item -Path $item.FullName -Destination $destinationPath -Force
            $mergedCount++
        }
    }

    Write-ColorOutput "Merged $mergedCount files, skipped $skippedCount files" $ColorSuccess
    return $true
}

function Create-VersionJson {
    param(
        [string]$TargetClaudeDir,
        [string]$InstallationMode
    )

    # Determine version from source parameter (passed from install-remote.ps1)
    $versionNumber = if ($SourceVersion) { $SourceVersion } else { $DefaultVersion }
    $sourceBranch = if ($SourceBranch) { $SourceBranch } else { "unknown" }
    $commitSha = if ($SourceCommit) { $SourceCommit } else { "unknown" }

    # Create version.json content
    $versionInfo = @{
        version = $versionNumber
        commit_sha = $commitSha
        installation_mode = $InstallationMode
        installation_path = $TargetClaudeDir
        installation_date_utc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        source_branch = $sourceBranch
        installer_version = $ScriptVersion
    }

    $versionJsonPath = Join-Path $TargetClaudeDir "version.json"

    try {
        $versionInfo | ConvertTo-Json | Out-File -FilePath $versionJsonPath -Encoding utf8 -Force
        Write-ColorOutput "Created version.json: $versionNumber ($commitSha) - $InstallationMode" $ColorSuccess
        return $true
    } catch {
        Write-ColorOutput "WARNING: Failed to create version.json: $($_.Exception.Message)" $ColorWarning
        return $false
    }
}

function Install-Global {
    Write-ColorOutput "Installing CommitCraft globally..." $ColorInfo

    # Determine user profile directory
    $userProfile = [Environment]::GetFolderPath("UserProfile")
    $globalClaudeDir = Join-Path $userProfile ".claude"
    $globalClaudeMd = Join-Path $globalClaudeDir "CLAUDE.md"

    Write-ColorOutput "Global installation path: $userProfile" $ColorInfo

    # Source paths
    $sourceDir = $PSScriptRoot
    $sourceClaudeDir = Join-Path $sourceDir ".claude"
    $sourceClaudeMd = Join-Path $sourceDir "CLAUDE.md"

    # Create backup folder if needed (default behavior unless NoBackup is specified)
    $backupFolder = $null
    if (-not $NoBackup) {
        if (Test-Path $globalClaudeDir) {
            $existingFiles = @()
            $existingFiles += Get-ChildItem $globalClaudeDir -Recurse -File -ErrorAction SilentlyContinue
            if (($existingFiles -and ($existingFiles | Measure-Object).Count -gt 0)) {
                $backupFolder = Get-BackupDirectory -TargetDirectory $userProfile
                Write-ColorOutput "Backup folder created: $backupFolder" $ColorInfo
            }
        } elseif (Test-Path $globalClaudeMd) {
            # Create backup folder even if .claude directory doesn't exist but CLAUDE.md does
            $backupFolder = Get-BackupDirectory -TargetDirectory $userProfile
            Write-ColorOutput "Backup folder created: $backupFolder" $ColorInfo
        }
    }

    # Replace .claude directory (backup → clear → copy entire folder)
    Write-ColorOutput "Installing .claude directory..." $ColorInfo
    $claudeInstalled = Backup-AndReplaceDirectory -Source $sourceClaudeDir -Destination $globalClaudeDir -Description ".claude directory" -BackupFolder $backupFolder

    # Handle CLAUDE.md file in .claude directory
    Write-ColorOutput "Installing CLAUDE.md to global .claude directory..." $ColorInfo
    $claudeMdInstalled = Copy-FileToDestination -Source $sourceClaudeMd -Destination $globalClaudeMd -Description "CLAUDE.md" -BackupFolder $backupFolder

    # Create version.json in global .claude directory
    Write-ColorOutput "Creating version.json..." $ColorInfo
    Create-VersionJson -TargetClaudeDir $globalClaudeDir -InstallationMode "Global"

    if ($backupFolder -and (Test-Path $backupFolder)) {
        $backupFiles = Get-ChildItem $backupFolder -Recurse -File -ErrorAction SilentlyContinue
        if (-not $backupFiles -or ($backupFiles | Measure-Object).Count -eq 0) {
            # Remove empty backup folder
            Remove-Item -Path $backupFolder -Force
            Write-ColorOutput "Removed empty backup folder" $ColorInfo
        }
    }

    return $true
}

function Install-Path {
    param(
        [string]$TargetDirectory
    )

    Write-ColorOutput "Installing CommitCraft in hybrid mode..." $ColorInfo
    Write-ColorOutput "Local path: $TargetDirectory" $ColorInfo

    # Determine user profile directory for global files
    $userProfile = [Environment]::GetFolderPath("UserProfile")
    $globalClaudeDir = Join-Path $userProfile ".claude"

    Write-ColorOutput "Global path: $userProfile" $ColorInfo

    # Source paths
    $sourceDir = $PSScriptRoot
    $sourceClaudeDir = Join-Path $sourceDir ".claude"
    $sourceClaudeMd = Join-Path $sourceDir "CLAUDE.md"

    # Local paths
    $localClaudeDir = Join-Path $TargetDirectory ".claude"

    # Create backup folder if needed
    $backupFolder = $null
    if (-not $NoBackup) {
        if ((Test-Path $localClaudeDir) -or (Test-Path $globalClaudeDir)) {
            $backupFolder = Get-BackupDirectory -TargetDirectory $TargetDirectory
            Write-ColorOutput "Backup folder created: $backupFolder" $ColorInfo
        }
    }

    # Create local .claude directory
    if (-not (Test-Path $localClaudeDir)) {
        New-Item -ItemType Directory -Path $localClaudeDir -Force | Out-Null
        Write-ColorOutput "Created local .claude directory" $ColorSuccess
    }

    # Local folders to install (agents, commands, output-styles)
    $localFolders = @("agents", "commands", "output-styles")

    Write-ColorOutput "Installing local components (agents, commands, output-styles)..." $ColorInfo
    foreach ($folder in $localFolders) {
        $sourceFolderPath = Join-Path $sourceClaudeDir $folder
        $destFolderPath = Join-Path $localClaudeDir $folder

        if (Test-Path $sourceFolderPath) {
            # Use new backup and replace logic for local folders
            Write-ColorOutput "Installing local folder: $folder..." $ColorInfo
            Backup-AndReplaceDirectory -Source $sourceFolderPath -Destination $destFolderPath -Description "$folder folder" -BackupFolder $backupFolder
            Write-ColorOutput "Installed local folder: $folder" $ColorSuccess
        } else {
            Write-ColorOutput "WARNING: Source folder not found: $folder" $ColorWarning
        }
    }

    # Global components - exclude local folders
    Write-ColorOutput "Installing global components to $globalClaudeDir..." $ColorInfo

    # Get all items from source, excluding local folders
    $sourceItems = Get-ChildItem -Path $sourceClaudeDir -Recurse -File | Where-Object {
        $relativePath = $_.FullName.Substring($sourceClaudeDir.Length + 1)
        $topFolder = $relativePath.Split([System.IO.Path]::DirectorySeparatorChar)[0]
        $topFolder -notin $localFolders
    }

    $mergedCount = 0
    foreach ($item in $sourceItems) {
        $relativePath = $item.FullName.Substring($sourceClaudeDir.Length + 1)
        $destinationPath = Join-Path $globalClaudeDir $relativePath

        # Ensure destination directory exists
        $destinationDir = Split-Path $destinationPath -Parent
        if (-not (Test-Path $destinationDir)) {
            New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
        }

        # Handle file merging
        if (Test-Path $destinationPath) {
            if ($BackupAll -and -not $NoBackup) {
                if ($backupFolder) {
                    Backup-FileToFolder -FilePath $destinationPath -BackupFolder $backupFolder
                }
                Copy-Item -Path $item.FullName -Destination $destinationPath -Force
                $mergedCount++
            } elseif ($NoBackup) {
                if (Confirm-Action "File '$relativePath' already exists in global location. Replace it? (NO BACKUP)" -DefaultYes:$false) {
                    Copy-Item -Path $item.FullName -Destination $destinationPath -Force
                    $mergedCount++
                }
            } elseif (Confirm-Action "File '$relativePath' already exists in global location. Replace it?" -DefaultYes:$false) {
                if ($backupFolder) {
                    Backup-FileToFolder -FilePath $destinationPath -BackupFolder $backupFolder
                }
                Copy-Item -Path $item.FullName -Destination $destinationPath -Force
                $mergedCount++
            }
        } else {
            Copy-Item -Path $item.FullName -Destination $destinationPath -Force
            $mergedCount++
        }
    }

    Write-ColorOutput "Merged $mergedCount files to global location" $ColorSuccess

    # Handle CLAUDE.md file in global .claude directory
    $globalClaudeMd = Join-Path $globalClaudeDir "CLAUDE.md"
    Write-ColorOutput "Installing CLAUDE.md to global .claude directory..." $ColorInfo
    Copy-FileToDestination -Source $sourceClaudeMd -Destination $globalClaudeMd -Description "CLAUDE.md" -BackupFolder $backupFolder

    # Create version.json in local .claude directory
    Write-ColorOutput "Creating version.json in local directory..." $ColorInfo
    Create-VersionJson -TargetClaudeDir $localClaudeDir -InstallationMode "Path"

    # Also create version.json in global .claude directory
    Write-ColorOutput "Creating version.json in global directory..." $ColorInfo
    Create-VersionJson -TargetClaudeDir $globalClaudeDir -InstallationMode "Global"

    if ($backupFolder -and (Test-Path $backupFolder)) {
        $backupFiles = Get-ChildItem $backupFolder -Recurse -File -ErrorAction SilentlyContinue
        if (-not $backupFiles -or ($backupFiles | Measure-Object).Count -eq 0) {
            Remove-Item -Path $backupFolder -Force
            Write-ColorOutput "Removed empty backup folder" $ColorInfo
        }
    }

    return $true
}


function Get-InstallationMode {
    if ($InstallMode) {
        Write-ColorOutput "Installation mode: $InstallMode" $ColorInfo
        return $InstallMode
    }

    $modes = @(
        "Global - Install CommitCraft to user profile (~/.claude/)",
        "Path - Install CommitCraft to custom directory (agents/commands local + global config)"
    )

    Write-Host ""
    $selection = Get-UserChoiceWithArrows -Prompt "Choose installation mode:" -Options $modes -DefaultIndex 0

    if ($selection -like "Global*") {
        return "Global"
    } elseif ($selection -like "Path*") {
        return "Path"
    }

    return "Global"
}

function Get-InstallationPath {
    param(
        [string]$Mode
    )

    if ($Mode -eq "Global") {
        return [Environment]::GetFolderPath("UserProfile")
    }

    if ($TargetPath) {
        if (Test-Path $TargetPath) {
            return $TargetPath
        }
        Write-ColorOutput "WARNING: Specified target path does not exist: $TargetPath" $ColorWarning
    }

    # Interactive path selection
    do {
        Write-Host ""
        Write-ColorOutput "Enter the target directory path for installation:" $ColorPrompt
        Write-ColorOutput "(This will install agents, commands, output-styles locally, other files globally)" $ColorInfo
        $path = Read-Host "Path"

        if ([string]::IsNullOrWhiteSpace($path)) {
            Write-ColorOutput "Path cannot be empty" $ColorWarning
            continue
        }

        # Expand environment variables and relative paths
        $expandedPath = [System.Environment]::ExpandEnvironmentVariables($path)
        $expandedPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($expandedPath)

        if (Test-Path $expandedPath) {
            return $expandedPath
        }

        Write-ColorOutput "Path does not exist: $expandedPath" $ColorWarning
        if (Confirm-Action "Create this directory?" -DefaultYes) {
            try {
                New-Item -ItemType Directory -Path $expandedPath -Force | Out-Null
                Write-ColorOutput "Directory created successfully" $ColorSuccess
                return $expandedPath
            } catch {
                Write-ColorOutput "Failed to create directory: $($_.Exception.Message)" $ColorError
            }
        }
    } while ($true)
}


function Show-Summary {
    param(
        [string]$Mode,
        [string]$Path,
        [bool]$Success
    )

    Write-Host ""
    if ($Success) {
        Write-ColorOutput "Installation completed successfully!" $ColorSuccess
    } else {
        Write-ColorOutput "Installation completed with warnings" $ColorWarning
    }

    Write-ColorOutput "Installation Details:" $ColorInfo
    Write-Host "  Mode: $Mode"

    if ($Mode -eq "Path") {
        Write-Host "  Local Path: $Path"
        Write-Host "  Global Path: $([Environment]::GetFolderPath('UserProfile'))"
        Write-Host "  Local Components: agents, commands, output-styles, .codex, .gemini, .qwen"
        Write-Host "  Global Components: workflows, scripts, python_script, etc."
    } else {
        Write-Host "  Path: $Path"
        Write-Host "  Global Components: .claude, .codex, .gemini, .qwen"
    }

    if ($NoBackup) {
        Write-Host "  Backup: Disabled (no backup created)"
    } elseif ($BackupAll) {
        Write-Host "  Backup: Enabled (automatic backup of all existing files)"
    } else {
        Write-Host "  Backup: Enabled (default behavior)"
    }

    Write-Host ""
    Write-ColorOutput "Next steps:" $ColorInfo
    Write-Host "1. Review CLAUDE.md - CommitCraft development guidelines"
    Write-Host "2. Navigate to your project directory"
    Write-Host "3. Run the commit workflow command:"
    Write-Host "   /commit-pilot <COMMIT_DESCRIPTION>"
    Write-Host "4. Follow the interactive prompts to:"
    Write-Host "   - Review file grouping"
    Write-Host "   - Select branch strategy"
    Write-Host "   - Choose merge strategy"
    Write-Host "5. Let the 5-agent pipeline handle your commits professionally!"

    Write-Host ""
    Write-ColorOutput "Documentation: Check .claude/commands/commit-pilot.md for detailed usage" $ColorInfo
    Write-ColorOutput "Features: 5-agent pipeline (analyzer → grouper → message → validator → executor)" $ColorInfo
}

function Main {
    # Use SourceVersion parameter if provided, otherwise use default
    $installVersion = if ($SourceVersion) { $SourceVersion } else { $DefaultVersion }

    Show-Header -InstallVersion $installVersion

    # Test prerequisites
    Write-ColorOutput "Checking system requirements..." $ColorInfo
    if (-not (Test-Prerequisites)) {
        Write-ColorOutput "Prerequisites check failed!" $ColorError
        return 1
    }

    try {
        # Get installation mode
        $mode = Get-InstallationMode
        $installPath = ""
        $success = $false

        if ($mode -eq "Global") {
            $installPath = [Environment]::GetFolderPath("UserProfile")
            $result = Install-Global
            $success = $result -eq $true
        }
        elseif ($mode -eq "Path") {
            $installPath = Get-InstallationPath -Mode $mode
            $result = Install-Path -TargetDirectory $installPath
            $success = $result -eq $true
        }

        Show-Summary -Mode $mode -Path $installPath -Success ([bool]$success)

        # Wait for user confirmation before exit in interactive mode
        if (-not $NonInteractive) {
            Write-Host ""
            Write-ColorOutput "Installation completed. Press any key to exit..." $ColorPrompt
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }

        if ($success) {
            return 0
        } else {
            return 1
        }

    } catch {
        Write-ColorOutput "CRITICAL ERROR: $($_.Exception.Message)" $ColorError
        Write-ColorOutput "Stack trace: $($_.ScriptStackTrace)" $ColorError

        # Wait for user confirmation before exit in interactive mode
        if (-not $NonInteractive) {
            Write-Host ""
            Write-ColorOutput "An error occurred. Press any key to exit..." $ColorPrompt
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }

        return 1
    }
}

# Run main function
exit (Main)