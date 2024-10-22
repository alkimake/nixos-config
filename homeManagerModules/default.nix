# Importing the default.nix file from another location
{ config, pkgs, isDarwin, isLinux, ... }:

let
  # Function to read directories and conditionally include them based on config sections
  getImports = dir: builtins.attrNames dir // [] // map (name: 
    if config."${dir}.${name}.enable" then "${dir}/${name}/default.nix" else null
  ) (builtins.attrNames dir);

  commonImports = getImports "./common";
  darwinImports = isDarwin ? getImports "./darwin";
  linuxImports = isLinux ? getImports "./nixos";

  # Combine all imports
  imports = builtins.removeAttrs((commonImports ++ darwinImports ++ linuxImports) [ null ]);
in
{
  imports = imports;
}