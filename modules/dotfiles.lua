local M = {}
--------------------------------------------------------------------------------

function M.extract_fileindex(x)
    -- TODO normalize table to 1:1 table
    local input = is_dictionary(x)
    local result = {}
    return is_dictionary(result)
end

--------------------------------------------------------------------------------

function M.files_sync(path, files)
    -- TODO routine for syncing of normal dotfiles
    local root = is_path(path)
    local index = is_dictionary(files)
    local lfs = require "lfs"

    local index = M.extract_fileindex(files)
    if debug_mode then msg(index) end

    -- TODO check if source and target do exist
    -- TODO if source doesn't exist but target, copy target to repo and symlink
    -- TODO if source exist, but not target, symlink
    -- TODO if both do not exist, do nothing
    -- TODO if both exist, check, if target is already symlink (what then?)
    -- TODO loop trough table
end

--------------------------------------------------------------------------------
return M