{
  lib,
  hywenhei-extended-font,
  component,
  grubTheme,
  colors,
  colorscheme,
}: let
  inherit (grubTheme) mkComponent percent;
  resoltions = import ./resolutions {inherit hywenhei-extended-font;};
in
  lib.flip lib.mapAttrs resoltions (resolution: {
    logo,
    menu,
    line,
    elements,
    fonts,
  }: let
    layout = import ./layout.nix {inherit grubTheme lib logo line elements fonts;};
  in
    component.bundleThemeTxtAssets "classic-${colorscheme}-${resolution}"
    ({
      image,
      font,
      bootMenu,
      ...
    }: {
      logo = image logo;
      menu = bootMenu menu;
      line = image line;
      elements = image elements;
      normalFont = font fonts.normal;
      headerFont = font fonts.header;
    })
    ({
      logo,
      menu,
      line,
      elements,
      normalFont,
      headerFont,
    }: {
      globalProperties = {
        title-text = "";
        desktop-color = colors.background;

        terminal-left = "0";
        terminal-top = "0";
        terminal-width = percent 100;
        terminal-height = percent 100;
      };
      components =
        [
          (mkComponent "image" (layout.logo // logo))

          (mkComponent "boot_menu" (layout.menu
            // menu
            // {
              item_font = normalFont;
              selected_item_font = headerFont;
              item_icon_space = menu.icon_width / 2;
            }))
        ]
        ++ [
          (mkComponent "label" (layout.countdown
            // {
              id = "__timeout__";
              text = "Booting selected entry in %d";
              font = headerFont;
              color = colors.bright;
              align = "center";
            }))
        ]
        ++ (lib.imap0 (i: text:
            mkComponent "label" ((builtins.elemAt layout.tooltips i)
              // {
                inherit text;
                color = colors.bright;
                font = normalFont;
                align = "center";
              }))
          (lib.splitString "\n" ''
            Use the ↑ and ↓ keys to select an entry. Press enter to
            boot the selected OS, 'e' to edit the commands before booting,
            'c' for a command-line and ESC to return to previous menu.''))
        ++ [
          (mkComponent "image" (line // layout.line-left))
          (mkComponent "image" (layout.elements // elements))
          (mkComponent "progress_bar" (layout.elements
            // {
              id = "__timeout__";
              text = "";

              fg_color = colors.elements-filled;
              bg_color = colors.elements-empty;
              border_color = colors.background;
            }))
          (mkComponent "image" (line // layout.line-right))
        ];
    }))
