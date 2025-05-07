_G.need = require "need"
local core = need "modules.lua-light-wings" core.globalize(core)
local utils = need "modules.utils"
--keep dofile, later logic with absolute path as output
local conf_path = os.getenv("LUAOS")
-- TODO set default conf_path, if it does not exists
-- TODO initiating a default conf.lua, if it is not in the path
msg(conf_path)
local conf = utils.get_configuration(conf_path)
local rebuild = need "modules.rebuild"
local tests = require "tests"
local M = {}
--------------------------------------------------------------------------------

local function application()
    if conf.debug_mode then
        tests.prestart()
        msg("content of the loaded configuration:")
        msg(conf)
    end

    if utils.value_in_table("rebuild", arg) or
        utils.value_in_table("upgrade", arg) then
        rebuild.system(conf.entry_path, conf.channels)
        elseif utils.value_in_table("tui", arg) then
            -- not working at the moment, but no plans for fixing now
            package.path = "./tui/?.lua;" .. package.path
            local tui = require "tui"
            tui()
        elseif utils.value_in_table("help", arg) then
            print "TODO create a module, which prints output of README.md"
        else print "argument missing. please run 'os help' to learn more."
    end
end

--------------------------------------------------------------------------------
application()
