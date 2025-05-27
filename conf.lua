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

conf.dot.path = "/home/burij/Desktop/2508_Nixos-Extended-Rebuilder/temp"


conf.dot.files = {
        single = {"$HOME/Downloads/single.md" },
        ["key with spaces"] = { "$HOME/Downloads/with space/single.md" },
        multiple = {
            "$HOME/Downloads/set/first file.md",
            "$HOME/Downloads/set/second file.md",
            "$HOME/Downloads/set/deeper/deep file.md",
            "$HOME/Downloads/set/test/file/without/extension",
        },
    }


--------------------------------------------------------------------------------
return conf