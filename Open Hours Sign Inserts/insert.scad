base = false;
top = 3;

width = 72;
height = 19.9;
slot_width = 1.0;
slot_depth = 5;
plate_thickness = 1;
text_thickness = 1.2;

label = "4:00";

if (base)
{
  for (i = [0 : 3])
  {
    translate([0, i * (height - slot_width) / 3, 0])
    cube([width, slot_width, slot_depth]);
  }

  translate([0, 0, slot_depth])
  cube([width, height, plate_thickness]);
}

if (top == 1)
{
  color("black")
  translate([width - 2, height / 2, slot_depth + plate_thickness])
  scale([1.2, 1.2, 1])
  translate([0, -5.5 - height / 2, 0])
  linear_extrude(text_thickness)
  import("4h00.svg");
}

if (top == 2)
{
  color("black")
  translate([width - 2, height / 2, slot_depth + plate_thickness])
  scale([1.2, 1.2, 1])
  translate([0, -6.49 - height / 2, 0])
  linear_extrude(text_thickness)
  import("2h30.svg");
}

if (top == 3)
{
  color("black")
  translate([width - 2, height / 2, slot_depth + plate_thickness])
  scale([1.2, 1.2, 1])
  translate([0, -6.668 - height / 2, 0])
  linear_extrude(text_thickness)
  import("10h00.svg");
}