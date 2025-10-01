local conf = { dot = {} }

--------------------------------------------------------------------------------

conf.help = [[

Run: os [option]

Options:
    help        :   shows this dialog
    rebuild     :   creates generation, based on conf.entry_path,
                    installs flatpaks, syncs user configuration, runs commands
                    from conf.postroutine
    userconf    :   syncs user configuration
    cleanup     :   set of commands to collect garbage and free up space
    upgrade     :   same as rebuild + upgrades all nix packages to the latest
                    version
    version     :   shows version and current NixOS generation

$LUAOS is used to determine path of the configuration file. If the variable not
set or file does not exist, default template will be created during first run in
$HOME/.nixconf.lua

Documentation: <https://github.com/burij/nixos-extended-rebuilder/>.
Help with Lua syntax: <https://lua.org>.
]]

--------------------------------------------------------------------------------
conf.debug_mode = false

conf.entry_path = "/etc/nixos/configuration.nix"

conf.channels = {"nixos https://nixos.org/channels/nixos-unstable"}

conf.flatpaks = {}

conf.cleanup = {
    "flatpak uninstall --unused",
    "nix-collect-garbage",
    "sudo nix-collect-garbage",
    "nix-collect-garbage -d",
    "sudo nix-collect-garbage -d",
}

conf.postroutine = {}

conf.dot.path =  os.getenv("HOME") .. "/.dotfiles"

conf.dot.gnome = "desktop"

conf.dot.files = {}

conf.editor = "nano"

--------------------------------------------------------------------------------
return conf