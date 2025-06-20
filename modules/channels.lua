local M = {}


function M.sync(x)
    local target_channels = is_table(x)
    local utils = require "modules.utils"
    local get_channels = utils.run_and_store(
        "sudo nix-channel --list",
        ""
    )
    local function str_to_table(x)
        is_string(x)
        local result = {}
        for line in x:gmatch("[^\n]+") do
            table.insert(result, line)
        end
        return is_table(result)
    end
    local current_channels = str_to_table(get_channels)
    if debug_mode then print "current channels: " end
    if debug_mode then msg(current_channels) end
    local channels_div = utils.tbl_div(current_channels, target_channels)

    -- Process removes first
    local process_removes = map(channels_div.removed, function(x)
        is_string(x)
        local name = x:match("(%S+)")
        return string.format("sudo nix-channel --remove %s", name)
    end)

    -- Then process installs with update after each add
    local process_installs = map(channels_div.added, function(x)
        is_string(x)
        local name, url = x:match("(%S+)%s+(.*)")
        return string.format(
            "sudo nix-channel --add %s %s && sudo nix-channel --update",
            url,
            name
        )
    end)

    -- Combine commands, no need for final update since each install does it
    local result = utils.compose_list(process_removes, process_installs)
    if debug_mode then msg(result) end
    map(result, os.execute)
    return is_table(result)
end

return M