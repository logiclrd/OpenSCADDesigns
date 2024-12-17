$fa = 5;
$fs = 1;

saturn_diameter = 30;
rings_diameter = 60;
fillet_size = 5;

module protosaturn()
{
  union()
  {
    sphere(d = saturn_diameter);
    cylinder(d = rings_diameter, h = 2, center = true);
  }
}

module negative_protosaturn_bottom_half()
{
  difference()
  {
    translate([0, 0, -0.5 * (saturn_diameter / 2 + 5)])
    cube([rings_diameter + 5, rings_diameter + 5, saturn_diameter / 2 + 5], center = true);
    protosaturn();
  }
}

module filleted_bottom_half()
{
  minkowski()
  {
    negative_protosaturn_bottom_half();
    sphere(d = fillet_size);
  }
}

module saturn_bottom_half()
{
  translate([0, 0, -0.5 * fillet_size])
  difference()
  {
    translate([0, 0, -0.5 * (saturn_diameter / 2 + 5)])
    cube([rings_diameter + 5, rings_diameter + 5, saturn_diameter - fillet_size - 1], center = true);
    filleted_bottom_half();
  }
}

module saturn_top_half()
{
  scale([1, 1, -1])
  saturn_bottom_half();
}

module saturn()
{
  union()
  {
    saturn_bottom_half();
    saturn_top_half();
  }
}

translate([-350, 0, 0])
protosaturn();

translate([-280, 0, 0])
negative_protosaturn_bottom_half();

translate([-210, 0, 0])
filleted_bottom_half();

translate([-140, 0, 0])
saturn_bottom_half();

translate([-70, 0, 0])
saturn_top_half();

saturn();