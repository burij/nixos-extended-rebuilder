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

function M.compose_list(...)
    -- glues strings and tables to a new table
    local tbl = {}
    for _, v in ipairs({ ... }) do
        if type(v) == "string" then
            table.insert(tbl, v)
        elseif type(v) == "table" then
            for _, str in ipairs(v) do
                if type(str) ~= "string" then
                    error("incorrect table format detected")
                end
                table.insert(tbl, str)
            end
        else
            error("all arguments must be either strings or tables")
        end
    end
    return is_table(tbl)
end

function M.command_and_capture(x, y)
    is_string(x) -- command, which will be executed
    is_string(y) -- value, which be returned, if there is no output
    local handle = io.popen(x)
    local str = ""
    if handle then
        str = handle:read("*a")
        handle:close()
    end
    if str == "" then
        str = y
    end
    str = string.gsub(str, "\n$", "")
    return str
end


function M.tbl_div(x, y)
    -- Creates a div table between 2 lists
    is_table(x)   -- original table
    is_table(y)  -- new table
    local tbl = { added = {}, removed = {} }
    -- Helper function for deep comparison
    local function deep_equals(a, b)
        if type(a) ~= type(b) then return false end
        if type(a) ~= "table" then return a == b end
        -- Check if tables have same length
        if #a ~= #b then return false end
        -- For array-like tables, compare by index
        for i = 1, #a do
            if not deep_equals(a[i], b[i]) then return false end
        end
        return true
    end
    -- Find added elements (in y but not in x)
    for i = 1, #y do
        local value = y[i]
        local found = false
        for j = 1, #x do
            local orig_value = x[j]
            if deep_equals(value, orig_value) then
                found = true
                break
            end
        end
        if not found then
            table.insert(tbl.added, value)
        end
    end
    -- Find removed elements (in x but not in y)
    for i = 1, #x do
        local value = x[i]
        if value ~= nil then -- Skip nil values
            local found = false
            for j = 1, #y do
                local new_value = y[j]
                if deep_equals(value, new_value) then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(tbl.removed, value)
            end
        end
    end
    return is_table(tbl)
end


--------------------------------------------------------------------------------
return M