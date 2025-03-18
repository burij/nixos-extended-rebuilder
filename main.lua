need = require "need"
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

    msg(
        utils.value_in_table("rebuild", arg)
    )

end

--------------------------------------------------------------------------------


conf.upgrade = [[
echo "NixOS update..."
sudo nixos-rebuild switch --upgrade
nixos-rebuild list-generations | grep current
flatpak update -y
notify-send -e "NixOS upgrade finished" --icon=software-update-available
]]


application()
