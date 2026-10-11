{
  config,
  inputs,
  ...
}: {
  imports = [inputs.home-manager.darwinModules.home-manager];

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "nixbckp";
    extraSpecialArgs = {inherit inputs;};
    users.${config.system.primaryUser}.imports = [../home];
  };
}
