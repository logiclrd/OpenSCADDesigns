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

cube([hole_size, hole_size, support_thickness + spacer_thickness]);