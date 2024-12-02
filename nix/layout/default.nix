{
  hywenhei-extended-font,
  lib,
  grubTheme,
  component,
  colors,
  colorscheme,
}: let
in {
  classic = import ./classic {inherit lib hywenhei-extended-font component grubTheme colors colorscheme;};
  teleport = import ./teleport {inherit lib hywenhei-extended-font component grubTheme colors colorscheme;};
}
