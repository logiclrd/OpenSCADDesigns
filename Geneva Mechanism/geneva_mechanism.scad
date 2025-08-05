if ($preview)
{
  translate([0, 100, 0])
  linear_extrude(0.5)
  import("drawing.svg");
}

number_of_points = 6;
center_distance_mm = 92;
follower_diameter_mm = 13;
cam_clearance_mm = 0.6;
cam_diameter_mm = 75;
driver_diameter_mm = 125;
index_plate_diameter_mm = 150;
follower_distance_mm = 47;
cam_cutout_radius_mm = index_plate_diameter_mm * 0.5 + cam_clearance_mm;
lighting_holes_number = 8;
lighting_holes_diameter_mm = 20;
lighting_holes_center_distance_mm = 80;
show_center_marks = true;
show_center_lines = true;

index_plate_thickness_mm = 25;
driver_thickness_mm = 45;
cam_thickness_mm = 25;

// These should match 6704ZZ bearings.
//
// https://www.amazon.ca/HiPicco-6700ZZ-Bearings-Shielded-Bearing/dp/B0C74WFYVB/146-5377152-4851331

axle_diameter_mm = 20;
axle_sides = 4;
axle_bearing_diameter_mm = 27;

$fn = 100;

module index_plate(height_mm = index_plate_thickness_mm)
{
  color("cyan")
  linear_extrude(height_mm)
  difference()
  {
    circle(d = index_plate_diameter_mm);

    for (i = [1 : number_of_points])
    {
      rotate([0, 0, i * 360 / number_of_points])
      {
        // Follower cutout
        translate([center_distance_mm - follower_distance_mm, 0, 0])
        circle(d = follower_diameter_mm + cam_clearance_mm * 2);

        translate([center_distance_mm - follower_distance_mm + 0.5 * index_plate_diameter_mm, 0, 0])
        square([index_plate_diameter_mm, follower_diameter_mm + cam_clearance_mm * 2], center = true);

        // Cam cutouts
        rotate([0, 0, 30])
        translate([center_distance_mm, 0, 0])
        circle(d = cam_diameter_mm);
      }
    }
    
  }
}

module driver(overall_height_mm, cam_height_mm = cam_thickness_mm, cap_bottom = true, cap_top = false)
{
  cap_height_mm =
    (cap_bottom && cap_top)
    ? (overall_height_mm - cam_height_mm) / 2
    : (cap_bottom || cap_top)
      ? (overall_height_mm - cam_height_mm)
      : 0;

  module cap(height_mm)
  {
    color("teal")
    linear_extrude(height_mm)
    union()
    {
      difference()
      {
        circle(d = driver_diameter_mm);

        for (i = [1 : lighting_holes_number])
        {
          rotate([0, 0, (i - 0.5) * 360 / lighting_holes_number])
          translate([lighting_holes_center_distance_mm / 2, 0, 0])
          circle(d = lighting_holes_diameter_mm);
        }
      }

      translate([-follower_distance_mm, 0, 0])
      circle(d = follower_diameter_mm);
    }
  }
  
  if (cap_bottom)
    cap(cap_height_mm);
  if (cap_top)
    translate([0, 0, overall_height_mm - cap_height_mm])
    cap(cap_height_mm);

  color("green")
  translate([0, 0, cap_height_mm])
  linear_extrude(cam_height_mm)
  union()
  {
    difference()
    {
      circle(d = cam_diameter_mm);

      translate([-center_distance_mm, 0, 0])
      circle(r = cam_cutout_radius_mm);
    }

    translate([-follower_distance_mm, 0, 0])
    circle(d = follower_diameter_mm);
  }
}

module mechanism(index_plate_height_mm = index_plate_thickness_mm, driver_height_mm = driver_thickness_mm, cam_height_mm = cam_thickness_mm)
{
  base_height_mm = driver_height_mm - cam_height_mm;

  translate([-0.5 * center_distance_mm, 0, base_height_mm])
  index_plate(index_plate_height_mm);

  translate([0.5 * center_distance_mm, 0, 0])
  driver(driver_height_mm, cam_height_mm);
}

module multi_mechanism(mount_plate_height_mm = 20, index_plate_height_mm = index_plate_thickness_mm, driver_height_mm = driver_thickness_mm, cam_height_mm = cam_thickness_mm, index_plate_count = 5, index_plate_layers = 3, plate_clearance_mm = 0.6)
{
  cap_height_mm = driver_height_mm - cam_height_mm;

  multi_driver_height_mm = cap_height_mm + plate_clearance_mm + index_plate_layers * (index_plate_height_mm + plate_clearance_mm) + cap_height_mm;
  multi_cam_height_mm = index_plate_layers * (cam_height_mm + plate_clearance_mm) + plate_clearance_mm;

  base_height_mm = driver_height_mm - cam_height_mm;

  for (i = [1 : index_plate_count])
    rotate([0, 0, (i - 1) * 360 / number_of_points])
    translate([-center_distance_mm, 0, 0])
    rotate([0, 0, (i > 1) ? 180 / number_of_points : 0])
    {
      translate([0, 0, base_height_mm + plate_clearance_mm + ((i - 1) % index_plate_layers) * (cam_height_mm + plate_clearance_mm)])
      index_plate(index_plate_height_mm);

      translate([0, 0, -mount_plate_height_mm - plate_clearance_mm])
      cylinder(multi_driver_height_mm + 2 * (mount_plate_height_mm + plate_clearance_mm), d = axle_diameter_mm, $fn = axle_sides);
    }

  driver(multi_driver_height_mm, multi_cam_height_mm, true, true);
  translate([0, 0, -mount_plate_height_mm])
  cylinder(multi_driver_height_mm + 2 * mount_plate_height_mm, d = axle_diameter_mm, $fn = axle_sides);

  mount_plate_width_mm = center_distance_mm + index_plate_diameter_mm + driver_diameter_mm;

  color("orange")
  for (i = [0, 1])
  {
    translate([0, 0, -0.5 * mount_plate_height_mm - plate_clearance_mm + i * (plate_clearance_mm + multi_driver_height_mm + plate_clearance_mm + mount_plate_height_mm)])
    difference()
    {
      cube([mount_plate_width_mm, mount_plate_width_mm, mount_plate_height_mm], center = true);

      for (i = [1 : index_plate_count])
        rotate([0, 0, (i - 1) * 360 / number_of_points])
        translate([-center_distance_mm, 0, 0])
        rotate([0, 0, (i > 1) ? 180 / number_of_points : 0])
        {
          translate([0, 0, -mount_plate_height_mm])
          cylinder(multi_driver_height_mm + 2 * mount_plate_height_mm, d = axle_bearing_diameter_mm);
        }

      translate([0, 0, -mount_plate_height_mm])
      cylinder(multi_driver_height_mm + 2 * mount_plate_height_mm, d = axle_bearing_diameter_mm);
    }
  }
}

//mechanism();

multi_mechanism();