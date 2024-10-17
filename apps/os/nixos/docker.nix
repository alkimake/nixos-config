{
  pkgs,
  config,
  ...
}: let
  cfg = config.myNixOS;
in {
  # Docker can also be run rootless
  virtualisation.docker = {
    enable = true;
  };
  # User permissions
  users.users.${config.currentSystemUser}.extraGroups = ["docker"];
}
