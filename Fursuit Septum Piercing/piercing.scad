$fn = 64;

shaft_diameter_mm = 9;
ball_diameter_mm = 13;
shaft_sweep_angle = 300;
shaft_sweep_radius_mm = 35;

union()
{
  rotate_extrude(shaft_sweep_angle, $fn = 200)
  translate([shaft_sweep_radius_mm, 0, 0])
  circle(d = shaft_diameter_mm);

  for (a = [0, shaft_sweep_angle])
    rotate([0, 0, a])
    translate([shaft_sweep_radius_mm, 0, 0])
    sphere(d = ball_diameter_mm);
}