M = {}
--------------------------------------------------------------------------------

function M.install(x, postroutine)
    -- creates a script to install flatpaks you wish for
    utils = need "utils"
    is_table(x)    -- target list of flatpaks
    is_string(postroutine)
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
    local process_installs = f.map(flatpak_div.added, function(x)
        is_string(x)
        str = string.format("flatpak install --system flathub %s -y", x)
        return str
    end)
    local process_removes = map(flatpak_div.removed, function(x)
        is_string(x)
        str = string.format("flatpak uninstall %s -y", x)
        return str
    end)
    local result = utils.compose_list(
        process_installs, process_removes, postroutine
    )
    return is_table(result)
end

--------------------------------------------------------------------------------
return M