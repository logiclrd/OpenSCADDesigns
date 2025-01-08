floor_size_mm = 201;
rotating_plate_diameter_mm = 144.5;
bracket_fillet_size_mm = 6;
bracket_height_mm = 5;
bracket_width_mm = 7;
bracket_corner_size_mm = 20;

intersection()
{
  translate([0, 0, -2.5 * bracket_height_mm])
  cube([floor_size_mm / 2, floor_size_mm / 2, bracket_height_mm * 1.5]);
  minkowski()
  {
    difference()
    {
      translate([0, 0, -2 * bracket_height_mm])
      cube([floor_size_mm / 2, floor_size_mm / 2, bracket_height_mm * 2]);

      rotate([180, 0, 0])
      minkowski()
      {
        difference()
        {
          linear_extrude(bracket_height_mm * 2)
          square(floor_size_mm * 2, center = true);
          
          rotate_extrude(angle = 360, $fn = 60)
          translate([rotating_plate_diameter_mm / 2 + 0, 0, 0])
          square([bracket_width_mm, bracket_height_mm * 2]);
          
          strut_length_mm = floor_size_mm * sqrt(2) / 2 - rotating_plate_diameter_mm * 0.5;
          
          rotate([0, 0, -45])
          translate([rotating_plate_diameter_mm * 0.5 + strut_length_mm * 0.5, 0, 0])
          cube([strut_length_mm, bracket_width_mm, bracket_height_mm * 4], center = true);
          
          translate([floor_size_mm / 2 - bracket_corner_size_mm / 2, bracket_width_mm / 4 - floor_size_mm / 2, 0])
          cube([bracket_corner_size_mm, bracket_width_mm * 1.125, bracket_height_mm * 4], center = true);
          
          translate([floor_size_mm / 2 - bracket_width_mm / 4, bracket_corner_size_mm / 2 - floor_size_mm / 2, 0])
          cube([bracket_width_mm * 1.125, bracket_corner_size_mm, bracket_height_mm * 4], center = true);
        }

        sphere(d = bracket_fillet_size_mm, $fn = 12);
      }
    }

    sphere(d = bracket_fillet_size_mm, $fn = 12);
  }
}
