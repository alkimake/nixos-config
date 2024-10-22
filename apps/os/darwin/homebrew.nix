{...}: let
in{
  homebrew = {
    enable = true;
    casks = [
      "spotify"
    ];
    onActivation.cleanup = "zap";
  };
}
