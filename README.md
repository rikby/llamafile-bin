# Llamafile Runner

A simple bash script to easily find and run llamafile models with fuzzy matching and interactive selection.

## Features

- 🔍 **Fuzzy pattern matching** - Find models by partial name
- 🎯 **Interactive selection** - Use fzf to choose from multiple matches
- 🌈 **Colorized output** - User-friendly colored messages
- 📁 **Flexible search** - Searches current directory and `models/` subdirectory
- ✅ **Permission checking** - Warns if llamafile isn't executable
- 🔗 **Easy installation** - One-command setup with symlink

## Installation

### Quick Install from GitHub (Recommended)

Run this one-liner to install directly from GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/rikby/llamafile-bin/main/install.sh | bash
```

This will:
- Create `~/.config/llamafile/` directory (uses `$XDG_CONFIG_HOME` if set)
- Download the latest `llamafile.sh` script from GitHub
- Create a configuration file with default settings
- Create `~/.config/llamafile/models/` directory for your models
- Create a symlink at `~/bin/llamafile`
- Provide PATH setup instructions

### Manual Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/rikby/llamafile-bin.git
   cd llamafile-bin
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

### Adding Models

**Add your llamafile models** to the `~/.config/llamafile/models/` directory:
```bash
# Download or copy your .llamafile files to the models directory
cp /path/to/your/model.llamafile ~/.config/llamafile/models/

# Make sure they're executable
chmod +x ~/.config/llamafile/models/*.llamafile
```

### PATH Setup

Add `~/bin` to your PATH if it's not already there:

```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$HOME/bin:$PATH"
```

## Usage

### Basic Usage

```bash
# Show all .llamafile files and select with fzf
llamafile

# Find files matching a pattern
llamafile Qwen
llamafile llama
llamafile phi
```

### Examples

```bash
# Run any available model (opens fzf selector)
llamafile

# Find and run Qwen models
llamafile Qwen
# Finds: Qwen2.5-7B-Instruct-1M-Q4_K_M.llamafile

# Find models starting with "llama"
llamafile llama

# Pass arguments to the llamafile
llamafile Qwen --help
llamafile phi --chat
```

## File Structure

```
~/.config/llamafile/
├── llamafile.sh     # Main script (downloaded automatically)
├── config.sh        # Configuration file
└── models/          # Directory for your .llamafile files
    └── (your .llamafile files go here)

~/bin/
└── llamafile        # Symlink to ~/.config/llamafile/llamafile.sh
```

**Note:** Models are stored in `~/.config/llamafile/models/` and are not tracked in git.

## Requirements

- **bash** or **zsh** shell - The scripts are compatible with both
- **fzf** - For interactive file selection
  ```bash
  # Install via homebrew (macOS)
  brew install fzf
  
  # Install via apt (Ubuntu/Debian)
  sudo apt install fzf
  
  # Install via yum (RHEL/CentOS)
  sudo yum install fzf
  ```

## How It Works

1. **Search**: Looks for `*.llamafile` files in:
   - Current directory (`.`)
   - Configured models directory (`~/.config/llamafile/models/`)

2. **Match**: Finds files matching the pattern `[pattern]*.llamafile`

3. **Select**: 
   - If one match: runs it directly
   - If multiple matches: opens fzf for selection
   - If no matches: shows error message

4. **Execute**: Runs the selected llamafile with any additional arguments

## Error Handling

The script provides helpful error messages for common issues:

- **No fzf installed**: `Error: fzf is not installed. Please install it to use this script.`
- **No matches found**: `Error: No llamafile found matching 'pattern'.`
- **Not executable**: `Error: File 'filename' is not executable. Please run 'chmod +x "filename"'.`

## Getting Models

You can download llamafile models from various sources:

- [Hugging Face](https://huggingface.co/models?other=llamafile) - Search for models with "llamafile" tag
- [Mozilla's llamafile releases](https://github.com/Mozilla-Ocho/llamafile/releases) - Pre-built models
- Convert your own GGUF models using llamafile tools

Popular models to try:
- **Qwen2.5-7B-Instruct** - Great general purpose model
- **Llama-3.1-8B-Instruct** - Strong instruction following
- **Phi-3-mini** - Lightweight and fast

## Troubleshooting

### File not executable
```bash
chmod +x ~/.config/llamafile/models/your-model.llamafile
```

### Script not in PATH
Make sure `~/bin` is in your PATH:
```bash
echo $PATH | grep "$HOME/bin"
```

### No models found
Make sure you have `.llamafile` files in the models directory:
```bash
ls -la ~/.config/llamafile/models/
```

### fzf not found
Install fzf using your system's package manager (see Requirements section).

## License

This project is released into the public domain. Feel free to use, modify, and distribute as needed.