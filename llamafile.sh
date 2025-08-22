#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to show error and exit
show_error() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    show_error "fzf is not installed. Please install it to use this script."
fi

# Search directories (current directory and models subdirectory)
SEARCH_DIRS=("." "models")

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

# If more than one file is found, use fzf to select one
if [ ${#files[@]} -gt 1 ]; then
    selected_file=$(printf "%s\n" "${files[@]}" | fzf)
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
