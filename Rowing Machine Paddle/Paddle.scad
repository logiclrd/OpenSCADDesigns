paddle_width = 80;
paddle_height = 150;
paddle_thickness = 2.8;

corner_radius = 6;

outer_cutout_width = 16.5;
outer_cutout_depth = 7.5;

wheel_width = 24.75;
wheel_depth_outer = 13.3;
wheel_depth_inner = 14.8;

wheel_offset_from_right = 26.75;

spoke_cutout_thickness = 2.75;
spoke_cutout_depth = 15;
spoke_cutout_position_outer = 31.5;
spoke_cutout_position_inner = 34.5;

difference()
{
  intersection()
  {
    // Main body
    cube([paddle_width, paddle_height, paddle_thickness]);

    // Rounded corners
    union()
    {
      for (x = [corner_radius, paddle_width - corner_radius])
        for (y = [corner_radius, paddle_height - corner_radius])
          translate([x, y, -0.5])
          cylinder(paddle_thickness + 1, corner_radius, corner_radius, $fn = 40);
        
      translate([0, corner_radius, -1])
      cube([paddle_width, paddle_height - 2 * corner_radius, paddle_thickness + 2]);
      translate([corner_radius, 0, -1])
      cube([paddle_width - 2 * corner_radius, paddle_height, paddle_thickness + 2]);
    }
  }
  // Outer cutout
  translate([paddle_width - outer_cutout_width * 0.5 - wheel_offset_from_right, paddle_height - outer_cutout_depth - 0.01, -0.5])
  cube([outer_cutout_width, outer_cutout_depth + 1, paddle_height + 1]);
  
  // a = h + q
  // b = i + q
  //
  // a = sqrt(m^2 + b^2)
  //   = sqrt(m^2 + i^2 + 2iq + q^2)
  //   = sqrt(C + 2iq + q^2)
  // C = m^2 + i^2
  // q^2 + 2iq + C = a^2
  // q = a - h
  // (a - h)^2 + 2i(a - h) + C = a^2
  // a^2 - 2ah + h^2 + 2ia - 2ih + C = a^2
  // -2ah + h^2 + 2ia - 2ih + C = 0
  // -2ah + 2ia = -h^2 + 2ih - C
  // a(2i - 2h) = -h^2 + 2ih - C
  // a = (-h^2 + 2ih - (m^2 + i^2)) / (2i - 2h)
  
  wheel_rounding_radius = (-wheel_depth_inner * wheel_depth_inner + 2 * wheel_depth_outer * wheel_depth_inner
    - (0.25 * wheel_width * wheel_width + wheel_depth_outer * wheel_depth_outer))
    / (2 * wheel_depth_outer - 2 * wheel_depth_inner);

  wheel_inner_y = paddle_height - outer_cutout_depth - wheel_depth_inner;

  wheel_circle_y = wheel_inner_y + wheel_rounding_radius;
  
  intersection()
  {
    // Wheel inner edge rounding
    translate([paddle_width - wheel_offset_from_right, wheel_circle_y, -0.5 * paddle_thickness])
    cylinder(2 * paddle_thickness, wheel_rounding_radius, wheel_rounding_radius, $fn = 40);
    
    // Clamp to size of wheel
    translate([paddle_width - wheel_offset_from_right - 0.5 * wheel_width, wheel_inner_y, -paddle_thickness])
    cube([wheel_width, wheel_depth_inner, 3 * paddle_thickness]);
  }
  
  // Spoke cutout
  // In spoke_cutout_depth y units, we need x to shift by (spoke_cutout_position_inner - spoke_cutout_position_outer).
  slant = (spoke_cutout_position_inner - spoke_cutout_position_outer) / spoke_cutout_depth;
  
  translate([spoke_cutout_position_outer, -0.01, -1.5 * paddle_thickness])
  multmatrix(
    [[1, slant, 0, 0],
     [0, 1, 0, 0],
     [0, 0, 1, 0],
     [0, 0, 0, 1]])
  cube([spoke_cutout_thickness, spoke_cutout_depth + 0.01, 4 * paddle_thickness]);
}
