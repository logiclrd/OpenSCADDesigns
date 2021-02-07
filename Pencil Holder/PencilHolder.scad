R = 60;
w = R / sqrt(2);
nH = 2 * w - R;

extend_sphere = false;
truncate_sphere = true;

cutaway = $preview;

pencil_hole_angle_multiplier = 1.4;
pencil_hole_count = 15;
pencil_hole_radius = 5;
pencil_hole_min_separation = 1;

top_z = truncate_sphere ? 2 * R - nH : 2 * R;

function radius_at_z(z)
  = truncate_sphere
    ? sqrt(R * R - (z - (R - nH)) * (z - (R - nH)))
    : (extend_sphere == false) || (z > nH)
      ? sqrt(R * R - (z - R) * (z - R))
      : nH + z;

module main_shell()
{
  if (truncate_sphere)
  {
    difference()
    {
      translate([0, 0, R - nH])
      sphere(R, $fn = 120);
      
      translate([0, 0, -50])
      cube(100, center = true);
    }
  }
  else
  {
    union()
    {
      translate([0, 0, R])
      sphere(R, $fn = 120);

      if (extend_sphere)
        cylinder(w - nH, nH, w, $fn = 120);
    }
  }
}

module ballast_chamber(z)
{
  ballast_chamber_radius = radius_at_z(z) - 5;
  
  translate([0, 0, z])
  cylinder(6.9, ballast_chamber_radius, ballast_chamber_radius);
  
  echo(str("Ballast chamber radius: ", ballast_chamber_radius));
}

module shell_with_ballast_chambers()
{
  difference()
  {
    main_shell();
    ballast_chamber(4);
    
    if (extend_sphere)
      ballast_chamber(14);
  }
}

function find_overlap(points, x, y, i)
  = i >= len(points)
    ? false
    : let (dx = points[i][0] - x)
      let (dy = points[i][1] - y)
      let (d = sqrt(dx * dx + dy * dy))
        d < pencil_hole_radius * 2 + pencil_hole_min_separation
        ? true
        : find_overlap(points, x, y, i + 1);

function find_next_pencil_hole(so_far, seed)
  = let (x = rands(-w / pencil_hole_angle_multiplier, w / pencil_hole_angle_multiplier, 1, seed)[0])
    let (y = rands(-w / pencil_hole_angle_multiplier, w / pencil_hole_angle_multiplier, 1, seed + 1/11)[0])
    let (r = sqrt(x * x + y * y))
      (r > w) || find_overlap(so_far, x, y, 0) ? find_next_pencil_hole(so_far, seed + 1/9) : [x, y];

module pencil_holes(count, so_far, seed)
{
  hole_position = find_next_pencil_hole(so_far, seed);
  
  hole_bottom_r = sqrt(hole_position[0] * hole_position[0] + hole_position[1] * hole_position[1]);
  hole_top_r = hole_bottom_r * pencil_hole_angle_multiplier;
  hole_angle_z = atan2(hole_position[1], hole_position[0]);
  
  hole_angle_xy = atan2(hole_top_r - hole_bottom_r, R);

  rotate([0, 0, hole_angle_z])
  translate([hole_bottom_r, 0, top_z - R])
  rotate([0, hole_angle_xy, 0])
  cylinder(R + 10, pencil_hole_radius, pencil_hole_radius, $fn = 40);
  
  if (count > 1)
    pencil_holes(count - 1, concat(so_far, [hole_position]), seed + 1);
}

module shell_with_pencil_holes()
{
  difference()
  {
    shell_with_ballast_chambers();
    pencil_holes(pencil_hole_count, [], 1);
  }
}

difference()
{
  shell_with_pencil_holes();
  
  if (cutaway)
    cube(100);
}