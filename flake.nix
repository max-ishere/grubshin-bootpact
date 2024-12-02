{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    grubTheme.url = "github:max-ishere/grub-theme.nix?ref=main";
    grubTheme.inputs.nixpkgs.follows = "nixpkgs";
    hywenhei-extended-font = {
      url = "github:cawa-93/HYWenHei-Extended-Font?ref=main";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    grubTheme,
    hywenhei-extended-font,
  }: let
    system = "x86_64-linux";
    unfreePkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true; # like this
    };
    pkgs = nixpkgs.legacyPackages.${system};
    inherit (nixpkgs) lib;
  in {
    formatter.${system} = pkgs.alejandra;

    theme = pkgs.callPackage ./nix/theme.nix {
      grubTheme = grubTheme.lib;
      inherit hywenhei-extended-font;
    };

    packages.${system} = import ./nix/packages/grubshin-bootpact.nix {
      inherit (self) theme;
      inherit lib;
      grubTheme = grubTheme.lib;
    };

    # Internal CI build stuff
    _ci = {
      release = pkgs.callPackage ./ci/release.nix {grubshin-bootpact = lib.filterAttrs (name: _: !(name == "override" || name == "overrideDerivation")) self.packages.${system};};
    };

    devShells.${system} = {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          (unfreePkgs.vscode-with-extensions.override {
            vscodeExtensions = with vscode-extensions; [
              vscodevim.vim
              jnoortheen.nix-ide
              ms-vscode.hexeditor
              github.vscode-github-actions
              bierner.markdown-preview-github-styles
              #me-dutour-mathieu.vscode-github-actions
            ];
          })
          nixd

          inkscape
          resvg
        ];
      };
    };
  };
}
