$fn = 400;

start_fitting_start_thickness = 5.5;
start_fitting_end_thickness = 4.5;

start_outer_mm = 200.4;
start_inner_mm = start_outer_mm - start_fitting_start_thickness * 2;

echo(start_inner_mm);
start_thickness = (start_outer_mm - start_inner_mm) / 2;
end_outer_mm = (5.75 + 1/32) * 25.4 + 1.2;
end_inner_mm = 144;
end_thickness = (end_outer_mm - end_inner_mm) / 2;
length = 225;
fitting_depth = 15;
wall = 4;
columns = 360;
rows = length;

difference()
{
  polyhedron(
    points =
    [
      for (row = [1 : rows])
        let (i = (row - 1) / (rows - 1))
        let (y = i * length)
        let (tt = (y < fitting_depth) ? 0
                : (y > length - fitting_depth) ? 1
                : ((y - fitting_depth) / (length - 2 * fitting_depth)))
        let (t = (sin(tt * 180 + 270) + 1) / 2)
        let (outer_d = start_outer_mm + (end_outer_mm - start_outer_mm) * t + wall)
        let (inner_d = start_inner_mm + (end_inner_mm - start_inner_mm) * t - wall)
        let (outer_r = outer_d / 2)
        let (inner_r = inner_d / 2)
        for (r = [outer_r, inner_r])
          let (direction = (r == outer_r) ? 1 : -1)
          for (column = [1 : columns])
            let (a = column * 360 / columns)
            [r * cos(a * direction), r * sin(a * direction), y],
    ],
    faces =
    [
      for (row = [2 : rows])
        let (outer_lower_start = (row - 2) * columns * 2)
        let (inner_lower_start = (row - 2) * columns * 2 + columns)
        for (lower_start = [outer_lower_start, inner_lower_start])
          let (upper_start = lower_start + columns * 2)
          for (column = [0 : columns - 1])
            let (next_column = (column + 1) % columns)
            [lower_start + column, upper_start + column, upper_start + next_column, lower_start + next_column],
            
      // Bottom cap
      for (column = [0 : columns - 1])
        let (top_left = column)
        let (top_right = (column + 1) % columns)
        let (bottom_left = 2 * columns - top_right - 1)
        let (bottom_right = (bottom_left + columns - 1) % columns + columns)
        [top_left, top_right, bottom_right, bottom_left],

      // Top cap
      let (last = (rows - 1) * (columns * 2))
      for (column = [0 : columns - 1])
        let (top_left = column)
        let (top_right = (column + 1) % columns)
        let (bottom_left = 2 * columns - top_right - 1)
        let (bottom_right = (bottom_left + columns - 1) % columns + columns)
        [last + top_right, last + top_left, last + bottom_left, last + bottom_right]
    ],
    convexity = 4);
  
  rotate_extrude()
  {
    translate([start_inner_mm / 2, 0, 0])
    union()
    {
      let (camber = start_fitting_start_thickness - start_fitting_end_thickness)
      polygon(
        [
          [0, -1],
          [0, 0],
          [camber / 2, fitting_depth],
          [camber / 2 + start_fitting_end_thickness, fitting_depth],
          [start_fitting_start_thickness, 0],
          [start_fitting_start_thickness, -1]
        ]);
    
      translate([start_fitting_start_thickness / 2, fitting_depth, 0])
      circle(d = start_fitting_end_thickness);
    }
  }
  
  translate([0, 0, length - fitting_depth])
  rotate_extrude()
  {
    translate([end_inner_mm / 2, 0, 0])
    union()
    {
      square([end_thickness, fitting_depth + 2]);
    
      translate([end_thickness / 2, 0])
      circle(d = end_thickness);
    }
  }
  
  translate([-2, -start_inner_mm / 2 - 0.9, -1])
  cube([4, 3, fitting_depth]);
}
