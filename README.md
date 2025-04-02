# NixOS Extended Rebuilder

A Lua-based tool for managing NixOS configurations and system rebuilds with extended functionality.

## Features

- System rebuilding and upgrading
- New machine setup automation
- Configuration management
- Garbage collection utilities
- Server administration helpers
- Flatpak support

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

### Setting Up a New Machine

The tool provides automated setup for new NixOS machines with:
- User configuration
- Host configuration
- Hardware configuration
- State version management
- Automatic backup of original configurations

### Configuration

The tool uses `conf.lua` for configuration settings. Key configuration options include:

- System paths
- User settings
- Server configurations
- Template settings
- Garbage collection commands
- Flatpak integration

### Server Administration

Includes utilities for:
- Docker container management
- Volume management
- Backup handling
- Blog and website building
- Nextcloud administration

## Development

The project is built with a modular Lua architecture:
- Core functionality using `lua-light-wings`
- Custom module loading system (`need.lua`)
- Utility functions for file and system operations
- JSON parsing and handling capabilities

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit pull requests.

## Author

Michael Burij

---
**Note**: This project is currently work in progress (WIP).
