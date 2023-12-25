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
tensioner_head_thickness = 6 * tensioner_thickness;

tensioner_axle_z = 0.5 * (tensioner_height + tensioner_thickness * 2) + wheel_diameter * 0.5 + track_height * 0.5 - track_slot_height - tensioner_thickness + tensioner_thickness;
tensioner_axle_minimum_y = 0.5 * tensioner_height + top_channel_inset - 4 * tensioner_thickness;

mount_clip_width = 2;
mount_top_height = 5;
mount_detent_size = 2;

washer_thickness = 0.75;
washer_outer_diameter = 10;
washer_inner_diameter = 4;

belt_width = 6;
belt_height = track_height + 2 * mount_top_height + 1 + washer_thickness;
belt_position_y = 5;
belt_thickness = 1;

toothless_pulley_radius = 6;
toothless_pulley_guard_radius = 9;
toothless_pulley_belt_engagement_width = belt_width + 0.25;

motor_mount_plate_width = 60;
belt_switch_plate_width = 120;
belt_pulley_plate_width = 20;

module track()
{
  color("#dddddd")
  translate([-170, 0, 0])
  difference()
  {
    cube([500, track_width, track_height]);
    
    translate([-1, top_channel_inset, track_height - track_slot_height])
    cube([502, top_channel_width, track_slot_height + 1]);
    
    translate([-1, top_channel_inset - track_slot_lip, track_height - 1])
    cube([502, top_channel_width, track_slot_height]);
    
    for (t = [0 : 4])
    {
      translate([-1, track_spacing * t + first_track_offset, -1])
      cube([502, track_slot_width, 8]);
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
    cylinder(tensioner_spring_width + tensioner_head_thickness, tensioner_spring_radius, tensioner_spring_radius, center = true, $fn = 40);

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
    cube([1, tensioner_spring_width + tensioner_head_thickness, tensioner_wire_length - 0.5 * tensioner_spring_width], center = true);
    
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
            tensioner_axle_minimum_y + 0.5 * tensioner_head_thickness,
            tensioner_axle_z
          ])
        rotate([90, 0, 0])
        cylinder(tensioner_head_thickness, 3 * tensioner_thickness, 3 * tensioner_thickness, center = true, $fn = 60);
        
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
        wheel_thickness * 0.5 + top_channel_inset + top_channel_width * 0.5 - tensioner_thickness * 0.5 - wheel_total_height + tensioner_thickness + 2 * tensioner_arm_movement_space - 0.5 * tensioner_spring_width + 0.5 * tensioner_head_thickness,
        0.5 * (tensioner_height + tensioner_thickness * 2) + wheel_diameter * 0.5 + track_height * 0.5 - track_slot_height - tensioner_thickness + tensioner_thickness
      ])
    rotate([90, 0, 0])
    cylinder(tensioner_spring_width + tensioner_head_thickness, tensioner_spring_radius, tensioner_spring_radius, center = true, $fn = 40);

    translate(
      [
        axle_spacing / 2 + 2 * tensioner_thickness - wheel_bearing_radius * 2 - 3 * tensioner_thickness + tensioner_arm_length + wheel_bearing_radius,
        wheel_thickness * 0.5 + top_channel_inset + top_channel_width * 0.5 - tensioner_thickness * 0.5 - wheel_total_height + tensioner_thickness + 2 * tensioner_arm_movement_space - 0.5 * tensioner_spring_width + tensioner_head_thickness,
        0.5 * (tensioner_height + tensioner_thickness * 2) + wheel_diameter * 0.5 + track_height * 0.5 - track_slot_height - tensioner_thickness + tensioner_thickness
      ])
    rotate([0, tensioner_resting_angle, 0])
    translate(
      [
        -tensioner_spring_radius + 0.5,
        -3 * tensioner_thickness,
        -0.5 * (tensioner_wire_length - 0.5 * tensioner_spring_width)
      ])
    cube([1, tensioner_spring_width + tensioner_head_thickness, tensioner_wire_length - 0.5 * tensioner_spring_width], center = true);
  }
}

module tensioner()
{
  translate([0, $preview ? 0 : -40, 0])
  color("red")
  tensioner_arm();
  color("green")
  tensioner_bracket();
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
  color("blue")
  translate([carriage_length / 2 - wheel_base, carriage_bar_thickness / 2 + wheel_left_offset - wheel_total_height - carriage_bar_thickness, carriage_bar_height / 2 + axle_height - carriage_bar_height * 0.5])
  carriage_bar(interface_expansion);
  
  // Right carriage bar
  union()
  {
    color("green")
    translate([carriage_length / 2 - wheel_base, carriage_bar_thickness / 2 + wheel_right_offset + wheel_total_height, carriage_bar_height / 2 + axle_height - carriage_bar_height * 0.5])
    rotate([0, 0, 180])
    carriage_bar(interface_expansion);

    tensioner();
  }
}

module panel_attachment_point()
{
  // This is designed to take a nail with a flat head. The other end of the nail is bent into a loop that attaches to the panel.
  // This may need to be adjusted following a closer inspection of the attachment points for the control rods.
  translate([-0.5, 0, axle_height])
  {
    cube([1, 10, 100]);
    translate([-2.5, 0, -5])
    cube([6, 1, 100]);
  }
}

module carriage_plate()
{
  // Carriage plate
  difference()
  {
    union()
    {
      translate([axle_hardware_allowance - wheel_diameter - 1, wheel_right_offset + wheel_total_height + carriage_bar_thickness, axle_height - carriage_plate_thickness * 0.5])
      cube([axle_spacing - 2 * axle_hardware_allowance + 2 * wheel_diameter + 2, carriage_plate_width - 2 * carriage_bar_thickness, carriage_plate_thickness]);
      
      // Bumpers
      translate([-wheel_diameter, 0, axle_height - carriage_plate_thickness * 0.5])
      cube([10, track_width, carriage_plate_thickness]);

      translate([axle_spacing - 2 * axle_hardware_allowance + wheel_diameter + 4, 0, axle_height - carriage_plate_thickness * 0.5])
      cube([10, track_width, carriage_plate_thickness]);
    }
    
    carriage_bars(interface_expansion = 0.1);

    // Left panel attachment
    translate([5 - wheel_diameter, first_track_offset + 4 * track_spacing + 0.5 * track_slot_width, 0])
    rotate([0, 0, 90])
    panel_attachment_point();
    
    // Right panel attachment
    translate([-5 + wheel_diameter + axle_spacing, first_track_offset + 2 * track_spacing + 0.5 * track_slot_width, 0])
    rotate([0, 0, -90])
    panel_attachment_point();
  }
}

module carriage()
{
  carriage_bars();
  
  color("teal")
  translate([0, $preview ? 0 : carriage_plate_width * 1.5, 0])
  carriage_plate();
}

module mount_clip(mount_width)
{
  difference()
  {
    translate([0, -mount_clip_width, -mount_clip_width])
    difference()
    {
      // Basic clip shape
      cube([mount_width, track_width + 2 * mount_clip_width, track_height + mount_top_height + mount_clip_width]);
      translate([-1, mount_clip_width, mount_clip_width])
      cube([mount_width + 2, track_width, track_height]);
      translate([-1, 2 * mount_clip_width, -1])
      cube([mount_width + 2, track_width - 2 * mount_clip_width, track_height + 1]);
    }

    // Mounting detents
    translate([0, -mount_clip_width * 1.5, track_height - 1])
    multmatrix(
      [[1, 0, -1, 0],
       [0, 1, 0, 0],
       [0, 0, 1, 0],
       [0, 0, 0, 1]])
      cube([mount_detent_size, track_width + 3 * mount_clip_width, mount_detent_size]);

    translate([mount_width - mount_detent_size, -mount_clip_width * 1.5, track_height - 1])
    multmatrix(
      [[1, 0, 1, 0],
       [0, 1, 0, 0],
       [0, 0, 1, 0],
       [0, 0, 0, 1]])
      cube([mount_detent_size, track_width + 3 * mount_clip_width, mount_detent_size]);
  }
}

module mount_clip_on(mount_width, height = mount_top_height)
{
  difference()
  {
    translate([-1.5, 0, track_height])
    cube([mount_width + 3, track_width, mount_top_height + height]);
    
    translate([0, 0, -0.1])
    mount_clip(mount_width);
    
    translate([0, 4, track_height + 1])
    cube([mount_width, track_width - 8, mount_top_height]);
  }
}

module toothless_pulley()
{
  color("#e0e0e0")
  translate([0, 0, 3.125])
  difference()
  {
    union()
    {
      difference()
      {
        cylinder(belt_width + 2, r = toothless_pulley_guard_radius, center = true, $fn = 32);
        cylinder(toothless_pulley_belt_engagement_width, d = 20, center = true);
      }
      
      cylinder(belt_width + 2, r = toothless_pulley_radius, center = true, $fn = 32);
    }
    
    cylinder(belt_width + 4, d = 5, center = true, $fn = 32);
  }
}

module toothy_pulley()
{
  translate([0, 0, 3])
  {
    color("#e0e0e0")
    difference()
    {
      union()
      {
        difference()
        {
          // Outer frame
          translate([0, 0, -3])
          cylinder(14, d = 13, center = true, $fn = 32);
          
          // Cutaway section for gears
          cylinder(6, d = 20, center = true);
        }
        
        difference()
        {
          // Point of contact with belt
          cylinder(8, d = 10, center = true, $fn = 32);
          
          // Teeth
          for (i = [0 : 15])
          {
            rotate([0, 0, i * 360 / 16])
            translate([0, 5, 0])
            scale([0.6, 0.75, 1])
            rotate([0, 0, 45])
            cube([2, 2, 20], center = true);
          }
        }
      }
      
      // Channel for motor shaft
      cylinder(25, d = 5, center = true, $fn = 32);
      
      // Holes for grub screws for attachment to motor shaft
      translate([0, 0, -3 - 3.5])
      rotate([90, 0, 0])
      cylinder(10, d = 3, $fn = 20);

      translate([0, 0, -3 - 3.5])
      rotate([0, 90, 0])
      cylinder(10, d = 3, $fn = 20);
    }

    // Grub screws for attachment to motor shaft
    color("#404040")
    {
      translate([0, -3.25, -3 - 3.5])
      rotate([90, 0, 0])
      difference()
      {
        cylinder(3, d = 2.8, $fn = 20);
        translate([0, 0, 2])
        cylinder(2, d = 1.5, $fn = 6);
      }

      translate([3.25, 0, -3 - 3.5])
      rotate([0, 90, 0])
      difference()
      {
        cylinder(3, d = 2.8, $fn = 20);
        translate([0, 0, 2])
        cylinder(2, d = 1.5, $fn = 6);
      }
    }
  }
}

module motor_mount()
{
  mount_clip(mount_width = 60);

  translate([0, 0, $preview ? 0 : 50])
  {
    mount_clip_on(mount_width = 60);
    // TODO
  }
}

function point_distance(p1, p2)
  // p1: [x, y]
  // p2: [x, y]
  // return: d
= sqrt(pow(p1[0] - p2[0], 2) + pow(p1[1] - p2[1], 2));

function rotate_point(p, a)
  // p: [x, y]
  // a: angle
  // return [x2, y2]
= [p[0] * cos(a) + p[1] * sin(a), p[0] * sin(a) - p[1] * cos(a)];

function add_vectors(p1, p2)
= [p1[0] + p2[0], p1[1] + p2[1]];

function make_line_array(p1, p2)
= [p1[0], p1[1], p2[0], p2[1]];

function circle_tangent_line_from_point(circle, point)
  // circle: [x, y, r]
  // point: [x1, y1]
  // return: [x1, y1, x2, y2]
= make_line_array(point, add_vectors(circle, rotate_point(
    [pow(circle[2], 2) / point_distance(circle, point), circle[2] * sqrt(pow(point_distance(circle, point), 2) - circle[2] * circle[2]) / point_distance(circle, point)],
    atan2(point[1] - circle[1], point[0] - circle[0]))));

module belt_from_to_crossing(pulley_1, pulley_2, this_belt_thickness = belt_thickness, this_belt_width = belt_width)
{
  guide_circle_radius = pulley_1[2] + pulley_2[2];
  
  guide = circle_tangent_line_from_point(
    [pulley_1[0], pulley_1[1], guide_circle_radius],
    pulley_2);

  angle = atan2(
    guide[0] - guide[2],
    guide[3] - guide[1]);
  
  guide_offset =
    [
      pulley_2[2] * cos(angle),
      pulley_2[2] * sin(angle)
    ];
  
  belt =
    [
      guide[0] + guide_offset[0],
      guide[1] + guide_offset[1],
      guide[2] + guide_offset[0],
      guide[3] + guide_offset[1]
    ];

  belt_segment_length =
    sqrt(
      pow(belt[2] - belt[0], 2) +
      pow(belt[3] - belt[1], 2));
      
  belt_angle = atan2(
    belt[0] - belt[2],
    belt[3] - belt[1]);
    
  belt_midpoint =
    [
      (belt[0] + belt[2]) * 0.5,
      (belt[1] + belt[3]) * 0.5
    ];
      
  translate([belt_midpoint[0], belt_midpoint[1], 0])
  rotate([0, 0, belt_angle])
  cube([this_belt_thickness, belt_segment_length, this_belt_width], center = true);
}

module belt_rotating_pulley(x, y, a)
{
  translate(
    [
      x,
      y,
      belt_height + toothless_pulley_radius
    ])
  rotate([-45, 0, a])
  toothless_pulley();
}

module belt_rotating_pulley_mount(expand_pin)
{
  union()
  {
    intersection()
    {
      rotate([-45, 0, 0])
      translate([0, 0, -toothless_pulley_guard_radius * 1.25 - 1 - washer_thickness])
      difference()
      {
        cube(toothless_pulley_guard_radius * 2.5, center = true);
        cylinder(toothless_pulley_guard_radius * 3, d = 4, center = true, $fn = 30);
      }
    
      translate([0, 65, 67.5])
      cube(150, center = true);
    }
    
    rotate([-45, 0, 0])
    {
      translate([toothless_pulley_guard_radius * 0.7, 0, -toothless_pulley_guard_radius * 1.6])
      cylinder(1.4 * toothless_pulley_guard_radius, d = expand_pin ? 4.2 : 4, $fn = 30, center = true);
      translate([-toothless_pulley_guard_radius * 0.7, 0, -toothless_pulley_guard_radius * 1.6])
      cylinder(1.4 * toothless_pulley_guard_radius, d = expand_pin ? 4.2 : 4, $fn = 30, center = true);
    }
  }
}

module overhead_pulley_mount(centre_pulley_angle, expand_pin)
{
  translate([belt_switch_plate_width * 0.5, tensioner_axle_minimum_y + tensioner_head_thickness + 2.5 * toothless_pulley_radius + belt_thickness + 3, 53])
  union()
  {
    rotate([0, 0, centre_pulley_angle])
    difference()
    {
      cube([3 * toothless_pulley_guard_radius, 2 * (toothless_pulley_belt_engagement_width + 2), 3 * toothless_pulley_guard_radius], center = true);
      translate([0, 0, -5])
      cube([4 * toothless_pulley_guard_radius, 2 * washer_thickness + (toothless_pulley_belt_engagement_width + 2), 3 * toothless_pulley_guard_radius], center = true);
      
      translate([0, 0, -toothless_pulley_guard_radius * 0.5 + 1.5])
      rotate([90, 0, 0])
      cylinder(3 * toothless_pulley_belt_engagement_width, d = 4, center = true, $fn = 30);
    }
    
    wall_thickness = 0.5 * (
      (2 * (toothless_pulley_belt_engagement_width + 2))
      -
      (2 * washer_thickness + (toothless_pulley_belt_engagement_width + 2)));
    
    echo(centre_pulley_angle);
    echo(cos(centre_pulley_angle));
    echo(sin(centre_pulley_angle));

    union()
    {
      difference()
      {
        union()
        {
          // Diamond that provides the NW/SE supports.
          translate([0, 0, -27])
          rotate([0, 45, 0])
          cube([40, wall_thickness / cos(centre_pulley_angle), 40], center = true);
          
          // Diamonds that provide the E/W supports.
          translate([0, 0, -27])
          rotate([45, 0, 0])
          cube([wall_thickness / cos(centre_pulley_angle), 40, 40], center = true);
        }

        // Channel for the overhead belt to pass through.
        rotate([0, 0, centre_pulley_angle])
        translate([0, 0, -5])
        cube([4 * toothless_pulley_guard_radius, 2 * washer_thickness + (toothless_pulley_belt_engagement_width + 2), 6 * toothless_pulley_guard_radius], center = true);
        
        // Channel for the belt that passes under the mount.
        translate([-belt_switch_plate_width * 0.5, -(tensioner_axle_minimum_y + tensioner_head_thickness + 2.5 * toothless_pulley_radius + belt_thickness + 3), -23])
        belt_from_to_crossing(
          [
            10,
            tensioner_axle_minimum_y + tensioner_head_thickness + toothless_pulley_radius + belt_thickness,
            toothless_pulley_radius
          ],
          [
            belt_switch_plate_width - 10,
            tensioner_axle_minimum_y + tensioner_head_thickness + 5 * toothless_pulley_radius + belt_thickness,
            toothless_pulley_radius
          ],
          5,
          10);

        // Lie flat against the mount clip.
        translate([0, 0, -50 - 27])
        cube([100, 100, 100], center = true);
      }
      
      // Pins from the overhead mount into the mount clip.
      translate([0, 0, -36])
      {
        translate([0, -15, 0])
        cylinder(10, d = expand_pin ? 3.2 : 3, $fn = 30);
        translate([0, +15, 0])
        cylinder(10, d = expand_pin ? 3.2 : 3, $fn = 30);
        translate([-18, 0, 0])
        cylinder(10, d = expand_pin ? 3.2 : 3, $fn = 30);
        translate([+18, 0, 0])
        cylinder(10, d = expand_pin ? 3.2 : 3, $fn = 30);
      }
    }
  }
}

module belt_switch()
{
  mount_clip(mount_width = belt_switch_plate_width);

  translate([0, 0, $preview ? 0 : 50])
  {
    centre_pulley_angle = -atan2(5 * toothless_pulley_radius + belt_width * 3, belt_switch_plate_width - 20);
    
    if ($preview)
    {
      // Straight through pulleys
      translate([10, tensioner_axle_minimum_y + tensioner_head_thickness + toothless_pulley_radius + belt_thickness, belt_height])
      toothless_pulley();

      translate([belt_switch_plate_width - 10, tensioner_axle_minimum_y + tensioner_head_thickness + 5 * toothless_pulley_radius + belt_thickness, belt_height])
      toothless_pulley();

      // Belt between straight through pulleys
      color("brown")
      translate([0, 0, belt_height + 3])
      belt_from_to_crossing(
        [
          10,
          tensioner_axle_minimum_y + tensioner_head_thickness + toothless_pulley_radius + belt_thickness,
          toothless_pulley_radius
        ],
        [
          belt_switch_plate_width - 10,
          tensioner_axle_minimum_y + tensioner_head_thickness + 5 * toothless_pulley_radius + belt_thickness,
          toothless_pulley_radius
        ]);

      // Pulley washers
      translate([10, tensioner_axle_minimum_y + tensioner_head_thickness + toothless_pulley_radius + belt_thickness, belt_height - washer_thickness])
      washer();

      translate([belt_switch_plate_width - 10, tensioner_axle_minimum_y + tensioner_head_thickness + 5 * toothless_pulley_radius + belt_thickness, belt_height - washer_thickness])
      washer();
      
      // Over top pulleys
      belt_rotating_pulley(
        10,
        tensioner_axle_minimum_y + belt_width * sqrt(2) / 4 + tensioner_head_thickness + 5 * toothless_pulley_radius + belt_thickness,
        0);
      belt_rotating_pulley(
        belt_switch_plate_width - 10,
        tensioner_axle_minimum_y + tensioner_head_thickness + toothless_pulley_radius + belt_thickness,
        180);

      translate([belt_switch_plate_width * 0.5, tensioner_axle_minimum_y + tensioner_head_thickness + 2.5 * toothless_pulley_radius + belt_thickness + 3, 50])
      rotate([90, 0, centre_pulley_angle])
      translate([0, 0, -0.5 * toothless_pulley_belt_engagement_width])
      toothless_pulley();
    }
    
    difference()
    {
      // Mount points for the two 45 degree pulleys.
      p1x = 10;
      p1y = tensioner_axle_minimum_y + belt_width * sqrt(2) / 4 + tensioner_head_thickness + 5 * toothless_pulley_radius + belt_thickness;
      p2x = belt_switch_plate_width - 10;
      p2y = tensioner_axle_minimum_y + belt_width * sqrt(2) / 4 + tensioner_head_thickness + toothless_pulley_radius - belt_thickness;
      mx = (p1x + p2x) * 0.5;
      my = (p1y + p2y) * 0.5;
      dx = (p2x - p1x) * 0.5;
      dy = (p2y - p1y) * 0.5;

      // Top plate
      union()
      {
        difference()
        {
          mount_clip_on(mount_width = belt_switch_plate_width);
          
          // 45 degree pulley mount attachments
          translate([mx, my, 0])
          for (a = [0, 180])
          {
            rotate([0, 0, a])
            translate(
              [
                -dx,
                -dy,
                belt_height + toothless_pulley_radius
              ])
            belt_rotating_pulley_mount(true);
          }
          
          // Attachment for the mount point for the overhead pulley.
          overhead_pulley_mount(centre_pulley_angle, true);
        }

        // 45 degree pulley mounts
        translate([mx, my, $preview ? 0 : 20])
        for (a = [0, 180])
        {
          rotate([0, 0, a])
          translate(
            [
              -dx,
              -dy,
              belt_height + toothless_pulley_radius
            ])
          belt_rotating_pulley_mount(false);
        }

        // Mount point for the overhead pulley.
        translate([0, 0, $preview ? 0 : 20])
        overhead_pulley_mount(centre_pulley_angle, false);
      }
      
      translate([10, tensioner_axle_minimum_y + tensioner_head_thickness + toothless_pulley_radius + belt_thickness, belt_height])
      cylinder(mount_top_height * 2, d = 4, center = true, $fn = 30);
      translate([belt_switch_plate_width - 10, tensioner_axle_minimum_y + tensioner_head_thickness + 5 * toothless_pulley_radius + belt_thickness, belt_height])
      cylinder(mount_top_height * 2, d = 4, center = true, $fn = 30);
    }
  }
}

module washer()
{
  color("#e0e0e0")
  difference()
  {
    cylinder(washer_thickness, d = washer_outer_diameter);
    cylinder(3 * washer_thickness, d = washer_inner_diameter, center = true, $fn = 30);
  }
}

module belt_pulleys()
{
  mount_clip(mount_width = belt_pulley_plate_width);

  translate([0, 0, $preview ? 0 : 50])
  {
    if ($preview)
    {
      translate([0.5 * belt_pulley_plate_width, tensioner_axle_minimum_y + tensioner_head_thickness + toothless_pulley_radius + belt_thickness, belt_height])
      toothless_pulley();

      translate([0.5 * belt_pulley_plate_width, tensioner_axle_minimum_y + tensioner_head_thickness + 5 * toothless_pulley_radius + belt_thickness, belt_height])
      toothless_pulley();

      // Pulley washers
      translate([0.5 * belt_pulley_plate_width, tensioner_axle_minimum_y + tensioner_head_thickness + toothless_pulley_radius + belt_thickness, belt_height - washer_thickness])
      washer();

      translate([0.5 * belt_pulley_plate_width, tensioner_axle_minimum_y + tensioner_head_thickness + 5 * toothless_pulley_radius + belt_thickness, belt_height - washer_thickness])
      washer();
    }
    
    difference()
    {
      mount_clip_on(mount_width = belt_pulley_plate_width);
      translate([0.5 * belt_pulley_plate_width, tensioner_axle_minimum_y + tensioner_head_thickness + toothless_pulley_radius + belt_thickness, belt_height])
      cylinder(mount_top_height * 2, d = 4, center = true, $fn = 30);
      translate([0.5 * belt_pulley_plate_width, tensioner_axle_minimum_y + tensioner_head_thickness + 5 * toothless_pulley_radius + belt_thickness, belt_height])
      cylinder(mount_top_height * 2, d = 4, center = true, $fn = 30);
    }
  }
}

module stepper_motor(expand)
{
  color("#444")
  intersection()
  {
    cube([
      42.3 + (expand ? 0.2 : 0),
      42.3 + (expand ? 0.2 : 0),
      20.4], center = true);
    
    rotate([0, 0, 45])
    cube([
      53 + (expand ? 0.2 * sqrt(2) : 0),
      53 + (expand ? 0.2 * sqrt(2) : 0),
      21], center = true);
  }

  intersection()
  {
    color("#eee")
    translate([0, 0, 10.25])
    cube([42.3, 42.3, 0.1], center = true);
    
    color("#444")
    rotate([0, 0, 45])
    cube([53, 52, 21], center = true);
  }

  color("#444")
  translate([0, 0, 2.1])
  cylinder(20.5, d = 21, center = true, $fn = 60);
  
  color("#eee")
  {
    translate([0, 0, 2 + (expand ? 1 : 0)])
    cylinder(20.5, d = 22 + (expand ? 2 : 0), center = true, $fn = 60);
    
    translate([0, 0, 18])
    difference()
    {
      cylinder(20.5, d = 4.5 + (expand ? 2 : 0), center = true, $fn = 30);
      
      if (!expand)
      {
        translate([0, 7, 0])
        cube([10, 10, 21], center = true);
      }
    }
  }
}

perimeter_module_overhang_height = 10;
perimeter_module_plate_height = 15;
perimeter_module_mount_width = 50;
perimeter_module_overhang_amount = 13;

module belt_perimeter_module(second_axle_offset = 0)
{
  translate([0, 0, $preview ? 0 : -40])
  mount_clip(mount_width = perimeter_module_mount_width);
  
  mount_clip_on(mount_width = perimeter_module_mount_width, height = perimeter_module_plate_height);

  difference()
  {
    for (side = [0 : 1])
    {
      translate([0, side * track_width, 0])
      scale([1, 1 - side * 2, 1])
      {
        difference()
        {
          union()
          {
            translate([0.5 * perimeter_module_mount_width + second_axle_offset * 0.5, -0.5 * perimeter_module_overhang_amount + 1, track_height + mount_top_height + perimeter_module_plate_height - perimeter_module_overhang_height * 0.5])
            cube([perimeter_module_mount_width + second_axle_offset, perimeter_module_overhang_amount + 1, perimeter_module_overhang_height], center = true);

            translate([0.5 * perimeter_module_mount_width + second_axle_offset * 0.5, 5 - perimeter_module_overhang_amount, 0.5 * (track_height + mount_top_height + perimeter_module_plate_height) - 1])
            cube([perimeter_module_mount_width + second_axle_offset, 10, track_height + mount_top_height + perimeter_module_plate_height + 2], center = true);

            translate([0.5 * perimeter_module_mount_width + second_axle_offset * 0.5, -0.5 * perimeter_module_overhang_amount + 1, 0.5 * (track_height + mount_top_height + perimeter_module_plate_height) - 1])
            cube([perimeter_module_mount_width + second_axle_offset, perimeter_module_overhang_amount + 1, track_height + mount_top_height + perimeter_module_plate_height + 2], center = true);
          }
          
          translate([10, -5, 0.5 * (track_height + mount_top_height + perimeter_module_plate_height)])
          cylinder(track_height + mount_top_height + perimeter_module_plate_height + 10, d = 4, center = true, $fn = 30);

          translate([40 + second_axle_offset, -5, 0.5 * (track_height + mount_top_height + perimeter_module_plate_height)])
          cylinder(track_height + mount_top_height + perimeter_module_plate_height + 10, d = 4, center = true, $fn = 30);
        }
      }
      
      if ($preview)
      {
        for (side = [0 : 1])
        {
          translate([0, side * (track_width + 10), 0])
          {
            translate([10, -5, -10])
            toothless_pulley();
            translate([40 + second_axle_offset, -5, -10])
            toothless_pulley();
          }
        }
      }
    }
    
    translate([perimeter_module_mount_width + 3, track_width * 0.5, 0])
    cube([3, track_width + 3, 200], center = true);
  }
}

module belt_end_module()
{
  union()
  {
    translate([0.5 * perimeter_module_mount_width + 1, 0.5 * track_width, 0])
    rotate([0, 0, 180])
    translate([-0.5 * perimeter_module_mount_width - 1, -0.5 * track_width, 0])
    belt_perimeter_module(second_axle_offset = 20);
  }
}

motor_mount_extension_length = 60;

module belt_motor_module()
{
  union()
  {
    belt_perimeter_module();
    
    for (side = [0 : 1])
    {
      translate([0, side * track_width, 0])
      scale([1, 1 - side * 2, 1])
      {
        translate([
          perimeter_module_mount_width + 0.5 * motor_mount_extension_length - 1,
          5 - perimeter_module_overhang_amount,
          0.5 * (track_height + mount_top_height + perimeter_module_plate_height) - 1])
        cube([motor_mount_extension_length + 1, 10, track_height + mount_top_height + perimeter_module_plate_height + 2], center = true);

        translate([0, 0, 10])
        multmatrix(
          [[1, 0, 0, 0],
           [0, 1, 0, 0],
           [0, -1, 1, 0],
           [0, 0, 0, 1]])
        difference()
        {
          translate([
            perimeter_module_mount_width + 0.5 * motor_mount_extension_length + 1.5,
            10 - perimeter_module_overhang_amount,
            0])
          cube([motor_mount_extension_length - 4, 20, 10], center = true);

          translate([
            perimeter_module_mount_width + 0.5 * motor_mount_extension_length + 1.5,
            10.1 - perimeter_module_overhang_amount,
            5])
          cube([(motor_mount_extension_length - 4) / 3 + 0.2, 20, 10], center = true);
        }
      }
    }
    
    translate([0, 0, $preview ? 0 : -50])
    union()
    {
      translate([
        perimeter_module_mount_width + 0.5 * motor_mount_extension_length + 1.5,
        track_width * 0.5,
        10 - 7])
      difference()
      {
        cube([motor_mount_extension_length - 4, track_width + 6 - 20.1, 10], center = true);

        translate([0, 0, 11])
        rotate([180, 0, 0])
        stepper_motor(true);
      }

      translate([0, 0, 10])
      for (side = [0 : 1])
      {
        translate([0, side * track_width, 0])
        scale([1, 1 - side * 2, 1])
        multmatrix(
          [[1, 0, 0, 0],
           [0, 1, 0, 0],
           [0, -1, 1, 0],
           [0, 0, 0, 1]])
        translate([
          perimeter_module_mount_width + 0.5 * motor_mount_extension_length + 1.5,
          10.1 - perimeter_module_overhang_amount,
          0])
        cube([(motor_mount_extension_length - 4) / 3, 20, 10], center = true);
      }
    }
    
    if ($preview)
    {
      translate([perimeter_module_mount_width + 0.5 * motor_mount_extension_length + 1.5, track_width * 0.5, 11])
      rotate([180, 0, 0])
      stepper_motor();
      
      translate([0, track_width * 0.5, -10])
      toothy_pulley();
    }
  }
}

if ($preview)
{
  track();
  //wheels();
}

/*
carriage();

translate([75 + axle_spacing, 0, 0])
motor_mount();

translate([-150, 0, 0])
belt_pulleys();

translate([-110, 0, 0])
belt_switch();
*/
translate([-169, 0, 0])
belt_end_module();

translate([279, 0, 0])
belt_motor_module();
