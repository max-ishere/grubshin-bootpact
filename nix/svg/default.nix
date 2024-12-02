{
  stdenv,
  runCommand,
  writeText,
  lib,
  resvg,
  colors,
}: let
  stylesheet = import ./stylesheet.nix {inherit writeText lib colors;};
in {
  render = import ./render.nix {inherit runCommand resvg lib stylesheet;};
  renderBox = import ./render-box.nix {
    inherit stdenv resvg lib stylesheet;
  };
  renderIcons = import ./render-icons.nix {
    inherit lib resvg stylesheet stdenv;
  };
}
