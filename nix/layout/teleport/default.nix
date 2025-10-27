{
  lib,
  hywenhei-extended-font,
  grubTheme,
  component,
  colors,
  colorscheme,
}: let
  inherit (grubTheme) mkComponent rel irel percent;
  resoltions = import ./resolutions {inherit hywenhei-extended-font;};
in
  lib.flip lib.mapAttrs resoltions (resolution: {
    menu,
    line,
    elements,
    fonts,
  }: let
    layout = import ./layout.nix {inherit grubTheme lib line menu elements fonts;};
  in
    component.bundleThemeTxtAssets "teleport-${colorscheme}-${resolution}"
    ({
      image,
      font,
      bootMenu,
      ...
    }: {
      menu = bootMenu menu;
      line = image line;
      elements = image elements;
      normalFont = font fonts.normal;
      headerFont = font fonts.header;
    })
    ({
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
      components = let
        # Puts the start of the boot entry label in a nice spot relative to the tip text below it
        menuCenterOffsetLeft = 300;
      in
        [
          (mkComponent "boot_menu" (menu
            // layout.menu
            // {
              # For some reason we have to move the next item really down so its not rendered
              item_spacing = 99999;

              # Hide the text
              item_color = colors.background;
              selected_item_color = colors.background;
            }))

          (mkComponent "label" (layout.countdown
            // {
              id = "__timeout__";
              text = "Booting selected entry in %d";
              font = headerFont;
              color = colors.bright;
              align = "center";
            }))

          # This progress bar covers up the second boot menu where the title of the selected entry is displayed.
          # If it is not present, or not sized to cover the boot menu, you will see both the entry title and the boot
          # countdown in the same place.
          (mkComponent "progress_bar" (
            layout.countdown
            // {
              left = irel 50 menuCenterOffsetLeft;
              width = rel 50 menuCenterOffsetLeft;
              height = headerFont.size;

              id = "__timeout__";
              text = "";

              fg_color = colors.background;
              bg_color = colors.background;
              border_color = colors.background;
            }
          ))

          (mkComponent "boot_menu" (
            layout.countdown
            // {
              left = irel 50 menuCenterOffsetLeft;
              width = rel 50 menuCenterOffsetLeft;

              icon_width = 0;
              icon_height = 0;

              item_height = headerFont.size;
              item_padding = 0;

              selected_item_font = headerFont;

              selected_item_color = colors.text;

              # For some reason we have to move the next item really down so its not rendered
              item_spacing = 99999;
            }
          ))
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
          (mkComponent "image" (elements // layout.elements))
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
