detail = $preview ? 10 : 10;

joint_tolerance = 1;
joint_rounding = 0.5;
base_joint_hook_width = 2;
base_joint_bar_size = 3;
number_of_segments = 3;

function find_circle_tangent_from_point(circle_x, circle_y, circle_r, point_x, point_y) =
  // Define the tangent line as (y - point_y) = m * (x - point_x)
  //
  // Rearranging this to the form ax + by + c = 0 gives:
  //
  // m * (x - point_x) = (y - point_y)
  // mx - m*point_x = (y - point_y)
  // mx - y - m*point_x = -point_y
  // mx - y + point_y - m*point_x = 0
  //
  //   a = m
  //   b = -1
  //   c = point_y - m*point_x
  //
  // Since the tangent line touches the circle, the distance
  // from the line to (circle_x, circle_y) must be circle_r.
  // The equation for this is:
  //
  //   distance = abs(aX + bY + c) / sqrt(a^2 + b^2)
  //
  // Substituting:
  //
  //   circle_r = abs(m*circle_x - circle_y + (point_y - m*point_x)) / sqrt(m^2 + 1)
  //
  // To keep each line shorter:
  //
  //   circle_m = m*circle_x - circle_y
  //   point_m = point_y - m*point_x
  //
  //   circle_r = abs(circle_m + point_m) / sqrt(m^2 + 1)
  //
  // Square:
  //
  //   circle_r^2 = abs^2(circle_m + point_m) / (m^2 + 1)
  //
  // Rearrange:
  //
  //   circle_r^2 m^2 + circle_r^2 = abs^2(circle_m + point_m)
  //   circle_r^2 m^2 + circle_r^2 - abs^2(circle_m + point_m) = 0
  //   circle_r^2 m^2 + circle_r^2 - abs^2((m*circle_x - circle_y) + (point_y - m*point_x)) = 0
  //
  // Let:
  //
  //   dx = point_x - circle_x
  //   dy = point_y - circle_y
  //
  // Then:
  //
  //   circle_r^2 m^2 + circle_r^2 - abs^2((m*circle_x - circle_y) + (point_y - m*point_x)) = 0
  //   circle_r^2 m^2 + circle_r^2 - abs^2(dy - m*dx) = 0
  //   circle_r^2 m^2 + circle_r^2 - (dy^2 - 2m*dx*dy + m^2*dx^2) = 0
  //   (circle_r^2 - dx^2) m^2 + circle_r^2 - (dy^2 - 2m*dx*dy) = 0
  //   (circle_r^2 - dx^2) m^2 + 2m*dx*dy + circle_r^2 - dy^2 = 0
  //
  // For am^2 + bm + c = 0:
  //
  //   a = circle_r^2 - dx^2
  //   b = 2*dx*dy
  //   c = circle_r^2 - dy^2
  //
  // By quadratic formula:
  //
  //       -b +/- sqrt(b^2 - 4ac)
  //   m = ----------------------
  //                2a
  //
  // Tangent point is the point where the slope of the circle equals m.
  // Slope of a point (x, y) on a unit circle is (-x / y) = -cot(a) = m
  // So, tan(a) = -1/m
  // So, a = arctan(-1/m)
  let
  (
    dx = point_x - circle_x,
    dy = point_y - circle_y,
  
    a = circle_r*circle_r - dx*dx,
    b = 2*dx*dy,
    c = circle_r*circle_r - dy*dy,
    
    m = (-b + sqrt(b*b - 4*a*c)) / (2*a),
  
    angle_to_tangent_point = atan(-1 / m)
  )
  [circle_x + circle_r * cos(angle_to_tangent_point), circle_y + circle_r * sin(angle_to_tangent_point)];

module segment_hull(
  up_width, up_height, previous_down_height, joint_bar_size,
  length,
  down_width, down_height, joint_hook_width, next_joint_bar_size)
{
  up_edge_left = [-0.5 * up_width, 0, 0.5 * up_height];
  up_edge_right = [0.5 * up_width, 0, 0.5 * up_height];
  
  up_shoulder_left = [-0.6 * up_width, joint_bar_size, 0.55 * up_height];
  up_shoulder_right = [0.6 * up_width, joint_bar_size, 0.55 * up_height];
  
  up_opening_top_left = [-0.45 * up_width, 0.5 * joint_bar_size, 0.85 * up_height];
  up_opening_top_right = [0.45 * up_width, 0.5 * joint_bar_size, 0.85 * up_height];
  
  up_top_left = [-0.4 * up_width, 0.5 * previous_down_height, up_height];
  up_top_right = [0.4 * up_width, 0.5 * previous_down_height, up_height];
  
  up_bottom_left = [-0.4 * up_width, 0.5 * previous_down_height, 0];
  up_bottom_right = [0.4 * up_width, 0.5 * previous_down_height, 0];
  
  down_offset = 0.5 * previous_down_height + length;
  
  back_circle_tangent_point = find_circle_tangent_from_point(
    -down_offset, down_height * 0.5, down_height * 0.5,
    -0.5 * previous_down_height, up_height);
    
  back_slope = (up_height - back_circle_tangent_point[1]) / (back_circle_tangent_point[0] + 0.5 * previous_down_height);
  
  down_top_height = up_height + back_slope * (length + down_height * 0.5);

  down_top_left = [-0.4 * down_width, down_offset + 0.5 * down_height, down_top_height];
  down_top_right = [0.4 * down_width, down_offset + 0.5 * down_height, down_top_height];
  
  down_shoulder_left = [-0.6 * down_width, down_offset + 0.5 * down_height, 0.55 * down_height];
  down_shoulder_right = [0.6 * down_width, down_offset + 0.5 * down_height, 0.55 * down_height];
  
  down_bottom_left = [-0.4 * down_width, down_offset + 0.5 * down_height, 0];
  down_bottom_right = [0.4 * down_width, down_offset + 0.5 * down_height, 0];
  
  polyhedron(
    points =
    [
      /* 0 */ up_edge_left, up_edge_right,
      /* 2 */ up_shoulder_left, up_shoulder_right,
      /* 4 */ up_opening_top_left, up_opening_top_right,
      /* 6 */ up_top_left, up_top_right,
      /* 8 */ up_bottom_left, up_bottom_right,
      /* 10 */ down_top_left, down_top_right,
      /* 12 */ down_shoulder_left, down_shoulder_right,
      /* 14 */ down_bottom_left, down_bottom_right
    ],
    faces =
    [
      [0, 4, 5, 1],
      [0, 2, 4],
      [1, 5, 3],
      
      [4, 6, 7, 5],
      [4, 2, 6],
      [5, 7, 3],
      
      [0, 1, 9, 8],
      [0, 8, 2],
      [1, 3, 9],
      
      [6, 10, 11, 7],
      [6, 2, 12, 10],
      [7, 11, 13, 3],
      [2, 8, 14, 12],
      [3, 13, 15, 9],
      [15, 14, 8, 9],
      
      [11, 10, 12, 14, 15, 13]
    ]
  );
}

module segment_rounded(
  up_width, up_height, previous_down_height, joint_bar_size,
  length,
  down_width, down_height, joint_hook_width, next_joint_bar_size,
  previous_rounding, rounding)
{
  down_offset = 0.5 * previous_down_height + length;

  minkowski()
  {
    intersection()
    {
      segment_hull(
        up_width, up_height, previous_down_height + previous_rounding - rounding, joint_bar_size,
        length,
        down_width, down_height, joint_hook_width, next_joint_bar_size);

      union()
      {
        translate([-0.5 * (down_width * 1.5 + joint_rounding), down_offset, down_height * 0.5])
        rotate([0, 90, 0])
        cylinder(
          h = down_width * 1.5,
          r = down_height * 0.5,
          $fn = detail * 16);
        
        back_circle_tangent_point = find_circle_tangent_from_point(
          -down_offset, down_height * 0.5, down_height * 0.5,
          -0.5 * previous_down_height, up_height);
        
        cube_size = down_height + down_offset + down_height;
  
        translate([-0.5 * cube_size, -back_circle_tangent_point[0] - cube_size, 0])
        cube(size = cube_size);
      }
    }

    sphere(r = rounding, $fn = detail);
  }
}

module up_cutout(
  up_width, up_height, previous_down_height, joint_bar_size,
  previous_rounding, rounding)
{
  translate([0, 0.5 * joint_bar_size - rounding, 0])
  minkowski()
  {
    translate([-0.25 * up_width + 0.5 * joint_rounding, 0, 0.5 * up_height + previous_rounding - rounding])
    rotate([0, 90, 0])
    difference()
    {
      cylinder(
        h = up_width * 0.5 - joint_rounding,
        r = previous_down_height * 0.5 + joint_tolerance * 1.25, // TODO: why 1.25?
        $fn = detail * 2.5);

      cylinder(
        h = up_width * 0.5 + joint_rounding,
        r = joint_bar_size * 0.5 + joint_rounding,
        $fn = detail * 1.5);
    }
    
    sphere(
      r = joint_rounding,
      $fn = detail);
  }
}

module apply_up_cutout(
  up_width, up_height, previous_down_height, joint_bar_size,
  length,
  down_width, down_height, joint_hook_width, next_joint_bar_size,
  previous_rounding, rounding)
{

  difference()
  {
  children();

    up_cutout(
      up_width, up_height, previous_down_height, joint_bar_size,
      previous_rounding, rounding);
  }
}

module down_cutout(
  down_width, down_height, joint_hook_width, next_joint_bar_size,
  down_offset,
  previous_rounding, rounding)
{
  union()
  {
    block_height = down_height;
    
    top_y = -0.5 * joint_rounding;
    bottom_y = -0.5 * next_joint_bar_size;
    
    /*
    skew_amount = (top_y - bottom_y) / block_height;
    
    multmatrix(
      [[1, 0, 0, 0],
       [0, 1, skew_amount, bottom_y - block_height * 0.5 * skew_amount],
       [0, 0, 1, 0],
       [0, 0, 0, 1]])
    {
      translate([-(joint_hook_width * 0.5 + joint_rounding), 0, block_height * 0.5])
      cylinder(h = block_height, r = joint_rounding, $fn = detail);
      
      translate([+(joint_hook_width * 0.5 + joint_rounding), 0, block_height * 0.5])
      cylinder(h = block_height, r = joint_rounding, $fn = detail);

      translate([0.5 * (down_width + joint_hook_width), 0.5 * (down_height + 2), block_height])
      cube([down_width, down_height + 2, block_height], center = true);
      translate([0.5 * (down_width + joint_hook_width + 2 * joint_rounding), 0.5 * (down_height + 2) - joint_rounding, block_height])
      cube([down_width, down_height + 2, block_height], center = true);
      
      translate([-0.5 * (down_width + joint_hook_width), 0.5 * (down_height + 2), block_height])
      cube([down_width, down_height + 2, block_height], center = true);
      translate([-0.5 * (down_width + joint_hook_width + 2 * joint_rounding), 0.5 * (down_height + 2) - joint_rounding, block_height])
      cube([down_width, down_height + 2, block_height], center = true);
    }
    
    multmatrix(
      [[1, 0, 0, 0],
       [0, 1, 0, 0],
       [0, 0, -1, block_height],
       [0, 0, 0, 1]])
    multmatrix(
      [[1, 0, 0, 0],
       [0, 1, skew_amount, bottom_y - block_height * 0.5 * skew_amount],
       [0, 0, 1, 0],
       [0, 0, 0, 1]])
    {
      translate([-(joint_hook_width * 0.5 + joint_rounding), 0, block_height * 0.5])
      cylinder(h = block_height, r = joint_rounding, $fn = detail);
      
      translate([+(joint_hook_width * 0.5 + joint_rounding), 0, block_height * 0.5])
      cylinder(h = block_height, r = joint_rounding, $fn = detail);

      translate([0.5 * (down_width + joint_hook_width), 0.5 * (down_height + 2), block_height])
      cube([down_width, down_height + 2, block_height], center = true);
      translate([0.5 * (down_width + joint_hook_width + 2 * joint_rounding), 0.5 * (down_height + 2) - joint_rounding, block_height])
      cube([down_width, down_height + 2, block_height], center = true);
      
      translate([-0.5 * (down_width + joint_hook_width), 0.5 * (down_height + 2), block_height])
      cube([down_width, down_height + 2, block_height], center = true);
      translate([-0.5 * (down_width + joint_hook_width + 2 * joint_rounding), 0.5 * (down_height + 2) - joint_rounding, block_height])
      cube([down_width, down_height + 2, block_height], center = true);
    }
    */
    
    large_cutout_radius = 0.75 * down_height;

    minkowski()
    {
      difference()
      {
        hull()
        {
          translate([-0.5 * (2 * down_width + 2), large_cutout_radius - next_joint_bar_size * 0.5, down_height * 0.5 + next_joint_bar_size * 0.3])
          rotate([0, 90, 0])
          cylinder(h = 2 * down_width + 2, r = large_cutout_radius + joint_rounding, $fn = detail * 4);

          translate([-0.5 * (2 * down_width + 2), large_cutout_radius - next_joint_bar_size * 0.5, down_height * 0.5 - next_joint_bar_size * 0.3])
          rotate([0, 90, 0])
          cylinder(h = 2 * down_width + 2, r = large_cutout_radius + joint_rounding, $fn = detail * 4);
        }
        
        translate([-1.5 * down_height, down_height + 1, -1.5 * large_cutout_radius])
        cube([3 * down_height, 3 * down_height, 3 * down_height]);
        
        translate([0, 0, large_cutout_radius * 0.5])
        cube([joint_hook_width + joint_rounding, 2 * down_height, 3 * down_height], center = true);
      }
      
      sphere(
        r = joint_rounding,
        $fn = detail);
    }
    
    difference()
    {
      translate([0, 0, large_cutout_radius * 0.5])
      cube([joint_hook_width - joint_rounding * 0.5, 2 * down_height, 3 * down_height], center = true);

      minkowski()
      {
        difference()
        {
          translate([0, 0, large_cutout_radius * 0.5])
          cube([joint_hook_width - 2 * joint_rounding, 2 * down_height, 3 * down_height], center = true);

          translate([0, 0, down_height * 0.5])
          rotate([0, 90, 0])
          cylinder(h = joint_hook_width + 2 * joint_rounding, r = 0.5 * next_joint_bar_size + joint_tolerance, center = true, $fn = detail * 5);
        }
        
        sphere(
          r = joint_rounding,
          $fn = detail - 3);
      }
    }
  }
}

module apply_down_cutout(
  up_width, up_height, previous_down_height, joint_bar_size,
  length,
  down_width, down_height, joint_hook_width, next_joint_bar_size,
  previous_rounding, rounding,
  segment)
{
  down_offset = 0.5 * previous_down_height + up_width + rounding;
  
  difference()
  {
    children();

    translate([0, previous_down_height * 0.5 + length, 0])
    down_cutout(
      down_width, down_height, joint_hook_width, next_joint_bar_size,
      down_offset,
      previous_rounding, rounding);
  }
}

module head_segment(height, rounding)
{
  translate([0, -rounding, 0])
  scale(height * 0.1)
  translate([176, -72.5, 0])
  rotate([0, 0, 90])
  import("Snake Head.stl", convexity = 10, center = true);
}

module segment(
  up_width, up_height, previous_down_height, joint_bar_size,
  length,
  down_width, down_height, joint_hook_width, next_joint_bar_size,
  previous_rounding, rounding,
  segment)
{
  if (segment == number_of_segments)
  {
    apply_up_cutout(
      up_width, up_height, previous_down_height, joint_bar_size,
      length,
      down_width, down_height, joint_hook_width, next_joint_bar_size,
      0, 0)
    {
      head_segment(previous_down_height, rounding);
    }
  }
  else
  {
    translate([0, 0, rounding])
    apply_down_cutout(
      up_width, up_height, previous_down_height, joint_bar_size,
      length,
      down_width, down_height, joint_hook_width, next_joint_bar_size,
      previous_rounding, rounding,
      segment)
    {
      if (segment == 1)
        segment_rounded(
          up_width, up_height, previous_down_height, joint_bar_size,
          length,
          down_width, down_height, joint_hook_width, next_joint_bar_size,
          previous_rounding, rounding);
      else
      {
        apply_up_cutout(
          up_width, up_height, previous_down_height, joint_bar_size,
          length,
          down_width, down_height, joint_hook_width, next_joint_bar_size,
          previous_rounding, rounding)
        {
          segment_rounded(
            up_width, up_height, previous_down_height, joint_bar_size,
            length,
            down_width, down_height, joint_hook_width, next_joint_bar_size,
            previous_rounding, rounding);
        }
      }
    }
  }
}

base_length = 6;
base_up_width = 5;
base_up_height = 6;
base_down_width = 7;
base_down_height = 6;

tail_length = base_length * 1.5;
tail_up_width = base_up_width * 0.75;
tail_up_height = base_up_height * 0.75;

scale_change = 0.05;

function get_factor(segment) = 
  segment <= 1
  ? 1
  : (1 + scale_change) * get_factor(segment - 1);

function get_length_y(segment) =
  (segment == 1 ? tail_length : base_length);

function get_offset_difference_y(segment) =
  get_factor(segment) * (get_length_y(segment) + 0.5) + 0.5 * get_factor(segment - 1) * base_down_height - get_factor(segment + 1);

function get_offset_y(segment) =
  segment <= 1
  ? 0
  : get_offset_y(segment - 1) + get_offset_difference_y(segment - 1);

for (segment = [ 3 : number_of_segments ])
{
  previous_factor = get_factor(segment - 1);
  factor = get_factor(segment);
  next_factor = get_factor(segment + 1);

  up_width = (segment == 1 ? tail_up_width : base_up_width) * factor;
  up_height = (segment == 1 ? tail_up_height : base_up_height) * factor;
  previous_down_height = base_down_height * previous_factor;

  length = get_length_y(segment) * factor;

  down_width = base_down_width * factor;
  down_height = base_down_height * next_factor;
  joint_hook_width = base_joint_hook_width * factor;
  joint_bar_size = base_joint_bar_size * factor;
  next_joint_bar_size = base_joint_bar_size * next_factor;
  
  previous_rounding = previous_factor;
  rounding = factor;

  translate([0, get_offset_y(segment), 0])
  segment(
    up_width, up_height, previous_down_height, joint_bar_size,
    length,
    down_width, down_height, joint_hook_width, next_joint_bar_size,
    previous_rounding, rounding,
    segment);
    
  echo(str("segment ", segment, " ends at ", get_offset_y(segment + 1)));
}
