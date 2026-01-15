frog_width_mm = 53.1;
frog_depth_mm = 51.0;
platform_width_mm = 40;
platform_thickness_mm = 1;

import("froggo.stl");

translate([frog_width_mm * 0.5, platform_width_mm * 0.5 - 2, 0])
linear_extrude(height = platform_thickness_mm)
circle(d = platform_width_mm);