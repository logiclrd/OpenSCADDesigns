$fn = 100;

outer_radius = 13;
inner_radius = 8;
bulge = 1;
elephant_foot_compensation = 0.2;
height = 4;
text_height = 0.6;
screw_hole_depth = 3;

module test(tolerance)
{
  difference()
  {
    cylinder(height, outer_radius, outer_radius);

    translate([0, 0, -0.05])
    cylinder(height / 8, inner_radius + elephant_foot_compensation, inner_radius + elephant_foot_compensation);
    translate([0, 0, -0.05])
    cylinder(height / 2 + 0.1, inner_radius, inner_radius + bulge);
    translate([0, 0, height / 2])
    cylinder(height / 2 + 0.1, inner_radius + bulge, inner_radius);
  }
  
  difference()
  {
    angle = atan2(0.5, 2);
    rotated_tolerance = tolerance / cos(angle);
    
    union()
    {
      cylinder(2, inner_radius - rotated_tolerance, inner_radius + bulge - rotated_tolerance);
      translate([0, 0, 2])
      cylinder(2, inner_radius + bulge - rotated_tolerance, inner_radius - rotated_tolerance);
      
      translate([0, -0.5 * inner_radius - 0.5, 0])
      linear_extrude(height = height + text_height)
      text(str(tolerance), size = inner_radius * 0.45, halign = "center", valign = "center");
    }

    translate([0, 0, height - screw_hole_depth])
    rotate([0, 0, 45])
    cylinder(screw_hole_depth + 0.05, 4.81 * cos(45), 4.85 * cos(45), $fn = 4);
  }
}

module tests()
{
  x_separation = outer_radius + inner_radius + bulge + 1;
  y_separation = x_separation * sin(60);
  
  for (gap_mult = [8 : 19])
  {
    gap = gap_mult * 0.02 - 0.02;
    
    x = gap_mult % 4 - floor(gap_mult / 8) + 1;
    y = floor(gap_mult / 4) - 2;
    
    translate([x * x_separation + y * x_separation * 0.5, y * y_separation, 0])
    test(gap);
  }
}

difference()
{
  tests();
  //cube(25, center = true);
}

//translate([-outer_radius, -outer_radius, 0])
//cube([115, 65, 3]);