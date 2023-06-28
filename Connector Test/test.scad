difference()
{
  cube([15, 15, 4]);
  translate([7.5, 7.5, 1])
  cylinder(3.1, 4, 4, $fn = 100);
}

translate([20, 0, 0])
difference()
{
  cube([15, 15, 4]);
  translate([7.5, 7.5, 1])
  cylinder(3.1, 4, 4, $fn = 100);
}

translate([40, 0, 0])
difference()
{
  cube([15, 15, 4]);
  translate([7.5, 7.5, 1])
  cylinder(3.1, 4, 4, $fn = 100);
}

translate([0, 20, 0])
union()
{
  cube([55, 15, 4]);
  translate([7.5, 7.5, 0])
  cylinder(7, 4, 4, $fn = 100);
  translate([27.5, 7.5, 0])
  cylinder(7, 4, 4, $fn = 100);
  translate([47.5, 7.5, 0])
  cylinder(7, 4, 4, $fn = 100);
}