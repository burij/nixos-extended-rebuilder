local M = {}

M.prestart = function ()
print(
[[
debug mode is on.
................................................................................
]])


M.repeat_string()

local M = {} _G.need = require "need"
local core = require "modules.lua-light-wings" core.globalize(core)
msg "light wings loaded..."
msg "prestart finished..."
msg([[
................................................................................
]])
end

--------------------------------------------------------------------------------

M.show_config = function (x)
    is_table(x)
    msg("content of the loaded configuration:")
    msg(x)
end

--------------------------------------------------------------------------------

function M.repeat_string()
    local x = ""
    local y = "."
    for i = 1, 80 do
        x = x .. y
    end
    print(x)
end

--------------------------------------------------------------------------------

return M