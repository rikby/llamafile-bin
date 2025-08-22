# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Architecture

This is a bash-based llamafile runner that provides fuzzy matching and interactive selection for llamafile models. The architecture consists of:

### Core Components

- **install.sh**: Installation script that sets up the entire system by creating directories, downloading scripts, and configuring the environment
- **llamafile.sh**: Main executable script that provides fuzzy matching and selection for llamafile models  
- **config.sh**: Configuration file (generated during install) that defines `MODELS_DIR` and other settings

### Directory Structure

The project uses XDG Base Directory specification:
- Configuration: `${XDG_CONFIG_HOME:-$HOME/.config}/llamafile/`
- Models storage: `~/.config/llamafile/models/`
- Executable symlink: `~/bin/llamafile`

### Key Design Patterns

1. **Configuration-driven**: `llamafile.sh` loads `config.sh` at runtime to get `MODELS_DIR` and other settings
2. **Remote installation**: `install.sh` downloads the latest `llamafile.sh` from GitHub rather than using local copy
3. **Multi-directory search**: Searches both current directory (`.`) and configured models directory
4. **Shell compatibility**: All scripts work with both bash and zsh

## Common Commands

### Testing the Installation Process
```bash
# Test the install script locally
./install.sh

# Test the GitHub remote install (after pushing changes)
curl -fsSL https://raw.githubusercontent.com/rikby/llamafile-bin/main/install.sh | bash
```

### Testing the Main Script
```bash
# Test direct execution
./llamafile.sh

# Test via symlink (after install)
llamafile

# Test pattern matching
llamafile Qwen
```

### Development Workflow
```bash
# Make scripts executable during development
chmod +x install.sh llamafile.sh

# Test changes before pushing
./install.sh && llamafile
```

## Configuration System

The configuration system is central to the architecture:

1. **install.sh** creates `config.sh` with `MODELS_DIR` variable
2. **llamafile.sh** sources `config.sh` to get the models directory path
3. This allows the models directory to be configurable and respects XDG standards

When modifying configuration:
- Update the config creation in `install.sh` (lines 49-57)
- Ensure `llamafile.sh` properly loads and uses the config variables
- The `MODELS_DIR` variable is used in the `SEARCH_DIRS` array

## Shell Compatibility Requirements

All scripts must work with both bash and zsh:
- Use `#!/bin/bash` shebang 
- Avoid bash-specific features that don't work in zsh
- Test array handling and parameter expansion in both shells
- Use POSIX-compatible commands where possible

## Installation Architecture

The installation follows a specific pattern:
1. Creates XDG-compliant directory structure
2. Downloads the latest script from GitHub (not local copy)
3. Generates configuration file with absolute paths
4. Creates symlink in `~/bin/` for global access
5. Provides user feedback and next steps

This remote-download approach means the local repository version may differ from what gets installed, which is important for testing.