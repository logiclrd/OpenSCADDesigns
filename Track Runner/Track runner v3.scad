track_width = 84;
track_height = 16.5;
track_spacing = 18;
first_track_offset = 4;
track_slot_width = 4.5;
track_slot_height = 5;
track_slot_lip = 4;

top_channel_width = 30;
top_channel_inset = 5;

last_track_offset = first_track_offset + track_spacing * 4;

mount_clip_width = 3;
mount_top_height = 5.75;
mount_detent_size = 2;
mount_module_pin_width = 4;

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
motor_mount_screw_diameter = 3;

pulley_mount_screw_diameter = 4;

perimeter_module_overhang_height = 10;
perimeter_module_plate_height = 15;
perimeter_module_mount_width = 50;
perimeter_module_overhang_amount = 13;

belt_switch_plate_width = 120;
belt_pulley_plate_width = 20;

fit_tolerance = 0.1;

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

module mount_clip(mount_width)
{
  translate([0, -mount_clip_width, -mount_clip_width])
  difference()
  {
    union()
    {
      cube([mount_width, track_width + 2 * mount_clip_width, track_height + mount_top_height + mount_clip_width]);
      
      difference()
      {
        union()
        {
          translate([0, -mount_clip_width, 0])
          cube([mount_module_pin_width, track_width + 4 * mount_clip_width, track_height + mount_top_height + mount_clip_width]);
          translate([mount_width - mount_module_pin_width, -mount_clip_width, 0])
          cube([mount_module_pin_width, track_width + 4 * mount_clip_width, track_height + mount_top_height + mount_clip_width]);
        }
        
        bevel_size = min(mount_module_pin_width, 2 * mount_clip_width);
        
        for (side = [-1, 1])
          for (end = [-1, 1])
          {
            translate([(mount_width) / 2, 0, 0])
            scale([end, 1, 1])
            translate([-(mount_width) / 2, 0, 0])
            
            translate([0, (track_width + 2 * mount_clip_width) / 2, 0])
            scale([1, side, 1])
            translate([0, -(track_width + 2 * mount_clip_width) / 2, 0])
            
            translate([mount_module_pin_width, -bevel_size, 0])
            rotate([0, 0, 45])
            translate([0, -5, 0])
            cube([50, 10 + bevel_size * sqrt(2), 100], center = true);
          }
      }
    }
    
    translate([-1, mount_clip_width, mount_clip_width])
    cube([mount_width + 2, track_width, track_height]);
    translate([-1, 2 * mount_clip_width, -1])
    cube([mount_width + 2, track_width - 2 * mount_clip_width, track_height + 1]);
  }
}

module_wing_size = 10;

module mount_module(mount_width)
{
  translate([mount_module_pin_width, -(mount_clip_width + mount_clip_width), -mount_clip_width])
  translate(
    [
      0.5 * (mount_width - 2 * mount_module_pin_width),
      0.5 * (track_width + 4 * mount_clip_width),
      0.5 * (track_height + mount_top_height * 2 + mount_clip_width)
    ])
  difference()
  {
    cube(
      [
        mount_width - 2 * mount_module_pin_width - 2 * fit_tolerance,
        track_width + 4 * mount_clip_width + module_wing_size * 2,
        track_height + mount_top_height * 2 + mount_clip_width
      ], center = true);

    translate([0, 0, -mount_clip_width])
    cube(
      [
        mount_width,
        track_width + 2 * mount_clip_width + 2 * fit_tolerance,
        track_height + mount_top_height * 2 + mount_clip_width
      ], center = true);
    
    for (side = [-1, 1])
      for (end = [-1, 1])
        translate([end * (mount_width * 0.5 - 2 * pulley_mount_screw_diameter), side * (track_width / 2 + mount_clip_width * 2 + module_wing_size / 2), 0])
        cylinder(2 * track_height, d = pulley_mount_screw_diameter, center = true, $fn = 40);
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

module stepper_motor(expand, screw_channels = false)
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
  
  if (screw_channels)
  {
    for (x = [-1, 1])
      for (y = [-1, 1])
        translate([x * 31 / 2, y * 31 / 2, 0])
        cylinder(50, d = motor_mount_screw_diameter + 0.5, $fn = 40);
  }
}

motor_mount_extension_length = 60;

module belt_motor_module(mount_module_width)
{
  translate([mount_module_width - 50, 0, 0])
  union()
  {
    translate([50 - mount_module_width, 0, 0])
    mount_module(mount_module_width);
    
    translate([-9.5, 0, 0])
    for (side = [0 : 1])
    {
      translate([-1, side * track_width, 0])
      scale([1, 1 - side * 2, 1])
      {
        translate([
          perimeter_module_mount_width + 0.5 * motor_mount_extension_length + 9,
          5 - perimeter_module_overhang_amount,
          0.5 * (track_height + perimeter_module_plate_height) + 1])
        difference()
        {
          translate([-1, 0, 0])
          cube([
            motor_mount_extension_length + 10,
            10,
            track_height + 2 * mount_clip_width], center = true);
          
          translate([-0.5 * (motor_mount_extension_length + 3), track_width * 0.5 + 2 - fit_tolerance, 0])
          cube([
            mount_module_pin_width + 2 * fit_tolerance,
            track_width,
            2 * track_height], center = true);
          
          translate([-motor_mount_extension_length * 0.5 - 8 - fit_tolerance, 0, 0])
          cube([
            10,
            track_width,
            2 * track_height], center = true);
        }

        translate([0, 0, 10])
        multmatrix(
          [[1, 0, 0, 0],
           [0, 1, 0, 0],
           [0, -1, 1, 0],
           [0, 0, 0, 1]])
        difference()
        {
          translate([
            perimeter_module_mount_width + 0.5 * motor_mount_extension_length + 13,
            10 - perimeter_module_overhang_amount,
            0])
          cube([motor_mount_extension_length, 20, 10], center = true);

          translate([
            perimeter_module_mount_width + 0.5 * motor_mount_extension_length + 12.5,
            10.1 - perimeter_module_overhang_amount,
            5])
          cube([(motor_mount_extension_length - 4) / 3 + 0.2, 20, 10], center = true);
        }
      }
    }
    
    translate([-10.5, 0, $preview ? 0 : -50])
    union()
    {
      translate([
        perimeter_module_mount_width + 0.5 * motor_mount_extension_length + 15,
        track_width * 0.5,
        10 - 7])
      difference()
      {
        cube([motor_mount_extension_length - 4, track_width + 6 - 20.1, 10], center = true);

        translate([0, 0, 11])
        rotate([180, 0, 0])
        stepper_motor(true, true);
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
          perimeter_module_mount_width + 0.5 * motor_mount_extension_length + 12.5,
          15.1 - perimeter_module_overhang_amount,
          0])
        cube([(motor_mount_extension_length - 4) / 3, 10, 10], center = true);
      }
    }
  }
}

if ($preview)
{
  track();
}

module_width = 60;

mount_clip(module_width);

translate([-module_width * 1.5, 0, 2 * track_height])
mount_module(module_width);

translate([0, 0, 2 * track_height])
belt_motor_module(module_width);
