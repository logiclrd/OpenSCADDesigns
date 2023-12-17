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

wheel_bearing_radius = 6;
wheel_mount_radius = 4.5;
wheel_axle_radius = 1;

wheel_right_offset = first_track_offset - 0.25;
wheel_left_offset = last_track_offset + wheel_total_height / 2 - 0.25;

axle_spacing = 100;
axle_height = -12;
axle_hardware_allowance = 7;

wheel_base = 10;

carriage_length = axle_spacing + 2 * wheel_base;

carriage_bar_thickness = 8;
carriage_bar_height = 16;
carriage_plate_length = axle_spacing - 0;
carriage_plate_width = wheel_left_offset - wheel_right_offset - 2 * wheel_total_height;
carriage_plate_thickness = carriage_bar_height;

tensioner_thickness = 6;
tensioner_height = 16;
tensioner_arm_length = axle_spacing * 0.5;

tensioner_arm_movement_space = 0.5;
tensioner_spring_diameter = 6;
tensioner_spring_radius = tensioner_spring_diameter * 0.5;
tensioner_spring_width = 8;
tensioner_wire_length = 11;
tensioner_resting_angle = 45;

tensioner_axle_z = 0.5 * (tensioner_height + tensioner_thickness * 2) + wheel_diameter * 0.5 + track_height * 0.5 - track_slot_height - tensioner_thickness + tensioner_thickness;
tensioner_axle_minimum_y = 0.5 * tensioner_height + top_channel_inset - 4 * tensioner_thickness;

module track()
{
  color("#dddddd")
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

module wheels()
{
  color("#dddddd")
  {
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
  }
}

module carriage_bar_plate_interface(expansion = 0)
{
  multmatrix(
    [[1, 0, 0, -carriage_length * 0.3],
     [-1, 1, 0, -carriage_bar_thickness * 0.5],
     [0, 0, 1, carriage_bar_height / 6],
     [0, 0, 0, 1]])
  {
    cube([carriage_bar_thickness + expansion, carriage_bar_thickness + expansion, carriage_bar_height * 2 / 3 + expansion], center = true);

    intersection()
    {
      cube([carriage_bar_thickness + expansion, carriage_bar_thickness + expansion, carriage_bar_height + expansion], center = true);
      
      translate([0, -50, 0])
      cube([100, 100, 100], center = true);
    }
  }
}

module tensioner_arm()
{
  translate(
    [
      axle_spacing / 2 + tensioner_arm_length / 2 - wheel_bearing_radius * 1.5 - 0.25 * tensioner_height,
      wheel_thickness * 0.5 + top_channel_inset + top_channel_width * 0.5 - tensioner_thickness * 0.5 - wheel_total_height,
      tensioner_height * 0.5 + wheel_diameter * 0.5 + track_height * 0.5 - track_slot_height
    ])
  difference()
  {
    // Main body of arm.
    union()
    {
      cube(
        [
          tensioner_arm_length + wheel_bearing_radius - 0.5 * tensioner_height - tensioner_thickness * 2,
          tensioner_thickness,
          tensioner_height
        ],
        center = true);
    
      translate(
        [
          0.5 * (tensioner_arm_length + wheel_bearing_radius - 0.5 * tensioner_height),
          0,
          0
        ])
      rotate([90, 0, 0])
      cylinder(tensioner_thickness, d = tensioner_height, center = true, $fn = 64);

      translate(
        [
          -0.5 * (tensioner_arm_length + wheel_bearing_radius - 0.5 * tensioner_height) + tensioner_thickness,
          0,
          0
        ])
      rotate([90, 0, 0])
      cylinder(tensioner_thickness, d = tensioner_height, center = true, $fn = 64);
    }

    // Insertion space for the spring.
    translate(
      [
        0.5 * tensioner_arm_length,
        0,
        0
      ])
    rotate([90, 0, 0])
    cylinder(tensioner_spring_width + 6 * tensioner_thickness, tensioner_spring_radius, tensioner_spring_radius, center = true, $fn = 40);

    translate(
      [
        0.5 * tensioner_arm_length,
        3 * tensioner_thickness,
        0
      ])
    rotate([0, tensioner_resting_angle, 0])
    translate(
      [
        tensioner_spring_radius - 0.5,
        -3 * tensioner_thickness,
        -0.5 * (tensioner_wire_length - 0.5 * tensioner_spring_width)
      ])
    cube([1, tensioner_spring_width + 6 * tensioner_thickness, tensioner_wire_length - 0.5 * tensioner_spring_width], center = true);
    
    // Detent to trap the spring.
    translate(
      [
        0.5 * tensioner_arm_length,
        3 * tensioner_thickness,
        0
      ])
    rotate([0, tensioner_resting_angle + 6, 0])
    translate(
      [
        tensioner_spring_radius - 0.5,
        -3 * tensioner_thickness,
        -0.5 * (tensioner_wire_length - 0.5 * tensioner_spring_width)
      ])
    cube([1, 1, tensioner_wire_length - 0.5 * tensioner_spring_width], center = true);

    // Screw hole for the wheel axle -- this doesn't line up exactly with the middle of the carriage, but I can't be bothered to rejigger the tensioner bracket. :-P
    translate([-0.5 * tensioner_arm_length + tensioner_thickness * 1.2 /* fudge factor */, 0, 0])
    rotate([90, 0, 0])
    cylinder(100, wheel_axle_radius * 1.2, wheel_axle_radius * 1.2, $fn = 30, center = true);
  }
}

module tensioner_bracket()
{
  difference()
  {
    // Hub for tensioner arm and connection to carriage.
    union()
    {
      intersection()
      {
        translate(
          [
            axle_spacing / 2 + 2 * tensioner_thickness - wheel_bearing_radius * 2 - 3 * tensioner_thickness + tensioner_arm_length + wheel_bearing_radius,
            tensioner_axle_minimum_y + 3 * tensioner_thickness,
            tensioner_axle_z
          ])
        rotate([90, 0, 0])
        cylinder(6 * tensioner_thickness, 3 * tensioner_thickness, 3 * tensioner_thickness, center = true, $fn = 60);
        
        translate([0, 0, 100 + track_height + 1])
        cube([200, 200, 200], center = true);
      }
      
      lowermost_z = axle_height - 0.5 * carriage_plate_thickness;
      
      arm_height = tensioner_axle_z - lowermost_z - tensioner_spring_radius;

      translate([axle_spacing - 3 * tensioner_thickness, tensioner_axle_minimum_y, lowermost_z + arm_height])
      multmatrix(
        [[1, 0, 1, 0],
         [0, 1, 0, 0],
         [0, 0, 1, 0],
         [0, 0, 0, 1]])
      translate([0, 0, -arm_height])
      cube([tensioner_thickness * 3, tensioner_thickness * 1.5, arm_height]);

      translate([axle_spacing - 3 * tensioner_thickness, tensioner_axle_minimum_y, lowermost_z + arm_height])
      multmatrix(
        [[1, 0, 1, 0],
         [0, 1, 0, 0],
         [0, 0, 1, 0],
         [0, 0, 0, 1]])
      translate([0, 0, -arm_height])
      cube([tensioner_thickness * 3, wheel_right_offset + wheel_total_height - tensioner_axle_minimum_y + 1, carriage_bar_height]);
    }

    
    // Channel for the tensioner arm to rotate within.
    translate(
      [
        axle_spacing / 2 + tensioner_arm_length / 2 - wheel_bearing_radius * 1.5,
        wheel_thickness * 0.5 + top_channel_inset + top_channel_width * 0.5 - tensioner_thickness * 0.5 - wheel_total_height,
        tensioner_height * 0.5 + wheel_diameter * 0.5 + track_height * 0.5 - track_slot_height
      ])
    cube(
      [
        tensioner_arm_length + wheel_bearing_radius,
        tensioner_thickness + tensioner_arm_movement_space,
        tensioner_height * 1.4
      ],
      center = true);

    translate(
      [
        axle_spacing / 2 + 2 * tensioner_thickness - wheel_bearing_radius * 2 - 3 * tensioner_thickness + tensioner_arm_length + wheel_bearing_radius,
        wheel_thickness * 0.5 + top_channel_inset + top_channel_width * 0.5 - tensioner_thickness * 0.5 - wheel_total_height,
        0.5 * (tensioner_height + tensioner_thickness * 2) + wheel_diameter * 0.5 + track_height * 0.5 - track_slot_height - tensioner_thickness + tensioner_thickness
      ])
    rotate([90, 0, 0])
    cylinder(tensioner_thickness + tensioner_arm_movement_space, 2 * tensioner_thickness, 2 * tensioner_thickness, center = true, $fn = 60);

    // Channel for insertion of the spring.
    translate(
      [
        axle_spacing / 2 + 2 * tensioner_thickness - wheel_bearing_radius * 2 - 3 * tensioner_thickness + tensioner_arm_length + wheel_bearing_radius,
        wheel_thickness * 0.5 + top_channel_inset + top_channel_width * 0.5 - tensioner_thickness * 0.5 - wheel_total_height + tensioner_thickness + 2 * tensioner_arm_movement_space - 0.5 * tensioner_spring_width + 3 * tensioner_thickness,
        0.5 * (tensioner_height + tensioner_thickness * 2) + wheel_diameter * 0.5 + track_height * 0.5 - track_slot_height - tensioner_thickness + tensioner_thickness
      ])
    rotate([90, 0, 0])
    cylinder(tensioner_spring_width + 6 * tensioner_thickness, tensioner_spring_radius, tensioner_spring_radius, center = true, $fn = 40);

    translate(
      [
        axle_spacing / 2 + 2 * tensioner_thickness - wheel_bearing_radius * 2 - 3 * tensioner_thickness + tensioner_arm_length + wheel_bearing_radius,
        wheel_thickness * 0.5 + top_channel_inset + top_channel_width * 0.5 - tensioner_thickness * 0.5 - wheel_total_height + tensioner_thickness + 2 * tensioner_arm_movement_space - 0.5 * tensioner_spring_width + 6 * tensioner_thickness,
        0.5 * (tensioner_height + tensioner_thickness * 2) + wheel_diameter * 0.5 + track_height * 0.5 - track_slot_height - tensioner_thickness + tensioner_thickness
      ])
    rotate([0, tensioner_resting_angle, 0])
    translate(
      [
        -tensioner_spring_radius + 0.5,
        -3 * tensioner_thickness,
        -0.5 * (tensioner_wire_length - 0.5 * tensioner_spring_width)
      ])
    cube([1, tensioner_spring_width + 6 * tensioner_thickness, tensioner_wire_length - 0.5 * tensioner_spring_width], center = true);
  }
}

module tensioner()
{
  translate([0, $preview ? 0 : -40, 0])
  tensioner_arm();
  tensioner_bracket();
}

module carriage_bar(interface_expansion = 0)
{
  difference()
  {
    union()
    {
      cube([carriage_length, carriage_bar_thickness, carriage_bar_height], center = true);
      
      intersection()
      {
        cube([100, 100, carriage_bar_height + interface_expansion], center = true);
        
        union()
        {
          carriage_bar_plate_interface(interface_expansion);
          scale([-1, 1, 1])
          carriage_bar_plate_interface(interface_expansion);
        }
      }
    }
    
    // Screw holes for the axles
    translate([-axle_spacing * 0.5, 0, 0])
    rotate([90, 0, 0])
    cylinder(100, wheel_axle_radius * 1.2, wheel_axle_radius * 1.2, $fn = 30, center = true);
    translate([+axle_spacing * 0.5, 0, 0])
    rotate([90, 0, 0])
    cylinder(100, wheel_axle_radius * 1.2, wheel_axle_radius * 1.2, $fn = 30, center = true);
  }
}

module carriage_bars(interface_expansion = 0)
{
  // Carriage bars (left/right), to which the lower wheels attach

  // Left carriage bar
  translate([carriage_length / 2 - wheel_base, carriage_bar_thickness / 2 + wheel_left_offset - wheel_total_height - carriage_bar_thickness, carriage_bar_height / 2 + axle_height - carriage_bar_height * 0.5])
  carriage_bar(interface_expansion);
  
  // Right carriage bar
  union()
  {
    translate([carriage_length / 2 - wheel_base, carriage_bar_thickness / 2 + wheel_right_offset + wheel_total_height, carriage_bar_height / 2 + axle_height - carriage_bar_height * 0.5])
    rotate([0, 0, 180])
    carriage_bar(interface_expansion);
    
    tensioner();
  }
}

module carriage_plate()
{
  // Carriage plate
  difference()
  {
    translate([axle_hardware_allowance, wheel_right_offset + wheel_total_height + carriage_bar_thickness, axle_height - carriage_plate_thickness * 0.5])
    cube([axle_spacing - 2 * axle_hardware_allowance, carriage_plate_width - 2 * carriage_bar_thickness, carriage_plate_thickness]);
    
    carriage_bars(interface_expansion = 0.1);
  }
}

module carriage()
{
  carriage_bars();
  
  translate([0, $preview ? 0 : carriage_plate_width * 1.5, 0])
  carriage_plate();
}

if ($preview)
{
  track();
  wheels();
}

carriage();