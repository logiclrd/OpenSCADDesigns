track_width = 84;
track_height = 16;
track_spacing = 18;
first_track_offset = 4;
track_slot_width = 4.5;
track_slot_height = 5;
track_slot_lip = 4;
top_channel_width = 30;
top_channel_inset = 5;
last_track_offset = first_track_offset + track_spacing * 4;
wheel_thickness = 5;
wheel_diameter = 25;
wheel_bevel_factor = 1 / 25;
wheel_bevel_thickness = wheel_thickness * 0.3;
wheel_flat_thickness = wheel_thickness - 2 * wheel_bevel_thickness;
wheel_total_height = 10;
wheel_right_offset = first_track_offset - 0.25;
wheel_left_offset = last_track_offset + wheel_total_height / 2 - 0.25;
axle_spacing = 100;
axle_height = -12;
wheel_base = 10;
carriage_length = axle_spacing + 2 * wheel_base;

carriage_bar_thickness = 8;
carriage_bar_height = 16;
carriage_plate_length = axle_spacing - 0;

module track()
{
  translate([-20, 0, 0])
  difference()
  {
    cube([200, track_width, track_height]);
    
    translate([-1, top_channel_inset, track_height - track_slot_height])
    cube([202, top_channel_width, track_slot_height + 1]);
    
    translate([-1, top_channel_inset - track_slot_lip, track_height - 1])
    cube([202, top_channel_width, track_slot_height]);
    
    for (t = [0 : 4])
    {
      translate([-1, track_spacing * t + first_track_offset, -1])
      cube([202, track_slot_width, 8]);
    }
  }
}

wheel_bearing_radius = 6;
wheel_mount_radius = 4.5;
wheel_axle_radius = 1;

module wheel()
{
  difference()
  {
    union()
    {
      cylinder(wheel_bevel_thickness, wheel_diameter * 0.5 * (1 - wheel_bevel_factor), wheel_diameter * 0.5, $fn = 96);
      translate([0, 0, wheel_bevel_thickness])
      cylinder(wheel_flat_thickness, wheel_diameter * 0.5, wheel_diameter * 0.5, $fn = 96);
      translate([0, 0, wheel_bevel_thickness + wheel_flat_thickness])
      cylinder(wheel_bevel_thickness, wheel_diameter * 0.5, wheel_diameter * 0.5 * (1 - wheel_bevel_factor), $fn = 96);
    }
    
    translate([0, 0, -0.5])
    cylinder(6, wheel_bearing_radius, wheel_bearing_radius, $fn = 40);
  }
  
  cylinder(5, wheel_bearing_radius - 0.1, wheel_bearing_radius - 0.1, $fn = 40);
  difference()
  {
    cylinder(wheel_total_height, wheel_mount_radius, wheel_mount_radius, $fn = 40);
    translate([-0.5, 0, 0])
    cylinder(wheel_total_height + 1, wheel_axle_radius, wheel_axle_radius, $fn = 40);
    for (i = [0 : 10])
    {
      translate([0, 0, wheel_total_height - 0.4])
      rotate([0, 0, i * 360 / 11])
      translate([0, 0.3, 0])
      cube([wheel_mount_radius * 2.2, 0.8, 1]);
    }
  }
}

carriage_plate_width = wheel_left_offset - wheel_right_offset - 2 * wheel_total_height;
carriage_plate_thickness = carriage_bar_height - 2;

module carriage()
{
  // Carriage bars (left/right), to which the lower wheels attach
  translate([-wheel_base, wheel_left_offset - wheel_total_height - carriage_bar_thickness, axle_height - carriage_bar_height * 0.5])
  cube([carriage_length, carriage_bar_thickness, carriage_bar_height]);

  translate([-wheel_base, wheel_right_offset + wheel_total_height, axle_height - carriage_bar_height * 0.5])
  cube([carriage_length, carriage_bar_thickness, carriage_bar_height]);
  
  // Carriage plate
  translate([0, wheel_right_offset + wheel_total_height, axle_height - carriage_plate_thickness * 0.5])
  cube([axle_spacing, carriage_plate_width, carriage_plate_thickness]);
}

if ($preview)
  track();

carriage();

translate([0, wheel_left_offset, axle_height])
rotate([90, 0, 0])
wheel();

translate([axle_spacing, wheel_left_offset, axle_height])
rotate([90, 0, 0])
wheel();

translate([0, wheel_right_offset, axle_height])
rotate([-90, 0, 0])
wheel();

translate([axle_spacing, wheel_right_offset, axle_height])
rotate([-90, 0, 0])
wheel();

translate([axle_spacing / 2, wheel_thickness * 0.5 + top_channel_inset + top_channel_width * 0.5, wheel_diameter * 0.5 + track_height - track_slot_height])
rotate([90, 0, 0])
wheel();

carriage();