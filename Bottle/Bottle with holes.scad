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

layer_height = 0.1;

resolution = 6;
circle_points = 400;

module bottle_hull(thickness, extra_z, flare_width, flare_height)
{
  printed_layers = (total_height - thickness + extra_z) / layer_height;

  layer_count = ceil(printed_layers / resolution);

  layer_z = [ for (i = [0 : layer_count]) i * layer_height * resolution + thickness ];

  function contour_at(z) =
    (z <= body_height)
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
          );

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

module bottle()
{
  difference()
  {
    bottle_hull(0, 0, neck_flare_width, neck_flare_height);
    bottle_hull(4, 1, 0, 0);
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

difference()
{
  bottle();
  gaps();
}
