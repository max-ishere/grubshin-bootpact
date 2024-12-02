{
  stdenv,
  runCommand,
  writeText,
  grub2,
  lib,
  resvg,
  grubTheme,
  hywenhei-extended-font,
}:
builtins.mapAttrs (_: colors: let
  svg = import ./svg {inherit stdenv runCommand lib resvg colors writeText;};
  component = import ./component {
    inherit stdenv runCommand lib grub2 colors svg grubTheme;
  };
in {
  inherit svg component;
  layout = import ./layout {
    inherit lib component grubTheme colors hywenhei-extended-font;
  };
})
(import ./colorschemes.nix)
