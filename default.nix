{ pkgs ? import <nixpkgs> { } }:

let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
  pkgs = import nixpkgs { config = { }; overlays = [ ]; };

  luaEnv = pkgs.lua5_4.withPackages (ps: with ps; [
    luarocks
    luafilesystem
    inspect
  ]);

  dependencies = with pkgs; [
    wget
    nixpkgs-fmt
  ];

  shell = pkgs.mkShell {
    buildInputs = [ luaEnv dependencies ];
    shellHook = ''
      export LUAOS="./conf.lua"
      alias run='lua main.lua'
      alias os='lua main.lua'
      alias make='rm result;git add .;build;git commit -m '

      cp ${pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/burij/"
          +"lua-light-wings/refs/heads/main/modules/need.lua";
        sha256 = "sha256-w6ie/GiCiMywXgVmDg6WtUsTFa810DTGo1jAHV5pi/A=";
      }} ./need.lua

      cp ${pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/burij/"
          +"lua-light-wings/refs/heads/v.0.2.2/modules/lua-light-wings.lua";
        sha256 = "sha256-mRD1V0ERFi4gmE/VfAnd1ujoyoxlA0vCj9fJNSCtPkw=";
      }} ./modules/lua-light-wings.lua

      nixpkgs-fmt default.nix
    '';
  };

  package = pkgs.stdenv.mkDerivation {
    pname = "os";
    version = "1.0.0";

    src = ./.;

    # Template for remote source
    # src = pkgs.fetchFromGitHub {
    #   owner = "burij";
    #   repo = "hpln";
    #   rev = "0.2";
    #   sha256 = "sha256-H+ns/5mkbKuSQQwQ6vaECTmveSBYBUMr6YRRKokFKck=";
    # };

    extraFile = pkgs.fetchurl {
      url = "https://github.com/burij/lua-light-wings/blob/"
        + "v.0.2.2/modules/lua-light-wings.lua";
      sha256 = "sha256-8t0WCZ3JG0gIoJQwhjfeB0bn16snHL+RYx4MAnsXH2c=";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];
    buildInputs = [ luaEnv dependencies ];

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/lib
      cp -r . $out/lib/$pname
      cp -r ./modules/* $out/lib/$pname/
      cp $extraFile $out/lib/$pname/lua-light-wings.lua

      makeWrapper ${luaEnv}/bin/luarocks $out/bin/luarocks
      makeWrapper ${luaEnv}/bin/lua $out/bin/$pname \
        --add-flags "$out/lib/$pname/main.lua" \
        --set LUA_PATH "$out/lib/$pname/?.lua;$out/lib/$pname/?/init.lua;" \
        --set LUA_CPATH "${luaEnv}/lib/lua/${luaEnv.lua.luaversion}/?.so"

      # Additional custom wrapper
      cat > $out/bin/$pname-extra <<EOF
      #!${pkgs.stdenv.shell}
      exec ${luaEnv}/bin/lua "$out/lib/$pname/main.lua" "\$@"
      EOF
      chmod +x $out/bin/$pname-extra

    '';

    meta = with pkgs.lib; {
      description = "NixOS extended rebuilder";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
in
{ shell = shell; package = package; }
