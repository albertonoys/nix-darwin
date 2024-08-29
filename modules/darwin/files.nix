{ user, config, pkgs, ... }:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config"; in
{

  "${xdg_configHome}/linearmouse/linearmouse.json" = {
    text = builtins.readFile ./config/linearmouse/linearmouse.json;
  };
}
