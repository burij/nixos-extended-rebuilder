{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "nixos-extended-rebuilder";
  version = "init";

  # src = pkgs.fetchFromGitHub {
  #   owner = "burij";
  #   repo = "nixos-extended-rebuilder";
  #   rev = "main";
  #   sha256 = "";
  # };

  src = ./.;

  llwCoreLua = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/burij/lua-light-wings/refs/tags/v.0.1.0/modules/llw-core.lua";
    sha256 = "sha256-mRD1V0ERFi4gmE/VfAnd1ujoyoxlA0vCj9fJNSCtPkw=";
  };

  buildInputs = with pkgs; [
    wget
    (lua5_4.withPackages (ps: with ps; [ inspect luafilesystem ]))
  ];

  installPhase = ''
    echo "Listing files in source directory"
    ls -l $src  # Check what files are in the fetched source directory
    mkdir -p $out/bin
    cp -r $src/* $out/
    cp $llwCoreLua $out/llw-core.lua

    # Create the lua binary wrapper with proper environment
    cat > $out/bin/lua <<EOF
    #!${pkgs.stdenv.shell}
    export LUA_PATH="\
    ${pkgs.lua54Packages.inspect}/share/lua/5.4/?.lua;\
    ${pkgs.lua54Packages.inspect}/share/lua/5.4/?/init.lua;\
    ${pkgs.lua54Packages.luafilesystem}/share/lua/5.4/?.lua;\
    ${pkgs.lua54Packages.luafilesystem}/share/lua/5.4/?/init.lua;\
    $out/?.lua;$out/?/init.lua"

    export LUA_CPATH="\
    ${pkgs.lua54Packages.inspect}/lib/lua/5.4/?.so;\
    ${pkgs.lua54Packages.luafilesystem}/lib/lua/5.4/?.so;\
    $out/?.so"

    exec ${pkgs.lua5_4}/bin/lua "\$@"
    EOF

    chmod +x $out/bin/lua
    install -m 755 ./wrapper.sh $out/bin/nx-rebuild
  '';

  meta = {
    description = "Declarative management of imperative NixOS components.";
    license = pkgs.lib.licenses.mit;
  };
}