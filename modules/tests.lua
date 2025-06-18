local M = {} _G.need = require "need"
--------------------------------------------------------------------------------

function M.prestart()
    print "debug mode is on"
    M.dotted_line()
    local core = require "modules.lua-light-wings" core.globalize(core)
    msg "light wings loaded..."
    msg "prestart finished..."
    M.dotted_line()
end

--------------------------------------------------------------------------------

function M.show_config(x)
    is_table(x)
    msg("content of the loaded configuration:")
    msg(x)
    M.dotted_line()
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