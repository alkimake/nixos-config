{
  ...
}: {
  programs.gpg.enable = true;

  # Optional: Set GPGTTY environment variable for SSH sessions
  home.sessionVariables = {
    GPGTTY = "$(tty)";
  };
}
