local core = require "modules.lua-light-wings" core.globalize(core)

local app = require "modules.application"
local conf = app.settings()
local defaults = require "conf"

conf.version = "NixOS extended rebuilder, Version 1.1-dev"
-- better way to handle flags
-- 'os edit': new command to open configuration with custom editor
-- conf.editor: non mandatory option to define custom editor
-- updated README

conf.help = defaults.help or "Documentation missing"
conf.arguments = arg

_G.debug_mode = conf.debug_mode
if debug_mode then
    local tests = require "modules.tests"
    tests.prestart()
    tests.show_config(conf)
end

app.run(conf)
