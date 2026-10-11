_: {
  programs.neovim = {
    defaultEditor = true;
    vimAlias = true;
    # init.lua comes from dotfiles/nvim; load HM's generated lua via the wrapper instead.
    sideloadInitLua = true;
  };
}
