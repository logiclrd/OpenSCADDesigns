slider_width_mm = 44;
slider_length_mm = 18 * 25.4;

left_front_space_mm = 17.8;
left_back_space_mm = 17.8;

right_front_space_mm = 19.5;
right_back_space_mm = 17.7;

desired_space_mm = 7;
spacer_top_mm = 20;
spacer_bottom_mm = 40;
bevel_down_to_mm = 2;

spacer_height_mm = spacer_top_mm + slider_width_mm + spacer_bottom_mm;

front_screwhole_offset_mm = 7;
middle_screwhole_offset_mm = 131;
back_screwhole_offset_mm = 259;

spacer_width_mm = 30;

front_spacer_offset_mm = 0;
middle_spacer_offset_mm = middle_screwhole_offset_mm - spacer_width_mm / 2;
back_spacer_offset_mm = back_screwhole_offset_mm - spacer_width_mm / 2;

screwhole_diameter_mm = 5;

module spacer(start_thickness_mm, end_thickness_mm, spacer_offset_mm, screwhole_offset_mm, side, placement, text_direction)
{
  thickness_mm = max(start_thickness_mm, end_thickness_mm);
  thinness_mm = min(start_thickness_mm, end_thickness_mm);
  
  top_bevel_angle = -atan2(thickness_mm - bevel_down_to_mm, spacer_top_mm);
  bottom_bevel_angle = atan2(thickness_mm - bevel_down_to_mm, spacer_bottom_mm);
  
  installation_angle = -atan2(start_thickness_mm - end_thickness_mm, slider_length_mm);
  
  echo(installation_angle);
  
  intersection()
  {
    difference()
    {
      cube([thickness_mm, slider_length_mm, spacer_height_mm]);
      
      translate([thickness_mm, -1, spacer_bottom_mm + slider_width_mm])
      rotate([0, top_bevel_angle, 0])
      cube([thickness_mm, slider_length_mm + 2, spacer_height_mm + 2]);

      translate([bevel_down_to_mm, -1, 0])
      rotate([0, bottom_bevel_angle, 0])
      cube([thickness_mm, slider_length_mm + 2, spacer_height_mm + 2]);
      
      translate([desired_space_mm, -1,spacer_bottom_mm])
      cube([thickness_mm, slider_length_mm + 2, slider_width_mm]);
      
      translate([max(0, end_thickness_mm - start_thickness_mm) - thickness_mm, 0, 0])
      rotate([0, 0, installation_angle])
      translate([0, -1, -1])
      cube([thickness_mm, slider_length_mm + 2, spacer_height_mm + 2]);
      
      translate([0, screwhole_offset_mm, spacer_bottom_mm + slider_width_mm / 2])
      rotate([0, 90, 0])
      cylinder(h = 2 * thickness_mm, d = screwhole_diameter_mm, center = true, $fn = 60);

      translate([0, spacer_offset_mm + spacer_width_mm / 2, spacer_bottom_mm + slider_width_mm / 2 + (spacer_top_mm + slider_width_mm / 2) / 2])
      scale([1, text_direction, 1])
      rotate([90, 0, 90])
      linear_extrude(thickness_mm - thinness_mm + 1)
      text(side, halign = "center", valign = "center");

      translate([0, spacer_offset_mm + spacer_width_mm / 2, spacer_bottom_mm / 2])
      scale([1, text_direction, 1])
      rotate([90, 0, 90])
      linear_extrude(thickness_mm - thinness_mm + 1)
      text(str(placement), halign = "center", valign = "center");
    }
    
    translate([thickness_mm / 2, spacer_width_mm / 2 + spacer_offset_mm, spacer_height_mm / 2])
    cube([2 * thickness_mm, spacer_width_mm, 2 * spacer_height_mm], center = true);
  }
}

module spacer_set(start_thickness_mm, end_thickness_mm, side, text_direction, spacers)
{
  for (spacer = spacers)
  {
    spacer_offset_mm = spacer[0];
    screwhole_offset_mm = spacer[1];

    spacer(start_thickness_mm, end_thickness_mm, spacer_offset_mm, screwhole_offset_mm, side, spacer_offset_mm, text_direction);
  }
}

spacer_set(
  left_front_space_mm,
  left_back_space_mm,
  "L",
  -1,
  [
    [ front_spacer_offset_mm, front_screwhole_offset_mm ],
    [ middle_spacer_offset_mm, middle_screwhole_offset_mm ],
    [ back_spacer_offset_mm, back_screwhole_offset_mm ]
  ]);

translate([100, 0, 0])
scale([-1, 1, 1])
spacer_set(
  right_front_space_mm,
  right_back_space_mm,
  "R",
  1,
  [
    [ front_spacer_offset_mm, front_screwhole_offset_mm ],
    [ middle_spacer_offset_mm, middle_screwhole_offset_mm ],
    [ back_spacer_offset_mm, back_screwhole_offset_mm ]
  ]);
