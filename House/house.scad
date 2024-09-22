step_height_inches = 8;
step_overlap_inches = 1.25;
first_floor_height_inches = 101;
stairs_bannister_place_inches = 7;
stairs_bannister_place_height_at_start_inches = 24;
stairs_post_ns_inches = 8.5;
stairs_post_ew_inches = 7;
front_room_east_wall_length_to_post_inches = 77.5;
front_room_south_wall_to_edge_of_door_opening_inches = 104;

step_height_mm = step_height_inches * 25.4;
step_width_mm = 700;
step_depth_mm = 20;
stairs_post_ns_mm = stairs_post_ns_inches * 25.4;
stairs_post_ew_mm = stairs_post_ew_inches * 25.4;
stairs_bannister_place_height_at_start_mm = stairs_bannister_place_height_at_start_inches * 25.4;

step_overlap_mm = step_overlap_inches * 25.4;

wall_thickness_mm = 20;

first_floor_height_mm = first_floor_height_inches * 25.4;
front_room_east_wall_length_to_post_mm = front_room_east_wall_length_to_post_inches * 25.4;
front_room_south_wall_to_edge_of_door_opening_mm = front_room_south_wall_to_edge_of_door_opening_inches * 25.4;
front_room_door_lintel_thickness_mm = 5;

module step()
{
  translate([0, 0, -step_depth_mm])
  cube([step_width_mm, step_depth_mm, step_height_mm + step_depth_mm]);
  translate([0, -step_overlap_mm, step_height_mm - step_depth_mm])
  cube([step_width_mm, step_height_mm + step_overlap_mm, step_depth_mm]);
}

module steps()
{
  for (i = [1 : 14])
  {
    translate([0, step_height_mm * (i - 1), step_height_mm * (i - 1)])
    step();
  }

  translate([step_width_mm, 0, 0])
  cube([stairs_post_ew_mm, stairs_post_ns_mm, first_floor_height_mm]);

  translate([step_width_mm, 0, 0])
  rotate([-45, 0, 0])
  cube([stairs_post_ew_mm, wall_thickness_mm, first_floor_height_mm * sqrt(2)]);
}

front_room_ceiling_edge_height_inches = 3.375;
front_room_ceiling_corner_block_inches = 5.5;

front_room_ceiling_edge_height_mm = front_room_ceiling_edge_height_inches * 25.4;
front_room_ceiling_corner_block_mm = front_room_ceiling_corner_block_inches * 25.4;

module front_room()
{
  translate([step_width_mm, stairs_post_ns_mm, 0])
  difference()
  {
    cube([stairs_post_ew_mm, front_room_east_wall_length_to_post_mm, first_floor_height_mm]);
    
    translate([-wall_thickness_mm, 0, stairs_bannister_place_height_at_start_mm])
    rotate([45, 0, 0])
    cube([stairs_post_ew_mm + wall_thickness_mm * 2, front_room_east_wall_length_to_post_mm * 2, first_floor_height_mm]);
  }

  translate([step_width_mm, stairs_post_ns_mm + front_room_east_wall_length_to_post_mm, 0])
  cube([front_room_south_wall_to_edge_of_door_opening_mm, wall_thickness_mm, first_floor_height_mm]);
  
  translate([step_width_mm, 0, first_floor_height_mm])
  cube([front_room_south_wall_to_edge_of_door_opening_mm, 5000, wall_thickness_mm]);
  
  translate([step_width_mm, 0, -wall_thickness_mm])
  cube([front_room_south_wall_to_edge_of_door_opening_mm, 5000, wall_thickness_mm]);
  
  translate([step_width_mm, 0, first_floor_height_mm - front_room_ceiling_edge_height_mm])
  cube([stairs_post_ew_mm, 3000, front_room_ceiling_edge_height_mm]);
  
  translate([step_width_mm, stairs_post_ns_mm + front_room_east_wall_length_to_post_mm - front_room_ceiling_corner_block_mm - 40, first_floor_height_mm - front_room_ceiling_corner_block_mm * 2])
  cube([stairs_post_ew_mm, front_room_ceiling_corner_block_mm, front_room_ceiling_corner_block_mm * 2]);
}

front_room_door_frame_thickness_inches = 7.5;
door_frame_height_inches = 84; // estimate

front_room_door_frame_thickness_mm = front_room_door_frame_thickness_inches * 25.4;
door_frame_height_mm = door_frame_height_inches * 25.4;
door_frame_protrusion_into_front_room_mm = 5;
front_room_door_frame_protrusion_into_middle_room_mm = 25;

front_room_to_middle_room_wall_thickness_mm = front_room_door_frame_thickness_mm - door_frame_protrusion_into_front_room_mm - front_room_door_frame_protrusion_into_middle_room_mm;

middle_room_north_wall_inches = 24.5;
middle_room_east_wall_inches = 100;

middle_room_north_wall_mm = middle_room_north_wall_inches * 25.4;
middle_room_east_wall_mm = middle_room_east_wall_inches * 25.4;

module door_from_front_room_to_middle_room()
{
  translate(
    [
      step_width_mm + front_room_south_wall_to_edge_of_door_opening_mm - front_room_door_frame_thickness_mm,
      stairs_post_ns_mm + front_room_east_wall_length_to_post_mm - door_frame_protrusion_into_front_room_mm,
      0
    ])
  cube([front_room_door_frame_thickness_mm, front_room_door_frame_thickness_mm, door_frame_height_mm]);
}

module middle_room()
{
  translate(
    [
      step_width_mm + front_room_south_wall_to_edge_of_door_opening_mm - middle_room_north_wall_mm,
      stairs_post_ns_mm + front_room_east_wall_length_to_post_mm + front_room_door_frame_thickness_mm - door_frame_protrusion_into_front_room_mm - front_room_door_frame_protrusion_into_middle_room_mm - wall_thickness_mm,
      0
    ])
  cube([middle_room_north_wall_mm, wall_thickness_mm, first_floor_height_mm]);
  
  translate(
    [
      step_width_mm + front_room_south_wall_to_edge_of_door_opening_mm - middle_room_north_wall_mm - wall_thickness_mm,
      stairs_post_ns_mm + front_room_east_wall_length_to_post_mm + front_room_door_frame_thickness_mm - door_frame_protrusion_into_front_room_mm - front_room_door_frame_protrusion_into_middle_room_mm,
      0
    ])
  cube([wall_thickness_mm, middle_room_east_wall_mm, first_floor_height_mm]);
}

bedroom_door_frame_thickness_inches = 7;
bedroom_door_frame_protrusion_into_middle_room_inches = 1;
bedroom_door_frame_protrusion_into_bedroom_inches = 0.5;

bedroom_door_frame_thickness_mm = bedroom_door_frame_thickness_inches * 25.4;
bedroom_door_frame_protrusion_into_middle_room_mm = bedroom_door_frame_protrusion_into_middle_room_inches * 25.4;
bedroom_door_frame_protrusion_into_bedroom_mm = bedroom_door_frame_protrusion_into_bedroom_inches * 25.4;

module door_from_middle_room_to_bedroom()
{
  translate(
    [
      step_width_mm + front_room_south_wall_to_edge_of_door_opening_mm - middle_room_north_wall_mm - bedroom_door_frame_thickness_mm + bedroom_door_frame_protrusion_into_middle_room_mm,
      stairs_post_ns_mm + front_room_east_wall_length_to_post_mm + front_room_door_frame_thickness_mm - door_frame_protrusion_into_front_room_mm - front_room_door_frame_protrusion_into_middle_room_mm + middle_room_east_wall_mm - bedroom_door_frame_thickness_mm,
      0
    ])
  cube([bedroom_door_frame_thickness_mm, bedroom_door_frame_thickness_mm, door_frame_height_mm]);
}

bedroom_west_wall_inches = 82.5;
bedroom_closet_opening_offset_inches = 73.5;
bedroom_closet_opening_width_inches = 17.5;
bedroom_sink_opening_offset_inches = 43.5;
bedroom_sink_opening_width_inches = 24.75;
bedroom_toilet_opening_offset_inches = 4.75;
bedroom_toilet_opening_width_inches = 24;
bedroom_toilet_stall_back_wall_depth_inches = 56.75;
bedroom_toilet_stall_back_wall_height_inches = 48;
bedroom_toilet_stall_south_wall_depth_inches = 3.75;

bedroom_west_wall_mm = bedroom_west_wall_inches * 25.4;

bedroom_north_wall_mm = step_width_mm + front_room_south_wall_to_edge_of_door_opening_mm - middle_room_north_wall_mm - bedroom_door_frame_thickness_mm + wall_thickness_mm + bedroom_door_frame_protrusion_into_bedroom_mm;
bedroom_north_edge_offset_mm = stairs_post_ns_mm + front_room_east_wall_length_to_post_mm + front_room_door_frame_thickness_mm - door_frame_protrusion_into_front_room_mm - front_room_door_frame_protrusion_into_middle_room_mm + middle_room_east_wall_mm - bedroom_west_wall_mm;

bedroom_closet_opening_offset_mm = bedroom_closet_opening_offset_inches * 25.4;
bedroom_closet_opening_width_mm = bedroom_closet_opening_width_inches * 25.4;

bedroom_sink_opening_offset_mm = bedroom_sink_opening_offset_inches * 25.4;
bedroom_sink_opening_width_mm = bedroom_sink_opening_width_inches * 25.4;

bedroom_toilet_opening_offset_mm = bedroom_toilet_opening_offset_inches * 25.4;
bedroom_toilet_opening_width_mm = bedroom_toilet_opening_width_inches * 25.4;

bedroom_toilet_stall_back_wall_depth_mm = bedroom_toilet_stall_back_wall_depth_inches * 25.4;
bedroom_toilet_stall_back_wall_height_mm = bedroom_toilet_stall_back_wall_height_inches * 25.4;

bedroom_toilet_stall_width_mm = bedroom_sink_opening_offset_mm - 0.5 * (bedroom_sink_opening_offset_mm - (bedroom_toilet_opening_offset_mm + bedroom_toilet_opening_width_mm)) - 0.5 * wall_thickness_mm;

bedroom_toilet_stall_south_wall_depth_mm = bedroom_toilet_stall_south_wall_depth_inches * 25.4;

module bedroom_toilet_stall()
{
  translate([0, stairs_post_ns_mm + front_room_east_wall_length_to_post_mm + front_room_door_frame_thickness_mm - door_frame_protrusion_into_front_room_mm - front_room_door_frame_protrusion_into_middle_room_mm + middle_room_east_wall_mm - bedroom_west_wall_mm - bedroom_toilet_stall_back_wall_depth_mm - bedroom_toilet_stall_south_wall_depth_mm - wall_thickness_mm, 0])
  cube([bedroom_toilet_stall_width_mm, wall_thickness_mm, bedroom_toilet_stall_back_wall_height_mm]);

  translate([0, stairs_post_ns_mm + front_room_east_wall_length_to_post_mm + front_room_door_frame_thickness_mm - door_frame_protrusion_into_front_room_mm - front_room_door_frame_protrusion_into_middle_room_mm + middle_room_east_wall_mm - bedroom_west_wall_mm - bedroom_toilet_stall_back_wall_depth_mm - bedroom_toilet_stall_south_wall_depth_mm - wall_thickness_mm, bedroom_toilet_stall_back_wall_height_mm])
  rotate([-45, 0, 0])
  cube([bedroom_toilet_stall_width_mm, wall_thickness_mm, bedroom_toilet_stall_back_wall_depth_mm * sqrt(2)]);
  
  translate([bedroom_toilet_stall_width_mm - 1, stairs_post_ns_mm + front_room_east_wall_length_to_post_mm + front_room_door_frame_thickness_mm - door_frame_protrusion_into_front_room_mm - front_room_door_frame_protrusion_into_middle_room_mm + middle_room_east_wall_mm - bedroom_west_wall_mm - bedroom_toilet_stall_south_wall_depth_mm - bedroom_toilet_stall_back_wall_depth_mm, 0])
  difference()
  {
    cube([wall_thickness_mm, bedroom_toilet_stall_back_wall_depth_mm, first_floor_height_mm]);
    
    translate([-wall_thickness_mm, 0, bedroom_toilet_stall_back_wall_height_mm])
    rotate([-45, 0, 0])
    translate([0, -bedroom_toilet_stall_back_wall_depth_mm, 0])
    cube([wall_thickness_mm * 4, bedroom_toilet_stall_back_wall_depth_mm, first_floor_height_mm]);
  }
}

module bedroom()
{
  translate(
    [
      bedroom_north_wall_mm,
      stairs_post_ns_mm + front_room_east_wall_length_to_post_mm + front_room_door_frame_thickness_mm - door_frame_protrusion_into_front_room_mm - front_room_door_frame_protrusion_into_middle_room_mm + middle_room_east_wall_mm - bedroom_west_wall_mm,
      0
    ])
  cube([wall_thickness_mm, bedroom_west_wall_mm, first_floor_height_mm]);
  
  translate([0, bedroom_north_edge_offset_mm - wall_thickness_mm, 0])
  {
    difference()
    {
      cube([bedroom_north_wall_mm, wall_thickness_mm, first_floor_height_mm]);
  
      translate([bedroom_closet_opening_offset_mm, -wall_thickness_mm, -5])
      cube([bedroom_closet_opening_width_mm, 10 * wall_thickness_mm, door_frame_height_mm + 5]);
      translate([bedroom_sink_opening_offset_mm, -wall_thickness_mm, -5])
      cube([bedroom_sink_opening_width_mm, 10 * wall_thickness_mm, door_frame_height_mm + 5]);
      translate([bedroom_toilet_opening_offset_mm, -wall_thickness_mm, -5])
      cube([bedroom_toilet_opening_width_mm, 10 * wall_thickness_mm, door_frame_height_mm + 5]);
    }
  }

  bedroom_closet_divider_depth_mm = middle_room_east_wall_mm - bedroom_west_wall_mm;

  translate([bedroom_toilet_stall_width_mm, bedroom_north_edge_offset_mm - wall_thickness_mm - bedroom_closet_divider_depth_mm, 0])
  cube([bedroom_north_wall_mm - bedroom_toilet_stall_width_mm, wall_thickness_mm, first_floor_height_mm]);

  translate(
    [
      bedroom_closet_opening_offset_mm - 0.5 * (bedroom_closet_opening_offset_mm - (bedroom_sink_opening_offset_mm + bedroom_sink_opening_width_mm)) - 0.5 * wall_thickness_mm,
      bedroom_north_edge_offset_mm - wall_thickness_mm - bedroom_closet_divider_depth_mm,
      0
    ])
  cube([wall_thickness_mm, bedroom_closet_divider_depth_mm, first_floor_height_mm]);

  translate(
    [
      bedroom_toilet_stall_width_mm,
      bedroom_north_edge_offset_mm - wall_thickness_mm - bedroom_closet_divider_depth_mm,
      0
    ])
  cube([wall_thickness_mm, bedroom_closet_divider_depth_mm, first_floor_height_mm]);

  translate([0, stairs_post_ns_mm + front_room_east_wall_length_to_post_mm, -wall_thickness_mm])
  cube([step_width_mm + front_room_south_wall_to_edge_of_door_opening_mm, 5000, wall_thickness_mm]);
  
  translate([0, bedroom_north_edge_offset_mm - bedroom_toilet_stall_south_wall_depth_mm - wall_thickness_mm, 0])
  difference()
  {
    cube([bedroom_toilet_stall_width_mm, wall_thickness_mm, first_floor_height_mm]);

    translate([bedroom_toilet_opening_offset_mm, -wall_thickness_mm, -5])
    cube([bedroom_toilet_opening_width_mm, 10 * wall_thickness_mm, door_frame_height_mm + 5]);
  }
  
  translate([bedroom_toilet_opening_offset_mm, bedroom_north_edge_offset_mm - bedroom_toilet_stall_south_wall_depth_mm, door_frame_height_mm])
  cube([bedroom_toilet_opening_width_mm, bedroom_toilet_stall_south_wall_depth_mm, wall_thickness_mm]);
  translate([bedroom_toilet_opening_offset_mm - wall_thickness_mm, bedroom_north_edge_offset_mm - bedroom_toilet_stall_south_wall_depth_mm, 0])
  cube([wall_thickness_mm, bedroom_toilet_stall_south_wall_depth_mm, door_frame_height_mm]);
  translate([bedroom_toilet_opening_offset_mm + bedroom_toilet_opening_width_mm, bedroom_north_edge_offset_mm - bedroom_toilet_stall_south_wall_depth_mm, 0])
  cube([wall_thickness_mm, bedroom_toilet_stall_south_wall_depth_mm, door_frame_height_mm]);
  
  bedroom_toilet_stall();
}

steps();

front_room();

door_from_front_room_to_middle_room();

middle_room();

door_from_middle_room_to_bedroom();

bedroom();