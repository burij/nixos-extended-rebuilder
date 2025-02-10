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
		]))
	];

	shellHook = ''
		alias run='lua main.lua'
		luarocks install lua-light-wings --tree ./pkgs
	'';
}