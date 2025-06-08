local M = {}

--------------------------------------------------------------------------------

function M.system(x)
    -- runs complete system rebuild/upgrade
    local path = is_path(x.entry_path or "/etc/nixos/configuration.nix")
    local target_channels = is_list(x.channels)
    local flatpak_list = is_list(x.flatpaks)
    local channels = require "modules.channels"
    local utils = require "modules.utils"
    local flatpak = require "modules.flatpak"
    local dotfiles = require "modules.dotfiles"
    local dot_confs = is_table(x.dot)
    local script = is_list(x.postroutine  or {})

    print "nixos extended rebuilder is cooking your config..."
    channels.sync(target_channels)

    M.nixos_rebuild(path)

    print "taking care of flatpaks..."
    flatpak.support()
    flatpak.install(flatpak_list)

    if utils.val_in_tbl("upgrade", arg) then
        os.execute("flatpak update -y")
    end

    dotfiles.sync(dot_confs)
    map(script, os.execute)

    os.execute("nixos-rebuild list-generations | grep current")
end

--------------------------------------------------------------------------------

function M.nixos_rebuild(x)
    local path = is_path(x)
    local utils = require "modules.utils"
    local data = {}
    data.flag = " "
    if utils.val_in_tbl("upgrade", arg) then
        data.flag = "--upgrade"
        print "NixOS full upgrade..."
    else
        print "NixOS rebuild without upgrade..."
    end
    os.execute(
        "sudo nixos-rebuild switch "
        .. data.flag
        .. " -I nixos-config="
        .. path
    )
end


--------------------------------------------------------------------------------

return M
