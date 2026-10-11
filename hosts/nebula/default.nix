# nebula: personal MacBook. Identity and anything specific to this machine.
{
  imports = [../../modules/darwin];

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "nebula";
  system.primaryUser = "noys";

  home-manager.users.noys.programs.git.settings.user = {
    name = "Alberto Noys";
    email = "albertonoys@gmail.com";
  };
}
