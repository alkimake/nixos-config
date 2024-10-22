{
  config,
  lib,
  darwin,
  isWSL,
  myLib,
  ...
}:
 let
  # darwin = true;
  cfg = config.myNixos;

  commonModules =
    myLib.extendModules
    (name: {
      extraOptions = {
        myNixos.common.${name}.enable = lib.mkEnableOption "enable ${name} module common";
      };

      configExtension = config: (lib.mkIf cfg.common.${name}.enable config);
    })
    (myLib.filesIn ./common)
    {};

  #
  # Taking all modules in ./features and adding enables to them
  darwinModules = if darwin then
    myLib.extendModules
    (name: {
      extraOptions = {
        myNixos.darwin.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
      };

      configExtension = config: (lib.mkIf cfg.darwin.${name}.enable config);
    })
    (myLib.filesIn ./darwin)
    {} else [];

  nixosModules = if !darwin && !isWSL then
    myLib.extendModules
    (name: {
      extraOptions = {
        myNixos.nixos.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
      };

      configExtension = config: (lib.mkIf cfg.nixos.${name}.enable config);
    })
    (myLib.filesIn ./nixos)
    {} else [];
in {
  imports =
    commonModules
    ++ darwinModules
    ++ nixosModules;
}
