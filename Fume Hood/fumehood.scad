INCH = 25.4;
FOOT = 12 * INCH;

PLYWOOD_THICK = INCH / 2;
PLYWOOD_THIN = INCH / 4;
WIDTH_2x2 = 1.5 * INCH;

usable_width = 5 * FOOT;
usable_depth = 2.5 * FOOT;
usable_height = 28 * INCH;
work_gap = 7 * INCH;
viewport_angle = 25;
duct_width = 6 * INCH;

cabinet_depth = usable_depth + PLYWOOD_THIN + duct_width + PLYWOOD_THIN;

viewport_height_orthogonal = usable_height - work_gap;
viewport_depth_orthogonal = viewport_height_orthogonal * tan(viewport_angle);

viewport_height = viewport_height_orthogonal / cos(viewport_angle);

echo(viewport_height / INCH);

roof_depth = cabinet_depth - viewport_depth_orthogonal - PLYWOOD_THIN;

elbow_height = 9.5 * INCH;

fan_length = 7.28 * INCH;
fan_diameter = 5.79 * INCH;

filter_box_width = 20 * INCH;
filter_box_depth = 20 * INCH;
filter_box_height = 30 * INCH;

FAN_COLOUR = [0.3, 0.3, 0.3];
DUCT_COLOUR = [0.65, 0.65, 0.65];

module fan()
{
  color(FAN_COLOUR)
  difference()
  {
    cylinder(h = fan_length, d = fan_diameter, center = true);
    
    difference()
    {
      cylinder(h = fan_length + 0.5 * INCH, d = fan_diameter - 0.1 * INCH, center = true);
      cylinder(h = fan_length + 0.5 * INCH / 2, d = fan_diameter + 1 * INCH, center = true);
    }
    
    difference()
    {
      cylinder(h = 2.5 * INCH, d = fan_diameter + 1 * INCH, center = true);
      cylinder(h = 2.5 * INCH, d = fan_diameter - 0.4 * INCH, center = true);
    }
    
    // meh, good enough
  }
}

module elbow()
{
  bend_height = elbow_height - 2 * INCH;

  color(DUCT_COLOUR)
  translate([-3 * INCH, 0, 0])
  intersection()
  {
    translate([0, -elbow_height / 2, 0])
    cube([elbow_height, elbow_height, elbow_height]);
    
    translate([3 * INCH, 0, 2.62 * INCH]) // ???
    for (i = [0 : 3])
    {
      translate([bend_height / 2 - 3, 0, 0])
      rotate([0, 30 * i, 0])
      translate([3 - bend_height / 2, 0, 0])
      difference()
      {
        cylinder(h = bend_height, d = 6 * INCH, center = true);
        
        if (i < 3)
        {
          translate([3 * INCH, 0, INCH / 5])
          rotate([0, 30 / 2, 0])
          translate([-5 * INCH, 0, 5 * INCH])
          cube([10 * INCH, 10 * INCH, 10 * INCH], center = true);
        }
        
        if (i > 0)
        {
          translate([3 * INCH, 0, -INCH / 5])
          rotate([0, -30 / 2, 0])
          translate([-5 * INCH, 0, -5 * INCH])
          cube([10 * INCH, 10 * INCH, 10 * INCH], center = true);
        }
      }
    }
  }
}

// Work area
translate([0, 0, -PLYWOOD_THICK])
cube([usable_width, cabinet_depth, PLYWOOD_THICK]);

// Left and right walls
difference()
{
  union()
  {
    translate([-PLYWOOD_THIN, 0, -PLYWOOD_THICK])
    cube([PLYWOOD_THIN, cabinet_depth, usable_height + PLYWOOD_THICK]);
    translate([usable_width, 0, -PLYWOOD_THICK])
    cube([PLYWOOD_THIN, cabinet_depth, usable_height + PLYWOOD_THICK]);
  }
  
  translate([0, 0, work_gap])
  rotate([-viewport_angle, 0, 0])
  translate([-INCH, -usable_depth, 0])
  cube([usable_width * 2, usable_depth, usable_height * 2]);
}

// Back of work area
translate([0, usable_depth, 0])
cube([usable_width, PLYWOOD_THIN, usable_height]);

// Back of entire construction
translate([0, cabinet_depth - PLYWOOD_THIN, 0])
cube([usable_width, PLYWOOD_THIN, usable_height]);

// Viewport
color(c = [0, 0.8, 0.8], alpha = 0.5)
translate([0, 0, work_gap])
rotate([-viewport_angle, 0, 0])
cube([usable_width, PLYWOOD_THIN, viewport_height]);

// Roof
translate([0, viewport_depth_orthogonal + PLYWOOD_THIN, usable_height])
difference()
{
  cube([usable_width, roof_depth, PLYWOOD_THIN]);
  echo(roof_depth / INCH);
  
  translate([usable_width / 2, roof_depth - duct_width / 2, -PLYWOOD_THIN / 2])
  cylinder(h = 2 * PLYWOOD_THIN, d = duct_width);
}

// Extraction
translate([usable_width / 2, cabinet_depth - 0.5 * duct_width, usable_height + PLYWOOD_THIN + 0.02])
rotate([0, 0, 180])
elbow();

fan_x = (usable_width / 2 + duct_width / 2 - elbow_height) / 2;
fan_y = cabinet_depth - duct_width / 2;

translate([fan_x, fan_y, usable_height + elbow_height - duct_width / 2])
rotate([0, 90, 0])
fan();

translate([(usable_width / 2 + duct_width / 2 - elbow_height) / 2, cabinet_depth - duct_width / 2, usable_height + elbow_height - duct_width - PLYWOOD_THIN])
cube([fan_length, fan_diameter, PLYWOOD_THIN], center = true);

for (x = [-1, 1])
  for (y = [-1, 1])
    translate([fan_x + x * (fan_length / 2 - WIDTH_2x2 / 2) - WIDTH_2x2 / 2, fan_y + y * (fan_diameter / 2 - WIDTH_2x2 / 2) - WIDTH_2x2 / 2, usable_height + PLYWOOD_THIN])
    cube([WIDTH_2x2, WIDTH_2x2, elbow_height - duct_width - PLYWOOD_THIN * 2]);

duct_connect_length = fan_x - fan_length / 2;

color(DUCT_COLOUR)
for (x = [-1, 1])
  translate([fan_x + x * (fan_x - duct_connect_length / 2), cabinet_depth - 3 * INCH, usable_height + elbow_height - 3 * INCH])
  rotate([0, 90, 0])
  cylinder(h = duct_connect_length, d = 6 * INCH, center = true);

// Filter Box
translate([-(filter_box_width + PLYWOOD_THIN), cabinet_depth - filter_box_depth + INCH, usable_height + elbow_height - filter_box_height + INCH])
{
  // Front & Back
  for (y = [0, 1])
    translate([0, y * (filter_box_depth - PLYWOOD_THIN), 0])
    cube([filter_box_width, PLYWOOD_THIN, filter_box_height]);
  
  // Left & Right
  difference()
  {
    for (x = [0, 1])
      translate([x * (filter_box_width - PLYWOOD_THIN), 0, 0])
      cube([PLYWOOD_THIN, filter_box_depth - PLYWOOD_THIN, filter_box_height]);

    translate([filter_box_width, filter_box_depth - 4 * INCH, filter_box_height - 4 * INCH])
    rotate([0, 90, 0])
    cylinder(h = INCH, d = 6 * INCH, center = true);
  }
  
  // Roof
  translate([0, 0, filter_box_height])
  cube([filter_box_width, filter_box_depth, PLYWOOD_THIN]);

  // Filter support
  translate([filter_box_width / 2, WIDTH_2x2 / 2 + PLYWOOD_THIN, WIDTH_2x2 / 2])
  cube([filter_box_width - 2 * PLYWOOD_THIN, WIDTH_2x2, WIDTH_2x2], center = true);
  translate([filter_box_width / 2, filter_box_depth - WIDTH_2x2 / 2 - PLYWOOD_THIN, WIDTH_2x2 / 2])
  cube([filter_box_width - 2 * PLYWOOD_THIN, WIDTH_2x2, WIDTH_2x2], center = true);
  
  translate([WIDTH_2x2 / 2 + PLYWOOD_THIN, filter_box_depth / 2, WIDTH_2x2 / 2])
  cube([WIDTH_2x2, filter_box_depth - 2 * (WIDTH_2x2 + PLYWOOD_THIN), WIDTH_2x2], center = true);
  translate([filter_box_width - WIDTH_2x2 / 2 - PLYWOOD_THIN, filter_box_depth / 2, WIDTH_2x2 / 2])
  cube([WIDTH_2x2, filter_box_depth - 2 * (WIDTH_2x2 + PLYWOOD_THIN), WIDTH_2x2], center = true);
}