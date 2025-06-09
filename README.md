# NixOS Extended Rebuilder

A Lua-based tool for managing NixOS configurations and system rebuilds with extended functionality.

It offers the possibility of managing additional aspects of NixOS in a declarative way without adding the complexity of flakes and Home Manager.

## Features

- **Shorter commands** for rebuilding and upgrading
- **Channel management** - declarative NixOS channels configuration
- **Custom configuration paths** - set custom path for NixOS configuration
- **Dotfiles management** - declarative synchronization with backup protection
- **GNOME Shell management** - declarative management of GNOME settings via dconf
- **Flatpak management** - declarative Flatpak application management
- **Custom commands** - define commands that run after rebuild
- **Debug mode** - for testing and configuration inspection

## Prerequisites

- Channel-based NixOS installation (flakes not required)
- Lua runtime (provided by Nix)

## Quick Start

The easiest way to try the tool is to build and run it locally:

```bash
wget -O default.nix https://raw.githubusercontent.com/burij/nixos-extended-rebuilder/refs/heads/main/default.nix && \
nix-build -A package && \
cd ./result/bin && \
./os help
```

## Installation

To permanently add NixOS Extended Rebuilder to your system, use the `callPackage` function in your NixOS configuration:

```nix
# configuration.nix
environment.systemPackages = with pkgs; [
  (callPackage /path/to/default.nix { }).package
];
```

**Note**: The `default.nix` contains both shell and package derivations - make sure to explicitly call `.package`.

## Usage

### Basic Commands

| Command | Description |
|---------|-------------|
| `os rebuild` | Rebuild the system |
| `os upgrade` | Upgrade the system |
| `os userconf` | Sync dotfiles |
| `os version` | Show version and current generation |
| `os help` | Show help information |

### Configuration

The tool uses a Lua configuration file (`nixconf.lua`) with declarative syntax. On first run of `os rebuild`, `upgrade`, or `userconf`, an empty configuration template will be created at `~/.nixconf.lua`.

#### Setting Configuration Path

For better organization, you can move the configuration file anywhere and set the `LUAOS` environment variable:

```bash
export LUAOS="/path/to/your/nixconf.lua"
```

To make this permanent, add it to your NixOS configuration:

```nix
# configuration.nix
environment.sessionVariables = {
  LUAOS = "$HOME/System/nixconf.lua";
};
```

### Dotfiles Management

NixOS Extended Rebuilder provides a simple approach to manage user configuration files by creating symlinks from a centralized dotfiles repository.

#### Configuration Structure

Declare dotfiles for synchronization using the `conf.dot.files` table:

```lua
-- nixconf.lua
conf.dot = {
  path = "/home/user/dotfiles",  -- Main dotfiles repository
  files = {
    nvim = {
      ".config/nvim/init.lua",
      ".config/nvim/lua/",
    },
    shell = {
      ".bashrc",
      ".zshrc",
    },
    desktop = {
      ".config/gtk-3.0/settings.ini",
      ".local/share/applications/",
    }
  },
  gnome = "/home/user/dotfiles/gnome"  -- GNOME dconf settings path
}
```

#### How Dotfiles Sync Works

1. **Repository Creation**: Creates the main dotfiles repository if it doesn't exist
2. **Structure Setup**: Automatically creates necessary subfolders and target directory structure
3. **File Protection**: 
   - If a config file exists in target location but not in repository → moves it to repository
   - If file exists in both locations → renames target file with timestamp and moves to repository
4. **Symlink Creation**: Creates symlinks for all files and folders in the repository
5. **GNOME Integration**: Dumps dconf database and loads declarative settings

#### Safety Features

- **No data loss**: All existing configurations are backed up with timestamps
- **Conflict resolution**: Handles applications that overwrite symlinks (like Brave browser)
- **Version control ready**: Repository structure is designed for Git tracking

**Recommendation**: Track your dotfiles repository with version control for additional safety.

### Channel Management

Declare NixOS channels in your configuration:

```lua
conf.channels = {
  nixos = "https://nixos.org/channels/nixos-24.05",
  nixpkgs-unstable = "https://nixos.org/channels/nixpkgs-unstable"
}
```

### Custom Commands

Define commands to run after system rebuild:

```lua
conf.post_rebuild = {
  "systemctl --user restart some-service",
  "notify-send 'System rebuilt successfully'"
}
```

## Development

### Getting Started

```bash
git clone https://github.com/burij/nixos-extended-rebuilder.git
cd nixos-extended-rebuilder
nix-shell -A shell
```

### Development Commands

Inside the development shell:

```bash
os-dev [option]  # Run development version
```

### Project Structure

```
.
├── modules/         # Core functionality modules
├── conf.lua        # Main configuration file template
├── default.nix     # Nix package and shell configuration
├── main.lua        # Application entry point
├── need.lua        # Custom module loader
└── README.md       # Documentation
```

## Examples

### Complete Configuration Example

```lua
-- ~/.nixconf.lua or your custom path
conf = {}

-- System configuration
conf.nixos_config = "/etc/nixos"
conf.debug = false

-- Channels
conf.channels = {
  nixos = "https://nixos.org/channels/nixos-24.05"
}

-- Dotfiles
conf.dot = {
  path = os.getenv("HOME") .. "/dotfiles",
  files = {
    shell = { ".bashrc", ".zshrc" },
    editor = { ".config/nvim/" }
  },
  gnome = os.getenv("HOME") .. "/dotfiles/gnome"
}

-- Post-rebuild commands
conf.post_rebuild = {
  "echo 'Rebuild completed at ' $(date)"
}

return conf
```

## Troubleshooting

### Common Issues

- **Permission errors**: Ensure your user has sudo privileges for system rebuilds
- **Missing dependencies**: Make sure Lua and required Nix tools are available
- **Symlink conflicts**: Check for applications that overwrite symlinks

### Debug Mode

Enable debug mode in your configuration:

```lua
conf.debug = true
```

This provides verbose output for troubleshooting configuration issues.

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Michael Burij**

---

> **Note**: This project is work in progress, was created mostly for personal use and might damage your system. Please don't try it out on a productive machine, if you don't know, what are you doing. Features may be added or modified in future releases. Please report issues on the [GitHub repository](https://github.com/burij/nixos-extended-rebuilder).