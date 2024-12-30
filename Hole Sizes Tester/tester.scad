difference()
{
  union()
  {
    cube([100, 8, 10]);

    for (i = [1 : 9])
    {
      d = 1 + i / 10;
      
      translate([i * 10 - 5, 1, 10])
      scale([0.5, 1, 1])
      linear_extrude(0.5)
      text(str(d), 6, "Arial", halign = "center");
    }
  }

  for (i = [1 : 9])
  {
    d = 1 + i / 10;
    
    translate([i * 10, 0, 8])
    cube([d, 20, 10], center = true);
  }
}