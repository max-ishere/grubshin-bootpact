{
  writeText,
  lib,
  colors,
}:
writeText "style.css" (builtins.concatStringsSep "\n"
  (lib.mapAttrsToList (name: color: ''
      .${name}-fill {
          fill: ${color};
      }

      .${name}-stroke {
          stroke: ${color};
      }

      .${name}-stop-opaque {
        stop-color: ${color};
        stop-opacity: 1;
      }

      .${name}-stop-transparent {
        stop-color: ${color};
        stop-opacity: 0;
      }
    '')
    colors))
