-- TODO dofile as relative path does not work if packaged for nix
_G.need = require "need"
local core = need "modules.lua-light-wings" core.globalize(core)
local utils = need "modules.utils"
local conf = utils.get_configuration("conf.lua")
-- TODO add a system to get conf.lua path from envirement variable
local rebuild = need "rebuild"
if conf.debug_mode then dofile("tests.lua") end
local M = {}
--------------------------------------------------------------------------------

local function application()
    if conf.debug_mode then
        msg("content of the loaded configuration:")
        msg(conf)
    end

    if utils.value_in_table("rebuild", arg) or
        utils.value_in_table("upgrade", arg) then
        rebuild.system(conf.entry_path, conf.channels)
    end

    if utils.value_in_table("tui", arg) then
        package.path = "./tui/?.lua;" .. package.path
        local tui = require "tui"
        tui()
    end

    -- TODO add message for usage without the right arguments

end

--------------------------------------------------------------------------------
application()
