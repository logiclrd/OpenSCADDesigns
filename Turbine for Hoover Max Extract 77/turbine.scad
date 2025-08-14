disc_diameter_mm = 75;
disc_thickness_mm = 2.5;
vane_count = 36;
vane_inset_mm = -0.1;
vane_width_mm =10;
vane_length_mm = 5;
vane_front_diameter_mm = 5;
vane_back_diameter_mm = 12;
vane_leading_angle = 35;
vane_centre_thickness_mm = 3;
axle_diameter_mm = 5.5;
axle_wall_width_mm = 3.75;
axle_wall_height_top_mm = 3.5;
axle_wall_height_bottom_mm = 6;
axle_wall_chamfer_diameter_mm = 1.5;

module disc()
{
  cylinder(disc_thickness_mm, d = disc_diameter_mm, $fn = 100);
}

module vane(h = vane_height_mm)
{
  translate([0, 0, 0.5 * h])
  difference()
  {
    intersection()
    {
      translate([0, -vane_front_diameter_mm / 2, 0])
      {
        cylinder(h, d = vane_front_diameter_mm, center = true, $fn = 50);
        for (x = [-1, 1])
          scale([x, 1, 1])
          translate([vane_front_diameter_mm * sin(90 - vane_leading_angle) / 2, vane_front_diameter_mm * cos(90 - vane_leading_angle) / 2, 0])
          rotate([0, 0, vane_leading_angle])
          translate([-vane_front_diameter_mm / 2, -vane_width_mm / 2, 0])
          cube([vane_front_diameter_mm, vane_width_mm, h], center = true);
      }
      
      translate([0, -vane_length_mm / 2, 0])
      cube([100, vane_length_mm, 100], center = true);
    }
    
    translate([0, -vane_back_diameter_mm / 2 - vane_centre_thickness_mm, 0])
    cylinder(h * 2, d = vane_back_diameter_mm, center = true, $fn = 50);
  }
}

module axle_space()
{
  cylinder(2 * (axle_wall_height_top_mm + axle_wall_height_bottom_mm), d = axle_diameter_mm, center = true, $fn = 50);
}

module axle_chamfer()
{
  intersection()
  {
    difference()
    {
      translate([0, 0, -axle_wall_chamfer_diameter_mm / 2])
      cylinder(disc_thickness_mm + axle_wall_chamfer_diameter_mm, d = axle_diameter_mm + 2 * axle_wall_width_mm + 10);
      
      cylinder(disc_thickness_mm, d = disc_diameter_mm);

      minkowski()
      {
        difference()
        {
          translate([0, 0, -axle_wall_height_bottom_mm + 1])
          cylinder(axle_wall_height_top_mm + disc_thickness_mm + axle_wall_height_bottom_mm - 2, d = axle_diameter_mm + 2 * axle_wall_width_mm + 10, $fn = 50);
          
          translate([0, 0, -0.5 * axle_wall_chamfer_diameter_mm])
          cylinder(disc_thickness_mm + axle_wall_chamfer_diameter_mm, d = disc_diameter_mm);
          
          cylinder(2 * (axle_wall_height_top_mm + axle_wall_height_bottom_mm), d = axle_diameter_mm + axle_wall_chamfer_diameter_mm + 2 * axle_wall_width_mm, center = true, $fn = 50);
        }
        
        sphere(d = axle_wall_chamfer_diameter_mm, $fn = 30); 
      }
    }
    
    translate([0, 0, -axle_wall_chamfer_diameter_mm])
    cylinder(disc_thickness_mm + 3 * axle_wall_chamfer_diameter_mm, d = axle_diameter_mm + 2 * axle_wall_width_mm + 2 * axle_wall_chamfer_diameter_mm, $fn = 60);
  }
}

module axle()
{
  difference()
  {
    union()
    {
      translate([0, 0, -axle_wall_height_bottom_mm])
      cylinder(axle_wall_height_top_mm + disc_thickness_mm + axle_wall_height_bottom_mm, d = axle_diameter_mm + 2 * axle_wall_width_mm, $fn = 50);
      
      axle_chamfer();
    }

    axle_space();
  }
}

union()
{
  difference()
  {
    disc();
    axle_space();
  }
  
  axle();

  color("blue")
  for (v = [1 : vane_count])
    rotate([0, 0, v * 360 / vane_count])
    translate([-disc_diameter_mm / 2 + vane_width_mm / 2 + vane_inset_mm, vane_length_mm, disc_thickness_mm])
    vane();
}
