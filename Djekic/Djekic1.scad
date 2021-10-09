$fn = 1000;

function rounded_triangle_height(side_length, corner_radius)
  = let (radius = side_length / sqrt(3))
    let (unrounded_height = radius + radius * sin(30))
    let (corner_circle_centre = side_length / sqrt(3) - corner_radius / cos(60))
    unrounded_height - radius + corner_circle_centre + corner_radius;

module rounded_triangle(side_length, corner_radius, depth)
{
  intersection()
  {
    cylinder(depth, side_length / sqrt(3), side_length / sqrt(3), $fn = 3);
    
    union()
    {
      corner_circle_centre = side_length / sqrt(3) - corner_radius / cos(60);
      
      translate([corner_circle_centre, 0, -1])
      cylinder(depth + 2, corner_radius, corner_radius);

      translate([-side_length + corner_circle_centre + sin(30) * corner_radius, -0.5 * side_length, -0.5])
      cube([side_length, side_length, depth + 1]);
    }
    
    rotate([0, 0, 120])
    union()
    {
      corner_circle_centre = side_length / sqrt(3) - corner_radius / cos(60);
      
      translate([corner_circle_centre, 0, -1])
      cylinder(depth + 2, corner_radius, corner_radius);

      translate([-side_length + corner_circle_centre + sin(30) * corner_radius, -0.5 * side_length, -0.5])
      cube([side_length, side_length, depth + 1]);
    }
    
    rotate([0, 0, 240])
    union()
    {
      corner_circle_centre = side_length / sqrt(3) - corner_radius / cos(60);
      
      translate([corner_circle_centre, 0, -1])
      cylinder(depth + 2, corner_radius, corner_radius);

      translate([-side_length + corner_circle_centre + sin(30) * corner_radius, -0.5 * side_length, -0.5])
      cube([side_length, side_length, depth + 1]);
    }
  }
}

module brick(brick_size, brick_rounding_size)
{
  translate([0, 0, brick_size[2] * 0.5])
  minkowski()
  {
    cube(
      [brick_size[0] - brick_rounding_size[0],
       brick_size[1] - brick_rounding_size[1],
       brick_size[2] - brick_rounding_size[2]], center = true);

    scale(brick_rounding_size) sphere(0.5, $fn = 50);
  }
}

module negative_space(
  side_length, corner_radius, depth, floor_thickness,
  hole_radius, hole_upper_radius, hole_lower_thickness, hole_offset_y,
  tray_width, tray_height, tray_lower_thickness, tray_notch_width, tray_notch_depth)
{
  union()
  {
    radius = side_length / sqrt(3);
    
    rounded_triangle_y = 0.125 * rounded_triangle_height(side_length, corner_radius);
    
    translate([0, rounded_triangle_y, 0])
    rotate([0, 0, -90])
    rounded_triangle(side_length, corner_radius, depth);
    
    translate([0, hole_offset_y, -floor_thickness - 1])
    cylinder(floor_thickness + 2, hole_radius, hole_radius);
    
    translate([0, hole_offset_y, -floor_thickness + hole_lower_thickness])
    cylinder(floor_thickness, hole_upper_radius, hole_upper_radius);

    triangle_bottom_y = rounded_triangle_y - radius;
    
    tray_y = triangle_bottom_y + tray_width * cos(30);
    
    translate([-0.5 * tray_width, tray_y, -tray_lower_thickness])
    {
      cube([tray_width, tray_height, floor_thickness + 2]);

      rotate([0, 0, 120])
      translate([-tray_notch_width, -0.75 * tray_width, 0])
      cube([tray_notch_width, tray_notch_depth + 0.75 * tray_width, depth]);

      multmatrix(
        [[-1, 0, 0, tray_width],
         [0, 1, 0, 0],
         [0, 0, 1, 0],
         [0, 0, 0, 1]])
      {
        rotate([0, 0, 120])
        translate([-tray_notch_width, -0.75 * tray_width, 0])
        cube([tray_notch_width, tray_notch_depth + 0.75 * tray_width, depth]);
      }
    }
  }
}

module slot(
  brick_size, brick_rounding_size,
  rounded_triangle_side_length, rounded_triangle_corner_radius, floor_thickness,
  hole_radius, hole_upper_radius, hole_lower_thickness, hole_offset_y,
  tray_width, tray_height, tray_lower_thickness, tray_notch_width, tray_notch_depth)
{
  difference()
  {
    brick(brick_size, brick_rounding_size);
    
    translate([0, 0, floor_thickness])
    negative_space(
      rounded_triangle_side_length, rounded_triangle_corner_radius, brick_size[2] * 2, floor_thickness,
      hole_radius, hole_upper_radius, hole_lower_thickness, hole_offset_y,
      tray_width, tray_height, tray_lower_thickness, tray_notch_width, tray_notch_depth);
  }
}

for (x = [0, 23])
{
  translate([x, 0, 0])
  slot(
    brick_size = [24, 20, 8],
    brick_rounding_size = [3, 2.5, 2],
    rounded_triangle_side_length = 20,
    rounded_triangle_corner_radius = 3,
    floor_thickness = 4,
    hole_radius = 0.75,
    hole_upper_radius = 1.5,
    hole_lower_thickness = 1,
    hole_offset_y = 4,
    tray_width = 8,
    tray_height = 4,
    tray_lower_thickness = 3,
    tray_notch_width = 1,
    tray_notch_depth = 1.5);
}