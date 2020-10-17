detail = $preview ? 7 : 20;

joint_tolerance = 0.3;
joint_rounding = 0.5;
joint_spacing = 0.5;
joint_hook_width = 2;

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
  up_width, up_height, up_inner_diameter, up_outer_diameter,
  length,
  down_width, down_height, down_inner_diameter)
{
  up_edge_left = [-0.5 * up_width, 0, 0.5 * up_height];
  up_edge_right = [0.5 * up_width, 0, 0.5 * up_height];
  
  up_shoulder_left = [-0.6 * up_width, up_inner_diameter, 0.55 * up_height];
  up_shoulder_right = [0.6 * up_width, up_inner_diameter, 0.55 * up_height];
  
  up_opening_top_left = [-0.45 * up_width, 0.5 * up_inner_diameter, 0.85 * up_height];
  up_opening_top_right = [0.45 * up_width, 0.5 * up_inner_diameter, 0.85 * up_height];
  
  up_top_left = [-0.4 * up_width, 0.5 * up_outer_diameter, up_height];
  up_top_right = [0.4 * up_width, 0.5 * up_outer_diameter, up_height];
  
  up_bottom_left = [-0.4 * up_width, 0.5 * up_outer_diameter, 0];
  up_bottom_right = [0.4 * up_width, 0.5 * up_outer_diameter, 0];
  
  down_offset = 0.5 * up_outer_diameter + length;
  
  back_circle_tangent_point = find_circle_tangent_from_point(
    -down_offset, down_height * 0.5, down_height * 0.5,
    -0.5 * up_outer_diameter, up_height);
  
  back_slope = (up_height - back_circle_tangent_point[1]) / (back_circle_tangent_point[0] + 0.5 * up_outer_diameter);
  
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
  up_width, up_height, up_inner_diameter, up_outer_diameter,
  length,
  down_width, down_height, down_inner_diameter,
  rounding)
{
  down_offset = 0.5 * up_outer_diameter + length;

  minkowski()
  {
    intersection()
    {
      segment_hull(
        up_width, up_height, up_inner_diameter, up_outer_diameter,
        length,
        down_width, down_height, down_inner_diameter);

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
          -0.5 * up_outer_diameter, up_height);
        
        cube_size = down_height + down_offset + down_height;
  
        translate([-0.5 * cube_size, -back_circle_tangent_point[0] - cube_size, 0])
        cube(size = cube_size);
      }
    }

    sphere(r = rounding, $fn = detail);
  }
}

module segment_with_up_cutout(
  up_width, up_height, up_inner_diameter, up_outer_diameter,
  length,
  down_width, down_height, down_inner_diameter,
  rounding)
{
  difference()
  {
    segment_rounded(
      up_width, up_height, up_inner_diameter, up_outer_diameter,
      length,
      down_width, down_height, down_inner_diameter,
      rounding);
    
    translate([0, up_inner_diameter - rounding, 0])
    minkowski()
    {
      translate([-0.25 * up_width + 0.5 * joint_rounding, -rounding, 0.5 * up_height])
      rotate([0, 90, 0])
      difference()
      {
        cylinder(
          h = up_width * 0.5 - joint_rounding,
          r = up_outer_diameter * 0.5 - joint_rounding,
          $fn = detail * 1.5);

        cylinder(
          h = up_width * 0.5 + joint_rounding,
          r = up_inner_diameter * 0.5 + joint_rounding,
          $fn = detail * 1.5);
      }
      
      sphere(
        r = joint_rounding,
        $fn = detail);
    }
  }
}

module down_cutout(
  down_width, down_height, down_inner_diameter,
  down_offset,
  rounding)
{
  union()
  {
    block_height = down_height;
    
    top_y = -0.5*joint_rounding;
    bottom_y = -0.5 * down_inner_diameter;
    
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
          translate([-0.5 * (2 * down_width + 2), large_cutout_radius - down_inner_diameter * 0.5, down_height * 0.5 + down_inner_diameter * 0.3])
          rotate([0, 90, 0])
          cylinder(h = 2 * down_width + 2, r = large_cutout_radius, $fn = detail * 4);

          translate([-0.5 * (2 * down_width + 2), large_cutout_radius - down_inner_diameter * 0.5, down_height * 0.5 - down_inner_diameter * 0.3])
          rotate([0, 90, 0])
          cylinder(h = 2 * down_width + 2, r = large_cutout_radius, $fn = detail * 4);
        }
        
        translate([-1.5 * large_cutout_radius, down_inner_diameter + joint_rounding + 1, -1.5 * large_cutout_radius])
        cube([large_cutout_radius * 3, 2 * down_height, large_cutout_radius * 3]);
        
        translate([0, 0, large_cutout_radius * 0.5])
        cube([joint_hook_width + joint_rounding, large_cutout_radius * 2, 2 * down_height], center = true);
      }
      
      sphere(
        r = joint_rounding,
        $fn = detail);
    }
    
    translate([0, 0, down_height * 0.5])
    rotate([0, 90, 0])
    cylinder(h = joint_hook_width + 2 * joint_rounding, r = down_inner_diameter * 0.5, center = true, $fn = detail * 5);
  }
}

module segment_with_down_cutout(
  up_width, up_height, up_inner_diameter, up_outer_diameter,
  length,
  down_width, down_height, down_inner_diameter,
  rounding)
{
  down_offset = 0.5 * up_outer_diameter + up_width + rounding;
  
  difference()
  {
    segment_with_up_cutout(
      up_width, up_height, up_inner_diameter, up_outer_diameter,
      length,
      down_width, down_height, down_inner_diameter,
      rounding);

    translate([0, up_outer_diameter * 0.5 + length, 0])
    down_cutout(
      down_width, down_height, down_inner_diameter,
      down_offset,
      rounding);
  }
}

function get_factor(segment) = 
  1 + segment * 0.15;

function get_length_y(segment) =
  get_factor(segment) * 13;

function get_offset_y(segment) =
  segment <= 1
  ? 0
  : get_offset_y(segment - 1) + get_length_y(segment - 1);

for (segment = [ 1 : 10 ])
{
  factor = get_factor(segment);
  next_factor = get_factor(segment + 1);

  up_width = 7 * factor;
  up_height = 7 * factor;
  up_inner_diameter = 2 * factor;
  up_outer_diameter = 10 * factor;

  length = 8 * factor;

  down_width = 10 * factor;
  down_height = 7 * next_factor;
  down_inner_diameter = 3.5 * factor;

  rounding = factor;

  translate([0, get_offset_y(segment), 0])
  segment_with_down_cutout(
    up_width, up_height, up_inner_diameter, up_outer_diameter,
    length,
    down_width, down_height, down_inner_diameter,
    rounding);
    
  echo(str("segment ", segment, " ends at ", get_offset_y(segment + 1)));
}

