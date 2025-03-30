local M = {}

function M.system(x)
-- runs complete system upgrade
    local path = is_path(x) or "/etc/nixos/configuration.nix"
    local utils = need "utils"
    print "nixos extended rebuilder is cooking your config..."
    -- TODO channels sync
    local flag = " "
    if utils.value_in_table("upgrade", arg) then
        local flag = "--upgrade"
        print "NixOS full upgrade..."
        else
        print "NixOS rebuild without upgrade..."
    end
    os.execute(
        "sudo nixos-rebuild switch " .. flag .. " -I nixos-config=" .. path
    )
    print "taking care of flatpaks..."
    --TODO add flatpak declarativ flatpak rebuilder
    if utils.value_in_table("upgrade", arg) then
        os.execute("flatpak update -y")
    end
    --TODO add dotfiles sync
    os.execute("nixos-rebuild list-generations | grep current")
end

return M