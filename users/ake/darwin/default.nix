{ inputs, config, pkgs, ... }:

{
  # nixpkgs.overlays = import ../../lib/overlays.nix ++ [
  #   (import ./vim.nix { inherit inputs; })
  # ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.alacritty
    pkgs.mkalias
  ];

  homebrew = {
    enable = true;
    casks  = [
      "spotify"
    ];
    onActivation.cleanup = "zap";
  };



  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.ake = {
    home = "/Users/ake";
    shell = pkgs.fish;
  };
}
