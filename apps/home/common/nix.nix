_: {
  nix = {
    # We need to enable flakes
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';

    # public binary cache that I use for all my derivations. You can keep
    # this, use your own, or toss it. Its typically safe to use a binary cache
    # since the data inside is checksummed.
    settings = {
      substituters = ["https://ake-nixos-config.cachix.org"];
      trusted-public-keys = ["ake-nixos-config.cachix.org-1:CiM0xLg1ECceA4PNgDbFCq4tK2xUKdh76cMG5m0y6A0="];
    };
  };
}
