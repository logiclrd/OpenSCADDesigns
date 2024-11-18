circle_diameter_inches = 26.875;
outer_gap_inches = 1.81;
inner_gap_inches = 1.33;

additional_width_angle = 5;

block_height_inches = 1.2;

block_thickness_mm = 3;
crosshair_thickness_mm = 0.5;

guide_hole_size_mm = 2.2;

window_width_degrees = 3;
window_height_inches = 0.3;

notch_width_mm = 1.5;

spike_width_mm = 2;
spike_height_mm = 2;
spike_inset_mm = 2.5;

circle_radius_inches = circle_diameter_inches * 0.5;
circle_circumference_inches = circle_diameter_inches * PI;

block_height_mm = block_height_inches * 25.4;
window_height_mm = window_height_inches * 25.4;
circle_radius_mm = circle_radius_inches * 25.4;
circle_circumference_mm = circle_circumference_inches * 25.4;

outer_gap_radians = outer_gap_inches / circle_circumference_inches * 2 * PI;
inner_gap_radians = inner_gap_inches / circle_circumference_inches * 2 * PI;

outer_gap_degrees = outer_gap_radians * 180 / PI;
inner_gap_degrees = inner_gap_radians * 180 / PI;

block_width_degrees = inner_gap_degrees + 2 * outer_gap_degrees + additional_width_angle;

module block(from_angle, to_angle, block_thickness_mm, block_height_mm, segments = 20)
{
  for (segment = [0 : segments - 1])
  {
    t1 = segment / segments;
    t2 = (segment + 1) / segments;

    a1 = (1 - t1) * from_angle + t1 * to_angle;
    a2 = (1 - t2) * from_angle + t2 * to_angle;

    x1 = sin(a1) * (circle_radius_mm - block_height_mm / 2);
    y1 = -cos(a1) * (circle_radius_mm - block_height_mm / 2);

    x2 = sin(a2) * (circle_radius_mm - block_height_mm / 2);
    y2 = -cos(a2) * (circle_radius_mm - block_height_mm / 2);

    x3 = sin(a2) * (circle_radius_mm + block_height_mm / 2);
    y3 = -cos(a2) * (circle_radius_mm + block_height_mm / 2);

    x4 = sin(a1) * (circle_radius_mm + block_height_mm / 2);
    y4 = -cos(a1) * (circle_radius_mm + block_height_mm / 2);
    
    linear_extrude(block_thickness_mm, slices = 1)
    translate([0, circle_radius_mm, 0])
    polygon(
      [
        [x1, y1],
        [x2, y2],
        [x3, y3],
        [x4, y4],
      ]);
  }
}

module guide(angle)
{
  translate([0, circle_radius_mm, 0])
  rotate([0, 0, angle])
  translate([0, -circle_radius_mm, 0])
  cylinder(10, d = guide_hole_size_mm, center = true, $fn = 32);
}

module window()
{
  crosshair_thickness_degrees = 360 * crosshair_thickness_mm / circle_circumference_mm;
  difference()
  {
    translate([0, 0, -5])
    block(-window_width_degrees * 0.5, window_width_degrees * 0.5, 10, window_height_mm);
    
    translate([0, 0, -4])
    block(-window_width_degrees * 0.5 - 0.1, window_width_degrees * 0.5 + 1, 8, crosshair_thickness_mm);
    translate([0, 0, -4])
    block(-crosshair_thickness_degrees * 0.5, crosshair_thickness_degrees * 0.5, 8, window_height_mm + 1, segments = 1);
  }
}

module base_block()
{
  block(-block_width_degrees * 0.5, +block_width_degrees * 0.5, block_thickness_mm, block_height_mm);
}

module guides()
{
  guide(-outer_gap_degrees - inner_gap_degrees * 0.5);
  guide(-inner_gap_degrees * 0.5);
  guide(inner_gap_degrees * 0.5);
  guide(outer_gap_degrees + inner_gap_degrees * 0.5);
}

module notch(angle_offset, radius_offset)
{
  radius = circle_radius_mm + radius_offset;
  angle = angle_offset;
  
  x = sin(angle) * radius;
  y = -cos(angle)* radius;
  
  translate([x, y + circle_radius_mm, 0])
  rotate([0, 0, 45])
  cube([notch_width_mm, notch_width_mm, 10], center = true);
}

module notches()
{
  for (x = [-1, 1])
    notch(x * block_width_degrees / 2, 0);
  
  for (y = [-1, 1])
    notch(0, y * block_height_mm / 2);
}

union()
{
  difference()
  {
    base_block();

    guides();

    window();

    notches();
  }
  
  for (side = [-1, 1])
    for (edge = [-1, 1])
    {
      radius = circle_radius_mm + (block_height_mm * 0.5 - spike_inset_mm) * edge;
      
      circumference = radius * 2 * PI;
      
      spike_inset_angle = 360 * spike_inset_mm / circumference;
      
      angle = (block_width_degrees * 0.5 - spike_inset_angle) * side;
      
      x = sin(angle) * radius;
      y = circle_radius_mm - cos(angle) * radius;

      color("red")
      translate([x, y, block_thickness_mm])
      cylinder(spike_height_mm, d1 = spike_width_mm, d2 = 0, $fn = 32);
    }
}
