{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.myHomeManager;
  myLib = (import ../../lib/myLib.nix) {inherit inputs;};

  commonModules =
    myLib.extendModules
    (name: {
      extraOptions = {
        myHomeManager.common.${name}.enable = lib.mkEnableOption "enable ${name} module common";
      };

      configExtension = config: (lib.mkIf cfg.common.${name}.enable config);
    })
    (myLib.filesIn ./common)
    {};

  #
  # Taking all modules in ./features and adding enables to them
  # features =
  #   myLib.extendModules
  #   (name: {
  #     extraOptions = {
  #       myHomeManager.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
  #     };
  #
  #     configExtension = config: (lib.mkIf cfg.${name}.enable config);
  #   })
  #   (myLib.filesIn ./features)
  #   {};
  #
in {
  imports = 
    commonModules;
}

