local conf = { dot = {} }

--------------------------------------------------------------------------------
conf.debug_mode = false

conf.entry_path = "/etc/nixos/configuration.nix"

conf.channels = {
    "nixos https://nixos.org/channels/nixos-unstable"
}

conf.flatpaks = {}

conf.dot.path =  os.getenv("HOME") .. "/.dotfiles"

conf.dot.gnome = "desktop"

conf.dot.files = {}


--------------------------------------------------------------------------------
return conf