width_top = 41;
width_bottom = 25.5;
height = 51.5;
plate_thickness = 3.1;
neck_reduction = 9.25;
neck_thickness = 4.5;
glue_helper_count_x = 8;
glue_helper_count_y = 10;
glue_helper_amplitude = 5;

difference()
{
  union()
  {
    multmatrix(
     [[1, -(width_top - width_bottom) / height / 2, 0, -(width_top - width_bottom) / 4],
      [0, 1, 0, 0],
      [0, 0, 1, 0],
      [0, 0, 0, 1]])
    {
      translate([0, 0, plate_thickness / 2])
      cube([width_bottom, height, plate_thickness], center = true);

      translate([0, 0, plate_thickness + neck_thickness / 2])
      cube([width_bottom - neck_reduction * 2, height, neck_thickness], center = true);
      translate([neck_reduction * 0.375, (height - height / 1.75) / 2, plate_thickness + neck_thickness / 2])
      cube([width_bottom - neck_reduction * 1.5, height / 1.75, neck_thickness], center = true);

      translate([0, 0, plate_thickness + neck_thickness + plate_thickness / 2])
      cube([width_bottom, height, plate_thickness], center = true);
    }

    multmatrix(
     [[1, (width_top - width_bottom) / height / 2, 0, (width_top - width_bottom) / 4],
      [0, 1, 0, 0],
      [0, 0, 1, 0],
      [0, 0, 0, 1]])
    {
      translate([0, 0, plate_thickness / 2])
      cube([width_bottom, height, plate_thickness], center = true);

      translate([0, 0, plate_thickness + neck_thickness / 2])
      cube([width_bottom - neck_reduction * 2, height, neck_thickness], center = true);
      translate([-neck_reduction * 0.375, (height - height / 1.75) / 2, plate_thickness + neck_thickness / 2])
      cube([width_bottom - neck_reduction * 1.5, height / 1.75, neck_thickness], center = true);

      translate([0, 0, plate_thickness + neck_thickness + plate_thickness / 2])
      cube([width_bottom, height, plate_thickness], center = true);
    }
  }
  
  for (xi = [-glue_helper_count_x / 2 : glue_helper_count_x / 2])
    for (yi = [-glue_helper_count_y / 2 : glue_helper_count_y / 2])
    {
      yt = (yi + glue_helper_count_y / 2) / glue_helper_count_y;
      
      w = width_top * (1 - yt) + width_bottom * yt;
      
      x = xi * w / (glue_helper_count_x + 1);
      y = -yi * height / (glue_helper_count_y + 1);
      
      q = xi * 51335667 + yi * 24566617;
      r = q % 21;
      s = q % 31;
      
      translate([x, y, plate_thickness + neck_thickness + plate_thickness * 3 / 4])
      rotate([(r - 10) * 0.15 * glue_helper_amplitude, (s - 15) * 0.1 * glue_helper_amplitude, 0])
      cylinder(10, d = 1);
    }
}