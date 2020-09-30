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

resolution = 10;
circle_points = 150;

module bottle(thickness, extra_z, flare_width, flare_height)
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

difference()
{
  bottle(0, 0, neck_flare_width, neck_flare_height);
  bottle(4, 1, 0, 0);
}