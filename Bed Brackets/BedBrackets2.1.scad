depth = 402;
width = 402;

thickness = 20;
height = 10;

total_bed_height = 11;
constrained_bed_height = 9;

center_square_size = 140;

heater_pad_gap = 2;

ease_in_width = 1;
ease_in_height = 2;

module bar(bar_length, interface_side, crossing_offsets)
{
  union()
  {
    difference()
    {
      cube([thickness, bar_length + 2 * thickness, height], center = true);
      
      for (crossing_offset = crossing_offsets)
      {
        translation = 
          + (crossing_offset == 0
             ? 0
             : sign(crossing_offset) * 0.5 * (center_square_size + thickness) + crossing_offset);
        
        translate([0, translation, height * 0.5 * interface_side])
        cube([2 * thickness, thickness, height], center = true);
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
      
      translate([0, 0, 0.5 * height + 0.5 * (total_bed_height - constrained_bed_height)])
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
}

rotate([0, 90, 0])
bar(depth, 1, [1, -1]);
//bar(width, -1, [10, -10]);
if ($preview)
{
  translate([0, -110, 0])
  cube([10, 10, 400], center = true);
  translate([0, 110, 0])
  cube([10, 10, 400], center = true);
}