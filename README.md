# NixOS Extended Rebuilder

A Lua-based tool for managing NixOS configurations and system rebuilds with extended functionality.

## Features

- System rebuilding and upgrading
- Configuration management
- Dotfiles synchronization
- Flatpak application management
- Debug mode for testing and configuration inspection
- TUI interface (currently disabled)

## Prerequisites

- NixOS
- Lua
- Required Lua modules (automatically handled through nix)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/burij/nixos-extended-rebuilder.git
cd nixos-extended-rebuilder
```

2. The project uses Nix for dependencies and installation. The provided `default.nix` will handle all required dependencies.

## Usage

### Basic Commands

- Rebuild system:
```bash
os rebuild
```

- Upgrade system:
```bash
os upgrade
```

- Sync dotfiles:
```bash
os userconf
```

- Show help:
```bash
os help
```

### Configuration

The tool uses `conf.lua` for configuration settings. Key configuration options include:

- System paths and entry points
- NixOS channels
- Flatpak applications
- Dotfiles synchronization paths and patterns
- Debug mode settings

### Dotfiles Management

The tool provides comprehensive dotfiles management for various applications including:
- Desktop environments (GNOME)
- Development tools (Builder, Git)
- Browsers (Brave)
- Media applications (Darktable, REAPER, Tenacity)
- Productivity tools (Nextcloud, Obsidian)
- And many more

### Development

The project is built with a modular Lua architecture:
- Core functionality using `lua-light-wings`
- Custom module loading system (`need.lua`)
- Utility functions for file and system operations
- Debug mode for testing and configuration inspection

## Project Structure

```
.
├── modules/         # Core functionality modules
├── tui/            # Terminal User Interface (currently disabled)
├── conf.lua        # Main configuration file
├── default.nix     # Nix package configuration
├── main.lua        # Application entry point
├── need.lua        # Custom module loader
└── README.md       # This file
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit pull requests.

## Author

Michael Burij

---
**Note**: This project is currently work in progress (WIP). Some features like the TUI interface are temporarily disabled.
