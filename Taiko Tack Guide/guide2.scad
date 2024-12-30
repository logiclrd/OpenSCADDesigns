// Guide #2, for the top row of tacks relative to the bottom row
//
// This minimalistic guide places the centre (and thus shaft position) for the second
// row tacks by being pressed up against the edges of the first row tacks they should
// be touching.

module cone(inclination, sweep, slice = [0, 200])
{
  rotate_extrude(angle = sweep)
  polygon(
    [
      [0, slice[0]],
      [slice[0] * sin(inclination), slice[0]],
      [slice[1] * sin(inclination), slice[1]],
      [0, slice[1]]
    ]);
}

inclination_x = 42.5;
inclination_y = 208;

inclination = atan2(inclination_x, inclination_y);

echo(str("Inclination: ", inclination_y, "x", inclination_x, " is ", inclination, " degrees"));

first_row_circumference_mm = 1990;
first_row_diameter_mm = first_row_circumference_mm / PI;
first_row_radius_mm = first_row_diameter_mm / 2;
//inclination = 15;
tack_diameter_mm = 19;
tack_count = 72;
guide_thickness_mm = 5;
tack_shaft_diameter_mm = 1.75;

first_row_tack_spacing_mm = first_row_circumference_mm / tack_count;
second_row_uninclined_offset_y_mm = sqrt(pow(tack_diameter_mm * 2, 2) - pow(first_row_tack_spacing_mm * 0.5, 2));
second_row_offset_y_mm = second_row_uninclined_offset_y_mm * cos(inclination);

second_row_radius_mm = first_row_radius_mm - second_row_offset_y_mm * sin(inclination);
second_row_diameter_mm = second_row_radius_mm * 2;
second_row_circumference_mm = second_row_diameter_mm * PI;

tack_sweep = 360 * tack_diameter_mm / second_row_circumference_mm;
radius_top_mm = second_row_radius_mm - tack_diameter_mm * sin(inclination);
radius_bottom_mm = second_row_radius_mm + tack_diameter_mm * sin(inclination);
cutaway_vertical_displacement_mm = guide_thickness_mm / tan(inclination);
slice_start = (radius_bottom_mm + guide_thickness_mm) / sin(inclination);
slice_end = (radius_top_mm + guide_thickness_mm) / sin(inclination);
tack_y_mm = second_row_radius_mm / tan(inclination) + cutaway_vertical_displacement_mm;
tack_shaft_radius_mm = tack_shaft_diameter_mm * 0.5;

difference()
{
  intersection()
  {
    scale([1, 1, -1])
    translate([0, 0, -tack_y_mm])
    difference()
    {
      rotate([0, 0, -tack_sweep])
      cone(inclination, 2 * tack_sweep, [tack_y_mm - tack_diameter_mm, tack_y_mm + tack_diameter_mm], $fn = 300);
      translate([0, 0, cutaway_vertical_displacement_mm])
      cone(inclination, 360, [tack_y_mm - tack_diameter_mm - cutaway_vertical_displacement_mm - 5, tack_y_mm + tack_diameter_mm], $fn = 300);
    }

    translate([0, 0, -second_row_radius_mm * sin(inclination)])
    rotate([0, 90 - inclination, 0])
    union()
    {
      cylinder(second_row_radius_mm + 10, d = tack_diameter_mm, $fn = 100);
      translate([-tack_diameter_mm, 0, second_row_radius_mm])
      cube([tack_diameter_mm * 2, tack_diameter_mm, guide_thickness_mm + 10], center = true);
    }
  }

  translate([0, 0, -second_row_radius_mm * sin(inclination)])
  rotate([0, 90 - inclination, 0])
  cylinder(second_row_radius_mm + 10, d = tack_shaft_diameter_mm, $fn = 50);
}