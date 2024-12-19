module simple_loft(shapes)
{
  shape_count = len(shapes);
  shape_size = len(shapes[0]);

  for (shape = shapes)
    assert(len(shape) == shape_size);

  points =
    [
      for (shape = shapes)
        for (pt = shape)
          pt,
    ];

  e = shape_size * shape_count + 1;

  faces =
    [
      [ for (n = [0 : shape_size]) shape_size - n % shape_size ],

      for (i = [1 : shape_count - 1])
      let (o = (i - 1) * shape_size)
      let (p = o + shape_size)
      for (n = [0 : shape_size - 1])
        let (m = (n + 1) % shape_size)
        [ o + n, o + m, p + m, p + n],

      let (l = (shape_count - 1) * shape_size)
      [ for (n = [0 : shape_size]) l + (n % shape_size) ]
    ];

  polyhedron(points, faces);
}

function arc_points(centre, radius, start_angle, end_angle, num_points)
= [
    for (i = [0 : num_points - 1])
      let (t = i / (num_points - 1))
      let (angle = start_angle + t * (end_angle - start_angle))
      [ centre[0] + radius * sin(angle), centre[1] + radius * cos(angle), centre[2] ]
  ];

function shape(z, basin_size, spout_width, spout_length_at_base, spout_angle, offset, corner_faces)
= let (o = z * cos(spout_angle) + spout_length_at_base)
  let (p = offset / sqrt(2))
  let (q = spout_width / sqrt(2))
  concat(
    [[-offset, 0, z], [-offset, basin_size, z]],
    arc_points([0, basin_size + 0, z], offset, 270, 360, corner_faces + 1),
    [[basin_size - q - p + 0, basin_size + offset, z], [basin_size - q - p + o, basin_size + offset + o, z]],
    arc_points([basin_size - q + o, basin_size + offset + o - p, z], offset, 315, 405, corner_faces + 1),
    arc_points([basin_size + offset + o - p, basin_size - q + o, z], offset, 45, 135, corner_faces + 1),
    [[basin_size + offset + o, basin_size - q - p + o, z], [basin_size + offset, basin_size - q - p, z]],
    arc_points([basin_size, 0, z], offset, 90, 180, corner_faces + 1),
    arc_points([0, 0, z], offset, 180, 270, corner_faces + 1));

module cup(height, flare, basin_size, spout_width, spout_length_at_base, spout_angle,, wall_thickness, corner_faces)
{
  difference()
  {
    simple_loft(
      [
        shape(0, basin_size, spout_width, spout_length_at_base, spout_angle,, offset = 0, corner_faces = corner_faces),
        shape(height, basin_size, spout_width, spout_length_at_base, spout_angle, offset = flare, corner_faces = corner_faces)
      ]);

    difference()
    {
      translate([wall_thickness, wall_thickness, 0.01])
      simple_loft(
        [
          shape(0, basin_size - wall_thickness * 2, spout_width - wall_thickness * 2, spout_length_at_base - wall_thickness / 2, spout_angle,, offset = 0, corner_faces = corner_faces),
          shape(height, basin_size - wall_thickness * 2, spout_width - wall_thickness * 2, spout_length_at_base - wall_thickness / 2, spout_angle, offset = flare, corner_faces = corner_faces)
        ]);

      mx = 2 * (basin_size + spout_width + spout_length_at_base + height);

      cube([mx, mx, 2 * wall_thickness], center = true);
    }
  }
}

for (row = [0 : 3])
  for (column = [0 : 3])
  {
    translate([column * 80, row * 60, 0])
    cup(
      height = 15 + row * 10,
      flare = 5,
      basin_size = 35,
      spout_width = 15,
      spout_length_at_base = 5,
      spout_angle = 45 + row * 10,
      wall_thickness = 2,
      corner_faces = column * column + 1);
  }

for (row = [0 : 3])
  for (column = [0 : 3])
  {
    translate([column * 80, row * 60 - 300, 0])
    cup(
      height = 15,
      flare = 5,
      basin_size = 25 + row * 5,
      spout_width = 15 + row * 3,
      spout_length_at_base = 5,
      spout_angle = 45 + row * 10,
      wall_thickness = 2,
      corner_faces = 25);
  }
