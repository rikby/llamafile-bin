#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;94m'
WHITE='\033[1;37m'
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

# Use XDG_CONFIG_HOME if set, otherwise default to ~/.config
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
LLAMAFILE_CONFIG_DIR="$CONFIG_HOME/llamafile"

# Create llamafile config directory if it doesn't exist
if [ ! -d "$LLAMAFILE_CONFIG_DIR" ]; then
    show_info "Creating $LLAMAFILE_CONFIG_DIR directory..."
    mkdir -p "$LLAMAFILE_CONFIG_DIR" || show_error "Failed to create $LLAMAFILE_CONFIG_DIR directory"
fi

# Create models directory
MODELS_DIR="$LLAMAFILE_CONFIG_DIR/models"
if [ ! -d "$MODELS_DIR" ]; then
    show_info "Creating $MODELS_DIR directory..."
    mkdir -p "$MODELS_DIR" || show_error "Failed to create $MODELS_DIR directory"
fi

# Download llamafile.sh from GitHub
LLAMAFILE_SCRIPT="$LLAMAFILE_CONFIG_DIR/llamafile.sh"
show_info "Downloading llamafile.sh from GitHub..."
curl -L -o "$LLAMAFILE_SCRIPT" "https://raw.githubusercontent.com/rikby/llamafile-bin/main/llamafile.sh" || show_error "Failed to download llamafile.sh"

# Create config.sh
CONFIG_SCRIPT="$LLAMAFILE_CONFIG_DIR/config.sh"
show_info "Creating config.sh..."
cat > "$CONFIG_SCRIPT" << EOF
#!/bin/bash
# Llamafile configuration

# Directory where llamafile models are stored
MODELS_DIR="$MODELS_DIR"
EOF

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
echo -e "Configuration directory: ${YELLOW}$LLAMAFILE_CONFIG_DIR${NC}"
echo -e "Models directory: ${YELLOW}$MODELS_DIR${NC}"
echo -e "Symlink created: ${YELLOW}$SYMLINK_PATH${NC} -> ${YELLOW}$LLAMAFILE_SCRIPT${NC}"
echo
echo -e "${YELLOW}Note: Make sure $BIN_DIR is in your PATH environment variable.${NC}"
echo -e "${YELLOW}You can add this line to your ~/.bashrc or ~/.zshrc:${NC}"
echo -e "${WHITE}export PATH=\"\$HOME/bin:\$PATH\"${NC}"
echo
echo -e "Usage: ${WHITE}llamafile [pattern]${NC}"
echo -e "Example: ${WHITE}llamafile Qwen${NC}  # Will find and run Qwen*.llamafile"
echo
echo -e "Place your .llamafile models in: ${YELLOW}$MODELS_DIR${NC}"
