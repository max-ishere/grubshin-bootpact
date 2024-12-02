{
  linkFarmFromDrvs,
  lib,
  grubshin-bootpact,
}: let
  collect = lib.flip lib.mapAttrsToList;

  resolutionsList = _: builtins.attrValues;
  layoutsList = _: layout: lib.flatten (collect layout resolutionsList);
  colorschemesList = colorschemes: lib.flatten (collect colorschemes layoutsList);
in
  linkFarmFromDrvs "release" (colorschemesList grubshin-bootpact)
