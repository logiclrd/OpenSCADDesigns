$fn = 200;

handle_width = 40;
brush_width = 225;
brush_length = 200;
solid_length = 40;
brush_thickness = 5;
corner_radius = 8;

cutout_radius = brush_width / 2 - handle_width / 2;

module corner_cutout(x, y, radius, angle)
{
  translate([x, y, 0])
  rotate([0, 0, angle])
  translate([-radius, -radius, 0])
  difference()
  {
    translate([radius / 2, radius / 2, 0])
    cube([radius, radius, brush_thickness + 2], center = true);
    
    cylinder(brush_thickness + 2, r = radius, center = true);
  }
}

difference()
{
  cube([brush_width, brush_length, brush_thickness], center = true);

  translate([-brush_width / 2, brush_length / 2 - cutout_radius - solid_length, 0])
  cylinder(brush_thickness + 2, r = cutout_radius, center = true);
  translate([brush_width / 2, brush_length / 2 - cutout_radius - solid_length, 0])
  cylinder(brush_thickness + 2, r = cutout_radius, center = true);
  
  translate([-brush_width / 2 - handle_width / 2, -cutout_radius - solid_length, 0])
  cube([brush_width, brush_length, 2 + brush_thickness], center = true);
  translate([brush_width / 2 + handle_width / 2, -cutout_radius - solid_length, 0])
  cube([brush_width, brush_length, 2 + brush_thickness], center = true);
  
  corner_cutout(-brush_width / 2, brush_length / 2 - solid_length - 0.35, corner_radius, 180);
  corner_cutout(brush_width / 2, brush_length / 2 - solid_length - 0.35, corner_radius, 270);
  corner_cutout(-handle_width / 2, -brush_length / 2, corner_radius, 180);
  corner_cutout(handle_width / 2, -brush_length / 2, corner_radius, 270);
}
