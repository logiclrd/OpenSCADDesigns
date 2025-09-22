base_plate_height = 3.2;

floor_height_difference = 17.5;

first_floor_elevation = 3;
second_floor_elevation = first_floor_elevation + floor_height_difference;

first_floor_depth = 32.4;
first_floor_width = 67.4;

pillar_depth = 16.2 - 8.5;

second_floor_depth = 56.5;

screw_hole_diameter = 2.693;
screw_hole_depth = 8;
screw_hole_inset = 3.35;

power_adapter_width = 10.5;
power_adapter_inset = 4.75;
power_adapter_height = 5.25;
power_adapter_depth = 20;
power_adapter_outset = 2;

power_adapter_guide_width = power_adapter_width + 2 * pillar_depth;
power_adapter_guide_height = power_adapter_height + first_floor_elevation;

module base_design()
{
  import("Pi_Zero_2_W_2040_Mount.stl", convexity = 4);
}

union()
{
  // Base mount for the Pi 2 Zero W
  base_design();

  // Corner mounts for the second floor, the relay hat.
  translate([0, first_floor_depth - second_floor_depth, floor_height_difference])
  intersection()
  {
    base_design();

    union()
    {
      translate([pillar_depth / 2 - first_floor_width / 2, pillar_depth / 2 - first_floor_depth / 2, 5])
      cube([pillar_depth, pillar_depth, 10], center = true);
      translate([first_floor_width / 2 - pillar_depth / 2, pillar_depth / 2 - first_floor_depth / 2, 5])
      cube([pillar_depth, pillar_depth, 10], center = true);
    }
  }

  // Extended base plate
  difference()
  {
    translate([0, first_floor_depth / 4 - second_floor_depth / 2, -base_plate_height / 2])
    cube([first_floor_width, second_floor_depth - first_floor_depth / 2, base_plate_height], center = true);
    
    translate([0, -first_floor_depth / 4, 0])
    cube([first_floor_width - 2 * pillar_depth, first_floor_depth / 2, base_plate_height * 2.5], center = true);
    
    translate([first_floor_width / 2, (first_floor_depth - second_floor_depth) / 2 - second_floor_depth / 2, 0])
    rotate([0, 0, 45])
    scale([1 / sqrt(2), 1 / sqrt(2), 1])
    cube([pillar_depth * 2, pillar_depth * 2, base_plate_height * 2.5], center = true);

    translate([-first_floor_width / 2, (first_floor_depth - second_floor_depth) / 2 - second_floor_depth / 2, 0])
    rotate([0, 0, 45])
    scale([1 / sqrt(2), 1 / sqrt(2), 1])
    cube([pillar_depth * 2, pillar_depth * 2, base_plate_height * 2.5], center = true);

    for (x = [-1, 1])
      for (y = [-1, 1])
        translate([x * (first_floor_width / 2 - screw_hole_inset - 1), y * (first_floor_depth / 2 - screw_hole_inset - 1), -2])
        cylinder(d = screw_hole_diameter * 2, h = base_plate_height * 3, $fn = 40);
  }

  // Fill in the hex holes on the underside so that there's no bridging.
  for (x = [-1, 1])
    for (y = [-1, 1])
      translate([x * (first_floor_width / 2 - screw_hole_inset - 1), y * (first_floor_depth / 2 - screw_hole_inset - 1), -base_plate_height])
      cylinder(d = screw_hole_diameter * 2, h = 2, $fn = 40);

  // Pillars to the second floor mount points.
  translate([0, first_floor_depth - second_floor_depth, -base_plate_height])
  union()
  {
    scale([1, 1, (base_plate_height + second_floor_elevation) / base_plate_height])
    intersection()
    {
      base_design();
      
      translate([0, pillar_depth / 2 - first_floor_depth / 2, first_floor_elevation / 2])
      cube([first_floor_width, pillar_depth, first_floor_elevation], center = true);
    }
    
    translate([0.6 + pillar_depth / 2 - first_floor_width / 2, 0.6 + pillar_depth / 2 - first_floor_depth / 2, 0])
    cylinder(d = screw_hole_diameter + 1, h = second_floor_elevation + base_plate_height - screw_hole_depth, $fn = 40);
    translate([-0.6 - pillar_depth / 2 + first_floor_width / 2, 0.6 + pillar_depth / 2 - first_floor_depth / 2, 0])
    cylinder(d = screw_hole_diameter + 1, h = second_floor_elevation + base_plate_height - screw_hole_depth, $fn = 40);
  }

  // Power adapter guide slot
  difference()
  {
    translate([first_floor_width / 2 - power_adapter_guide_width / 2, -first_floor_depth / 2 - power_adapter_depth / 2 - power_adapter_outset, 0])
    difference()
    {
      translate([0, 0, power_adapter_guide_height / 2])
      cube([power_adapter_guide_width, power_adapter_depth, power_adapter_guide_height], center = true);
      
      translate([0, 0, power_adapter_height + first_floor_elevation])
      cube([power_adapter_width, power_adapter_depth * 2, power_adapter_height * 2], center = true);
    }

    translate([first_floor_width / 2, (first_floor_depth - second_floor_depth) / 2 - second_floor_depth / 2, 0])
    rotate([0, 0, 45])
    scale([1 / sqrt(2), 1 / sqrt(2), 1])
    cube([pillar_depth * 2, pillar_depth * 2, power_adapter_guide_height * 3], center = true);
  }
}