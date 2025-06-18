local core = require "modules.lua-light-wings" core.globalize(core)

local defaultconf = require "conf"
local default_conf_path = os.getenv("HOME") .. "/.nixconf.lua"
local conf_path = os.getenv("LUAOS") or default_conf_path
local utils = require "modules.utils"
utils.new_config(conf_path, default_conf_path)
local conf = utils.get_configuration(conf_path)
_G.debug_mode = conf.debug_mode

if debug_mode then
    local tests = require "modules.tests"
    tests.prestart()
    tests.show_config(conf)
end

conf.version = "NixOS extended rebuilder, Version 0.9.2-dev"
conf.help = defaultconf.help or "Documentation missing"
conf.arguments = arg

local app = require "modules.application"
app.run(conf)
