{config, ...}: let
  cfg = config.myNixos;
in{
  homebrew = {
    enable = true;
    casks = [
      "spotify"
    ];
    onActivation.cleanup = "zap";
  };
}
