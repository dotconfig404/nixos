{ config, lib, pkgs, ... }:

{
  imports = [ ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true; 
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     ntfs3g
     lsof
       tree
       kitty
     wget
     cowsay
     gparted
     rsync
     woeusb-ng
    ((vim_configurable.override {  }).customize{
      name = "vim";
      # since my vimrc is fairly simple, we'll just source it like this
      vimrcConfig.customRC = ''
        so /etc/nixos/dotfiles/.vimrc
      '';
      # needs vundle to work tho, then do VundleInstall or PluginInstall from vim
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ Vundle-vim ];
        opt = [];
      };
    })
   ];

  # windwow manager
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "eu";
  services.xserver.xkb.options = "caps:escape";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # user setup
   users.users.dotconfig = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" ]; 
     packages = with pkgs; [
       firefox
     ];
   };
   # source the tmux file
  programs.tmux = {
  enable = true;
  extraConfig = ''
    source-file /etc/nixos/dotfiles/tmux.conf
  '';
  };
 
  # tried to nixify neovim setup, but gave up and opted for symlinking the nvim directory
  # due to being unable to find a way to make require work properly for nvim dir being in
  # /etc/nixos/dotfiles instead of xdg_config_directory
  # maybe revisit this another time
    programs.neovim = {
      enable = true;
     # configure = {
     #   # setup package path so it loads the lua dir from here and load the here-config iykwim
     #   # https://www.lua.org/pil/8.1.html
     #   # https://neovim.discourse.group/t/require-files-not-from-lua-folder/1823/8
     #   #customRC = ''
     #   #  so /etc/nixos/dotfiles/nvim/nixos-helper.lua
     #   #  so /etc/nixos/dotfiles/nvim/init.lua
     #   #'';
     #   packages.myVimPackage = with pkgs.vimPlugins; {
     #     start = [ ctrlp ];
     #   };
     # };
    };
  # symlinking neovim here (if this is actually what we choose in the end, make it idiotproof):
   system.activationScripts.symmingDotfiles = {
     text = ''
       ln -s "/etc/nixos/dotfiles/nvim/" "/home/dotconfig/.config/"
     '';
  }; 

  # enable flakes
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # get virtualbox running
   virtualisation.virtualbox.host.enable = true;
   users.extraGroups.vboxusers.members = [ "dotconfig" ];
   virtualisation.virtualbox.guest.enable = true;
  

   environment.sessionVariables = rec {
    EDITOR = "vim";
   };

  home-manager = {
    users.dotconfig = {
     
      programs.git = {
        enable = true;
        userName = "dotconfigaaaa";
        userEmail = "dotconfig@krutt.org";
      };
     

     
      services.xcape = {
         enable = true;
         mapExpression = {
           Alt_R = "Escape";
         };
       };
      
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      home.stateVersion = "23.11";
    };
  };
  # why the fuck is this not working a?????
      programs.bash.shellAliases = {
        conf = "$EDITOR /etc/nixos/configuration.nix";
        reb = "sudo nixos-rebuild switch";
      };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

