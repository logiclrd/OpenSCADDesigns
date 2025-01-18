show_drum = false;
show_back = false;
show_base = false;
show_base_extended = false;
show_axle = true;
show_platform = true;

lumber_2x2_width_inches = 1.5;
lumber_2x4_width_inches = 3.5;
lumber_2x4_thickness_inches = 1.5;
lumber_2x6_width_inches = 5.5;
lumber_2x6_thickness_inches = 1.5;
lumber_4x4_width_inches = 3.5;
lumber_plywood_thickness_inches = 0.5;

lumber_2x2_width_mm = lumber_2x2_width_inches * 25.4;
lumber_2x4_width_mm = lumber_2x4_width_inches * 25.4;
lumber_2x4_thickness_mm = lumber_2x4_thickness_inches * 25.4;
lumber_2x6_width_mm = lumber_2x6_width_inches * 25.4;
lumber_2x6_thickness_mm = lumber_2x6_thickness_inches * 25.4;
lumber_4x4_width_mm = lumber_4x4_width_inches * 25.4;
lumber_plywood_thickness_mm = lumber_plywood_thickness_inches * 25.4;

drum_height_inches = 28;
drum_head_diameter_inches = 24;
drum_widest_circumference_inches = 87;
drum_support_minimum_thickness_inches = 2;
mimi_clearance_inches = 7;
support_span_inches = drum_height_inches - 2 * mimi_clearance_inches;

axle_bearing_separation_inches = 11.5;
axle_bearing_diameter_inches = 3;

drum_slice_count = 25;

drum_widest_diameter_inches = drum_widest_circumference_inches / 3.1415926535;

axle_thickness_inches = lumber_4x4_width_inches + 2 * lumber_2x4_thickness_inches;

back_height_inches = mimi_clearance_inches + support_span_inches;
back_width_feet = 2;
back_peg_length_inches = axle_thickness_inches / 2;

support_span_mm = support_span_inches * 25.4;

drum_height_mm = drum_height_inches * 25.4;
drum_head_diameter_mm = drum_head_diameter_inches * 25.4;
drum_widest_diameter_mm = drum_widest_diameter_inches * 25.4;
drum_support_minimum_thickness_mm = drum_support_minimum_thickness_inches * 25.4;
mimi_clearance_mm = mimi_clearance_inches * 25.4;
back_height_mm = back_height_inches * 25.4;
back_width_mm = back_width_feet * 12 * 25.4;
back_peg_length_mm = back_peg_length_inches * 25.4;

axle_width_mm = back_width_mm + 2 * lumber_2x4_thickness_mm + lumber_2x4_thickness_mm;
axle_bearing_separation_mm = axle_bearing_separation_inches * 25.4;
axle_bearing_diameter_mm = axle_bearing_diameter_inches * 25.4;
axle_thickness_mm = axle_thickness_inches * 25.4;
axle_base_clearance_mm = 4;

base_width_mm = back_width_mm - 2 * lumber_2x4_thickness_mm;
base_extended_width_mm = base_width_mm - 2 * lumber_2x2_width_mm;

drum_head_radius_mm = drum_head_diameter_mm / 2;
drum_widest_radius_mm = drum_widest_diameter_mm / 2;

platform_base_separation_mm = axle_base_clearance_mm - lumber_plywood_thickness_mm / 2 + axle_thickness_mm / 2 * sqrt(2);

wheel_base_diameter_mm = 45;
wheel_offset_y_mm = 30;
wheel_diameter_mm = 35;
wheel_width_mm = 12;

bolt_length_mm = 91;
bolt_diameter_mm = 8;
bolt_plate_width_mm = 36;
bolt_plate_height_mm = 75;
bolt_handle_length_mm = 15;
bolt_handle_offset_mm = 24;
bolt_throw_mm = 21.5;

// Animation
function range(t, start, stop)
  = (t < start) ? 0
  : (t > stop) ? 1
  : ((t - start) / (stop - start));

t1 = range($t, 0, 0.3);
t2 = range($t, 0.3, 0.7);
t3 = range($t, 0.7, 1.0);

back_separation_mm = (1 - t1) * back_height_mm * 1.2;
rotation_angle = t2 * 45;
base_separation_mm = t3 * drum_widest_diameter_mm * (show_drum ? 1.2 : 0.7);

module wheel()
{
  translate([0, 0, -2])
  {
    cylinder(2, d = wheel_base_diameter_mm);
    
    translate([0, 0, -wheel_offset_y_mm])
    rotate([90, 0, 0])
    cylinder(wheel_width_mm, d = wheel_diameter_mm, center = true);
    
    for (x = [-1, 1])
      translate([0, x * (wheel_width_mm / 2 + 2), 0])
      rotate([90, 0, 0])
      linear_extrude(2, center = true)
      polygon(
        [
          [0, 0],
          [0, -wheel_offset_y_mm],
          [wheel_base_diameter_mm / 2 + 1, 0]
        ]);
  }
}

module bolt(bt)
{
  bt1 = range(bt, 0, 0.35);
  bt2 = range(bt, 0.35, 0.65);
  bt3 = range(bt, 0.65, 1);
  
  translate([0, 0, -bt2 * bolt_throw_mm])
  rotate([0, 0, (bt1 - bt3) * 90])
  {
    cylinder(bolt_length_mm, d = bolt_diameter_mm, $fn = 100);
    
    translate([0, 0, bolt_length_mm - bolt_handle_offset_mm])
    rotate([90, 0, 0])
    cylinder(bolt_handle_length_mm + bolt_diameter_mm / 2, d = bolt_diameter_mm, $fn = 100);
  }
}

module drum()
{
  rotate_extrude($fn = 100)
  polygon(
    [
      [0, drum_height_mm],
      [0, 0],
      
      for (yi = [0 : drum_slice_count])
        let (y = yi * drum_height_mm / drum_slice_count)
        let (t = (yi - drum_slice_count / 2) / (drum_slice_count / 2))
        let (x = drum_widest_radius_mm - t * t * (drum_widest_radius_mm - drum_head_radius_mm))
        [x, y]
    ]);
}

module drum_in_place()
{
  translate([0, drum_widest_radius_mm + drum_support_minimum_thickness_mm, 0])
  drum();
}

module back()
{
  module frame()
  {
    translate([-back_width_mm / 2, -0.5, -back_peg_length_mm])
    cube([lumber_2x4_thickness_mm, lumber_2x4_width_mm, back_height_mm - lumber_2x4_thickness_mm + back_peg_length_mm]);
    translate([back_width_mm / 2 - lumber_2x4_thickness_mm, -0.5, -back_peg_length_mm])
    cube([lumber_2x4_thickness_mm, lumber_2x4_width_mm, back_height_mm - lumber_2x4_thickness_mm + back_peg_length_mm]);
    
    // Stops
    stop_height_mm = mimi_clearance_mm + back_peg_length_mm - axle_thickness_mm;
    
    for (x = [-1, 1])
      translate([x * ((back_width_mm - lumber_2x2_width_mm) / 2 - lumber_2x2_width_mm), lumber_2x4_width_mm / 2, stop_height_mm / 2 - back_peg_length_mm + axle_thickness_mm])
      cube([lumber_2x4_thickness_mm, lumber_2x4_width_mm, stop_height_mm], center = true);

    difference()
    {
      union()
      {
        translate([-back_width_mm / 2, 0, back_height_mm - lumber_2x4_thickness_mm])
        cube([back_width_mm, lumber_2x6_width_mm, lumber_2x6_thickness_mm]);

        difference()
        {
          translate([-back_width_mm / 2, 0, mimi_clearance_mm])
          cube([back_width_mm, lumber_2x6_width_mm, lumber_2x6_thickness_mm]);
          
          translate([-back_width_mm / 2, 0, 0])
          cube([lumber_2x4_thickness_mm, lumber_2x4_width_mm, back_height_mm - lumber_2x4_thickness_mm]);
          translate([back_width_mm / 2 - lumber_2x4_thickness_mm, 0, 0])
          cube([lumber_2x4_thickness_mm, lumber_2x4_width_mm, back_height_mm - lumber_2x4_thickness_mm]);
        }
      }
      
      drum_in_place();
    }
  }
  
  module support()
  {
    support_width_mm = back_width_mm - 2 * lumber_2x4_thickness_mm;
    support_elevation_mm = back_height_mm / 2 + lumber_2x4_width_mm / 2;
    support_length_mm = support_elevation_mm + (platform_base_separation_mm + lumber_plywood_thickness_mm / 2 - lumber_2x6_thickness_mm) * sqrt(2);
  
    translate([0, 0, -lumber_2x4_thickness_mm * sqrt(2)])
    difference()
    {
      translate([0, 0, support_elevation_mm - lumber_2x4_width_mm / 2])
      union()
      {
        translate([-support_width_mm / 2, lumber_2x4_width_mm / 2 - support_length_mm, 0])
        cube([lumber_2x4_thickness_mm, support_length_mm + lumber_2x4_width_mm / 2, lumber_2x4_width_mm]);
        translate([support_width_mm / 2 - lumber_2x4_thickness_mm, lumber_2x4_width_mm / 2 - support_length_mm, 0])
        cube([lumber_2x4_thickness_mm, support_length_mm + lumber_2x4_width_mm / 2, lumber_2x4_width_mm]);
      }

      translate([0, lumber_2x4_width_mm * 0.5 - support_length_mm, support_elevation_mm + lumber_2x4_width_mm / 2])
      rotate([-45, 0, 0])
      translate([0, 500, -500])
      cube([1000, 1000, 1000], center = true);
    }
    
    translate([0, -support_length_mm + lumber_2x6_thickness_mm - 3 /* TODO: fixme */, support_elevation_mm])
    rotate([45, 0, 0])
    {
      translate([0, -lumber_2x6_thickness_mm / 2, -lumber_2x6_width_mm / 2])
      cube([support_width_mm, lumber_2x6_thickness_mm, lumber_2x6_width_mm], center = true);
      
      for (x = [-1, 1])
        rotate([270, 0, 0])
        translate([x * (support_width_mm / 2 - wheel_base_diameter_mm), lumber_2x6_width_mm / 2, -lumber_2x6_thickness_mm])
        wheel();
    }
  }

  frame();
  support();
}

module base()
{
  leg_length_mm = platform_base_separation_mm - lumber_2x4_thickness_mm;
  
  riser_height_mm = leg_length_mm - lumber_2x4_thickness_mm;

  for (x = [-1, 1])
  {
    translate([x * (base_width_mm / 2 - lumber_2x2_width_mm / 2), drum_widest_diameter_mm / 4, -lumber_2x2_width_mm / 2])
    cube([lumber_2x2_width_mm, drum_widest_diameter_mm * 0.5 + 0.5, lumber_2x2_width_mm], center = true);

    translate([x * (back_width_mm / 2 - lumber_2x2_width_mm / 2 - lumber_2x2_width_mm), drum_widest_diameter_mm * 0.5 - lumber_2x4_width_mm * 0.5, -riser_height_mm / 2 - lumber_2x2_width_mm])
    cube([lumber_2x4_thickness_mm, lumber_2x4_width_mm, riser_height_mm], center = true);
  }

  translate([
    0,
    drum_widest_diameter_mm / 2 - lumber_2x4_width_mm / 2,
    -lumber_2x4_thickness_mm / 2 - leg_length_mm])
  cube([base_width_mm, lumber_2x4_width_mm, lumber_2x4_thickness_mm], center = true);
}

module base_extended()
{
  leg_length_mm = platform_base_separation_mm - lumber_2x4_thickness_mm + lumber_plywood_thickness_mm;
  
  riser_height_mm = leg_length_mm - lumber_2x4_thickness_mm;

  for (x = [-1, 1])
  {
    translate([x * (back_width_mm / 2 - 2 * lumber_2x4_thickness_mm - lumber_2x2_width_mm / 2), drum_widest_diameter_mm / 2, -lumber_2x2_width_mm / 2])
    cube([lumber_2x2_width_mm, drum_widest_diameter_mm + 0.5, lumber_2x2_width_mm], center = true);

    translate([x * (back_width_mm / 2 - 2 * lumber_2x4_thickness_mm - lumber_2x2_width_mm / 2), drum_widest_diameter_mm - lumber_2x4_width_mm / 2, -riser_height_mm / 2 - lumber_2x2_width_mm])
    cube([lumber_2x4_thickness_mm, lumber_2x4_width_mm, riser_height_mm], center = true);
  }

  translate([0, drum_widest_diameter_mm - lumber_2x4_width_mm / 2, -lumber_2x4_thickness_mm / 2 - leg_length_mm])
  cube([base_extended_width_mm, lumber_2x4_width_mm, lumber_2x4_thickness_mm], center = true);
  
  for (x = [-1, 1])
    translate([x * (base_extended_width_mm / 2 - wheel_base_diameter_mm), drum_widest_diameter_mm - lumber_2x4_width_mm / 2, -leg_length_mm - lumber_2x4_thickness_mm])
    wheel();
}

module axle()
{
  color("teal")
  difference()
  {
    translate([0, lumber_4x4_width_mm / 2, 0])
    {
      difference()
      {
        cube([axle_width_mm, lumber_4x4_width_mm, lumber_4x4_width_mm], center = true);

        color("purple")
        for (x = [-1, 1])
          translate([x * axle_bearing_separation_mm / 2, 0, 0])
          difference()
          {
            cube([lumber_2x6_thickness_mm, lumber_4x4_width_mm * 2, lumber_4x4_width_mm * 2], center = true);
            rotate([0, 90, 0])
            cylinder(5 * lumber_2x6_thickness_mm, d = axle_bearing_diameter_mm, center = true, $fn = 100);
          }
      }
    }

    translate([0, -20, 0])
    {
      translate([-back_width_mm / 2, -0.5, -back_peg_length_mm])
      cube([lumber_2x4_thickness_mm, lumber_2x4_width_mm, back_height_mm - lumber_2x4_thickness_mm + back_peg_length_mm]);
      translate([back_width_mm / 2 - lumber_2x4_thickness_mm, -0.5, -back_peg_length_mm])
      cube([lumber_2x4_thickness_mm, lumber_2x4_width_mm, back_height_mm - lumber_2x4_thickness_mm + back_peg_length_mm]);

      base();
      base_extended();
    }
  }

  color("teal")
  difference()
  {
    translate([0, lumber_2x4_width_mm / 2, 0])
    for (x = [-1, 1])
      for (z = [-1, 1])
        translate([x * (back_width_mm / 2 - lumber_2x4_thickness_mm), 0, z * (lumber_4x4_width_mm / 2 + lumber_2x4_thickness_mm / 2)])
        cube([5 * lumber_2x4_thickness_mm, lumber_2x6_width_mm, lumber_2x6_thickness_mm], center = true);

    translate([-back_width_mm / 2, -0.5, -back_peg_length_mm])
    cube([lumber_2x4_thickness_mm, lumber_2x4_width_mm, back_height_mm - lumber_2x4_thickness_mm + back_peg_length_mm]);
    translate([back_width_mm / 2 - lumber_2x4_thickness_mm, -0.5, -back_peg_length_mm])
    cube([lumber_2x4_thickness_mm, lumber_2x4_width_mm, back_height_mm - lumber_2x4_thickness_mm + back_peg_length_mm]);
  }

  bt = range($t, 0.75, 1);

  color("green")
  for (x = [-1, 1])
    translate([x * axle_width_mm / 2, lumber_4x4_width_mm / 2 + lumber_4x4_width_mm / 2 - lumber_2x6_width_mm / 2, -lumber_2x6_thickness_mm])
    rotate([-45, 0, 0])
    rotate([0, 0, 90 - 90 * x])
    translate([0, 0, -lumber_4x4_width_mm / sqrt(2)])
    bolt(bt);
}

module platform()
{
  platform_depth_mm = drum_widest_radius_mm + lumber_2x6_width_mm / 2 - lumber_4x4_width_mm / 2;

  translate([0, platform_depth_mm / 2 - lumber_2x6_width_mm / 2, -platform_base_separation_mm - lumber_plywood_thickness_mm / 2])
  cube([drum_widest_diameter_mm, platform_depth_mm, lumber_plywood_thickness_mm], center = true);
  
  for (x = [-1, 1])
    for (y = [-1, 1])
      translate([x * (drum_widest_radius_mm - wheel_base_diameter_mm), y * (platform_depth_mm / 2 - wheel_base_diameter_mm) + platform_depth_mm / 2 - lumber_2x6_width_mm / 2, -platform_base_separation_mm - lumber_plywood_thickness_mm])
      wheel();

  for (x = [-1, 1])
    translate([x * axle_bearing_separation_mm / 2, 0, -platform_base_separation_mm / 2])
    {
      difference()
      {
        cube([lumber_2x6_thickness_mm, lumber_2x6_width_mm, platform_base_separation_mm], center = true);
        translate([0, 0, platform_base_separation_mm / 2])
        rotate([0, 90, 0])
        cylinder(2 * lumber_2x6_thickness_mm, d = axle_bearing_diameter_mm, center = true, $fn = 100);
      }
    };
}

rotate([rotation_angle, 0, 0])
translate([0, -lumber_4x4_width_mm / 2, 0])
{
  if (show_back)
  {
    color("black")
    translate([0, 0, back_separation_mm])
    back();
  }
  if (show_base)
  {
    color("purple")
    base();
  }
  if (show_base_extended)
  {
    color("orange")
    translate([0, base_separation_mm, 0])
    base_extended();
  }
  if (show_axle)
    axle();

  if (show_drum)
  {
    color("brown")
    drum_in_place();
  }
}

if (show_platform)
  platform();
