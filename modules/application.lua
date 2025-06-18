local M = {}

function M.run(options)
    local x = is_dictionary(options)
    local version = is_string(options.version)
    local utils = require "modules.utils"
    local tests = require "modules.tests"


    if utils.val_in_tbl("help", arg) then
        local defaultconf = x
        print(version)
        print(defaultconf.help or "Documentation missing")
        os.exit()
    elseif utils.val_in_tbl("version", arg) then
        print(version)
        print "NixOS state:"
        os.execute("nixos-rebuild list-generations | grep current")
        os.execute(
            "nixos-rebuild list-generations | " ..
            "grep 'True' | awk '{print $1, $2, $3, $4, $5}'"
        )
        os.exit()
    end

    local default_conf_path = os.getenv("HOME") .. "/.nixconf.lua"
    local conf_path = os.getenv("LUAOS") or default_conf_path
    utils.new_config(conf_path, default_conf_path)
    local conf = utils.get_configuration(conf_path)
    _G.debug_mode = conf.debug_mode

    if debug_mode then
        tests.prestart()
        tests.show_config(conf)
    end

    if utils.val_in_tbl("rebuild", arg) or utils.val_in_tbl("upgrade", arg) then
        local rebuild = require "modules.rebuild"
        rebuild.system(conf)
    elseif utils.val_in_tbl("userconf", arg) then
        local dotfiles = require "modules.dotfiles"
        dotfiles.sync(conf.dot)
    elseif utils.val_in_tbl("cleanup", arg) then
        msg "TODO create garbage collecting routine"
    else
        print "argument missing. please run 'os help' to learn more."
    end

end

return M