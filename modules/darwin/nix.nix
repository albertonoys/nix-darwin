{config, ...}: {
  # Determinate Nix manages the daemon and /etc/nix/nix.conf, so nix-darwin's
  # nix module must stay off (and `nix.settings` would be ignored). Extra
  # settings go in nix.custom.conf, which nix.conf `!include`s.
  nix.enable = false;
  environment.etc."nix/nix.custom.conf" = {
    text = ''
      trusted-users = root ${config.system.primaryUser}
      download-buffer-size = 1073741824
    '';
    # Hash of the stub the Determinate installer writes, so nix-darwin can take it over.
    knownSha256Hashes = ["3bd68ef979a42070a44f8d82c205cfd8e8cca425d91253ec2c10a88179bb34aa"];
  };

  nixpkgs.config.allowUnfree = true;
}
