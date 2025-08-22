#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to show error and exit
show_error() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Get the directory where this script is located (resolve symlinks)
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null || realpath "${BASH_SOURCE[0]}" 2>/dev/null || echo "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CONFIG_FILE="$SCRIPT_DIR/config.sh"

# Load configuration
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    show_error "Configuration file not found at $CONFIG_FILE"
fi

# Check if fzf is installed (will be used if available)
FZF_AVAILABLE=false
if command -v fzf &> /dev/null; then
    FZF_AVAILABLE=true
fi

# Search directories (current directory and models directory from config)
SEARCH_DIRS=("." "$MODELS_DIR")

# Function to find llamafiles
find_llamafiles() {
    local pattern="$1"
    local files=()
    
    for dir in "${SEARCH_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            while IFS= read -r -d '' file; do
                files+=("$file")
            done < <(find "$dir" -maxdepth 1 -name "${pattern}*.llamafile" -print0 2>/dev/null)
        fi
    done
    
    printf '%s\n' "${files[@]}"
}

# If no argument is provided, list all models and let the user choose
if [ -z "$1" ]; then
    files=($(find_llamafiles ""))
else
    # Find llamafiles based on the user's input
    files=($(find_llamafiles "$1"))
fi

# Check if any files were found
if [ ${#files[@]} -eq 0 ]; then
    show_error "No llamafile found matching '$1'."
fi

# If more than one file is found, use fzf (if available) or show a list
if [ ${#files[@]} -gt 1 ]; then
    if [ "$FZF_AVAILABLE" = true ]; then
        # Create associative arrays for filename to path mapping
        declare -A file_map
        filenames=()
        
        for file in "${files[@]}"; do
            filename=$(basename "$file")
            file_map["$filename"]="$file"
            filenames+=("$filename")
        done
        
        selected_filename=$(printf "%s\n" "${filenames[@]}" | fzf --height=~40% --layout=reverse)
        if [ -n "$selected_filename" ]; then
            selected_file="${file_map[$selected_filename]}"
        fi
    else
        echo -e "${YELLOW}Multiple llamafiles found:${NC}"
        for i in "${!files[@]}"; do
            filename=$(basename "${files[$i]}")
            echo -e "${CYAN}$((i+1)). $filename${NC}"
        done
        
        echo -n "Select a file (1-${#files[@]}): "
        read -r choice
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#files[@]} ]; then
            selected_file="${files[$((choice-1))]}"
        else
            show_error "Invalid selection."
        fi
    fi
else
    selected_file=${files[0]}
fi

# Check if a file was selected
if [ -z "$selected_file" ]; then
    exit 0
fi

# Check if the file is executable
if [ ! -x "$selected_file" ]; then
    show_error "File '$selected_file' is not executable. Please run 'chmod +x \"$selected_file\"'."
fi

# Run the llamafile
echo -e "${GREEN}Running $selected_file...${NC}"
"$selected_file" "$@"
