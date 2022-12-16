// Uses FlipperLogo.stl from elsewhere in the repo
//
// Uses top.stl from the Flipper Zero Case design.abs

difference()
{
  union()
  {
    import("C:\\Users\\JDG\\3D Objects\\Flipper Zero Case\\top.stl");

    translate([0, 0, 0.5])
    cube([120, 40, 1], center = true);
  }

  translate([-55, -7, -0.01])
  import("FlipperLogo.stl");
}
