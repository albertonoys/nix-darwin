{
  name,
  useremail,
  ...
}: {
  programs.git = {
    enable = true;
    ignores = [
      "*.swp"
      "**/.DS_Store"
    ];
    userName = name;
    userEmail = useremail;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
        autocrlf = "input";
        pager = "delta";
      };
      pull.rebase = true;
      rebase.autoStash = true;
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
      };
      merge.conflictstyle = "diff3";
      diff = {
        colorMoved = "default";
      };
    };
  };
}
