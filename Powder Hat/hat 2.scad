height_mm = 50;
cap_height_mm = 10;
vanes = 6;
diameter_mm = 100;
centre_space_mm = 10;
tolerance_mm = 1;
vane_rounding_mm = 3;
cap_attach_points = 6;
attach_point_size = 5;

vane_length_mm = (diameter_mm - centre_space_mm) / 2;

vane_length_base_rectangle_mm = vane_length_mm - vane_rounding_mm - tolerance_mm;

color("green")
for (i = [0 : vanes - 1])
{
  rotate([0, 0, i * 360 / vanes])
  translate([vane_length_base_rectangle_mm / 2 - vane_rounding_mm / 2 + centre_space_mm / 2 + vane_rounding_mm, 0, height_mm / 2])
  minkowski()
  {
    cube([vane_length_base_rectangle_mm, 1, height_mm], center = true);
    cylinder(h = 1, d = vane_rounding_mm, $fn = 40);
  }
}

difference()
{
  translate([0, 0, height_mm])
  cylinder(cap_height_mm, d = 100, $fn = 100);
  
  for (i = [0 : cap_attach_points - 1])
  {
    rotate([0, 0, i * 360 / cap_attach_points + 30])
    translate([diameter_mm * 0.35, 0, height_mm - 10])
    cylinder(cap_height_mm + 20, d = attach_point_size, $fn = 4);
  }
}