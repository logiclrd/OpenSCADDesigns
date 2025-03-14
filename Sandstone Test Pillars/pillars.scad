base_height_mm = 5;
grid_cell_width_mm = 25;
grid_cell_height_mm = 15;
grid_cells_x = 11;
grid_cells_y = 11;
min_tower_diameter_mm = 1;
max_tower_diameter_mm = 3;

// Set seed.
x = rands(0, 0, 0, 1);

function hsv2rgb(h, s=1, v=1) = let(
    h = h / 360,
    i = floor(h * 6),
    f = h * 6 - i,
    p = v * (1 - s),
    q = v * (1 - f * s),
    t = v * (1 - (1 - f) * s)
) i % 6 == 0 ? [v, t, p] :
  i == 1 ? [q, v, p] :
  i == 2 ? [p, v, t] :
  i == 3 ? [p, q, v] :
  i == 4 ? [t, p, v] :
           [v, p, q];

module pillar(x, y)
{
  translate([x * grid_cell_width_mm + 1 + max_tower_diameter_mm, y * grid_cell_height_mm + 6, 0])
  {
    diameter = rands(min_tower_diameter_mm, max_tower_diameter_mm, 1)[0];
    height = rands(10, 30, 1)[0];
    is_round = rands(0, 2, 1)[0] < 1;
    
    color("blue")
    translate([1.5 + max_tower_diameter_mm / 2, 0, -1])
    intersection()
    {
      linear_extrude(1.2)
      text(str(diameter + 0.005), size = 5);
      translate([0, 0, -1])
      cube([13.5, 10, 10]);
    }
    
    color("blue")
    translate([0, -5, -1])
    intersection()
    {
      linear_extrude(1.2)
      text(str(height + 0.005), size = 4);
      translate([0, 0, -1])
      cube([14, 10, 10]);
    }
    
    hue = rands(0, 360, 1)[0];
    saturation = rands(0.5, 1, 1)[0];
    value = rands(0.5, 1, 1)[0];
    
    color(c = hsv2rgb(hue, saturation, value))
    if (is_round)
      cylinder(h = height, d = diameter, $fn = 60);
    else
      cube([diameter, diameter, height]);
  }
}

color("white")
cube([grid_cells_x * grid_cell_width_mm, grid_cells_y * grid_cell_height_mm, base_height_mm]);

translate([0, 0, base_height_mm])
for (x = [0 : 1 : grid_cells_x - 1])
  for (y = [0 : 1 : grid_cells_y - 1])
    pillar(x, y);