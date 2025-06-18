local core = require "modules.lua-light-wings" core.globalize(core)
local conf = require "conf"

conf.version = "NixOS extended rebuilder, Version 0.9.2-dev"

local app = require "modules.application"
app.run(conf)
