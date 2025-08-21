local M = {}

--------------------------------------------------------------------------------

function M.run(options)
    local x = is_dictionary(options)
    local conf = is_dictionary(options)
    local version = is_string(x.version)
    local utils = require "modules.utils"
    local flag = utils.map_arguments(conf.arguments)
    local cleanup = is_list(x.cleanup)

    if flag.find("help") then
        print(version)
        print(conf.help or "Documentation missing")
        os.exit()
    elseif flag.find("version") then
        print(version)
        print "NixOS state:"
        os.execute("nixos-rebuild list-generations | grep current")
        os.execute(
            "nixos-rebuild list-generations | " ..
            "grep 'True' | awk '{print $1, $2, $3, $4, $5}'"
        )
        os.exit()
    end

    if flag.find("rebuild", "upgrade") then
        local rebuild = require "modules.rebuild"
        rebuild.system(conf)
    elseif flag.find("userconf") then
        local dotfiles = require "modules.dotfiles"
        dotfiles.sync(conf.dot)
    elseif flag.find("cleanup") then
        print "Collecting garbage..."
        if debug_mode then map(cleanup, print) end
        map(cleanup, os.execute)
    else
        print "argument missing. please run 'os help' to learn more."
    end

end

--------------------------------------------------------------------------------

function M.settings()
    local default_conf_path = os.getenv("HOME") .. "/.nixconf.lua"
    local conf_path = os.getenv("LUAOS") or default_conf_path
    local utils = require "modules.utils"
    utils.new_config(conf_path, default_conf_path)
    local result = utils.get_configuration(conf_path)
    return is_dictionary(result)
end

--------------------------------------------------------------------------------

return M