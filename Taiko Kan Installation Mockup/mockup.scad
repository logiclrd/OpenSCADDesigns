installed = true;

rotate_extrude()
translate([12, 0, 0])
circle(d = 7);

translate([0, -25, 0])
rotate([90, 0, 90])
rotate_extrude()
translate([25, 0, 0])
circle(d = 9.5);

if (!installed)
{
  intersection()
  {
    union()
    {
      translate([0, 0, 2])
      scale([1, 15, 1])
      rotate([0, 0, 45])
      cube([10, 10, 3], center = true);
        
      translate([0, 0, -2])
      scale([1, 16, 1])
      rotate([0, 0, 45])
      cube([10, 10, 3], center = true);
    }

    translate([0, 60, 0])
    cube([100, 100, 100], center = true);
  }
}
else
{
  intersection()
  {
    union()
    {
      translate([0, 0, 2])
      scale([1, 15, 1])
      rotate([0, 0, 45])
      cube([10, 10, 3], center = true);
        
      translate([0, 0, -2])
      scale([1, 16, 1])
      rotate([0, 0, 45])
      cube([10, 10, 3], center = true);
    }

    translate([0, 60, 0])
    cube([100, 100, 100], center = true);

    translate([0, -15, 0])
    cube([100, 100, 100], center = true);
  }

  translate([0, 36, 1])
  rotate([90, 0, 0])
  translate([0, -35, 0])
  union()
  {
    intersection()
    {
      union()
      {
        translate([0, 0, 2])
        scale([1, 15, 1])
        rotate([0, 0, 45])
        cube([10, 10, 3], center = true);
      }

      translate([0, 85, 0])
      cube([100, 100, 100], center = true);

      translate([0, 45, 0])
      cube([100, 100, 100], center = true);
    }

    translate([0, 96, 1])
    rotate([90, 0, 0])
    translate([0, -95, 0])
    intersection()
    {
      union()
      {
        translate([0, 0, 2])
        scale([1, 15, 1])
        rotate([0, 0, 45])
        cube([10, 10, 3], center = true);
      }

      translate([0, 145, 0])
      cube([100, 100, 100], center = true);
    }
  }
  
  translate([0, 36, -1])
  rotate([-90, 0, 0])
  translate([0, -35, 0])
  union()
  {
    intersection()
    {
      union()
      {
        translate([0, 0, -2])
        scale([1, 16, 1])
        rotate([0, 0, 45])
        cube([10, 10, 3], center = true);
      }

      translate([0, 85, 0])
      cube([100, 100, 100], center = true);

      translate([0, 50, 0])
      cube([100, 100, 100], center = true);
    }

    translate([0, 101, 1])
    rotate([-90, 0, 0])
    translate([0, -98, 0])
    intersection()
    {
      union()
      {
        translate([0, 0, -2])
        scale([1, 16, 1])
        rotate([0, 0, 45])
        cube([10, 10, 3], center = true);
      }

      translate([0, 150, 0])
      cube([100, 100, 100], center = true);
    }
  }
}

dd = 24 * 25.4;

color(alpha = 0.5)
difference()
{
  scale([1.6, 1, 1])
  translate([0, dd * 0.5 + 15, 0])
  sphere(d = dd);
  
  rotate([270, 0, 0])
  cylinder(d = 14.5, h = 100);
}