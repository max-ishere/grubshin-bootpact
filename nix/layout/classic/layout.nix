{
  grubTheme,
  lib,
  logo,
  line,
  elements,
  fonts,
}: let
  inherit (grubTheme) rel irel percent;
in
  (lib.pipe {}
    (builtins.map
      (stepfn: args: let
        result = stepfn args;
      in
        lib.recursiveUpdate args result)
      [
        ({top ? 0, ...}: let
          padding = logo.height / 10; # Easiest way to scale off of the image size
        in {
          top = top + logo.height + padding;

          out.logo = {
            left = irel 50 (logo.width / 2);
            top = top + padding;
            inherit (logo) width height;
          };
        })

        ({bottom ? 0, ...}: let
          vpad = 15;
          hpad = elements.width / 2 + 20;

          lineTop = irel 100 (bottom + vpad + (elements.height - line.height) / 2 + line.height);
          lineWidth = irel 50 hpad;
        in {
          bottom = bottom + elements.height + vpad;

          out.elements = {
            left = irel 50 (elements.width / 2);
            top = irel 100 (bottom + elements.height + vpad);
            inherit (elements) width height;
          };

          out.line-left = {
            left = 0;
            width = lineWidth;
            top = lineTop;
            inherit (line) height;
          };

          out.line-right = {
            left = rel 50 hpad;
            width = lineWidth;
            top = lineTop;
            inherit (line) height;
          };
        })
        ({bottom ? 0, ...}: let
          lines = 3;
          spacing = 1.3;
          padding = 40;
          height = fonts.normal.size;
        in {
          bottom = bottom + padding + height * spacing * lines;

          out.tooltips =
            builtins.genList (
              fromBottom: let
                i = lines - fromBottom;
              in {
                left = percent 0;
                width = percent 100;
                top = irel 100 (bottom + padding + height * spacing * i);
                inherit height;
              }
            )
            lines;
        })

        ({bottom ? 0, ...}: let
          padding = fonts.normal.size;
          height = fonts.header.size;
        in {
          bottom = bottom + padding + height;

          out.countdown = {
            left = percent 0;
            width = percent 100;
            top = irel 100 (bottom + padding + height);
            inherit height;
          };
        })

        ({
          top,
          bottom,
          ...
        }: let
          hpadPercent = 15;
          vpad = 5;
        in {
          out.menu = {
            left = percent hpadPercent;
            width = percent (100 - hpadPercent * 2);
            top = top + vpad;
            height = irel 100 (top + bottom + vpad * 2);
          };
        })
      ]))
  .out
