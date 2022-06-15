$fn = $preview ? 50 : 100;

INCH = 25.4;
CM = 10;

WIDTH = 48;
DEPTH = 13;
HEIGHT = 20;

WATER_DEPTH = 17;

CORNER_SIZE = 0.75;
BRIM_HEIGHT = 1.25;

LIGHT_WIDTH = WIDTH - 2;
LIGHT_DEPTH = 7;
LIGHT_HEIGHT = 2.5;
LIGHT_SHORT_HEIGHT = 2;

LIGHT_COOLING_VENT_WIDTH = 6;
LIGHT_COOLING_VENT_DEPTH = 5;
LIGHT_COOLING_VENT_SPACING = 7.1;

LIGHT_SPACE = 2.75;

LIGHT_OFFSET_FROM_BACK = 2.75; // TODO: measure me

LIGHT_BRACKET_DEPTH = 5;

TARGET_WALL_HEIGHT = 1;
TARGET_RADIUS = 3.375;
TARGET_BASE_HEIGHT = 0.625;
TARGET_WALL_THICKNESS = 0.2;
TARGET_WALL_TAPER = 0.3;
TARGET_DEPTH = 6;

DISPENSER_RADIUS = 2.75 / 2;
DISPENSER_DEPTH = 6;
DISPENSER_BRACKET_RADIUS = 2.3 / 2;
DISPENSER_BRACKET_INSET = 0.5;
DISPENSER_BRACKET_EXTRUDE = 0.25;
DISPENSER_FACE_TAPER = 1;
DISPENSER_RESERVOIR_START = 3.25;

DISPENSER_POSITION_X = (WIDTH - LIGHT_WIDTH) * INCH / 2 + CM * (2 * LIGHT_COOLING_VENT_SPACING + (LIGHT_COOLING_VENT_SPACING - LIGHT_COOLING_VENT_WIDTH));

module target()
{
  difference()
  {
    union()
    {
      translate([0, 0, TARGET_BASE_HEIGHT * INCH])
      cylinder(TARGET_WALL_HEIGHT * INCH, TARGET_RADIUS * INCH, (TARGET_RADIUS - TARGET_WALL_TAPER) * INCH);
      
      cylinder(TARGET_BASE_HEIGHT * INCH, (TARGET_RADIUS - .6) * INCH, TARGET_RADIUS * INCH);
    }
    
    translate([0, 0, TARGET_BASE_HEIGHT * INCH])
    cylinder(TARGET_WALL_HEIGHT * INCH + 0.1, (TARGET_RADIUS - TARGET_WALL_THICKNESS) * INCH, (TARGET_RADIUS - TARGET_WALL_TAPER - TARGET_WALL_THICKNESS) * INCH);
  }
}

module tank()
{
  color("gray")
  translate([WIDTH * INCH / 2, DEPTH * INCH / 2, -HEIGHT * INCH / 2])
  difference()
  {
    cube([WIDTH * INCH, DEPTH * INCH, HEIGHT * INCH], center = true);
    
    cube([(WIDTH - 2 * CORNER_SIZE) * INCH, (DEPTH + 2) * INCH, (HEIGHT - 2 * BRIM_HEIGHT) * INCH], center = true);
    cube([(WIDTH + 2) * INCH, (DEPTH - 2 * CORNER_SIZE) * INCH, (HEIGHT - 2 * BRIM_HEIGHT) * INCH], center = true);
    translate([0, 0, 2 * INCH])
    cube([(WIDTH - 2 * CORNER_SIZE) * INCH, (DEPTH - 2 * CORNER_SIZE) * INCH, HEIGHT * INCH], center = true);
  }
  
  translate([(TARGET_RADIUS + CORNER_SIZE) * INCH, (TARGET_RADIUS + CORNER_SIZE) * INCH, -TARGET_DEPTH * INCH])
  color("blue")
  target();

  color([0, 1, 1, .1])
  translate([WIDTH * INCH / 2, DEPTH * INCH / 2, -HEIGHT * INCH / 2])
  cube([(WIDTH - 2 * CORNER_SIZE) * INCH, (DEPTH - 2 * CORNER_SIZE) * INCH, WATER_DEPTH * INCH], center = true);
}

module light_bracket()
{
  translate([(WIDTH - 3) * INCH / 2, (LIGHT_DEPTH / 2 - LIGHT_BRACKET_DEPTH + 1) * INCH, 0])
  multmatrix(
    [[1, 0, -0.35, 0],
     [0, 1, 0, 0],
     [0, 0, 1, 0],
     [0, 0, 0, 1]])
  difference()
  {
    cube([1.5 * INCH, LIGHT_BRACKET_DEPTH * INCH, LIGHT_SPACE * INCH]);

    translate([0, 9.5 * INCH, 0])
    rotate([10, 0, 0])
    cube([10 * INCH, 10 * INCH, 10 * INCH], center = true);
    
    translate([0, -4 * INCH, 3 * INCH])
    rotate([-45, 0, 0])
    cube([10 * INCH, 10 * INCH, 10 * INCH], center = true);
  }
}

module lights()
{
  translate([WIDTH * INCH / 2, (LIGHT_DEPTH * 0.5 + LIGHT_OFFSET_FROM_BACK) * INCH, 0])
  rotate([0, 0, 180])
  color("gray")
  {
    translate([0, 0, (LIGHT_SPACE + LIGHT_HEIGHT / 2) * INCH])
    difference()
    {
      cube([LIGHT_WIDTH * INCH, LIGHT_DEPTH * INCH, LIGHT_HEIGHT * INCH], center = true);
    
      translate([0, 0, (LIGHT_HEIGHT + LIGHT_SHORT_HEIGHT + 0.3) * INCH / 2])
      rotate([8, 0, 0])
      cube([WIDTH * INCH, (LIGHT_DEPTH + 1) * INCH, LIGHT_HEIGHT * INCH], center = true);
    }
  
    light_bracket();
    scale([-1, 1, 1])
    light_bracket();
    
    for (vent = [1, 2])
    {
      translate([(WIDTH - 2) * INCH * 0.5 - vent * LIGHT_COOLING_VENT_SPACING * CM, 0.5 * LIGHT_DEPTH * INCH - (LIGHT_COOLING_VENT_DEPTH + 0.5) * CM, (LIGHT_SPACE + LIGHT_HEIGHT) * INCH])
      cube([LIGHT_COOLING_VENT_WIDTH * CM, LIGHT_COOLING_VENT_DEPTH * CM, 5]);
    }
  }
}

module dispenser()
{
  translate([0, 0, (DISPENSER_RADIUS + DISPENSER_BRACKET_EXTRUDE) * INCH])
  {
    color("gray")
    union()
    {
      difference()
      {
        rotate([90, 0, 0])
        cylinder(DISPENSER_DEPTH * INCH, DISPENSER_RADIUS * INCH, DISPENSER_RADIUS * INCH);
        
        multmatrix(
          [[1, 0, 0, -1.5 * DISPENSER_RADIUS * INCH],
           [0, 1, -0.5 / DISPENSER_RADIUS, 0],
           [0, 0, 1, -DISPENSER_RADIUS * INCH],
           [0, 0, 0, 1]])
        {
          translate([0, 0, -1])
          cube([DISPENSER_RADIUS * INCH * 3, DISPENSER_RADIUS * INCH * 3, DISPENSER_RADIUS * INCH * 3]);
        }
      }

      translate([0, -(DISPENSER_BRACKET_RADIUS + DISPENSER_BRACKET_INSET) * INCH, -(DISPENSER_RADIUS + DISPENSER_BRACKET_EXTRUDE) * INCH])
      cylinder(DISPENSER_RADIUS * INCH, DISPENSER_BRACKET_RADIUS * INCH, DISPENSER_BRACKET_RADIUS * INCH);
    }

    color([0, 0.9, 0])
    union()
    {
      difference()
      {
        rotate([90, 0, 0])
        cylinder(30, DISPENSER_RADIUS * INCH - 1, DISPENSER_RADIUS * INCH - 1);
        
        multmatrix(
          [[1, 0, 0, -1.5 * DISPENSER_RADIUS * INCH],
           [0, 1, -0.5 / DISPENSER_RADIUS, 0],
           [0, 0, 1, -DISPENSER_RADIUS * INCH],
           [0, 0, 0, 1]])
        {
          translate([0, 0.2, -1])
          cube([DISPENSER_RADIUS * INCH * 3, DISPENSER_RADIUS * INCH * 3, DISPENSER_RADIUS * INCH * 3]);
        }
      }

      translate([0, -DISPENSER_RESERVOIR_START * INCH, 0])
      rotate([90, 0, 0])
      cylinder(4, DISPENSER_RADIUS * INCH + 0.1, DISPENSER_RADIUS * INCH + 0.1);
    }
  }
}

CHUTE_HOPPER_RADIUS = 2;
CHUTE_HOPPER_RIM_HEIGHT = 1;
CHUTE_RADIUS = 1;
CHUTE_HEIGHT = LIGHT_SPACE + LIGHT_HEIGHT - CHUTE_HOPPER_RIM_HEIGHT - 0.25;
CHUTE_CLIP_HEIGHT = DISPENSER_BRACKET_EXTRUDE - 0.05;
CHUTE_CLIP_WIDTH = 0.2;
CHUTE_CLIP_RADIUS = DISPENSER_BRACKET_RADIUS + CHUTE_CLIP_WIDTH;
CHUTE_WALL_WIDTH = 0.125;
CHUTE_REINFORCEMENT_WIDTH = 0.2;
CHUTE_REINFORCEMENT_DEPTH = DISPENSER_DEPTH - DISPENSER_BRACKET_INSET - 2 * DISPENSER_BRACKET_RADIUS;
CHUTE_REINFORCEMENT_HEIGHT = 2 * CHUTE_HOPPER_RIM_HEIGHT;

module chute()
{
  translate([0, -DISPENSER_DEPTH * INCH, (CHUTE_CLIP_HEIGHT - CHUTE_HOPPER_RIM_HEIGHT) * INCH])
  {
    color("magenta")
    difference()
    {
      union()
      {
        cylinder(CHUTE_HOPPER_RIM_HEIGHT * INCH, CHUTE_HOPPER_RADIUS * INCH, CHUTE_HOPPER_RADIUS * INCH);

        multmatrix(
          [[1, 0, 0.9, 0],
           [0, 1, -0.7, 0],
           [0, 0, 1, 0],
           [0, 0, 0, 1]])
        translate([0, 0, -CHUTE_HEIGHT * INCH])
        cylinder(CHUTE_HEIGHT * INCH, CHUTE_RADIUS * INCH, CHUTE_HOPPER_RADIUS * INCH);
        
        translate([0, (DISPENSER_DEPTH - DISPENSER_BRACKET_INSET - DISPENSER_BRACKET_RADIUS) * INCH, (CHUTE_HOPPER_RIM_HEIGHT - CHUTE_CLIP_HEIGHT) * INCH])
        difference()
        {
          cylinder(CHUTE_CLIP_HEIGHT * INCH, CHUTE_CLIP_RADIUS * INCH, CHUTE_CLIP_RADIUS * INCH);

          translate([0, 0, -0.5])
          cylinder(CHUTE_CLIP_HEIGHT * INCH + 1, DISPENSER_BRACKET_RADIUS * INCH + 0.5, DISPENSER_BRACKET_RADIUS * INCH + 0.5);
        }
        
        difference()
        {
          translate([0, (DISPENSER_DEPTH - DISPENSER_BRACKET_INSET - DISPENSER_BRACKET_RADIUS) * INCH * 0.5, (CHUTE_HOPPER_RIM_HEIGHT - 0.5 * CHUTE_CLIP_HEIGHT) * INCH])
          cube([2 * CHUTE_CLIP_RADIUS * INCH, (DISPENSER_DEPTH - DISPENSER_BRACKET_INSET - DISPENSER_BRACKET_RADIUS) * INCH, CHUTE_CLIP_HEIGHT * INCH], center = true);

          translate([0, (DISPENSER_DEPTH - DISPENSER_BRACKET_INSET - DISPENSER_BRACKET_RADIUS) * INCH, (CHUTE_HOPPER_RIM_HEIGHT - CHUTE_CLIP_HEIGHT) * INCH])
          translate([0, 0, -0.5])
          cylinder(CHUTE_CLIP_HEIGHT * INCH + 1, DISPENSER_BRACKET_RADIUS * INCH + 0.5, DISPENSER_BRACKET_RADIUS * INCH + 0.5);
        }
        
        intersection()
        {
          translate([-CHUTE_CLIP_RADIUS * INCH, 0 * INCH, (CHUTE_HOPPER_RIM_HEIGHT - CHUTE_REINFORCEMENT_HEIGHT) * INCH])
          difference()
          {
            cube([2 * CHUTE_CLIP_RADIUS * INCH, CHUTE_REINFORCEMENT_DEPTH * INCH, CHUTE_REINFORCEMENT_HEIGHT * INCH]);
            
            translate([CHUTE_REINFORCEMENT_WIDTH * INCH, -0.5, -0.5])
            cube([(2 * CHUTE_CLIP_RADIUS - 2 * CHUTE_REINFORCEMENT_WIDTH) * INCH, CHUTE_REINFORCEMENT_DEPTH * INCH + 1, CHUTE_REINFORCEMENT_HEIGHT * INCH + 1]);

            multmatrix(
              [[1, 0, 0, 35],
               [0, 1, CHUTE_REINFORCEMENT_DEPTH / CHUTE_REINFORCEMENT_HEIGHT, 50 + 0.5 * CHUTE_REINFORCEMENT_DEPTH * INCH],
               [0, 0, 1, 0.5 * CHUTE_REINFORCEMENT_HEIGHT * INCH],
               [0, 0, 0, 1]])
            cube([100, 100, 60], center = true);
          }

          union()
          {
            translate([0, 0, 50])
            cube([100, 200, 100], center = true);

            translate([-10, 70, 0])
            cube([100, 100, 100], center = true);
            
            multmatrix(
              [[1, 0, 0.9, 0],
               [0, 1, -0.7, 0],
               [0, 0, 1, 0],
               [0, 0, 0, 1]])
            translate([0, 0, -CHUTE_HEIGHT * INCH])
            cylinder(CHUTE_HEIGHT * INCH, CHUTE_RADIUS * INCH, CHUTE_HOPPER_RADIUS * INCH);
          }
        }
      }
      
      cylinder(CHUTE_HOPPER_RIM_HEIGHT * INCH + 1, (CHUTE_HOPPER_RADIUS - CHUTE_WALL_WIDTH) * INCH, (CHUTE_HOPPER_RADIUS - CHUTE_WALL_WIDTH) * INCH);

      multmatrix(
        [[1, 0, 0.9, 0],
         [0, 1, -0.7, 0],
         [0, 0, 1, 0],
         [0, 0, 0, 1]])
      translate([0, 0, -CHUTE_HEIGHT * INCH - 0.5])
      cylinder(CHUTE_HEIGHT * INCH + 1, (CHUTE_RADIUS - CHUTE_WALL_WIDTH) * INCH, (CHUTE_HOPPER_RADIUS - CHUTE_WALL_WIDTH) * INCH);
    }
  }
}

if ($preview)
{
  tank();

  lights();

  translate([DISPENSER_RADIUS * INCH + DISPENSER_POSITION_X, (DISPENSER_BRACKET_INSET + 2 * DISPENSER_BRACKET_RADIUS + LIGHT_OFFSET_FROM_BACK) * INCH, (LIGHT_SPACE + LIGHT_HEIGHT) * INCH])
  {
    dispenser();

    chute();
  }
}
else
{
  chute();
}