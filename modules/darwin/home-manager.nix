{ config, pkgs, lib, home-manager, ... }:

let
  user = "noys";
  sharedFiles = import ../shared/files.nix { inherit user config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
   ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
        ];

        stateVersion = "23.11";
      };
      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    { path = "${pkgs.kitty}/Applications/Kitty.app/"; }
    { path = "/Applications/Google Chrome.app/"; }
    { path = "/System/Applications/Mail.app/"; }
    { path = "/Applications/Cursor.app/"; }
    { path = "/Applications/Zed.app/"; }
    { path = "${pkgs.vscode}/Applications/Visual Studio Code.app/"; }
    { path = "${config.users.users.${user}.home}/Applications/Keybr.app/"; }
    { path = "${config.users.users.${user}.home}/Applications/Monkeytype.app/"; }
    { path = "${pkgs.discord}/Applications/Discord.app/"; }
    { path = "/System/Applications/System Settings.app/"; }
    {
      path = "${config.users.users.${user}.home}/.config/";
      section = "others";
      options = "--sort name --view grid --display folder";
    }
  ];

}
