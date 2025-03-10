let
	nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
	pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShell {
	packages = with pkgs; [
		wget
		(lua5_4.withPackages(ps: with ps; [
			luarocks
			inspect
			luafilesystem
		]))
	];

	shellHook = ''
		alias run='lua app.lua'
		luarocks install lua-light-wings --tree ./pkgs
		wget -O need.lua https://raw.githubusercontent.com/burij/lua-light-wings/refs/heads/main/modules/need.lua
	'';
}