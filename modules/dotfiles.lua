local M = {}

--------------------------------------------------------------------------------
function M.sync(x)
    -- interface for communication with dotfiles module
    local conf = is_dictionary(x)

    print "syncing user configuration..."

    M.ensure_repository(conf.path)
    M.create_structure(conf.path, conf.files)
    M.backup_targets(conf.path, conf.files)
    M.create_symlinks(conf.path, conf.files)

    -- TODO sync configuration folders
    -- TODO backup gnome-shell settings
    -- TODO import gnome-shell settings

end

--------------------------------------------------------------------------------

function M.create_symlinks(x, y)
    local lfs = require "lfs"
    local path = is_string(x)
    local index = is_dictionary(y)

    local index_encoded = map(
        M.extract_fileindex(path, index), M.encode_home
    )
    for key, value in pairs(index_encoded) do
        local attributes = lfs.attributes(key)
        local symlink = lfs.attributes(value)
        if attributes and not symlink then
            local link_cmd = string.format('ln -sf "%s" "%s"', key, value)
            os.execute(link_cmd)
            print(link_cmd)
        end
    end

end

--------------------------------------------------------------------------------
function M.backup_targets(x, y)
    local lfs = require "lfs"
    local utils = require "modules.utils"
    local path = is_string(x)
    local index = is_dictionary(y)

    local index_encoded = map(
        M.extract_fileindex(path, index), M.encode_home
    )

    local index_filtered = filter(index_encoded, utils.real_file)
    -- TODO index_filtered doesn't include folders

    print "configs to back up: "

    for key, value in pairs(index_filtered) do
        local attributes = lfs.attributes(key)
        if attributes then
            os.rename(key, key .. "." .. attributes.modification)
        end
        local move_cmd = string.format('mv "%s" "%s"', value, key)
        os.execute(move_cmd)
        print(move_cmd)
    end
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

    local target_paths = {}
    -- TODO target_paths = filter(index, utils.real_folder)

    do
        print "TODO write test for utils.real_folder with single path"
        local test = require "modules.utils"
        msg(index["one folder"][1])
        local folder_path = M.encode_home(index["one folder"][1])
        msg(folder_path)
        local folder_exists = test.real_file(folder_path)
        msg(folder_exists)
        print "||||||||||||| end of the test"
    end

    for k, _ in pairs(index) do
        local target_dir = path .. "/" .. k
        target_paths = M.add_all_parents(target_dir, all_dirs, seen)
    end

    local all_paths = target_paths
    for _, files in pairs(index) do
          map(files, function(file_path)
            local parent_dir_decoded = string.match(file_path, "^(.+)/[^/]+$")
            if parent_dir_decoded then
                local parent_dir = M.encode_home(parent_dir_decoded)
                if parent_dir then
                    all_paths = M.add_all_parents(
                            parent_dir, target_paths, seen
                        )
                end
            end
        end)
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
    -- normalize table to 1:1 table
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

    if debug_mode then print "encoded index: " msg(result) end
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