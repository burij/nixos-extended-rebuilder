local core = require "modules.lua-light-wings" core.globalize(core)

local app = require "modules.application"
local conf = app.settings()
local defaults = require "conf"

conf.version = "NixOS extended rebuilder, Version 1.0"
conf.help = defaults.help or "Documentation missing"
conf.arguments = arg

_G.debug_mode = conf.debug_mode
if debug_mode then
    local tests = require "modules.tests"
    tests.prestart()
    tests.show_config(conf)
end

app.run(conf)
