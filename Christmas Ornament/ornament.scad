// Instructions:
// - Select the shape you want, and then change the "/*" at the top of that section to "//*".
// - Print the ornament in vase mode and the cap regularly (upside down)
//   * If the ornament has a point at the bottom, print it upside-down with a brim
// - Superglue the cap onto the top of the ornament after printing
// - Drill a hole through the cap for inserting a hook (or bent paperclip) for hanging

height_mm = 100;
cap_height_mm = 12;
cap_diameter_mm = 12;

render_cap = true;

cap_wall_thickness_mm = 1;
cap_tolerance_mm = 0.09;

// Onion (adjust twist as desired)
/*
twist = 25;
radius_mm = 32;
layers = 25;
stripes = 8;
cap_adjust_mm = 4;

function profile(t)
  = sin(t * 180);
/**/

// Bulb
/*
twist = 0;
radius_mm = height_mm * 0.5;
layers = 25;
stripes = 50;
cap_adjust_mm = 0;

function profile(t)
  = let (x = 2 * (t - 0.5)) sqrt(1 - x*x);
/**/

// Gem/Spiky/Sharp
/*
twist = 0;
radius_mm = height_mm * 0.5;
layers = 2;
stripes = 6;
cap_adjust_mm = 5;

function profile(t)
  = 2 * (0.5 - abs(t - 0.5));
/**/

// Bell
/*
twist = 0;
radius_mm = height_mm;
layers = 25;
stripes = 50;
cap_adjust_mm = 2;

function profile(t)
  = (t > 0.75)
    ? let (u = (t - 0.75) * 4) sqrt(1 - u * u) * 0.25
    : let (u = (0.75 - t) * 0.7) (0.25 + u * u);
/**/

points =
  [
    [0, 0, 0],
    
    for (i = [0 : layers])
      for (j = [1 : stripes])
        let (t = i / layers)
        let (a = j * 360 / stripes + i * twist * 5 / layers)
        let (r = profile(t) * radius_mm)
        let (x = r * cos(a))
        let (y = r * sin(a))
        let (z = i * height_mm / layers)
        [ x, y, z ],
        
    [0, 0, height_mm + cap_height_mm]
  ];
  
faces =
  [
    for (i = [1 : stripes])
      [0, i, (i % stripes) + 1],
      
    for (i = [1 : layers])
      let (b = (i - 1) * stripes + 1)
      for (j = [0 : stripes - 1])
        [b + j, b + (j + 1) % stripes, b + j + stripes],

    for (i = [1 : layers])
      let (b = (i - 1) * stripes + 1)
      for (j = [0 : stripes - 1])
        [b + (j + 1) % stripes, b + (j + 1) % stripes + stripes, b + j + stripes],

    let (e = (layers + 1) * stripes + 1)
    for (i = [1 : stripes])
      [e, e - i, e - ((i % stripes) + 1)],
  ];

if (layers > 0)
{
  union()
  {
    polyhedron(points, faces, 1);
    translate([0, 0, height_mm * 0.5 - cap_adjust_mm])
    cylinder(height_mm * 0.5 + cap_height_mm, d = cap_diameter_mm, $fn = 30);
  }

  if (render_cap)
  {
    translate([0, 0, height_mm + cap_height_mm * 2])
    difference()
    {
      cylinder(cap_height_mm, d = cap_diameter_mm + 2 * (cap_wall_thickness_mm + cap_tolerance_mm));
      translate([0, 0, -cap_wall_thickness_mm])
      cylinder(cap_height_mm, d = cap_diameter_mm + 2 * cap_tolerance_mm);
    }
  }
}
else
{
  rotate([45, 0, 0])
  text("Select a shape (instructions in the code)");
}
