_G.need = require "need"
local core = need "lua-light-wings" core.globalize(core)
local utils = need "utils"
local conf = utils.get_configuration("conf.lua")
if conf.debug_mode then dofile("tests.lua") end
local M = {}
--------------------------------------------------------------------------------

local function application()
    msg("nixos extended rebuilder is cooking your config...")

    if conf.debug_mode then
        msg("content of the loaded configuration:")
        msg(conf)
    end

    if utils.value_in_table("upgrade", arg) then
        M.upgrade_system(conf.entry_path)
    end

end

--------------------------------------------------------------------------------

function M.upgrade_system(x)
-- runs complete system upgrade
    local path = is_path(x) or "/etc/nixos/configuration.nix"
    msg "NixOS upgrade..."
    --TODO add flatpak declarativ flatpak rebuilder
    os.execute("sudo nixos-rebuild switch --upgrade -I nixos-config=" .. path)
    msg("taking care of flatpaks...")
    os.execute("flatpak update -y")
    os.execute("nixos-rebuild list-generations | grep current")
end

application()
