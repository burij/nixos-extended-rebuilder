local M = {}
-- TODO try to make this file a module


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

return M