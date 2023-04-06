# Grubshin Bootpact

A Genshin Impact inspired GRUB bootloader minimal theme. 

The theme has been tested at 1080p in a qemu/KVM and at 720p on hardware. Most offsets are in pixels relative to the top and the bottom of the screen.
If you have a larger monitor unless you have many menu items you may want to increase the font and adjust the location
of some elements. This is done in `grubshin-bootpact/theme.txt`. You will have to read the GRUB documentation for this process.
If you adjust the theme to a different resolution then consider submitting a pull request with you changes.

![Theme screenshot](https://github.com/max-ishere/grubshin-bootpact/blob/main/How_it_looks.png)

**Features:**
- Looks as close to the loading screen in game as possible
- Black background, white foreground.
- A font from the game
- The boot countdown is an elemental loading bar from the game
- There are a few icons included representing different enemies from the game, however you may want to create a custom one

**The directory structure**
- `grubshin-bootpact`: 1080p version (tested in a VM)
- `grubshin-bootpact720`: 720 version (tested on hardware)

Just a heads up I cannot really test a 1080p version outside the VM so the more polished one is the 720p one. The VM is quite limiting in that it doesnt support different sized fonts. I have tried to make it look good to the best of my ability.

# How to install
*These instructions are for Arch linux. Some steps may be different on other distributuions. E.g. the GRUB directory may be /boot/grub2. If you are not willing to research installation for your distro, dont mess with your bootloader. I am not capable of supporting every distro out there.*

**Before installation I highly recomend practicing in a VM and having a rescue USB stick ready with your distro. How else will you rescue unbootable machine?** That said installing a theme correctly should be rather safe. Oh and please think before you type. As in really make sure I (max-ishere) didn't screw up some step.

1. Download a release from GitHub
2. If you have not installed any themes before, go to [Troubleshooting/Enabling themes](#enabling-themes).
3. **Before you execute this, please note:** there are 2 directories with this name - the entire project and inside the project. You need only the one that has theme.txt inside, which is the inside one. Ok now you can copy it: `sudo cp -r grubshin-bootpact/ /boot/grub/themes/grubshin-bootpact`. There is a 720p theme in `grubshin-bootpact720` make sure if you copy it you put it into `grubshin-bootpact` (without the 720).
4. Set `GRUB_THEME="/boot/grub/themes/grubshin-bootpact/theme.txt"` in `/etc/default/grub`
5. Run `sudo grub-mkconfig -o /boot/grub/grub.cfg`
6. Reboot

The theme should be installed.

# Uninstalling

1. Remove or replace `GRUB_THEME` in `/etc/default/grub`
2. Delete `/boot/grub/themes/grubshin-bootpact`

# Extending this theme

## Adding a background

You can set a darkened background picture yourself if you want to. To do so make a 8bprc RGB PNG. If you are in GIMP you can open any image, scale and crop to your display resolution click `Export as`. Then in color format select the described above and untick every setting. Next copy it to`/boot/grub/themes/grubshin-bootpact/background.png` and add this line at the top of `theme.txt`: `desktop-image: "background.png"`.

You may want to use one of the images as seen on [Genshin Wiki: Loading screen: Gallery](https://genshin-impact.fandom.com/wiki/Loading_Screen). I am not willing to take the risk of shipping anything more than a font and some pixel art images that I made myself so make a background yourself please. Just to save me the legal trouble just in case.

GRUB requires that even if you change the theme you regenerate the config with `grub-mkconfig`.

## Adding more icons to the menu

The current list of icons only contains
- `os.png`: anything without an icon, but not a submenu
- `linux.png`, `windows.png` and `arch.png`: Every entry in grub has a `--class class`. If it doesnt its considered OS, if it does and *`class`*`.png` file is found that image is used.

You can simply create an image (The default theme uses 64x64px BW images) and copy it to `/boot/grub/themes/grubshin-bootpact/icons`. That directory is where GRUB looks for icons. Whats weird is that GRUB doesnt tell you that directly in docs...

# Troubleshooting

## Enabling themes

GRUB by default is not configured to use themes. `grub-mkconfig` will tell you a theme was found, but GRUB doesnt try to use it.

Here are the settings you have to replace, and if they are not present in the config then add them in. This is a reference I used to 
come up with this list: [GRUB Manual: Simple configuration](https://www.gnu.org/software/grub/manual/grub/grub.html#Simple-configuration),
it explains all the options. There is also a YouTube video that helped me to set this up: [Broodie Robertson: Try A Grub Theme ...](https://youtu.be/smkzKmrtza4)

Add these to your `/etc/default/grub` file. It should contain some settings already, each on their own line so just add these at the end of the file. This file is actually a shell script so whatever is the last assignment to a variable is its final value.

- `GRUB_TIMEOUT=5` and `GRUB_TIMEOUT_STYLE=menu` are required for you to see the themed bootloader.
- `GRUB_TERMINAL_OUTPUT=gfxterm` makes GRUB use the graphical terminal
- `GRUB_GFXMODE="1920x1080,auto"`. You can set as many resolutions as you want and GRUB will go down the list trying each. The last one should be `auto` because it will use whatever your BIOS supports. Read the docs for details on this one. *Personally*, I set it to `auto` because on my system the default is the desired resolution (open GRUB on boot, press `c` and type `videoinfo`) and the process of going through the list makes the screen flicker.
- `GRUB_GFXPAYLOAD_LINUX=keep` Makes the linux kernel use the same graphics mode as set in `GRUB_GFXMODE` variable.
- And of course `GRUB_THEME="/boot/grub/themes/grubshin-bootpact/theme.txt"`

Here is a sample of what it should look like:
```sh
# Append something like this to the end, DONT replace existing settings!

GRUB_TIMEOUT=5
GRUB_TIMEOUT_STYLE=menu
GRUB_TERMINAL_OUTPUT=gfxterm
GRUB_GFXMODE="1920x1080,auto"
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_THEME="/boot/grub/themes/grubshin-bootpact/theme.txt"
```

-----------------------------------------

If you have issues with the theme please (dont worry if you use the wrong one, it simply would be nice to use these in a certain way so later people can search their problems)
- Discussions: Installation and other kind of support. E.g: I dont know how to install this theme, the instructions are not clear. (I really hope they are tho...)
- Issues: For submiting bugs and fixes. E.g: I have found this bug please fix/I have a fix for this bug.

TLDR: Issues are for developers and Discussions are for questions by regular users. Please use the correct one but if you are between *which do I use* and not using either just use Discussions then.

I am open to questions as this project is targeted at gamers who just want stuff to work (why are you on Linux? Ok whatever, doesnt matter) and I want to provide useful instructions.

