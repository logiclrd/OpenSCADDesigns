head_width = 22.5;
head_length = 49.2;
tail_left = 2.75;
tail_right = 6.25;
entire_length = 150;
height = 2.05;
edge_radius = 0.75;

intersection()
{
  minkowski()
  {
    union()
    {
      translate([tail_left, 0, 0])
      cube([head_width - tail_left - tail_right - 2 * edge_radius, entire_length - 2 * edge_radius, height]);
      cube([head_width - 2 * edge_radius, head_length - 2 * edge_radius, height]);
    }
    
    sphere(edge_radius + 0.005, $fn = 40);
  }
  
  translate([-edge_radius, -edge_radius, edge_radius])
  cube([head_width, entire_length, height]);
}