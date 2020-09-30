wall_thickness = 4;

layer_height = 0.1;

resolution = 6;
circle_points = 400;

base_bevel_xy = 1;
base_bevel_z = 1 * (layer_height * resolution);
body_width = 50;
body_height = 160;
body_neck_transition = 60;
neck_width = 18;
neck_height = 30;

neck_flare_width = 1.5;
neck_flare_height = 6;

base_chamfer_size = 2;
head_chamfer_size = 1;

total_height = body_height + body_neck_transition + neck_height;

module bottle_hull(thickness = 0, bevel_xy = 0, bevel_z = 0, extra_r = 0, extra_z = 0, flare_width = 0, flare_height = 0)
{
  printed_layers = (total_height - thickness + extra_z) / layer_height;

  layer_count = ceil(printed_layers / resolution);

  layer_z = [ for (i = [0 : layer_count]) i * layer_height * resolution + thickness ];

  function contour_at(z) = extra_r + (
    (z < bevel_z)
    ? body_width - (bevel_z - z) * bevel_xy / bevel_z
    : (z <= body_height)
      ? body_width - thickness
      : (z >= total_height - flare_height)
        ? neck_width + flare_width - thickness
        : (z >= body_height + body_neck_transition)
          ? neck_width - thickness
          : (
            (body_width + neck_width) * 0.5 + cos((z - body_height) * 180 / body_neck_transition) * (body_width - neck_width) * 0.5
            -
            (thickness / ((abs(cos((z - body_height) * 180 / body_neck_transition)) > 0.99)
                          ? 1
                          : sqrt(1 + 1/pow((body_width - neck_width) * 0.5 * 180 * sin((z - body_height) * 180 / body_neck_transition) / body_neck_transition, 2))))
            ));

  function contour_thickness_term_at(z) =
    (thickness / sqrt(1 + 1/pow((body_width - neck_width) * 0.5 * 180 * sin(z * 180 / body_neck_transition) / body_neck_transition, 2)));

  angle_at = [ for (i = [0 : circle_points - 1]) i * 360 / circle_points ];

  poly_points =
    [
      for (i = [0 : layer_count])
        for (j = [0 : circle_points - 1])
          let (a = angle_at[j], r = contour_at(layer_z[i]))
            [ cos(a) * r, sin(a) * r, layer_z[i] ]
    ];
        
  poly_faces =
    [
      // Floor
      [ for (i = [0 : circle_points - 1]) i ],
      
      // Sides
      for (i = [1 : layer_count])
        for (j = [0 : circle_points - 1])
          let (ii = i - 1, jj = (j + 1) % circle_points)
            [ ii * circle_points + j, i * circle_points + j, i * circle_points + jj, ii * circle_points + jj ],
        
      // Ceiling
      [ for (i = [1 : circle_points]) circle_points * (layer_count + 1) - i ]
    ];

  polyhedron
  (
    points = poly_points,
    faces = poly_faces
  );
}

module bottle_flat_bottom(hollow = true, bottom_bevel = true)
{
  difference()
  {
    bottle_hull
    (
      bevel_xy = bottom_bevel ? base_bevel_xy : 0,
      bevel_z = bottom_bevel ? base_bevel_z : 0,
      flare_width = neck_flare_width,
      flare_height = neck_flare_height
    );

    if (hollow)
    {
      bottle_hull
      (
        thickness = wall_thickness,
        extra_z = 1
      );
    }
  }
}

////////////////////////////

gap_height = 50;
gap_width_angle = 10;
gap_point_height = 10;

module gap_shape(z, a)
{
  cutout_size = body_width + 10;

  top_bottom_x = cutout_size * cos(a);
  top_bottom_y = cutout_size * sin(a);

  left_x = cutout_size * cos(a - gap_width_angle);
  left_y = cutout_size * sin(a - gap_width_angle);

  right_x = cutout_size * cos(a + gap_width_angle);
  right_y = cutout_size * sin(a + gap_width_angle);

  bottom_z = z;
  top_z = z + gap_height;
  bottom_point_z = bottom_z + gap_point_height;
  top_point_z = top_z - gap_point_height;

  poly_points =
    [
      [top_bottom_x, top_bottom_y, bottom_z],

      [0, 0, bottom_point_z],
      [left_x, left_y, bottom_point_z],
      [right_x, right_y, bottom_point_z],

      [0, 0, top_point_z],
      [left_x, left_y, top_point_z],
      [right_x, right_y, top_point_z],

      [top_bottom_x, top_bottom_y, top_z],
    ];

  poly_faces =
    [
      // left wall
      [0, 1, 2],
      [1, 4, 5, 2],
      [4, 7, 5],

      // right wall
      [0, 3, 1],
      [1, 3, 6, 4],
      [4, 6, 7],
      
      // face
      [0, 2, 5, 7],
      [7, 6, 3, 0]
    ];

  polyhedron
  (
    points = poly_points,
    faces = poly_faces
  );
}

gap_spacing = 4;

circumference = 2 * PI * body_width;

gap_width = circumference * gap_width_angle / 360;
gap_spacing_angle = gap_spacing * 360 / circumference;

base_of_point_z = gap_height - gap_point_height;
gap_spacing_z = gap_spacing * sqrt(3) / 2;

inter_gap_angle = gap_width_angle * 2 + gap_spacing_angle;

module first_gaps()
{
  pattern_start_z = 20;

  first_row_z = pattern_start_z;
  second_row_z = pattern_start_z + base_of_point_z + gap_spacing_z;
  third_row_z = second_row_z + (second_row_z - first_row_z);

  first_row_a = 0;
  second_row_a = gap_width_angle + gap_spacing_angle / 2;
  third_row_a = second_row_a * 2;

  gap_shape(first_row_z, first_row_a + inter_gap_angle);
  gap_shape(second_row_z, second_row_a);
  gap_shape(second_row_z, second_row_a + inter_gap_angle);
  gap_shape(second_row_z, second_row_a + inter_gap_angle * 2);
  gap_shape(third_row_z, third_row_a + inter_gap_angle);
};

module second_gaps()
{
  pattern_start_z = 20 + gap_height / 2;

  first_row_z = pattern_start_z;
  second_row_z = pattern_start_z + base_of_point_z + gap_spacing_z;

  first_row_a = 170;
  second_row_a = first_row_a + gap_width_angle + gap_spacing_angle / 2;

  gap_shape(first_row_z, first_row_a);
  gap_shape(first_row_z, first_row_a + inter_gap_angle);
  gap_shape(second_row_z, second_row_a);
};

module gaps()
{
  first_gaps();
  second_gaps();
}

////////////////////////////

base_round_margin = wall_thickness * 1.5;
base_round_radius = body_width - base_round_margin;
base_sphere_radius = base_round_radius + 100;
base_sphere_z = -sqrt(base_sphere_radius * base_sphere_radius - base_round_radius * base_round_radius);
base_sphere_chop_off_size = 2.1 * base_sphere_radius;
base_pip_size = 1.2;
base_pip_exposed = base_pip_size * 0.7;
base_pip_count = 100;

module bottle_curved_bottom(hollow = true, bottom_bevel = true)
{
  difference()
  {
    union()
    {
      bottle_flat_bottom
      (
        hollow = hollow,
        bottom_bevel = bottom_bevel
      );

      intersection()
      {
        translate([ 0, 0, base_sphere_z ]) sphere(r = base_sphere_radius + wall_thickness, $fn = circle_points);
        bottle_flat_bottom
        (
          hollow = false,
          bottom_bevel = true
        );
      }
    }
    
    translate([ 0, 0, base_sphere_z ]) sphere(r = base_sphere_radius, $fn = circle_points);
  }
}

module base_pips(pip_size_xy, pip_size_z, pip_exposed)
{
  pip_radius = body_width - base_round_margin * 0.5;

  for (i = [1 : base_pip_count])
  {
    pip_angle = i * 360 / base_pip_count;

    pip_x = pip_radius * cos(pip_angle);
    pip_y = pip_radius * sin(pip_angle);

    translate([ pip_x, pip_y, pip_size_z - pip_exposed])
    scale([ pip_size_xy / pip_size_z, pip_size_xy / pip_size_z, 1 ])
    sphere(r = pip_size_z, $fn = 40);
  }
}

module bottle_curved_bottom_pips
(
  hollow = true,
  bottom_bevel = true,
  pip_size = 0,
  pip_size_xy = 0,
  pip_size_z = 0,
  pip_exposed = 0
)
{
  union()
  {
    bottle_curved_bottom
    (
      hollow = hollow,
      bottom_bevel = bottom_bevel
    );

    base_pips
    (
      pip_size_xy = 
        pip_size_xy ? pip_size_xy
        : pip_size ? pip_size
        : base_pip_size,
      pip_size_z =
        pip_size_z ? pip_size_z
        : pip_size ? pip_size
        : base_pip_size,
      pip_exposed = pip_exposed ? pip_exposed : base_pip_exposed
    );
  }
}

////////////////////////////

support_gap = 3 * layer_height;

module support()
{
  stock_size = body_width * 2.1;

  translate([0, 0, -support_gap])
  intersection()
  {
    difference()
    {
      cube(size = stock_size, center = true);
      bottle_curved_bottom_pips
      (
        hollow = false,
        bottom_bevel = false,
        pip_size_xy = base_pip_size + 0.5,
        pip_size_z = base_pip_size
      );
    }

    translate([ 0, 0, -base_pip_size ]) bottle_hull(extra_r = -0.1);
  }
}

////////////////////////////

union()
{
  difference()
  {
    bottle_curved_bottom_pips();
    gaps();
  }

  support();
}
