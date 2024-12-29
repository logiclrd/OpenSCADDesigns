min_radius = 280;
max_radius = 285;
random_seed = 17;

green_1 = "#58b678";
green_2 = "#007353";
green_3 = "#515b2c";
red = "#fe002f";
all = "###";

render_colour = green_2;

function random_colour()
= let (i = rands(0, 3, 1)[0])
  (i < 1) ? green_1
: (i < 2) ? green_2
          : green_3;

head_colour = red;

dummy = rands(0, 1, 1, random_seed);

module apply_colour(colour)
{
  intersection()
  {
    color(colour)
    children();
  
    translate([((colour == render_colour) || (render_colour == all)) ? 0 : 10000, 0, 0])
    cube([10000, 10000, 10000], center = true);
  }
}

module ring(
  remaining_count,
  inclination_angle,
  head = false,
  distribute_evenly = false,
  distribution_angle = 0,
  distribution_step = 0)
{
  a1 = distribute_evenly ? distribution_angle : rands(0, 360, 1)[0];
  a2 = distribute_evenly
    ? ((rands(0, 2, 1)[0] < 1 ? 180 : 0) + rands(-10, 10, 1)[0] + distribution_angle)
    : rands(0, 360, 1)[0];
  r = rands(min_radius, max_radius, 1)[0];
  
  cx = r * cos(a1);
  cy = r * sin(a1);
  
  translate([cx, cy, 0])
  rotate([0, -90 + inclination_angle, a2])
  translate([0, 0, -50])
  {
    if (!head)
    {
      apply_colour(random_colour())
      import("penis_lite.stl");
    }
    else
    {
      apply_colour(random_colour())
      import("penis_lite_shaft.stl");

      apply_colour(head_colour)
      import("penis_lite_head.stl");
    }
  }
  
  if (remaining_count > 1)
  {
    step = (distribution_step != 0)
      ? distribution_step
      : 360 / remaining_count;
      
    ring(
      remaining_count - 1,
      inclination_angle,
      head,
      distribute_evenly,
      distribution_angle + step,
      step);
  }
}

intersection()
{
  union()
  {
    ring(250, 10);
    ring(25, 30);
    ring(25, 50, true, true);
  }
  
  translate([0, 0, 50])
  cube([3 * max_radius, 3 * max_radius, 100], center = true);
}

translate([0, 0, 4])
apply_colour(red)
linear_extrude(5)
import("MerryChristmas.svg");

apply_colour(green_2)
translate([0, 0, 2])
cube([2 * min_radius, 160, 4], center = true);