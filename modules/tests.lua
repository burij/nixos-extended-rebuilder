local M = {}

M.prestart = function ()
print(
[[
debug mode is on.
................................................................................
]])
local core = need "lua-light-wings"
core.msg("lua-light-wings succefully loaded localy")
msg("llw-core succefully loaded globaly")
msg("lua documention: https://lua-docs.vercel.app")
local inspect = need "inspect"
print(
    inspect({
        "inspect succefully loaded via nix-pkgs"
    }))
msg("prestart finished...")
msg([[
................................................................................
]])
end

M.show_config = function (x)
    is_table(x)
    msg("content of the loaded configuration:")
    msg(x)
end

return M