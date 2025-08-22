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

# Function to show success message
show_success() {
    echo -e "${GREEN}$1${NC}"
}

# Function to show info message
show_info() {
    echo -e "${BLUE}$1${NC}"
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LLAMAFILE_SCRIPT="$SCRIPT_DIR/llamafile.sh"

# Check if llamafile.sh exists
if [ ! -f "$LLAMAFILE_SCRIPT" ]; then
    show_error "llamafile.sh not found in $SCRIPT_DIR"
fi

# Create ~/bin directory if it doesn't exist
BIN_DIR="$HOME/bin"
if [ ! -d "$BIN_DIR" ]; then
    show_info "Creating $BIN_DIR directory..."
    mkdir -p "$BIN_DIR" || show_error "Failed to create $BIN_DIR directory"
fi

# Path for the symlink
SYMLINK_PATH="$BIN_DIR/llamafile"

# Remove existing symlink or file if it exists
if [ -e "$SYMLINK_PATH" ] || [ -L "$SYMLINK_PATH" ]; then
    show_info "Removing existing file/symlink at $SYMLINK_PATH..."
    rm -f "$SYMLINK_PATH" || show_error "Failed to remove existing file/symlink"
fi

# Make the llamafile.sh script executable
chmod +x "$LLAMAFILE_SCRIPT" || show_error "Failed to make llamafile.sh executable"

# Create the symlink
ln -s "$LLAMAFILE_SCRIPT" "$SYMLINK_PATH" || show_error "Failed to create symlink"

show_success "Successfully installed llamafile script!"
echo
show_info "Symlink created: $SYMLINK_PATH -> $LLAMAFILE_SCRIPT"
echo
echo -e "${YELLOW}Note: Make sure $BIN_DIR is in your PATH environment variable.${NC}"
echo -e "${YELLOW}You can add this line to your ~/.bashrc or ~/.zshrc:${NC}"
echo -e "${YELLOW}export PATH=\"\$HOME/bin:\$PATH\"${NC}"
echo
show_info "Usage: llamafile [pattern]"
show_info "Example: llamafile Qwen  # Will find and run Qwen*.llamafile"