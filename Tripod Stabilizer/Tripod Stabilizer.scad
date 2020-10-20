$fn = 100;

arm_width_mm = 32;
corner_radius_mm = 10;
radius_inch = 12 / sqrt(3);
thickness_mm = 4;
slot_width_mm = 13;
slot_start = 0.7;
slot_straight = 0.8;
slot_skew = -0.5;
joint_rounding_mm = 20;

radius_mm = radius_inch * 25.4;

module outer_corner()
{
  difference()
  {
    translate([-(corner_radius_mm + 1) / 2, (corner_radius_mm + 1) / 2])
    cube([corner_radius_mm + 1, corner_radius_mm + 1, thickness_mm + 2], center = true);
    
    cylinder(thickness_mm + 1, corner_radius_mm, corner_radius_mm, center = true);
  }
}

module slot()
{
  multmatrix(
    [ [ 1, 0,         0, 0 ],
      [ 0, 1, slot_skew, 0 ],
      [ 0, 0,         1, 0 ],
      [ 0, 0,         0, 1 ] ]
  )
  union()
  {
    hull()
    {
      translate([arm_width_mm * 0.5 + slot_width_mm * 0.5, radius_mm * slot_start, 0])
      cylinder(thickness_mm + 1, slot_width_mm * 0.5, slot_width_mm * 0.5, center = true);

      translate([0, radius_mm * slot_straight, 0])
      cylinder(thickness_mm + 1, slot_width_mm * 0.5, slot_width_mm * 0.5, center = true);
    }
    hull()
    {
      translate([0, radius_mm * slot_straight, 0])
      cylinder(thickness_mm + 1, slot_width_mm * 0.5, slot_width_mm * 0.5, center = true);

      translate([0, radius_mm - arm_width_mm * 0.5, 0])
      cylinder(thickness_mm + 1, slot_width_mm * 0.5, slot_width_mm * 0.5, center = true);
    }
  }
}

module arm()
{
  difference()
  {
    translate([0, radius_mm / 2, 0]) cube([arm_width_mm, radius_inch * 25.4, thickness_mm], center = true);

    translate([-0.5 * arm_width_mm + corner_radius_mm, radius_mm - corner_radius_mm, 0])
    outer_corner();

    scale([-1, 1, 1])
    translate([-0.5 * arm_width_mm + corner_radius_mm, radius_mm - corner_radius_mm, 0])
    outer_corner();

    slot();
  }
}

joint_rounding_edge_length_mm = 2 * joint_rounding_mm + arm_width_mm;
joint_rounding_radius_mm = joint_rounding_edge_length_mm / sqrt(3);

union()
{
  rotate([0, 0, 0]) arm();
  rotate([0, 0, 120]) arm();
  rotate([0, 0, 240]) arm();

  difference()
  {
    rotate([0, 0, 30])
    cylinder(thickness_mm, joint_rounding_radius_mm, joint_rounding_radius_mm, $fn = 3, center = true);
    
    for (position = [0 : 2])
      rotate([0, 0, 30 + position * 120])
      translate([joint_rounding_radius_mm, 0, 0])
      cylinder(thickness_mm + 50, joint_rounding_mm, joint_rounding_mm, center = true);
  }
}
