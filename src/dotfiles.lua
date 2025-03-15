local conf, f = require( "conf" ), require( "lib" )

--------------------------------------------------------------------------------

function application()
    local load_index = loadfile(conf.index_path)
    local index = load_index()

    local install_file_pkgs = f.new_files_packages(index.files)
    local link_files = f.link_files(index.files)
    local link_folders = f.link_folders(index.folders)

    local script = f.compose_list(
        link_folders,
        install_file_pkgs,
        link_files,
        index.commands)

    f.do_cmd_list(script)

end

--------------------------------------------------------------------------------

function f.escape_path(x)
    -- Helper function to properly escape paths with spaces
    f.types(x, "string") -- input path
    local str = '"' .. x:gsub('"', '\\"') .. '"'
    return str
end

---


function f.copy_content(x)
    -- move content of the folders, which do not exist, to dotfiles
    f.types( x, "table" )
    local tbl = {}
    for k, v in pairs(x) do
        local pkg = f.escape_path(conf.dotfiles_path .. k)
        local injection = "/home/" .. conf.user_name
        local absolute_target = f.inject_var(v, "$HOME", injection)
        if f.folder_exists(pkg) == false
        and f.folder_exists(absolute_target) == true then
            local a = "mkdir -p " .. pkg 
                .. " && cp -r " .. f.escape_path(v) .. "/* " .. pkg
            table.insert(tbl, a)
        end
    end
    return tbl
end

---

function f.create_targets(x)
    -- create empty folders and their parents, so links can be created
    f.types( x, "table" )
    local tbl = {}
    for k, v in pairs(x) do
        local pkg = f.escape_path(conf.dotfiles_path .. k)
        local injection = "/home/" .. conf.user_name
        local absolute_target = f.inject_var(v, "$HOME", injection)
        local parent = string.match(absolute_target, "(.*)/.*")
        if parent and not f.folder_exists(parent) then
            table.insert(tbl, "mkdir -p " .. f.escape_path(parent))
        end
        if f.folder_exists(pkg) and not f.folder_exists(absolute_target) then
            table.insert(tbl, "mkdir -p " .. f.escape_path(absolute_target))
        end
    end
    return tbl
end

---

function f.link_folder_pkgs(x)
    -- delete target if exists and link source to target
    f.types( x, "table" )
    tbl = {}
    for k, v in pairs(x) do
        local parent = string.match(v, "(.*)/.*")
        local a = "mkdir -p " .. f.escape_path(parent)
            .. " && rm -rf " .. f.escape_path(v)
            .. " && ln -sv "
            .. f.escape_path(conf.dotfiles_path .. k)
            .. " "
            .. f.escape_path(v)
        table.insert(tbl, a)
    end
    return tbl
end

---

function f.link_folders(x)
    -- returns all bash commands which do needs to be done with folders
    f.types( x, "table" )
    local copy_content = f.copy_content(x)
    local create_targets = f.create_targets(x)
    local linking = f.link_folder_pkgs(x)
    tbl = f.compose_list(copy_content, create_targets, linking)
    return tbl
end

---

function f.copy_files(x)
    -- creates list of commands to copy files to new folders
    f.types( x, "table" )
    local tbl = {}
    for k, v in pairs(x) do
        local target = f.escape_path(conf.dotfiles_path .. k)
        for k, v in pairs(v) do
            local source = f.escape_path(v)
            table.insert(tbl, "cp " .. source .. " " .. target .. "/")
        end
    end
    return tbl
end

----

function f.make_folders(x)
    -- creates a list of commands to make new folders
    f.types( x, "table" )
    local tbl = {}
    for k, v in pairs(x) do
        local make_folder = "mkdir -p "
            .. f.escape_path(conf.dotfiles_path .. k)
        table.insert(tbl, make_folder)
    end
    return tbl
end

---

function f.folder_exists(x)
-- checks for existence of a folder
    f.types( x, "string" ) --folder path
    -- Remove escaping for os.rename check
    local clean_path = string.gsub(x, "\\(.)", "%1")
    local success, _, code = os.rename(clean_path, clean_path)
    local bool = success or code == 13
    return bool
end

---

function f.filter_new_pkgs(x)
-- checks for existens of folders and returns filtered table
    f.types( x, "table" )
    local tbl = {}
    for k, v in pairs(x) do
        local path = conf.dotfiles_path .. k
        local exists = f.folder_exists(path)
        if exists == false then
            tbl[k] = v
        end
    end
    return tbl
end

---

function f.new_files_packages(x)
-- returns list of commands to create folders and copy files
    f.types( x, "table" )
    local tbl = {}
    local new_pkgs = f.filter_new_pkgs(x)
    local folder_creation = f.make_folders(new_pkgs)
    local copy_files = f.copy_files(new_pkgs)
    local tbl = f.compose_list(folder_creation, copy_files)
    return tbl
end

---

function f.link_files(x)
-- returns list of commands to symlink dotfiles
    f.types( x, "table" )
    local tbl = {}
    for k, v in pairs(x) do
        for _, v in ipairs(v) do
            local prefix = "ln -sfv " ..  f.escape_path(conf.dotfiles_path)
            local parent = string.match(v, "(.*)/.*")
            local make_parent = "mkdir -p " .. f.escape_path(parent)
            local file = string.match(v, ".*/(.*)")
            table.insert(tbl, make_parent)
            table.insert(
                tbl, prefix
                    .. k
                    .. "/"
                    .. f.escape_path(file)
                    .. " "
                    .. f.escape_path(v)
            )
        end
    end
    return tbl
end

--------------------------------------------------------------------------------
application()
