local M = {}

--------------------------------------------------------------------------------
function M.sync(x)
    -- interface for communication with dotfiles module
    local conf = is_dictionary(x)

    print "syncing user configuration..."

    -- TODO sync single configuration files
    M.ensure_repository(conf.path)
    M.create_structure(conf.path, conf.files)
    -- M.backup_targets()
    -- M.create_symlinks()

    -- TODO sync configuration folders
    -- TODO backup gnome-shell settings
    -- TODO import gnome-shell settings

end
--------------------------------------------------------------------------------

function M.ensure_repository(x)
    local path = is_string(x)
    local utils = require "modules.utils"
    local lfs = require "lfs"

    if utils.dir_exists(path) then
        print("dotfiles repository is located in " .. path)
    else
        lfs.mkdir(path)
        print("new dotfiles repository created in " .. path)
    end
end

--------------------------------------------------------------------------------
function M.create_structure(x, y)
    local lfs = require "lfs"
    local utils = require "modules.utils"
    local path = is_string(x)
    local index = is_dictionary(y)

    local all_dirs = {}
    local seen = {}

    -- Add target directories (temp/key_name)
    local target_paths = {}
    for k, _ in pairs(index) do
        local target_dir = path .. "/" .. k
        target_paths = M.add_all_parents(target_dir, all_dirs, seen)
    end

    -- Add file parent directories
    local all_paths = target_paths
    for _, files in pairs(index) do
        for _, file_path in ipairs(files) do
            local parent_dir_decoded = string.match(file_path, "^(.+)/[^/]+$")
            if parent_dir_decoded then
                local parent_dir = M.encode_home(parent_dir_decoded)
                if parent_dir then
                    all_paths = M.add_all_parents(
                        parent_dir, target_paths, seen
                    )
                end
            end
        end
    end

    table.sort(all_paths, function(a, b)
        local depth_a = select(2, string.gsub(a, "/", ""))
        local depth_b = select(2, string.gsub(b, "/", ""))
        return depth_a < depth_b
    end)

    local missing_dirs = filter(all_paths, utils.dir_missing)
    if debug_mode then print "folders to create: " msg(missing_dirs) end
    map(missing_dirs, lfs.mkdir)
end
--------------------------------------------------------------------------------


function M.add_all_parents(x, y, z)
    local current = is_string(x)
    local all_dirs = is_table(y)
    local seen = is_table(z)
    local result = y
    while current and current ~= "/" and not seen[current] do
        table.insert(all_dirs, current)
        seen[current] = true
        current = string.match(current, "^(.+)/[^/]+$")
    end
    return is_table(result)
end

--------------------------------------------------------------------------------

function M.encode_home(path)
    local home = os.getenv("HOME")
    if home then
        return string.gsub(path, "^%$HOME", home)
    end
    return path
end

--------------------------------------------------------------------------------

function M.extract_fileindex(path, files)
    -- normalize table to 1:1 table --> belongs to create symlinks
    local repo = is_path(path)
    local input = is_dictionary(files)
    local result = {}

    for app_name, file_list in pairs(input) do
        for _, file_path in ipairs(file_list) do
            local filename = file_path:match("([^/]+)$") or file_path
            local key = repo .. "/" .. app_name .. "/" .. filename
            result[key] = file_path
        end
    end

    if debug_mode then msg(result) end
    return is_dictionary(result)
end

--------------------------------------------------------------------------------

function M.files_sync(path, files)
    --> belongs to create symlinks
    local root = is_path(path)
    local index = is_dictionary(files)
    local lfs = require "lfs"

    local index = M.extract_fileindex(root, index)

end

--------------------------------------------------------------------------------
return M