local conf = {}
--------------------------------------------------------------------------------
conf.debug_mode = true

conf.entry_path = "/etc/nixos/configuration.nix"

conf.channels = {
    "nixos https://nixos.org/channels/nixos-unstable"
}

--------------------------------------------------------------------------------
return conf