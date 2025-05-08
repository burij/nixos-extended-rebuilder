local M = {} _G.need = require "need"

local core = require "modules.lua-light-wings" core.globalize(core)
local utils = require "modules.utils"
local rebuild = require "modules.rebuild"
local tests = require "modules.tests"

--------------------------------------------------------------------------------

local function application()
    local default_conf_path = os.getenv("HOME") .. "/.nixconf.lua"
    local conf_path = os.getenv("LUAOS") or default_conf_path
    utils.new_config(conf_path, default_conf_path)
    local conf = utils.get_configuration(conf_path)

    if conf.debug_mode then
        tests.prestart()
        tests.show_config(conf)
    end

    if utils.value_in_table("rebuild", arg) or
        utils.value_in_table("upgrade", arg) then
        rebuild.system(conf)
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
