{
  stdenv,
  lib,
  resvg,
  stylesheet,
}: {
  src,
  width ? null,
  height ? null,
}:
stdenv.mkDerivation {
  inherit src;
  name = "icons";
  buildInputs = [resvg];
  buildPhase = let
    args = lib.cli.toGNUCommandLineShell {} {
      inherit width height stylesheet;
    };
  in ''
    mkdir -p "$out"

    for file in *.svg; do
      file_name=$(basename "$file" .svg)
      resvg ${args} "$file" "$out/$file_name.png"
    done
  '';
}
