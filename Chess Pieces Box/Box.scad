ornate_width = 331.5075;
ornate_height = 234.9995;
ornate_extrusion = 0.2;
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

joint_width = depth / 3;

// non-mortise bifold hinge
// https://www.homedepot.ca/product/richelieu-non-mortise-bifold-hinge-antique-copper/1000401500

module ornate()
{
  if ($preview)
  {
    translate([ornate_width / 2, ornate_height / 2, 0])
    cylinder(ornate_extrusion, ornate_height / 2, ornate_height / 2);
  }
  else
  {
    multmatrix(
      [[0, 1, 0, 0],
       [1, 0, 0, 0],
       [0, 0, 1, 0],
       [0, 0, 0, 1]])
    linear_extrude(height = ornate_extrusion, $fn = 1)
    {
      import("ornate.svg");
    }
  }
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

module pin(x, y, h, r, t = 0.24)
{
  translate([x, y, 0])
  cylinder(h, r, r, $fn = 150);
  translate([x, y, h])
  cylinder(t, r, r - t, $fn = 150);
}

module lid_connector(tolerance = 0.05)
{
  diagonal = sqrt(width * width + height * height);
  diagonal_angle = atan2(height, width);

  translate([width / 2, height / 2, -1])
  {
    rotate([0, 0, diagonal_angle])
    cube([diagonal / 2 + 15, 24, 2], center = true);

    rotate([0, 0, -diagonal_angle])
    cube([diagonal / 2 + 15, 24, 2], center = true);

    for (x = [-1, 1])
      for (y = [-1, 1])
      {
        ray_angle = diagonal_angle * x + 90 * y + 90;

        circle_1 = (x == -1);
        circle_2 = (x != -1) || (y != 1);
        circle_3 = (x == 1) || (y == 1);
        circle_offset = (x == 1) && (y == 1) ? 5 : 0;

        r1 = (diagonal / 4) - 5 - 2 * circle_offset;
        r2 = (diagonal / 4) - 30 - 2 * circle_offset;
        r3 = (diagonal / 4) - 55 - 2 * circle_offset;

        if (circle_1)
        {
          pin(r1 * cos(ray_angle), r1 * sin(ray_angle), wall_thickness, 10 - tolerance);
        }

        if (circle_2)
        {
          pin(r2 * cos(ray_angle), r2 * sin(ray_angle), wall_thickness, 10 - tolerance);
        }

        if (circle_3)
        {
          pin(r3 * cos(ray_angle), r3 * sin(ray_angle), wall_thickness, 10 - tolerance);
        }
      }
  }
}

module short_side()
{
  translate([margin, margin, wall_thickness])
  ornate_smaller(depth - 2 * margin, 0);

  union()
  {
    cube([depth, height, wall_thickness]);
    
    // Joining tabs to long_side
    translate([0, -wall_thickness, 0])
    {
      cube([joint_width, wall_thickness, wall_thickness]);
      translate([depth - joint_width, 0, 0])
      cube([joint_width, wall_thickness, wall_thickness]);
    }
    
    translate([0, height, 0])
    {
      cube([joint_width, wall_thickness, wall_thickness]);
      translate([depth - joint_width, 0, 0])
      cube([joint_width, wall_thickness, wall_thickness]);
    }
  }
}

module long_side()
{
  difference()
  {
    union()
    {
      translate([margin, margin, wall_thickness])
      ornate_smaller(depth - 2 * margin, 90);

      cube([depth, width, wall_thickness]);
    }
    
    translate([0, 0, -wall_thickness])
    {
      joint_thickness = 3 * wall_thickness + ornate_extrusion;
      
      // Joining tabs to short_side
      translate([0, -1, 0])
      cube([joint_width, wall_thickness + 1, joint_thickness]);
      translate([depth - joint_width, -1, 0])
      cube([joint_width, wall_thickness + 1, joint_thickness + 1]);

      translate([0, width - wall_thickness, 0])
      {
        cube([joint_width, wall_thickness + 1, joint_thickness]);
        translate([depth - joint_width, 0, 0])
        cube([joint_width, wall_thickness + 1, joint_thickness]);
      }
      
      // Joining tabs to floor
      translate([-1, joint_width, 0])
      cube([wall_thickness + 1, joint_width, joint_thickness]);
      translate([-1, width - 2 * joint_width, 0])
      cube([wall_thickness + 1, joint_width, joint_thickness]);
    }
  }
}

module long_side_with_hinge_spaces()
{
  difference()
  {
    long_side();
    
    translate([depth - hinge_height, wall_thickness, -1])
    cube([hinge_height + 1, hinge_width, wall_thickness + 2 + ornate_extrusion]);

    translate([depth - hinge_height, width - wall_thickness - hinge_width, -1])
    cube([hinge_height + 1, hinge_width, wall_thickness + 2 + ornate_extrusion]);
  }
}

module slot(x, y, diameter)
{
  translate([x, y, 0])
  cylinder(slot_height + 1, 0.5 * diameter + slot_tolerance, 0.5 * diameter + slot_tolerance, $fn = 120);
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
    union()
    {
      cube([width - 2 * wall_thickness, height - 2 * wall_thickness, wall_thickness + slot_height]);
     
      translate([joint_width - wall_thickness, -wall_thickness, 0])
      cube([joint_width, wall_thickness, wall_thickness]);
      translate([width - 2 * joint_width - wall_thickness, -wall_thickness, 0])
      cube([joint_width, wall_thickness, wall_thickness]);
     
      translate([joint_width - wall_thickness, height - 2 * wall_thickness, 0])
      cube([joint_width, wall_thickness, wall_thickness]);
      translate([width - 2 * joint_width - wall_thickness, height - 2 * wall_thickness, 0])
      cube([joint_width, wall_thickness, wall_thickness]);
    }
    
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
  color("teal")
  {
    translate([width - wall_thickness, 0, 0])
    rotate([90, 0, 0])
    rotate([0, 0, 90])
    long_side();
  }

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
  multmatrix(
    [[0, 1, 0, -wall_thickness],
     [0, 0, 1, height - 2 * wall_thickness],
     [1, 0, 0, 0],
     [0, 0, 0, 1]])
  long_side_with_hinge_spaces();

  // top
  color("green")
  translate([-wall_thickness, -wall_thickness, depth])
  lid();
}

difference()
{
  lid();
  lid_connector(0);
}

translate([0, 0, -10])
lid_connector();