{ isDarwin, isWSL, inputs, ... }:

{ config, lib, pkgs, outputs, ... }:

let

  # For our MANPAGER env var
  # https://github.com/sharkdp/bat/issues/1145
  manpager = (pkgs.writeShellScriptBin "manpager" (if isDarwin then ''
    sh -c 'col -bx | bat -l man -p'
    '' else ''
    cat "$1" | col -bx | bat --language man --style plain
  ''));

  importsCommon = [
    ../../../homeManagerModules/common/gnupg.nix
  ];
  importsDarwin = [
    ../../../homeManagerModules/darwin
  ];
  importsNixos = [
    ../../../homeManagerModules/nixos
  ];
  imports = importsCommon
    ++ (lib.optionals isDarwin importsDarwin)
    ++ (lib.optionals (!isDarwin && !isWSL) importsNixos); # ++ (if isDarwin then importsDarwin else importsNixos);

  # imports = [
  #   (import ../../../homeManagerModules { inherit config; })
  # ];

in {
  inherit imports;
  programs.home-manager.enable = true;
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";
  
  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = [
    pkgs.bat
    pkgs.eza
    pkgs.fd
    pkgs.fzf
    pkgs.gh
    pkgs.htop
    pkgs.jq
    pkgs.ripgrep
    pkgs.watch

  ] ++ (lib.optionals isDarwin [
    # This is automatically setup on Linux
    pkgs.cachix
  ]) ++ (lib.optionals (!isDarwin && !isWSL) [
    # Linux dependencies
  ]);
}

