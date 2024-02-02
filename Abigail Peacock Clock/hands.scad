smaller = 0.2;

translate([-15, 0, 0])
difference()
{
  union()
  {
    linear_extrude(0.8)
    scale([0.077, 0.077, 1])
    translate([-105, -495.5, 0])
    import("minute hand.svg");

    color("blue")
    cylinder(3, d = 6.5, $fn = 50);
  }
  
  translate([0, 0, -1])
  cylinder(12, d = 4.0 - smaller, $fn = 50);
}

difference()
{
  union()
  {
    linear_extrude(0.8)
    scale([0.077, 0.077, 1])
    translate([-105, -369, 0])
    import("hour hand.svg");

    color("blue")
    cylinder(3, d = 8, $fn = 50);
  }
  
  translate([0, 0, -1])
  cylinder(12, d = 5.8 - smaller, $fn = 50);
}