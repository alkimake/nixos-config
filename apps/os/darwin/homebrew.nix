_: {
  homebrew = {
    enable = true;
    casks = [
      "spotify"
    ];
    onActivation.cleanup = "zap";
  };
}
