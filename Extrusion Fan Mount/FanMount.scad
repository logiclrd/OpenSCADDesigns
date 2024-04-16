mount_width = 29;

/*
intersection()
{
  translate([-105, -142, -28])
  import("CableClip2.stl", 5);

  translate([0, 25, -8])
  cube([50, 50, 50], center = true);
}
*/

module extrusion_attachment()
{
  union()
  {
    intersection()
    {
      difference()
      {
        difference()
        {
          translate([0, 9, 0])
          rotate([90, 0, 0])
          cylinder(20, 0, 21, $fn = 150);
          
          translate([0, 30.8, 0])
          cube([50, 50, 50], center = true);
        }
        
        translate([0, 0, 28])
        cube([50, 50, 50], center = true);
        translate([0, 0, -28])
        cube([50, 50, 50], center = true);
      }

      translate([0, 8, 0])
      rotate([90, 0, 0])
      cylinder(20, 5.05, 5.05, $fn = 150);

      translate([0, 22.1, 0])
      rotate([90, 0, 0])
      cylinder(20, 5.05, 5.05, $fn = 150);
      
      translate([0, 8.05, 0])
      rotate([90, 0, 0])
      cylinder(11, 10, 0, $fn = 150);
    }

    difference()
    {
      translate([0, 5, 0])
      rotate([90, 0, 0])
      cylinder(5, 3.3, 3.3, $fn = 150);
      
      translate([0, 0, 28])
      cube([50, 50, 50], center = true);
      translate([0, 0, -28])
      cube([50, 50, 50], center = true);
    }
  }
}

module top_screw(expand = 0)
{
  translate([0, -4, 0])
  rotate([90, 0, 90])
  cylinder(60, d = 3 + expand, center = true, $fn = 40);
}

module bottom_screw()
{
  translate([0, -8 - 7.5, 0])
  rotate([90, 0, 90])
  cylinder(60, d = 4, center = true, $fn = 40);
}

module attachment_block()
{
  translate([0, -2, 0])
  cube([10, 4, 10], center = true);

  translate([0, -4, 0])
  difference()
  {
    translate([0, -4, 0])
    cube([mount_width, 8, 20], center = true);

    top_screw(expand = 0.5);
  }
}

extrusion_attachment();
attachment_block();

/*
difference()
{
  translate([mount_width / 2+ 2.5, -12, 0])
  cube([12, 24, 20], center = true);
  
  top_screw(expand = 1);
  bottom_screw();
}

difference()
{
  translate([-mount_width / 2 + -2.5, -12, 0])
  cube([12, 24, 20], center = true);
  
  top_screw(expand = 1);
  bottom_screw();
}
*/