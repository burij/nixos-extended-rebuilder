package.path = "./pkgs/share/lua/5.4/?.lua;" .. package.path
package.path = "./share/lua/5.4/?/init.lua;" .. package.path
package.cpath = "./pkgs/lib/lua/5.4/?.so;" .. package.cpath

local core = require "llw-core"
core.globalize(core)
local utils = require "modules.utils"
local conf = utils.get_configuration("./example-config.lua")
if conf.debug_mode then dofile("tests.lua") end
