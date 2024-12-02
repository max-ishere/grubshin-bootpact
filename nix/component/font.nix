{
  stdenv,
  grub2,
  lib,
}: {
  src,
  family,
  size,
  range ? null,
  bold ? false,
  ascent ? null,
  descent ? null,
}: {
  component = {
    inherit size family;
    __toString = self: "${family} ${
      if bold
      then "Bold"
      else "Regular"
    } ${builtins.toString size}";
  };

  assets = [
    (let
      args = lib.cli.toGNUCommandLineShell {} {
        inherit bold size range;
        asce = ascent;
        desc = descent;
        name = family;
      };
    in
      stdenv.mkDerivation {
        inherit src;
        name = "${family}-${builtins.toString size}.pf2";
        buildInputs = [grub2];
        dontUnpack = true;
        buildPhase = ''
          mkdir -p "$(dirname "$out")"
          grub-mkfont ${args} --output="$out" "${src}"
        '';
      })
  ];
}
