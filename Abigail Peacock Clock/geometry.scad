all = -1;

show_layer = all;
show_colour = all;

include_layer_1 = (show_layer < 0) || (show_layer == 1);
include_layer_2 = (show_layer < 0) || (show_layer == 2);
include_layer_3 = (show_layer < 0) || (show_layer == 3);
include_layer_4 = (show_layer < 0) || (show_layer == 4);
include_layer_5 = (show_layer < 0) || (show_layer == 5);

include_colour_1 = (show_colour < 0) || (show_colour == 1);
include_colour_2 = (show_colour < 0) || (show_colour == 2);
include_colour_3 = (show_colour < 0) || (show_colour == 3);
include_colour_4 = (show_colour < 0) || (show_colour == 4);

body_colour = "blue";
clock_colour = "#333";
feather_colour = "#8FD";
spot_colour = "gold";

surface_colour = "red";
lettering_colour = "gold";

scale_xy = 2;
clock_thickness = 15;
slice_thickness = clock_thickness * 0.5;;
filigree_thickness = 1;
translation = [0, -250, 0];

module clock(extend_down_battery = 0, extend_main = 0)
{
  translate([0, 0, clock_thickness * 0.5])
  color("#444")
  union()
  {
    translate([0, 0, -extend_main]);
    cube([56, 56, clock_thickness + 2 * extend_main], center = true);
    translate([0, -(56 - 19) / 2, -slice_thickness - extend_down_battery])
    cube([56, 19, clock_thickness], center = true);
    
    cylinder(30, d = 8, $fn = 30);
    translate([0, 0, 7.49])
    cylinder(1, d1 = 16, d2 = 8, $fn = 30);
    
    for (x = [-1, 1])
      for (y = [-1, 1])
        translate([x * 21, y * 23, 0])
        cylinder(8.5, d = 2, $fn = 30);
  }
}

module nibs(expansion = false)
{
  color("blue")
  for (x = [-1, 1])
    for (y = [-1, 1])
      translate([x * 40, y * 40, expansion ? -0.2 : 0])
      cylinder(3 + (expansion ? 0.2 : 0), 2 + (expansion ? 0.1 : 0), 1 + (expansion ? 0.1 : 0), $fn = 40);
}

/// LAYER 1 ///

module layer1_part1()
{
  union()
  {
    if (include_colour_1)
    {
      color(feather_colour)
      scale([scale_xy, scale_xy, slice_thickness])
      translate(translation)
      linear_extrude(1)
      union()
      {
        translate([-60, 0, 0])
        import("layer 1 part 1.svg");
        scale([-1, 1, 1])
        translate([-60, 0, 0])
        import("layer 1 part 1.svg");
      }
    }
    
    if (include_colour_4)
    {
      color(clock_colour)
      scale([scale_xy, scale_xy, slice_thickness])
      translate(translation)
      linear_extrude(1)
      union()
      {
        translate([-60, 0, 0])
        import("clock body.svg");
        scale([-1, 1, 1])
        translate([-60, 0, 0])
        import("clock body.svg");
      }
      
      translate([0, 0, slice_thickness])
      nibs();
    }
  }
}

module layer1_part2()
{
  if (include_colour_3)
  {
    color(spot_colour)
    translate([0, 0, slice_thickness])
    scale([scale_xy, scale_xy, filigree_thickness])
    translate(translation)
    linear_extrude(1)
    {
      translate([-60, 0, 0])
      import("layer 1 part 2.svg");
      scale([-1, 1, 1])
      translate([-60, 0, 0])
      import("layer 1 part 2.svg");
    }
  }
}

module layer1()
{
  difference()
  {
    layer1_part1();
    translate([0, 0, slice_thickness - 1])
    clock(1, 0);
  }

  layer1_part2();
}

/// LAYER 2 ///

module layer2_part1()
{
  difference()
  {
    union()
    {
      if (include_colour_1)
      {
        color(feather_colour)
        scale([scale_xy, scale_xy, slice_thickness])
        translate(translation)
        linear_extrude(1)
        union()
        {
          translate([-60, 0, 0])
          import("layer 2 part 1.svg");
          scale([-1, 1, 1])
          translate([-60, 0, 0])
          import("layer 2 part 1.svg");
        }
      }

      if (include_colour_4)
      {
        color(clock_colour)
        scale([scale_xy, scale_xy, slice_thickness])
        translate(translation)
        linear_extrude(1)
        union()
        {
          translate([-60, 0, 0])
          import("clock body.svg");
          scale([-1, 1, 1])
          translate([-60, 0, 0])
          import("clock body.svg");
        }

        translate([0, 0, slice_thickness])
        nibs();
      }
    }
    
    nibs(true);
  }
}

module layer2_part2()
{
  if (include_colour_3)
  {
    color(spot_colour)
    translate([0, 0, slice_thickness])
    scale([scale_xy, scale_xy, filigree_thickness])
    linear_extrude(1)
    translate(translation)
    {
      translate([-60, 0, 0])
      import("layer 2 part 2.svg");
      scale([-1, 1, 1])
      translate([-60, 0, 0])
      import("layer 2 part 2.svg");
    }
  }
}

module layer2()
{
  difference()
  {
    layer2_part1();
    clock(0, 1);
  }

  layer2_part2();
}

/// LAYER 3 ///

module layer3_part1()
{
  difference()
  {
    union()
    {
      if (include_colour_1)
      {
        color(feather_colour)
        scale([scale_xy, scale_xy, slice_thickness])
        translate(translation)
        linear_extrude(1)
        union()
        {
          translate([-60, 0, 0])
          import("layer 3 part 1.svg");
          scale([-1, 1, 1])
          translate([-60, 0, 0])
          import("layer 3 part 1.svg");
        }
      }
      
      if (include_colour_4)
      {
        union()
        {
          color(clock_colour)
          scale([scale_xy, scale_xy, slice_thickness])
          translate(translation)
          linear_extrude(1)
          union()
          {
            translate([-60, 0, 0])
            import("clock body.svg");
            scale([-1, 1, 1])
            translate([-60, 0, 0])
            import("clock body.svg");
          }
          
          translate([0, 0, slice_thickness])
          nibs();
        }
      }
    }
    
    nibs(true);
  }
}

module layer3_part2()
{
  if (include_colour_3)
  {
    color(spot_colour)
    translate([0, 0, slice_thickness])
    scale([scale_xy, scale_xy, filigree_thickness])
    translate(translation)
    linear_extrude(1)
    {
      translate([-60, 0, 0])
      import("layer 3 part 2.svg");
      scale([-1, 1, 1])
      translate([-60, 0, 0])
      import("layer 3 part 2.svg");
    }
  }
}

module layer3()
{
  difference()
  {
    layer3_part1();
    clock(0, 1);
  }

  layer3_part2();
}

/// LAYER 4 ///

module layer4_part1()
{
  difference()
  {
    union()
    {
      if (include_colour_1)
      {
        color(feather_colour)
        scale([scale_xy, scale_xy, slice_thickness])
        translate(translation)
        linear_extrude(1)
        union()
        {
          translate([-60, 0, 0])
          import("layer 4 part 1.svg");
          scale([-1, 1, 1])
          translate([-60, 0, 0])
          import("layer 4 part 1.svg");
        }

        color(feather_colour)
        union()
        {
          translate([-63, 0, slice_thickness])
          cylinder(0.4, 3, 2, $fn = 40);
          translate([+63, 0, slice_thickness])
          cylinder(0.4, 3, 2, $fn = 40);

          translate([-44, 60, slice_thickness])
          cylinder(0.4, 3, 2, $fn = 40);
          translate([+44, 60, slice_thickness])
          cylinder(0.4, 3, 2, $fn = 40);
        }
      }

      if (include_colour_4)
      {
        color(surface_colour)
        difference()
        {
          scale([scale_xy, scale_xy, slice_thickness])
          translate(translation)
          linear_extrude(1)
          union()
          {
            translate([-60, 0, 0])
            import("clock body.svg");
            scale([-1, 1, 1])
            translate([-60, 0, 0])
            import("clock body.svg");
          }

          translate([0, 0, -2 * slice_thickness])
          clock(0, 0);
        }
      }
    }
    
    nibs(true);
  }

  // Face numbers
  if (include_colour_2)
  {
    color(lettering_colour)
    translate([0, 0, slice_thickness])
    {
      for (i = [1 : 12])
      {
        rotate([0, 0, -i * 360 / 12])
        translate([0, -118, 0])
        linear_extrude(0.6)
        scale([0.8, 0.5, 0.5])
        import(str("roman numeral ", i, ".svg"));
      }

      scale([1, 1, 1])
      linear_extrude(0.6)
      translate([0, -297, 0])
      import(str("arabic numerals alternate larger.svg"));

      for (i = [1 : 60])
      {
        rotate([0, 0, i * 6])
        translate([0, 39.5, 0.5])
        cube([0.4, 3, 0.6], center = true);
      }
    }
  }
}

module layer4_part2()
{
  if (include_colour_3)
  {
    color(spot_colour)
    translate([0, 0, slice_thickness])
    scale([scale_xy, scale_xy, filigree_thickness])
    translate(translation)
    linear_extrude(1)
    {
      translate([-60, 0, 0])
      import("layer 4 part 2.svg");
      scale([-1, 1, 1])
      translate([-60, 0, 0])
      import("layer 4 part 2.svg");
    }
  }
}

module layer4()
{
  layer4_part1();
  layer4_part2();
}

/// LAYER 5 ///

module layer5_part1()
{
  if (include_colour_2)
  {
    color(body_colour)
    difference()
    {
      scale([scale_xy, scale_xy, filigree_thickness])
      translate(translation)
      linear_extrude(1)
      union()
      {
        translate([-60, 0, 0])
        import("layer 5 part 1.svg");
        scale([-1, 1, 1])
        translate([-60, 0, 0])
        import("layer 5 part 1.svg");
      }

      translate([-63, 0, 0])
      cylinder(0.4, 3.75, 2.5, $fn = 40);
      translate([+63, 0, 0])
      cylinder(0.4, 3.75, 2.5, $fn = 40);

      translate([-44, 60, 0])
      cylinder(0.4, 3.75, 2.5, $fn = 40);
      translate([+44, 60, 0])
      cylinder(0.4, 3.75, 2.5, $fn = 40);
    }
  }
}

module layer5_part2()
{
  if (include_colour_4)
  {
    color(clock_colour)
    translate([0, 0, filigree_thickness])
    scale([scale_xy, scale_xy, 0.4])
    translate(translation)
    linear_extrude(1)
    {
      translate([-60, 0, 0])
      import("layer 5 part 2.svg");
      scale([-1, 1, 1])
      translate([-60, 0, 0])
      import("layer 5 part 2.svg");
    }
  }
}

module layer5()
{
  layer5_part1();
  layer5_part2();
}

if (include_layer_1) translate([0, 0, 0 * slice_thickness]) layer1();
if (include_layer_2) translate([0, 0, 1 * slice_thickness]) layer2();
if (include_layer_3) translate([0, 0, 2 * slice_thickness]) layer3();
if (include_layer_4) translate([0, 0, 3 * slice_thickness]) layer4();
if (include_layer_5) translate([0, 0, 4 * slice_thickness]) layer5();
