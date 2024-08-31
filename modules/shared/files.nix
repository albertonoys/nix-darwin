{ user, config, pkgs, ... }:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";

  # Function to recursively read files from a directory
  readNvimConfig = dir:
    builtins.mapAttrs (name: type:
      if type == "regular" then { text = builtins.readFile (dir + "/${name}"); }
      else if type == "directory" then readNvimConfig (dir + "/${name}")
      else null
    ) (builtins.readDir dir);

  # Read all Neovim config files
  nvimConfig = readNvimConfig ./config/nvim;

  # Function to flatten the nested attribute set
  flattenAttrs = prefix: attrs:
    builtins.foldl' (acc: name:
      let value = attrs.${name};
      in if builtins.isAttrs value && !(builtins.hasAttr "text" value)
         then acc // (flattenAttrs (prefix + "${name}/") value)
         else acc // { "${prefix}${name}" = value; }
    ) {} (builtins.attrNames attrs);

  # Flatten the Neovim config
  flatNvimConfig = flattenAttrs "${xdg_configHome}/nvim/" nvimConfig;

in
{
  "${xdg_configHome}/btop/btop.conf".source = ./config/btop/btop.conf;

  "${xdg_configHome}/kitty/kitty.conf".source = ./config/kitty/kitty.conf;

  "${xdg_configHome}/kitty/ayu_mirage.conf".source = ./config/kitty/ayu_mirage.conf;

  "${xdg_configHome}/zed/settings.json" = {
    text = ''
      {
        "base_keymap": "JetBrains",
        "ui_font_family": "Menlo",
        "ui_font_size": 14,
        "buffer_font_size": 14,
        "buffer_font_family": "Menlo",
        "buffer_font_features": {
          "calt": true
        },
        "confirm_quit": true,
        "autosave": "on_focus_change",
        "telemetry": {
          "diagnostics": true,
          "metrics": false
        },
        "preferred_line_length": 120
      }
    '';
  };
} // flatNvimConfig
