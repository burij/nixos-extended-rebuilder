local M = {}
--------------------------------------------------------------------------------

function M.reload_module(x)
    -- reloads modules during runtime
    M.types(x, "string")   -- module name
    package.loaded[x] = nil
    return require(x)
end

function M.get_configuration(x)
    is_path(x)
    local config_loader = loadfile(x)
    local output = config_loader()
    return is_dictionary(output)
end


function M.value_in_table(x, y)
-- returns true, if value x is present in table y
    is_string(x)
    is_dictionary(y)
    local output = false
    for _, value in pairs(y) do
        if value == x then
            output = true
        end
    end
    return is_boolean(output)
end


--------------------------------------------------------------------------------
return M