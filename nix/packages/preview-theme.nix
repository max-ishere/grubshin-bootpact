{
  grubTheme,
  src,
  lib,
  resolution ? "1920x720",
}:
grubTheme.mkGrubThemePreview {
  inherit src resolution;
  name = "grubshin-bootpact";
  menuentries = builtins.map (png: let
    class = lib.removeSuffix ".svg" png;
  in {
    name = "class: ${class}";
    inherit class;
  }) (builtins.attrNames (builtins.readDir ../../svg/icons));
}
