difference()
{
  translate([-50, -50, 0])
  cube([900, 1030, 4]);

  linear_extrude(5)
  import("Logo for 3D printed stencil.svg");
}

color("green")
translate([0, 0, 4])
linear_extrude(1)
import("Logo for 3D printed stencil - Ties.svg");