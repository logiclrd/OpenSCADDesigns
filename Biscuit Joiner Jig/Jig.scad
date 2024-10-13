$fn = 32;

front_plate_width = 123;
front_plate_height = 8;

main_plate_width = 117;
main_plate_height = 146;

small_pin_diameter = 4.5; 
small_pin_inset_x = 18;
small_pin_inset_y = 20;

small_pin_x = front_plate_width * 0.5 - small_pin_inset_x;
small_pin_y = small_pin_inset_y;

large_pin_diameter = 7.5;
large_pin_inset_x = 13.2;
large_pin_inset_y = 10.5;

large_pin_x = front_plate_width * 0.5 - large_pin_inset_x;
large_pin_y = front_plate_height + main_plate_height - large_pin_inset_y;

biscuit_joiner_elevation = 6;

plates_form_height = 50;

jig_block_width = 160;
jig_block_height = main_plate_height + front_plate_height;
jig_block_depth = 25;

pin_height = 8;

fence_distance = 140;
fence_thickness = 8;
fence_width = 100;
fence_height = 50;

fence_bracket_width = small_pin_inset_y - 0.5 * small_pin_diameter;
fence_bracket_length = jig_block_width * 0.5 + fence_distance;

fence_bracket_clamp_height = 8;

module jig_block()
{
  translate([0, jig_block_height * 0.5, jig_block_depth * 0.5])
  cube([jig_block_width, jig_block_height, jig_block_depth], center = true);
}

module plates()
{
  translate([0, front_plate_height * 0.5, plates_form_height * 0.5])
  cube([front_plate_width, front_plate_height, plates_form_height], center = true);
  translate([0, front_plate_height + main_plate_height * 0.5, plates_form_height * 0.5])
  cube([main_plate_width, main_plate_height, plates_form_height], center = true);
}

module pins()
{
  pin_geometry_height = pin_height + biscuit_joiner_elevation;
  
  translate([small_pin_x, small_pin_y, pin_geometry_height * 0.5])
  cylinder(pin_geometry_height, d = small_pin_diameter, center = true);
  translate([-small_pin_x, small_pin_y, pin_geometry_height * 0.5])
  cylinder(pin_geometry_height, d = small_pin_diameter, center = true);

  translate([large_pin_x, large_pin_y, pin_geometry_height * 0.5])
  cylinder(pin_geometry_height, d = large_pin_diameter, center = true);
  translate([-large_pin_x, large_pin_y, pin_geometry_height * 0.5])
  cylinder(pin_geometry_height, d = large_pin_diameter, center = true);
}

module main_jig_piece()
{
  union()
  {
    difference()
    {
      jig_block();
      
      translate([0, 0, biscuit_joiner_elevation])
      plates();

      translate([0.5 * fence_bracket_length - 0.5 * jig_block_width, 0.5 * fence_bracket_width, 0.5 * biscuit_joiner_elevation])
      cube([fence_bracket_length + 2 * fence_thickness, fence_bracket_width, biscuit_joiner_elevation], center = true);
    }

    pins();
  }
}

module fence()
{
  translate([fence_distance, 0, 0])
  translate([0.5 * fence_thickness, 0.5 * fence_width + 0.5 * fence_bracket_width -0.5 * fence_width, 0.5 * fence_height])
  cube([fence_thickness, 2 * fence_width + fence_bracket_width, fence_height], center = true);
 
  translate([0.5 * fence_bracket_length - 0.5 * jig_block_width, 0.5 * fence_bracket_width, 0.5 * biscuit_joiner_elevation])
  cube([fence_bracket_length + 2 * fence_thickness, fence_bracket_width, biscuit_joiner_elevation], center = true);

  translate([0.5 * fence_thickness + 0.5 * jig_block_width, 0.5 * fence_bracket_width, 0.5 * fence_bracket_clamp_height + biscuit_joiner_elevation])
  cube([fence_thickness, fence_bracket_width, fence_bracket_clamp_height], center = true);
  translate([-0.5 * fence_thickness - 0.5 * jig_block_width, 0.5 * fence_bracket_width, 0.5 * fence_bracket_clamp_height + biscuit_joiner_elevation])
  cube([fence_thickness, fence_bracket_width, fence_bracket_clamp_height], center = true);

  intersection()
  {
    translate([0.5 * jig_block_width + fence_thickness, 0, biscuit_joiner_elevation + fence_bracket_clamp_height])
    multmatrix(
      [[1, 0, 0, 0],
       [0, 1, 0, 0],
       [(fence_height - biscuit_joiner_elevation - fence_bracket_clamp_height) / (fence_distance - 0.5 * jig_block_width - fence_thickness), 0, 1, 0],
       [0, 0, 0, 1]])
    translate([0.5 * (fence_distance - 0.5 * jig_block_width - fence_thickness), 0.5 * fence_bracket_width, -0.5 * (fence_height - biscuit_joiner_elevation - fence_bracket_clamp_height) - 5])
    cube([fence_distance - 0.5 * jig_block_width - fence_thickness, fence_bracket_width, fence_height - biscuit_joiner_elevation - fence_bracket_clamp_height + 10], center = true);

    translate([0, 0, 150])
    cube([300, 300, 300], center = true);
  }
}


color("teal") main_jig_piece();

color("red") fence();

