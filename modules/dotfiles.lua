local M = {}

--------------------------------------------------------------------------------
function M.sync(x)
    -- interface for communication with dotfiles module
    local conf = is_dictionary(x)

    print "syncing user configuration..."

    -- TODO sync single configuration files
    M.ensure_repository(conf.path)
    M.create_parents(conf)
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
function M.create_parents(x)
    local lfs = require "lfs"
    local utils = require "modules.utils"
    local path = "/home/burij/Desktop/2508_Nixos-Extended-Rebuilder/temp"
    local index = {
        single = {"$HOME/Downloads/single.md" },
        ["key with spaces"] = { "$HOME/Downloads/with space/single.md" },
        multiple = {
            "$HOME/Downloads/set/first file.md",
            "$HOME/Downloads/set/second file.md",
            "$HOME/Downloads/set/deeper/deep file.md",
            "$HOME/Downloads/set/test/file/without/extension",
        },
    }
    local parent_list = {}
    local seen = {}  -- To avoid duplicates
    for k, _ in pairs(index) do
        local target_dir = path .. "/" .. k
        if not seen[target_dir] then
            table.insert(parent_list, target_dir)
            seen[target_dir] = true
        end
    end
    for _, files in pairs(index) do
        for _, file_path in ipairs(files) do
            local parent_dir_decoded = string.match(file_path, "^(.+)/[^/]+$")
            local parent_dir = M.encode_home(parent_dir_decoded)
            if parent_dir and not seen[parent_dir] then
                table.insert(parent_list, parent_dir)
                seen[parent_dir] = true
            end
        end
    end
    local parents_of_parents = {}
    local seen_parents = {}
    for _, v in ipairs(parent_list) do
        local current_path = v
        while true do
            local parent = string.match(current_path, "^(.+)/[^/]+$")
            if not parent or seen_parents[parent] then
                break
            end
            table.insert(parents_of_parents, parent)
            seen_parents[parent] = true
            current_path = parent
        end
    end
    -- Combine parent_list and parents_of_parents, avoiding duplicates
    local all_dirs = {}
    local all_seen = {}

    -- Add all directories from parent_list
    for _, dir in ipairs(parent_list) do
        if not all_seen[dir] then
            table.insert(all_dirs, dir)
            all_seen[dir] = true
        end
    end

    -- Add all parent directories
    for _, dir in ipairs(parents_of_parents) do
        if not all_seen[dir] then
            table.insert(all_dirs, dir)
            all_seen[dir] = true
        end
    end

    local missing_dirs = filter(all_dirs, utils.dir_missing)

    -- Sort by path depth (shortest first) to ensure parents are created before children
    table.sort(missing_dirs, function(a, b)
        local depth_a = select(2, string.gsub(a, "/", ""))
        local depth_b = select(2, string.gsub(b, "/", ""))
        return depth_a < depth_b
    end)

    if debug_mode then print "folders to create: " msg(missing_dirs) end
    map(missing_dirs, lfs.mkdir)
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