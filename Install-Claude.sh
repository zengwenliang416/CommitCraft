#!/usr/bin/env bash
# CommitCraft Interactive Installer
# Installation script for CommitCraft with intelligent git commit workflow with 5-agent pipeline.
# Installs globally to user profile directory (~/.claude) by default.

set -e  # Exit on error

# Script metadata
SCRIPT_NAME="CommitCraft Installer"
VERSION="2.1.0"

# Colors for output
COLOR_RESET='\033[0m'
COLOR_SUCCESS='\033[0;32m'
COLOR_INFO='\033[0;36m'
COLOR_WARNING='\033[0;33m'
COLOR_ERROR='\033[0;31m'
COLOR_PROMPT='\033[0;35m'

# Default parameters
INSTALL_MODE=""
TARGET_PATH=""
FORCE=false
NON_INTERACTIVE=false
BACKUP_ALL=true  # Enabled by default
NO_BACKUP=false
SOURCE_VERSION=""  # Version from remote installer
SOURCE_BRANCH=""   # Branch from remote installer
SOURCE_COMMIT=""   # Commit SHA from remote installer

# Functions
function write_color() {
    local message="$1"
    local color="${2:-$COLOR_RESET}"
    echo -e "${color}${message}${COLOR_RESET}"
}

function show_banner() {
    echo ""
    write_color '╔═══════════════════════════════════════════════════════════════════════════════╗' "$COLOR_INFO"
    write_color '║                                                                               ║' "$COLOR_INFO"
    write_color '║   ██████╗ ██████╗ ███╗   ███╗███╗   ███╗██╗████████╗ ██████╗██████╗  █████╗ ║' "$COLOR_INFO"
    write_color '║  ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██║╚══██╔══╝██╔════╝██╔══██╗██╔══██╗║' "$COLOR_INFO"
    write_color '║  ██║     ██║   ██║██╔████╔██║██╔████╔██║██║   ██║   ██║     ██████╔╝███████║║' "$COLOR_INFO"
    write_color '║  ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██║   ██║   ██║     ██╔══██╗██╔══██║║' "$COLOR_INFO"
    write_color '║  ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║██║   ██║   ╚██████╗██║  ██║██║  ██║║' "$COLOR_INFO"
    write_color '║   ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝║' "$COLOR_INFO"
    write_color '║                                                                               ║' "$COLOR_INFO"
    write_color '║              ██████╗██████╗  █████╗ ███████╗████████╗                        ║' "$COLOR_SUCCESS"
    write_color '║             ██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝                        ║' "$COLOR_SUCCESS"
    write_color '║             ██║     ██████╔╝███████║█████╗     ██║                           ║' "$COLOR_SUCCESS"
    write_color '║             ██║     ██╔══██╗██╔══██║██╔══╝     ██║                           ║' "$COLOR_SUCCESS"
    write_color '║             ╚██████╗██║  ██║██║  ██║██║        ██║                           ║' "$COLOR_SUCCESS"
    write_color '║              ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝                           ║' "$COLOR_SUCCESS"
    write_color '║                                                                               ║' "$COLOR_INFO"
    write_color '║           Intelligent Git Commit Workflow with 5-Agent Pipeline              ║' "$COLOR_WARNING"
    write_color '║        Analyzer → Grouper → Message → Validator → Executor                   ║' "$COLOR_WARNING"
    write_color '║                                                                               ║' "$COLOR_INFO"
    write_color '╚═══════════════════════════════════════════════════════════════════════════════╝' "$COLOR_INFO"
    echo ""
}

function show_header() {
    show_banner
    write_color "    $SCRIPT_NAME v$VERSION" "$COLOR_INFO"
    write_color "    Intelligent Git Commit Workflow with 5-Agent Pipeline" "$COLOR_INFO"
    write_color "========================================================================" "$COLOR_INFO"

    if [ "$NO_BACKUP" = true ]; then
        write_color "WARNING: Backup disabled - existing files will be overwritten!" "$COLOR_WARNING"
    else
        write_color "Auto-backup enabled - existing files will be backed up" "$COLOR_SUCCESS"
    fi
    echo ""
}

function test_prerequisites() {
    # Test bash version
    if [ "${BASH_VERSINFO[0]}" -lt 2 ]; then
        write_color "ERROR: Bash 2.0 or higher is required" "$COLOR_ERROR"
        write_color "Current version: ${BASH_VERSION}" "$COLOR_ERROR"
        return 1
    fi

    # Test source files exist
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local claude_dir="$script_dir/.claude"
    local claude_md="$script_dir/CLAUDE.md"

    if [ ! -d "$claude_dir" ]; then
        write_color "ERROR: .claude directory not found in $script_dir" "$COLOR_ERROR"
        return 1
    fi

    if [ ! -f "$claude_md" ]; then
        write_color "ERROR: CLAUDE.md file not found in $script_dir" "$COLOR_ERROR"
        return 1
    fi

    # CommitCraft only requires .claude directory and CLAUDE.md
    # No need for .codex, .gemini, or .qwen directories

    write_color "✓ Prerequisites check passed" "$COLOR_SUCCESS"
    return 0
}

function get_user_choice() {
    local prompt="$1"
    shift
    local options=("$@")
    local default_index=0

    if [ "$NON_INTERACTIVE" = true ]; then
        write_color "Non-interactive mode: Using default '${options[$default_index]}'" "$COLOR_INFO" >&2
        echo "${options[$default_index]}"
        return
    fi

    # Output prompts to stderr so they don't interfere with function return value
    echo "" >&2
    write_color "$prompt" "$COLOR_PROMPT" >&2
    echo "" >&2

    for i in "${!options[@]}"; do
        echo "  $((i + 1)). ${options[$i]}" >&2
    done

    echo "" >&2

    while true; do
        read -p "Please select (1-${#options[@]}): " choice

        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
            echo "${options[$((choice - 1))]}"
            return
        fi

        write_color "Invalid selection. Please enter a number between 1 and ${#options[@]}" "$COLOR_WARNING" >&2
    done
}

function confirm_action() {
    local message="$1"
    local default_yes="${2:-false}"

    if [ "$FORCE" = true ]; then
        write_color "Force mode: Proceeding with '$message'" "$COLOR_INFO"
        return 0
    fi

    if [ "$NON_INTERACTIVE" = true ]; then
        if [ "$default_yes" = true ]; then
            write_color "Non-interactive mode: $message - Yes" "$COLOR_INFO"
            return 0
        else
            write_color "Non-interactive mode: $message - No" "$COLOR_INFO"
            return 1
        fi
    fi

    local prompt
    if [ "$default_yes" = true ]; then
        prompt="(Y/n)"
    else
        prompt="(y/N)"
    fi

    while true; do
        read -p "$message $prompt " response

        if [ -z "$response" ]; then
            [ "$default_yes" = true ] && return 0 || return 1
        fi

        case "${response,,}" in
            y|yes) return 0 ;;
            n|no) return 1 ;;
            *) write_color "Please answer 'y' or 'n'" "$COLOR_WARNING" ;;
        esac
    done
}

function get_backup_directory() {
    local target_dir="$1"
    local timestamp=$(date +"%Y%m%d-%H%M%S")
    local backup_dir="${target_dir}/claude-backup-${timestamp}"

    mkdir -p "$backup_dir"
    echo "$backup_dir"
}

function backup_file_to_folder() {
    local file_path="$1"
    local backup_folder="$2"

    if [ ! -f "$file_path" ]; then
        return 1
    fi

    local file_name=$(basename "$file_path")
    local file_dir=$(dirname "$file_path")
    local relative_path=""

    # Try to determine relative path structure
    if [[ "$file_dir" == *".claude"* ]]; then
        relative_path="${file_dir#*.claude/}"
    fi

    # Create subdirectory structure in backup if needed
    local backup_sub_dir="$backup_folder"
    if [ -n "$relative_path" ]; then
        backup_sub_dir="${backup_folder}/${relative_path}"
        mkdir -p "$backup_sub_dir"
    fi

    local backup_file_path="${backup_sub_dir}/${file_name}"

    if cp "$file_path" "$backup_file_path"; then
        write_color "Backed up: $file_name" "$COLOR_INFO"
        return 0
    else
        write_color "WARNING: Failed to backup file $file_path" "$COLOR_WARNING"
        return 1
    fi
}

function backup_directory_to_folder() {
    local dir_path="$1"
    local backup_folder="$2"

    if [ ! -d "$dir_path" ]; then
        return 1
    fi

    local dir_name=$(basename "$dir_path")
    local backup_dir_path="${backup_folder}/${dir_name}"

    if cp -r "$dir_path" "$backup_dir_path"; then
        write_color "Backed up directory: $dir_name" "$COLOR_INFO"
        return 0
    else
        write_color "WARNING: Failed to backup directory $dir_path" "$COLOR_WARNING"
        return 1
    fi
}

function copy_directory_recursive() {
    local source="$1"
    local destination="$2"

    if [ ! -d "$source" ]; then
        write_color "ERROR: Source directory does not exist: $source" "$COLOR_ERROR"
        return 1
    fi

    mkdir -p "$destination"

    if cp -r "$source/"* "$destination/"; then
        write_color "✓ Directory copied: $source -> $destination" "$COLOR_SUCCESS"
        return 0
    else
        write_color "ERROR: Failed to copy directory" "$COLOR_ERROR"
        return 1
    fi
}

function copy_file_to_destination() {
    local source="$1"
    local destination="$2"
    local description="${3:-file}"
    local backup_folder="${4:-}"

    if [ -f "$destination" ]; then
        # Use BackupAll mode for automatic backup
        if [ "$BACKUP_ALL" = true ] && [ "$NO_BACKUP" = false ]; then
            if [ -n "$backup_folder" ]; then
                backup_file_to_folder "$destination" "$backup_folder"
                write_color "Auto-backed up: $description" "$COLOR_SUCCESS"
            fi
            cp "$source" "$destination"
            write_color "$description updated (with backup)" "$COLOR_SUCCESS"
            return 0
        elif [ "$NO_BACKUP" = true ]; then
            if confirm_action "$description already exists. Replace it? (NO BACKUP)" false; then
                cp "$source" "$destination"
                write_color "$description updated (no backup)" "$COLOR_WARNING"
                return 0
            else
                write_color "Skipping $description installation" "$COLOR_WARNING"
                return 1
            fi
        elif confirm_action "$description already exists. Replace it?" false; then
            if [ -n "$backup_folder" ]; then
                backup_file_to_folder "$destination" "$backup_folder"
                write_color "Existing $description backed up" "$COLOR_SUCCESS"
            fi
            cp "$source" "$destination"
            write_color "$description updated" "$COLOR_SUCCESS"
            return 0
        else
            write_color "Skipping $description installation" "$COLOR_WARNING"
            return 1
        fi
    else
        # Ensure destination directory exists
        local dest_dir=$(dirname "$destination")
        mkdir -p "$dest_dir"
        cp "$source" "$destination"
        write_color "✓ $description installed" "$COLOR_SUCCESS"
        return 0
    fi
}

function backup_and_replace_directory() {
    local source="$1"
    local destination="$2"
    local description="${3:-directory}"
    local backup_folder="${4:-}"

    if [ ! -d "$source" ]; then
        write_color "WARNING: Source $description not found: $source" "$COLOR_WARNING"
        return 1
    fi

    # Backup destination if it exists
    if [ -d "$destination" ]; then
        write_color "Found existing $description at: $destination" "$COLOR_INFO"

        # Backup entire directory if backup is enabled
        if [ "$NO_BACKUP" = false ] && [ -n "$backup_folder" ]; then
            write_color "Backing up entire $description..." "$COLOR_INFO"
            if backup_directory_to_folder "$destination" "$backup_folder"; then
                write_color "Backed up $description to: $backup_folder" "$COLOR_SUCCESS"
            fi
        elif [ "$NO_BACKUP" = true ]; then
            if ! confirm_action "Replace existing $description without backup?" false; then
                write_color "Skipping $description installation" "$COLOR_WARNING"
                return 1
            fi
        fi

        # Get all items from source to determine what to clear in destination
        write_color "Clearing conflicting items in destination $description..." "$COLOR_INFO"
        while IFS= read -r -d '' source_item; do
            local item_name=$(basename "$source_item")
            local dest_item_path="${destination}/${item_name}"

            if [ -e "$dest_item_path" ]; then
                write_color "Removing existing: $item_name" "$COLOR_INFO"
                rm -rf "$dest_item_path"
            fi
        done < <(find "$source" -mindepth 1 -maxdepth 1 -print0)
        write_color "Cleared conflicting items in destination" "$COLOR_SUCCESS"
    else
        # Create destination directory if it doesn't exist
        mkdir -p "$destination"
        write_color "Created destination directory: $destination" "$COLOR_INFO"
    fi

    # Copy all items from source to destination
    write_color "Copying $description from $source to $destination..." "$COLOR_INFO"
    while IFS= read -r -d '' item; do
        local item_name=$(basename "$item")
        local dest_path="${destination}/${item_name}"
        cp -r "$item" "$dest_path"
    done < <(find "$source" -mindepth 1 -maxdepth 1 -print0)
    write_color "$description installed successfully" "$COLOR_SUCCESS"

    return 0
}

function merge_directory_contents() {
    local source="$1"
    local destination="$2"
    local description="${3:-directory contents}"
    local backup_folder="${4:-}"

    if [ ! -d "$source" ]; then
        write_color "WARNING: Source $description not found: $source" "$COLOR_WARNING"
        return 1
    fi

    mkdir -p "$destination"
    write_color "Created destination directory: $destination" "$COLOR_INFO"

    local merged_count=0
    local skipped_count=0

    # Find all files recursively
    while IFS= read -r -d '' file; do
        local relative_path="${file#$source/}"
        local dest_path="${destination}/${relative_path}"
        local dest_dir=$(dirname "$dest_path")

        mkdir -p "$dest_dir"

        if [ -f "$dest_path" ]; then
            local file_name=$(basename "$relative_path")

            if [ "$BACKUP_ALL" = true ] && [ "$NO_BACKUP" = false ]; then
                if [ -n "$backup_folder" ]; then
                    backup_file_to_folder "$dest_path" "$backup_folder"
                    write_color "Auto-backed up: $file_name" "$COLOR_INFO"
                fi
                cp "$file" "$dest_path"
                ((merged_count++))
            elif [ "$NO_BACKUP" = true ]; then
                if confirm_action "File '$relative_path' already exists. Replace it? (NO BACKUP)" false; then
                    cp "$file" "$dest_path"
                    ((merged_count++))
                else
                    write_color "Skipped $file_name (no backup)" "$COLOR_WARNING"
                    ((skipped_count++))
                fi
            elif confirm_action "File '$relative_path' already exists. Replace it?" false; then
                if [ -n "$backup_folder" ]; then
                    backup_file_to_folder "$dest_path" "$backup_folder"
                    write_color "Backed up existing $file_name" "$COLOR_INFO"
                fi
                cp "$file" "$dest_path"
                ((merged_count++))
            else
                write_color "Skipped $file_name" "$COLOR_WARNING"
                ((skipped_count++))
            fi
        else
            cp "$file" "$dest_path"
            ((merged_count++))
        fi
    done < <(find "$source" -type f -print0)

    write_color "✓ Merged $merged_count files, skipped $skipped_count files" "$COLOR_SUCCESS"
    return 0
}

function install_global() {
    write_color "Installing CommitCraft globally..." "$COLOR_INFO"

    local user_home="$HOME"
    local global_claude_dir="${user_home}/.claude"
    local global_claude_md="${global_claude_dir}/CLAUDE.md"

    write_color "Global installation path: $user_home" "$COLOR_INFO"

    # Source paths
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local source_claude_dir="${script_dir}/.claude"
    local source_claude_md="${script_dir}/CLAUDE.md"

    # Create backup folder if needed
    local backup_folder=""
    if [ "$NO_BACKUP" = false ]; then
        local has_existing_files=false

        if [ -d "$global_claude_dir" ] && [ "$(ls -A "$global_claude_dir" 2>/dev/null)" ]; then
            has_existing_files=true
        elif [ -f "$global_claude_md" ]; then
            has_existing_files=true
        fi

        if [ "$has_existing_files" = true ]; then
            backup_folder=$(get_backup_directory "$user_home")
            write_color "Backup folder created: $backup_folder" "$COLOR_INFO"
        fi
    fi

    # Replace .claude directory (backup → clear conflicting → copy)
    write_color "Installing .claude directory..." "$COLOR_INFO"
    backup_and_replace_directory "$source_claude_dir" "$global_claude_dir" ".claude directory" "$backup_folder"

    # Handle CLAUDE.md file
    write_color "Installing CLAUDE.md to global .claude directory..." "$COLOR_INFO"
    copy_file_to_destination "$source_claude_md" "$global_claude_md" "CLAUDE.md" "$backup_folder"

    # Remove empty backup folder
    if [ -n "$backup_folder" ] && [ -d "$backup_folder" ]; then
        if [ -z "$(ls -A "$backup_folder" 2>/dev/null)" ]; then
            rm -rf "$backup_folder"
            write_color "Removed empty backup folder" "$COLOR_INFO"
        fi
    fi

    # Create version.json in global .claude directory
    write_color "Creating version.json..." "$COLOR_INFO"
    create_version_json "$global_claude_dir" "Global"

    return 0
}

function install_path() {
    local target_dir="$1"

    write_color "Installing CommitCraft in hybrid mode..." "$COLOR_INFO"
    write_color "Local path: $target_dir" "$COLOR_INFO"

    local user_home="$HOME"
    local global_claude_dir="${user_home}/.claude"
    write_color "Global path: $user_home" "$COLOR_INFO"

    # Source paths
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local source_claude_dir="${script_dir}/.claude"
    local source_claude_md="${script_dir}/CLAUDE.md"

    # Local paths
    local local_claude_dir="${target_dir}/.claude"

    # Create backup folder if needed
    local backup_folder=""
    if [ "$NO_BACKUP" = false ]; then
        if [ -d "$local_claude_dir" ] || [ -d "$global_claude_dir" ]; then
            backup_folder=$(get_backup_directory "$target_dir")
            write_color "Backup folder created: $backup_folder" "$COLOR_INFO"
        fi
    fi

    # Create local .claude directory
    mkdir -p "$local_claude_dir"
    write_color "✓ Created local .claude directory" "$COLOR_SUCCESS"

    # Local folders to install
    local local_folders=("agents" "commands" "output-styles")

    write_color "Installing local components (agents, commands, output-styles)..." "$COLOR_INFO"
    for folder in "${local_folders[@]}"; do
        local source_folder="${source_claude_dir}/${folder}"
        local dest_folder="${local_claude_dir}/${folder}"

        if [ -d "$source_folder" ]; then
            # Use new backup and replace logic for local folders
            write_color "Installing local folder: $folder..." "$COLOR_INFO"
            backup_and_replace_directory "$source_folder" "$dest_folder" "$folder folder" "$backup_folder"
            write_color "✓ Installed local folder: $folder" "$COLOR_SUCCESS"
        else
            write_color "WARNING: Source folder not found: $folder" "$COLOR_WARNING"
        fi
    done

    # Global components - exclude local folders
    write_color "Installing global components to $global_claude_dir..." "$COLOR_INFO"

    local merged_count=0

    while IFS= read -r -d '' file; do
        local relative_path="${file#$source_claude_dir/}"
        local top_folder=$(echo "$relative_path" | cut -d'/' -f1)

        # Skip local folders
        if [[ " ${local_folders[*]} " =~ " ${top_folder} " ]]; then
            continue
        fi

        local dest_path="${global_claude_dir}/${relative_path}"
        local dest_dir=$(dirname "$dest_path")

        mkdir -p "$dest_dir"

        if [ -f "$dest_path" ]; then
            if [ "$BACKUP_ALL" = true ] && [ "$NO_BACKUP" = false ]; then
                if [ -n "$backup_folder" ]; then
                    backup_file_to_folder "$dest_path" "$backup_folder"
                fi
                cp "$file" "$dest_path"
                ((merged_count++))
            elif [ "$NO_BACKUP" = true ]; then
                if confirm_action "File '$relative_path' already exists in global location. Replace it? (NO BACKUP)" false; then
                    cp "$file" "$dest_path"
                    ((merged_count++))
                fi
            elif confirm_action "File '$relative_path' already exists in global location. Replace it?" false; then
                if [ -n "$backup_folder" ]; then
                    backup_file_to_folder "$dest_path" "$backup_folder"
                fi
                cp "$file" "$dest_path"
                ((merged_count++))
            fi
        else
            cp "$file" "$dest_path"
            ((merged_count++))
        fi
    done < <(find "$source_claude_dir" -type f -print0)

    write_color "✓ Merged $merged_count files to global location" "$COLOR_SUCCESS"

    # Handle CLAUDE.md file in global .claude directory
    local global_claude_md="${global_claude_dir}/CLAUDE.md"
    write_color "Installing CLAUDE.md to global .claude directory..." "$COLOR_INFO"
    copy_file_to_destination "$source_claude_md" "$global_claude_md" "CLAUDE.md" "$backup_folder"

    # Remove empty backup folder
    if [ -n "$backup_folder" ] && [ -d "$backup_folder" ]; then
        if [ -z "$(ls -A "$backup_folder" 2>/dev/null)" ]; then
            rm -rf "$backup_folder"
            write_color "Removed empty backup folder" "$COLOR_INFO"
        fi
    fi

    # Create version.json in local .claude directory
    write_color "Creating version.json in local directory..." "$COLOR_INFO"
    create_version_json "$local_claude_dir" "Path"

    # Also create version.json in global .claude directory
    write_color "Creating version.json in global directory..." "$COLOR_INFO"
    create_version_json "$global_claude_dir" "Global"

    return 0
}

function get_installation_mode() {
    if [ -n "$INSTALL_MODE" ]; then
        write_color "Installation mode: $INSTALL_MODE" "$COLOR_INFO" >&2
        echo "$INSTALL_MODE"
        return
    fi

    local modes=(
        "Global - Install CommitCraft to user profile (~/.claude/)"
        "Path - Install CommitCraft to custom directory (agents/commands local + global config)"
    )

    local selection=$(get_user_choice "Choose installation mode:" "${modes[@]}")

    if [[ "$selection" == Global* ]]; then
        echo "Global"
    elif [[ "$selection" == Path* ]]; then
        echo "Path"
    else
        echo "Global"
    fi
}

function get_installation_path() {
    local mode="$1"

    if [ "$mode" = "Global" ]; then
        echo "$HOME"
        return
    fi

    if [ -n "$TARGET_PATH" ]; then
        if [ -d "$TARGET_PATH" ]; then
            echo "$TARGET_PATH"
            return
        fi
        write_color "WARNING: Specified target path does not exist: $TARGET_PATH" "$COLOR_WARNING"
    fi

    # Interactive path selection
    while true; do
        echo ""
        write_color "Enter the target directory path for installation:" "$COLOR_PROMPT"
        write_color "(This will install agents, commands, output-styles locally, other files globally)" "$COLOR_INFO"
        read -p "Path: " path

        if [ -z "$path" ]; then
            write_color "Path cannot be empty" "$COLOR_WARNING"
            continue
        fi

        # Expand ~ and environment variables
        path=$(eval echo "$path")

        if [ -d "$path" ]; then
            echo "$path"
            return
        fi

        write_color "Path does not exist: $path" "$COLOR_WARNING"
        if confirm_action "Create this directory?" true; then
            if mkdir -p "$path"; then
                write_color "✓ Directory created successfully" "$COLOR_SUCCESS"
                echo "$path"
                return
            else
                write_color "ERROR: Failed to create directory" "$COLOR_ERROR"
            fi
        fi
    done
}

function create_version_json() {
    local target_claude_dir="$1"
    local installation_mode="$2"

    # Determine version from source parameter (passed from install-remote.sh)
    local version_number="${SOURCE_VERSION:-unknown}"
    local source_branch="${SOURCE_BRANCH:-unknown}"
    local commit_sha="${SOURCE_COMMIT:-unknown}"

    # Get current UTC timestamp
    local installation_date_utc=$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -u +"%Y-%m-%dT%H:%M:%SZ")

    # Create version.json content
    local version_json_path="${target_claude_dir}/version.json"

    cat > "$version_json_path" << EOF
{
  "version": "$version_number",
  "commit_sha": "$commit_sha",
  "installation_mode": "$installation_mode",
  "installation_path": "$target_claude_dir",
  "installation_date_utc": "$installation_date_utc",
  "source_branch": "$source_branch",
  "installer_version": "$VERSION"
}
EOF

    if [ -f "$version_json_path" ]; then
        write_color "Created version.json: $version_number ($commit_sha) - $installation_mode" "$COLOR_SUCCESS"
        return 0
    else
        write_color "WARNING: Failed to create version.json" "$COLOR_WARNING"
        return 1
    fi
}

function show_summary() {
    local mode="$1"
    local path="$2"
    local success="$3"

    echo ""
    if [ "$success" = true ]; then
        write_color "✓ Installation completed successfully!" "$COLOR_SUCCESS"
    else
        write_color "Installation completed with warnings" "$COLOR_WARNING"
    fi

    write_color "Installation Details:" "$COLOR_INFO"
    echo "  Mode: $mode"

    if [ "$mode" = "Path" ]; then
        echo "  Local Path: $path"
        echo "  Global Path: $HOME"
        echo "  Local Components: agents, commands, output-styles, .codex, .gemini, .qwen"
        echo "  Global Components: workflows, scripts, python_script, etc."
    else
        echo "  Path: $path"
        echo "  Global Components: .claude, .codex, .gemini, .qwen"
    fi

    if [ "$NO_BACKUP" = true ]; then
        echo "  Backup: Disabled (no backup created)"
    elif [ "$BACKUP_ALL" = true ]; then
        echo "  Backup: Enabled (automatic backup of all existing files)"
    else
        echo "  Backup: Enabled (default behavior)"
    fi

    echo ""
    write_color "Next steps:" "$COLOR_INFO"
    echo "1. Review CLAUDE.md - CommitCraft development guidelines"
    echo "2. Navigate to your project directory"
    echo "3. Run the commit workflow command:"
    echo "   /commit-pilot <COMMIT_DESCRIPTION>"
    echo "4. Follow the interactive prompts to:"
    echo "   - Review file grouping"
    echo "   - Select branch strategy"
    echo "   - Choose merge strategy"
    echo "5. Let the 5-agent pipeline handle your commits professionally!"

    echo ""
    write_color "Documentation: Check .claude/commands/commit-pilot.md for detailed usage" "$COLOR_INFO"
    write_color "Features: 5-agent pipeline (analyzer → grouper → message → validator → executor)" "$COLOR_INFO"
}

function parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -InstallMode)
                INSTALL_MODE="$2"
                shift 2
                ;;
            -TargetPath)
                TARGET_PATH="$2"
                shift 2
                ;;
            -Force)
                FORCE=true
                shift
                ;;
            -NonInteractive)
                NON_INTERACTIVE=true
                shift
                ;;
            -BackupAll)
                BACKUP_ALL=true
                NO_BACKUP=false
                shift
                ;;
            -NoBackup)
                NO_BACKUP=true
                BACKUP_ALL=false
                shift
                ;;
            -SourceVersion)
                SOURCE_VERSION="$2"
                shift 2
                ;;
            -SourceBranch)
                SOURCE_BRANCH="$2"
                shift 2
                ;;
            -SourceCommit)
                SOURCE_COMMIT="$2"
                shift 2
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                write_color "Unknown option: $1" "$COLOR_ERROR"
                show_help
                exit 1
                ;;
        esac
    done
}

function show_help() {
    cat << EOF
$SCRIPT_NAME v$VERSION

Usage: $0 [OPTIONS]

Options:
    -InstallMode <mode>   Installation mode: Global or Path
    -TargetPath <path>    Target path for Path installation mode
    -Force                Skip confirmation prompts
    -NonInteractive       Run in non-interactive mode with default options
    -BackupAll            Automatically backup all existing files (default)
    -NoBackup             Disable automatic backup functionality
    -SourceVersion <ver>  Source version (passed from install-remote.sh)
    -SourceBranch <name>  Source branch (passed from install-remote.sh)
    -SourceCommit <sha>   Source commit SHA (passed from install-remote.sh)
    --help, -h            Show this help message

Examples:
    # Interactive installation
    $0

    # Global installation without prompts
    $0 -InstallMode Global -Force

    # Path installation with custom directory
    $0 -InstallMode Path -TargetPath /path/to/your/project

    # Installation without backup
    $0 -NoBackup

    # With version info (typically called by install-remote.sh)
    $0 -InstallMode Global -Force -SourceVersion "1.0.0" -SourceBranch "feature/commitcraft-standalone" -SourceCommit "abc1234"

EOF
}

function main() {
    show_header

    # Test prerequisites
    write_color "Checking system requirements..." "$COLOR_INFO"
    if ! test_prerequisites; then
        write_color "Prerequisites check failed!" "$COLOR_ERROR"
        return 1
    fi

    local mode=$(get_installation_mode)
    local install_path=""
    local success=false

    if [ "$mode" = "Global" ]; then
        install_path="$HOME"
        if install_global; then
            success=true
        fi
    elif [ "$mode" = "Path" ]; then
        install_path=$(get_installation_path "$mode")
        if install_path "$install_path"; then
            success=true
        fi
    fi

    show_summary "$mode" "$install_path" "$success"

    # Wait for user confirmation in interactive mode
    if [ "$NON_INTERACTIVE" != true ]; then
        echo ""
        write_color "Installation completed. Press Enter to exit..." "$COLOR_PROMPT"
        read -r
    fi

    if [ "$success" = true ]; then
        return 0
    else
        return 1
    fi
}

# Initialize backup behavior - backup is enabled by default unless NoBackup is specified
if [ "$NO_BACKUP" = false ]; then
    BACKUP_ALL=true
fi

# Parse command line arguments
parse_arguments "$@"

# Run main function
main
exit $?
