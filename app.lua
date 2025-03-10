need = require "need"
local core = need "lua-light-wings" core.globalize(core)
local utils = need "utils"
local conf = utils.get_configuration("./example-config.lua")
if conf.debug_mode then dofile("tests.lua") end

--------------------------------------------------------------------------------

local function application()
    msg("nixos extended rebuilder is cooking your config...")
    if conf.debug_mode then
        msg("content of the loaded configuration:")
        msg(conf)
    end
end

--------------------------------------------------------------------------------
application()
