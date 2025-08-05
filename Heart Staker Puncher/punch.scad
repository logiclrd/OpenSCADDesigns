heart_scale = 0.23;
heart_place_depth_mm = 30;
heart_place_tolerance_mm = 0.5;
base_width_mm = 120;
base_depth_mm = 90;
base_height_mm = 50;
pillar_diameter_mm = 10;
pillar_inset_mm = 10;

head_height_mm = 50;

difference()
{
  translate([-base_width_mm / 2, -base_depth_mm / 2, 0])
  cube([base_width_mm, base_depth_mm, base_height_mm]);

  minkowski()
  {
    translate([0, 0, base_height_mm - heart_place_depth_mm])
    linear_extrude(heart_place_depth_mm)
    color("red")
    scale([0.23, 0.23, 1])
    import("heart.svg", center = true);

    sphere(heart_place_tolerance_mm, $fn = 3);
  }

  for (x = [-1, 1])
    for (y = [-1, 1])
      translate([x * (base_width_mm / 2 - pillar_diameter_mm / 2 - pillar_inset_mm), y * (base_depth_mm / 2 - pillar_diameter_mm / 2 - pillar_inset_mm), 5])
      cylinder(base_height_mm, d = pillar_diameter_mm);
}

translate([0, 0, base_height_mm + 50])
{
  difference()
  {
    translate([0, 0, head_height_mm / 2])
    cube([base_width_mm, base_depth_mm, head_height_mm], center = true);

    for (x = [-1, 1])
      for (y = [-1, 1])
        translate([x * (base_width_mm / 2 - pillar_diameter_mm / 2 - pillar_inset_mm), y * (base_depth_mm / 2 - pillar_diameter_mm / 2 - pillar_inset_mm), -5])
        cylinder(head_height_mm + 10, d = pillar_diameter_mm);
  }
}