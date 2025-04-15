local conf, f = require("conf"), require("lib")

conf.symlink_system = "ln -sfv " .. conf.root_path .. " /etc/nixos"
conf.back_up_path = "/etc/nixos/configuration." .. os.time()

--------------------------------------------------------------------------------

local function application()
    local menu = {}
    menu.title = conf.title
    menu.message = "Use arrow keys to navigate, 'enter' to select"
    menu.selected = 1
    menu.options = {}

    menu.options[1] = {
        text = "Update system",
        action = function()
            os.execute(conf.upgrade)
        end
    }

    menu.options[2] = {
        text = "Rebuild",
        action = function()
            conf = f.reload_module("conf")
            local add_channels = f.channels(conf.channels)
            local fp_installer = f.flatpak_script(
                conf.flatpak_list, conf.flatpak_postroutine
            )
            local folder_rm = f.extend_table(
                conf.dirs_to_remove, conf.drm_cmd, ""
            )
            local build_script = f.compose_list(
                f.skipcmd_tbl_if_false(add_channels, true),
                f.skipcmd_str_if_false(conf.rebuild_cmd, true),
                f.skipcmd_tbl_if_false(conf.flatpak_support, true),
                f.skipcmd_tbl_if_false(fp_installer, true),
                f.skipcmd_str_if_false(conf.symlink, true),
                f.skipcmd_tbl_if_false(folder_rm, true)
            )
            f.map(build_script, function(x)
                f.types(x, "string")
                os.execute(x)
            end)
        end
    }

    menu.options[3] = {
        text = "Relink dotfiles",
        action = function()
            dofile("dotfiles.lua")
        end
    }

    menu.options[4] = {
        text = "Export dotfiles",
        action = function()
            local load_index = loadfile(conf.index_path)
            local index = load_index()
            f.do_cmd(index.export)
        end
    }

    menu.options[5] = {
        text = "Server administration",
        action = function()
            dofile("server.lua")
        end
    }

    menu.options[6] = {
        text = "Nuke trash",
        action = function()
            f.do_cmd_list(conf.gc_collect)
        end
    }

    menu.options[7] = {
        text = "Setup new machine",
        action = f.setup_new
    }

    menu.options[8] = {
        text = "NixOS configuration",
        action = function()
            os.execute("nano " .. conf.root_path .. "config.nix")
        end
    }

    menu.options[9] = {
        text = "Settings",
        action = function()
            os.execute("nano ./conf.lua")
        end
    }

    menu.options[10] = {
        text = "All configurations",
        action = function()
            os.execute("flatpak run org.gnome.Builder -p " .. conf.root_path )
        end
    }

    menu.options[11] = {
        text = "Exit",
        action = function()
            os.exit()
        end
    }

    f.do_draw_menu(menu)
end
--------------------------------------------------------------------------------

function f.setup_new()
    -- returns script to setup an new machine
    local user = conf.user_name or f.read("Username:")
    local host = f.read("Host:")
    local path = conf.root_path or f.read("New configs path:")
    local get_v = "nix-instantiate --eval"
        .. " '<nixos/nixos>' -A config.system.stateVersion"
    local version = f.command_and_capture(get_v, f.read("NixOS version:"))
    local str = string.format(conf.template_new_machine, user, user, path)
    local default_path = "/etc/nixos/"
    local orig_conf = f.read_file(default_path .. "configuration.nix")
    local etcnixos = f.replace(conf.template_etcnixos, "$HOSTNAME", host)
    local orig_hard = f.read_file(default_path .. "hardware-configuration.nix")
    local host_conf_temp = f.replace(conf.template_host, "$HOSTNAME", host)
    local host_conf = f.replace(host_conf_temp, "$VERSION", version)
    local back_up_path = "/etc/nixos/configuration." .. os.time()
    f.do_cmd(str)
    f.do_write_file(back_up_path, orig_conf)
    f.do_write_file(default_path .. "configuration.nix", etcnixos)
    f.do_folder( path .. "hosts/" .. host .. "/" )
    f.do_write_file(path .. "hosts/" .. host .. "/config.nix", host_conf)
    f.do_write_file(path .. "hosts/" .. host .. "/hardware.nix", orig_hard)
end

---

function f.channels(x)
    f.types(x, "table")
    local tbl = {}
    local get_channels = f.command_and_capture(
        "sudo nix-channel --list",
        ""
    )
    local function str_to_table(x)
        f.types(x, "string")
        local tbl = {}
        for line in x:gmatch("[^\n]+") do
            table.insert(tbl, line)
        end
        return tbl
    end
    local current_channels = str_to_table(get_channels)
    local channels_div = f.tbl_div(current_channels, x)

    -- Process removes first
    local process_removes = f.map(channels_div.removed, function(x)
        f.types(x, "string")
        local name = x:match("(%S+)")
        return string.format("sudo nix-channel --remove %s", name)
    end)

    -- Then process installs with update after each add
    local process_installs = f.map(channels_div.added, function(x)
        f.types(x, "string")
        local name, url = x:match("(%S+)%s+(.*)")
        return string.format(
            "sudo nix-channel --add %s %s && sudo nix-channel --update",
            url,
            name
        )
    end)

    -- Combine commands, no need for final update since each install does it
    local tbl = f.compose_list(process_removes, process_installs)
    return tbl
end

---

function f.flatpak_script(x, y)
    -- creates a script to install flatpaks you wish for
    f.types(x, "table")    -- target list of flatpaks
    f.types(y, "string")   -- additional post routine
    local get_flatpaks_cmd = "flatpak list --app --columns=application"
    local flatpak_output = f.command_and_capture(get_flatpaks_cmd, "")
    local function str_to_table(x)
        f.types(x, "string")
        local tbl = {}
        for line in x:gmatch("[^%s]+") do
            table.insert(tbl, line)
        end
        return tbl
    end
    local existing_flatpaks = str_to_table(flatpak_output)
    local flatpak_div = f.tbl_div(existing_flatpaks, x)
    local process_installs = f.map(flatpak_div.added, function(x)
        f.types(x, "string")
        str = string.format("flatpak install --system flathub %s -y", x)
        return str
    end)
    local process_removes = f.map(flatpak_div.removed, function(x)
        f.types(x, "string")
        str = string.format("flatpak uninstall %s -y", x)
        return str
    end)
    local tbl = f.compose_list(process_installs, process_removes, y)
    return tbl
end

---

function f.do_link_to_home(x, y, z)
    f.types(x, "boolean")
    f.types(y, "string")
    f.types(z, "string")
    if x then
        f.do_cmd_list(conf.own_etcnixos)
        f.do_cmd(conf.symlink_system)
        f.do_write_file(conf.back_up_path, z)
        f.do_write_file("/etc/nixos/configuration.nix", y)
    end
end

---

function f.do_folder(x)
    f.types(x, "string")
    local current_user = os.getenv("USER")
    local check_cmd = "if [ -d "
        .. x
        .. " ]; then echo 'exists'; else echo 'not exists'; fi"
    local folder_status = f.do_cmd(check_cmd):gsub("%s+", "")
    if folder_status == "notexists" then
        local mkdir_cmd = "sudo mkdir -p " .. x
        f.do_cmd(mkdir_cmd)
    else
        print("Folder already exists: " .. x)
    end
    local chown_cmd = "sudo chown -R $USER:users " .. x
    f.do_cmd(chown_cmd)
end

---

function f.do_register_host(x, y, z)
    f.types(x, "boolean")
    f.types(y, "string")
    f.types(z, "string")
    if x then
        local hard_path = "/etc/nixos/hardware-configuration.nix"
        local orig_hard = f.do_get_file_content(hard_path)
        local host_folder = conf.root_path .. "hosts/" .. z .. "/"
        local conf_path = host_folder .. "config.nix"
        local hard_path = host_folder .. "hardware.nix"
        local host_conf = f.inject_var(conf.template_host, "$HOSTNAME", z)
        local cmd_get_version = "nix-instantiate --eval"
            .. " '<nixos/nixos>' -A config.system.stateVersion"
        local system_version = f.command_and_capture(cmd_get_version, "ERROR")
        print(system_version)
        local host_conf_with_version = f.inject_var(
            host_conf, "$VERSION", system_version
        )
        f.do_folder(host_folder)
        f.do_write_file(conf_path, host_conf_with_version)
        f.do_write_file(hard_path, orig_hard)
    end
end

--------------------------------------------------------------------------------
application()
