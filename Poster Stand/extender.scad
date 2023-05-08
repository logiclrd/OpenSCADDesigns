//color("blue")
//translate([-10, 30, 0])
//rotate([0, 0, -40])
//cube([220, 220, 1]);

scale([1, 1, 2])
union()
{
  difference()
  {
    translate([0, 0, 0])
    cube([100, 100, 10]);
    
    translate([0, 0, 10])
    rotate([0, 90, 0])
    import("poster_stand.stl");
    
    translate([0, 0, 20])
    rotate([0, 90, 0])
    import("poster_stand.stl");
    
    translate([0, -1, 0])
    cube([110, 20, 10]);
    
    rotate([0, 0, 10])
    translate([15, -8, 0])
    cube([120, 40, 10]);

    translate([0, 40, 0])
    rotate([0, 0, 6])
    cube([110, 60, 10]);
  }
  
  translate([7, 30, 0])
  rotate([0, 0, 10])
  cube([275, 5, 10]);
}