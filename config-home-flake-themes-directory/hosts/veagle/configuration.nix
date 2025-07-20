{ config, pkgs, lib, ... }:
{
  imports = [ ];

  nixpkgs.config.allowUnfree = true;        

  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Enable Hyprland and a compatible display manager
  programs.hyprland = {
    enable = true;
    withUWSM = true;
   };  

  # Display Manager
  # Enable SDDM
  services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs; [
        kdePackages.qtsvg
        kdePackages.qtmultimedia
        kdePackages.qtvirtualkeyboard
      ];
      theme = "sddm-astronaut-theme";
  };

  xdg.portal = {
    enable = true;
    # Set the Hyprland portal as the default
    config.common.default = "hyprland";
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
    ];
    # This disables fallback GTK portal
    configPackages = [];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # For Wayland compatibility with Electron apps
  };

  i18n.defaultLocale = "en_US.UTF-8"; # Replace with your preferred locale
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
   };

  # For Running Steam
  hardware.graphics = {
   enable = true;
   enable32Bit = true;
  };        

  # Enable hardware-accelerated rendering (optional, adjust if necessary)
  services.xserver.videoDrivers = [ "modesetting" ];

  # Configure the system timezone
  time.timeZone = "Asia/Kolkata"; 

  # Enable networking
  #networking.wireless.enable = true;
  hardware.enableAllFirmware = true;
  networking.hostName = "nixos"; # Set your hostname
  networking.networkmanager.enable = true; # Enable NetworkManager for easier configuration

  nixpkgs.config.permittedInsecurePackages = [
                "electron-24.8.6"
              ];   
  
  # Configure system packages
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-hyprland
    networkmanagerapplet
    networkmanager
    (pkgs.callPackage ./sddm-theme.nix {
      # theme = "astronaut"; #nice
      # theme = "black_hole"; #bad
      # theme = "cyberpunk"; # bad(showing wrong date)
      # theme = "hyprland_kath"; #good
      # theme = "jake_the_dog"; #bad
      # theme = "japanese_aesthetic"; #bad
      # theme = "pixel_sakura"; #nice
      # theme = "pixel_sakura_static"; #bad
      # theme = "post-apocalyptic_hacker"; #bad
      theme = "purple_leaves"; #nice
    }) 
    # Add more packages as needed
  ] ++ (lib.optionals (!config.boot.isContainer) [
  (pkgs.runCommand "remove-gtk-portal" { } ''
    mkdir -p $out/share/xdg-desktop-portal/portals
    # Create a dummy gtk.portal that does nothing
    echo '[portal]' > $out/share/xdg-desktop-portal/portals/gtk.portal
    echo 'DBusName=ignore.me' >> $out/share/xdg-desktop-portal/portals/gtk.portal
    echo 'Interfaces=' >> $out/share/xdg-desktop-portal/portals/gtk.portal
  '')
]);
  
  # Fonts
  fonts.packages = with pkgs; [
   noto-fonts-color-emoji
   dosis
   iosevka
   nerd-fonts._0xproto
   nerd-fonts._3270
   nerd-fonts.agave
   nerd-fonts.anonymice
   nerd-fonts.arimo
   nerd-fonts.aurulent-sans-mono
   nerd-fonts.bigblue-terminal
   nerd-fonts.bitstream-vera-sans-mono
   nerd-fonts.blex-mono
   nerd-fonts.caskaydia-cove
   nerd-fonts.caskaydia-mono
   nerd-fonts.code-new-roman
   nerd-fonts.comic-shanns-mono
   nerd-fonts.commit-mono
   nerd-fonts.cousine
   nerd-fonts.d2coding
   nerd-fonts.daddy-time-mono
   nerd-fonts.dejavu-sans-mono
   nerd-fonts.departure-mono
   nerd-fonts.droid-sans-mono
   nerd-fonts.envy-code-r
   nerd-fonts.fantasque-sans-mono
   nerd-fonts.fira-code
   nerd-fonts.fira-mono
   nerd-fonts.geist-mono
   nerd-fonts.go-mono
   nerd-fonts.gohufont
   nerd-fonts.hack
   nerd-fonts.hasklug
   nerd-fonts.heavy-data
   nerd-fonts.hurmit
   nerd-fonts.im-writing
   nerd-fonts.inconsolata
   nerd-fonts.inconsolata-go
   nerd-fonts.inconsolata-lgc
   nerd-fonts.intone-mono
   nerd-fonts.iosevka-term
   nerd-fonts.iosevka-term-slab
   nerd-fonts.jetbrains-mono
   nerd-fonts.lekton
   nerd-fonts.liberation
   nerd-fonts.lilex
   nerd-fonts.martian-mono
   nerd-fonts.monaspace
   nerd-fonts.monofur
   nerd-fonts.monoid
   nerd-fonts.mononoki
   nerd-fonts.noto
   nerd-fonts.open-dyslexic
   nerd-fonts.overpass
   nerd-fonts.profont
   nerd-fonts.proggy-clean-tt
   nerd-fonts.recursive-mono
   nerd-fonts.roboto-mono
   nerd-fonts.sauce-code-pro
   nerd-fonts.shure-tech-mono
   nerd-fonts.space-mono
   nerd-fonts.symbols-only
   nerd-fonts.terminess-ttf
   nerd-fonts.tinos
   nerd-fonts.ubuntu
   nerd-fonts.ubuntu-mono
   nerd-fonts.ubuntu-sans
   nerd-fonts.victor-mono
   nerd-fonts.zed-mono
  ];

  # Enable sound
  # sound.enable = true;
  services.pulseaudio.enable = false;  

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Bluedevil-Blueman Alternative
  # services.dbus.enable = true;  

  # Enable SSH
  services.openssh.enable = true;

  # Enable firewall
  networking.firewall.enable = true;

  # Users
  users.users.veagle = { # Replace "yourusername" with your actual username
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Add user to additional groups
  };

  # Enable systemd-boot (optional if not using GRUB)
  boot.loader.systemd-boot.enable = true;
  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";  # Replace with your actual ESP partition
    fsType = "vfat";
  };

  # File systems
  fileSystems."/" = {
   device = "/dev/nvme0n1p6"; # Root partition
   fsType = "ext4";           # Assuming ext4 is the filesystem
  };

  system.stateVersion = "24.11";
  swapDevices = [
   {
    device = "/swapfile";
   }
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
