{pkgs, ...}: {
  fonts.packages = with pkgs; [
    # icon fonts
    material-design-icons
    font-awesome

    # nerdfonts
    nerd-fonts.symbols-only
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];
}
