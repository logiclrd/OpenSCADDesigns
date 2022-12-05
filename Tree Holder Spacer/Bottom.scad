$fn = 64;

stand_diameter = 8.45 * 25.4;
tree_diameter = 3.6 * 25.4;
printer_bed_size = 220;
spacer_thickness = 6;
outer_wall_width = 6;
grid_spacing = 12;
grid_line_width = 4;
water_space = 3;

stand_radius = stand_diameter / 2;

union()
{
  difference()
  {
    cylinder(spacer_thickness, stand_radius, stand_radius, center = true);
    cylinder(spacer_thickness + 2, stand_radius - outer_wall_width, stand_radius - outer_wall_width, center = true);
  }

  intersection()
  {
    cylinder(spacer_thickness, stand_radius - 1, stand_radius - 1, center = true);
    
    for (qq = [0 : printer_bed_size / grid_spacing])
    {
      q = qq * grid_spacing;

      translate([q, 0, water_space])
      cube([grid_line_width, printer_bed_size, spacer_thickness], center = true);
      translate([-q, 0, water_space])
      cube([grid_line_width, printer_bed_size, spacer_thickness], center = true);

      translate([0, q, water_space])
      cube([printer_bed_size, grid_line_width, spacer_thickness], center = true);
      translate([0, -q, water_space])
      cube([printer_bed_size, grid_line_width, spacer_thickness], center = true);
    }
  }

  intersection()
  {
    cylinder(spacer_thickness, stand_radius - 1, stand_radius - 1, center = true);

    intersection()
    {
      union()
      {
        for (qq = [0 : printer_bed_size / grid_spacing])
        {
          q = qq * grid_spacing;

          translate([q, 0, 0])
          cube([grid_line_width, printer_bed_size, spacer_thickness], center = true);
          translate([-q, 0, 0])
          cube([grid_line_width, printer_bed_size, spacer_thickness], center = true);
        }
      }

      union()
      {
        for (qq = [0 : printer_bed_size / grid_spacing])
        {
          q = qq * grid_spacing;

          translate([0, q, 0])
          cube([printer_bed_size, grid_line_width, spacer_thickness], center = true);
          translate([0, -q, 0])
          cube([printer_bed_size, grid_line_width, spacer_thickness], center = true);
        }
      }
    }
  }
}