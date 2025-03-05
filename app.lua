dofile "env.lua"
local utils = require "modules.utils"

local function application()
    local conf = utils.get_configuration("./example-config.lua")
    msg("nixos extended rebuilder is cooking your config...")
    if conf.debug_mode then
        msg("content of the loaded configuration:")
        msg(conf)
    end
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
application()
