{ pkgs ? import <nixpkgs> { } }:

let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-25.05";
  pkgs = import nixpkgs { config = { }; overlays = [ ]; };

  appName = "os";
  appVersion = "1.1";


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
      # export LUAOS="./conf.lua"
      alias run='lua main.lua'
      alias build='nix-build -A package'
      alias os-out='./result/bin/os'
      alias os-dev='lua main.lua'
      alias make='rm result;git add .;build;git commit -m '
      mkdir modules

      cp ${pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/burij/"
          +"lua-light-wings/refs/tags/v.0.2.2/modules/lua-light-wings.lua";
        sha256 = "sha256-mRD1V0ERFi4gmE/VfAnd1ujoyoxlA0vCj9fJNSCtPkw=";
      }} ./modules/lua-light-wings.lua

      nixpkgs-fmt default.nix
    '';
  };

  package = pkgs.stdenv.mkDerivation {
    pname = appName;
    version = appVersion;

    # src = ./.;

    src = pkgs.fetchFromGitHub {
      owner = "burij";
      repo = "nixos-extended-rebuilder";
      rev = appVersion;
      sha256 = "sha256-qdgWvsW4oaas5wE9vzCGxtyXVOikpl1vyIQ+twHM1zY=";
    };

    extraFile = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/burij/"
        + "lua-light-wings/refs/tags/v.0.2.2/modules/lua-light-wings.lua";
      sha256 = "sha256-mRD1V0ERFi4gmE/VfAnd1ujoyoxlA0vCj9fJNSCtPkw=";
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
