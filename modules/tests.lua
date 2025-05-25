local M = {}

M.prestart = function ()
print "debug mode is on"
M.dotted_line()
local M = {} _G.need = require "need"
local core = require "modules.lua-light-wings" core.globalize(core)
msg "light wings loaded..."
msg "prestart finished..."
M.dotted_line()
end

--------------------------------------------------------------------------------

M.show_config = function (x)
    is_table(x)
    msg("content of the loaded configuration:")
    msg(x)
end

--------------------------------------------------------------------------------

function M.dotted_line()
    local x = ""
    local y = "."
    for i = 1, 80 do
        x = x .. y
    end
    print(x)
end

--------------------------------------------------------------------------------

return M