_G.need = require "need"
local core = need "lua-light-wings" core.globalize(core)
local utils = need "utils"
local conf = utils.get_configuration("conf.lua")
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

    -- TODO add message for usage without the right arguments

end

--------------------------------------------------------------------------------
application()
