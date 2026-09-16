# Installation instructions

> [!CAUTION]
> Before installation on hardware it is recommended to practice in a VM and having a rescue USB stick ready with your
> Linux distribution. Theme installation is a safe process if done right, but better be safe than sorry.

> [!TIP]
> If you want to see how the theme looks before you install it, there are some methods to do so in
> [showcase](SHOWCASE.md#previewing-the-themes).

## NixOS (Flakes)

1. Add this repo as a flake input.
2. Set [`boot.loader.grub.theme`](https://search.nixos.org/options?channel=24.11&show=boot.loader.grub.theme&from=0&size=50&sort=relevance&type=packages&query=boot.loader.grub+theme) 

   ```nix
   { inputs, ... }: {
      boot.loader.grub.theme = let
        colorsheme = "night";
        layout = "teleport";
        resolution = "1920x1080";
      in inputs.grubshin-bootpact.${colorsheme}.${layout}.${resolution};
   }
   ```

## Other Linux distributions

1. Download a [release from GitHub](https://github.com/max-ishere/grubshin-bootpact/releases/latest).
2. If you have not installed themes before, you might have to [enable themes in GRUB](#enable-themes)
3. The release is a single zip with all the theme variants inside. Extract it somewhere and copy the variants you like
   to `/boot/grub/themes/`*`variant`*.

> [!NOTE]
> GRUB is usually installed on a separate partition on your disk. This partition is then usually mounted at `/boot`.
> GRUB itself may however be located at `/boot/grub2` (GRUB v2 is the current version).
>
> It is also possible that you are using a different bootloader such as `refind`, `systemd-boot`, etc. This theme is
> not going to work with those other bootloaders.

4. Update the `GRUB_THEME` variable in `/etc/default/grub` to point to `/boot/grub/themes/`*`variant`*`/theme.txt`.
5. Run `grub-mkconfig -o /boot/grub/grub.cfg`. This will update the config file loaded by GRUB during boot based on the
   values in `/etc/default/grub`.

You can now reboot your system and check out your new theme.

There is a known issue with UKI setups using the `uki` GRUB command. See the [Icons for UKI entries](#icons-for-uki-entries)
section for steps to work around the GRUB limitations.

## Enable themes

GRUB by default is not configured to use themes. `grub-mkconfig` will tell you a theme was found, but GRUB doesn't try
to use it.

Here are the settings you have to replace, and if they are not present in the config then add them in. This is a
reference I used to come up with this list:
[GRUB Manual: Simple configuration](https://www.gnu.org/software/grub/manual/grub/grub.html#Simple-configuration),
it explains all the options. There is also a YouTube video that helped me to set this up:
[Broodie Robertson: Try A Grub Theme ...](https://youtu.be/smkzKmrtza4)

Add these to your `/etc/default/grub` file. It should contain some settings already, each on their own line so just add
these at the end of the file. This file is actually a shell script so whatever is the last assignment to a variable is
its final value.

- `GRUB_TIMEOUT=5` and `GRUB_TIMEOUT_STYLE=menu` are required for you to see the themed bootloader.
- `GRUB_TERMINAL_OUTPUT=gfxterm` makes GRUB use the graphical terminal
- `GRUB_GFXMODE="1920x1080,auto"`. You can set as many resolutions as you want and GRUB will go down the list trying
  each. The last one should be `auto` because it will use whatever your firmware supports. Read the docs for details on
  this one.
  
> [!TIP]
> Set GFX mode to `auto` to prevent screen flicker on during boot. To see the default resolution for your firmware,
> reboot into GRUB, press <kbd>c</kbd> and type `videoinfo`.

- `GRUB_GFXPAYLOAD_LINUX=keep` Makes the linux kernel use the same graphics mode as set in `GRUB_GFXMODE` variable.
- And of course `GRUB_THEME="/boot/grub/themes/grubshin-bootpact/theme.txt"`

Here is a sample of what it should look like:

**/etc/default/grub**

```sh
# Simply add this to the end so you can roll back to previous values

GRUB_TIMEOUT=5
GRUB_TIMEOUT_STYLE=menu
GRUB_TERMINAL_OUTPUT=gfxterm
GRUB_GFXMODE="1920x1080,auto"
GRUB_GFXPAYLOAD_LINUX=keep
# Set what variant you want here
GRUB_THEME="/boot/grub/themes/grubshin-bootpact/theme.txt"
```

## Icons for UKI entries

UKI stands for [Unified Kernel Image](https://wiki.archlinux.org/title/Unified_kernel_image). It is a type of `.efi`
file that stores the kernel, initramfs and the kernel command-line in one file. GRUB has support for auto-discovering
these files using the [`uki` command](https://www.gnu.org/software/grub/manual/grub/html_node/uki.html).

Based on the test in [Issue #16](https://github.com/max-ishere/grubshin-bootpact/issues/16), the `uki` command generates
menu entries of the following format at boot time:

```shell
chainloader <path to UKI> <kernel command-line>
```

Unfortunately, such generated entries do not include any class (icon name) specification and GRUB does not seem to have
any default class defined:

- [Theme file format#Boot Menu](https://www.gnu.org/software/grub/manual/grub/html_node/Theme-file-format.html#Boot-Menu)
- [`menuentry` command](https://www.gnu.org/software/grub/manual/grub/html_node/menuentry.html)

Although this [GRUB tutorial](https://web.archive.org/web/20230719032327/http://wiki.rosalab.ru/en/index.php/Grub2_theme_tutorial)
mentions the `os` class as the default, it seems to be more of a convention to include the `--class os` code in the
`/etc/grub.d/` files rather than an actual fallback in the GRUB code.

However, this can be worked around relatively easily. Based on the
[`chainloader` command docs](https://www.gnu.org/software/grub/manual/grub/html_node/Chain_002dloading.html),
it is possible to wrap this definition in a `menuentry`. So, you can just define a styled version of the UKIs you use.
Here's an example of how to modify the default config on Arch Linux:

**/etc/grub.d/15_uki**

```shell
#! /bin/sh
set -e

cat << EOF
if [ "\$grub_platform" = "efi" ]; then
  # Manually declare the entries that should have the icon
  menuentry "Arch Linux" --class arch {
    chainloader (hd0,gpt1)/EFI/Linux/arch-linux.efi
  }

  # Have grub generate the UKI entries as well (expected to cause duplicates of chainloader items above).
  # If you don't want to see duplicates, use a `submenu` to contain all the UKIs:
  # https://www.gnu.org/software/grub/manual/grub/html_node/submenu.html
  uki
fi
EOF
```

On other distributions, the file name and location may be different.

The title can be changed from `"Arch Linux"` to any custom text. The `--class` value controls the icon used for the entry.
The list of supported icons can be checked in the `icons/` folder of the theme or in the [[./svg/icons/]] folder of this
repository.

The path to the EFI file generally uses this format: `(<disk>,<partition>)/EFI/Linux/<file.efi>`. The easiest way to
check the `disk` and `partition` values is using the <kbd>e</kbd> key while in GRUB.

You could also wrap the `uki` in a `menuentry` (just like the `chainloader`), which would apply the same title and class
to all the generated items. Unfortunately, `menuentry` must overwrite the title of all wrapped entries, so the title
embedded in the UKI file will be disregarded using this method.

Depending on the setup, the `uki` command can be completely removed and replaced with manual UKI file definitions.

## Uninstalling

1. Update or remove `GRUB_THEME`.
2. Remove the directories associated with the theme from `/boot/grub/themes`
