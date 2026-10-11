# Link files from dotfiles/<app>/ into ~/.config/<app>/ as out-of-store
# symlinks, so edits in the repo apply without a rebuild. Files are linked one
# by one (not whole directories) so apps can keep writing their own state next
# to them without it landing in the repo.
{
  config,
  lib,
  ...
}: let
  src = ../../dotfiles;
  repo = "${config.my.repoDir}/dotfiles";
  link = rel: config.lib.file.mkOutOfStoreSymlink "${repo}/${rel}";

  # nvim is linked as a whole directory below; zsh/p10k.zsh is read by the zsh plugin.
  skip = ["nvim" "zsh"];
  apps = lib.filter (name: !(lib.elem name skip)) (lib.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir src)));

  filesOf = app:
    map (path: lib.removePrefix "${toString src}/" (toString path)) (lib.filesystem.listFilesRecursive (src + "/${app}"));
in {
  xdg.configFile =
    lib.genAttrs (lib.concatMap filesOf apps) (rel: {source = link rel;})
    // {
      # Whole directory, so new lua files and lazy-lock.json updates land in the repo.
      nvim.source = link "nvim";
    };
}
