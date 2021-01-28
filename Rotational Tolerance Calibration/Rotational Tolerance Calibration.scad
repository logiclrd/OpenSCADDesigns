$fn = 100;

module test(tolerance)
{
  difference()
  {
    cylinder(4, 20, 20);

    translate([0, 0, -0.05])
    cylinder(0.5, 12.2, 12.2);
    translate([0, 0, -0.05])
    cylinder(2.1, 12, 13);
    translate([0, 0, 2])
    cylinder(2.1, 13, 12);
  }
  
  difference()
  {
    angle = atan2(0.5, 2);
    rotated_tolerance = tolerance / cos(angle);
    
    union()
    {
      cylinder(2, 12 - rotated_tolerance, 13 - rotated_tolerance);
      translate([0, 0, 2])
      cylinder(2, 13 - rotated_tolerance, 12 - rotated_tolerance);
      
      translate([0, -6.5, 0])
      linear_extrude(height = 4.5)
      text(str(tolerance), size = 5.5, halign = "center", valign = "center");
    }

    translate([0, 0, 1])
    rotate([0, 0, 45])
    cylinder(3.1, 4.81 * cos(45), 4.85 * cos(45), $fn = 4);
  }
}

module tests()
{
  for (gap_mult = [8 : 13])
  {
    gap = gap_mult * 0.02;
    
    x = floor(gap_mult / 2) % 4;
    y = gap_mult % 2;
    
    translate([x * 34 + y * 16 + 18, y * 32 + 15, 0])
    test(gap);
  }
}

difference()
{
  tests();
  //cube(25, center = true);
}

//cube([115, 65, 3]);