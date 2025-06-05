local conf = { dot = {} }

--------------------------------------------------------------------------------
conf.debug_mode = false

conf.entry_path = "/etc/nixos/configuration.nix"

conf.channels = {
    "nixos https://nixos.org/channels/nixos-unstable"
}

conf.flatpaks = {
    "page.codeberg.libre_menu_editor.LibreMenuEditor",
    "org.gnome.Builder",
    "io.beekeeperstudio.Studio",
    "com.mattjakeman.ExtensionManager",
    "org.onlyoffice.desktopeditors",
    "com.github.jeromerobert.pdfarranger",
    "org.gustavoperedo.FontDownloader",
    "com.nextcloud.desktopclient.nextcloud",
    "net.natesales.Aviator",
    "org.jdownloader.JDownloader",
    "de.schmidhuberj.DieBahn",
    "com.github.xournalpp.xournalpp",
    "com.github.unrud.VideoDownloader",
    "br.com.wiselabs.simplexity",
    "com.github.maoschanz.drawing",
    "app.drey.EarTag",
}

conf.dot.path = "/home/burij/System/dotfiles"

conf.dot.files = {
    bash = { "$HOME/.bash_history" },
    blender = { "$HOME/.config/blender/4.2/config/userpref.blend" },
    brave = {
        "$HOME/.config/BraveSoftware/Brave-Browser/Default/Preferences",
        "$HOME/.config/BraveSoftware/Brave-Browser/Local State"
    },
    builder = {
	    "$HOME/.var/app/org.gnome.Builder/config/glib-2.0/settings/keyfile",
	    "$HOME/.var/app/org.gnome.Builder/config/gnome-builder/keybindings.json"
    },
    cursor = {
        "$HOME/.config/Cursor/User/keybindings.json"
    },
    darktable = {
        "$HOME/.config/darktable/lua",
        "$HOME/.config/darktable/styles",
        "$HOME/.config/darktable/data.db",
        "$HOME/.config/darktable/library.db",
        "$HOME/.config/darktable/shortcutsrc",
        "$HOME/.config/darktable/user.css",
    },
    desktop = {
        "$HOME/.local/share/applications",
        "$HOME/.config/mimeapps.list",
        "$HOME/.local/share/icons",
        "$HOME/.config/user-dirs.dirs",
        "$HOME/.config/user-dirs.locale",
        "$HOME/.config/gtk-3.0/bookmarks",
        "$HOME/.config/gtk-3.0/settings.ini",
        "$HOME/.config/gtk-4.0/servers",
        "$HOME/.config/gtk-4.0/settings.ini"
    },
    flatpak = {
        "$HOME/.local/share/flatpak/db",
        "$HOME/.local/share/flatpak/overrides",
        "$HOME/.local/share/flatpak/repo",
    },
    ghostwriter = { "$HOME/.config/kde.org/ghostwriter.conf" },
    git = { "$HOME/.gitconfig" },
    gitnuro = {
        "$HOME/.config/gitnuro/.java/.userPrefs/GitnuroConfig/prefs.xml"
    },
    grsync = { "$HOME/.config/grsync/grsync.ini"},
    krenamer = { "$HOME/.config/krenamerc" },
    masterpdf = {
        "$HOME/.config/Code Industry/Master PDF Editor 5.conf"
    },
    nextcloud = {
        "$HOME/.var/app/com.nextcloud.desktopclient.nextcloud/"
            .. "config/Nextcloud/cookies0.db",
        "$HOME/.var/app/com.nextcloud.desktopclient.nextcloud/"
            .. "config/Nextcloud/nextcloud.cfg",
        "$HOME/.var/app/com.nextcloud.desktopclient.nextcloud/"
            .."config/Nextcloud/sync-exclude.lst"
    },
    obsidian = {
        "$HOME/.config/obsidian/Preferences",
        "$HOME/.config/obsidian/obsidian.json",
        "/data/burij/.obsidian",
        "$HOME/.config/obsidian/Dictionaries/de-DE-3-0.bdic",
        "$HOME/.config/obsidian/Dictionaries/en-US-10-1.bdic"
    },
    ocenaudio = {
        "$HOME/.local/share/ocenaudio/ocenaudio.settings"
    },
    ptyxis = {
        "$HOME/.config/org.gnome.Ptyxis/session.gvariant"
    },
    reaper= {
        "$HOME/.config/REAPER/ColorThemes",
        "$HOME/.config/REAPER/Data",
        "$HOME/.config/REAPER/Effects",
        "$HOME/.config/REAPER/KeyMaps",
        "$HOME/.config/REAPER/presets",
        "$HOME/.config/REAPER/ProjectTemplates",
        "$HOME/.config/REAPER/ReaPack",
        "$HOME/.config/REAPER/Scripts",
        "$HOME/.config/REAPER/UserPlugins",
        "$HOME/.config/REAPER/reapack.ini",
        "$HOME/.config/REAPER/reaper.ini",
        "$HOME/.config/REAPER/reaper-vstplugins64.ini",
        "$HOME/.config/REAPER/reaper-themeconfig.ini",
    },
    tenacity = {
        "$HOME/.config/tenacity/tenacity.cfg",
        "$HOME/.config/tenacity/pluginsettings.cfg",
        "$HOME/.config/tenacity/Theme/ImageCache.htm",
        "$HOME/.config/tenacity/Theme/ImageCache.png"
    },
    thunderbird = {
        "$HOME/.thunderbird/profile.default/key4.db",
        "$HOME/.thunderbird/profile.default/logins.json",
        "$HOME/.thunderbird/profile.default/permissions.sqlite",
        "$HOME/.thunderbird/profile.default/prefs.js",
        "$HOME/.thunderbird/profile.default/xulstore.json"
    },
    vital = {
        "$HOME/.local/share/vital/User/Wavetables"
    },
    vst = {
        "$HOME/.vst"
    }
}


--------------------------------------------------------------------------------
return conf