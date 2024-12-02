{
  stdenv,
  resvg,
  lib,
  stylesheet,
}: {
  src,
  name ? "box",
}:
stdenv.mkDerivation {
  inherit name src;
  buildInputs = [resvg];
  buildPhase = let
    argsFor = id:
      lib.cli.toGNUCommandLineShell {} {
        export-id = id;
        inherit stylesheet;
      };
  in
    ''
      mkdir -p "$out"
    ''
    + builtins.concatStringsSep "\n" (builtins.map (id: ''
      resvg ${argsFor id} ./box.svg "$out/${id}.png"
    '') ["nw" "n" "ne" "w" "c" "e" "sw" "s" "se"]);
}
