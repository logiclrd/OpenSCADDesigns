corner_piece_inset_mm = 10;
height_mm = 6 * 25.4 + corner_piece_inset_mm;
strip_thickness_mm = 0.5;
strip_width_mm = 8.5;
strip_retention_wall_mm = 1.5;
strip_retention_wall_angle = 40;
strip_separation_mm = 1;
strip_depth_mm = 1;
strip_escape_length_mm = 10;
bracket_width_mm = strip_width_mm * 2 + 3 * strip_separation_mm;
bracket_depth_mm = 4;
mirror_thickness_mm = 1.2;
mirror_retention_depth_mm = 3;
mirror_retention_inset_mm = 1.2;

strip_retention_wall_skew_factor = tan(strip_retention_wall_angle);
strip_retention_wall_x_mm = strip_retention_wall_mm * strip_retention_wall_skew_factor;

difference()
{
  translate([0, 0, height_mm * 0.5])
  cube([bracket_width_mm, bracket_depth_mm, height_mm], center = true);

  strip_offset = 0.5 * (strip_width_mm + strip_separation_mm);
  
  for (i = [-1, 1])
  {
    translate([i * strip_offset, -0.5 * bracket_depth_mm + 0.5 * strip_thickness_mm + strip_depth_mm, 0])
    {
      translate([0, 0, height_mm * 0.5])
      cube([strip_width_mm, strip_thickness_mm, height_mm + 5], center = true);

      translate([0, -0.5 * bracket_depth_mm, height_mm * 0.5])
      cube([strip_width_mm - 2 * strip_retention_wall_mm, bracket_depth_mm, height_mm + 5], center = true);

      difference()
      {
        union()
        for (j = [-1, 1])
        {
          intersection()
          {
            translate([j * (0.5 * strip_width_mm - 0.5 * strip_retention_wall_mm), 0.5 * strip_retention_wall_mm - 0.5 * strip_thickness_mm, height_mm * 0.5])
            multmatrix(
              [[1, 0, 0, 0],
               [j * strip_retention_wall_skew_factor, 1, 0, -0.5 * strip_retention_wall_x_mm],
               [0, 0, 1, 0],
               [0, 0, 0, 1]])
            cube([strip_retention_wall_mm + 0.1, strip_retention_wall_mm, height_mm + 10], center = true);
            
            translate([0, -3 * bracket_depth_mm + 0.5 * strip_thickness_mm, height_mm * 0.5 + 10])
            cube([strip_width_mm, 6 * bracket_depth_mm, height_mm + 20], center = true);
          }
        }
        
        translate([0, 3 * bracket_depth_mm + 0.5 * strip_thickness_mm, 0])
        cube([5 * strip_width_mm, 6 * bracket_depth_mm, 5 * height_mm], center = true);
      }
      
      translate([-i * 0.25 * strip_width_mm, -1.5 * strip_thickness_mm, height_mm - 0.5 * strip_escape_length_mm])
      cube([0.5 * strip_width_mm, 2 * strip_thickness_mm, strip_escape_length_mm], center = true);

      translate([-i * 0.25 * strip_width_mm, -1.5 * strip_thickness_mm, 0.5 * (strip_escape_length_mm + corner_piece_inset_mm)])
      cube([0.5 * strip_width_mm, 2 * strip_thickness_mm, strip_escape_length_mm + corner_piece_inset_mm], center = true);
      
      // TODO: escape, plus factor in inset on bottom end (more escape on bottom than top)
      //cube([strip_width_mm, bracket_depth_mm
    }
  }
}

mirror_retention_block_width_mm = mirror_retention_depth_mm + bracket_depth_mm / sqrt(2);

for (i = [-1, 1])
{
  scale([-i, 1, 1])
  intersection()
  {
    translate([-bracket_width_mm / 2, 0, 0])
    translate([bracket_depth_mm / sqrt(2) / 2, bracket_depth_mm * (1 - sqrt(2) / 2) / 2, 0.5 * height_mm])
    rotate([0, 0, 45])
    difference()
    {
      translate([-0.5 * mirror_retention_block_width_mm, 0, 0])
      cube([mirror_retention_block_width_mm, bracket_depth_mm, height_mm], center = true);
      
      translate([-mirror_retention_block_width_mm + 0.5 * mirror_retention_depth_mm - 1, -0.5 * bracket_depth_mm + 0.5 * mirror_thickness_mm + mirror_retention_inset_mm, 0])
      cube([mirror_retention_depth_mm + 2, mirror_thickness_mm, 5 * height_mm], center = true);
    }

    union()
    {
      translate([-3.5 * bracket_width_mm, 0, 0])
      cube([6 * bracket_width_mm, 6 * bracket_width_mm, 4 * height_mm], center = true);
      
      translate([0, -3.5 * bracket_depth_mm, 0])
      cube([4 * bracket_width_mm, 6 * bracket_depth_mm, 4 * height_mm], center = true);
    }
  }
}

