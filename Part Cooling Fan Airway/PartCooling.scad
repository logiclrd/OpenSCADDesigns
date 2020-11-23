include_mockups = true;

$fn = 60;

wall_thickness = 2;
inlet_width = 30;
inlet_depth = 28.5;
fan_width = 56;
fan_height = 58;
fan_lip_height = 5;
aetrium_width = 47;
aetrium_depth = 52;
aetrium_height = 85;
aetrium_corner_radius = 10;
duct_width = 20;
duct_height = 44;
ceiling_support_blade_thickness = 0.6;
ceiling_support_blade_max_spacing = 4;

fan_intake_radius = 18;
fan_depth = 28;
fan_outlet_distance_from_center = 31;
fan_tab_length = 9;
fan_tab_width = 3;
fan_tab_height = 1.5;
fan_tab_distance_from_back_face = 12;
fan_outlet_tab_distance_from_top = 4;

mounting_bracket_width = 43;
mounting_bracket_depth = 38;
mounting_bracket_height = 11;

mounting_bracket_filament_path_x = 20;
mounting_bracket_filament_path_y = 19;

heat_sink_height = 26;
heat_sink_radius = 0.5 * 22.3;
heat_sink_bracket_radius = 0.5 * 16;
heat_sink_bracket_height = 42.7 - 26;

heater_block_width = 16;
heater_block_depth = 23;
heater_block_height = 11.5;
heater_block_base_z = -57;

nozzle_hex_height = 3;
nozzle_tip_height = 2;

nozzle_height = nozzle_hex_height + nozzle_tip_height;

filament_path_x = 0.5 * fan_width - 0.5 * aetrium_width - 24;
filament_path_y = 0.5 * aetrium_depth + wall_thickness - 17 - 0.5 * heater_block_depth;

manifold_radius = heater_block_depth;
manifold_rounding_radius = 5;
manifold_height = 15;
manifold_z = -2;
manifold_vent_diameter = 1.8;
manifold_vent_z_offset = 1;
manifold_vent_count = 30;

manifold_vent_radius = 0.5 * manifold_vent_diameter;

module aetrium_ceiling_outer_wall()
{
  translate([0, 0, aetrium_height - aetrium_corner_radius + wall_thickness])
  difference()
  {
    union()
    {
      minkowski()
      {
        cube([aetrium_width - 2 * aetrium_corner_radius, aetrium_depth - 2 * aetrium_corner_radius, 1], center = true);
        sphere(aetrium_corner_radius + wall_thickness);
      }
      
      intersection()
      {
        translate([-0.5 * aetrium_width - wall_thickness, -0.5 * aetrium_depth + aetrium_corner_radius, 0.25 * wall_thickness])
        rotate([0, 90, 0])
        rotate([0, 0, 180 / $fn])
        cylinder(aetrium_corner_radius + wall_thickness, aetrium_corner_radius + wall_thickness, aetrium_corner_radius + wall_thickness);
        
        translate([-0.5 * aetrium_width + aetrium_corner_radius, -0.5 * aetrium_depth + aetrium_corner_radius, 0.25 * wall_thickness])
        rotate([90, 0, 0])
        rotate([0, 0, 180 / $fn])
        cylinder(aetrium_corner_radius + wall_thickness, aetrium_corner_radius + wall_thickness, aetrium_corner_radius + wall_thickness);
      }

      intersection()
      {
        translate([-0.5 * aetrium_width - wall_thickness, -0.5 * aetrium_depth + aetrium_corner_radius, 0.25 * wall_thickness])
        rotate([0, 90, 0])
        rotate([0, 0, 180 / $fn])
        difference()
        {
          cylinder(aetrium_corner_radius + wall_thickness, aetrium_corner_radius + wall_thickness, aetrium_corner_radius + wall_thickness);
          cylinder(aetrium_corner_radius + wall_thickness, aetrium_corner_radius, aetrium_corner_radius);
        }
        
        translate([-0.5 * aetrium_width + aetrium_corner_radius, -0.5 * aetrium_depth + aetrium_corner_radius, 0.25 * wall_thickness])
        rotate([90, 0, 0])
        rotate([0, 0, 180 / $fn])
        difference()
        {
          cylinder(aetrium_corner_radius + wall_thickness, aetrium_corner_radius + wall_thickness, aetrium_corner_radius + wall_thickness);
        }
      }
    }
    
    translate([0, 0, -aetrium_corner_radius * 2])
    cube([aetrium_width + 2 * wall_thickness, aetrium_height, aetrium_corner_radius * 4], center = true);
  }
}

module aetrium_ceiling_inner_wall()
{
  translate([0, 0, aetrium_height - aetrium_corner_radius + wall_thickness])
  difference()
  {
    union()
    {
      minkowski()
      {
        cube([aetrium_width - 2 * aetrium_corner_radius, aetrium_depth - 2 * aetrium_corner_radius, 1], center = true);
        sphere(aetrium_corner_radius);
      }
      
      intersection()
      {
        translate([-0.5 * aetrium_width - wall_thickness, -0.5 * aetrium_depth + aetrium_corner_radius, 0.25 * wall_thickness])
        rotate([0, 90, 0])
        rotate([0, 0, 180 / $fn])
        cylinder(aetrium_corner_radius + wall_thickness, aetrium_corner_radius + wall_thickness, aetrium_corner_radius + wall_thickness);
        
        translate([-0.5 * aetrium_width + aetrium_corner_radius, -0.5 * aetrium_depth + aetrium_corner_radius, 0.25 * wall_thickness])
        rotate([90, 0, 0])
        rotate([0, 0, 180 / $fn])
        cylinder(aetrium_corner_radius + wall_thickness, aetrium_corner_radius, aetrium_corner_radius);

        translate([-0.5 * aetrium_width - wall_thickness, -0.5 * aetrium_depth + aetrium_corner_radius, 0.25 * wall_thickness])
        rotate([0, 90, 0])
        rotate([0, 0, 180 / $fn])
        cylinder(aetrium_corner_radius + wall_thickness, aetrium_corner_radius, aetrium_corner_radius);
      }
    }
    
    translate([0, 0, -aetrium_corner_radius * 2 - 0.1])
    cube([aetrium_width + 2 * wall_thickness, aetrium_height, aetrium_corner_radius * 4], center = true);
  }
}

module aetrium_ceiling()
{
  difference()
  {
    aetrium_ceiling_outer_wall();
    aetrium_ceiling_inner_wall();
  }
}

module aetrium_body_outer_wall()
{
  translate([0, 0, aetrium_corner_radius + wall_thickness])
  {
    union()
    {
      for (x = [-0.5 : 1])
        for (y = [-0.5 : 1])
        {
          if ((x < 0) && (y < 0))
          {
            translate([x * (aetrium_width - aetrium_corner_radius + wall_thickness), y * (aetrium_depth - aetrium_corner_radius + wall_thickness), 0.5 * aetrium_height - aetrium_corner_radius])
            cube([aetrium_corner_radius + wall_thickness, aetrium_corner_radius + wall_thickness, aetrium_height - 2 * aetrium_corner_radius], center = true);
          }
          else
          {
            translate([x * (aetrium_width - 2 * aetrium_corner_radius), y * (aetrium_depth - 2 * aetrium_corner_radius), 0])
            cylinder(aetrium_height - 2 * aetrium_corner_radius, aetrium_corner_radius + wall_thickness, aetrium_corner_radius + wall_thickness);
          }
        }
      
      translate([0, 0, 0.5 * aetrium_height - aetrium_corner_radius])
      {
        cube([aetrium_width - 2 * aetrium_corner_radius, aetrium_depth + 2 * wall_thickness, aetrium_height - 2 * aetrium_corner_radius], center = true);
        cube([aetrium_width + 2 * wall_thickness, aetrium_depth - 2 * aetrium_corner_radius, aetrium_height - 2 * aetrium_corner_radius], center = true);
      }
    }
  }
}

module aetrium_body_inner_wall()
{
  translate([0, 0, wall_thickness])
  {
    union()
    {
      for (x = [-0.5 : 1])
        for (y = [-0.5 : 1])
        {
          if ((x < 0) && (y < 0))
          {
            translate([x * (aetrium_width - aetrium_corner_radius - wall_thickness), y * (aetrium_depth - aetrium_corner_radius - wall_thickness), 0.5 * aetrium_height + aetrium_corner_radius])
            cube([aetrium_corner_radius + wall_thickness, aetrium_corner_radius + wall_thickness, aetrium_height + aetrium_corner_radius], center = true);
          }
          else
          {
            translate([x * (aetrium_width - 2 * aetrium_corner_radius), y * (aetrium_depth - 2 * aetrium_corner_radius), 0])
            cylinder(aetrium_height, aetrium_corner_radius, aetrium_corner_radius);
          }
        }
      
      translate([0, 0, 0.5 * aetrium_height])
      {
        cube([aetrium_width - 2 * aetrium_corner_radius, aetrium_depth, aetrium_height], center = true);
        cube([aetrium_width, aetrium_depth - 2 * aetrium_corner_radius, aetrium_height], center = true);
      }
    }
  }
}

module aetrium_body()
{
  difference()
  {
    aetrium_body_outer_wall();
    aetrium_body_inner_wall();
  }
}

module aetrium_inlet_cutout()
{
  translate([-0.5 * aetrium_width - fan_width + inlet_width - wall_thickness * 2, -0.5 * aetrium_depth + 0.25, fan_height - fan_lip_height - 1000])
  intersection()
  {
    translate([0, aetrium_depth, 0])
    multmatrix(
      [[1, 0, 0, 0],
       [0, 1, 0, 0],
       [0, -.16, 1, -2.2],
       [0, 0, 0, 1]])
    translate([0, -aetrium_depth, 0])
    cube([fan_width, aetrium_depth, 1000]);
    
    multmatrix(
      [[1, 0, 0, 0],
       [0, 1, 0, 0],
       [0, .16, 1, 1.4],
       [0, 0, 0, 1]])
    cube([fan_width, aetrium_depth, 1000]);
  }
  
  translate([-0.5 * fan_width - 0.5 * aetrium_width + wall_thickness + 0.5, inlet_depth - 0.5 * aetrium_depth + 0.25, -fan_lip_height])
  cube([fan_width, aetrium_depth, fan_height]);
  
  translate([-0.5 * fan_width + 2 * wall_thickness + 0.5, 0.5 * wall_thickness - 0.5 * aetrium_depth, fan_height - fan_outlet_distance_from_center])
  rotate([90, 0, 0])
  cylinder(2 * wall_thickness, fan_intake_radius, fan_intake_radius);
  
  translate([-0.5 * fan_width + wall_thickness, -0.5 * wall_thickness - 0.5 * aetrium_depth, fan_height - fan_outlet_distance_from_center + fan_intake_radius / sqrt(2)])
  rotate([0, 45, 0])
  cube([fan_intake_radius + wall_thickness + 1 * sqrt(2), 2 * wall_thickness, fan_intake_radius + wall_thickness + 1 * sqrt(2)], center = true);
  
  translate([-0.5 * fan_width + 2 * wall_thickness + 0.5 * fan_intake_radius + 0.5, -0.5 * wall_thickness - 0.5 * aetrium_depth, fan_height - fan_outlet_distance_from_center - 0.5 * fan_intake_radius])
  cube([fan_intake_radius, 2 * wall_thickness, fan_intake_radius], center = true);
}

module aetrium_inlet()
{
  difference()
  {
    translate([-0.5 * aetrium_width + 0.5 * fan_width + wall_thickness + 0.5, -0.5 * aetrium_depth, aetrium_corner_radius + wall_thickness])
    difference()
    {
      cube([wall_thickness, aetrium_depth, fan_height - aetrium_corner_radius - wall_thickness]);
      
      translate([fan_tab_height - 4, fan_depth - fan_tab_width - fan_tab_distance_from_back_face, -aetrium_corner_radius - fan_outlet_tab_distance_from_top + 0.1])
      cube([4, fan_tab_width + 0.5, fan_height]);
    }
    
    translate([inlet_width - 0.5 * aetrium_width, -0.5 * aetrium_depth + inlet_depth + 0.25, fan_height + 0.25])
    multmatrix(
      [[1, 0, 0, 0],
       [0, 1, 0, 0],
       [-(aetrium_height - aetrium_corner_radius - fan_height) / (aetrium_width - inlet_width), 0, 1, 0],
       [0, 0, 0, 1]])
    translate([0, -500, 0])
    cube([1000, 1000, 1000]);
  }

  difference()
  {
    intersection()
    {
      aetrium_body_outer_wall();
    
      translate([-0.5 * aetrium_width - aetrium_width + fan_width * 0.5 + wall_thickness * 2 + 0.5, 0.25, 0])
      cube([aetrium_width, aetrium_depth, aetrium_height]);

      translate([-1000 - 0.5 * aetrium_width + inlet_width + 0.5, -0.5 * aetrium_depth + inlet_depth + 0.25, aetrium_corner_radius])
      translate([1000, 0, 0])
      multmatrix(
        [[-1, 0, 0, 0],
         [0, 1, 0, 0],
         [0, 0, 1, 0],
         [0, 0, 0, 1]])
      multmatrix(
        [[1, 0, 0, 0],
         [0, 1, 0, 0],
         [0.6, 0.6, 1, 0],
         [0, 0, 0, 1]])
      cube([1000, 1000, 1000]);
    }
    
    translate([0, -0.5 * aetrium_depth + inlet_depth + 0.25, fan_height])
    multmatrix(
      [[1, 0, 0, 0],
       [0, 1, 0, 0],
       [0, (aetrium_height - aetrium_corner_radius - fan_height) / (aetrium_depth - inlet_depth), 1, 0],
       [0, 0, 0, 1]])
    translate([-500, 0, 0])
    cube([1000, 1000, 1000]);
    
    translate([inlet_width - 0.5 * aetrium_width, -0.5 * aetrium_depth + inlet_depth + 0.25, fan_height + 0.25])
    multmatrix(
      [[1, 0, 0, 0],
       [0, 1, 0, 0],
       [-(aetrium_height - aetrium_corner_radius - fan_height) / (aetrium_width - inlet_width), 0, 1, 0],
       [0, 0, 0, 1]])
    translate([-500, 0, 0])
    cube([1000, 1000, 1000]);
  }
}

module aetrium_ceiling_support()
{
  blade_height = aetrium_height + wall_thickness * 2 - fan_height;
  
  translate([0, 0, fan_height])
  difference()
  {
    translate([0, 0, 0.5 * blade_height])
    cube([aetrium_width, wall_thickness, blade_height], center = true);
    
    multmatrix(
      [[1, 0, 0, 0],
       [0, 1, -0.5 * (wall_thickness - ceiling_support_blade_thickness) / blade_height, 0],
       [0, 0, 1, 0],
       [0, 0, 0, 1]])
    translate([0, wall_thickness, 0.5 * blade_height])
    cube([aetrium_width, wall_thickness, 2 * blade_height], center = true);

    multmatrix(
      [[1, 0, 0, 0],
       [0, 1, 0.5 * (wall_thickness - ceiling_support_blade_thickness) / blade_height, 0],
       [0, 0, 1, 0],
       [0, 0, 0, 1]])
    translate([0, -wall_thickness, 0.5 * blade_height])
    cube([aetrium_width, wall_thickness, 2 * blade_height], center = true);

    translate([inlet_width - 0.5 * aetrium_width + 0.5, 0, 0])
    rotate([0, -46, 0])
    translate([-1000, -500, 0])
    cube([1000, 1000, 1000]);
    
    translate([inlet_width - 0.5 * aetrium_width + 0.5 + wall_thickness, 0, 0])
    rotate([0, 30, 0])
    translate([0, -500, 0])
    cube([1000, 1000, 1000]);

    translate([0, -0.5 * wall_thickness, 0])
    intersection()
    {
      translate([inlet_width - 0.5 * aetrium_width + 0.5 + wall_thickness - 8, 0, 0])
      rotate([0, 30, 0])
      translate([-1000, -500, 0])
      cube([1000, 1000, 1000]);
    
      translate([inlet_width - 0.5 * aetrium_width + 0.5 + 8, 0, 0])
      rotate([0, -46, 0])
      translate([0, -500, 0])
      cube([1000, 1000, 1000]);
      
      translate([0, 0, blade_height - 5])
      rotate([0, 45, 0])
      translate([0, 0, -1000])
      cube([1000, 1000, 1000]);
    }

    translate([0, -0.5 * wall_thickness, 0])
    intersection()
    {
      translate([inlet_width - 0.5 * aetrium_width + 0.5 + wall_thickness - 8, 0, 0])
      rotate([0, 30, 0])
      translate([-1000, -500, 0])
      cube([1000, 1000, 1000]);
    
      translate([inlet_width - 0.5 * aetrium_width + 0.5 + 8, 0, 0])
      rotate([0, -46, 0])
      translate([0, -500, 0])
      cube([1000, 1000, 1000]);
      
      translate([12, 0, blade_height - 5])
      rotate([0, 45, 0])
      translate([0, 0, -5])
      cube([1000, 1000, 5]);
    }
  }
}

module aetrium_ceiling_supports()
{
  intersection()
  {
    union()
    {
      aetrium_ceiling_outer_wall();
      aetrium_body_outer_wall();
    }
    
    ceiling_support_count = ceil(aetrium_depth / (ceiling_support_blade_thickness + ceiling_support_blade_max_spacing)) - 1;
    
    ceiling_support_spacing = (aetrium_depth - ceiling_support_count * ceiling_support_blade_thickness) / (ceiling_support_count + 1) + ceiling_support_blade_thickness;
    
    for (support_index = [1 : ceiling_support_count])
    {
      translate([0, -0.5 * aetrium_depth + support_index * ceiling_support_spacing + 0.5 * ceiling_support_blade_thickness, 0])
      aetrium_ceiling_support();
    }
  }
}

module fan_mockup()
{
  difference()
  {
    union()
    {
      intersection()
      {
        cylinder(fan_depth, 30, 30);
        cube([35, 35, 35]);
      }

      scale([30/27, 1, 1])
      rotate([0, 0, -90])
      intersection()
      {
        cylinder(fan_depth, 27, 27);
        cube([35, 35, 35]);
      }
      
      rotate([0, 0, -180])
      intersection()
      {
        cylinder(fan_depth, 27, 27);
        cube([35, 35, 35]);
      }
      
      scale([27/25, 1, 1])
      rotate([0, 0, -270])
      intersection()
      {
        cylinder(fan_depth, 25, 25);
        cube([35, 35, 35]);
      }
      
      cube([30, fan_outlet_distance_from_center, fan_depth]);
    }

    translate([0, 0, 2])
    union()
    {
      intersection()
      {
        cylinder(fan_depth - 2 * wall_thickness, 28, 28);
        translate([2, 0, 0])
        cube([35, 35, 35]);
      }

      scale([28/25, 1, 1])
      rotate([0, 0, -90])
      intersection()
      {
        cylinder(fan_depth - 2 * wall_thickness, 25, 25);
        cube([35, 35, 35]);
      }
      
      rotate([0, 0, -180])
      intersection()
      {
        cylinder(fan_depth - 2 * wall_thickness, 25, 25);
        cube([35, 35, 35]);
      }
      
      scale([25/23, 1, 1])
      rotate([0, 0, -270])
      intersection()
      {
        cylinder(fan_depth - 2 * wall_thickness, 23, 23);
        translate([0, -2, 0])
        cube([35, 35, 35]);
      }
      
      translate([2, 0, 0])
      cube([26, 37, fan_depth - 2 * wall_thickness]);
      
      cylinder(fan_depth + wall_thickness, fan_intake_radius, fan_intake_radius);
    }
  }
  
  translate([0, 0, 4])
  union()
  {
    cylinder(1, 21, 21);

    translate([0, 0, fan_depth - 11])
    difference()
    {
      cylinder(2, 21, 21);
      translate([0, 0, -1])
      cylinder(4, 20, 20);
    }
    
    for (blade = [0 : 28])
    {
      angle = blade * 360 / 29;
      
      rotate([0, 0, angle])
      translate([19, 0, (fan_depth - 9)/2])
      rotate([0, 0, 40])
      cube([4, 1, fan_depth - 9], center = true);
    }
    
    cylinder(fan_depth - 15, 15, 15);
    translate([0, 0, fan_depth - 15])
    cylinder(2, 15, 13);
  }
  
  translate([23, -22, 0])
  rotate([0, 0, 45])
  difference()
  {
    union()
    {
      cylinder(fan_depth, 4.25, 4.25);
      translate([-4.25, 0, 0])
      cube([8.5, 5.25, 28]);
    }
    
    translate([0, 0, -1])
    cylinder(fan_depth + 2, 2.25, 2.25);
  }

  translate([-20, 22, 0])
  rotate([0, 0, 225])
  difference()
  {
    union()
    {
      cylinder(fan_depth, 4.25, 4.25);
      translate([-4.25, 0, 0])
      cube([8.5, 5.25, 28]);
    }
    
    translate([0, 0, -1])
    cylinder(fan_depth + 2, 2.25, 2.25);
  }
  
  translate([30, fan_outlet_distance_from_center - fan_tab_length - fan_outlet_tab_distance_from_top, fan_tab_distance_from_back_face])
  cube([fan_tab_height, fan_tab_length, fan_tab_width]);

  translate([fan_tab_length * 0.5, -28, fan_tab_distance_from_back_face])
  rotate([0, 0, 90])
  cube([fan_tab_height, fan_tab_length, fan_tab_width]);
}


module hot_end_mockup()
{
  // Filament path through x = y = 0
  
  // Mounting bracket
  // width: 43
  translate([0.5 * mounting_bracket_width - mounting_bracket_filament_path_x, mounting_bracket_filament_path_y - 0.5 * mounting_bracket_depth, 57 - 0.5 * mounting_bracket_height])
  union()
  {
    difference()
    {
      cube([mounting_bracket_width, mounting_bracket_depth, mounting_bracket_height], center = true);
      
      translate([-0.5 * mounting_bracket_width + 7, 7 - 0.5 * mounting_bracket_depth])
      rotate([90, 0, 0])
      cylinder(9, 4, 4);

      translate([0.5 * mounting_bracket_width - 10, 7 - 0.5 * mounting_bracket_depth])
      rotate([90, 0, 0])
      cylinder(9, 4, 4);
    }

    translate([-0.5 * mounting_bracket_width + 7, 12 - 0.5 * mounting_bracket_depth])
    rotate([90, 0, 0])
    cylinder(8, 2.5, 2.5);

    translate([0.5 * mounting_bracket_width - 10, 12 - 0.5 * mounting_bracket_depth])
    rotate([90, 0, 0])
    cylinder(8, 2.5, 2.5);
  }
  
  // Heat sink
  translate([0, 0, 15])
  cylinder(heat_sink_height, heat_sink_radius, heat_sink_radius);
  
  translate([0, 0, 15 + heat_sink_height])
  cylinder(heat_sink_bracket_height, heat_sink_bracket_radius, heat_sink_bracket_radius);
  
  // Heat sink fan
  translate([0, 5 - 0.5 * heater_block_depth - 8, 44])
  translate([0, 0, -15])
  {
    difference()
    {
      cube([31, 30, 30], center = true);
      
      translate([0, -16, 0])
      rotate([-90, 0, 0])
      cylinder(32, 14, 14);
      
      translate([0, -8, 0])
      rotate([90, 0, 0])
      difference()
      {
        translate([0, 0, 2.5])
        cube([32, 32, 5], center = true);
        
        translate([0, 0, -1])
        cylinder(7, 15, 15);
      }
    }
    
    intersection()
    {
      union()
      {
        translate([0, -10, 0])
        rotate([90, 0, 0])
        cylinder(10, 9, 9, center = true);
        
        for (blade = [1 : 7])
        {
          blade_angle = blade * 360 / 7;
          
          rotate([0, blade_angle, 0])
          rotate([0, 0, 30])
          translate([-5, -10, 10])
          rotate([0, -25, 0])
          cube([7, 1, 15], center = true);
        }
      }
      
      rotate([90, 0, 0])
      cylinder(20, 13.5, 13.5);
    }
  }
  
  // Heat break
  translate([0, 0, heater_block_height - 1])
  cylinder(4, 1.24, 1.24);
  
  // Heater block & cartridge
  translate([0, 8 - 0.5 * heater_block_depth, 0.5 * heater_block_height])
  {
    difference()
    {
      cube([heater_block_width, heater_block_depth, heater_block_height], center = true);
      
      translate([0, -0.5 * (heater_block_depth - 8.5), 4 - 0.5 * heater_block_height])
      cube([heater_block_width + 0.1, 9, 1.6], center = true);
    }
    
    translate([0.5 * heater_block_width, -0.5 * heater_block_depth + 8.5, 4 - 0.5 * heater_block_height])
    rotate([0, -90, 0])
    cylinder(21, 3, 3);
    
    translate([0, 0.5 * heater_block_depth - 19.5, -1.75 - 0.5 * heater_block_height])
    cylinder(1.75, 2.5, 2.5);
  }
  
  // Nozzle
  translate([0, 0, -(nozzle_hex_height + nozzle_tip_height)])
  {
    translate([0, 0, nozzle_tip_height])
    cylinder(nozzle_hex_height, 3.5 / cos(30), 3.5 / cos(30), $fn = 6);
    
    cylinder(nozzle_tip_height, 0.5, 0.5 + 2 * tan(35));
  }
}

module aetrium()
{
  aetrium_ceiling();

  difference()
  {
    aetrium_body();
    aetrium_inlet_cutout();
  }
  
  aetrium_inlet();
  
  //if (!$preview)
  //  aetrium_ceiling_supports();
}

module manifold()
{
  translate([filament_path_x, filament_path_y, heater_block_base_z])
  difference()
  {
    union()
    {
      difference()
      {
        minkowski()
        {
          translate([0, 0, manifold_rounding_radius + manifold_z])
          cylinder(manifold_height - 2 * manifold_rounding_radius, manifold_radius, manifold_radius);

          sphere(manifold_rounding_radius);
        }

        difference()
        {
          minkowski()
          {
            translate([0, 0, manifold_rounding_radius + manifold_z])
            cylinder(manifold_height - 2 * manifold_rounding_radius, manifold_radius, manifold_radius);

            sphere(manifold_rounding_radius - 0.5 * wall_thickness);
          }

          translate([0, 0, manifold_z])
          cylinder(18, manifold_radius - 5 + wall_thickness, manifold_radius - 5 + wall_thickness);
        }
        
        translate([0, 0, manifold_z])
        cylinder(18, manifold_radius - 5, manifold_radius - 5);
      }
      
      translate([0, 0, manifold_z + 0.5 * wall_thickness])
      difference()
      {
        cylinder(3, manifold_radius, manifold_radius - 5 + wall_thickness);
      
        translate([0, 0, -1])
        cylinder(5, manifold_radius - 5 + 0.5 * wall_thickness, manifold_radius - 5 + 0.5 * wall_thickness);
      }
    }
    
    /*
    if ($preview)
    {
      translate([0, 0, -5])
      cube(100);
    }
    */
  
    vent_pitch = 90 - asin((nozzle_height + manifold_z + manifold_vent_z_offset) / (manifold_radius - manifold_rounding_radius));
    vent_length = 1 + sqrt(manifold_z * manifold_z + manifold_radius * manifold_radius);
  
    for (vent_index = [1 : manifold_vent_count])
    {
      vent_angle = vent_index * 360 / manifold_vent_count;
      
      translate([0, 0, -nozzle_height])
      rotate([0, 0, vent_angle])
      rotate([0, vent_pitch, 0])
      cylinder(vent_length, manifold_vent_radius, manifold_vent_radius);
    }
  }
}

module manifold_inlet_cutaway()
{
  translate([filament_path_x, filament_path_y, manifold_z + heater_block_base_z - 1])
  {
    difference()
    {
      cylinder(manifold_height + 2, manifold_radius + manifold_rounding_radius, manifold_radius + manifold_rounding_radius);
      cylinder(manifold_height + 2, manifold_radius, manifold_radius);
      translate([-50, 0, 0])
      cube(100, center = true);
    }
  }
}

module manifold_inlet_adaptor()
{
  // This is the piece that builds out the rounded outer wall in a straight
  // line instead of following the curve, including the floor and ceiling,
  // so that the profile of the inlet is 2 dimensional as a starting point
  // for making the segments that make up the 90 degree bend up toward the
  // bottom of the aetrium.
  translate([filament_path_x, filament_path_y, manifold_z + heater_block_base_z])
  {
    difference()
    {
      intersection()
      {
        difference()
        {
          translate([0.5 * manifold_radius, 0, 0.5 * manifold_height])
          minkowski()
          {
            cube([manifold_radius, manifold_radius * 2, manifold_height - 2 * manifold_rounding_radius], center = true);
            sphere(manifold_rounding_radius);
          }

          translate([0.5 * manifold_radius, 0, 0.5 * manifold_height])
          minkowski()
          {
            cube([manifold_radius, manifold_radius * 2, manifold_height - 2 * manifold_rounding_radius], center = true);
            sphere(manifold_rounding_radius - 0.5 * wall_thickness);
          }
        }
        
        translate([0.5 * manifold_radius, 0, 0.5 * manifold_height])
        cube([manifold_radius, manifold_radius * 2 + manifold_rounding_radius * 2, manifold_height], center = true);
      }
      
      translate([0, 0, -1])
      cylinder(manifold_height + 2, manifold_radius, manifold_radius);
    }
  }
}

module manifold_inlet_segment(inter_segment_angle)
{
  intersection()
  {
    difference()
    {
      translate([0.5 * manifold_radius, 0, 0.5 * manifold_height])
      minkowski()
      {
        cube([manifold_radius, manifold_radius * 2, manifold_height - 2 * manifold_rounding_radius], center = true);
        sphere(manifold_rounding_radius);
      }

      translate([0.5 * manifold_radius, 0, 0.5 * manifold_height])
      minkowski()
      {
        cube([manifold_radius, manifold_radius * 2, manifold_height - 2 * manifold_rounding_radius], center = true);
        sphere(manifold_rounding_radius - 0.5 * wall_thickness);
      }
    }
    
    // TODO: tilt this cube one way and then the other to cut off each end at an angle so they will join nicely
    translate([0.5 * manifold_radius, 0, 0.5 * manifold_height])
    cube([manifold_radius, manifold_radius * 2 + manifold_rounding_radius * 2, manifold_height], center = true);
    translate([0.5 * manifold_radius, 0, 0.5 * manifold_height])
    cube([manifold_radius, manifold_radius * 2 + manifold_rounding_radius * 2, manifold_height], center = true);
  }
}

module manifold_inlet()
{
  manifold_inlet_adaptor();
  
  translate([filament_path_x, filament_path_y, manifold_z + heater_block_base_z])
  {
    segment_count = $fn / 4;

    inter_segment_angle = 90 / segment_count;
    for (segment = [1 : segment_count - 1])
    {
      segment_angle = segment * inter_segment_angle;
      
      // TODO: figure out the correct bend to smoothly go 90 degrees and be
      //       lined up with the inner wall of the aetrium outlet
      // manifold_inlet_segment will need a segment_length parameter
      //translate([
      //rotate([0, segment_angle, 0])
      //manifold_inlet_segment(inter_segment_angle);
    }
  }
}

aetrium();

difference()
{
  manifold();
  manifold_inlet_cutaway();
}

manifold_inlet();

if (include_mockups)
{
  color([.5, .5, .5])
  {
    translate([0, 0, fan_height])
    translate([-27.5 + 2 * wall_thickness + 0.25, wall_thickness + 0.25, -fan_outlet_distance_from_center])
    rotate([90, 0, 0])
    fan_mockup();

    translate([filament_path_x, filament_path_y, heater_block_base_z])
    hot_end_mockup();
  }
}