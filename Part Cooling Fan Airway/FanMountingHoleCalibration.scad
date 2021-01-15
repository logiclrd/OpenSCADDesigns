$fn = 60;

mounting_bracket_fan_attachment_hole_diameter = 3.39; // measured, adjust tolerance
mounting_bracket_fan_attachment_hole_tolerance = 0.08;

for (i = [0 : 7])
{
  tolerance = mounting_bracket_fan_attachment_hole_tolerance + 0.04 * i;
  
  cylinder(i * 4, 0.5 * mounting_bracket_fan_attachment_hole_diameter - 2 * tolerance, 0.5 * mounting_bracket_fan_attachment_hole_diameter - 2 * tolerance);
}

cube([6, 6, 1], center = true);