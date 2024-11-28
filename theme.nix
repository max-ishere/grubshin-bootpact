{
  mkGrubThemeTxt,
  lib,
}: {fontSize}: let
  mkComponent = type: config: {${type} = config;};

  rel = percent: num: let
    pstr = lib.optionalString (percent != 0) "${builtins.toString (builtins.floor percent)}%";
    sign = lib.optionalString (percent != 0) (
      if num > 0
      then "+"
      else "" # minus is handeled by toString
    );
    nstr = lib.optionalString (num != 0) "${builtins.toString (builtins.floor num)}";
  in "${pstr}${sign}${nstr}";

  irel = percent: num: rel percent (-num);
  percent = value: "${builtins.toString (builtins.floor value)}%";

  # Takes a list a of functions like lib.pipe, but the result is recursively merged with the args.
  incrementalUpdate = mods:
    lib.pipe {}
    (builtins.map
      (mod: args: lib.recursiveUpdate args (mod args))
      mods);

  # Constructs the layout incrementally. The space occupied by the previous element is recorded in the args attrs
  layout =
    (incrementalUpdate [
      ({top ? 0, ...}: let
        width = 330;
        height = 100;
        padding = 20;
      in {
        top = top + height + padding;

        out.logo = {
          left = irel 50 (width / 2);
          top = top + padding;
          inherit width height;
        };
      })

      ({bottom ? 0, ...}: let
        elements = {
          width = 350;
          height = 47;
          padding = 15;
        };

        line = {
          height = 16;
          top = irel 100 (bottom + elements.padding + (elements.height - line.height) / 2 + line.height);
          padding = 5;
          relWidth = elements.width / 2 + line.padding + elements.padding;
          width = irel 50 line.relWidth;
        };
      in {
        bottom = bottom + elements.height + elements.padding;

        out.elements = {
          left = irel 50 (elements.width / 2);
          top = irel 100 (bottom + elements.height + elements.padding);
          inherit (elements) width height;
        };

        out.line-left = {
          left = 0;
          inherit (line) top height width;
        };

        out.line-right = {
          left = rel 50 line.relWidth;
          inherit (line) top height width;
        };
      })

      ({bottom ? 0, ...}: let
        lines = 3;
        spacing = 1.5;
        padding = 20;
        height = fontSize * spacing;
      in {
        bottom = bottom + padding + height * lines;

        out.tooltips =
          builtins.genList (
            fromBottom: let
              i = lines - fromBottom;
            in {
              left = percent 0;
              width = percent 100;
              top = irel 100 (bottom + padding + height * i);
              height = fontSize;
            }
          )
          lines;
      })

      ({bottom ? 0, ...}: let
        padding = fontSize;
      in {
        bottom = bottom + padding + fontSize;

        out.countdown = {
          left = percent 0;
          width = percent 100;
          top = irel 100 (bottom + padding + fontSize);
          height = fontSize;
        };
      })

      ({
        top,
        bottom,
        ...
      }: let
        hpad = 15;
        vpad = 5;
      in {
        out.menu = {
          left = percent hpad;
          width = percent (100 - hpad * 2);
          top = top + vpad;
          height = irel 100 (top + bottom + vpad * 2);
        };
      })
    ])
    .out;

  logo = mkComponent "image" (layout.logo // {file = "grubshin-bootpact.png";});

  menu = mkComponent "boot_menu" (layout.menu
    // {
      item_font = "HYWenHei ${builtins.toString fontSize}";
      item_color = "#bbbbbb";
      item_height = 64;
      item_padding = 20;
      item_spacing = 40;

      selected_item_color = "white";
      selected_item_pixmap_style = "highlight-box/*.png";

      icon_width = 64;
      icon_height = 64;
      item_icon_space = 40;
    });

  countdown = mkComponent "label" (layout.countdown
    // {
      font = "HYWenHei ${builtins.toString fontSize}";
      color = "white";
      align = "center";
      id = "__timeout__";
      text = "Booting selected entry in %d";
    });

  instructionsMultiline =
    lib.imap0 (i: text:
      mkComponent "label" ((builtins.elemAt layout.tooltips i)
        // {
          inherit text;
          color = "#bbbbbb";
          align = "center";
        }))
    (builtins.split "\n" ''
      Use the ↑ and ↓ keys to select an entry. Press enter to
      boot the selected OS, 'e' to edit the commands before booting,
      'c' for a command-line and ESC to return to previous menu.
    '');

  # Ordered by Z index: first is top
  progressBar = [
    # Mask that blacks out everything but the 7 elements
    (mkComponent "image" (layout.elements // {file = "seven-elements.png";}))

    # Progress bar for highlighting the 7 elements
    (mkComponent "progress_bar" (layout.elements
      // {
        id = "__timeout__";
        text = ""; # Explicit setting

        fg_color = "white";
        bg_color = "#333333";
        border_color = "black";
      }))

    # That line at the bottom of the loading screen
    (mkComponent "image" (layout.line-left // {file = "line.png";}))
    (mkComponent "image" (layout.line-right // {file = "line.png";}))
  ];
in
  mkGrubThemeTxt {
    globalProperties = {
      title-text = "";
      terminal-left = "${builtins.toString terminalPaddingPercent}%";
      inherit terminal-top;
      terminal-width = "${builtins.toString (100 - terminalPaddingPercent * 2)}%";
      terminal-height = "${builtins.toString (100 - terminalPaddingPercent)}%-${builtins.toString terminal-top}";
      terminal-font = "HYWenHei ${builtins.toString fontSize}";
      desktop-color = "black";
    };

    components =
      [
        logoImage
        bootMenu
        countdownLabel
      ]
      ++ instructionsMultiline
      ++ progressBar;
  }
