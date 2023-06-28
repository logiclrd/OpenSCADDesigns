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

module pin(x, y, h, r, t = 0.24)
{
  translate([x, y, 0])
  cylinder(h, r, r, $fn = 100);
  translate([x, y, h])
  cylinder(t, r, r - t, $fn = 100);
}

translate([0, 20, 0])
union()
{
  cube([55, 15, 4]);

  pin(7.5, 7.5, 7, 3.95); // <-- this one works nicely!
  pin(27.5, 7.5, 7, 3.9);
  pin(47.5, 7.5, 7, 3.85);
}