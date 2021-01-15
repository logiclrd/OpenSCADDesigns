$fn = 60;

mounting_bracket_fan_attachment_hole_diameter = 3.39; // measured, adjust tolerance
mounting_bracket_fan_attachment_hole_tolerance = 0.08;

for (i = [0 : 10])
{
  tolerance = mounting_bracket_fan_attachment_hole_tolerance + 0.05 * i;
  
  cylinder(i * 4, mounting_bracket_fan_attachment_hole_diameter - 2 * tolerance, mounting_bracket_fan_attachment_hole_diameter - 2 * tolerance);
}

cube([10, 10, 1], center = true);