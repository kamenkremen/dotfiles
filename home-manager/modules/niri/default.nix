{ pkgs, ... }:

{
  programs.niri.settings = {
    prefer-no-csd = true;
    workspaces = {
        "1" = {};
        "2" = {};
        "3" = {};
        "4" = {};
        "5" = {};
        "6" = {};
        "7" = {};
        "8" = {};
        "9" = {};
    };

    outputs."eDP-1" = {
      scale = 2;
    }; 

    input = {
      keyboard.xkb = {
        layout = "us, ru";
        options = "grp:caps_toggle";
      };
      
      touchpad = {
        tap = true; 
        dwt = true;
        natural-scroll = true;
        accel-profile = "adaptive";
      };
      
      mouse = {
        accel-profile = "flat";
      };
    };

    layout = {
      gaps = 12;      
      center-focused-column = "never";
      default-column-width = { proportion = 0.5; }; 
      focus-ring = {
        enable = true;
        width = 3; 
      };

      border = {
        enable = false;
        width = 2;
      };
    };

    spawn-at-startup =[      
      { command = [ "noctalia-shell" ]; }
      { command = ["xwayland-satellite"]; }
      { command = [ "systemctl" "--user" "start" "hyprpolkitagent" ]; }
    ];
    window-rules =[
      {
        matches =[
          { app-id = "^pavucontrol$"; }
          { app-id = "^nm-connection-editor$"; }
          { app-id = "^blueman-manager$"; }
          { title = "^Open File$"; }
        ];
        open-floating = true;
      }
    ];
    };

    programs.niri.settings.binds = {
      "Mod+T".action.spawn = "ghostty";
      "Mod+S".action.spawn =[ "noctalia-shell" "ipc" "call" "launcher" "toggle" ];
      "Mod+Escape".action.spawn =[ "noctalia-shell" "ipc" "call" "lockScreen" "lock" ];
      "Mod+Shift+Slash".action.show-hotkey-overlay = {};
      "Mod+Shift+E".action.quit = {};
      "Mod+Shift+P".action.power-off-monitors = {};

      "Mod+Q".action.close-window = {};
      "Mod+F".action.maximize-column = {};
      "Mod+Shift+F".action.fullscreen-window = {};
      "Mod+C".action.center-column = {};
      "Mod+Comma".action.consume-window-into-column = {};
      "Mod+Period".action.expel-window-from-column = {};

      "Mod+V".action.toggle-window-floating = {};
      "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = {};

      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Equal".action.set-column-width = "+10%";
      "Mod+Shift+Minus".action.set-window-height = "-10%";
      "Mod+Shift+Equal".action.set-window-height = "+10%";
      "Mod+R".action.switch-preset-column-width = {};
      "Mod+Shift+R".action.switch-preset-window-height = {};
      "Mod+Ctrl+R".action.reset-window-height = {};

      "Mod+Left".action.focus-column-left = {};
      "Mod+Right".action.focus-column-right = {};
      "Mod+Up".action.focus-window-up = {};
      "Mod+Down".action.focus-window-down = {};

      "Mod+H".action.focus-column-left = {};
      "Mod+L".action.focus-column-right = {};
      "Mod+K".action.focus-window-up = {};
      "Mod+J".action.focus-window-down = {};

      "Mod+Home".action.focus-column-first = {};
      "Mod+End".action.focus-column-last = {};

      "Mod+Ctrl+Left".action.move-column-left = {};
      "Mod+Ctrl+Right".action.move-column-right = {};
      "Mod+Ctrl+Up".action.move-window-up = {};
      "Mod+Ctrl+Down".action.move-window-down = {};

      "Mod+Ctrl+H".action.move-column-left = {};
      "Mod+Ctrl+L".action.move-column-right = {};
      "Mod+Ctrl+K".action.move-window-up = {};
      "Mod+Ctrl+J".action.move-window-down = {};

      "Mod+Shift+Left".action.focus-monitor-left = {};
      "Mod+Shift+Right".action.focus-monitor-right = {};
      "Mod+Shift+Up".action.focus-monitor-up = {};
      "Mod+Shift+Down".action.focus-monitor-down = {};

      "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = {};
      "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = {};
      "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = {};
      "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = {};

      "Mod+Page_Down".action.focus-workspace-down = {};
      "Mod+Page_Up".action.focus-workspace-up = {};
      "Mod+U".action.focus-workspace-down = {};
      "Mod+I".action.focus-workspace-up = {};

      "Mod+Shift+Page_Down".action.move-column-to-workspace-down = {};
      "Mod+Shift+Page_Up".action.move-column-to-workspace-up = {};
      "Mod+Shift+U".action.move-column-to-workspace-down = {};
      "Mod+Shift+I".action.move-column-to-workspace-up = {};

      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;

      "Mod+Shift+1".action.move-column-to-workspace = 1;
      "Mod+Shift+2".action.move-column-to-workspace = 2;
      "Mod+Shift+3".action.move-column-to-workspace = 3;
      "Mod+Shift+4".action.move-column-to-workspace = 4;
      "Mod+Shift+5".action.move-column-to-workspace = 5;
      "Mod+Shift+6".action.move-column-to-workspace = 6;
      "Mod+Shift+7".action.move-column-to-workspace = 7;
      "Mod+Shift+8".action.move-column-to-workspace = 8;
      "Mod+Shift+9".action.move-column-to-workspace = 9;

      "XF86AudioRaiseVolume".action.spawn =[ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" ];
      "XF86AudioLowerVolume".action.spawn =[ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-" ];
      "XF86AudioMute".action.spawn =[ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
      "XF86AudioMicMute".action.spawn =[ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];

      "Print".action.screenshot = {};
      "Ctrl+Print".action.screenshot-screen = {};
      "Alt+Print".action.screenshot-window = {};
    };
}
