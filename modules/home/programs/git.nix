_: {
  programs.git = {
    enable = true;
    ignores = [
      "*.swp"
      "**/.DS_Store"
    ];
    lfs.enable = true;
    settings = {
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
      merge.conflictstyle = "zdiff3";
      diff.colorMoved = "default";
    };
  };

  # Sets core.pager, interactive.diffFilter and installs delta.
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options.navigate = true;
  };
}
