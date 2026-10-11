{config, ...}: {
  # Shared by fish and zsh (via home-manager's session-vars file).
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.bun/bin"
  ];
  home.sessionVariables = {
    NH_FLAKE = config.my.repoDir; # `nh darwin switch` works from any directory
    NH_SHOW_ACTIVATION_LOGS = "1";
    AGY_CLI_DISABLE_AUTO_UPDATE = "1";
  };

  home.shellAliases = {
    ".." = "cd ..";
    aliasList = "alias | bat --paging=never --wrap=never --language=fish";
    ding = "tput bel";

    ls = "eza --oneline --all --group-directories-first";
    ll = "eza --long --all --sort=modified --group-directories-first --header --smart-group --git --color=always --icons=always";
    tree = "eza --tree --all --icons=auto";

    "gc." = "git checkout .";
    gd = "git diff | bat --language diff";
    gg = "lazygit";
    gs = "git status";
    is = "git status";

    v = "nvim";
    top = "btop";

    cdd = "builtin cd"; # original cd, since fish abbreviates cd to z
  };
}
