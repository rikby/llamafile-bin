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

1. Clone or download the scripts to your desired location
2. Run the installation script:

```bash
./install.sh
```

This will:
- Create a symlink at `~/bin/llamafile`
- Make the scripts executable
- Provide PATH setup instructions

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
llamafile/
├── llamafile.sh    # Main script
├── install.sh      # Installation script
├── README.md       # This file
└── models/         # Directory for .llamafile files
    └── *.llamafile
```

## Requirements

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
   - Models subdirectory (`models/`)

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

## Troubleshooting

### File not executable
```bash
chmod +x path/to/your/model.llamafile
```

### Script not in PATH
Make sure `~/bin` is in your PATH:
```bash
echo $PATH | grep "$HOME/bin"
```

### fzf not found
Install fzf using your system's package manager (see Requirements section).

## License

This project is released into the public domain. Feel free to use, modify, and distribute as needed.