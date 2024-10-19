show_cutaway = true;

// Unit: inches
cabinet_width = 30;
cabinet_depth = 20;
cabinet_height = 36;
wall_thickness = 0.5;
door_height_y = 15;
door_angle = 15;
platform_y = 11;
reclaimed_powder_chute_diameter = 4;
reclaimed_powder_chute_inset = 8;
reclaimed_powder_channel_width = 10;
reclaimed_powder_channel_depth = 18.5;

module cabinet_top_and_walls(inset)
{
  door_cutout_depth = cabinet_depth + cabinet_height;
  door_cutout_height = cabinet_height / sin(door_angle) + 10;

  difference()
  {
    translate([0, 0, -0.5 * inset])
    cube([cabinet_width - 2 * inset, cabinet_depth - 2 * inset, cabinet_height - inset], center = true);
    
    translate([0, -0.5 * cabinet_depth, 0.5 * cabinet_height - wall_thickness - door_height_y])
    rotate([-door_angle, 0, 0])
    translate([0, -0.5 * door_cutout_depth, 0])
    cube([cabinet_width + 10, door_cutout_depth, door_cutout_height], center = true);
    
    translate([0, -0.5 * cabinet_depth, 0.5 * platform_y - 0.5 * cabinet_height])
    cube([reclaimed_powder_channel_width, 2 * wall_thickness, platform_y], center = true);
  }
}

cutaway_height = door_height_y + wall_thickness;
cutaway_inset = cutaway_height * tan(door_angle);

module opening()
{  
  translate([0, -cabinet_depth + cutaway_inset, 0.5 * cabinet_height- 0.5 * door_height_y - 0.5 * wall_thickness])
  cube([cabinet_width - 2 * wall_thickness, cabinet_depth, cutaway_height], center = true);
}

module platform()
{
  difference()
  {
    translate([0, 0, 0.5 * wall_thickness - 0.5 * cabinet_height + platform_y])
    cube([cabinet_width - 2 * wall_thickness, cabinet_depth - 2 * wall_thickness, wall_thickness], center = true);

    translate([0, 0.5 * reclaimed_powder_chute_diameter - 0.5 * cabinet_depth + reclaimed_powder_chute_inset, -0.5 * cabinet_height + platform_y])
    cylinder(2 * wall_thickness, d = reclaimed_powder_chute_diameter, center = true, $fn = 32);
  }
  
  translate([0, 0.5 * reclaimed_powder_chute_diameter - 0.5 * cabinet_depth + reclaimed_powder_chute_inset, 0.5 * wall_thickness - 0.5 * cabinet_height + platform_y - wall_thickness])
  difference()
  {
    cube([reclaimed_powder_chute_diameter + 2, reclaimed_powder_chute_diameter + 2, wall_thickness], center = true);
    cylinder(2 * wall_thickness, d = reclaimed_powder_chute_diameter, center = true, $fn = 32);
  }
}

module channel_walls()
{
  translate([-0.5 * (reclaimed_powder_channel_width + wall_thickness), 0, 0.5 * (platform_y - wall_thickness) - 0.5 * cabinet_height + wall_thickness])
  cube([wall_thickness, cabinet_depth - 2 * wall_thickness, platform_y - wall_thickness], center = true);
  translate([+0.5 * (reclaimed_powder_channel_width + wall_thickness), 0, 0.5 * (platform_y - wall_thickness) - 0.5 * cabinet_height + wall_thickness])
  cube([wall_thickness, cabinet_depth - 2 * wall_thickness, platform_y - wall_thickness], center = true);
  translate([0, 0.5 * wall_thickness - 0.5 * cabinet_depth + reclaimed_powder_channel_depth, 0.5 * (platform_y - wall_thickness) - 0.5 * cabinet_height + wall_thickness])
  cube([reclaimed_powder_channel_width, wall_thickness, platform_y - wall_thickness], center = true);
}

module cabinet_floor(width, height, depth)
{
  translate([0, 0, wall_thickness * 0.5 - cabinet_height * 0.5])
  cube([cabinet_width - 2 * wall_thickness, cabinet_depth - 2 * wall_thickness, wall_thickness], center = true);
}

module cabinet()
{
  difference()
  {
    cabinet_top_and_walls(0);
    cabinet_top_and_walls(wall_thickness);

    opening();
  }

  platform();
  
  channel_walls();
  
  cabinet_floor();
}

intersection()
{
  cabinet();
  
  if (show_cutaway)
  {
    translate([0, -50, -20])
    cube([50, 100, 50]);
  }
}

echo(str("Top piece: ", cabinet_width - 2 * wall_thickness, " x ", cabinet_depth - cutaway_inset));
echo(str("Left/right pieces: ", cabinet_depth, " x ", cabinet_height));
echo(str("=> Cutaway inset: ", cutaway_inset, " on x, ", door_height_y + wall_thickness, " on y"));
echo(str("Front piece: ", cabinet_width - 2 * wall_thickness, " x ", cabinet_height - door_height_y - wall_thickness));
echo(str("=> Cutaway: ", reclaimed_powder_channel_width, " x ", platform_y, " centered on bottom edge"));
echo(str("Back piece: ", cabinet_width - 2 * wall_thickness, " x ", cabinet_height - wall_thickness));
echo(str("Platform piece: ", cabinet_width - 2 * wall_thickness, " x ", cabinet_depth - 2 * wall_thickness));
echo(str("=> Chute: circle with diameter ", reclaimed_powder_chute_diameter, " centered, inset by ", reclaimed_powder_chute_inset, " (center of hole inset by ", reclaimed_powder_chute_inset + 0.5 * reclaimed_powder_chute_diameter, ")"));
echo(str("Filter retainer: ", reclaimed_powder_chute_diameter + 2, " x ", reclaimed_powder_chute_diameter + 2));
echo(str("Reclaimed powder channel:"));
echo(str("=> Walls (2): ", cabinet_depth - 2 * wall_thickness, " x ", platform_y - wall_thickness));
echo(str("=> Back?: ", reclaimed_powder_channel_width, " x ", platform_y - wall_thickness));
echo(str("Bottom piece: ", cabinet_width - 2 * wall_thickness, " x ", cabinet_depth - wall_thickness));
echo(str("=> Tab with width ", reclaimed_powder_channel_width, " and depth ", wall_thickness, " centered on front edge"));
echo();
echo(str("Acrylic: ", cabinet_width, " x ", (door_height_y + wall_thickness) / cos(door_angle)));
/*
Top piece: 29 x 15.8468
Left/right pieces: 20 x 36
=> Cutaway inset: 4.15321 on x, 15.5 on y
Front piece: 29 x 20.5
=> Cutaway: 10 x 11 centered on bottom edge
Back piece: 29 x 35.5
Platform piece: 29 x 19
=> Chute: circle with diameter 4 centered, inset by 8 (center of hole inset by 10)
Filter retainer: 6 x 6
Reclaimed powder channel:
=> Walls (2): 19 x 10.5
=> Back?: 10 x 10.5
Bottom piece: 29 x 19.5
=> Tab with width 10 and depth 0.5 centered on front edge

Acrylic: 30 x 16.0468
*/