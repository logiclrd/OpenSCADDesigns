// For a side length of 2, the height to the centre of the icosahedron
// is given by this expression:
//
//             ______________
//            √ 5ϕ² + 4ϕ + 1
//   height = ----------------
//                    3
//
// I got this by taking known coordinates for one of the faces of an
// icosahedron, determining that the coordinates had a side length of
// 2, and then using Wolfram Alpha to get an algebraic representation
// of the distance from the centre of the face to the origin. :-)
//
// The other thing we need is the distance from any corner to the
// centre of a triangle with side length 2. Then we can generate said
// triangle using basic trigonometry off the origin. Again, Wolfram 
// Alpha to the rescue.
//                  ______________
//            side √ 2ϕ² - 2ϕ + 1
//   radius = --------------------
//                     3

// Mathematical constant
phi = (1 + sqrt(5))/2;

// Desired size
side = 2;

height = (side / 2) * sqrt(5 * phi * phi + 4 * phi + 1) / 3;
radius = (side / 3) * sqrt(2 * phi * phi - 2 * phi + 1);

d20_wall_thickness = 0.3;

module pyramid(base_radius, base_sides, pyramid_height)
{
  polyhedron(
    [
      for (corner = [1 : base_sides])
        let (angle = corner * 360 / base_sides)
        [base_radius * cos(angle), base_radius * sin(angle), 0],
      
      [0, 0, pyramid_height]
    ],
    [
      // base
      [0, 1, base_sides - 1],
      // sides
      let (top_vertex = base_sides)
      for (side = [1 : base_sides])
        [side % base_sides, (side + 1) % base_sides, top_vertex]
    ]);
}

module text_inset(text, font_size = 10, font = "", flipped, height)
{
  intersection()
  {
    translate([0, 0, height / 2])
    cube([1000, 1000, height], center = true);

    roof()
    {
      scale([flipped ? -1 : +1, 1])
      text(text, font_size, font, halign = "center", valign = "center");
    }
  }
}

module facet(text)
{
  intersection()
  {
    translate([0, 0, d20_wall_thickness / 2])
    cube([1000, 1000, d20_wall_thickness], center = true);

    difference()
    {
      pyramid(
        base_radius = radius,
        base_sides = 3,
        pyramid_height = height);

      rotate([0, 0, -90])
      scale([0.02, 0.02, 0.02])
      text_inset(text, 20, font = "Futura Heavy, Bold", flipped = true, height = 1, $fn = 150);
    }
  }
}

translate([0, -side * 3 / 5, d20_wall_thickness])
facet("20");

translate([0, side * 3 / 5, d20_wall_thickness])
rotate([180, 0, 0])
facet("20");