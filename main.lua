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
    _G.debug_mode = conf.debug_mode

    if debug_mode then
        tests.prestart()
        tests.show_config(conf)
    end

    if utils.val_in_tbl("rebuild", arg) or utils.val_in_tbl("upgrade", arg) then
        rebuild.system(conf)
    elseif utils.val_in_tbl("help", arg) then
        print(utils.format_markdown("README.md"))
        -- TODO make better help-output
    elseif utils.val_in_tbl("userconf", arg) then
        local dotfiles = require "modules.dotfiles"
        dotfiles.sync(conf.dot)
    else
        print "argument missing. please run 'os help' to learn more."
    end
end

--------------------------------------------------------------------------------
application()