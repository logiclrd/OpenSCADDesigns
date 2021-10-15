ornate_width = 331.5075;
ornate_height = 234.9995;
ornate_extrusion = 1.4;
ornate_border_size = 4.9075;

margin = 3;
wall_thickness = 4;

width = ornate_width + margin * 2;
height = ornate_height + margin * 2;
depth = 120;

slot_height = 12.65;

king_diameter = 40;
queen_diameter = 36;
knight_diameter = 36;
rook_diameter = 35;
bishop_diameter = 35;
pawn_diameter = 30;

slot_tolerance = 0.2;

hinge_width = 52;
hinge_height = 2;

// non-mortise bifold hinge
// https://www.homedepot.ca/product/richelieu-non-mortise-bifold-hinge-antique-copper/1000401500

module ornate()
{
  multmatrix(
    [[0, 1, 0, 0],
     [1, 0, 0, 0],
     [0, 0, ornate_extrusion, ornate_extrusion * 0.5],
     [0, 0, 0, 1]])
  import("ornate.svg");
}

module ornate_smaller(constraint, angle)
{
  box_size = ornate_width + ornate_height;
  
  rotated_width = abs(cos(angle)) * ornate_width + abs(sin(angle)) * ornate_height;
  rotated_height = abs(sin(angle)) * ornate_width + abs(cos(angle)) * ornate_height;

  union()
  {
    intersection()
    {
      translate([constraint - rotated_width, 0, 0])
      translate([+rotated_width/2, +rotated_height/2, 0])
      rotate([0, 0, angle])
      translate([-ornate_width/2, -ornate_height/2, 0])
      ornate();
      
      translate([ornate_border_size, -5, 0])
      cube([constraint, box_size, 2 * ornate_extrusion]);
    }

    intersection()
    {
      translate([+rotated_width/2, +rotated_height/2, 0])
      rotate([0, 0, angle])
      translate([-ornate_width/2, -ornate_height/2, 0])
      ornate();
      
      translate([0, -5, 0])
      cube([ornate_border_size, box_size, 2 * ornate_extrusion]);
    }
  }
}

module lid()
{
  translate([margin, margin, wall_thickness])
  ornate();
  
  cube([width, height, wall_thickness]);
}

module short_side()
{
  translate([margin, margin, wall_thickness])
  ornate_smaller(depth - 2 * margin, 0);

  cube([depth, height, wall_thickness]);
}

module long_side()
{
  translate([margin, margin, wall_thickness])
  ornate_smaller(depth - 2 * margin, 90);

  cube([depth, width, wall_thickness]);
}

module slot(x, y, diameter)
{
  translate([x, y, 0])
  cylinder(slot_height + 1, 0.5 * diameter + slot_tolerance, 0.5 * diameter + slot_tolerance);
}

module slots()
{
  translate([10, 5, 0])
  {
    slot(25, 26, king_diameter);

    slot(23, 70, queen_diameter);
    slot(69, 24, queen_diameter);
    slot(61, 62, queen_diameter);

    slot(22.5, 125, rook_diameter);
    slot(124, 23.5, rook_diameter);
    
    slot(54.5, 101, knight_diameter);
    slot(100, 55.5, knight_diameter);

    slot(89.5, 121, bishop_diameter);
    slot(120, 90.5, bishop_diameter);
    
    for (x = [0 : 3])
      for (y = [0 : 1])
        slot(20 + x * (pawn_diameter + 5), 170 + y * (pawn_diameter + 5), pawn_diameter);
  }
}

module floor_with_slots()
{
  translate([0, 0, 0])
  difference()
  {
    cube([width - 2 * wall_thickness, height - 2 * wall_thickness, wall_thickness + slot_height]);
    
    translate([0, 0, wall_thickness])
    slots();

    translate([width - 2 * wall_thickness, height - 2 * wall_thickness, wall_thickness])
    rotate([0, 0, 180])
    slots();
  }
}

module assembled()
{
  floor_with_slots();

  // front
  translate([width - wall_thickness, 0, 0])
  rotate([90, 0, 0])
  rotate([0, 0, 90])
  long_side();

  // left
  color("red")
  scale([1, (height - 2 * wall_thickness) / height, 1])
  rotate([0, 270, 0])
  short_side();

  // right
  color("red")
  translate([width - 2 * wall_thickness, height - 2 * wall_thickness, 0])
  rotate([0, 0, 180])
  scale([1, (height - 2 * wall_thickness) / height, 1])
  rotate([0, 270, 0])
  short_side();
  
  // back
  color("blue")
  difference()
  {
    translate([-wall_thickness, height - 2 * wall_thickness, 0])
    rotate([0, 0, 180])
    rotate([90, 0, 0])
    rotate([0, 0, 90])
    long_side();

    translate([0, height - 0.5 - 2 * wall_thickness, depth - hinge_height])
    cube([hinge_width, wall_thickness + 1 + ornate_extrusion, hinge_height]);

    translate([width - hinge_width - 2 * wall_thickness, height - 0.5 - 2 * wall_thickness, depth - hinge_height])
    cube([hinge_width, wall_thickness + 1 + ornate_extrusion, hinge_height]);
  }

  // top
  color("green")
  translate([-wall_thickness, -wall_thickness, depth])
  lid();
}

assembled();