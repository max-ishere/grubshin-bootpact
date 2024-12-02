{
  lib,
  renderIcons,
  renderBox,
  colors,
}: {
  icons ? null,
  iconSize ? null,
  itemBox ? null,
  selectedItemBox ? null,
}: {
  component =
    # TODO: Add null value stripping to grub-theme.nix
    {
      icon_width = iconSize;
      icon_height = iconSize;
      item_height = iconSize;

      selected_item_color = colors.text;
      item_color = colors.medium;

      item_pixmap_style = lib.optionalString (itemBox != null) "box/*.png";
      selected_item_pixmap_style = lib.optionalString (selectedItemBox != null) "box-selected/*.png";
    };

  assets =
    (lib.optional (icons != null) (renderIcons {
      src = icons;
      width = iconSize;
      height = iconSize;
    }))
    ++ (lib.optional (itemBox != null)
      (renderBox {
        src = itemBox;
        name = "box";
      }))
    ++ (
      lib.optional (selectedItemBox != null)
      (renderBox {
        src = selectedItemBox;
        name = "box-selected";
      })
    );
}
