{config, ...}: let
  user = config.system.primaryUser;
  home = "/Users/${user}";
in {
  system.stateVersion = 5;
  system.checks.verifyNixPath = false;
  documentation.enable = false;

  # home-manager reads the home directory from here. Other user attributes
  # (shell, description, ...) only apply to users in `users.knownUsers`; the
  # login shell was set once with `chsh -s ~/.nix-profile/bin/fish`.
  users.users.${user}.home = home;

  networking.computerName = config.networking.hostName;
  system.defaults.smb.NetBIOSName = config.networking.hostName;

  programs.fish.enable = true;
  environment.variables.EDITOR = "nvim";
  environment.shells = ["${home}/.nix-profile/bin/fish"];
}
