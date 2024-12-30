// A little hat to place over the filter mesh in the depowdering
// cabinet so that the vibrations from the vibrator can reach
// the mesh.

$fn = 50;

scale([1.5, 1, 1])
cylinder(d = 100, h = 8);

for (i = [1 : 4])
{
  rotate([0, 0, i * 360 / 4])
  translate([45, 0, 0])
  cylinder(d = 10, h = 75);
}