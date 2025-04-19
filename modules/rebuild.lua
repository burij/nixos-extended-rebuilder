local M = {}

function M.system(x, y)
-- runs complete system upgrade
    local path = is_path(x) or "/etc/nixos/configuration.nix"
    local target_channels = is_list(y)
    local utils = need "utils"
    local channels = need "channels"
    print "nixos extended rebuilder is cooking your config..."
    channels.sync(target_channels)
    local flag = " "
    local data = {}
    data.flag = " "
    if utils.value_in_table("upgrade", arg) then
        data.flag = "--upgrade"
        print "NixOS full upgrade..."
        else
        print "NixOS rebuild without upgrade..."
    end
    os.execute(
        "sudo nixos-rebuild switch " .. data.flag .. " -I nixos-config=" .. path
    )
    print "taking care of flatpaks..."
    --TODO some system to check, if flathub is avaible and add if not
    --TODO add flatpak declarativ flatpak rebuilder
    if utils.value_in_table("upgrade", arg) then
        os.execute("flatpak update -y")
    end
    --TODO add dotfiles sync
    os.execute("nixos-rebuild list-generations | grep current")
end

return M