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

conf.postroutine = {}

conf.dot.path =  os.getenv("HOME") .. "/.dotfiles"

conf.dot.gnome = "desktop"

conf.dot.files = {}

--------------------------------------------------------------------------------
return conf