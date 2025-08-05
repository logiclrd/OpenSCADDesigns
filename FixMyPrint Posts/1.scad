$fn = 100;

difference()
{
  sphere(d = 100, $fn = 100);
  
  sphere(d = 92, $fn = 100);
  
  translate([0, 0, -35])
  cube([100, 100, 100], center = true);
  
  rotate([-22, 15, 0])
  cylinder(h = 100, d = 28);
  rotate([+22, 15, 0])
  cylinder(h = 100, d = 28);
  
  rotate([0, -25, 0])
  cylinder(h = 100, d = 10);
}