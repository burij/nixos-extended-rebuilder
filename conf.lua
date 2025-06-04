local conf = {
    dot = {}
}
--------------------------------------------------------------------------------
conf.debug_mode = true

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
        applications = {
            "$HOME/.local/share/applications",
            "$HOME/.config/mimeapps.list"
        },
        bash = { "$HOME/.bash_history" },
        blender = { "$HOME/.config/blender/4.2/config/userpref.blend" },
        brave = {
            "$HOME/.config/BraveSoftware/Brave-Browser/Default/Preferences",
            "$HOME/.config/BraveSoftware/Brave-Browser/Local State"
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
        thunderbird = {
            "$HOME/.thunderbird/profile.default/key4.db",
            "$HOME/.thunderbird/profile.default/logins.json",
            "$HOME/.thunderbird/profile.default/permissions.sqlite",
            "$HOME/.thunderbird/profile.default/prefs.js",
            "$HOME/.thunderbird/profile.default/xulstore.json"
        },
}


--------------------------------------------------------------------------------
return conf