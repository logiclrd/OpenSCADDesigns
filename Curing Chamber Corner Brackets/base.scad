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
base_thickness_mm = floor_inset_mm + 6;
base_chamfer_height_mm = 12;
corner_piece_hole_depth_mm = 8;
floor_size_mm = 201;

pin_width_mm = 10;
pin_depth_mm = 8;
pin_inset_mm = 10;
pin_thickness_mm = 4;
pin_top_thickness_mm = 3;
pin_insertion_easing_mm = 0.6;

pin_insertion_depth_mm = pin_depth_mm - pin_top_thickness_mm;
pin_insertion_tolerance_mm = 0.3;

pin_insertion_extra_mm = 1;

module pin()
{
  difference()
  {
    cube([2 * pin_inset_mm, pin_width_mm, pin_depth_mm], center = true);
    
    translate([0, 0, -pin_top_thickness_mm])
    cube([2 * pin_inset_mm - 2 * pin_thickness_mm, pin_width_mm * 2, pin_depth_mm], center = true);

    for (i = [-1, 1])
    {
      translate([-i * (pin_inset_mm - pin_thickness_mm * 1.5), 0, 0.5 * pin_insertion_depth_mm - 0.5 * pin_depth_mm])
      multmatrix(
        [[1, 0, i * pin_insertion_easing_mm / (2 * pin_insertion_depth_mm), 0],
         [0, 1, 0, 0],
         [0, 0, 1, 0],
         [0, 0, 0, 1]])
      cube([pin_thickness_mm, 2 * pin_width_mm, pin_insertion_depth_mm], center = true);
    }
  }
}

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

base_chamfer_generation_side_mm = mirror_width_mm + corner_piece_offset_mm * sqrt(2) * 2 + corner_piece_inset_mm * 2 + base_thickness_mm * 2;
base_side_mm = mirror_width_mm + corner_piece_offset_mm * sqrt(2) * 2 + corner_piece_inset_mm * 2 + base_chamfer_height_mm * 2;

echo(base_chamfer_generation_side_mm);

module base()
{
  difference()
  {
    intersection()
    {
      roof()
      square(base_chamfer_generation_side_mm, center = true);
      
      linear_extrude(height = base_thickness_mm)
      square(2 * mirror_width_mm, center = true);
    }

    color("red")
    for (i = [1 : 4])
    {
      rotate([0, 0, 45 + 90 * i])
      translate([0, mirror_width_mm / sqrt(2) + corner_piece_offset_mm, base_thickness_mm - corner_piece_hole_depth_mm + slot_tolerance_mm / 2])
      minkowski()
      {
        profile(corner_piece_hole_depth_mm + 1);
        sphere(d = slot_tolerance_mm, $fn = 10);
      }
    }

    translate([0, 0, base_thickness_mm - floor_inset_mm])
    linear_extrude(floor_inset_mm + 1)
    square(floor_size_mm, center = true);

    for (i = [0 : 3])
      rotate([0, 0, i * 90])
      translate([0, base_side_mm, 0])
      cube([base_side_mm * 2, base_side_mm, base_thickness_mm * 2], center = true);
  }
}

module base_segment()
{
  difference()
  {
    base();

    for (i = [-45, 45])
    {
      rotate([0, 0, i])
      {
        translate([0, -base_side_mm, 0])
        cube([base_side_mm * 2, base_side_mm * 2, base_thickness_mm * 2], center = true);

        translate([0, (base_side_mm + floor_size_mm) / 2 / sqrt(2), 0.5 * pin_depth_mm + pin_insertion_extra_mm])
        rotate([180, 0, 0])
        minkowski()
        {
          union()
          {
            pin();
            
            translate([0, 0, pin_depth_mm])
            cube([2 * pin_inset_mm, pin_width_mm, pin_depth_mm], center = true);
          }
          
          sphere(d = pin_insertion_tolerance_mm, $fn = 12);
        }
      }
    }
  }
}

base_segment();
//pin();

/*
difference()
{
  base_segment();

  translate([0, -45, 0])
  cube([base_side_mm * 2, base_side_mm, base_thickness_mm * 2], center = true);
  rotate([0, 0, 90])
  translate([0, -45, 0])
  cube([base_side_mm * 2, base_side_mm, base_thickness_mm * 2], center = true);
}
*/