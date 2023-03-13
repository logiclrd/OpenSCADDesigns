$fn = 24;

pi_width_inches = 3.5 + 1/8;
pi_height_inches = 2.5;
rb_width_inches = 2 + 9.5/16;
case_depth_inches = 3.5;
ribbon_width_inches = 2;
device_box_inches = 4;
device_box_depth_inches = 2 + 1/8;

lid_allowance_mm = 5;
wall_thickness_mm = 3;
module_additional_width_mm = 4;

ribbon_width_mm = ribbon_width_inches * 25.4;

ribbon_pi_inset_mm = 13;
ribbon_rb_inset_mm = 7; // rb == "relay board"

ribbon_gender_adapter_width_mm = 58;
ribbon_gender_adapter_height_mm = 35;
ribbon_gender_adapter_depth_mm = 10;
ribbon_gender_adapter_outset_mm = (ribbon_gender_adapter_width_mm - ribbon_width_mm) / 2;

rb_ribbon_pin_header_width_mm = 50;
rb_ribbon_pin_header_height_mm = 6;
rb_ribbon_pin_header_depth_mm = 4;

rb_terminal_block_spacing_mm = 1.5;
rb_terminal_block_inset_mm = 2;

pi_width_mm = pi_width_inches * 25.4;
pi_height_mm = pi_height_inches * 25.4;
board_thickness_mm = 1;
rb_width_mm = rb_width_inches * 25.4;
rb_height_mm = 60;
rb_pinch_mm = 18;
rb_pinch_inset_mm = 8;
rb_pinch_depth_mm = 3;
case_width_mm = pi_width_mm + 2 * module_additional_width_mm;
case_depth_mm = case_depth_inches * 25.4;
case_height_mm = pi_height_mm;
case_base_height_mm = 15;
case_margin_mm = 15;
case_wire_port_mm = 20;

module_snapin_width_mm = 3;
module_snapin_depth_mm = 6;
module_snapin_height_mm = 10;
module_thickness_mm = 10;
module_width_mm = pi_width_mm + 2 * module_additional_width_mm;

pi_bracket_hdmi_space_start_mm = 34;
pi_bracket_hdmi_space_end_mm = 51;

pi_bracket_bat_space_start_mm = (2 + 3/16) * 25.4;
pi_bracket_bat_space_end_mm = (3 + 1/8) * 25.4;
pi_bracket_bat_space_offset_mm = 1.8;
pi_bracket_bat_space_depth_mm = 3.5;

device_box_mm = device_box_inches * 25.4;
device_box_depth_mm = device_box_depth_inches * 25.4;
device_box_elevation_mm = case_height_mm + case_base_height_mm - device_box_depth_mm + 9;

next_module_offset_mm = (case_depth_mm - module_thickness_mm - 2 * module_snapin_width_mm) / 2;

module gender_adapter()
{
  color("black")
  cube([ribbon_gender_adapter_width_mm, ribbon_gender_adapter_depth_mm, ribbon_gender_adapter_depth_mm]);

  color("black")
  translate([0, ribbon_gender_adapter_height_mm - ribbon_gender_adapter_depth_mm, 0])
  cube([ribbon_gender_adapter_width_mm, ribbon_gender_adapter_depth_mm, ribbon_gender_adapter_depth_mm]);
  
  color("green")
  translate([1.5, 0.5, ribbon_gender_adapter_depth_mm / 2 - board_thickness_mm / 2])
  cube([ribbon_gender_adapter_width_mm - 3, ribbon_gender_adapter_height_mm - 1, board_thickness_mm]);
}

terminal_block_height_mm = 13;
terminal_block_width_mm = 11;
terminal_block_depth_mm = 7;
terminal_block_head_height_mm = 4;
terminal_block_head_depth_mm = 4;
terminal_block_head_ledge_front_mm = 0.25;
terminal_block_head_ledge_back_mm = 0.75;
terminal_block_opening_width_mm = 1.5;
terminal_block_opening_height_mm = 1.5;
terminal_block_opening_offset_mm = 2;

terminal_block_screw_inset_mm = 0.5;

terminal_block_screw_diameter_mm = terminal_block_head_depth_mm - 2 * terminal_block_screw_inset_mm;

terminal_block_screw_space_mm = terminal_block_width_mm - 2 * terminal_block_screw_inset_mm;

terminal_block_next_screw_offset_mm = (terminal_block_screw_space_mm - terminal_block_screw_diameter_mm) / 2;

module terminal_block()
{
  color("#95ee7f")
  {
    difference()
    {
      union()
      {
        cube([terminal_block_width_mm, terminal_block_depth_mm, terminal_block_height_mm - terminal_block_head_height_mm]);
        
        translate([0, terminal_block_head_ledge_front_mm, terminal_block_height_mm - terminal_block_head_height_mm])
        {
          multmatrix(
          [
            [1, 0, 0, 0],
            [0, 1, ((terminal_block_depth_mm - terminal_block_head_ledge_front_mm - terminal_block_head_ledge_back_mm) - terminal_block_head_depth_mm) / 2 / terminal_block_head_height_mm, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1],
          ])
          cube([terminal_block_width_mm, terminal_block_head_depth_mm, terminal_block_head_height_mm]);

          multmatrix(
          [
            [1, 0, 0, 0],
            [0, 1, -((terminal_block_depth_mm - terminal_block_head_ledge_front_mm - terminal_block_head_ledge_back_mm) - terminal_block_head_depth_mm) / 2 / terminal_block_head_height_mm, terminal_block_depth_mm - terminal_block_head_depth_mm - terminal_block_head_ledge_front_mm - terminal_block_head_ledge_back_mm],
            [0, 0, 1, 0],
            [0, 0, 0, 1],
          ])
          cube([terminal_block_width_mm, terminal_block_head_depth_mm, terminal_block_head_height_mm]);
        }
      }

      translate([
        terminal_block_screw_diameter_mm * 0.5 + terminal_block_screw_inset_mm,
        terminal_block_screw_diameter_mm * 0.5 + terminal_block_head_ledge_front_mm + (terminal_block_depth_mm - terminal_block_head_ledge_front_mm - terminal_block_head_ledge_back_mm - terminal_block_head_depth_mm) / 2 + terminal_block_screw_inset_mm,
        0])
      for (screw = [0, 1, 2])
      {
        translate([screw * terminal_block_next_screw_offset_mm, 0, 1])
        cylinder(terminal_block_height_mm, d = terminal_block_screw_diameter_mm);
        
        translate([screw * terminal_block_next_screw_offset_mm - 0.5 * terminal_block_opening_width_mm, -10, terminal_block_opening_offset_mm])
        cube([terminal_block_opening_width_mm, 10, terminal_block_opening_height_mm]);

        translate([screw * terminal_block_next_screw_offset_mm - 0.5 * terminal_block_opening_width_mm, -12, terminal_block_opening_offset_mm - 2])
        rotate([20, 0, 0])
        cube([terminal_block_opening_width_mm, 10, 10]);
      }
    }
  }
  
  color("gray")
  {
    translate([
      terminal_block_screw_diameter_mm * 0.5 + terminal_block_screw_inset_mm,
      terminal_block_screw_diameter_mm * 0.5 + terminal_block_head_ledge_front_mm + (terminal_block_depth_mm - terminal_block_head_ledge_front_mm - terminal_block_head_ledge_back_mm - terminal_block_head_depth_mm) / 2 + terminal_block_screw_inset_mm,
      0])
    for (screw = [0, 1, 2])
    {
      translate([screw * terminal_block_next_screw_offset_mm, 0])
      difference()
      {
        cylinder(terminal_block_height_mm - 2, d = terminal_block_screw_diameter_mm);
        translate([0, 0, terminal_block_height_mm + 2.5])
        rotate([0, 0, screw * 123])
        cube([.25, 10, 10], center = true);
      }
    }
  }
}
module case()
{
  color("orange")
  union()
  {
    translate([0, -0.5 * case_margin_mm, 0])
    difference()
    {
      cube([case_width_mm + 2 * wall_thickness_mm, case_depth_mm + 2 * case_margin_mm + 2 * wall_thickness_mm, case_base_height_mm + case_height_mm + lid_allowance_mm]);

      translate([wall_thickness_mm, wall_thickness_mm, case_base_height_mm])
        cube([case_width_mm, case_depth_mm + 2 * case_margin_mm, case_height_mm + lid_allowance_mm + 1]);

      translate([(case_width_mm + 2 * wall_thickness_mm) / 2, case_depth_mm + 2 * case_margin_mm + 5, case_base_height_mm + case_height_mm - device_box_depth_mm + case_wire_port_mm / sqrt(2) + 12])
      rotate([0, 45, 0])
        cube([case_wire_port_mm, 10, case_wire_port_mm], center = true);
    }

    for (snapin = [0, 1, 2])
      translate([0, snapin * next_module_offset_mm, 0])
      for (x = [0, 1])
        for (y = [0, 1])
          translate([wall_thickness_mm + x * (module_width_mm - module_snapin_depth_mm), wall_thickness_mm + y * (module_thickness_mm + module_snapin_width_mm), case_base_height_mm])
          cube([module_snapin_depth_mm, module_snapin_width_mm, module_snapin_height_mm]);

    translate([0, case_depth_mm + 1.5 * case_margin_mm + 2 * wall_thickness_mm, 0])
    cube([device_box_mm, device_box_mm, device_box_elevation_mm]);
  }
}

module pi()
{
  color("blue")
  cube([pi_width_mm, board_thickness_mm, pi_height_mm]);
}

module pi_bracket()
{
  color("cornflowerblue")
  translate([wall_thickness_mm, wall_thickness_mm + module_snapin_width_mm, case_base_height_mm])
  {
    difference()
    {
      union()
      {
        cube([pi_width_mm + 2 * module_additional_width_mm, module_thickness_mm, 10]);

        translate([module_additional_width_mm + 3 + pi_bracket_bat_space_start_mm, module_thickness_mm / 2 - 4 - pi_bracket_bat_space_depth_mm, pi_bracket_bat_space_offset_mm])
        cube([pi_bracket_bat_space_end_mm - pi_bracket_bat_space_start_mm + 4, 12, 10 - pi_bracket_bat_space_offset_mm]);

        translate([module_additional_width_mm + 3 + pi_bracket_bat_space_start_mm, module_thickness_mm / 2 - 4 - pi_bracket_bat_space_depth_mm, 0])
        multmatrix([
          [1, 0, 0, 0],
          [0, 1, -1, 1.8],
          [0, 0, 1, 0],
          [0, 0, 0, 1]])
        cube([pi_bracket_bat_space_end_mm - pi_bracket_bat_space_start_mm + 4, 5, pi_bracket_bat_space_offset_mm]);
      }

      translate([module_additional_width_mm, module_thickness_mm / 2 - board_thickness_mm / 2, -1])
      cube([pi_width_mm, board_thickness_mm, pi_height_mm]);

      translate([module_additional_width_mm + 5, module_thickness_mm / 2, -1])
      cube([pi_width_mm - 6, module_snapin_depth_mm, pi_height_mm]);

      translate([module_additional_width_mm + 5, module_thickness_mm / 2 - 3, 2])
      cube([pi_width_mm - 6, module_snapin_depth_mm, pi_height_mm]);

      translate([module_additional_width_mm + 5 + pi_bracket_hdmi_space_start_mm, module_thickness_mm / 2 - 2, -1])
      cube([pi_bracket_hdmi_space_end_mm - pi_bracket_hdmi_space_start_mm, module_snapin_depth_mm, pi_height_mm]);

      translate([module_additional_width_mm + 5 + pi_bracket_bat_space_start_mm, module_thickness_mm / 2 - 2 - pi_bracket_bat_space_depth_mm, pi_bracket_bat_space_offset_mm])
      cube([pi_bracket_bat_space_end_mm - pi_bracket_bat_space_start_mm, 10, 10]);
    }
  }
}

module rb()
{
  color("red")
  difference()
  {
    cube([rb_width_mm, board_thickness_mm, rb_height_mm]);
    
    translate([-1, -0.5, rb_pinch_inset_mm])
    multmatrix([
      [1, 0, 0, 0],
      [0, 1, 0, 0],
      [1, 0, 1, 0],
      [0, 0, 0, 1]])
    cube([rb_pinch_depth_mm, 2 * board_thickness_mm, rb_pinch_mm]);

    translate([-1, -0.5, rb_pinch_inset_mm + rb_pinch_depth_mm * 2])
    multmatrix([
      [1, 0, 0, 0],
      [0, 1, 0, 0],
      [-1, 0, 1, 0],
      [0, 0, 0, 1]])
    cube([rb_pinch_depth_mm, 2 * board_thickness_mm, rb_pinch_mm]);
    
    multmatrix([
      [-1, 0, 0, rb_width_mm],
      [0, 1, 0, 0],
      [0, 0, 1, 0],
      [0, 0, 0, 1]])
    {
      translate([-1, -0.5, rb_pinch_inset_mm])
      multmatrix([
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [1, 0, 1, 0],
        [0, 0, 0, 1]])
      cube([rb_pinch_depth_mm, 2 * board_thickness_mm, rb_pinch_mm]);

      translate([-1, -0.5, rb_pinch_inset_mm + rb_pinch_depth_mm * 2])
      multmatrix([
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [-1, 0, 1, 0],
        [0, 0, 0, 1]])
      cube([rb_pinch_depth_mm, 2 * board_thickness_mm, rb_pinch_mm]);
    }
  }
  
  color("black")
  translate([
    (rb_width_mm - rb_ribbon_pin_header_width_mm) / 2,
    -rb_ribbon_pin_header_height_mm,
    rb_height_mm - rb_ribbon_pin_header_depth_mm - (ribbon_gender_adapter_depth_mm - rb_ribbon_pin_header_depth_mm) / 2])
  cube([rb_ribbon_pin_header_width_mm, rb_ribbon_pin_header_height_mm, rb_ribbon_pin_header_depth_mm]);

  for (block = [0, 1, 2, 3])
  {
    translate([
      terminal_block_width_mm + block * (terminal_block_width_mm + rb_terminal_block_spacing_mm) + (rb_width_mm - (4 * (terminal_block_width_mm + rb_terminal_block_spacing_mm) - rb_terminal_block_spacing_mm)) / 2,
      board_thickness_mm,
      rb_terminal_block_inset_mm])
    rotate([-90, 180, 0])
    terminal_block();
  }
}



module rb_bracket()
{
  color("pink")
  translate([wall_thickness_mm, module_snapin_width_mm, case_base_height_mm])
  {
    difference()
    {
      cube([pi_width_mm + 2 * module_additional_width_mm, module_thickness_mm, 10]);
      
      translate([
        pi_width_mm - rb_width_mm - ribbon_pi_inset_mm + ribbon_rb_inset_mm + wall_thickness_mm + 1,
        module_snapin_depth_mm / 2 + board_thickness_mm + 0.5,
        -1])
      cube([rb_width_mm, board_thickness_mm + 0.25, 12]);

      translate([
        pi_width_mm - rb_width_mm - ribbon_pi_inset_mm + ribbon_rb_inset_mm + wall_thickness_mm + 3,
        module_snapin_depth_mm / 2 + board_thickness_mm - 2,
        3])
      cube([rb_width_mm - 4, board_thickness_mm + 2, 12]);

      translate([
        pi_width_mm - rb_width_mm - ribbon_pi_inset_mm + ribbon_rb_inset_mm + wall_thickness_mm + 3,
        module_snapin_depth_mm / 2 + board_thickness_mm + 1,
        -1])
      cube([rb_width_mm - 4, module_snapin_depth_mm, 12]);
    }
  }
}

module device_box()
{
  color("gray")
  difference()
  {
    cube([device_box_mm, device_box_mm, device_box_depth_mm], center = true);
    
    translate([0, 0, 0.5])
    cube([device_box_mm - 1, device_box_mm - 1, device_box_depth_mm], center = true);

    translate([0, 1, -device_box_depth_mm / 2 + 9.5 + 8])
    rotate([90, 0, 0])
    cylinder(device_box_mm + 4, d = 19, center = true);
  }
}

case();

translate([wall_thickness_mm + module_additional_width_mm, wall_thickness_mm + module_snapin_width_mm + module_thickness_mm / 2 - board_thickness_mm / 2, case_base_height_mm])
pi();

pi_bracket();

translate([
  wall_thickness_mm + module_additional_width_mm + pi_width_mm - rb_width_mm - (ribbon_pi_inset_mm - ribbon_rb_inset_mm),
  wall_thickness_mm + 2 * next_module_offset_mm + module_snapin_width_mm + module_thickness_mm / 2 - board_thickness_mm / 2,
  case_base_height_mm])
rb();

translate([
  0,
  wall_thickness_mm + 2 * next_module_offset_mm,
  0])
rb_bracket();

translate([
  wall_thickness_mm + module_additional_width_mm + pi_width_mm - rb_width_mm - (ribbon_pi_inset_mm - ribbon_rb_inset_mm) + ribbon_gender_adapter_outset_mm,
  wall_thickness_mm + 2 * next_module_offset_mm + module_snapin_width_mm + module_thickness_mm / 2 - board_thickness_mm / 2 - ribbon_gender_adapter_height_mm - rb_ribbon_pin_header_height_mm,
  case_base_height_mm + rb_height_mm - ribbon_gender_adapter_depth_mm])
gender_adapter();

translate([(case_width_mm + wall_thickness_mm * 2) / 2, device_box_mm / 2 - case_margin_mm / 2 + case_depth_mm + 2 * case_margin_mm + 2 * wall_thickness_mm, device_box_depth_mm / 2 + device_box_elevation_mm])
device_box();