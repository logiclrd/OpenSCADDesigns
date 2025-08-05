function clamp(t, low, high)
  = (t < low) ? low : (t > high) ? high : t;

function anim_range(t) = clamp(t, 0, 1);

anim_stage_1_t = anim_range($t * 5);
anim_stage_2_t = anim_range($t * 5 - 1);
anim_stage_3_t = anim_range($t * 5 - 2);
anim_stage_4_t = anim_range($t * 5 - 3);
anim_stage_5_t = anim_range($t * 5 - 4);

stage_4_5_length = 0.05;

anim_stage_4_5_t = ($t < 0.8 - stage_4_5_length) ? 0 : ($t > 0.8) ? 0 : (($t - (0.8 - stage_4_5_length)) / stage_4_5_length);

pedal_latched_height_mm = 60;
pedal_unlatched_height_mm = 49;

pedal_depression_extent_mm = pedal_latched_height_mm - pedal_unlatched_height_mm;

door_elevation_mm = 3 * 25.4;

pedal_height_mm = pedal_latched_height_mm - (anim_stage_1_t - anim_stage_3_t + anim_stage_4_5_t) * pedal_depression_extent_mm;
door_open_angle = (anim_stage_2_t - anim_stage_4_t) * 60;
spring_height_mm = pedal_height_mm;

echo(pedal_height_mm);

max_spring_height_mm = 40 + pedal_depression_extent_mm;

door_width_mm = 12 * 25.4;
door_height_mm = 7 * 12 * 25.4;
door_thickness_mm = 0.6 * 25.4;

pedal_width_mm = 4 * 25.4;
pedal_depth_mm = 3 * 25.4;
pedal_wood_thickness_mm = 0.5 * 25.4;

spring_diameter_mm = 1.25 * 25.4;
spring_turns = 6;
spring_thickness_mm = 1.5;

wall_height_mm = door_height_mm + 8 * 25.4;

module doors()
{
  translate([0, 0, door_elevation_mm])
  color(c = [0.65, 0.3, 0.1])
  {
    rotate([0, 0, -door_open_angle])
    translate([0, -door_thickness_mm, 0])
    minkowski()
    {
      cube([door_width_mm - 1, door_thickness_mm, door_height_mm]);
      sphere(d = 1, $fn = 30);
    }

    translate([2 * door_width_mm + 0.5, 0, 0])
    rotate([0, 0, door_open_angle])
    translate([-door_width_mm, -door_thickness_mm, 0])
    minkowski()
    {
      cube([door_width_mm - 1, 0.6 * 25.4, door_height_mm]);
      sphere(d = 1, $fn = 30);
    }
  }
}

module pedal()
{
  color(c = [0.6, 0.35, 0])
  translate([door_width_mm -0.5 * pedal_width_mm, -pedal_depth_mm - door_thickness_mm - 2, 0])
  {
    cube([pedal_width_mm, pedal_depth_mm, pedal_wood_thickness_mm]);
    multmatrix(
     [[1, 0, 0, 0],
      [0, 1, 0, 0],
      [0, 0.17, 1, 0],
      [0, 0, 0, 1]])
    cube([pedal_width_mm, pedal_depth_mm, pedal_wood_thickness_mm]);
    translate([0, pedal_depth_mm - pedal_wood_thickness_mm, 0])
    cube([pedal_width_mm, pedal_wood_thickness_mm, pedal_wood_thickness_mm * 1.17]);
  }
}

module spring()
{
  for (a = [-360 : 5 : (spring_turns + 1) * 360])
    let (z = clamp(a / (spring_turns * 360), 0, 1) * spring_height_mm)
    translate([0, 0, z])
    rotate([0, 0, a])
    translate([0.5 * spring_diameter_mm, 0, 0])
    sphere(spring_thickness_mm);
}

module springs()
{
  color("black")
  {
    translate([12 * 25.4 - 0.5 * pedal_width_mm + 0.5 * spring_diameter_mm, -3.6 * 25.4 + 0.5 * spring_diameter_mm, 0])
    spring();

    translate([12 * 25.4 + 0.5 * pedal_width_mm - 0.5 * spring_diameter_mm, -3.6 * 25.4 + 0.5 * spring_diameter_mm, 0])
    spring();
  }
}

module wall()
{
  color(c = [0.55, 0.50, 0.45])
  translate([0, 1, 0])
  cube([2 * door_width_mm, 1, wall_height_mm]);
}

wall();

doors();

translate([0, 0, pedal_height_mm])
pedal();

springs();
