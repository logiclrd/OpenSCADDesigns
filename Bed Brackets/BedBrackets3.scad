depth = 402;
width = 402;

thickness = 20;
height = 10;

total_bed_height = 11;
constrained_bed_height = 9;

heater_pad_gap = 2;

ease_in_width = 1;
ease_in_height = 2;

screw_offset_x = 185;
screw_offset_y = 105;
screw_hole_diameter = 12;

screw_diameter = 3;

module bar(bar_length, interface_side, crossing_offset)
{
  translate([0, 0, height * 0.5])
  union()
  {
    difference()
    {
      // rounding:
      // * middle circle diameter = 3 * thickness
      // * corner circles diameter = 3 * thickness
      intersection()
      {
        union()
        {
          cube([thickness, bar_length + 2 * thickness, height], center = true);
          
          rounding_circle_radius = 1.5 * thickness;
          
          for (bulge_y = [-crossing_offset, crossing_offset])
            translate([0, bulge_y, 0])
            {
              intersection()
              {
                cube([3 * thickness, 3 * thickness, height], center = true);
                cylinder(height + 0.2, rounding_circle_radius, rounding_circle_radius, center = true, $fn = 100);
              }

              rounding_x = 0.5 * thickness + rounding_circle_radius;
              rounding_y = sqrt(4 * rounding_circle_radius * rounding_circle_radius - rounding_x * rounding_x);

              for (dx = [-1, 1])
                for (dy = [-1, 1])
                  difference()
                  {
                    translate([dx * (0.5 * rounding_circle_radius + 0.5 * thickness), dy * rounding_y * 0.75, 0])
                    cube([rounding_circle_radius, 0.5 * rounding_y, height], center = true);
                    
                    translate([dx * rounding_x, dy * rounding_y, 0])
                    cylinder(height + 2.1, rounding_circle_radius, rounding_circle_radius, center = true, $fn = 100);
                  }
            }

          difference()
          {
            union()
            {
              translate([0, -bar_length * 0.5 - thickness * 0.5, 0.5 * total_bed_height + 0.5 * ease_in_height])
              cube([thickness, thickness, height + total_bed_height + ease_in_height], center = true);

              translate([0, bar_length * 0.5 + thickness * 0.5, 0.5 * total_bed_height + 0.5 * ease_in_height])
              cube([thickness, thickness, height + total_bed_height + ease_in_height], center = true);
            }
            
            translate([0, 0, 0.5 * height + 0.5 * (total_bed_height - constrained_bed_height) - 0.01])
            cube([2 * thickness, bar_length + 2 * heater_pad_gap, total_bed_height - constrained_bed_height], center = true);
           
            translate([0, 0, 0.5 * height + total_bed_height])
            multmatrix(
              [[1, 0, 0, -thickness],
               [0, 1, ease_in_width / ease_in_height, -0.5 * bar_length],
               [0, 0, 1, 0],
               [0, 0, 0, 1]])
            {
              cube([2 * thickness, bar_length, ease_in_height]);
            }

            translate([0, 0, 0.5 * height + total_bed_height])
            multmatrix(
              [[1, 0, 0, -thickness],
               [0, 1, -ease_in_width / ease_in_height, -0.5 * bar_length],
               [0, 0, 1, 0],
               [0, 0, 0, 1]])
            {
              cube([2 * thickness, bar_length, ease_in_height]);
            }
          }
        }
        
        cube([4 * thickness, bar_length + 2 * thickness, 4 * height], center = true);
      }
      
      for (translation = [-crossing_offset, +crossing_offset])
      {
        translate([0, translation, 0])
        {
          translate([0, 0, height * 0.25 * interface_side])
          cylinder(height * 0.5, 1.52 * thickness, 1.52 * thickness, center = true);
          
          cylinder(height * 2, 0.5 * screw_hole_diameter, 0.5 * screw_hole_diameter, center = true, $fn = 20);
        }
      }
    }
  }
}

xs = $preview ? [-screw_offset_x, +screw_offset_x] : [0];
ys = $preview ? [-screw_offset_y, +screw_offset_y] : [0];

//*/
color([1, 0.3, 0.6])
for (x = xs)
  translate([x, 0, 0])
    bar(depth, -1, screw_offset_y);
/*/
color([0.3, 1, 0.6])
for (y = ys)
  translate([0, y, 0.1])
    rotate([0, 0, 90])
      bar(depth, 1, screw_offset_x);
/**/

color([0, 0, 0])
if ($preview)
{
  for (y_offset = [-screw_offset_y, +screw_offset_y])
  {
    translate([0, y_offset, 0])
    difference()
    {
      translate([0, 0, -5])
      cube([600, 10, 10], center = true);
      
      translate([screw_offset_x, 0, -13])
      cylinder(30, screw_diameter * 0.5, screw_diameter * 0.5, $fn = 20);
      
      translate([-screw_offset_x, 0, -13])
      cylinder(30, screw_diameter * 0.5, screw_diameter * 0.5, $fn = 20);
    }
  }
}