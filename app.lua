dofile("env.lua")
local utils = require("modules.utils")

local function application()
    local conf = utils.get_configuration("./example-config.lua")
    msg("nixos extended rebuilder is cooking your config...")
    msg(conf)
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
application()
