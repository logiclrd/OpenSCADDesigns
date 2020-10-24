$fn = 100;

wall_thickness = 1.2;
swoop_thickness = 0.4;
swoop_start = 3;
swoop_stop = 14;
outer_height = 23;
inner_height = 29;
bottom_diameter = 14;
top_outer_diameter = 17.5;
inner_taper_height = 11;
inner_diameter = 8.75;
taper_exponent = 2.5;
vent_width = 1.5;
vent_depth = 1;
rib_count = 3;
rib_full_bridge_height = 13;
rib_unbridged_depth = 1.8;
rib_top_offset = 0.8;
top_attachment_diameter = 9.25;
top_attachment_taper_amount = 0.72;

/*

  |  |
  |  |
   |  |
   |  |
    |  |
    |  |
     |  |
     |.-|
      |  |
      |  |
       |  |
       |  |
        |  |
        |  |

separation * cos(a) = wall_thickness

a = atan((top_outer_diameter - bottom_outer_diameter) / outer_height)
separation = wall_thickness / cos(a)

*/

module outer_shell()
{
  difference()
  {
    a = atan((top_outer_diameter - bottom_diameter) / outer_height);
    
    separation = wall_thickness / cos(a);
    
    cylinder(outer_height, bottom_diameter * 0.5 + separation, top_outer_diameter * 0.5 + separation);
    cylinder(outer_height, bottom_diameter * 0.5, top_outer_diameter * 0.5);
  }
}

module outer_shell_swoop()
{
  difference()
  {
    a = atan((top_outer_diameter - bottom_diameter) / outer_height);
    
    separation = wall_thickness / cos(a);
    
    cylinder(outer_height, bottom_diameter * 0.5 + separation + swoop_thickness, top_outer_diameter * 0.5 + separation);
    cylinder(outer_height, bottom_diameter * 0.5, top_outer_diameter * 0.5);
    
    effective_bottom_diameter = bottom_diameter + (separation + swoop_thickness) * 2;
    effective_top_diameter = top_outer_diameter + separation * 2;
    
    radius_at_swoop_start = 0.5 * (effective_bottom_diameter * (outer_height - swoop_start) + effective_top_diameter * swoop_start) / outer_height;
    radius_at_swoop_stop = 0.5 * (effective_bottom_diameter * (outer_height - swoop_stop) + effective_top_diameter * swoop_stop) / outer_height;
    
    swoop_angle = atan((radius_at_swoop_stop + radius_at_swoop_start) / (swoop_stop - swoop_start));
    
    translate([-radius_at_swoop_stop, 0, swoop_stop])
    rotate([0, -swoop_angle, 0])
    translate([-50, 0, -50])
    cube(100, center = true);
  }
}

module inner_shell_top()
{
  union()
  {
    intersection()
    {
      translate([0, 0, inner_taper_height])
      difference()
      {
        cylinder(inner_height - inner_taper_height + wall_thickness, inner_diameter * 0.5 + wall_thickness, inner_diameter * 0.5 + wall_thickness);
        cylinder(inner_height - inner_taper_height, inner_diameter * 0.5, inner_diameter * 0.5);
      }
      
      union()
      {
        difference()
        {
          translate([0, 0, outer_height])
          cylinder(inner_height - outer_height + wall_thickness, 0.5 * top_attachment_diameter, 0.5 * top_attachment_diameter);
          
          translate([0, 0, inner_height - 1 + wall_thickness])
          difference()
          {
            cylinder(1, bottom_diameter * 0.5, bottom_diameter * 0.5);
            cylinder(1, top_attachment_diameter * 0.5, top_attachment_diameter * 0.5 - top_attachment_taper_amount);
          }
        }
        
        cylinder(outer_height, 0.5 * bottom_diameter, 0.5 * bottom_diameter);
      }
    }

    translate([0, 0, outer_height - 1])
    difference()
    {
      cylinder(inner_height - outer_height + 1, 0.5 * top_attachment_diameter, 0.5 * top_attachment_diameter);
      cylinder(inner_height - outer_height + 1, 0.5 * top_attachment_diameter - wall_thickness, 0.5 * top_attachment_diameter - wall_thickness);
    }

    translate([0, 0, outer_height - 2])
    difference()
    {
      cylinder(1, 0.5 * top_attachment_diameter, 0.5 * top_attachment_diameter);
      cylinder(1, 0.5 * top_attachment_diameter, 0.5 * top_attachment_diameter - wall_thickness);
    }
  }
}

function interpolate(a, from, to) =
  (from * (1 - a) + to * a);

function radius_at(z) =
  let (z_i = (inner_taper_height - z) / inner_taper_height)
    0.5 * interpolate(pow(z_i, taper_exponent), inner_diameter, bottom_diameter);

// f(x) = x^t
// f'(x) = t * x^(t - 1)
//

function slope_at(z) =
  let (z_i = (inner_taper_height - z) / inner_taper_height)
    0.5 * taper_exponent * pow(z_i, taper_exponent - 1) * (bottom_diameter - inner_diameter) / inner_taper_height;

function slope_angle_at(z) =
  let (slope = slope_at(z))
    atan2(slope, 1);

function normal_angle_at(z) =
  slope_angle_at(z) + 90;

module inner_shell_shape(cutout)
{
  ring_points = $fn;
  rings = ($fn + 1);
  shell_points = rings * ring_points;
  
  points = 
      [
        for (z_i = [0 : rings - 1])
          let (z = inner_taper_height - z_i * inner_taper_height / $fn)
          let (r = radius_at(z))
            for (a_i = [1 : ring_points])
              let(a = a_i * 360 / $fn)
                [r * cos(a), r * sin(a), z],

        for (z_i = [0 : rings - 1])
          let (z = inner_taper_height - z_i * inner_taper_height / $fn)
          let (ta = normal_angle_at(z))
          let (r = cutout ? 100 : radius_at(z))
          let (tr = r + wall_thickness * sin(ta))
            for (a_i = [1 : ring_points])
              let(a = a_i * 360 / $fn)
                [tr * cos(a), tr * sin(a), z - wall_thickness * cos(ta)]
      ];
  
  top_wall =
    [
      for (a_i = [1 : ring_points])
        let (a_i_1 = (a_i % ring_points) + 1)
          [a_i - 1, a_i_1 - 1, a_i_1 + shell_points - 1, a_i + shell_points - 1]
    ];

  bottom_wall =
    [
      for (b_i = [1 : ring_points])
        let (b_i_1 = (b_i % ring_points) + 1)
        let (a_i = b_i + ring_points * (rings - 1))
        let (a_i_1 = b_i_1 + ring_points * (rings - 1))
          [a_i_1 - 1, a_i - 1, a_i + shell_points - 1, a_i_1 + shell_points - 1]
    ];

  inner_surface =
    [
      for (strip = [1 : rings - 1])
        let (strip_start = (strip - 1) * ring_points)
          for (a_i = [1 : ring_points])
            let (a_i_1 = (a_i % ring_points) + 1)
              [strip_start + a_i_1 - 1, strip_start + a_i - 1, strip_start + a_i + ring_points - 1, strip_start + a_i_1 + ring_points - 1]
    ];

  outer_surface =
    [
      for (strip = [1 : rings - 1])
        let (strip_start = shell_points + (strip - 1) * ring_points)
          for (a_i = [1 : ring_points])
            let (a_i_1 = (a_i % ring_points) + 1)
              [strip_start + a_i - 1, strip_start + a_i_1 - 1, strip_start + a_i_1 + ring_points - 1, strip_start + a_i + ring_points - 1]
    ];

  polyhedron(
    points = points,
    faces =
      [
        each top_wall,
        each bottom_wall,
        each inner_surface,
        each outer_surface,
      ]
  );
}

module inner_shell_cutout()
{
  union()
  {
    difference()
    {
      r = 0.5 * top_outer_diameter + 2 * wall_thickness;
      
      cylinder(inner_taper_height, r, r);
      
      inner_shell_shape(cutout = true);
    }
    
    translate([0, 0, inner_taper_height])
    cylinder(inner_height - inner_taper_height, inner_diameter * 0.5, inner_diameter * 0.5);
  }
}

module inner_shell_bottom()
{
  inner_shell_shape(cutout = false);
}

module inner_shell_bottom_with_vents()
{
  difference()
  {
    inner_shell_bottom();
    
    for (vent = [1 : 6])
    {
      vent_angle = vent * 60;
      
      rotate([0, 0, vent_angle])
      translate([bottom_diameter * 0.5 - vent_depth, -0.5 * vent_width, 0])
      cube([vent_depth, vent_width, inner_height]);
    }
  }
}

module ribs()
{
  difference()
  {
    union()
    {
      for (rib = [1 : rib_count])
      {
        rib_angle = 30 + rib * 360 / rib_count;
        
        skew =
          [ [ 1, 0, 0.5 * (top_outer_diameter - bottom_diameter) / outer_height, 0 ],
            [ 0, 1, 0, 0 ],
            [ 0, 0, 1, 0 ],
            [ 0, 0, 0, 1 ] ];
        
        rotate([0, 0, rib_angle])
        multmatrix(skew)
        union()
        {
          translate([0.5 * bottom_diameter - rib_unbridged_depth, -0.5 * wall_thickness, 0])
          cube([rib_unbridged_depth + wall_thickness * 0.5, wall_thickness, outer_height - rib_top_offset]);
          
          translate([0, -0.5 * wall_thickness, 0])
          cube([0.5 * bottom_diameter, wall_thickness, rib_full_bridge_height]);
        }
      }
    }
    
    inner_shell_cutout();
  }
}

union()
{
  outer_shell();
  outer_shell_swoop();
  inner_shell_top();
  inner_shell_bottom_with_vents();
  ribs();
}