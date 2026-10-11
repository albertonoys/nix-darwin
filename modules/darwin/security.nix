{config, ...}: let
  user = config.system.primaryUser;
in {
  security.pam.services.sudo_local.touchIdAuth = true;

  # Passwordless sudo only for what `darwin-rebuild switch` shells out to, so
  # rebuilds work unattended (e.g. docked with the lid closed, no Touch ID).
  # Homebrew cask upgrades that ship .pkg installers need installer/pkgutil. If
  # a cask still prompts, find the binary next to its `Upgrading <cask>` line
  # and add it here.
  security.sudo.extraConfig = ''
    ${user} ALL=(ALL) NOPASSWD: /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings
    ${user} ALL=(ALL) NOPASSWD: /usr/sbin/installer
    ${user} ALL=(ALL) NOPASSWD: /usr/bin/pkgutil
  '';
}
