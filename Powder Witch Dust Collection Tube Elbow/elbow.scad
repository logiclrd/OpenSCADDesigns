side_inner_diameter_mm = 98;
top_inner_diameter_mm = 82;
bend_radius_mm = 10;
wall_thickness_mm = 4;

input_length_mm = 25;
output_length_mm = 30;

sweep_slices = 60;
slice_points = 200;

function interpolate(t, from, to)
  = let(tt = (1 - cos(t * 180)) / 2)
    tt * to + (1 - tt) * from;

function gen_skin_points(side_diameter_mm, top_diameter_mm)
  = let(
      sweep_points =
        [
          for (i = [0 : sweep_slices])
            let (sweep_t = i / sweep_slices)
            let (sweep_angle = sweep_t * 90)
            let (common_diameter = interpolate(sweep_t, side_inner_diameter_mm, top_inner_diameter_mm))
            let (diameter = interpolate(sweep_t, side_diameter_mm, top_diameter_mm))
            let (common_radius = common_diameter / 2)
            let (radius = diameter / 2)
            for (j = [0 : slice_points - 1])
              let (slice_angle = j * 360 / slice_points)
              let (x = cos(slice_angle) * radius)
              let (y = sin(slice_angle) * radius)
              let (x2 = x - common_radius - bend_radius_mm)
              let (y2 = y)
              let (z2 = 0)
              let (x3 = x2 * cos(sweep_angle) - z2 * sin(sweep_angle))
              let (y3 = y)
              let (z3 = x2 * sin(sweep_angle) + z2 * cos(sweep_angle))
                [ x3, y3, z3 ]
        ])
      [
        for (i = [0 : slice_points - 1])
          let (sweep_point = sweep_points[i])
          [sweep_point[0], sweep_point[1], sweep_point[2] + output_length_mm],

        for (sweep_point = sweep_points)
          sweep_point,

        let (o = sweep_slices * slice_points)
        for (i = [0 : slice_points - 1])
          let (sweep_point = sweep_points[o + i])
          [sweep_point[0] + input_length_mm, sweep_point[1], sweep_point[2]],
      ];

points = concat(
  gen_skin_points(side_inner_diameter_mm, top_inner_diameter_mm),
  gen_skin_points(side_inner_diameter_mm + wall_thickness_mm, top_inner_diameter_mm + wall_thickness_mm));

faces =
  [
    for (i = [0 : sweep_slices + 1])
      let (p = i * slice_points)
      let (o = (i + 1) * slice_points)
      for (j = [0 : slice_points  -1])
        let (k = (j + 1) % slice_points)
        [ o + j, o + k, p + k, p + j],

    let (m = (sweep_slices + 3) * slice_points)
    for (i = [0 : sweep_slices + 1])
      let (o = m + i * slice_points)
      let (p = m + (i + 1) * slice_points)
      for (j = [0 : slice_points  -1])
        let (k = (j + 1) % slice_points)
        [ o + j, o + k, p + k, p + j],

    let (m = (sweep_slices + 3) * slice_points)
    for (i = [0 : slice_points - 1])
      let (j = (i + 1) % slice_points)
      [ i, m + i, m + j, j],

    let (m = (sweep_slices + 3) * slice_points)
    let (o = (sweep_slices + 2) * slice_points)
    for (i = [0 : slice_points - 1])
      let (j = (i + 1) % slice_points)
      [ o + j, o + m + j, o + m + i, o + i],
  ];

polyhedron(points, faces);
