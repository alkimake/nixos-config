{
  pkgs,
  lib,
  currentSystemName,
  ...
}: let
  # Turn this to true to use gnome instead of i3. This is a bit
  # of a hack, I just flip it on as I need to develop gnome stuff
  # for now.
  linuxGnome = true;
in {
  myNixos = {
    # TODO: assign current system user {userName}
    common = {
      nix.enable = true;
    };
    nixos = {
      docker.enable = true;
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    # Needed for k2pdfopt 2.53.
    "mupdf-1.17.0"
  ];
  boot = {
    # Be careful updating this.
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;

      # VMware, Parallels both only support this being 0 otherwise you see
      # "error switching console mode" on boot.
      systemd-boot.consoleMode = "0";
    };
  };

  networking = {
    # Define your hostname.
    hostName = "dev";
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    # Disable the firewall since we're in a VM and we want to make it
    # easy to visit stuff in here. We only use NAT networking anyways.
    firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;


  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        fcitx5-chinese-addons
      ];
    };
  };

  # setup windowing environment
  services = {
    xserver =
      if linuxGnome
      then {
        enable = true;
        xkb.layout = "us";
        desktopManager.gnome.enable = true;
        displayManager.gdm.enable = true;
      }
      else {
        enable = true;
        xkb.layout = "us";
        dpi = 220;

        desktopManager = {
          xterm.enable = false;
          wallpaper.mode = "fill";
        };

        displayManager = {
          defaultSession = "none+i3";
          lightdm.enable = true;

          # AARCH64: For now, on Apple Silicon, we must manually set the
          # display resolution. This is a known issue with VMware Fusion.
          sessionCommands = ''
            ${pkgs.xorg.xset}/bin/xset r rate 200 40
          '';
        };

        windowManager = {
          i3.enable = true;
        };
      };
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };
    };
    # Enable tailscale. We manually authenticate when we want with
    # "sudo tailscale up". If you don't use tailscale, you should comment
    # out or delete all of this.
    tailscale.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;

  # Manage fonts. We pull these from a secret directory since most of these
  # fonts require a purchase.
  fonts = {
    fontDir.enable = true;

    packages = [
      pkgs.fira-code
      pkgs.jetbrains-mono
      (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
    [
      cachix
      gnumake
      killall
      niv
      rxvt_unicode
      xclip
      neovim
      tmux
      git

      # For hypervisors that support auto-resizing, this script forces it.
      # I've noticed not everyone listens to the udev events so this is a hack.
      (writeShellScriptBin "xrandr-auto" ''
        xrandr --output Virtual-1 --auto
      '')
    ]
    ++ lib.optionals (currentSystemName == "vm-aarch64") [
      # This is needed for the vmware user tools clipboard to work.
      # You can test if you don't need this by deleting this and seeing
      # if the clipboard sill works.
      gtkmm3
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
