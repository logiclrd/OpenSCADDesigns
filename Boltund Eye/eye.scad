outer_width = 60;
outer_height = 80;

inner_width = 40;
inner_height = 60;

inner_angle = 12;
inner_x = -6;
inner_y = -8;

thickness = 1.5;

$fn = 150;

color("white")
minkowski()
{
  linear_extrude(0.1)
  difference()
  {
    scale([1, outer_height / outer_width, 1])
    circle(d = outer_width);

    translate([inner_x, inner_y, 0])
    rotate([0, 0, inner_angle])
    scale([1, inner_height / inner_width, 1])
    circle(d = inner_width);
  }

  sphere(d = thickness, $fn = 30);
}
