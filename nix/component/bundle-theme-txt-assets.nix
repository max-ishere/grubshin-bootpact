{
  runCommand,
  lib,
  image,
  bootMenu,
  font,
  grubTheme,
}: name: genAssets: genThemeTxt: let
  bundle = genAssets {inherit image bootMenu font;};

  assets = builtins.listToAttrs (builtins.map (asset: {
    inherit (asset) name;
    value = asset.outPath;
  }) (lib.flatten (lib.mapAttrsToList (_: item: item.assets) bundle)));

  components = builtins.mapAttrs (_: value: value.component) bundle;

  copyCommands =
    lib.mapAttrsToList
    (name: path: ''
      mkdir -p "$out"
      cd "$out"
      mkdir -p "$(dirname ${lib.escapeShellArg "${name}"})"
      cp -rL ${lib.escapeShellArg "${path}"} ${lib.escapeShellArg "${name}"}
    '')
    assets;
in
  runCommand name {} ''
    mkdir -p "$out"
    echo -n ${lib.escapeShellArg (grubTheme.mkGrubThemeTxt (genThemeTxt components))} > $out/theme.txt
    ${builtins.concatStringsSep "\n" copyCommands}
  ''
