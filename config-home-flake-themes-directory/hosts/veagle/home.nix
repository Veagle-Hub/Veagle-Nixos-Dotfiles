{ config, pkgs, lib, ... }:

{
  home.username = "veagle";
  home.homeDirectory = "/home/veagle";

  programs.home-manager.enable = true;
 
  services.network-manager-applet.enable = true;  

  home.packages = 
   (with pkgs; [
    kdePackages.systemsettings
    kdePackages.kwalletmanager
    htop
    neofetch
    xdotool
    fastfetch
    #vscode
    hyprland
    #rclone
    hyprlock
    hyprpaper
    pavucontrol     # for audio controls
    waybar
    wlogout
    libreoffice-qt6
    qt6ct
    libsForQt5.qt5ct
    # GTK
    gtk3
    bibata-cursors
    adw-gtk3
    #gruvboxPlus
    # Calendar
    gnome-calendar
    protonmail-desktop
    brightnessctl
    fuzzel
    #rofi
    kitty
    wl-clipboard
    cliphist
    grim
    slurp
    hyprshot
    obs-studio
    # blueman
    # kdePackages.bluedevil
    # bluetuith
    blueberry
    wireplumber
    networkmanagerapplet
    kdePackages.okular   
    # Or try: evince or zathura
    # 🛠 Optional helpful tools
    unzip
    wget
    git
    git-credential-manager
    # Doc-Reader
    sioyek
    kdePackages.dolphin
    #qimgv
    # PKMS/Editor
    obsidian
    syncthing
    vim
    # Messaging Apps
    equibop 
    signal-desktop
    #vesktop
    # Browser
    brave
    tor-browser
    # Youtube
    freetube
    mpv            # to stream YouTube via CLI
    # For Running.exe files
    steam
    # VPN
    protonvpn-gui  # ProtonVPN GUI client (needs setup and login)
    openvpn        # Required for many VPNs
    # File Manager
    gvfs                # Needed for mounting drives and trash support
    kdePackages.kio-extras
    kdePackages.baloo
    kdePackages.kdegraphics-thumbnailers
    kdePackages.ffmpegthumbs
    kdePackages.breeze
    kdePackages.breeze-icons
    kdePackages.oxygen
    kdePackages.polkit-kde-agent-1
    kdePackages.gwenview #for opening images
    #libsForQt5.gwenview
    # Notifications
    swaynotificationcenter
    # Add more user-level packages here
   ]);  

  # Enable some basic programs

  # Bash
  programs.zsh.enable = true;
  programs.bash = {
    enable = true;
    initExtra = ''
      eval "$(starship init bash)"
    '';
    shellAliases = {
      ns = "sudo nixos-rebuild switch --flake ~/nixos-config#veagle";
      hm = "nix run ~/nixos-config#homeConfigurations.veagle.activationPackage";
      nb = "sudo nixos-rebuild boot --flake /home/veagle/nixos-config#veagle";
      ntest = "sudo nixos-rebuild build --flake /home/veagle/nixos-config#veagle";
      le = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      nclean = "sudo nix-collect-garbage -d";
      hland = "nano ~/.config/hypr/hyprland.conf";
      hlock = "nano ~/.config/hypr/hyprlock.conf";
      home = "nano nixos-config/hosts/veagle/home.nix";
      ship = "nano ~/nixos-config/hosts/veagle/starship.toml";
      config = "nano nixos-config/hosts/veagle/configuration.nix";
      flake = "nano nixos-config/flake.nix";
      vs = "vim ~/.vimrc";
      nf = "neofetch";
      ff = "fastfetch";
      hc = "hyprctl clients";
      cond = "cd .config";
      plugd = "cd pkms/.obsidian/plugins"; #obsidian plugins directory
      obsid = "cd pkms/.obsidian"; #obsidian diretory
    };
  };

  #Sioyek
  programs.sioyek = {
    enable = true;
    config = {
      "default_dark_mode" = "1";
    }; 
    bindings = {
      "toggle_statusbar" = "S";
      "toggle_dark_mode" = "i";
      "visual_mark_under_cursor" = "M";
    };
  };

  # Wlogout
  programs.wlogout = {
     enable = true;
  };

  # Git
  programs.git = {
    enable = true;
    userEmail = "justforutube0987@gmail.com";
    userName = "Veagle";
    extraConfig = {
      credential.helper = "store"; 
      core.askpass = ""; # Any other git config settings
    };
  };

  # Kitty
    programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "FiraCode Nerd Font";
      size = 10;
    };
    #extraConfig = ''
    #  background_opacity 0.2
    #'';
  };

  # Blueman
  #services.blueman-applet = {
  # enable = true;
  #};
  
  # Gtk  
  gtk = {
   enable = true;
   cursorTheme.package = pkgs.bibata-cursors;
   cursorTheme.name = "Bibata-Modern-Ice";
   theme.package = pkgs.adw-gtk3;
   theme.name = "adw-gtk3";
   #iconTheme.package = gruvboxPlus;
   iconTheme.name = "Paprikus Dark";
  };

  # Set home-manager version compatibility
  home.stateVersion = "24.11"; # Match your system.stateVersion

  # In home.nix recommended by Chatgpt
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    QT_QPA_PLATFORMTHEME = "qt6ct"; # Or "qt5ct" for Qt 5 apps
    #QT_STYLE_OVERRIDE = "Breeze"; 
   };

  # App Launcher
   programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "FiraCode Nerd Font:size=12";
        prompt = "Run: ";
        terminal = "alacritty";
        width = 50;
      };
      colors = {
        background = "282a36dd";
        text = "f8f8f2ff";
        match = "ff79c6ff";
        selection = "44475add";
        selection-text = "f8f8f2ff";
      };
    };
  };

  # Starship
  programs.starship = {
  enable = true;
  settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };

  # Zoxide
  programs.zoxide = {
     enable = true;
     enableZshIntegration = true;
     enableBashIntegration = true;
    };

  # Wallpaper Via Hyprpaper ChatGPT Suggestion
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/.config/wallpapers/mywall.png
    wallpaper = eDP-1,~/.config/wallpapers/mywall.png
  '';
  
  # Obsidian Sync With Syncthing
    services.syncthing = {
      enable = true;
    };
  
  # Waybar Nick's modules/home/gui/desktop/wayland/waybar/config
  programs.waybar = {
  enable = true;
  settings = [
    {
      layer = "top";
      position = "bottom";
      height = 50;
      spacing = 10;
      margin-top = 0;
      margin-bottom = 5;
      margin-left = 10;
      margin-right = 10;
      modules-left = [ 
       "custom/launcher"
       "tray" 
       "custom/exit"
      ];
      modules-center = [ "hyprland/workspaces" ];
      modules-right = [ 
       "bluetooth" 
       "privacy" 
       "pulseaudio" 
       "battery" 
       "network" 
       "clock"
       ];
      
      "custom/launcher" = {
         format = "";
         on-click = "fuzzel";
         tooltip = false;
       };

      "custom/exit" = {
        format = " ";
        on-click = "wlogout";
        tooltip-format = "Power Menu";
       };

      "hyprland/workspaces" = {
        active-only = false;
        disable-scroll = true;
        format = "{icon}";
        on-click = "activate";
        format-icons = {
         "1" = "◉";
         "2" = "◉";
         "3" = "◉";
         "4" = "◉";
         "5" = "◉";
        urgent = "";
        default = "◉";
        sort-by-number = true;
        };
        persistent-workspaces = {
         "1" = [ ];
         "2" = [ ];
         "3" = [ ];
         "4" = [ ];
         "5" = [ ];
        };
       };

      "bluetooth" = {
         format = " {status}";
         format-disabled = "";
         format-off = "";
         interval = 30;
         on-click = "blueberry";
         format-no-controller = "";
       };
       
      "tray" = {
        icon-size = 20;
        spacing = 10;
       };
       
      "privacy" = {
         icon-spacing = 8;
         icon-size = 12;
         transition-duration = 250;
         modules = {
          screenshare = {
          type = "screenshare";
          tooltip = true;
          tooltip-icon-size = 12;
         };
         audio-out = {
          type = "audio-out";
          tooltip = true;
          tooltip-icon-size = 12;
         };
         audio-in = {
          type = "audio-in";
          tooltip = true;
          tooltip-icon-size = 12;
         };
        };
       };

       "pulseaudio" = {
         format = "{icon} {volume}%";
         tooltip = false;
         format-muted = " Muted";
         on-click = "pavucontrol";
         on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
         on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
         scroll-step = 5;
         format-icons = {
         headphone = "";
         hands-free = "";
         headset = "";
         phone = "";
         portable = "";
         car = "";
         default = [
          ""
          ""
          " "
          ];
         };
        };

      "battery" = {
        format = "{icon}{capacity}%";
        format-alt = "{icon} {time}";
        format-charging = "{capacity}%";
        format-icons = [
         " "
         " "
         " "
         " "
         " "
        ];
        format-plugged = "{capacity}%";
        states = {
         critical = 15;
         warning = 30;
        };
       };
     
      "network" = {
        format-wifi = " {signalStrength}%";
        format-ethernet = "󰀂";
        #tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
        format-linked = "{ifname} (No IP)";
        format-disconnected = "󰖪 ";
       };

       "clock" = {
        calendar = {
         format = {
          today = "<span color='#ff6699'><b><u>{}</u></b></span>";
         };
        };
        format = "{:%I:%M%p}";
        tooltip = true;
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "{:%d/%m}";
        on-click = "gnome-calendar";
       };
    }
  ];     
   
  style = ''
    * {
       min-height: 34px;
       border-radius:0;
       font-family: "MonaspiceNe Nerd Font";
       font-weight: bold;
      }
     
      window#waybar {
       background: #262626;  
       color: #d197d9;
       border: 2px solid;
       border-radius: 30px;
       border-color: #9000ff;
       opacity: 1;
      }
     
     #workspaces {
      font-size: 50px;
      padding-left: 5px;
      margin-bottom: 5px;
     }
    
     #workspaces button {
      color: #424343;
      padding: 0px 5px 0px 5px;
      opacity: 1;
     } 
    
     #workspaces button.active {
      color: #9000ff;
     }
     
     #privacy {
       font-size: 20px;
       color: #9000ff;
       padding-right: 20px;
      }
 
     #tray {
       font-size: 20px;
       color: #9000ff;
       padding-right: 5px;
       padding-left: 5px;
      } 
     
     #pulseaudio {
       font-size: 20px;
       color: #9000ff;
       padding-right: 10px;
      }

     #clock {
       font-size: 50px;
       color: #9000ff;
       padding-right: 10px;
      }
     
     #network {
       font-size: 20px;
       color: #9000ff;
       padding-right: 10px;
      }

     #bluetooth {
       font-size: 20px;
       color: #9000ff;
       padding-right: 10px;
      }
     
     #battery {
      font-size: 20px;
      color: #9000ff;
      padding-right: 10px;
     }

     #custom-launcher {
       font-size: 50px;
       color: #9000ff;
       font-weight: bold;
       padding-left: 10px;
       padding-right: 10px;
      }  

     #custom-exit {
       color: #9000ff;
       font-size: 50px;
       font-weight: bold;
      } 
   '';
 };
}
