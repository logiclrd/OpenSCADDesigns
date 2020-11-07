base_size_mm = 350;
square_size_mm = 41;
edge_bevel_width_mm = 10;
edge_bevel_height_mm = 4;
base_height_mm = 15;
square_height_mm = 2;
base_tile_size_mm = 48;
base_tile_height_mm = 8;
base_tile_edge_thickness_mm = 1.5;
base_tile_join_islands_height_mm = 3;
outer_wall_tile_gap_height_mm = 3;

board_surface_size_mm = square_size_mm * 8;

module square()
{
  cube([square_size_mm, square_size_mm, square_height_mm]);
}

module square_chamfer_x(i)
{
  overlap = 1;
  cube_size_mm = square_size_mm + 2 * overlap;
  
  if (i > 0)
  {
    translate([0, 0, square_height_mm])
    rotate([0, -45, 0])
    translate([-0.5 * cube_size_mm, 0.5 * cube_size_mm - overlap, 0])
    cube(cube_size_mm, center = true);
  }
  
  if (i < 7)
  {
    translate([square_size_mm, 0, square_height_mm])
    rotate([0, 45, 0])
    translate([0.5 * cube_size_mm, 0.5 * cube_size_mm - overlap, 0])
    cube(cube_size_mm, center = true);
  }
}

module square_chamfer(i, j)
{
  square_chamfer_x(i);
  
  multmatrix(
  [[0, 1, 0, 0],
   [1, 0, 0, 0],
   [0, 0, 1, 0],
   [0, 0, 0, 1]])
  square_chamfer_x(j);
}

module squares()
{
  top_left = -0.5 * board_surface_size_mm;
  
  for (i = [0 : 7])
    for (j = [0 : 7])
      if ((i + j) % 2 == 0)
      {
        translate([top_left + i * square_size_mm, top_left + j * square_size_mm, 0])
        difference()
        {
          square();
          square_chamfer(i, j);
        }
      }
}

module white_squares()
{
  translate([0, 0, base_height_mm])
  rotate([0, 0, 90])
  squares();
}

module black_squares()
{
  translate([0, 0, base_height_mm])
  squares();
}

module base()
{
  overlap = 1;
  cube_size_mm = base_size_mm + 2 * overlap;
  
  difference()
  {
    translate([0, 0, 0.5 * base_height_mm])
    cube([base_size_mm, base_size_mm, base_height_mm], center = true);
    
    for (side = [0 : 3])
    {
      rotate([0, 0, side * 90])
      translate([0.5 * base_size_mm, 0, base_height_mm - edge_bevel_height_mm])
      rotate([0, -atan2(edge_bevel_width_mm, edge_bevel_height_mm), 0])
      translate([0.5 * cube_size_mm, 0, 0])
      cube(cube_size_mm, center = true);
    }
  }
}

module base_tile()
{
  circle_radius_mm = 0.5 * base_tile_size_mm / cos(22.5);
  
  translate([0, 0, -1])
  difference()
  {
    rotate([0, 0, 22.5])
    difference()
    {
      cylinder(base_tile_height_mm + 1, circle_radius_mm + 0.5 * base_tile_edge_thickness_mm, circle_radius_mm + 0.5 * base_tile_edge_thickness_mm, $fn = 8);
      translate([0, 0, -1])
      cylinder(base_tile_height_mm + 3, circle_radius_mm - 0.5 * base_tile_edge_thickness_mm, circle_radius_mm - 0.5 * base_tile_edge_thickness_mm, $fn = 8);
    }
    
    for (edge = [ 0 : 7 ])
    {
      rotate([0, 0, 45 * edge])
      {
        translate([-3 * base_tile_edge_thickness_mm, base_tile_size_mm * 0.5, 0.5 * base_tile_height_mm + base_tile_height_mm - base_tile_join_islands_height_mm + 1])
        cube([base_tile_edge_thickness_mm, 2 * base_tile_edge_thickness_mm, base_tile_height_mm], center = true);

        translate([+3 * base_tile_edge_thickness_mm, base_tile_size_mm * 0.5, 0.5 * base_tile_height_mm + base_tile_height_mm - base_tile_join_islands_height_mm + 1])
        cube([base_tile_edge_thickness_mm, 2 * base_tile_edge_thickness_mm, base_tile_height_mm], center = true);
      }
    }
  }
}

module base_tiling_ring(ring)
{
  if (ring == 0)
  {
    base_tile();
  }
  else
  {
    ring_size_difference_mm = base_tile_size_mm / sqrt(2);
    ring_spacing_mm = base_tile_size_mm * sqrt(2);
  
    for (direction = [0 : 3])
    {
      rotate([0, 0, 90 * direction])
      for (index = [1 : ring])
      {
        translate([index * ring_spacing_mm - ring_size_difference_mm * ring, ring * ring_size_difference_mm, 0])
        base_tile();
      }
    }
  }
}

module base_tiling_pattern()
{
  ring_size_difference_mm = base_tile_size_mm / sqrt(2);
  
  for (ring = [0 : floor((base_size_mm * 0.5 + base_tile_size_mm) / ring_size_difference_mm) - 1])
  {
    base_tiling_ring(ring);
  }
}

module outer_wall()
{
  outer_wall_height = base_height_mm - edge_bevel_height_mm - outer_wall_tile_gap_height_mm;
  
  translate([0, 0, 0.5 * outer_wall_height + outer_wall_tile_gap_height_mm])
  difference()
  {
    cube([base_size_mm, base_size_mm, outer_wall_height], center = true);
    cube([base_size_mm - 2 * base_tile_edge_thickness_mm, base_size_mm - 2 * base_tile_edge_thickness_mm, outer_wall_height + 2], center = true);
  }
}

union()
{
  difference()
  {
    base();
    base_tiling_pattern();
  }
  
  outer_wall();
}

color([0.3, 0.3, 0.3]) black_squares();
color([0.95, 0.95, 0.95]) white_squares();