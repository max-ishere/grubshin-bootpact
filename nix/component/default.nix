{
  stdenv,
  runCommand,
  grub2,
  lib,
  svg,
  colors,
  grubTheme,
}: let
  bootMenu = import ./boot-menu.nix {
    inherit lib colors;
    inherit (svg) renderIcons renderBox;
  };

  font = import ./font.nix {
    inherit lib grub2 stdenv;
  };

  image = import ./image.nix {
    inherit (svg) render;
  };
in {
  inherit bootMenu font image;
  bundleThemeTxtAssets = import ./bundle-theme-txt-assets.nix {
    inherit runCommand lib image bootMenu font grubTheme;
  };
}
