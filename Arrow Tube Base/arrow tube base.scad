size = 6.4;

tube_diameter = 54;
tube_height = 104;

grabber_size = 1.25;
grabber_things = 3;
grabber_fade_in_angle = 5;
grabber_height = 96;

module stump()
{
  if ($preview)
  {
    cylinder(tube_height, 105, tube_diameter / 2 + 7);
  }
  else
  {
    scale([size, size, size])
    import("files-28mm-tree-stump-with-base.stl");
  }
}

difference()
{
  union()
  {
    stump();
    cylinder(tube_height, tube_diameter / 2 + 5, tube_diameter / 2 + 5);
  }

  translate([0, 0, 1.5])
  cylinder(250, tube_diameter * 0.5, tube_diameter * 0.5, $fn = 128);
}

intersection()
{
  for (i = [0 : grabber_things])
  {
    grabber_angle = i * 360 / grabber_things;
    
    rotate([0, 0, grabber_angle])
    translate([0.5 * tube_diameter, 0, grabber_height * 0.5])
    intersection()
    {
      rotate([0, 0, 45])
      cube([grabber_size * sqrt(2), grabber_size * sqrt(2), tube_height], center = true);
      
      translate([0, 0, tube_height * 0.5])
      rotate([0, grabber_fade_in_angle, 0])
      translate([0, grabber_size * -10, 10 - grabber_height * 2])
      cube([100, 100, grabber_height * 2]);
    }
  }
  
  stump();
}

if ($preview)
{
  color("gray")
  translate([0, 0, -15])
  cube([235, 235, 5], center = true);
}