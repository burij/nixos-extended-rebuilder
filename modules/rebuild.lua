local M = {}

--------------------------------------------------------------------------------

function M.system(x)
    -- runs complete system upgrade
    local path = is_path(x.entry_path) or "/etc/nixos/configuration.nix"
    local target_channels = is_list(x.channels)
    local channels = require "modules.channels"
    local utils = require "modules.utils"

    print "nixos extended rebuilder is cooking your config..."
    channels.sync(target_channels)

    M.nixos_rebuild(path)

    print "taking care of flatpaks..."
    --TODO some system to check, if flathub is avaible and add if not
    --TODO add flatpak declarativ flatpak rebuilder
    if utils.val_in_tbl("upgrade", arg) then
        os.execute("flatpak update -y")
    end

    --TODO add dotfiles sync

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
