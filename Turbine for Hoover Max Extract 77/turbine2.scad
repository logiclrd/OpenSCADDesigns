disc_diameter_mm = 75;
disc_thickness_mm = 2.5;
against_plate_bias_mm = 1.3;
vane_count = 28;
vane_height_mm = 7;
vane_inset_mm = 0.3;
vane_width_mm = 10;
vane_thickness_mm = 2.5;
vane_angle_in = 30;
vane_angle_out = 0;
vane_leading_angle = 35;
vane_centre_thickness_mm = 3;
axle_diameter_mm = 5.6;
axle_wall_width_mm = 3.75;
axle_wall_height_top_mm = 3.5;
axle_wall_height_bottom_mm = 6;
axle_wall_chamfer_diameter_mm = 1.5;
part_tolerance_mm = 0.15;

module disc(plate_thickness_bias_mm)
{
  cylinder(disc_thickness_mm + plate_thickness_bias_mm, d = disc_diameter_mm, $fn = 100);
}

module vane(h = vane_height_mm)
{
  vane_in_unit_x = -sin(vane_angle_in);
  vane_out_unit_x = -sin(vane_angle_out);

  vane_unit_circle_width_mm = vane_out_unit_x - vane_in_unit_x;
  vane_scale = 2 * vane_width_mm / vane_unit_circle_width_mm;
  
  echo("unit: ", vane_unit_circle_width_mm);
  echo("scale: ", vane_scale);
  echo("width: ", vane_width_mm);

  translate([-0.5 * vane_scale * -sin(vane_angle_in), -0.5 * vane_scale * cos(vane_angle_in), 0])
  intersection()
  {
    difference()
    {
      sphere(d = vane_scale + vane_thickness_mm / 2, $fn = 200);
      translate([0, 0, 1])
      sphere(d = vane_scale - vane_thickness_mm / 2, $fn = 200);
    }
    
    linear_extrude(vane_height_mm)
    polygon(
      [
        [0, 0],
        for (angle = [vane_angle_in : -1 : vane_angle_out])
          [vane_scale * -sin(angle), vane_scale * cos(angle)],
      ],
      [
        [
          for (i = [0 : -(vane_angle_out - vane_angle_in)])
            i,
          0
        ]
      ]);
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

module part(plate_thickness_bias_mm)
{
  union()
  {
    difference()
    {
      disc(plate_thickness_bias_mm);
      axle_space();
    }
    
    axle();

    color("blue")
    for (v = [1 : vane_count])
      rotate([0, 0, v * 360 / vane_count])
      translate([-disc_diameter_mm / 2 + vane_inset_mm, 0, disc_thickness_mm + plate_thickness_bias_mm])
      vane();
  }
}

module part_separation(bias)
{
  cube(
    [
      axle_diameter_mm + 2 * axle_wall_width_mm + 2 * axle_wall_chamfer_diameter_mm + bias,
      axle_diameter_mm + 2 * axle_wall_width_mm + 2 * axle_wall_chamfer_diameter_mm + bias,
      axle_wall_height_bottom_mm + disc_thickness_mm + axle_wall_height_top_mm + 10
    ], center = true);
}

/*
difference()
{
  part(-against_plate_bias_mm);
  part_separation(part_tolerance_mm);
}
/*/
intersection()
{
  part(0);
  //part_separation(-part_tolerance_mm);
}
/**/