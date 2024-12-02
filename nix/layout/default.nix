{
  lib,
  component,
  grubTheme,
  colors,
  hywenhei-extended-font,
}: let
in {
  classic = import ./classic {inherit lib hywenhei-extended-font component grubTheme colors;};
  teleport = import ./teleport {inherit lib hywenhei-extended-font component grubTheme colors;};
}
