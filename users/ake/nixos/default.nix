{ pkgs, inputs, ... }:

{
  myHomeManager = {
    common = {
      nix.enable = true;
    };
  };
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Since we're using fish as our shell
  programs.fish.enable = true;

  users.users.ake = {
    isNormalUser = true;
    home = "/home/ake";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.fish;
    hashedPassword = "$y$j9T$uSYdADElzNspLspBixGyA1$1nTox9ouYL8wvN1eTj9PRj9pYEU2HENKsSEFWjdYE45";
    # openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGbTIKIPtrymhvtTvqbU07/e7gyFJqNS4S0xlfrZLOaY mitchellh"
    # ];
  };

}
