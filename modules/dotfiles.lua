local M = {}
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

    if debug_mode then msg(result) end
    return is_dictionary(result)
end

--------------------------------------------------------------------------------

function M.files_sync(path, files)
    -- TODO routine for syncing of normal dotfiles
    local root = is_path(path)
    local index = is_dictionary(files)
    local lfs = require "lfs"

    local index = M.extract_fileindex(root, index)

    -- TODO check if source and target do exist
    -- TODO if source doesn't exist but target, copy target to repo and symlink
    -- TODO if source exist, but not target, symlink
    -- TODO if both do not exist, do nothing
    -- TODO if both exist, check, if target is already symlink (what then?)
    -- TODO loop trough table
end

--------------------------------------------------------------------------------
return M