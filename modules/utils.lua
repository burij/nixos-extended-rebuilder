local M = {}
--------------------------------------------------------------------------------

function M.reload_module(x)
-- reloads modules during runtime
    M.types(x, "string")   -- module name
    package.loaded[x] = nil
    return require(x)
end

--------------------------------------------------------------------------------

function M.get_configuration(x)
    is_path(x)
    local config_loader = loadfile(x)
    local output = config_loader()
    return is_dictionary(output)
end

--------------------------------------------------------------------------------

function M.val_in_tbl(x, y)
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

--------------------------------------------------------------------------------

function M.run_and_store(cmd, default)
-- function, which runs a terminal command and returns the output as variable
    is_string(cmd)
    is_string(default)
    local handle = io.popen(cmd)
    local result = ""
    if handle then
        result = handle:read("*a")
        handle:close()
    end
    if result == "" then
        result = default
    end
    output = string.gsub(result, "\n$", "")
    return is_string(output)
end

--------------------------------------------------------------------------------

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

function M.new_config(path, default_path)
-- creating new config if it does not exist
    is_string(path)
    is_string(default_path)
    local file = io.open(path, "r")
    if file then
        io.close(file)
    else
        local content = M.read_file("conf")
        os.execute("touch " .. default_path)
        M.write_file(default_path, content)
        print("configuration template created. path: " .. default_path)
        print "modify, execute:"
        print('export LUAOS="' .. default_path .. '"')
        print "and run again"
        os.exit()
    end
end

--------------------------------------------------------------------------------

function M.read_file(file)
    local x = is_string(file)
    local filepath = package.searchpath(x, package.path)

    if not filepath then
        filepath = x
    end

    local file = io.open(filepath, "r")
    if file then
        local content = file:read("*all")
        file:close()
        return is_string(content)
    else
        return filepath .. " not readable!"
    end
end

--------------------------------------------------------------------------------

function M.write_file(filename, content)
    x = is_string(filename)
    y = is_string(content)
    local file = io.open(x, "w")
    if file then
        file:write(y)
        file:close()
    else
        error("Unable to open file for writing: " .. x)
    end
end

--------------------------------------------------------------------------------

function M.real_file(x)
-- check, if file exist and is not a symlink
    local file = is_string(x)
    local lfs = require "lfs"
    local result = false
    local attributes = lfs.attributes(file)
    local symlink = lfs.symlinkattributes(file)
    if attributes and symlink.target==nil then result = true end
    return result
end

--------------------------------------------------------------------------------

function M.real_folder(x)
-- check, if folder exist and is not a symlink
    local folder = is_string(x)
    local lfs = require "lfs"
    local result = false
    local attributes = lfs.attributes(folder)
    local symlink = lfs.symlinkattributes(folder)
    if attributes.mode == "directory" and symlink.target==nil then
        result = true
    end
    return result
end

--------------------------------------------------------------------------------

function M.dir_exists(x)
    local path = is_string(x)
    local lfs = require "lfs"
    local attr = lfs.attributes(path)

    if debug_mode then print("check if exists: " .. path) end
    if debug_mode then msg(attr and attr.mode == "directory") end

    return attr and attr.mode == "directory"
end

--------------------------------------------------------------------------------
function M.dir_missing(x)
    local path = is_string(x)
    local lfs = require "lfs"
    local attr = lfs.attributes(path)
    local flag = false
    if attr == nil then flag = true end

    if debug_mode then print("check if missing: " .. path) end
    if debug_mode then msg(flag) end

    return is_boolean(flag)
end

--------------------------------------------------------------------------------

function M.print_file_formatted(x)
    local filename = is_string(x)
    local file = io.open(filename, "r")
    if file then
        io.input(file)
        local content = io.read("*all")
        io.close(file)

        -- Print with word wrapping at 80 characters
        local pos = 1
        while pos <= string.len(content) do
            local line_end = pos + 79
            if line_end > string.len(content) then
                print(string.sub(content, pos))
                break
            end

            -- Find last space before 80 chars to avoid breaking words
            local search_start = math.max(pos, line_end - 20)
            local last_space = nil

            for i = line_end, search_start, -1 do
                if string.sub(content, i, i) == " " then
                    last_space = i
                    break
                end
            end

            if last_space and last_space > pos then
                line_end = last_space
            end

            print(string.sub(content, pos, line_end))
            pos = line_end + 1
        end
    else
        print("Could not open file: " .. filename)
    end
end

--------------------------------------------------------------------------------

function M.format_markdown(filename)
    local file = io.open(filename, "r")
    if not file then
        print("Could not open file: " .. filename)
        return
    end

    io.input(file)
    local content = io.read("*all")
    io.close(file)

    content = string.gsub(content, "^%s*#+%s*(.-)%s*$", "%1")
    content = string.gsub(content, "\n%s*#+%s*(.-)%s*", "\n%1")

    content = string.gsub(content, "```.-```", function(match)
        local code = string.gsub(match, "```[^\n]*\n?", "")
        code = string.gsub(code, "\n```", "")
        -- Indent each line with 4 spaces
        code = string.gsub(code, "([^\n]+)", "    %1")
        return "\n" .. code .. "\n"
    end)

    content = string.gsub(content, "`([^`]+)`", "[%1]")
    content = string.gsub(content, "%*%*(.-)%*%*", "%1")
    content = string.gsub(content, "%*(.-)%*", "%1")
    content = string.gsub(content, "%[(.-)%]%((.-)%)", "%1 (%2)")
    content = string.gsub(content, "^%s*[-*+] ", "• ")

    local function wrap_text(text)
        local result = {}
        local pos = 1

        while pos <= string.len(text) do
            local line_end = pos + 79
            if line_end >= string.len(text) then
                table.insert(result, string.sub(text, pos))
                break
            end

            local last_space = nil
            local search_start = math.max(pos, line_end - 20)

            for i = line_end, search_start, -1 do
                if string.sub(text, i, i) == " " then
                    last_space = i
                    break
                end
            end

            if last_space and last_space > pos then
                line_end = last_space - 1  -- Don't include the space
                table.insert(result, string.sub(text, pos, line_end))
                pos = last_space + 1  -- Skip the space
            else
                table.insert(result, string.sub(text, pos, line_end))
                pos = line_end + 1
            end
        end

        return table.concat(result, "\n")
    end

    local paragraphs = {}
    for paragraph in string.gmatch(content, "[^\n\n]+") do
        if string.match(paragraph, "^%s*$") then
            table.insert(paragraphs, "")
        else
            table.insert(paragraphs, wrap_text(paragraph))
        end
    end

    local result = table.concat(paragraphs, "\n\n")
    return is_string(result)
end

--------------------------------------------------------------------------------
return M