{hywenhei-extended-font}: let
  svg = path: ../../../../svg + path;
in {
  menu = {
    icons = svg /icons;
    iconSize = 150;
  };

  line = {
    src = svg /progress-bar/line.svg;
    name = "line";
    width = 1;
    height = 2;
  };

  elements = {
    src = svg /progress-bar/seven-elements.svg;
    name = "elements";
    width = 223;
    height = 30;
  };

  fonts.normal = {
    size = 14;
    src = "${hywenhei-extended-font}/HYWenHei Extended.ttf";
    family = "HY WenHei Extended";
  };
  fonts.header = {
    size = 16;
    src = "${hywenhei-extended-font}/HYWenHei Extended.ttf";
    family = "HY WenHei Extended";
  };
}
