{render}: {
  src,
  name,
  height ? null,
  width ? null,
}: let
  drv = render {inherit src name width height;};
in {
  component = {
    inherit width height;
    file = drv.name;
  };

  assets = [drv];
}
