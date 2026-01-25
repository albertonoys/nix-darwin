{...}: {
  home.shellAliases = {
    ".." = "cd ..";
    rld = "source ~/.config/fish/config.fish";
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

    vim = "nvim";
    v = "nvim";
    top = "btop";

    config-nix = "cursor ~/repos/nix &";
    c = "cursor . &";

    # backup alias for original cd
    cdd = "builtin cd"; # backup for original cd command
  };
}
