{
  config,
  lib,
  ...
}: let
  user = config.system.primaryUser;
  home = "/Users/${user}";
in {
  system.stateVersion = 5;
  system.checks.verifyNixPath = false;
  documentation.enable = false;

  users.users.${user} = {
    name = user;
    inherit home;
    isHidden = false;
    description = user;
    shell = lib.mkForce "${home}/.nix-profile/bin/fish";
  };

  networking.computerName = config.networking.hostName;
  system.defaults.smb.NetBIOSName = config.networking.hostName;

  programs.fish.enable = true;
  environment.variables.EDITOR = "nvim";
  environment.shells = ["${home}/.nix-profile/bin/fish"];
}
