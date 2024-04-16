color("gray")
difference()
{
  cube([192, 216, 5], center = true);

  difference()
  {
    translate([-96, -108, 0])
    cube([12, 12, 6], center = true);

    translate([-96 + 6, -108 + 6, 0])
    cylinder(10, d = 12, $fn = 40, center = true);
  }
  
  translate([-90, -102, 0])
  cylinder(10, d = 2.7, center = true, $fn = 40);
}

color("#ddd")
translate([-90, -102, 3])
{
  difference()
  {
    cylinder(5, d = 11, $fn = 40);

    for (i = [0 : 39])
      rotate([0, 0, i * 360 / 40])
      translate([0, 12, 0])
      rotate([0, 0, 45])
      cube([10, 10, 12], center = true);
  }
  
  translate([0, 0, -5])
  cylinder(5, d = 2.7, $fn = 40);
}


color("#444")
translate([0, 0, 2.7])
difference()
{
  cube([192, 216, 0.2], center = true);

  difference()
  {
    translate([-96, -108, 0])
    cube([24, 24, 1], center = true);

    translate([-96 + 3, -108 + 12, 0])
    cylinder(2, d = 6, $fn = 40, center = true);
    translate([-96 + 12, -108 + 3, 0])
    cylinder(2, d = 6, $fn = 40, center = true);
    translate([-96 + 10, -108 + 10, 0])
    cube([12, 12, 2], center = true);
  }
  
  translate([-90, -102, 0])
  cylinder(10, d = 2.7, center = true, $fn = 40);
}

module clip()
{
  difference()
  {
    union()
    {
      translate([0, 0, 2.8])
      cube([12, 12, 0.1], center = true);
      translate([-6.05, 0, 0.125])
      cube([0.1, 12, 5.45], center = true);
      translate([0, 0, -2.55])
      cube([12, 12, 0.1], center = true);
    }

    translate([0, 0, -5])
    cylinder(10, d = 2.7, $fn = 40);
  }
}

translate([-90, -102, 0])
clip();

translate([-80, -132, 0])
clip();

