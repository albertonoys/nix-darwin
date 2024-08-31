{ user, config, pkgs, ... }:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config"; in
{
  "${xdg_configHome}/linearmouse/linearmouse.json".source = ./config/linearmouse/linearmouse.json;
}
