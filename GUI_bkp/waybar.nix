{ config, pkgs, ... }:
{
# Waybar con config dai dotfiles
programs.waybar = {
  enable = true;
  package = pkgs.waybar;
  
  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 40;
      spacing = 8;
      margin-top = 20;
      margin-bottom = 0;
      margin-left = 20;
      margin-right = 20;
      
      modules-left = [
        "image#nixos"
        "hyprland/workspaces"
      ];
      
      modules-center = [
        "hyprland/window"
      ];
      
      modules-right = [
        "custom/screenshot"
        "network"
        "pulseaudio"
        "cpu"
        "memory"
        "hyprland/language"
        "clock"
        "custom/power"
      ];
      
      # Logo NixOS
      "image#nixos" = {
        path = "/run/current-system/sw/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        size = 24;
        on-click = "rofi -show drun";
        tooltip = false;
      };
      
      # Workspaces Hyprland
      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        format = "{id}";
        on-click = "activate";
        persistent-workspaces = {
          "1" = [];
          "2" = [];
          "3" = [];
          "4" = [];
          "5" = [];
        };
      };
      
      # Finestra attiva
      "hyprland/window" = {
        format = "{title}";
        max-length = 60;
        separate-outputs = true;
      };
      
      # Screenshot
      "custom/screenshot" = {
        format = "\uf0104";
        tooltip-format = "Screenshot";
        on-click = "gnome-screenshot -i";
      };
      
      # Network (IP)
      network = {
        format-wifi = "WiFi: {ipaddr}";
        format-ethernet = "Eth: {ipaddr}";
        format-disconnected = "Disconnected";
        tooltip-format-wifi = "{essid} ({signalStrength}%) {ipaddr}";
        tooltip-format-ethernet = "{ifname}: {ipaddr}";
        tooltip-format-disconnected = "Disconnected";
        max-length = 15;
      };
      
      # Volume
      pulseaudio = {
        format = "AUDIO: {volume}%";
        format-bluetooth = "BL AUDIO: {volume}%";
        format-bluetooth-muted = "BL MUTED";
        format-muted = "MUTED";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "🎧";
          hands-free = "🎧";
          headset = "🎧";
          phone = "📞";
          portable = "📱";
          car = "🚗";
          default = ["🔈" "🔉" "🔊"];
        };
        on-click = "pavucontrol";
        on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
      };
      
      # CPU
      cpu = {
        format = "CPU: {usage}% ";
        tooltip = false;
        interval = 2;
      };
      
      # RAM
      memory = {
        format = "RAM: {percentage}% ";
        tooltip-format = "{used:0.1f}G/{total:0.1f}G used";
        interval = 2;
      };
      
      # Lingua
      "hyprland/language" = {
        format = "{long}";
        keyboard-name = "keyboard";
      };
      
      # Orologio
      clock = {
        format = "{:%A, %d %B %Y} - {:%H:%M}";
        format-alt = "{:%A, %d %B %Y}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "year";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
          on-click-right = "mode";
          format = {
            months = "<span color='#268bd2'><b>{}</b></span>";
            days = "<span color='#657b83'><b>{}</b></span>";
            weeks = "<span color='#586e75'><b>W{}</b></span>";
            weekdays = "<span color='#cb4b16'><b>{}</b></span>";
            today = "<span color='#dc322f'><b><u>{}</u></b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-click-forward = "tz_up";
          on-click-backward = "tz_down";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };
      
      # Power menu
      "custom/power" = {
        format = "ESC";
        on-click = "wlogout";
      };
    };
  };
  
  style = ''
    * {
      font-family: "Agave Nerd Font";
      font-size: 13px;
      font-weight: normal;
      border: none;
      border-radius: 0;
      min-height: 0;
      margin: 0;
      padding: 0;
    }
    
    /* Solarized Light Colors */
    @define-color base03 #002b36;
    @define-color base02 #073642;
    @define-color base01 #586e75;
    @define-color base00 #000000;
    @define-color base0 #839496;
    @define-color base1 #93a1a1;
    @define-color base2 #eee8d5;
    @define-color base3 #fdf6e3;
    @define-color yellow #b58900;
    @define-color orange #cb4b16;
    @define-color red #dc322f;
    @define-color magenta #d33682;
    @define-color violet #6c71c4;
    @define-color blue #268bd2;
    @define-color cyan #2aa198;
    @define-color green #859900;
    
    window#waybar {
      background: rgba(253, 246, 227, 0.90);
      border-radius: 10px;
      color: @base00;
    }
    
    /* Sezioni principali */
    .modules-left,
    .modules-center,
    .modules-right {
      background: transparent;
    }
    
    .modules-left {
      margin-left: 8px;
    }
    
    .modules-right {
      margin-right: 8px;
      border-radius: 10px;
    }
    
    /* Logo NixOS */
    #image {
      margin-right: 8px;
      padding: 0 8px;
    }
    
    #image:hover {
      background: @blue;
      color: @base3;
    }
    
    /* Workspaces */
    #workspaces {
      border-radius: 12px;
      padding: 0 4px;
    }
    
    #workspaces button {
      background: transparent;
      color: @base01;
      border-radius: 10px;
      padding: 4px 8px;
      margin: 2px;
      transition: all 0.2s ease;
    }
    
    #workspaces button:hover {
      background: @base1;
      color: @base3;
    }
    
    #workspaces button.active {
      background: @blue;
      color: @base3;
    }
    
    #workspaces button.urgent {
      background: @red;
      color: @base3;
    }
    
    /* Finestra centrale */
    #window {
      color: @base00;
      padding: 0 15px;
      font-weight: bold;
      font-family: "Agave Nerd Font Bold";
      font-size: 13px;
    }
    
    /* Moduli a destra */
    #custom-screenshot,
    #network,
    #cpu,
    #memory,
    #language,
    #clock,
    #custom-power {
      color: @base00;
      padding: 0 12px;
      /*margin: 0 2px;*/
      transition: all 0.2s ease;
    }
    
    /* Hover effects */
    #custom-screenshot:hover { background: @cyan; color: @base3; }
    #network:hover { background: @green; color: @base3; }
    #pulseaudio:hover { background: @blue; color: @base3; }
    #cpu:hover { background: @orange; color: @base3; }
    #memory:hover { background: @yellow; color: @base3; }
    #language:hover { background: @violet; color: @base3; }
    #clock:hover { background: @magenta; color: @base3; }
    #custom-power:hover { background: @red; color: @base3; }
    
    /* Stati speciali */
    #pulseaudio.muted {
      background: @red;
      color: @base3;
    }
    
    #network.disconnected {
      background: @red;
      color: @base3;
    }
    
    #cpu.warning {
      background: @yellow;
      color: @base3;
    }
    
    #cpu.critical {
      background: @red;
      color: @base3;
    }
    
    #memory.warning {
      background: @yellow;
      color: @base3;
    }
    
    #memory.critical {
      background: @red;
      color: @base3;
    }
    
    /* Tooltip */
    tooltip {
      background: @base2;
      border: 1px solid @base1;
      border-radius: 8px;
      color: @base00;
    }
  '';
};
}
