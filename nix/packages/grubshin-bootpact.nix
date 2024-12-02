{
  theme,
  grubTheme,
  lib,
}: let
in
  builtins.mapAttrs (_: colorscheme:
    builtins.mapAttrs (_: layout:
      builtins.mapAttrs (resolution: drv:
        drv
        // {
          preview-theme = import ./preview-theme.nix {
            inherit grubTheme lib resolution;
            src = drv;
          };
        })
      layout)
    colorscheme.layout)
  theme
