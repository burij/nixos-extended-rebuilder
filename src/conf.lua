conf = {}
--------------------------------------------------------------------------------
conf.title = "NixOS setup & management tool\n"
conf.host = "nixos" -- hostname: change on new machine
conf.user_name = os.getenv("USER")
conf.root_path = "/data/" .. conf.user_name .. "/System/"
conf.dotfiles_path =  conf.root_path .. "dotfiles/"
conf.index_path = conf.dotfiles_path .. "index.lua"

conf.channels = {
    "nixos https://nixos.org/channels/nixos-unstable"
}

conf.dirs_to_remove = {
    "Downloads",
    "Musik",
    "Dokumente",
    "Bilder",
    "Öffentlich",
    "Videos",
    "Screenshots",
    "Bildschirmfotos",
    "Camera",
    "iZotope",
    "Schreibtisch"
}

conf.flatpak_list = {
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

conf.flatpak_postroutine = [[
flatpak run --command=gsettings com.github.unrud.VideoDownloader set \
com.github.unrud.VideoDownloader download-folder '~/Virtuelles USB/Vinylcase';
flatpak override --user --filesystem='~/Virtuelles USB/Vinylcase:create' \
com.github.unrud.VideoDownloader;
sudo flatpak override --filesystem=host org.gnome.Builder
]]

conf.upgrade = [[
echo "NixOS update..."
sudo nixos-rebuild switch --upgrade
nixos-rebuild list-generations | grep current
flatpak update -y
notify-send -e "NixOS upgrade finished" --icon=software-update-available
]]

conf.gc_collect = {
    "flatpak uninstall --unused",
    "nix-collect-garbage",
    "sudo nix-collect-garbage",
    "nix-collect-garbage -d",
    "sudo nix-collect-garbage -d",
}

conf.rebuild_cmd = "sudo nixos-rebuild switch"

conf.flatpak_support =  { "flatpak remote-add --if-not-exists "
    .. "flathub https://flathub.org/repo/flathub.flatpakrepo",
    "flatpak update -y" }

conf.drm_cmd = "rm -r $HOME/"

conf.symlink = "lua " .. conf.root_path .. "setup/dotfiles.lua"

conf.srv = {
    title    = "Server Administration\n",
    path     = "/srv/config",
    config   = "/srv/config/docker-compose.yml",
    bu_path  = "/srv/backups",
    vol_path = "/srv/docker/volumes",
    docker   = "sudo docker exec ",
    nc       = "nextcloud-aio-nextcloud "
}

conf.srv.update = "sudo docker stop $(sudo docker ps -a -q); "
    .. "cd " .. conf.srv.path .. "; "
    .. "sudo docker compose pull; "
    .. "docker images --format '{{.Repository}}:{{.Tag}}' | "
    .. "xargs -L1 docker pull; "
    .. "sudo docker compose up -d; "
    .. "sleep 30; "
    .. "sudo docker image prune -a; "
    .. "sleep 30; "
    .. "echo  'do not forget to start nextcloud'; "
    .. "echo  'https://box:8080'; "
    .. "cd $HOME"

conf.srv.blog = "cd /home/burij/Projekte/2311_burij.de/blog/ && "
    .. "apostrophe ./index.md && chmod +x ./build; ./build; cd $HOME"

conf.srv.home = "cd /srv/config/home/ && "
    .. "apostrophe ./index.md && chmod +x ./build; ./build; cd $HOME"

--------------------------------------------------------------------------------
-- TEMPLATES

conf.template_etcnixos = [[
{ config, pkgs, ... }:
{
  imports =
    [
      ./System/hosts/$HOSTNAME/config.nix
    ];
}
]]

---

conf.template_host = [[
{ config, pkgs, lib, modulesPath, ... }:
{

	networking.hostName = "$HOSTNAME";
	system.stateVersion = $VERSION;

	imports =
	[
		../../config.nix
		./hardware.nix
		# <nixpkgs/nixos/modules/installer/virtualbox-demo.nix>

	];
}
]]

---

conf.template_new_machine = [[
sudo chown -R %s /etc/nixos/;
sudo chown %s /etc/nixos/configuration.nix;
sudo chmod u+w /etc/nixos/configuration.nix;
ln -sfv %s /etc/nixos;
sudo chown -R $USER /data/$USER
]]

--------------------------------------------------------------------------------
return conf
