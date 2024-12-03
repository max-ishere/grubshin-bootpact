# Theme showcase

> [!NOTE]
> Scroll down for screenshots.

## Previewing the themes

### NixOS

If you're on Nix you just have to run one command:

```sh
nix build "github:max-ishere/grubshin-bootpact#$colors.$layout.$resolution.preview-theme"

# Example
nix build "github:max-ishere/grubshin-bootpact#night.teleport.1920x1080.preview-theme"
```

Where colors, layout and resolution can be obtained from the tables below.

This will create a result directory with an ISO file and a script to boot it in a QEMU VM. You can flash the ISO on a
USB as well, but you cannot use it to boot your OS because the only entries it has are showcasing the icons with a
reboot command.

### Other linux distributions

`hartwork` made an awesome tool <https://github.com/hartwork/grub2-theme-preview>. This lets you generate a preview ISO
as well and run it in QEMU. In fact, the NixOS approach replicates the majority of the functionality of this tool, the
only difference is that it is implemented in Nix and not python.

## Supported resolutions

| `nix build` | Common name |
|-------------|-------------|
| 1280x720    | 720p        |
| 1980x1080   | 1080p       |

## Colorschemes

| `nix build` | Name      | Description                                              |
|-------------|-----------|----------------------------------------------------------|
| night       | **Night** | The dark version of the in-game loading screen.          |
| day         | **Day**   | The light version of the in-game loading screen.         |
| abyss       | **Abyss** | The 0.0.1 colorscheme - pitch black, just like the void. |

## Layouts

| `nix build` | Name         | Description                                                                                |
|-------------|--------------|--------------------------------------------------------------------------------------------|
| classic     | **Classic**  | A touched up version of the 0.0.1 look. Very convinient to use with multiple boot entries. |
| teleport    | **Teleport** | Very similar to classic, but mimics the teleport loading screen a lot better.              |

## Screenshots

### Teleport (Night)

<img src="screenshots/teleport-night-720.png" />

### Teleport (Day)

<img src="screenshots/teleport-day-720.png" />

### Teleport (Abyss)

<img src="screenshots/teleport-abyss-720.png" />

### Classic (Night)

<img src="screenshots/classic-night-720.png" />

### Classic (Day)

<img src="screenshots/classic-day-720.png" />

### Classic (Abyss)

<img src="screenshots/classic-abyss-720.png" />
