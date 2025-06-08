local conf = { dot = {} }

--------------------------------------------------------------------------------

conf.help = [[

Run: os option

Options:
    rebuild     :   creates generation, based on conf.entry_path,
                    installs flatpaks, syncs user configuration, runs commands
                    from conf.postroutine
    userconf    :   syncs user configuration
    upgrade     :   same as rebuild + upgrades all nix packages to the latest
                    version
    version     :   shows version and current NixOS generation

TODO: additional explainations
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