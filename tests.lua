print(
[[

debug mode is on.
to run in production mode comment out or remove dofile("tests.lua") from main]]
)
--------------------------------------------------------------------------------
package.path = "./pkgs/share/lua/5.4/?.lua;" .. package.path
package.path = "./share/lua/5.4/?/init.lua;" .. package.path
package.cpath = "./pkgs/lib/lua/5.4/?.so;" .. package.cpath
core = require( "llw-core" )
core.msg("llw-core succefully loaded localy")
msg("llw-core succefully loaded globaly")
msg("lua documention: https://lua-docs.vercel.app")
local inspect = require("inspect")
print(
    inspect({
        "inspect succefully loaded via nix-pkgs"
    })
)
