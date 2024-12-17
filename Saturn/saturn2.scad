saturn_diameter = 30;
rings_diameter = 60;
fillet_size = 5;

// The shape we are reproducing here, to match the original saturn.scad, is the result of filleting a
// proto-Saturn that consists of a sphere of size saturn_diameter with a disc of height 2 (y = [-1 : +1])
// with a sphere of size fillet_size.
//
// Some math:
//
// If we take a cross-section from the side, then we have a circle at the origin of size saturn_diameter,
// and a line at y = 1, and the fillet will be the arc that joins the circle with the line, above the line.
// This means the fillet is described by a circle of diameter fillet_size whose center is at
// y = 1 + fillet_size / 2, and we need to figure out two things to make the fillet join to the main
// circle smoothly:
//
// - What is the x coordinate of the circle's center? This is required to make the two circles touch at
//   exactly one point.
// - What is the angle from the fillet circle's center to the point of intersection with the larger circle?
//   This is required to know exactly where to stop the fillet. (The other end is simple; we stop at exactly
//   y = 1).
//
// To compute the first unknown, consider that the distance from this point to the origin is known. It will
// be the sum of the radii of the two circles, or (saturn_diameter + fillet_size) / 2.

fillet_circle_center_distance_from_origin = (saturn_diameter + fillet_size) / 2;

// We can figure out exactly where it is using the second unknown, which is the angle of the point of intersection. The centre
// of the fillet circle will be colinear with the point of intersection and the origin, and we know the
// height of the centre of the fillet circle. So:

fillet_circle_y = 1 + fillet_size / 2;

// fillet_circle_y = sin(Angle) * fillet_circle_center_distance_from_origin
// fillet_circle_y / fillet_circle_center_distance_from_origin = sin(fillet_circle_angle)
//
// Now we can take arcsine of both sides.

fillet_circle_angle = asin(fillet_circle_y / fillet_circle_center_distance_from_origin);

// Plugging that in, we can compute the missing X coordinate for the centre of the fillet circle:

fillet_circle_x = cos(fillet_circle_angle) * fillet_circle_center_distance_from_origin;

module test_math()
{
  $fn = 50;

  circle(d = saturn_diameter);
  square([rings_diameter, 2], center = true);

  color("yellow")
  translate([fillet_circle_x, fillet_circle_y, 0])
  circle(d = fillet_size);
}

// Now we can start generating points and faces. :-)
saturn_radius = 0.5 * saturn_diameter;
rings_radius = 0.5 * rings_diameter;
fillet_radius = 0.5 * fillet_size;
fillet_circle_angle_inner = 90 - fillet_circle_angle;

module test_points(points)
{
  for (position = points)
    translate(position)
    sphere(d = 1);
}

module saturn_top_half(sections, fillet_bands, planet_bands, test_points)
{
  points =
    [
      // Outer edge of rings.
      for (section = [1 : sections])
        let (angle = section * 360 / sections)
        [(rings_radius + fillet_radius) * cos(angle), (rings_radius + fillet_radius) * sin(angle), 0],

      // Outer edge of top surface of rings.
      for (section = [1 : sections])
        let (angle = section * 360 / sections)
        [rings_radius * cos(angle), rings_radius * sin(angle), 1],

      // Fillet
      for (band = [1 : fillet_bands])
        for (section = [1 : sections])
          let (z_angle = section * 360 / sections)
          let (x_angle = (band - 1) * fillet_circle_angle_inner / (fillet_bands - 1))
          let (fillet_point_x = fillet_circle_x - fillet_radius * sin(x_angle))
          let (fillet_point_y = fillet_circle_y - fillet_radius * cos(x_angle))
          [fillet_point_x * cos(z_angle), fillet_point_x * sin(z_angle), fillet_point_y],

      // Remainder of planet
      for (band = [1 : planet_bands - 1])
        for (section = [1 : sections])
          let (z_angle = section * 360 / sections)
          let (x_angle = (planet_bands - band) * fillet_circle_angle_inner / (planet_bands - 1))
          let (saturn_point_x = saturn_radius * sin(x_angle))
          let (saturn_point_y = saturn_radius * cos(x_angle))
          [saturn_point_x * cos(z_angle), saturn_point_x * sin(z_angle), saturn_point_y],

      // The final planet "band" would produce all identical points. We only need one of these.abs
      [0, 0, saturn_radius]
    ];

  faces =
    [
      // All points except the last are in "bands" of points, with count sections.
      for (band = [0 : fillet_bands + planet_bands - 1])
        let (band_offset = band * sections)
        for (section = [0 : sections - 1])
          let (next_section = (section + 1) % sections)
          [band_offset + section, band_offset + next_section, band_offset + next_section + sections, band_offset + section + sections],

      // The final "band" would be all identical points, so they're just a single entry in the points set.
      let (last_band = fillet_bands + planet_bands + 1)
      let (final_point = sections * last_band)
      let (band_offset = (last_band - 1) * sections)
      for (section = [0 : sections - 1])
        let (next_section = (section + 1) % sections)
        [band_offset + section, band_offset + next_section, final_point],

      // Close off the bottom.
      [ for (i = [0 : sections - 1]) i ]
    ];

  if (test_points)
    test_points(points);

  polyhedron(points, faces);
}

module saturn_bottom_half(sections, fillet_bands, planet_bands, test_points)
{
  scale([1, 1, -1])
  saturn_top_half(sections, fillet_bands, planet_bands, test_points);
}

module saturn(sections = 10, fillet_bands = 3, planet_bands = 5, test_points = false)
{
  union()
  {
    saturn_top_half(sections, fillet_bands, planet_bands, test_points);
    saturn_bottom_half(sections, fillet_bands, planet_bands, test_points);
  }
}

translate([0, 0, 50])
saturn(test_points = true);

for (i = [1 : 3])
  let (detail_level = i * i)
  translate([(i - 1) * 70, 0, 0])
  saturn(detail_level * 10, detail_level * 3, detail_level * 5);
