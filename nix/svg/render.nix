{
  runCommand,
  lib,
  resvg,
  stylesheet,
}: {
  src,
  name,
  width ? null,
  height ? null,
}:
runCommand "${name}.png" {} (let
  args = lib.cli.toGNUCommandLineShell {} {
    inherit width height stylesheet;
  };
in ''
  mkdir -p "$(dirname "$out")"
  ${lib.getExe resvg} ${args} "${src}" "$out"
'')
