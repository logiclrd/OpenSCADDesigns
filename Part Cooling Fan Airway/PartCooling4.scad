include_mockups = $preview;
part_cutaway = true;//$preview;
see_into_manifold = false;//$preview;

$fn = $preview ? 24 : 80;

wall_thickness = 2;
inlet_width = 30;
inlet_depth = 28.5;
inlet_offset_x = 5;
fan_width = 55;
fan_height = 58;
fan_depth = 28;

fan_intake_radius = 18;
fan_intake_offset_x = 1.5;
fan_intake_offset_y = 2.0;

fan_screw_positions =
  [
    [23 - fan_intake_offset_x, -22 - fan_intake_offset_y, 45],
    [-20 - fan_intake_offset_x, 22 - fan_intake_offset_y, 225]
  ];
fan_screw_hole_diameter = 4.5;

fan_tab_length = 9;
fan_tab_width = 3;
fan_tab_height = 1.5;
fan_tab_distance_from_back_face = 12;
fan_outlet_distance_from_center = 31;
fan_outlet_tab_distance_from_top = 4;

inlet_tolerance = 0.15;

mount_plate_top_z = 23;
mount_plate_width = 75;
mount_plate_height = 64;
mount_plate_depth = 3;
mount_plate_corner_round = 2.5;

mounting_bracket_width = 43;
mounting_bracket_depth = 38;
mounting_bracket_height = 11;
mounting_bracket_filament_path_x = 20;
mounting_bracket_filament_path_y = 19;

mounting_bracket_fan_attachment_height = 39;
mounting_bracket_fan_attachment_narrow_width = 19.7;
mounting_bracket_fan_attachment_depth = 3;
mounting_bracket_fan_attachment_wide_width = 26.6;
mounting_bracket_fan_attachment_wide_height = 19;
mounting_bracket_fan_attachment_hole_diameter = 3.39; // measured, adjust tolerance
mounting_bracket_fan_attachment_hole_tolerance = 0.08;

mounting_bracket_fan_attachment_holes =
  [
    [4.637, mounting_bracket_fan_attachment_height - 1.888 - 1.695],
    [mounting_bracket_fan_attachment_narrow_width - 3.37 - 1.695, 15.812]
  ];

x_axis_beam_near_y = -mounting_bracket_filament_path_y + mounting_bracket_depth + mount_plate_depth + 4;

belt_thickness = 6;

belt_y = 0.5 * mount_plate_depth - mounting_bracket_filament_path_y + mounting_bracket_depth;
right_belt_z = mount_plate_top_z + 3 - 12;
left_belt_z = mount_plate_top_z + 3 - 4;

heat_sink_height = 26;
heat_sink_radius = 0.5 * 22.3;
heat_sink_bracket_radius = 0.5 * 16;
heat_sink_bracket_height = 42.7 - 26;

heater_block_width = 16;
heater_block_depth = 23;
heater_block_height = 11.5;
heater_block_base_z = -58;
heater_cartridge_protrusion = 3.6;
heater_cartridge_wire_diameter = 1.8;
sock_wall_thickness = 1.4;

nozzle_hex_height = 3;
nozzle_tip_height = 2;

nozzle_height = nozzle_hex_height + nozzle_tip_height;

connection_taper_height = 7;
connection_taper_offset = -3;
connection_top_z = right_belt_z + connection_taper_height;

inlet_height = 0.5 * fan_height;

manifold_radius = heater_block_depth + 2;
manifold_radius_top_difference = 3;
manifold_inner_space_radius = manifold_radius - 5;
manifold_rounding_radius = 5;
manifold_height = 15;
manifold_z = -2;
manifold_vent_diameter = 1.8;
manifold_vent_z_offset = 1;
manifold_vent_count = 30;
manifold_ceiling_support_radius = 0.4;
manifold_ceiling_support_spacing = 4.125;
manifold_ceiling_support_rotation = 0;

manifold_vent_radius = 0.5 * manifold_vent_diameter;

manifold_inlet_connection_segments = $fn * 0.75;

mounting_clip_width = 6;
mounting_clip_depth = 3.5;
mounting_clip_tab_depth = 4;
mounting_clip_tab_height = 4;
mounting_clip_lock_height = 4;

module fan_mockup()
{
  translate([-1.5, -2, -0.5 * fan_depth])
  {
    // Case
    difference()
    {
      // Outer wall
      union()
      {
        intersection()
        {
          cylinder(fan_depth, 30, 30);
          cube([35, 35, 35]);
        }

        scale([30/27, 1, 1])
        rotate([0, 0, -90])
        intersection()
        {
          cylinder(fan_depth, 27, 27);
          cube([35, 35, 35]);
        }
        
        rotate([0, 0, -180])
        intersection()
        {
          cylinder(fan_depth, 27, 27);
          cube([35, 35, 35]);
        }
        
        scale([27/25, 1, 1])
        rotate([0, 0, -270])
        intersection()
        {
          cylinder(fan_depth, 25, 25);
          cube([35, 35, 35]);
        }
        
        cube([30, fan_outlet_distance_from_center, fan_depth]);
      }

      // Inner wall
      translate([0, 0, 2])
      union()
      {
        intersection()
        {
          cylinder(fan_depth - 2 * wall_thickness, 28, 28);
          translate([2, 0, 0])
          cube([35, 35, 35]);
        }

        scale([28/25, 1, 1])
        rotate([0, 0, -90])
        intersection()
        {
          cylinder(fan_depth - 2 * wall_thickness, 25, 25);
          cube([35, 35, 35]);
        }
        
        rotate([0, 0, -180])
        intersection()
        {
          cylinder(fan_depth - 2 * wall_thickness, 25, 25);
          cube([35, 35, 35]);
        }
        
        scale([25/23, 1, 1])
        rotate([0, 0, -270])
        intersection()
        {
          cylinder(fan_depth - 2 * wall_thickness, 23, 23);
          translate([0, -2, 0])
          cube([35, 35, 35]);
        }
        
        translate([2, 0, 0])
        cube([26, 37, fan_depth - 2 * wall_thickness]);
        
        cylinder(fan_depth + wall_thickness, fan_intake_radius, fan_intake_radius);
      }
    }
    
    // Impeller
    translate([0, 0, 4])
    union()
    {
      cylinder(1, 21, 21);

      translate([0, 0, fan_depth - 11])
      difference()
      {
        cylinder(2, 21, 21);
        translate([0, 0, -1])
        cylinder(4, 20, 20);
      }
      
      for (blade = [0 : 28])
      {
        angle = blade * 360 / 29;
        
        rotate([0, 0, angle])
        translate([19, 0, (fan_depth - 9)/2])
        rotate([0, 0, 40])
        cube([4, 1, fan_depth - 9], center = true);
      }
      
      cylinder(fan_depth - 15, 15, 15);
      translate([0, 0, fan_depth - 15])
      cylinder(2, 15, 13);
    }
    
    // Screw holes
    for (screw_hole = fan_screw_positions)
    {
      translate([screw_hole[0] + 1.5, screw_hole[1] + 2, 0])
      rotate([0, 0, screw_hole[2]])
      difference()
      {
        union()
        {
          cylinder(fan_depth, 4.25, 4.25);
          translate([-4.25, 0, 0])
          cube([8.5, 5.25, 28]);
        }
        
        translate([0, 0, -1])
        cylinder(fan_depth + 2, 0.5 * fan_screw_hole_diameter, 0.5 * fan_screw_hole_diameter);
      }
    }
    
    // Tab (outlet)
    translate([30, fan_outlet_distance_from_center - fan_tab_length - fan_outlet_tab_distance_from_top, fan_tab_distance_from_back_face])
    cube([fan_tab_height, fan_tab_length, fan_tab_width]);

    // Tab (far end)
    translate([fan_tab_length * 0.5, -28, fan_tab_distance_from_back_face])
    rotate([0, 0, 90])
    cube([fan_tab_height, fan_tab_length, fan_tab_width]);
  }
}

module mounting_bracket()
{
  translate([0.5 * mounting_bracket_width - mounting_bracket_filament_path_x, mounting_bracket_filament_path_y - 0.5 * mounting_bracket_depth, -heater_block_base_z - 0.5 * mounting_bracket_height])
  union()
  {
    translate([-0.5 * mounting_bracket_width + 7, 12 - 0.5 * mounting_bracket_depth])
    rotate([90, 0, 0])
    cylinder(8, 2.5, 2.5);

    translate([0.5 * mounting_bracket_width - 10, 12 - 0.5 * mounting_bracket_depth])
    rotate([90, 0, 0])
    cylinder(8, 2.5, 2.5);
    
    difference()
    {
      union()
      {
        cube([mounting_bracket_width, mounting_bracket_depth, mounting_bracket_height], center = true);
      
        translate([0.5 * mounting_bracket_width - 0.5 * mounting_bracket_fan_attachment_depth, 0.5 * mounting_bracket_depth - 0.5 * 26.6, 0.5 * mounting_bracket_height + 0.5 * mounting_bracket_fan_attachment_wide_height - mounting_bracket_fan_attachment_height])
        cube([mounting_bracket_fan_attachment_depth, mounting_bracket_fan_attachment_wide_width, mounting_bracket_fan_attachment_wide_height], center = true);
    
        translate([0.5 * mounting_bracket_width - 0.5 * mounting_bracket_fan_attachment_depth, 0.5 * mounting_bracket_depth - 0.5 * 19.7, 0.5 * mounting_bracket_height - 0.5 * mounting_bracket_fan_attachment_height])
        cube([mounting_bracket_fan_attachment_depth, mounting_bracket_fan_attachment_narrow_width, mounting_bracket_fan_attachment_height], center = true);
      }
      
      translate([-0.5 * mounting_bracket_width + 7, 7 - 0.5 * mounting_bracket_depth])
      rotate([90, 0, 0])
      cylinder(9, 4, 4);

      translate([0.5 * mounting_bracket_width - 10, 7 - 0.5 * mounting_bracket_depth])
      rotate([90, 0, 0])
      cylinder(9, 4, 4);

      for (hole = mounting_bracket_fan_attachment_holes)
      {
        translate([0.5 * mounting_bracket_width - 2, 0.5 * mounting_bracket_depth - hole[0], 0.5 * mounting_bracket_height - hole[1]])
        rotate([0, 90, 0])
        cylinder(5, 0.5 * mounting_bracket_fan_attachment_hole_diameter, 0.5 * mounting_bracket_fan_attachment_hole_diameter, center = true);
      }
    }
  }
}

module hot_end_mockup()
{
  // Filament path through x = y = 0
  
  // Mounting bracket
  // width: 43
  color([0.1, 0.6, 0.6])
  mounting_bracket();

  // Heat sink
  color([0.9, 0.9, 0.9])
  {
    translate([0, 0, 15])
    cylinder(heat_sink_height, heat_sink_radius, heat_sink_radius);
  
    translate([0, 0, 15 + heat_sink_height])
    cylinder(heat_sink_bracket_height, heat_sink_bracket_radius, heat_sink_bracket_radius);
  }
  
  // Heat sink fan
  translate([0, 5 - 0.5 * heater_block_depth - 8, 44])
  translate([0, 0, -15])
  {
    color([0, 0, 0.4])
    difference()
    {
      translate([0, 4.5, 0])
      cube([31, 30 - 9, 30], center = true);
      
      translate([0, -16, 0])
      rotate([-90, 0, 0])
      cylinder(32, 14, 14);
      
      translate([0, -8, 0])
      rotate([90, 0, 0])
      difference()
      {
        translate([0, 0, 2.5])
        cube([32, 32, 5], center = true);
        
        translate([0, 0, -1])
        cylinder(7, 15, 15);
      }
    }
    
    color([0.3, 0.3, 0.3])
    difference()
    {
      translate([0, -10.5, 0])
      cube([31, 9, 30], center = true);
      
      translate([0, -16, 0])
      rotate([-90, 0, 0])
      cylinder(32, 14, 14);
      
      translate([0, -8, 0])
      rotate([90, 0, 0])
      difference()
      {
        translate([0, 0, 2.5])
        cube([32, 32, 5], center = true);
        
        translate([0, 0, -1])
        cylinder(7, 15, 15);
      }
    }

    color([0.3, 0.3, 0.3])
    intersection()
    {
      union()
      {
        translate([0, -10, 0])
        rotate([90, 0, 0])
        cylinder(10, 9, 9, center = true);
        
        for (blade = [1 : 7])
        {
          blade_angle = blade * 360 / 7;
          
          rotate([0, blade_angle, 0])
          rotate([0, 0, 30])
          translate([-5, -10, 10])
          rotate([0, -25, 0])
          cube([7, 1, 15], center = true);
        }
      }
      
      rotate([90, 0, 0])
      cylinder(20, 13.5, 13.5);
    }
  }
  
  // Heat break
  color([0.9, 0.9, 0.9])
  translate([0, 0, heater_block_height - 1])
  cylinder(4, 1.24, 1.24);

  // Heater block & cartridge
  color([0.7, 0.7, 0.7])
  translate([0, 8 - 0.5 * heater_block_depth, 0.5 * heater_block_height])
  {
    difference()
    {
      cube([heater_block_width, heater_block_depth, heater_block_height], center = true);
      
      translate([0, -0.5 * (heater_block_depth - 8.5), 4 - 0.5 * heater_block_height])
      cube([heater_block_width + 0.1, 9, 1.6], center = true);
    }
    
    translate([0.5 * heater_block_width, -0.5 * heater_block_depth + 8.5, 4 - 0.5 * heater_block_height])
    rotate([0, -90, 0])
    cylinder(heater_block_width + heater_cartridge_protrusion, 3, 3);
    
    translate([0, 0.5 * heater_block_depth - 19.5, -1.75 - 0.5 * heater_block_height])
    cylinder(1.75, 2.5, 2.5);
  }
  
  color([1, 0, 0])
  translate([-0.5 * heater_block_width - heater_cartridge_protrusion - 0.5 * heater_cartridge_wire_diameter, 16.5 - heater_block_depth, 0])
  rotate([0, -10, 0])
  union()
  {
    translate([0.5, 0.5 * heater_cartridge_wire_diameter, 3])
    cylinder(10, heater_cartridge_wire_diameter * 0.5, heater_cartridge_wire_diameter * 0.5);
    
    translate([0.5, -0.5 * heater_cartridge_wire_diameter, 3])
    cylinder(10, heater_cartridge_wire_diameter * 0.5, heater_cartridge_wire_diameter * 0.5);
  }
  
  // Sock
  color([0, 0.7, 0.7])
  translate([0, 8 - 0.5 * heater_block_depth, 0.5 * heater_block_height])
  difference()
  {
    union()
    {
      cube([heater_block_width + 2 * sock_wall_thickness, heater_block_depth + 2 * sock_wall_thickness, heater_block_height + 2 * sock_wall_thickness], center = true);

      translate([0, 0.5 * heater_block_depth - 8, -0.5 * heater_block_height - sock_wall_thickness - 0.8])
      cylinder(1, 5.45, 5.45);
    }
    
    cube([heater_block_width, heater_block_depth, heater_block_height], center = true);
    
    translate([0, 0.5 * heater_block_depth - 8, -0.5 * heater_block_height - sock_wall_thickness - 1])
    cylinder(2, 4, 4);

    translate([0, 0.5 * heater_block_depth - 19.5, -0.5 * heater_block_height - sock_wall_thickness - 1])
    cylinder(2, 2.6, 2.6);

    translate([0.5 * heater_block_width + 1.5 * sock_wall_thickness, -0.5 * heater_block_depth + 8.5, 4 - 0.5 * heater_block_height])
    rotate([0, -90, 0])
    cylinder(heater_block_width + 3 * sock_wall_thickness, 3, 3);
    
    translate([0, -0.5 * heater_block_depth + 8.5, 4 - 0.5 * heater_block_height + 0.5 * heater_block_height + sock_wall_thickness])
    cube([heater_block_width + 3 * sock_wall_thickness, 6, heater_block_height + 2 * sock_wall_thickness], center = true);

    translate([0.5 * heater_block_width + 1.5 * sock_wall_thickness, 0.5 * heater_block_depth - 1.35, 4 - 0.5 * heater_block_height])
    rotate([0, -90, 0])
    cylinder(heater_block_width + 3 * sock_wall_thickness, 1.25, 1.25);
    
    translate([0, 0.5 * heater_block_depth - 1.35, 4 + 1.25])
    cube([heater_block_width + 3 * sock_wall_thickness, 2.5, heater_block_height + 2 * sock_wall_thickness], center = true);
    
    translate([0, 0, 0.5 * heater_block_height])
    cube([heater_block_width - 2, heater_block_depth - 2, heater_block_height], center = true);
    
    translate([-0.5 * heater_block_width - sock_wall_thickness + 1, -0.5 * heater_block_depth, 0.5 * heater_block_height + sock_wall_thickness - 0.01])
    cube([3, 12, 2 * sock_wall_thickness], center = true);
    translate([0.5 * heater_block_width + sock_wall_thickness - 1, -0.5 * heater_block_depth, 0.5 * heater_block_height + sock_wall_thickness - 0.01])
    cube([3, 12, 2 * sock_wall_thickness], center = true);
    translate([0, -0.5 * heater_block_depth, 0.5 * heater_block_height + sock_wall_thickness - 0.01])
    cube([3, 12, 2 * sock_wall_thickness], center = true);

    translate([-0.5 * heater_block_width - sock_wall_thickness + 1, 0.5 * heater_block_depth, 0.5 * heater_block_height + sock_wall_thickness - 0.01])
    cube([3, 3, 2 * sock_wall_thickness], center = true);
    translate([0.5 * heater_block_width + sock_wall_thickness - 1, 0.5 * heater_block_depth, 0.5 * heater_block_height + sock_wall_thickness - 0.01])
    cube([3, 3, 2 * sock_wall_thickness], center = true);
  }
  
  // Nozzle
  color([0.8, 0.7, 0.2])
  translate([0, 0, -(nozzle_hex_height + nozzle_tip_height)])
  {
    translate([0, 0, nozzle_tip_height])
    cylinder(nozzle_hex_height, 3.5 / cos(30), 3.5 / cos(30), $fn = 6);
    
    cylinder(nozzle_tip_height, 0.5, 0.5 + 2 * tan(35));
  }
}

module mount_plate()
{
  translate([-0.5 * mount_plate_width - mounting_bracket_filament_path_x + mounting_bracket_width + 4.5, 0.5 * mount_plate_depth - mounting_bracket_filament_path_y + mounting_bracket_depth, mount_plate_top_z])
  intersection()
  {
    difference()
    {
      // Plate
      translate([0, 0, -mount_plate_height * 0.5])
      cube([mount_plate_width, mount_plate_depth, mount_plate_height], center = true);
      
      // Top-right belt groove
      translate([mount_plate_width * 0.5 - 7.5, 0, -10])
      cube([4, mount_plate_depth + 1, 22], center = true);
      
      // Bottom-right cutaway
      translate([mount_plate_width * 0.5 - 6, 0, 4.5 - mount_plate_height])
      cube([14, mount_plate_depth + 1, 11], center = true);
      
      // Top-left belt groove
      translate([2 - mount_plate_width * 0.5 + 4.5, 0, -5.5])
      cube([4, mount_plate_depth + 1, 13], center = true);
      
      // Bottom-left cutaway
      translate([9.5 - mount_plate_width * 0.5, 0, 4.5 - mount_plate_height])
      cube([21, mount_plate_depth + 1, 11], center = true);
    }
    
    // Round top corners
    translate([0, 0, -mount_plate_height * 0.5])
    union()
    {
      // Rectangle that covers the mount plate entirely except for the corners
      cube([mount_plate_width - 2 * mount_plate_corner_round, mount_plate_depth + 1, mount_plate_height + 1], center = true);

      translate([0, 0, -mount_plate_corner_round])
      cube([mount_plate_width + 1, mount_plate_depth + 1, mount_plate_height + 1], center = true);
      
      // Rounded corner bits
      translate([-0.5 * mount_plate_width + mount_plate_corner_round, 0, 0.5 * mount_plate_height - mount_plate_corner_round])
      rotate([90, 0, 0])
      cylinder(mount_plate_depth + 1, mount_plate_corner_round, mount_plate_corner_round, center = true);

      translate([0.5 * mount_plate_width - mount_plate_corner_round, 0, 0.5 * mount_plate_height - mount_plate_corner_round])
      rotate([90, 0, 0])
      cylinder(mount_plate_depth + 1, mount_plate_corner_round, mount_plate_corner_round, center = true);
    }
  }
}

module x_axis_beam()
{
  // bottom of beam is 48 below top of mount plate and 4 mm behind it
  translate([0, 10 + x_axis_beam_near_y, -10 - 4.8])
  difference()
  {
    cube([420, 20, 20], center = true);
    
    for (side = [0 : 3])
    {
      rotate([90 * side, 0, 0])
      union()
      {
        intersection()
        {
          translate([0, 0, 20 / sqrt(2) + sqrt(2 * 0.75 * 0.75)])
          rotate([45, 0, 0])
          cube([430, 20, 20], center = true);
          
          translate([0, 0, 10 - 0.5 * 4.3 - 1.8])
          cube([440, 11, 4.3], center = true);
        }
        
        translate([0, 0, 20 / sqrt(2) + 10 - 0.5 * 9.16])
        rotate([45, 0, 0])
        cube([450, 20, 20], center = true);
      }
    }
    
    rotate([0, 90, 0])
    cylinder(460, 2.1, 2.1, center = true);
  }
}

module belts()
{
  // Right belt
  translate([100 + 0.5 * mount_plate_width + mounting_bracket_filament_path_x - 0.5 * mounting_bracket_width - 15, -0.5 + 0.75 + belt_y, right_belt_z - belt_thickness])
  cube([200, 1.5, 6], center = true);

  translate([15 + 0.5 * mount_plate_width + mounting_bracket_filament_path_x - 0.5 * mounting_bracket_width - 15, -2.5 + 0.5 * (mount_plate_depth + 2) + belt_y, right_belt_z - belt_thickness])
  cube([30, mount_plate_depth + 2, 6], center = true);

  // Left belt
  translate([-100 - 0.5 * mount_plate_width + mounting_bracket_filament_path_x - 0.5 * mounting_bracket_width - 5, -0.5 + 0.75 + belt_y, left_belt_z - belt_thickness])
  cube([200, 1.5, 6], center = true);

  translate([-15 - 0.5 * mount_plate_width + mounting_bracket_filament_path_x - 0.5 * mounting_bracket_width - 3, -2.5 + 0.5 * (mount_plate_depth + 2) + belt_y, left_belt_z - belt_thickness])
  cube([30, mount_plate_depth + 2, 6], center = true);
}

module manifold_outer_shell()
{
  minkowski()
  {
    translate([0, 0, manifold_rounding_radius + manifold_z])
    cylinder(manifold_height - 2 * manifold_rounding_radius, manifold_radius, manifold_radius);

    sphere(manifold_rounding_radius);
  }
}

module manifold_inner_shell()
{
  difference()
  {
    minkowski()
    {
      translate([0, 0, manifold_rounding_radius + manifold_z])
      cylinder(manifold_height - 2 * manifold_rounding_radius, manifold_radius, manifold_radius);

      sphere(manifold_rounding_radius - 0.75 * wall_thickness);
    }

    // Inner wall
    translate([0, 0, manifold_z])
    cylinder(18, manifold_radius - 5 + wall_thickness, manifold_radius - 5 + wall_thickness + manifold_radius_top_difference);
  }
}

module manifold_inner_space()
{
  translate([0, 0, manifold_z])
  cylinder(18, manifold_inner_space_radius, manifold_inner_space_radius + manifold_radius_top_difference);
}

module manifold_vents()
{
  vent_pitch = 90 - asin((nozzle_height + manifold_z + manifold_vent_z_offset) / (manifold_radius - manifold_rounding_radius));
  vent_length = 2 + sqrt(manifold_z * manifold_z + manifold_radius * manifold_radius);

  for (vent_index = [1 : manifold_vent_count])
  {
    vent_angle = vent_index * 360 / manifold_vent_count;
    
    translate([0, 0, heater_block_base_z - nozzle_height])
    rotate([0, 0, vent_angle])
    rotate([0, vent_pitch, 0])
    cylinder(vent_length, manifold_vent_radius, manifold_vent_radius);
  }
}

module manifold()
{
  translate([0, 0, heater_block_base_z])
  difference()
  {
    union()
    {
      // Main ring
      difference()
      {
        manifold_outer_shell();
        manifold_inner_shell();
        manifold_inner_space();
      }
      
      translate([0, 0, manifold_z + 0.5 * wall_thickness])
      difference()
      {
        cylinder(3, manifold_radius, manifold_radius - 5 + wall_thickness);
      
        translate([0, 0, -1])
        cylinder(5, manifold_radius - 5, manifold_radius - 5 + manifold_radius_top_difference);
      }
      
      // Bottom bevel (avoid shallower than 45 degree angle)
      translate([0, 0, manifold_z])
      difference()
      {
        cylinder(manifold_rounding_radius * (1 - 1 / sqrt(2)), manifold_radius + manifold_rounding_radius * (sqrt(2) - 1), manifold_radius + manifold_rounding_radius / sqrt(2));

        minkowski()
        {
          translate([0, 0, manifold_rounding_radius])
          cylinder(manifold_height - 2 * manifold_rounding_radius, manifold_radius, manifold_radius);

          sphere(manifold_rounding_radius);
        }
        
        translate([0, 0, -1])
        cylinder(manifold_rounding_radius * (1 - 1 / sqrt(2)) + 2, manifold_radius, manifold_radius);
      }
    }
    
    if (see_into_manifold)
    {
      translate([0, -50, 0])
      cube(100);
    }
    
    translate([0, 0, -heater_block_base_z])
    manifold_vents();
  }
}

module manifold_inlet_cutaway()
{
  translate([0, 0, manifold_z + heater_block_base_z - 1])
  {
    difference()
    {
      cylinder(manifold_height + 2, manifold_radius + manifold_rounding_radius, manifold_radius + manifold_rounding_radius);
      cylinder(manifold_height + 2, manifold_radius, manifold_radius);
      translate([-50, 0, 0])
      cube(100, center = true);
    }
  }
}

module manifold_inlet_adaptor(hollow = true)
{
  // This is the piece that builds out the rounded outer wall in a straight
  // line instead of following the curve, including the floor and ceiling,
  // so that the profile of the inlet is 2 dimensional as a starting point
  // for making the segments that make up the 90 degree bend up toward the
  // bottom of the inlet.
  difference()
  {
    translate([0, 0, manifold_z + heater_block_base_z])
    {
      difference()
      {
        union()
        {
          intersection()
          {
            difference()
            {
              // Cuboid with all rounded edges, outer wall
              translate([0.5 * manifold_radius, 0, 0.5 * manifold_height])
              minkowski()
              {
                cube([manifold_radius, manifold_radius * 2, manifold_height - 2 * manifold_rounding_radius], center = true);
                sphere(manifold_rounding_radius);
              }

              // Inner wall
              if (hollow)
              {
                translate([0.5 * manifold_radius, 0, 0.5 * manifold_height])
                minkowski()
                {
                  cube([manifold_radius, manifold_radius * 2, manifold_height - 2 * manifold_rounding_radius], center = true);
                  sphere(manifold_rounding_radius - 0.75 * wall_thickness);
                }
              }
            }
            
            // Intersect down to chop off the ends
            translate([0.5 * manifold_radius, 0, 0.5 * manifold_height])
            cube([manifold_radius, manifold_radius * 2 + manifold_rounding_radius * 2, manifold_height], center = true);
          }
          
          // height: manifold_rounding_radius * (1 - 1 / sqrt(2))
          // bottom radius: manifold_radius + manifold_rounding_radius * (sqrt(2) - 1)
          // top radius: manifold_radius + manifold_rounding_radius / sqrt(2)

          difference()
          {
            union()
            {
              // Close bottom edge bevel
              translate([0, -(manifold_radius + manifold_rounding_radius * (sqrt(2) - 1)), 0])
              rotate([-45, 0, 0])
              translate([0.5 * manifold_radius, -0.5 * manifold_rounding_radius * (sqrt(2) - 1), 0.5 * wall_thickness])
              cube([manifold_radius, manifold_rounding_radius * (sqrt(2) - 1), wall_thickness], center = true);

              // Far bottom edge bevel
              translate([0, manifold_radius + manifold_rounding_radius * (sqrt(2) - 1), 0])
              rotate([45, 0, 0])
              translate([0.5 * manifold_radius, 0.5 * manifold_rounding_radius * (sqrt(2) - 1), 0.5 * wall_thickness])
              cube([manifold_radius, manifold_rounding_radius * (sqrt(2) - 1), wall_thickness], center = true);
              
              // Complete bottom edge
              translate([0.5 * manifold_radius, 0, 0.25 * wall_thickness])
              cube([manifold_radius, 2 * (manifold_radius + manifold_rounding_radius * (sqrt(2) - 1)), 0.5 * wall_thickness], center = true);
            }
            
            // Cuboid with all rounded edges, outer wall
            translate([0.5 * manifold_radius, 0, 0.5 * manifold_height])
            minkowski()
            {
              cube([manifold_radius, manifold_radius * 2, manifold_height - 2 * manifold_rounding_radius], center = true);
              sphere(manifold_rounding_radius);
            }
          }
        }
        
        translate([0, 0, -1])
        cylinder(manifold_height + 2, manifold_radius, manifold_radius);
      }
    }

    if (hollow)
      manifold_vents();
  }
}

module manifold_ceiling_supports()
{
  vent_pitch = 90 - asin((nozzle_height + manifold_z + manifold_vent_z_offset) / (manifold_radius - manifold_rounding_radius));
  vent_length = 2 + sqrt(manifold_z * manifold_z + manifold_radius * manifold_radius);
  vent_projected_length = vent_length * sin(vent_pitch);
  
  translate([0, 0, manifold_z + heater_block_base_z])
  {
    support_count = 2 * ceil(manifold_radius / manifold_ceiling_support_spacing);
    
    ca = cos(manifold_ceiling_support_rotation);
    sa = sin(manifold_ceiling_support_rotation);
    
    for (xi = [-support_count : support_count])
      for (yi = [-support_count : support_count])
      {
        ox = xi * manifold_ceiling_support_spacing * 2 / sqrt(3);
        oy = (yi + (((xi % 2) == 1) ? 1 / tan(60) : 0)) * manifold_ceiling_support_spacing;

        x = ox * ca + oy * sa;
        y = ox * sa - oy * ca;
        
        d = sqrt(x * x + y * y);
        
        if ((d > vent_projected_length)
         && (x > 0)
         && (x < manifold_radius + manifold_rounding_radius - 1)
         && (y > -manifold_radius - manifold_rounding_radius)
         && (y < manifold_radius + manifold_rounding_radius))
        {
          translate([x, y, 0])
          cylinder(manifold_height + 100, manifold_ceiling_support_radius, manifold_ceiling_support_radius);
        }
      }
  }
}

function bezier1d(t, P0, P1, P2, P3)
  = P0 * pow(1 - t, 3)
  + P1 * 3 * pow(1 - t, 2) * t
  + P2 * 3 * (1 - t) * t * t
  + P3 * pow(t, 3);

function bezier3d(t, P0, P1, P2, P3) =
  [
    bezier1d(t, P0[0], P1[0], P2[0], P3[0]),
    bezier1d(t, P0[1], P1[1], P2[1], P3[1]),
    bezier1d(t, P0[2], P1[2], P2[2], P3[2])
  ];

function sum_point_axis(points, axis, skip = 0)
  = points[skip][axis]
  + (skip >= len(points) - 1 ? 0 : sum_point_axis(points, axis, skip + 1));

function average_point(points)
  = [for (axis = [0 : len(points[0]) - 1]) sum_point_axis(points, axis) / len(points)];

// The manifold/inlet connection takes manifold point mx, my, mz
// and inlet point ax, ay, az, and does a bezier spline defined by
// the control points:
//
//  P0 = mx, my, mz
//  P1 = ax, my, mz
//  P2 = ax, ay, mz
//  P3 = ax, ay, az

module manifold_inlet_connection_hull(manifold_points, inlet_points)
{
  // Assumes manifold_points and inlet_points are, each, coplanar and convex.
  
  band_count = manifold_inlet_connection_segments;
  band_length = len(manifold_points);
  
  manifold_cap_center = average_point(manifold_points);
  inlet_cap_center = average_point(inlet_points);
  
  polyhedron(
    points =
    [
      for (band_index = [0 : band_count])
        let (t = band_index / band_count)
          for (point_index = [0 : band_length - 1])
            let (p0 = manifold_points[point_index])
            let (p3 = inlet_points[point_index])
            let (p1 = [p3[0], p0[1], p0[2]])
            let (p2 = [p3[0], p3[1], p0[2]])
              bezier3d(t, p0, p1, p2, p3),

      manifold_cap_center,
      inlet_cap_center
    ],
    faces =
    [
      // Curve, made up of bands
      for (band_index = [0 : band_count - 1])
        let (band_start = band_index * band_length)
          for (point_index = [0 : band_length - 1])
            let (next_point_index = (point_index + 1) % band_length)
              [
                band_start + point_index,
                band_start + next_point_index,
                band_start + band_length + next_point_index,
                band_start + band_length + point_index
              ],
      
      // End caps
      let (manifold_cap_center_index = (band_count + 1) * band_length)
        for (point_index = [0 : band_length - 1])
          let (next_point_index = (point_index + 1) % band_length)
            [next_point_index, point_index, manifold_cap_center_index],
      let (inlet_cap_center_index = (band_count + 1) * band_length + 1)
      let (inlet_last_ring_start = band_count * band_length)
        for (point_index = [0 : band_length - 1])
          let (next_point_index = (point_index + 1) % band_length)
            [inlet_last_ring_start + point_index, inlet_last_ring_start + next_point_index, inlet_cap_center_index]
    ]);
}

module polyline(pts)
{
  for (i = [1 : len(pts) - 1])
    hull()
    {
      translate(pts[i - 1]) sphere(.5, $fn = 6);
      translate(pts[i]) sphere(.5, $fn = 6);
    };
}

module manifold_inlet_connection(hollow = true)
{
  manifold_inlet_x = manifold_radius;
  manifold_inlet_near_y = -manifold_radius - manifold_rounding_radius;
  manifold_inlet_far_y = manifold_radius + manifold_rounding_radius;
  manifold_inlet_top_z = manifold_z + heater_block_base_z + manifold_height;
  manifold_inlet_bottom_z = manifold_z + heater_block_base_z;
  
  inlet_z = connection_top_z;
  inlet_near_y = -0.5 * fan_width - wall_thickness - fan_tab_height;
  inlet_far_y = belt_y - 4;
  inlet_left_x = mounting_bracket_width - mounting_bracket_filament_path_x + inlet_offset_x;
  inlet_right_x = inlet_left_x + wall_thickness + fan_depth + wall_thickness;
  
  // It is very important that the points in these arrays match up, both in
  // count and semantically.
  
  manifold_y_straight_edge_length =
    (manifold_inlet_top_z - manifold_rounding_radius) -
    (manifold_inlet_bottom_z + manifold_rounding_radius);
  
  manifold_inlet_inner_contour =
    [
      [manifold_inlet_x, manifold_inlet_far_y - manifold_rounding_radius, manifold_inlet_top_z - 0.75 * wall_thickness],
      for (i = [1 : $fn / 4])
        let (angle = (i - 0.5) * 90 / ($fn / 4))
          [manifold_inlet_x, manifold_inlet_far_y - manifold_rounding_radius + sin(angle) * (manifold_rounding_radius - 0.75 * wall_thickness), manifold_inlet_top_z - manifold_rounding_radius + cos(angle) * (manifold_rounding_radius - 0.75 * wall_thickness)],
      [manifold_inlet_x, manifold_inlet_far_y - 0.75 * wall_thickness, manifold_inlet_top_z - manifold_rounding_radius],
      [manifold_inlet_x, manifold_inlet_far_y - 0.75 * wall_thickness, manifold_inlet_bottom_z + manifold_rounding_radius],
      for (i = [$fn / 4 + 1 : $fn * 2 / 4])
        let (angle = (i - 0.5) * 90 / ($fn / 4))
          [manifold_inlet_x, manifold_inlet_far_y - manifold_rounding_radius + sin(angle) * (manifold_rounding_radius - 0.75 * wall_thickness), manifold_inlet_bottom_z + manifold_rounding_radius + cos(angle) * (manifold_rounding_radius - 0.75 * wall_thickness)],
      [manifold_inlet_x, manifold_inlet_far_y - manifold_rounding_radius, manifold_inlet_bottom_z + 0.75 * wall_thickness],
      [manifold_inlet_x, manifold_inlet_near_y + manifold_rounding_radius, manifold_inlet_bottom_z + 0.75 * wall_thickness],
      for (i = [$fn * 2 / 4 + 1 : $fn * 3 / 4])
        let (angle = (i - 0.5) * 90 / ($fn / 4))
          [manifold_inlet_x, manifold_inlet_near_y + manifold_rounding_radius + sin(angle) * (manifold_rounding_radius - 0.75 * wall_thickness), manifold_inlet_bottom_z + manifold_rounding_radius + cos(angle) * (manifold_rounding_radius - 0.75 * wall_thickness)],
      [manifold_inlet_x, manifold_inlet_near_y + 0.75 * wall_thickness, manifold_inlet_bottom_z + manifold_rounding_radius],
      [manifold_inlet_x, manifold_inlet_near_y + 0.75 * wall_thickness, manifold_inlet_top_z - manifold_rounding_radius],
      for (i = [$fn * 3 / 4 + 1 : $fn * 4 / 4])
        let (angle = (i - 0.5) * 90 / ($fn / 4))
          [manifold_inlet_x, manifold_inlet_near_y + manifold_rounding_radius + sin(angle) * (manifold_rounding_radius - 0.75 * wall_thickness), manifold_inlet_top_z - manifold_rounding_radius + cos(angle) * (manifold_rounding_radius - 0.75 * wall_thickness)],
      [manifold_inlet_x, manifold_inlet_near_y + manifold_rounding_radius, manifold_inlet_top_z - 0.75 * wall_thickness],
    ];
      
  manifold_inlet_outer_contour =
    [
      [manifold_inlet_x, manifold_inlet_far_y - manifold_rounding_radius, manifold_inlet_top_z],
      for (i = [1 : $fn / 4])
        let (angle = (i - 0.5) * 90 / ($fn / 4))
          [manifold_inlet_x, manifold_inlet_far_y - manifold_rounding_radius + sin(angle) * manifold_rounding_radius, manifold_inlet_top_z - manifold_rounding_radius + cos(angle) * manifold_rounding_radius],
      [manifold_inlet_x, manifold_inlet_far_y, manifold_inlet_top_z - manifold_rounding_radius],
      [manifold_inlet_x, manifold_inlet_far_y, manifold_inlet_bottom_z + manifold_rounding_radius],
      for (i = [$fn / 4 + 1 : $fn * 2 / 4])
        let (angle = (i - 0.5) * 90 / ($fn / 4))
          [manifold_inlet_x, manifold_inlet_far_y - manifold_rounding_radius + sin(angle) * manifold_rounding_radius, manifold_inlet_bottom_z + manifold_rounding_radius + cos(angle) * manifold_rounding_radius],
      [manifold_inlet_x, manifold_inlet_far_y - manifold_rounding_radius, manifold_inlet_bottom_z],
      [manifold_inlet_x, manifold_inlet_near_y + manifold_rounding_radius, manifold_inlet_bottom_z],
      for (i = [$fn * 2 / 4 + 1 : $fn * 3 / 4])
        let (angle = (i - 0.5) * 90 / ($fn / 4))
          [manifold_inlet_x, manifold_inlet_near_y + manifold_rounding_radius + sin(angle) * manifold_rounding_radius, manifold_inlet_bottom_z + manifold_rounding_radius + cos(angle) * manifold_rounding_radius],
      [manifold_inlet_x, manifold_inlet_near_y, manifold_inlet_bottom_z + manifold_rounding_radius],
      [manifold_inlet_x, manifold_inlet_near_y, manifold_inlet_top_z - manifold_rounding_radius],
      for (i = [$fn * 3 / 4 + 1 : $fn * 4 / 4])
        let (angle = (i - 0.5) * 90 / ($fn / 4))
          [manifold_inlet_x, manifold_inlet_near_y + manifold_rounding_radius + sin(angle) * manifold_rounding_radius, manifold_inlet_top_z - manifold_rounding_radius + cos(angle) * manifold_rounding_radius],
      [manifold_inlet_x, manifold_inlet_near_y + manifold_rounding_radius, manifold_inlet_top_z]
    ];
  
  sharp_corner_length = fan_depth * 0.4;
  
  inlet_inner_contour =
    [
      for (i = [0 : $fn / 4 + 1])
        let (j = i)
        let (offset_x = max(0, j - $fn / 8) / ($fn / 8))
        let (offset_y = max(0, $fn / 8 - j) / ($fn / 8))
          [inlet_left_x + wall_thickness - inlet_tolerance + offset_x * sharp_corner_length, inlet_far_y - wall_thickness + inlet_tolerance - offset_y * sharp_corner_length, inlet_z],

      for (i = [$fn / 4 - 1: $fn * 2 / 4])
        let (j = i - $fn / 4 - 1)
        let (offset_x = max(0, $fn / 8 - j) / ($fn / 8))
        let (offset_y = max(0, j - $fn / 8) / ($fn / 8))
          [inlet_right_x - wall_thickness + inlet_tolerance - offset_x * sharp_corner_length, inlet_far_y - wall_thickness + inlet_tolerance - offset_y * sharp_corner_length, inlet_z],

      for (i = [$fn * 2 / 4 : $fn * 3 / 4 + 1])
        let (j = i - $fn * 2 / 4)
        let (offset_x = max(0, j - $fn / 8) / ($fn / 8))
        let (offset_y = max(0, $fn / 8 - j) / ($fn / 8))
          [inlet_right_x - wall_thickness + inlet_tolerance - offset_x * sharp_corner_length, inlet_near_y + wall_thickness - inlet_tolerance + fan_tab_height + offset_y * sharp_corner_length, inlet_z],

      for (i = [$fn * 3 / 4 - 1: $fn * 4 / 4])
        let (j = i - $fn * 3 / 4 - 1)
        let (offset_x = max(0, $fn / 8 - j) / ($fn / 8))
        let (offset_y = max(0, j - $fn / 8) / ($fn / 8))
          [inlet_left_x + wall_thickness - inlet_tolerance + offset_x * sharp_corner_length, inlet_near_y + wall_thickness - inlet_tolerance + fan_tab_height + offset_y * sharp_corner_length, inlet_z]
    ];
  
  inlet_outer_contour =
    [
      for (i = [0 : $fn / 4 + 1])
        let (j = i)
        let (offset_x = max(0, j - $fn / 8) / ($fn / 8))
        let (offset_y = max(0, $fn / 8 - j) / ($fn / 8))
          [inlet_left_x + offset_x * sharp_corner_length, inlet_far_y - offset_y * sharp_corner_length, inlet_z],

      for (i = [$fn / 4 - 1: $fn * 2 / 4])
        let (j = i - $fn / 4 - 1)
        let (offset_x = max(0, $fn / 8 - j) / ($fn / 8))
        let (offset_y = max(0, j - $fn / 8) / ($fn / 8))
          [inlet_right_x - offset_x * sharp_corner_length, inlet_far_y - offset_y * sharp_corner_length, inlet_z],

      for (i = [$fn * 2 / 4 : $fn * 3 / 4 + 1])
        let (j = i - $fn * 2 / 4)
        let (offset_x = max(0, j - $fn / 8) / ($fn / 8))
        let (offset_y = max(0, $fn / 8 - j) / ($fn / 8))
          [inlet_right_x - offset_x * sharp_corner_length, inlet_near_y + offset_y * sharp_corner_length, inlet_z],

      for (i = [$fn * 3 / 4 - 1: $fn * 4 / 4])
        let (j = i - $fn * 3 / 4 - 1)
        let (offset_x = max(0, $fn / 8 - j) / ($fn / 8))
        let (offset_y = max(0, j - $fn / 8) / ($fn / 8))
          [inlet_left_x + offset_x * sharp_corner_length, inlet_near_y + offset_y * sharp_corner_length, inlet_z]
    ];
  
  difference()
  {
    manifold_inlet_connection_hull(manifold_inlet_outer_contour, inlet_outer_contour);
    
    if (hollow)
    {
      manifold_inlet_connection_hull(manifold_inlet_inner_contour, inlet_inner_contour);
    }
  }
}

module mounting_clips()
{
  tab_inset = 5;
  
  color([0.6, 0.9, 0.6])
  union()
  {
    difference()
    {
      support_height = abs(heater_block_base_z) - 0.5 * manifold_height;
      
      translate([-mounting_bracket_filament_path_x, -mounting_bracket_filament_path_y + tab_inset, 0])
      union()
      {
        translate([0, -0.5 * mounting_clip_width, 0])
        {
          // Left clip
          translate([-mounting_clip_depth, 0, -support_height])
          cube([mounting_clip_depth, mounting_clip_width, support_height]);

          translate([-mounting_clip_depth, 0, 0])
          cube([mounting_clip_depth + mounting_clip_tab_depth, mounting_clip_width, mounting_clip_tab_height]);

          translate([0, 0, mounting_clip_tab_height])
          cube([mounting_clip_tab_depth, mounting_clip_width, mounting_clip_lock_height]);

          translate([-mounting_clip_depth, 0, mounting_clip_tab_height + mounting_clip_lock_height])
          cube([mounting_clip_depth + mounting_clip_tab_depth, mounting_clip_width, 1]);

          // Right clip, attached to inlet
          difference()
          {
            translate([mounting_bracket_width + inlet_offset_x - mounting_clip_depth, 0, -mounting_clip_depth])
            multmatrix(
              [[1, 0, -1, mounting_clip_depth],
               [0, 1, 0, 0],
               [0, 0, 1, 0],
               [0, 0, 0, 1]])
            cube([mounting_clip_depth, mounting_clip_width, mounting_clip_depth]);

            translate([mounting_bracket_width + inlet_offset_x, 0, -mounting_clip_depth])
            cube([mounting_clip_depth, mounting_clip_width, mounting_clip_depth]);
          }

          translate([mounting_bracket_width + inlet_offset_x - mounting_clip_depth - mounting_clip_tab_depth, 0, 0])
          cube([mounting_clip_depth + mounting_clip_tab_depth, mounting_clip_width, mounting_clip_tab_height]);

          translate([mounting_bracket_width + inlet_offset_x - mounting_clip_depth - mounting_clip_tab_depth, 0, mounting_clip_tab_height])
          cube([mounting_clip_tab_depth, mounting_clip_width, mounting_clip_lock_height]);

          translate([mounting_bracket_width + inlet_offset_x - mounting_clip_depth - mounting_clip_tab_depth, 0, mounting_clip_tab_height + mounting_clip_lock_height])
          cube([mounting_clip_tab_depth + 1.5, mounting_clip_width, 1]);
        }
      }
      
      translate([0, 0, heater_block_base_z])
      manifold_outer_shell();
    }
    
    difference()
    {
      highest_peg_z_offset = min(
        [
          for (hole = mounting_bracket_fan_attachment_holes)
            hole[1]
        ]);
      
      deepest_peg_y_offset = min(
        [
          for (hole = mounting_bracket_fan_attachment_holes)
            hole[0]
        ]);
      
      plate_width = mounting_bracket_fan_attachment_narrow_width - deepest_peg_y_offset + 1 + 0.5 * mounting_bracket_fan_attachment_hole_diameter;
      plate_height = -heater_block_base_z - highest_peg_z_offset + 1 + 0.5 * mounting_bracket_fan_attachment_hole_diameter;
      
      union()
      {
        translate([mounting_bracket_width - mounting_bracket_filament_path_x, mounting_bracket_depth - mounting_bracket_filament_path_y - mounting_bracket_fan_attachment_narrow_width, heater_block_base_z])
        {
          translate([0, 0, 0])
          cube([mounting_clip_depth, plate_width, plate_height]);
          
          translate([0, 0, plate_height - mounting_clip_depth])
          cube([inlet_width, plate_width, mounting_clip_depth]);
        }
      }
      
      translate([0, 0, heater_block_base_z])
      manifold_outer_shell();
      
      manifold_inlet_connection(hollow = false);
      
      manifold_inlet_adaptor(hollow = false);
    }
    
    peg_radius = 0.5 * mounting_bracket_fan_attachment_hole_diameter - 2 * mounting_bracket_fan_attachment_hole_tolerance;

    for (hole = mounting_bracket_fan_attachment_holes)
    {
      translate([mounting_bracket_width - mounting_bracket_filament_path_x - mounting_bracket_fan_attachment_depth - 1, mounting_bracket_depth - mounting_bracket_filament_path_y - hole[0], -hole[1]])
      rotate([0, 90, 0])
      cylinder(mounting_bracket_fan_attachment_depth + 1, peg_radius, peg_radius);
    }
  }
}

module manifold_inlet_connection_support()
{
  manifold_inlet_x = manifold_radius;

  inlet_left_x = mounting_bracket_width - mounting_bracket_filament_path_x;
  inlet_right_x = inlet_left_x + wall_thickness + fan_depth + wall_thickness;
  
  inlet_z = wall_thickness;
  
  support_width = inlet_right_x - manifold_inlet_x;
  support_height = inlet_z - manifold_z - heater_block_base_z;
  
  bevel_width = manifold_rounding_radius * (sqrt(2) - 1);
  bevel_height = bevel_width;

  difference()
  {
    translate([0, 0, manifold_z + heater_block_base_z])
    union()
    {
      // Close bottom edge bevel
      translate([manifold_inlet_x, -(manifold_radius + manifold_rounding_radius * (sqrt(2) - 1)), 0])
      rotate([-45, 0, 0])
      translate([0.5 * support_width, -0.5 * bevel_width, 0.5 * bevel_height])
      cube([support_width, bevel_width, bevel_height], center = true);

      // Far bottom edge bevel
      translate([manifold_inlet_x, manifold_radius + manifold_rounding_radius * (sqrt(2) - 1), 0])
      rotate([45, 0, 0])
      translate([0.5 * support_width, 0.5 * bevel_width, 0.5 * bevel_height])
      cube([support_width, bevel_width, bevel_height], center = true);
      
      // Right edge bevel
      translate([inlet_right_x, 0, 0])
      rotate([0, 45, 0])
      translate([-0.5 * bevel_width, 0, 0.5 * bevel_height])
      cube([bevel_width, 2 * (manifold_radius + manifold_rounding_radius * (sqrt(2) - 1)), bevel_height], center = true);

      intersection()
      {
        translate([inlet_right_x, 0, 0])
        rotate([0, 45, 0])
        translate([-0.5 * bevel_width, 0, 0.5 * bevel_height])
        cube([bevel_width, 2 * (manifold_radius + manifold_rounding_radius), bevel_height], center = true);
        
        union()
        {
          // Close bottom edge bevel
          translate([manifold_inlet_x + 2 * bevel_width, -(manifold_radius + manifold_rounding_radius * (sqrt(2) - 1)), 0])
          rotate([-45, 0, 0])
          translate([0.5 * support_width, -0.5 * bevel_width, 0.5 * bevel_height])
          cube([support_width, bevel_width, bevel_height], center = true);

          // Far bottom edge bevel
          translate([manifold_inlet_x + 2 * bevel_width, manifold_radius + manifold_rounding_radius * (sqrt(2) - 1), 0])
          rotate([45, 0, 0])
          translate([0.5 * support_width, 0.5 * bevel_width, 0.5 * bevel_height])
          cube([support_width, bevel_width, bevel_height], center = true);
        }
      }
      
      // Complete bottom edge
      translate([manifold_inlet_x + 0.5 * support_width, 0, 0.5 * bevel_height])
      cube([support_width, 2 * (manifold_radius + manifold_rounding_radius * (sqrt(2) - 1)), bevel_height], center = true);
      
      // Fill vertically
      translate([manifold_inlet_x + 0.5 * support_width, 0, 0.5 * (manifold_height - bevel_height)])
      cube([support_width, 2 * (manifold_radius + bevel_width) + bevel_width * sqrt(2), manifold_height - bevel_height * (sqrt(2) + 1)], center = true);
    }
    
    manifold_inlet_connection(hollow = false);
  }
}

module inlet()
{
  union()
  {
    translate([mounting_bracket_width - mounting_bracket_filament_path_x + inlet_offset_x, 0, connection_taper_offset])
    translate([fan_depth * 0.5 + wall_thickness, 0, fan_height * 0.5 + connection_top_z])
    difference()
    {
      // Outer shell
      translate([0, -0.5 * fan_tab_height, -0.5 * inlet_height])
      cube([fan_depth + wall_thickness * 2, fan_width + wall_thickness * 2 + fan_tab_height, inlet_height], center = true);
      // Inner shell
      translate([0, 0, -0.5 * inlet_height])
      cube([fan_depth + inlet_tolerance * 2, fan_width + inlet_tolerance * 2, inlet_height + 1], center = true);
      
      // Air inlet
      translate([fan_depth * 0.5 - wall_thickness * 0.5, fan_intake_offset_x, fan_intake_offset_y])
      rotate([0, 90, 0])
      cylinder(wall_thickness * 2, fan_intake_radius, fan_intake_radius);
      
      // Gap for fan tab
      translate([-0.5 * fan_tab_width - 1, -0.5 * fan_width - inlet_tolerance - fan_tab_height, -0.5 * fan_height + fan_outlet_tab_distance_from_top])
      cube([fan_tab_width, fan_tab_height + 1, fan_height - fan_outlet_tab_distance_from_top + 1]);
      
      // Screw holes
      for (screw_hole = fan_screw_positions)
      {
        translate([-0.5 * fan_depth - 1.5 * wall_thickness, -screw_hole[0], -screw_hole[1]])
        rotate([0, 90, 0])
        cylinder(fan_depth + wall_thickness * 3, 0.5 * fan_screw_hole_diameter + inlet_tolerance, 0.5 * fan_screw_hole_diameter + inlet_tolerance);
      }
    }

    // Taper for overhang
    inlet_near_y = -0.5 * fan_width - wall_thickness - fan_tab_height;
    inlet_far_y = belt_y - 4;
    
    taper_width = fan_depth + wall_thickness * 2;
    taper_depth = fan_width + wall_thickness * 2 + fan_tab_height - (inlet_far_y - inlet_near_y);
    taper_height = connection_taper_height;
    
    translate([0, 0, connection_taper_offset])
    difference()
    {
      translate([0.5 * taper_width + mounting_bracket_width - mounting_bracket_filament_path_x + inlet_offset_x, inlet_near_y + fan_width + wall_thickness * 2 + fan_tab_height - taper_depth, connection_top_z - 0.5 * taper_height])
      multmatrix(
        [[1, 0, 0, 0],
         [0, 1, 0, 0],
         [0, connection_taper_height / taper_depth, 1, 0],
         [0, 0, 0, 1]])
      translate([0, 0.5 * taper_depth, 0])
      cube([taper_width, taper_depth, taper_height], center = true);
      
      taper_angle = atan2(connection_taper_height, taper_depth);
      taper_vertical_thickness = wall_thickness / cos(taper_angle);
      
      translate([0.5 * taper_width + mounting_bracket_width - mounting_bracket_filament_path_x + inlet_offset_x, inlet_near_y + fan_width + wall_thickness * 2 + fan_tab_height - taper_depth, connection_top_z - 0.5 * taper_height + taper_vertical_thickness])
      multmatrix(
        [[1, 0, 0, 0],
         [0, 1, 0, 0],
         [0, connection_taper_height / taper_depth, 1, 0],
         [0, 0, 0, 1]])
      translate([0, 0.5 * taper_depth, 0])
      cube([taper_width - 2 * wall_thickness, taper_depth, taper_height], center = true);
    }
    
    if (include_mockups)
    {
      color([0.4, 0.4, 0.7])
      translate([0.5 * fan_depth + mounting_bracket_width - mounting_bracket_filament_path_x + wall_thickness + inlet_offset_x, 0, 0.5 * fan_height + connection_top_z + connection_taper_offset])
      rotate([90, 180, 90])
      fan_mockup();
    }
  }
}

module part()
{
  inlet();

  difference()
  {
    manifold();
    manifold_inlet_cutaway();
  }

  manifold_inlet_adaptor(hollow = true);

  manifold_inlet_connection(hollow = true);

  manifold_inlet_connection_support();

  intersection()
  {
    manifold_ceiling_supports();

    union()
    {
      manifold_inlet_adaptor(hollow = false);
      manifold_inlet_connection(hollow = false);
    }
  }

  mounting_clips();
}

difference()
{
  part();
  
  if (part_cutaway)
    cube([100, 100, 94], center = true);
}

if (include_mockups)
{
  translate([0, 0, heater_block_base_z])
  hot_end_mockup();
  
  color([.1, .1, .1])
  {
    mount_plate();
    x_axis_beam();
    belts();
  }
}
