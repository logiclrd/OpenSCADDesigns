strip_thickness_mm = 0.5;
strip_width_mm = 8.5;
strip_retention_wall_mm = 1.5;
strip_retention_wall_angle = 40;
strip_separation_mm = 1;
strip_depth_mm = 1;
bracket_width_mm = strip_width_mm * 2 + 3 * strip_separation_mm;
bracket_depth_mm = 4;
mirror_thickness_mm = 1.2;
mirror_retention_depth_mm = 3;
mirror_retention_inset_mm = 1.2;
slot_tolerance_mm = 0.4;
mirror_width_mm = 200;

mirror_retention_block_width_mm = mirror_retention_depth_mm + bracket_depth_mm / sqrt(2);
corner_piece_offset_mm = bracket_width_mm / 2 - bracket_depth_mm / 2 + (mirror_retention_block_width_mm - mirror_retention_depth_mm) * sqrt(2);
corner_piece_inset_mm = 6;
floor_inset_mm = 38;
base_chamfer_height_mm = 12;
top_corner_chamfer_mm = 12;
top_pin_area_mm = 21;
corner_piece_hole_depth_mm = 8;
lid_retention_thickness_mm = 2.5;
floor_size_mm = 201;
ceiling_size_mm = floor_size_mm + 2 * lid_retention_thickness_mm;
top_thickness_mm = corner_piece_hole_depth_mm + 4;

horizontal_bracket_length_mm = 7.625 * 25.4;
horizontal_bracket_retention_width_mm = 6 * 25.4;
horizontal_bracket_retention_wall_thickness_mm = 2.5;
horizontal_bracket_retention_tolerance_mm = 0.3;

pin_width_mm = 10;
pin_depth_mm = 8;
pin_inset_mm = 10;
pin_thickness_mm = 4;
pin_top_thickness_mm = 3;
pin_insertion_easing_mm = 0.6;

pin_insertion_depth_mm = pin_depth_mm - pin_top_thickness_mm;
pin_insertion_tolerance_mm = 0.3;

pin_insertion_extra_mm = 1;

strip_retention_wall_skew_factor = tan(strip_retention_wall_angle);
strip_retention_wall_x_mm = strip_retention_wall_mm * strip_retention_wall_skew_factor;

module profile(height_mm)
{
  translate([0, 0, height_mm * 0.5])
  cube([bracket_width_mm, bracket_depth_mm, height_mm], center = true);

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
}

base_chamfer_generation_side_mm = mirror_width_mm + corner_piece_offset_mm * sqrt(2) * 2 + corner_piece_inset_mm * 2 + top_thickness_mm * 2;
base_side_mm = mirror_width_mm + corner_piece_offset_mm * sqrt(2) * 2 + corner_piece_inset_mm * 2 + base_chamfer_height_mm * 2;
top_side_mm = mirror_width_mm + corner_piece_offset_mm * sqrt(2) * 2 + corner_piece_inset_mm * 2;

strip_retention_angle = 28;

strip_retention_min_mm = ceiling_size_mm * 0.5;
strip_retention_max_mm = mirror_width_mm * 0.5 + corner_piece_offset_mm * sqrt(2) - bracket_depth_mm + mirror_retention_inset_mm;
strip_retention_width_mm = strip_retention_max_mm - strip_retention_min_mm;

strip_retention_width_flat_mm = strip_retention_width_mm / cos(strip_retention_angle);

clamp_width_mm = mirror_width_mm + 2 * bracket_width_mm / sqrt(2) + 3 * bracket_depth_mm;
clamp_depth_mm = bracket_width_mm + bracket_depth_mm * 2 + 2.5;
clamp_thickness_mm = 10;
clamp_height_mm = 20;

module clamp()
{
  translate([0, 1.855, 0])
  union()
  {
    difference()
    {
      translate([0, -mirror_width_mm / 2 + clamp_depth_mm / 2 - bracket_width_mm - bracket_depth_mm * 0.5 + bracket_depth_mm * 0.5 - 1 - clamp_thickness_mm / 4, clamp_height_mm / 2])
      cube([clamp_width_mm, clamp_depth_mm - bracket_depth_mm * 2 + clamp_thickness_mm / 2, clamp_height_mm], center = true);

      color("red")
      for (i = [1 : 2])
      {
        rotate([0, 0, 45 + 90 * i])
        translate([0, mirror_width_mm / sqrt(2) + corner_piece_offset_mm, 0])
        minkowski()
        {
          profile(100);
          sphere(d = slot_tolerance_mm, $fn = 10);
        }
      }
      
      difference()
      {
        color("green")
        translate([0, -0.5 * mirror_width_mm - (bracket_width_mm / 2 + bracket_depth_mm / 2) + (bracket_width_mm + bracket_depth_mm * 2) - bracket_width_mm, 5])
        cube([mirror_width_mm + bracket_width_mm * sqrt(2) + bracket_depth_mm, bracket_width_mm * 1.25, clamp_height_mm * 2], center = true);

        for (i = [-1, 1])
        {
          rotate([0, 0, 45 * i])
          translate([0, -mirror_width_mm / sqrt(2) - bracket_width_mm - bracket_depth_mm * 3, 4])
          cube([2 * bracket_width_mm, 2 * bracket_width_mm, clamp_height_mm * 3], center = true);
        }
      }
      
      for (i = [-1, 1])
      {
        color("blue")
        rotate([0, 0, 45 * i])
        translate([0, -mirror_width_mm / sqrt(2) - bracket_width_mm - bracket_depth_mm * 3.5 - clamp_thickness_mm / 2, 4])
        cube([2 * bracket_width_mm, 2 * bracket_width_mm, clamp_height_mm * 2], center = true);
      }

      translate([25 + mirror_width_mm / 2, -mirror_width_mm / 2, clamp_height_mm / 2 + 25])
      cube([65, 65, 50], center = true);
      translate([-(25 + mirror_width_mm / 2), -mirror_width_mm / 2, clamp_height_mm / 2 - 25])
      cube([65, 65, 50], center = true);
    }
  }
}

module clamp_with_cable_port()
{
  translate([0, 1.855, 0])
  union()
  {
    difference()
    {
      translate([0, -mirror_width_mm / 2 + clamp_depth_mm / 2 - bracket_width_mm - bracket_depth_mm * 0.5 + bracket_depth_mm * 0.5 - 1 - clamp_thickness_mm / 4, clamp_height_mm * 0.75])
      cube([clamp_width_mm, clamp_depth_mm - bracket_depth_mm * 2 + clamp_thickness_mm / 2, clamp_height_mm * 1.5], center = true);

      color("red")
      for (i = [1 : 2])
      {
        rotate([0, 0, 45 + 90 * i])
        translate([0, mirror_width_mm / sqrt(2) + corner_piece_offset_mm, 0])
        minkowski()
        {
          profile(100);
          sphere(d = slot_tolerance_mm, $fn = 10);
        }
      }
      
      difference()
      {
        color("green")
        translate([0, -0.5 * mirror_width_mm - (bracket_width_mm / 2 + bracket_depth_mm / 2) + (bracket_width_mm + bracket_depth_mm * 2) - bracket_width_mm, 5])
        cube([mirror_width_mm + bracket_width_mm * sqrt(2) + bracket_depth_mm, bracket_width_mm * 1.25, clamp_height_mm * 3], center = true);

        for (i = [-1, 1])
        {
          rotate([0, 0, 45 * i])
          translate([0, -mirror_width_mm / sqrt(2) - bracket_width_mm - bracket_depth_mm * 3, 4])
          cube([2 * bracket_width_mm, 2 * bracket_width_mm, clamp_height_mm * 4], center = true);
        }
      }
      
      for (i = [-1, 1])
      {
        color("blue")
        rotate([0, 0, 45 * i])
        translate([0, -mirror_width_mm / sqrt(2) - bracket_width_mm - bracket_depth_mm * 3.5 - clamp_thickness_mm / 2, 4])
        cube([2 * bracket_width_mm, 2 * bracket_width_mm, clamp_height_mm * 3], center = true);
      }

      translate([-100, -mirror_width_mm / 2 + clamp_depth_mm / 2 - bracket_width_mm - bracket_depth_mm * 0.5 + bracket_depth_mm * 0.5 - 1 - clamp_thickness_mm / 4, clamp_height_mm * 1.5])
      cube([clamp_width_mm, clamp_depth_mm - bracket_depth_mm * 2 + clamp_thickness_mm / 2, clamp_height_mm], center = true);
      
      translate([25 + mirror_width_mm / 2, -mirror_width_mm / 2, clamp_height_mm / 2 - 25 + clamp_height_mm / 2])
      cube([65, 65, 50], center = true);
      translate([-(25 + mirror_width_mm / 2), -mirror_width_mm / 2, clamp_height_mm / 2 - 25])
      cube([65, 65, 50], center = true);

      translate([clamp_width_mm / 2 - 100, -mirror_width_mm / 2 - clamp_depth_mm / 2, clamp_height_mm * 1.5])
      multmatrix(
        [[1, 0, 0, 0],
         [0, 1, 0, 0],
         [0.5, 0, 1, 0],
         [0, 0, 0, 1]])
      translate([clamp_height_mm, 0, 0])
      cube([clamp_height_mm * 2, clamp_depth_mm, clamp_height_mm], center = true);
    }
  }
}

//clamp();

clamp_with_cable_port();