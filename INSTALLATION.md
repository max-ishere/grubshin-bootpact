# Installation instructions

> [!CAUTION]
> Before installation on hardware it is recomended to practice in a VM and having a rescue USB stick ready with your
> Linux distribution. Theme installation is a safe process if done right, but better be safe than sorry.

> [!TIP]
> If you want to see how the theme looks before you install it, there are some methods to do so in
> [showcase](SHOWCASE.md).
<!-- TODO: Link to the showcase header -->

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

## Enable themes

GRUB by default is not configured to use themes. `grub-mkconfig` will tell you a theme was found, but GRUB doesnt try to
use it.

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
GRUB_THEME="/boot/grub/themes/VARIANT/theme.txt"
```

## Uninstalling

1. Update or remove `GRUB_THEME`.
2. Remove the directories associated with the theme from `/boot/grub/themes`

## Getting support

You can file an issue that is related to the theme itself in the issues tab on GitHub.

If you have further questions about installing, create a discussion in the Q/A section.