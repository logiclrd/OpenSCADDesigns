corner_piece_inset_mm = 10;
vertical_bracket_height_mm = (11 + 11/32) * 0.5 * 25.4 + 2 * corner_piece_inset_mm;
horizontal_bracket_length_mm = 7.625 * 25.4;
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

module strip_retention(side, height_mm, top_escape_mm, bottom_escape_mm)
{
  strip_offset = 0.5 * (strip_width_mm + strip_separation_mm);

  translate([side * strip_offset, -0.5 * bracket_depth_mm + 0.5 * strip_thickness_mm + strip_depth_mm, 0])
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

    translate([-side * 0.25 * strip_width_mm, -1.5 * strip_thickness_mm, height_mm - 0.5 * top_escape_mm])
    cube([0.5 * strip_width_mm, 2 * strip_thickness_mm, top_escape_mm], center = true);

    translate([-side * 0.25 * strip_width_mm, -1.5 * strip_thickness_mm, 0.5 * bottom_escape_mm])
    cube([0.5 * strip_width_mm, 2 * strip_thickness_mm, bottom_escape_mm], center = true);
  }
}

module vertical_bracket()
{
  union()
  {
    difference()
    {
      translate([0, 0, vertical_bracket_height_mm * 0.5])
      cube([bracket_width_mm, bracket_depth_mm, vertical_bracket_height_mm], center = true);

      for (i = [-1, 1])
        strip_retention(i, vertical_bracket_height_mm, strip_escape_length_mm + corner_piece_inset_mm, strip_escape_length_mm + corner_piece_inset_mm);
    }

    mirror_retention_block_width_mm = mirror_retention_depth_mm + bracket_depth_mm / sqrt(2);

    for (i = [-1, 1])
    {
      scale([-i, 1, 1])
      intersection()
      {
        translate([-bracket_width_mm / 2, 0, 0])
        translate([bracket_depth_mm / sqrt(2) / 2, bracket_depth_mm * (1 - sqrt(2) / 2) / 2, 0.5 * vertical_bracket_height_mm])
        rotate([0, 0, 45])
        difference()
        {
          translate([-0.5 * mirror_retention_block_width_mm, 0, 0])
          cube([mirror_retention_block_width_mm, bracket_depth_mm, vertical_bracket_height_mm], center = true);

          translate([-mirror_retention_block_width_mm + 0.5 * mirror_retention_depth_mm - 1, -0.5 * bracket_depth_mm + 0.5 * mirror_thickness_mm + mirror_retention_inset_mm, 0])
          cube([mirror_retention_depth_mm + 2, mirror_thickness_mm, 5 * vertical_bracket_height_mm], center = true);
        }

        union()
        {
          translate([-3.5 * bracket_width_mm, 0, 0])
          cube([6 * bracket_width_mm, 6 * bracket_width_mm, 4 * vertical_bracket_height_mm], center = true);

          translate([0, -3.5 * bracket_depth_mm, 0])
          cube([4 * bracket_width_mm, 6 * bracket_depth_mm, 4 * vertical_bracket_height_mm], center = true);
        }
      }
    }
  }
}

module horizontal_bracket()
{
  difference()
  {
    translate([0, 0, horizontal_bracket_length_mm * 0.5])
    cube([bracket_width_mm, bracket_depth_mm, horizontal_bracket_length_mm], center = true);

    strip_retention(-1, horizontal_bracket_length_mm, strip_escape_length_mm, strip_escape_length_mm);
  }
}

translate([-20, 0, 0])
vertical_bracket();

translate([20, 0, 0])
horizontal_bracket();