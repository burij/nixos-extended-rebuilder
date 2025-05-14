M = {}
--------------------------------------------------------------------------------

function M.install(x)
    -- creates a script to install flatpaks you wish for
    utils = need "utils"
    is_table(x)    -- target list of flatpaks
    local get_flatpaks_cmd = "flatpak list --app --columns=application"
    local flatpak_output = utils.run_and_store(get_flatpaks_cmd, "")
    local function str_to_table(x)
        is_string(x)
        local tbl = {}
        for line in x:gmatch("[^%s]+") do
            table.insert(tbl, line)
        end
        return tbl
    end
    local existing_flatpaks = str_to_table(flatpak_output)
    local flatpak_div = utils.tbl_div(existing_flatpaks, x)
    local process_installs = map(flatpak_div.added, function(x)
        is_string(x)
        str = string.format("flatpak install --system flathub %s -y", x)
        return str
    end)
    local process_removes = map(flatpak_div.removed, function(x)
        is_string(x)
        str = string.format("flatpak uninstall %s -y", x)
        return str
    end)
    local result = utils.compose_list(process_installs, process_removes)
    map(result, os.execute)
    -- return is_table(result)
end

--------------------------------------------------------------------------------


function M.support()
    --adds flatpak support
    local utils = require "modules.utils"
    local flatpak_version = utils.run_and_store(
        "flatpak --version",
        "Flatpak was not found on this system."
    )
    print(flatpak_version)
    if string.find(flatpak_version, "not found") then
        print "Add 'services.flatpak.enable = true;' to your configuration.nix"
    else
        os.execute("flatpak remote-add --if-not-exists "
            .. "flathub https://flathub.org/repo/flathub.flatpakrepo"
        )
    end
end


--------------------------------------------------------------------------------
return M