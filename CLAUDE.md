# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for an Arch Linux system with Hyprland (Wayland) desktop environment. The repository contains configuration files for desktop environment, terminal, editors, and development tools.

## System Architecture

- **OS**: Arch Linux with `yay` AUR helper
- **Desktop Environment**: Hyprland (Wayland compositor) with Waybar, Mako notifications
- **Terminal**: Kitty with Zellij terminal multiplexer
- **Shell**: Zsh with Zinit plugin manager and Powerlevel10k prompt
- **Editor**: Neovim with NvChad configuration framework
- **Development**: Node.js/TypeScript, Rust, Ruby with various LSPs

## Installation & Setup Commands

### Initial System Setup
```bash
# Install entire dotfiles system (requires sudo)
./install.sh
```

The install script:
- Installs `yay` AUR helper if not present
- Installs all packages from predefined lists
- Syncs config files to `~/.config/`
- Copies scripts to `~/.local/bin/`
- Sets up Zsh as default shell
- Configures NVIDIA drivers and system services

### Package Management
```bash
# Install new packages
yay -S package-name

# Update system
yay -Syyu

# Clean unused dependencies  
yay -Rns $(yay -Qdtq)
```

## Configuration Structure

### Main Configuration Directories
- `config/` - All application configs that go to `~/.config/`
- `scripts/` - Utility scripts copied to `~/.local/bin/`
- `ssh/config` - SSH configuration
- `.zshrc` - Zsh shell configuration
- `other/greetd.conf` - Login manager configuration

### Key Applications & Configs
- **Hyprland**: `config/hypr/hyprland.conf` - Window manager settings, keybinds, NVIDIA setup
- **Neovim**: `config/nvim/` - NvChad-based configuration with LSPs and plugins
- **Waybar**: `config/waybar/` - Status bar configuration and styling
- **Kitty**: `config/kitty/kitty.conf` - Terminal emulator settings
- **Zellij**: `config/zellij/` - Terminal multiplexer layouts and config

### Package Lists in install.sh
- `cli_tools` - Command line utilities (bat, ripgrep, fzf, etc.)
- `desktop_apps` - GUI applications (Firefox, Discord, Spotify, etc.)
- `desktop_environment` - Wayland/Hyprland components
- `dev_tools` - Development tools (Docker, etc.)
- `fonts` - Font packages including Nerd Fonts
- `gaming` - Gaming-related packages (Steam, MangoHud, etc.)
- `graphics` - NVIDIA drivers and related packages
- `system_utilities` - Core system tools

## Development Environment

### Neovim Setup
- Uses **NvChad v2.5** framework
- Theme: `everforest_light`
- Configured LSPs for multiple languages (see `deps-list.txt` lines 71-88)
- AI integration with Aider and MCP Hub

### Shell Environment
- **Zsh** with Zinit plugin manager
- **Powerlevel10k** prompt theme
- **fzf** for fuzzy finding with shell integration
- **zoxide** for smart directory navigation
- Vi mode keybindings

### Available Tools
- **Rust**: Full toolchain with rust-analyzer LSP
- **Node.js**: v20 with TypeScript and various LSPs
- **Ruby**: With Solargraph LSP
- **Docker**: With compose and language servers
- **Git**: With SSH configuration

## System-Specific Notes

### NVIDIA Configuration
The system is configured for NVIDIA GPUs with:
- Open DKMS drivers
- Wayland compatibility settings
- Hardware acceleration for media

### Hyprland Keybinds & Workflows
- Master layout as default
- Custom workspace management scripts in `config/hyprland-fzfify/`
- Rose Pine cursor theme

### Security Notes
- Uses `doas` instead of `sudo` for privilege escalation
- SSH config with custom settings
- No sensitive data should be committed to this repository