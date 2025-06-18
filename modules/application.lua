local M = {}

--------------------------------------------------------------------------------

function M.run(options)
    local x = is_dictionary(options)
    local version = is_string(options.version)
    local utils = require "modules.utils"
    local conf = is_dictionary(options)
    local flag = is_table(options.arguments)

    if utils.val_in_tbl("help", flag) then
        print(version)
        print(conf.help or "Documentation missing")
        os.exit()
    elseif utils.val_in_tbl("version", flag) then
        print(version)
        print "NixOS state:"
        os.execute("nixos-rebuild list-generations | grep current")
        os.execute(
            "nixos-rebuild list-generations | " ..
            "grep 'True' | awk '{print $1, $2, $3, $4, $5}'"
        )
        os.exit()
    end

    if utils.val_in_tbl("rebuild", flag)
    or utils.val_in_tbl("upgrade", flag) then
        local rebuild = require "modules.rebuild"
        rebuild.system(conf)
    elseif utils.val_in_tbl("userconf", flag) then
        local dotfiles = require "modules.dotfiles"
        dotfiles.sync(conf.dot)
    elseif utils.val_in_tbl("cleanup", flag) then
        msg "TODO create garbage collecting routine"
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
    local conf = utils.get_configuration(conf_path)
    return conf
end

--------------------------------------------------------------------------------

return M