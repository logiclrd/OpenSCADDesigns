difference()
{
  translate([0, 0, 2])
  minkowski()
  {
    cube([51.5, 51.5, 1.75], center = true);
    sphere(7, $fn = 70);
  }
  
  //translate([0, 0, -12])
  //cube([70, 70, 20], center = true);
  
  translate([0, 0, -4.25])
  cube([51.5, 51.5, 17], center = true);
  
  if ($preview)
  {
    cube([100, 100, 100]);
  }
}
