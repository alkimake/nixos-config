{
  description = "NixOS systems and tools by ake";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Build a custom WSL installer
    # nixos-wsl.url = "github:nix-community/NixOS-WSL";
    # nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs: let
    # Overlays is the list of overlays we want to apply from flake inputs.
    overlays = [
    ];

    mkSystem = import ./lib/mksystem.nix {
      inherit overlays nixpkgs inputs;
    };
  in {
    # nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" {
    #   system = "aarch64-linux";
    #   user   = "ake";
    # };
    #
    # nixosConfigurations.vm-aarch64-prl = mkSystem "vm-aarch64-prl" rec {
    #   system = "aarch64-linux";
    #   user   = "ake";
    # };
    #
    nixosConfigurations.vm-aarch64-utm = mkSystem "vm-aarch64-utm" rec {
      system = "aarch64-linux";
      user   = "ake";
    };

    # nixosConfigurations.vm-intel = mkSystem "vm-intel" rec {
    #   system = "x86_64-linux";
    #   user   = "ake";
    # };
    #
    # nixosConfigurations.wsl = mkSystem "wsl" {
    #   system = "x86_64-linux";
    #   user   = "ake";
    #   wsl    = true;
    # };

    darwinConfigurations.macbook-air = mkSystem "macbook-air" {
      system = "aarch64-darwin";
      user   = "ake";
      darwin = true;
    };

    homeManagerModules.default = ./apps/home;
    osModules.default = ./apps/os;
  };
}
