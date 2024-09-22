// Origin: Northwest corner, aligned with west edge of house and south edge of sidewalk
// Positive X is west, width
// Positive Y is south, depth
//
// Units: feet
//
// Features:
// * Axe throwing
// * Slide
// * Swings
// * Zipline

show_new_space = true;
remove_dead_apple_tree = true;

house_porch_x = 0;
house_porch_y = 118;

house_porch_width = -50;
house_porch_depth = 205;

dining_room_end_x = 15;
dining_room_start_y = house_porch_y + 205;
dining_room_and_kitchen_depth = 300; // Not yet measured

front_trees =
  [
    // x, y, height, diameter
    [91, 108, 300, 200], // Pear tree
    [91 + 30, 98, 150, 200], // Bush
    [91 + 72, 73, 170, 250], // Crab apple tree
    [91 + 72 + 129, 66, 100, 10], // Dead crab apple tree
    [91 + 72 + 129 + 71, 85, 120, 230], // Bush
    [91 + 72 + 129 + 123, 62, 250, 200], // Tree
    [91 + 72 + 129 + 123 + 54, 54, 120, 210], // Bush
    [91 + 72 + 129 + 123 + 54 + 48, 39, 500, 400] // Big tree
  ];

old_play_structure_end_x = 302;
old_play_structure_width = 39; // Forgot to measure, assuming square
old_play_structure_x = old_play_structure_end_x - old_play_structure_width;
old_play_structure_y = 260;
old_play_structure_depth = 39;
old_play_structure_end_y = old_play_structure_y + 136;

shed_x = old_play_structure_x + 196;
shed_y = 157;
shed_width = 100; // not measured, not needed
shed_depth = 172;

dead_apple_tree_x = dining_room_end_x + 244;
dead_apple_tree_y = old_play_structure_y + 309;

usable_yard_start_x = 108;
usable_yard_start_y = 154;
usable_yard_end_x_by_shed = old_play_structure_end_x + 112;
usable_yard_end_x_past_shed = shed_x + 85;
usable_yard_depth = dead_apple_tree_y + 75;

module tree(specs, alive = true)
{
  color("#806000")
  translate([specs[0], specs[1], 0])
  cylinder(specs[2] * 0.5, d1 = 0, d2 = specs[3] * 0.5);
  color(alive ? "green" : "#806000")
  translate([specs[0], specs[1], specs[2] * 0.5])
  cylinder(specs[2] * 0.5, d1 = specs[3] * 0.5, d2 = specs[3]);
}

module space()
{
  color("green")
  translate([0, 0, -10])
  union()
  {
    translate([usable_yard_start_x, usable_yard_start_y, 0])
    cube([usable_yard_end_x_by_shed - usable_yard_start_x, usable_yard_depth, 10]);

    translate([usable_yard_start_x, usable_yard_start_y + shed_depth, 0])
    cube([usable_yard_end_x_past_shed - usable_yard_start_x, usable_yard_depth - shed_depth, 10]);
  }

  color("#608060")
  translate([0, 0, -11])
  cube([usable_yard_end_x_past_shed + 50, usable_yard_depth + usable_yard_start_y + 50, 10]);

  for (tree_specs = front_trees)
    tree(tree_specs);

  if (!remove_dead_apple_tree || !show_new_space)
    tree([dead_apple_tree_x, dead_apple_tree_y, 120, 96], false);

  color("#CCC")
  translate([house_porch_x + house_porch_width, house_porch_y, 0])
  cube([-house_porch_width, house_porch_depth, 150]);

  translate([dining_room_end_x - 200, dining_room_start_y, 0])
  cube([200, dining_room_and_kitchen_depth, 150]);

  color("red")
  translate([shed_x, shed_y, 0])
  cube([shed_width, shed_depth, 100]);

  color("black")
  translate([shed_x + shed_width * 0.5, shed_y, shed_width - 10])
  scale([1, 1, 0.7])
  intersection()
  {
    rotate([0, 45, 0])
    translate([shed_width * -0.5, 1, shed_width * -0.5])
    cube([shed_width, shed_depth - 2, shed_width]);

    translate([-100, 1, 0])
    cube([200, 200, 100]);
  }
}

module old_play_structure()
{
  color("#907000")
  {
    translate([old_play_structure_x, old_play_structure_y, 0])
    cube([old_play_structure_width, old_play_structure_depth, 100]);

    translate([old_play_structure_x + old_play_structure_width * 0.5, old_play_structure_y, 80])
    cube([5, old_play_structure_end_y - old_play_structure_y, 5]);

    translate([old_play_structure_x + old_play_structure_width * 0.5, old_play_structure_end_y, 80])
    rotate([0, 20, 0])
    translate([0, 0, -40])
    cube([5, 5, 80], center = true);

    translate([old_play_structure_x + old_play_structure_width * 0.5, old_play_structure_end_y, 80])
    rotate([0, -20, 0])
    translate([0, 0, -40])
    cube([5, 5, 80], center = true);

    translate([old_play_structure_x + old_play_structure_width, old_play_structure_y + (old_play_structure_depth - 24) / 2, 60])
    cube([60, 24, 3]);
    translate([old_play_structure_x + old_play_structure_width + 60, old_play_structure_y + (old_play_structure_depth - 24) / 2, 0])
    cube([3, 24, 60]);

    translate([old_play_structure_x, old_play_structure_y + old_play_structure_depth - 12, 48])
    rotate([0, 45, 0])
    translate([0, 0, -40])
    cube([5, 24, 80], center = true);
  }
}

new_play_structure_x = 260;
new_play_structure_y = 260;

lumber_2x4_width = 3.5;
lumber_2x4_depth = 1.5;

lumber_2x6_width = 5.5;
lumber_2x6_depth = 1.5;

lumber_4x4_width = 3.5;
lumber_4x4_depth = 3.5;

lumber_osb_width = 48;
lumber_osb_height = 96;
lumber_osb_thickness = 3/8;

climbing_wall_panels = 6;
climbing_wall_width = climbing_wall_panels * lumber_2x6_width;
climbing_wall_height = 8 * 12;
climbing_wall_crossbeam_count = 4;

climbing_wall_angle_degrees = 8;

climbing_wall_horizontal_offset = sin(climbing_wall_angle_degrees) * climbing_wall_height;

hallway_y = 48;
hallway_panels = 8;
hallway_width = hallway_panels * lumber_2x6_width;
hallway_length = 1.5 * 96;
hallway_height = 6.5 * 12;
hallway_horizontal_offset = climbing_wall_horizontal_offset * hallway_y / climbing_wall_height;
hallway_crossbeam_count = 4;

outer_platform_panels = 6;
outer_platform_width = outer_platform_panels * lumber_2x6_width;
outer_platform_length = 16 * 12;
outer_platform_crossbeam_count = 5;

landing_width = 36;

roof_angle = 8;
roof_panels = 4;
roof_crossbeams = 4;

slide_x = -outer_platform_width;
slide_y = -landing_width;

zipline_length = 40 * 12; // https://www.amazon.ca/Slackers-Falcon-Flyer-Zipline-Backyard/dp/B01HOTY0LO/ref=sr_1_20
zipline_angle = 0;
zipline_drop = 20; // max reasonable drop per manual is 24 inches over 50 feet

// If zipline goes to tree, how far is tree?
// Will need platform at tree to step off onto?

module pillar(length = 96)
{
  cube([lumber_4x4_width, lumber_4x4_depth, length]);
}

module wall_sheet(height = lumber_osb_height)
{
  cube([lumber_osb_width - 0.1, lumber_osb_thickness, height]);
}

module climbing_wall_plank()
{
  translate([lumber_2x6_width * 0.5, lumber_2x6_depth * 0.5, 48])
  cube([lumber_2x6_width - 0.1, lumber_2x6_depth, climbing_wall_height], center = true);
}

module climbing_wall_crossbeam()
{
  translate([0, lumber_2x6_depth, 0])
  cube([climbing_wall_width, lumber_2x6_depth, lumber_2x6_width]);
}

module climbing_wall()
{
  translate([0, -0.6, 0])
  rotate([climbing_wall_angle_degrees, 0, 0])
  {
    for (plank = [0 : climbing_wall_panels - 1])
      translate([plank * lumber_2x6_width, 0, 0])
      climbing_wall_plank();

    for (crossbeam = [0 : climbing_wall_crossbeam_count - 1])
      translate([0, 0, crossbeam * (climbing_wall_height - lumber_2x6_width) / (climbing_wall_crossbeam_count - 1)])
      climbing_wall_crossbeam();
  }
}

module hallway_plank(length = 96)
{
  translate([lumber_2x6_width * 0.5, 48 + lumber_2x6_depth * 0.5 - 0.5 * ((96 - length) - 0.1), lumber_2x6_depth * 0.5])
  cube([lumber_2x6_width - 0.1, length - 0.1, lumber_2x6_depth], center = true);
}

crossbeam_truss_angle = 25;

module hallway()
{
  translate([0, lumber_2x6_depth - hallway_horizontal_offset - 0.8, hallway_y])
  for (plank = [0: hallway_panels - 1])
    translate([plank * lumber_2x6_width, -2 * lumber_osb_thickness, 0])
    hallway_plank(hallway_length);

  crossbeam_spacing = (hallway_length - lumber_2x6_width) / (hallway_crossbeam_count - 1);
  crossbeam_height = crossbeam_spacing * sin(crossbeam_truss_angle) / cos(crossbeam_truss_angle);

  for (crossbeam = [0 : hallway_crossbeam_count - 1])
  {
    translate([2 * lumber_osb_thickness + hallway_width + 0.05, 0.1 + lumber_2x6_depth - hallway_horizontal_offset - 0.1 - 2 * lumber_osb_thickness + crossbeam * (hallway_length - lumber_2x6_width) / (hallway_crossbeam_count - 1), hallway_y - lumber_2x6_depth])
    rotate([0, 0, 90])
    hallway_plank(hallway_width);

    translate([-lumber_osb_thickness + lumber_osb_thickness, lumber_2x6_depth - hallway_horizontal_offset + (lumber_2x6_width - lumber_4x4_depth) * 0.5 - 0.05 - 2 * lumber_osb_thickness + crossbeam * crossbeam_spacing, 0])
    pillar(hallway_y - lumber_2x6_depth);
    translate([-lumber_osb_thickness + lumber_osb_thickness + hallway_width - lumber_4x4_width, lumber_2x6_depth - hallway_horizontal_offset + (lumber_2x6_width - lumber_4x4_depth) * 0.5 - 0.05 - 2 * lumber_osb_thickness + crossbeam * crossbeam_spacing, 0])
    pillar(hallway_y - lumber_2x6_depth);

    if (crossbeam > 0)
    {
      translate(
        [
          -lumber_osb_thickness + lumber_osb_thickness + 0.5 * lumber_2x4_depth + lumber_4x4_width,
          lumber_2x6_depth - hallway_horizontal_offset + (lumber_2x6_width - lumber_4x4_depth) * 0.5 - 0.05 + 0.5 * lumber_4x4_depth - 0.5 * crossbeam_spacing - 2 * lumber_osb_thickness + crossbeam * crossbeam_spacing,
          hallway_y + hallway_height - lumber_osb_height - 0.5 * crossbeam_height - 2
        ])
      rotate([crossbeam_truss_angle, 0, 0])
      cube([lumber_2x4_depth, crossbeam_spacing / cos(crossbeam_truss_angle) + 2, lumber_2x4_width], center = true);

      translate(
        [
          -lumber_osb_thickness + lumber_osb_thickness + hallway_width - 0.5 * lumber_2x4_depth - lumber_4x4_width,
          lumber_2x6_depth - hallway_horizontal_offset + (lumber_2x6_width - lumber_4x4_depth) * 0.5 - 0.05 + 0.5 * lumber_4x4_depth - 0.5 * crossbeam_spacing - 2 * lumber_osb_thickness + crossbeam * crossbeam_spacing,
          hallway_y + hallway_height - lumber_osb_height - 0.5 * crossbeam_height - 2
        ])
      rotate([-crossbeam_truss_angle, 0, 0])
      cube([lumber_2x4_depth, crossbeam_spacing / cos(crossbeam_truss_angle) + 2, lumber_2x4_width], center = true);

      translate(
        [
          -lumber_osb_thickness + lumber_osb_thickness + hallway_width + 0.5 * lumber_2x4_depth,
          lumber_2x6_depth - hallway_horizontal_offset + (lumber_2x6_width - lumber_4x4_depth) * 0.5 - 0.05 + 0.5 * lumber_4x4_depth - 0.5 * crossbeam_spacing - 2 * lumber_osb_thickness + crossbeam * crossbeam_spacing,
          hallway_y + hallway_height - lumber_osb_height - 0.5 * crossbeam_height - 2
        ])
      rotate([crossbeam_truss_angle, 0, 0])
      cube([lumber_2x4_depth, crossbeam_spacing / cos(crossbeam_truss_angle) + 2, lumber_2x4_width], center = true);
    }
  }

  tiebeam_spacing = hallway_width;
  tiebeam_angle = atan2(crossbeam_height, tiebeam_spacing);

  translate([hallway_width / 2, hallway_length - hallway_horizontal_offset + lumber_osb_thickness + 0.1, hallway_y + hallway_height - lumber_osb_height - 0.5 * crossbeam_height - 2])
  rotate([0, tiebeam_angle, 0])
  cube([tiebeam_spacing / cos(tiebeam_angle), lumber_2x4_depth, lumber_2x4_width], center = true);

  translate([hallway_width / 2, hallway_length - hallway_horizontal_offset + lumber_osb_thickness - lumber_4x4_depth - lumber_2x6_depth, hallway_y + hallway_height - lumber_osb_height - 0.5 * crossbeam_height - 2])
  rotate([0, -tiebeam_angle, 0])
  cube([tiebeam_spacing / cos(tiebeam_angle), lumber_2x4_depth, lumber_2x4_width], center = true);

  // Wall facing house
  translate([0, lumber_2x6_depth - hallway_horizontal_offset - 0.8, hallway_y + hallway_height - lumber_osb_height])
  rotate([0, 0, 90])
  wall_sheet();

  translate([0, lumber_2x6_depth - hallway_horizontal_offset - 0.8 + lumber_osb_width, hallway_y + hallway_height - lumber_osb_height])
  rotate([0, 0, 90])
  wall_sheet();

  translate([0, lumber_2x6_depth - hallway_horizontal_offset - 0.9 - 2 * lumber_osb_thickness, hallway_y + hallway_height])
  rotate([0, 90, 0])
  hallway_plank(2 * lumber_osb_width);

  translate([-lumber_osb_thickness - 0.05, lumber_2x6_depth - hallway_horizontal_offset - 0.9 - 2 * lumber_osb_thickness, hallway_y + hallway_height])
  hallway_plank(3 * lumber_osb_width);
  translate([-lumber_osb_thickness - 0.05, lumber_2x6_depth - hallway_horizontal_offset - 0.9 - 2 * lumber_osb_thickness, hallway_y + hallway_height + lumber_2x6_depth])
  hallway_plank(3 * lumber_osb_width);

  // Wall facing Pembina
  translate([lumber_osb_thickness + hallway_width, lumber_2x6_depth - hallway_horizontal_offset - 0.8, hallway_y + hallway_height - lumber_osb_height])
  rotate([0, 0, 90])
  wall_sheet();

  translate([lumber_osb_thickness + hallway_width, lumber_2x6_depth - hallway_horizontal_offset - 0.8 + lumber_osb_width, hallway_y + hallway_height - lumber_osb_height])
  rotate([0, 0, 90])
  wall_sheet();

  translate([lumber_osb_thickness + hallway_width, lumber_2x6_depth - hallway_horizontal_offset - 0.8 + 2 * lumber_osb_width, hallway_y + hallway_height - lumber_osb_height])
  rotate([0, 0, 90])
  wall_sheet();

  translate([hallway_width - lumber_2x6_depth, lumber_2x6_depth - hallway_horizontal_offset - 0.8 - 2 * lumber_osb_thickness, hallway_y + hallway_height])
  rotate([0, 90, 0])
  hallway_plank(hallway_length);

  translate([hallway_width - lumber_2x6_width + lumber_osb_thickness, lumber_2x6_depth - hallway_horizontal_offset - 0.9 - 2 * lumber_osb_thickness, hallway_y + hallway_height])
  hallway_plank(3 * lumber_osb_width);

  // Wall facing street
  translate([0, lumber_2x6_depth - hallway_horizontal_offset - 0.8 - lumber_osb_thickness, hallway_y + hallway_height - lumber_osb_height + 1.5 * 12])
  wall_sheet(6.5 * 12);

  translate([-lumber_osb_thickness + 1.05, 2 * lumber_2x6_depth - hallway_horizontal_offset - 0.8 + lumber_osb_thickness, hallway_y + hallway_height])
  rotate([0, 0, -90])
  rotate([0, 90, 0])
  hallway_plank(hallway_width - lumber_2x6_depth - lumber_osb_thickness - 1.05);

  // Wall facing river
  translate([0, lumber_2x6_depth - hallway_horizontal_offset - 0.8 + hallway_length, hallway_y + hallway_height - lumber_osb_height])
  wall_sheet();

  translate([-lumber_osb_thickness + 1.05 - lumber_2x6_depth, 1 * lumber_2x6_depth - hallway_horizontal_offset - 0.8 + lumber_osb_thickness + hallway_length, hallway_y + hallway_height])
  rotate([0, 0, -90])
  rotate([0, 90, 0])
  hallway_plank(hallway_width - lumber_osb_thickness - 1.05);
}

module outer_platform()
{
  translate([-lumber_osb_thickness - outer_platform_width, lumber_2x6_depth - hallway_horizontal_offset - 0.8 - landing_width, hallway_y])
  for (plank = [0: outer_platform_panels - 1])
    translate([plank * lumber_2x6_width, 0, 0])
    hallway_plank(outer_platform_length);

  crossbeam_spacing = (outer_platform_length - lumber_2x6_width) / (outer_platform_crossbeam_count - 1);
  crossbeam_height = crossbeam_spacing * sin(crossbeam_truss_angle) / cos(crossbeam_truss_angle);

  for (crossbeam = [0 : outer_platform_crossbeam_count - 1])
  {
    translate([lumber_osb_thickness, lumber_2x6_depth - hallway_horizontal_offset - landing_width + crossbeam * (outer_platform_length - lumber_2x6_width) / (outer_platform_crossbeam_count - 1), hallway_y - lumber_2x6_depth])
    rotate([0, 0, 90])
    hallway_plank(outer_platform_width);

    translate([-lumber_osb_thickness - lumber_4x4_width, lumber_2x6_depth - hallway_horizontal_offset - landing_width + (lumber_2x6_width - lumber_4x4_depth) * 0.5 + crossbeam * (outer_platform_length - lumber_2x6_width) / (outer_platform_crossbeam_count - 1), 0])
    pillar(hallway_y - lumber_2x6_depth);
    translate([-lumber_osb_thickness - outer_platform_width, lumber_2x6_depth - hallway_horizontal_offset - landing_width + (lumber_2x6_width - lumber_4x4_depth) * 0.5 + crossbeam * (outer_platform_length - lumber_2x6_width) / (outer_platform_crossbeam_count - 1), 0])
    pillar(hallway_y - lumber_2x6_depth);

    if (crossbeam > 0)
    {
      if (crossbeam < outer_platform_crossbeam_count - 1)
      {
        translate(
          [
            -lumber_osb_thickness - outer_platform_width - 0.5 * lumber_2x4_depth,
            lumber_2x6_depth - hallway_horizontal_offset - landing_width + (lumber_2x6_width - lumber_4x4_depth) * 0.5 - 0.05 + 0.5 * lumber_4x4_depth - 0.5 * crossbeam_spacing - 2 * lumber_osb_thickness + crossbeam * crossbeam_spacing,
            hallway_y - 0.5 * crossbeam_height - 5
          ])
        rotate([-crossbeam_truss_angle, 0, 0])
        cube([lumber_2x4_depth, crossbeam_spacing / cos(crossbeam_truss_angle) + 2, lumber_2x4_width], center = true);
      }

      translate(
        [
          -lumber_osb_thickness - outer_platform_width + 0.5 * lumber_2x4_depth + lumber_4x4_width,
          lumber_2x6_depth - hallway_horizontal_offset - landing_width + (lumber_2x6_width - lumber_4x4_depth) * 0.5 - 0.05 + 0.5 * lumber_4x4_depth - 0.5 * crossbeam_spacing - 2 * lumber_osb_thickness + crossbeam * crossbeam_spacing,
          hallway_y - 0.5 * crossbeam_height - 5
        ])
      rotate([crossbeam_truss_angle, 0, 0])
      cube([lumber_2x4_depth, crossbeam_spacing / cos(crossbeam_truss_angle) + 2, lumber_2x4_width], center = true);

      translate(
        [
          -lumber_osb_thickness - lumber_4x4_width - 0.5 * lumber_2x4_depth,
          lumber_2x6_depth - hallway_horizontal_offset - landing_width + (lumber_2x6_width - lumber_4x4_depth) * 0.5 - 0.05 + 0.5 * lumber_4x4_depth - 0.5 * crossbeam_spacing - 2 * lumber_osb_thickness + crossbeam * crossbeam_spacing,
          hallway_y - 0.5 * crossbeam_height - 5
        ])
      rotate([-crossbeam_truss_angle, 0, 0])
      cube([lumber_2x4_depth, crossbeam_spacing / cos(crossbeam_truss_angle) + 2, lumber_2x4_width], center = true);
    }
  }

  tiebeam_spacing = outer_platform_width - 1.5;
  tiebeam_angle = atan2(crossbeam_height, tiebeam_spacing);

  translate(
    [
      -outer_platform_width / 2,
      lumber_2x6_depth * 2 + lumber_4x4_depth + 0.25 - hallway_horizontal_offset - landing_width,
      hallway_y - 0.5 * crossbeam_height - 5
    ])
  rotate([0, tiebeam_angle, 0])
  cube([tiebeam_spacing / cos(tiebeam_angle), lumber_2x4_depth, lumber_2x4_width], center = true);

  translate(
    [
      -outer_platform_width / 2,
      lumber_2x6_depth + 0.25 - hallway_horizontal_offset - landing_width,
      hallway_y - 0.5 * crossbeam_height - 5
    ])
  rotate([0, -tiebeam_angle, 0])
  cube([tiebeam_spacing / cos(tiebeam_angle), lumber_2x4_depth, lumber_2x4_width], center = true);

  translate(
    [
      -outer_platform_width / 2,
      lumber_2x6_depth - 0.25 - hallway_horizontal_offset - landing_width + outer_platform_length,
      hallway_y - 0.5 * crossbeam_height - 5
    ])
  rotate([0, tiebeam_angle, 0])
  cube([tiebeam_spacing / cos(tiebeam_angle), lumber_2x4_depth, lumber_2x4_width], center = true);

  translate(
    [
      -outer_platform_width / 2,
      lumber_2x6_depth - 0.25 - hallway_horizontal_offset - landing_width - 1.5 * lumber_4x4_depth + outer_platform_length,
      hallway_y - 0.5 * crossbeam_height - 5
    ])
  rotate([0, -tiebeam_angle, 0])
  cube([tiebeam_spacing / cos(tiebeam_angle), lumber_2x4_depth, lumber_2x4_width], center = true);
}

module zipline_gantry()
{
  translate(
    [
      -lumber_osb_thickness,
      lumber_2x6_depth - hallway_horizontal_offset - landing_width + (lumber_2x6_width - lumber_4x4_depth) * 0.5 + outer_platform_length - lumber_2x6_width,
      0
    ])
  pillar(96);

  translate(
    [
      -lumber_osb_thickness - outer_platform_width - lumber_4x4_width,
      lumber_2x6_depth - hallway_horizontal_offset - landing_width + (lumber_2x6_width - lumber_4x4_depth) * 0.5 + outer_platform_length - lumber_2x6_width,
      0
    ])
  pillar(96);

  translate(
    [
      -lumber_osb_thickness,
      lumber_2x6_depth - hallway_horizontal_offset - landing_width + (lumber_2x6_width - 3 * lumber_4x4_depth) * 0.5 + outer_platform_length - lumber_2x6_width - 0.02,
      0
    ])
  pillar(96);

  translate(
    [
      -lumber_osb_thickness - outer_platform_width - lumber_4x4_width,
      lumber_2x6_depth - hallway_horizontal_offset - landing_width + (lumber_2x6_width - 3 * lumber_4x4_depth) * 0.5 + outer_platform_length - lumber_2x6_width - 0.02,
      0
    ])
  pillar(96);
}

module roof()
{
  translate([0, 0, hallway_y + hallway_height + lumber_2x6_depth + tan(roof_angle) * (hallway_width + lumber_osb_thickness)])
  rotate([0, roof_angle, 0])
  {
    for (panel = [0 : roof_panels - 1])
    {
      translate([0, (panel - 0.8)* lumber_osb_width, 0])
      translate([-outer_platform_width / cos(roof_angle), 0, 0])
      cube([lumber_osb_height, lumber_osb_width, lumber_osb_thickness]);
    }

    for (crossbeam = [0 : roof_crossbeams - 1])
    {
      translate([-outer_platform_width / cos(roof_angle) + crossbeam * (lumber_osb_height - lumber_2x4_width) / (roof_crossbeams - 1), -0.8 * lumber_osb_width, -lumber_2x4_depth])
      cube([lumber_2x4_width, 16 * 12, lumber_2x6_depth]);
    }
  }

  for (crossbeam = [0 : roof_crossbeams - 1])
  {
    translate([0, crossbeam * (hallway_length - lumber_2x6_width) / (roof_crossbeams - 1), 0])
    {
      translate([-3, -hallway_horizontal_offset + 0.7, hallway_y + hallway_height + 2 * lumber_2x6_depth])
      cube([8, lumber_2x6_width, lumber_2x6_depth]);
      translate([-3, -hallway_horizontal_offset + 0.7, hallway_y + hallway_height + 3 * lumber_2x6_depth])
      cube([8, lumber_2x6_width, lumber_2x6_depth]);
    }
  }
}

module slide()
{
  jut_out_amount = 20;

  for (angle = [0 : 2 : 360])
  {
    jut_out_factor = asin((angle / 180) - 1) / 90 + 1;

    translate([-jut_out_factor * jut_out_amount, 12, (cos(angle * 180 / 360) - 1) * hallway_y / 2])
    rotate([0, 0, angle + 180])
    translate([-5, -12, 60])
    rotate([0, 90, 0])
    cylinder(2, d = 24);
  }
}

module zipline()
{
  drop_angle = atan2(zipline_drop, zipline_length);

  translate([-0.5 * outer_platform_width, outer_platform_length - landing_width - 12, 96])
  rotate([0, 0, zipline_angle])
  rotate([-drop_angle, 0, 0])
  rotate([-90, 0, 0])
  cylinder(zipline_length, d = 1);
}

module new_play_structure()
{
  color("#907000")
  translate([new_play_structure_x, new_play_structure_y, 0])
  {
    climbing_wall();
    hallway();
    outer_platform();
    zipline_gantry();

    translate([climbing_wall_width, lumber_2x6_depth - hallway_horizontal_offset - 0.8 - lumber_4x4_depth, 0])
    pillar();

    translate([0, lumber_2x6_depth - hallway_horizontal_offset - 0.8 - lumber_4x4_depth, cos(climbing_wall_angle_degrees) * 96 - 1.5])
    rotate([0, 90, 0])
    pillar(climbing_wall_width);

    roof();
  }

  color("seagreen")
  translate([new_play_structure_x + slide_x, new_play_structure_y + slide_y, 0])
  slide();

  color("black")
  translate([new_play_structure_x, new_play_structure_y, 0])
  zipline();
}

space();

if (!show_new_space)
  old_play_structure();
else
  new_play_structure();