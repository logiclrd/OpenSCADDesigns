render_part_1 = true;
render_part_2 = false;
render_part_3 = false;

beam_length = 440;
beam_width = 30;
beam_thickness = 10;
beam_hook_length = 15;
beam_hook_depth = 3;
beam_hook_tolerance = 0.4;

hinge_bracket_height = 48;
hinge_pin_diameter = 10;
hinge_pin_spacing = 0.6;
hinge_pin_head_spacing = 1;
hinge_pin_wall = 7;
hinge_pin_overall_diameter = hinge_pin_diameter + 2 * hinge_pin_wall;
hinge_pin_steps = $preview ? 15 : 90;
hinge_pin_ramp_height = 5;

hinge_bracket_cutaway_start = beam_length - hinge_bracket_height - beam_thickness - 1;
hinge_bracket_width = beam_width + 1.5 * beam_thickness;

hinge_pin_head_height = 30;

pin_to_wall_distance = 0.5 * hinge_pin_overall_diameter + 1.45 * beam_thickness;

cell_phone_width = 170;
cell_phone_height = 85;
cell_phone_thickness = 19;

cell_phone_opening_start = 16;
cell_phone_opening_length = 41;
cell_phone_opening_thickness = 12;

bucket_wall_thickness = 3;
bucket_floor_thickness = 12;
bucket_floor_angle = 35;
bucket_width = cell_phone_width + 2 * bucket_wall_thickness;
bucket_height = cell_phone_height + bucket_floor_thickness + hinge_pin_head_height;
bucket_thickness = cell_phone_thickness + 2 * bucket_wall_thickness;

bucket_retainer_width = 5;
bucket_retainer_height = cell_phone_height / 5;

part_2_y_offset = 60;
part_3_y_offset = 120;

// Part 1: Bracket that hangs off top of shower frame
if (render_part_1)
difference()
{
  union()
  {
    cube([beam_length, beam_thickness, beam_width]);

    cube([beam_thickness, 2 * beam_thickness + beam_hook_depth, beam_width + beam_thickness + pin_to_wall_distance + bucket_width]);

    translate([0, beam_thickness + beam_hook_depth, 0])
    cube([beam_thickness + beam_hook_length, beam_thickness, beam_width]);
  }
  
  translate([hinge_bracket_cutaway_start - 1, 0.5 * beam_thickness - beam_hook_tolerance, beam_width - beam_thickness])
  cube([hinge_bracket_height + 2, 0.5 * beam_thickness + 2, beam_thickness + 1]);
}

// Part 2: Hinge that attaches near bottom of bracket
if (render_part_2)
union()
{
  rotate([0, 90, 0])
  translate([-(hinge_bracket_height + hinge_bracket_cutaway_start), part_2_y_offset + 0.5 * beam_thickness + hinge_pin_overall_diameter, 0.5 * beam_thickness])
  color("red")
  {
    union()
    {
      translate([hinge_bracket_cutaway_start, 0.5 * beam_thickness, beam_width - beam_thickness])
      cube([hinge_bracket_height, 0.45 * beam_thickness, beam_thickness + 2]);
      
      translate([hinge_bracket_cutaway_start, -0.5 * beam_thickness, beam_width])
      cube([hinge_bracket_height, 1.45 * beam_thickness, beam_thickness]);
      
      translate([hinge_bracket_cutaway_start, -0.5 * beam_thickness, -0.5 * beam_thickness])
      cube([hinge_bracket_height, 0.5 * beam_thickness, 1.5 * beam_thickness + beam_width - 1]);
      
      translate([hinge_bracket_cutaway_start, -0.5 * beam_thickness, -0.5 * beam_thickness])
      cube([hinge_bracket_height, 0.5 * beam_thickness + 2, 0.5 * beam_thickness]);
    }
  }
  
  color("blue")
  {
    translate([hinge_bracket_width - 0.5 * hinge_pin_overall_diameter, part_2_y_offset + hinge_pin_overall_diameter * 0.5, 0])
    difference()
    {
      union()
      {
        cylinder(hinge_bracket_height, hinge_pin_overall_diameter * 0.5, hinge_pin_overall_diameter * 0.5, $fn = hinge_pin_steps * 2);
        
        translate([-0.5 * hinge_pin_overall_diameter, 0, 0])
        cube([hinge_pin_overall_diameter, hinge_pin_overall_diameter * 0.5, hinge_bracket_height]);
      }

      translate([0, 0, -1])
      cylinder(hinge_bracket_height + 2, (hinge_pin_diameter + hinge_pin_spacing) * 0.5, (hinge_pin_diameter + hinge_pin_spacing) * 0.5, $fn = hinge_pin_steps);

      hinge_ramp();
    }
  }
}

module hinge_ramp_wedge(outer_radius, inner_radius, step, height)
{
  for (half = [0, 180])
  {
    start_angle = half + (step - 1) * 180 / hinge_pin_steps;
    end_angle = half + step * 180 / hinge_pin_steps + 0.1;
    
    start_height = hinge_bracket_height - hinge_pin_ramp_height * (step - 1) / hinge_pin_steps;
    end_height = hinge_bracket_height - hinge_pin_ramp_height * step / hinge_pin_steps;
    
    outer_start_x = outer_radius * cos(start_angle);
    outer_start_y = outer_radius * sin(start_angle);
    
    outer_end_x = outer_radius * cos(end_angle);
    outer_end_y = outer_radius * sin(end_angle);
    
    inner_start_x = inner_radius * cos(start_angle);
    inner_start_y = inner_radius * sin(start_angle);
    
    inner_end_x = inner_radius * cos(end_angle);
    inner_end_y = inner_radius * sin(end_angle);
    
    top_pt1 = [outer_start_x, outer_start_y, height];
    top_pt2 = [outer_end_x, outer_end_y, height];
    top_pt3 = [inner_end_x, inner_end_y, height];
    top_pt4 = [inner_start_x, inner_start_y, height];
    
    bottom_pt1 = [outer_start_x, outer_start_y, start_height];
    bottom_pt2 = [outer_end_x, outer_end_y, end_height];
    bottom_pt3 = [inner_end_x, inner_end_y, end_height];
    bottom_pt4 = [inner_start_x, inner_start_y, start_height];
    
    polyhedron(
      points =
        [
          top_pt1, bottom_pt1,
          top_pt2, bottom_pt2,
          top_pt3, bottom_pt3,
          top_pt4, bottom_pt4
        ],
      faces =
        [
          [0, 2, 3, 1],
          [2, 4, 5, 3],
          [4, 6, 7, 5],
          [6, 0, 1, 7],
          [0, 6, 4, 2],
          [1, 3, 5, 7]
        ]);
  }
}

module hinge_ramp(height = hinge_bracket_height + 1, spacing = 0, clear = true)
{
  outer_radius = 0.5 * (hinge_pin_overall_diameter - spacing);
  inner_radius = 0.5 * (hinge_pin_diameter - 1);
  clear_radius = hinge_pin_overall_diameter + 1;
  
  for (step = [1 : hinge_pin_steps])
  {
    hinge_ramp_wedge(outer_radius, inner_radius, step, height);
    
    if (clear)
      hinge_ramp_wedge(clear_radius, outer_radius - 0.1, step, height);
  }
}

// Part 3: Bucket that holds cell phone and sits in hinge
if (render_part_3)
color("green")
translate($preview ? [0, part_2_y_offset + 0.5 * hinge_pin_overall_diameter + pin_to_wall_distance, 0] : [0, part_3_y_offset, 0])
{
  translate([hinge_bracket_width - 0.5 * hinge_pin_overall_diameter, -pin_to_wall_distance, 0])
  union()
  {
    hinge_ramp(height = hinge_bracket_height + hinge_pin_head_height, spacing = hinge_pin_head_spacing, clear = false);
    
    cylinder(hinge_bracket_height + hinge_pin_head_height, 0.5 * hinge_pin_diameter, 0.5 * hinge_pin_diameter, $fn = hinge_pin_steps * 2);
    
    attachment_length = pin_to_wall_distance - 0.5 * bucket_thickness + hinge_pin_head_spacing + 0.5; // TODO: figure out where this 0.5 is supposed to be coming from
    
    translate([0, 0.5 * hinge_pin_overall_diameter - bucket_thickness - hinge_pin_head_spacing, hinge_bracket_height + hinge_pin_head_spacing])
    difference()
    {
      multmatrix(
        [[1, 0, 0, 0],
         [1, 1, 0, 0],
         [0, 0, 1, 0],
         [0, 0, 0, 1]])
      {
        cube([attachment_length, bucket_thickness, hinge_pin_head_height - hinge_pin_head_spacing]);
      }
      
      // Prevent attachment from sticking out the other side of the pin head
      translate([-1, -hinge_pin_overall_diameter / sqrt(2), -1])
      cube([attachment_length, hinge_pin_overall_diameter, hinge_pin_head_height + 2]);
    }
    
    translate([attachment_length, pin_to_wall_distance - bucket_thickness, hinge_bracket_height + hinge_pin_head_height - bucket_height])
    bucket();
  }
}

module bucket()
{
  union()
  {
    difference()
    {
      cube([bucket_width, bucket_thickness, bucket_height]);
      
      translate([bucket_wall_thickness, bucket_wall_thickness, bucket_floor_thickness])
      cube([cell_phone_width, bucket_thickness, cell_phone_height]);
      
      translate([0.5 * bucket_wall_thickness + cell_phone_width, bucket_wall_thickness + cell_phone_thickness - cell_phone_opening_thickness, bucket_floor_thickness + cell_phone_height - cell_phone_opening_start - cell_phone_opening_length])
      cube([2 * bucket_wall_thickness, cell_phone_opening_thickness, cell_phone_opening_length]);
      
      taper_side_length = cell_phone_opening_thickness / sqrt(2);
      
      translate([1.5 * bucket_wall_thickness + cell_phone_width, bucket_wall_thickness + cell_phone_thickness - 0.5 * cell_phone_opening_thickness, bucket_floor_thickness + cell_phone_height - cell_phone_opening_start])
      rotate([45, 0, 0])
      cube([2 * bucket_wall_thickness, taper_side_length, taper_side_length], center = true);
      
      translate([1.5 * bucket_wall_thickness + cell_phone_width, bucket_wall_thickness + cell_phone_thickness - 0.5 * cell_phone_opening_thickness, bucket_floor_thickness + cell_phone_height - cell_phone_opening_start - cell_phone_opening_length])
      rotate([45, 0, 0])
      cube([2 * bucket_wall_thickness, taper_side_length, taper_side_length], center = true);
      
      floor_angle_side_length = cell_phone_thickness / sqrt(2);
      
      translate([bucket_wall_thickness + 0.5 * cell_phone_width, bucket_wall_thickness + 0.5 * cell_phone_thickness, bucket_floor_thickness])
      scale([1, 1, sin(bucket_floor_angle) * sqrt(2)])
      rotate([45, 0, 0])
      cube([cell_phone_width, floor_angle_side_length, floor_angle_side_length], center = true);
    }
    
    difference()
    {
      translate([bucket_wall_thickness - 1, bucket_thickness - bucket_wall_thickness, bucket_floor_thickness])
      cube([bucket_retainer_width + 1, bucket_wall_thickness, bucket_retainer_height]);
      
      taper_side_length = bucket_retainer_width * sqrt(2);
      
      translate([bucket_wall_thickness + bucket_retainer_width, bucket_thickness - 0.5 * bucket_wall_thickness, bucket_floor_thickness + bucket_retainer_height])
      rotate([0, 45, 0])
      cube([taper_side_length, bucket_wall_thickness * 2, taper_side_length], center = true);
    }

    difference()
    {
      translate([bucket_wall_thickness + cell_phone_width - bucket_retainer_width, bucket_thickness - bucket_wall_thickness, bucket_floor_thickness])
      cube([bucket_retainer_width + 1, bucket_wall_thickness, bucket_retainer_height]);
      
      taper_side_length = bucket_retainer_width * sqrt(2);
      
      translate([bucket_wall_thickness + cell_phone_width - bucket_retainer_width, bucket_thickness - 0.5 * bucket_wall_thickness, bucket_floor_thickness + bucket_retainer_height])
      rotate([0, 45, 0])
      cube([taper_side_length, bucket_wall_thickness * 2, taper_side_length], center = true);
    }
  }
}