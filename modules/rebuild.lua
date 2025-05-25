local M = {}

--------------------------------------------------------------------------------

function M.system(x)
    -- runs complete system rebuild/upgrade
    local path = is_path(x.entry_path) or "/etc/nixos/configuration.nix"
    local target_channels = is_list(x.channels)
    local flatpak_list = is_list(x.flatpaks)
    local channels = require "modules.channels"
    local utils = require "modules.utils"
    local flatpak = require "modules.flatpak"
    local dot_confs = is_table(x.dot)

    print "nixos extended rebuilder is cooking your config..."
    channels.sync(target_channels)

    M.nixos_rebuild(path)

    print "taking care of flatpaks..."
    flatpak.support()
    flatpak.install(flatpak_list)

    if utils.val_in_tbl("upgrade", arg) then
        os.execute("flatpak update -y")
    end

    M.dotfiles_sync(dot_confs)

    --TODO create a postroutine execution

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
function M.dotfiles_sync(x)
    -- interface for communication with dotfiles module
    local dot = require "modules.dotfiles"
    local utils = require "modules.utils"
    local lfs = require "lfs"
    local path = is_string(x.path)
    local files = is_dictionary(x.files)

    if utils.dir_exists(path) then
        print("Dotfiles repository is located in " .. path)
    else
        lfs.mkdir(path)
        print("New dotfiles repository created in " .. path)
    end

    dot.files_sync(path, files)

end


--------------------------------------------------------------------------------

return M
