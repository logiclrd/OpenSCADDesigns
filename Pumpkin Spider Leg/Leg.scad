translate([-120, 11, 50])
rotate([0, -45, -3.5])
cylinder(50, 4, 2);

translate([-120, 11, 35])
rotate([0, -45, -3.5])
cylinder(50, 4, 2);

translate([-129, 11, 29])
rotate([0, -45, -3.5])
cylinder(40, 4, 2);

scale([3, 3, 3])
difference()
{
  union()
  {
    rotate([0, -80, 0])
    cube([15, 5, 45]);

    translate([-14.4, 0, -21])
    {
      translate([0.1, 0, 0.6])
      rotate([0, 11, 0])
      cube([10, 5, 30]);

      translate([-10, 0, -25])
      {
        translate([14.5, 0, -8])
        rotate([0, -70, 0])
        cube([7, 5, 20]);
        
        translate([-5.5, 0, 5])
        rotate([0, 80, 0])
        cube([6, 5, 10]);
        
        translate([-5.5, 0, 5])
        rotate([0, 35, 0])
        cube([10, 5, 30]);
      }
    }
  }

  color("red")
  {
    translate([-50, -2, 24.5])
    rotate([0, 15, 0])
    cube([100, 10, 100]);
    
    translate([-50, -2, -146])
    rotate([0, 4, 0])
    cube([100, 10, 100]);
  }
  
  translate([-50, -7, -50])
  rotate([2, 0, 0])
  cube([100, 10, 100]);
}

