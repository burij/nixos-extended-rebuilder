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


--------------------------------------------------------------------------------
return M