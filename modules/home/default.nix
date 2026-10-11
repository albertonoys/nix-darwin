# User-level (home-manager) modules.
{
  config,
  lib,
  ...
}: {
  imports = [
    ./dotfiles.nix
    ./packages.nix
    ./programs/fish.nix
    ./programs/git.nix
    ./programs/neovim.nix
    ./programs/shell.nix
    ./programs/zsh.nix
  ];

  options.my.repoDir = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/repos/nix";
    description = "Checkout of this repo; dotfiles are symlinked from here so edits apply without a rebuild.";
  };

  config = {
    home.stateVersion = "26.05";
    # Skips the home-configuration.nix(5) man page, whose options.json build
    # triggers a "builtins.derivation ... without a proper context" warning on
    # every evaluation. Option docs: https://home-manager-options.extranix.com
    manual.manpages.enable = false;

    programs = {
      bat.enable = true;
      btop.enable = true;
      bun.enable = true;
      direnv.enable = true;
      eza.enable = true;
      fastfetch.enable = true;
      fd.enable = true;
      fzf.enable = true;
      gh.enable = true;
      home-manager.enable = true;
      jq.enable = true;
      lazygit.enable = true;
      neovim.enable = true;
      ripgrep.enable = true;
      zoxide.enable = true;
      yazi = {
        enable = true;
        settings.manager = {
          show_hidden = true;
          sort_dir_first = true;
        };
      };

      man.generateCaches = false;
    };
  };
}
