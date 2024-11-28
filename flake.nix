{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    grub-theme.url = "path:/home/max_ishere/Projects/grub-theme.nix";
    grub-theme.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    grub-theme,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true; # like this
    };
    lib = nixpkgs.lib;
  in {
    formatter.${system} = pkgs.alejandra;

    packages.${system} = {
      preview-theme = grub-theme.lib.mkGrubThemePreview {
        src = self.packages.${system}.grubshin-bootpact;
        name = "grubshin-bootpact";
        # resolution = "1280x720";
        menuentries = builtins.map (png: let
          class = lib.removeSuffix ".png" png;
        in {
          name = "class: ${class}";
          inherit class;
        }) (builtins.attrNames (builtins.readDir ./src/icons));
      };

      grubshin-bootpact = pkgs.callPackage ./grubshin-bootpact.nix {
        inherit (grub-theme.lib) mkGrubThemeTxt;
      };
    };

    devShells.${system} = {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          (vscode-with-extensions.override {
            vscodeExtensions = with vscode-extensions; [
              vscodevim.vim
              jnoortheen.nix-ide
              ms-vscode.hexeditor
            ];
          })

          inkscape
        ];
      };
    };
  };
}
