peg_diameter_mm = 3.6;
peg_spacing_mm = 52;
peg_height_mm = 4.5;
step_height_mm = 4;

for (i = [0 : 2])
{
  translate([i * peg_spacing_mm, 0, 0])
  {
    cylinder(peg_height_mm + step_height_mm, d = peg_diameter_mm, $fn = 50);
    
    intersection()
    {
      rotate([0, 0, 360 / 16])
      cylinder(peg_height_mm + step_height_mm, d = peg_diameter_mm / cos(360 / 16), $fn = 8);
      
      q = peg_diameter_mm * (0.5 - 0.5 / sqrt(2));
      translate([-0.5 * peg_diameter_mm, peg_diameter_mm * 0.5 - q, 0])
      cube([peg_diameter_mm, q, peg_height_mm * step_height_mm]);
    }
  }
}

translate([0, -0.5 * peg_diameter_mm, peg_height_mm])
cube([2 * peg_spacing_mm, peg_diameter_mm, step_height_mm]);
