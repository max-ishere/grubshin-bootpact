{
  stdenv,
  lib,
  resvg,
  grub2,
  fetchFromGitHub,
  writeText,
  hywenhei-font ?
    fetchFromGitHub {
      owner = "cawa-93";
      repo = "HYWenHei-Extended-Font";
      rev = "main";
      hash = "sha256-zzRUVv+OmINrvhOkQWZQ6EjjsqQMO2oAiOKE7je1F6U=";
    },
  mkGrubThemeTxt,
}:
stdenv.mkDerivation {
  pname = "grubshin-bootpact";
  version = "0.0.1";
  src = ./src;
  buildInputs = [resvg grub2];

  buildPhase = let
    foreground = "white";
    foregroundDim = "#666";
    background = "black";
    fontSize = 20;
    themeTxt = import ./theme.nix {inherit mkGrubThemeTxt lib;} {inherit fontSize;};
  in ''
    mkdir $out

    echo 'path { fill: ${foreground}; }' > ./logo.css

    resvg ./grubshin-bootpact.svg \
      --stylesheet=./logo.css \
      $out/grubshin-bootpact.png

    echo 'path { fill: ${background}; }' > ./elements.css

    resvg ./seven-elements.svg \
      --width=350 \
      --height=47 \
      --stylesheet=./elements.css \
      $out/seven-elements.png

    echo '#line { stroke: ${foregroundDim}; }' > ./line.css

    resvg ./line.svg \
      --stylesheet=./line.css \
      $out/line.png

    ${grub2}/bin/grub-mkfont --name="Hy WenHei ${builtins.toString fontSize}" \
      --size=${builtins.toString fontSize} \
      --asce=22 \
      --desc=7 \
      --output=$out/hywenhei-${builtins.toString fontSize}.pf2 \
      "${hywenhei-font}/HYWenHei Extended.ttf"

    cp ./icons ./highlight-box $out -r

    cat <<EOF > $out/theme.txt
    ${themeTxt}
    EOF
  '';
}
