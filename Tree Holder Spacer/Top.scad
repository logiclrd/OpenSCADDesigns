$fn = 64;

stand_diameter = 8.45 * 25.4;
tree_diameter = 3.6 * 25.4;
printer_bed_size = 220;
spacer_thickness = 6;
support_thickness = 10;
outer_wall_width = 6;
grid_spacing = 12;
grid_line_width = 4;
water_space = 3;
tree_space_camber = 6;
tree_space_support_diameter = 6 * 25.4;

stand_radius = stand_diameter / 2;
tree_radius = tree_diameter / 2;

tree_space_support_radius = tree_space_support_diameter / 2;

hole_size = grid_spacing - grid_line_width;

union()
{
  difference()
  {
    cylinder(support_thickness, stand_radius, stand_radius, center = true);
    cylinder(support_thickness + 2, stand_radius - outer_wall_width, stand_radius - outer_wall_width, center = true);
  }

  difference()
  {
    intersection()
    {
      cylinder(support_thickness, stand_radius - 1, stand_radius - 1, center = true);
      
      for (qq = [0 : printer_bed_size / grid_spacing])
      {
        q = qq * grid_spacing;

        translate([q, 0, 0])
        cube([grid_line_width, printer_bed_size, support_thickness], center = true);
        translate([-q, 0, 0])
        cube([grid_line_width, printer_bed_size, support_thickness], center = true);

        translate([0, q, 0])
        cube([printer_bed_size, grid_line_width, support_thickness], center = true);
        translate([0, -q, 0])
        cube([printer_bed_size, grid_line_width, support_thickness], center = true);
      }
    }
    
    translate([0, 0, support_thickness / 2])
    cylinder(support_thickness, tree_radius, tree_radius + tree_space_camber * 2, center = true);
  }

  translate([0, 0, support_thickness / 2])
  difference()
  {
    cylinder(support_thickness * 2, tree_space_support_radius, tree_space_support_radius, center = true);
    cylinder(support_thickness * 2 + 0.05, tree_radius, tree_radius + tree_space_camber * 2, center = true);
  }
}