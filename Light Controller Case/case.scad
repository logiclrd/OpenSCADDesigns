// Design:
//   Case has a slotted design.
//   => Banana Pi goes into one slot. This slot has a Micro USB connector
//      welded into exactly the right spot so that pushing the board down
//      connects it for power.
//   => Relay board goes into another slot.
//   => Friction with mounting brackets that hold the boards pins them
//      into place.
//   => Wires connect to relays via terminal block.
//   => Two bus bars for neutral and hot. Power source is split using the
//      bus bars.
//   => A device box is attached on the side with receptacles.
//   => A pad raises the device box to the correct height so that its cover
//      does not interfere with the main case. The pad is affixed to the
//      case using L shaped connector inserts.

$fn = 24;

case_power_channel_test = false;
case_device_box_support_interface_test = false;

show_pi = $preview;
show_rb = $preview;
show_device_box = $preview;

pi_width_inches = 3.5 + 1/8;
pi_height_inches = 2.5;
rb_width_inches = 2 + 9.5/16;
case_depth_inches = 3.5;
ribbon_width_inches = 2;
device_box_inches = 4;
device_box_depth_inches = 2 + 1/8;
power_cable_depth_inches = 5/8;
power_cable_width_inches = 5/16;
power_cable_turning_space_inches = 3/4;
power_cable_thickness_inches = 3/16;
power_cable_inset_inches = 1 + 3/32;

lid_allowance_mm = 5;
wall_thickness_mm = 3;
module_additional_width_mm = 30;

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

power_cable_depth_mm = power_cable_depth_inches * 25.4;
power_cable_width_mm = power_cable_width_inches * 25.4;
power_cable_turning_space_mm = power_cable_turning_space_inches * 25.4;
power_cable_thickness_mm = power_cable_thickness_inches * 25.4;
power_cable_inset_mm = power_cable_inset_inches * 25.4;

pi_width_mm = pi_width_inches * 25.4;
pi_height_mm = pi_height_inches * 25.4;
board_thickness_mm = 1.25;
rb_width_mm = rb_width_inches * 25.4;
rb_height_mm = 60;
rb_pinch_mm = 18;
rb_pinch_inset_mm = 8;
rb_pinch_depth_mm = 3;
rb_board_extra_thickness_mm = 0.5;
case_width_mm = pi_width_mm + 2 * module_additional_width_mm;
case_depth_mm = case_depth_inches * 25.4;
case_height_mm = pi_height_mm;
case_base_height_mm = power_cable_depth_mm + 2;
case_margin_mm = 15;
case_wire_port_mm = 20;

module_snapin_width_mm = 3;
module_snapin_depth_mm = 6;
module_snapin_height_mm = 10;
module_thickness_mm = 10;
module_width_mm = pi_width_mm + 2 * module_additional_width_mm;
module_insertion_allowance_mm = 0.2;

pi_bottom_bracket_hdmi_space_start_mm = 29;
pi_bottom_bracket_hdmi_space_end_mm = 47;

pi_bottom_bracket_bat_space_start_mm = (1 + 15/16) * 25.4;
pi_bottom_bracket_bat_space_end_mm = (2 + 15/16) * 25.4;
pi_bottom_bracket_bat_space_offset_mm = 1.8;
pi_bottom_bracket_bat_space_depth_mm = 3.5;

pi_power_button_width_mm = 6.75;
pi_power_button_depth_mm = 4;

pi_audio_port_width_mm = 7;
pi_audio_port_depth_mm = 5;

device_box_mm = device_box_inches * 25.4;
device_box_depth_mm = device_box_depth_inches * 25.4;
device_box_elevation_mm = case_height_mm + case_base_height_mm - device_box_depth_mm + 9;
device_box_pin_mm = module_thickness_mm;

elephants_foot_compensation_factor = 0.75;
elephants_foot_compensation_height_mm = 1.0;

next_module_offset_mm = (case_depth_mm - module_thickness_mm - 2 * module_snapin_width_mm) / 2;

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

module power_cable_space()
{
  // End of the cable (wider).
  translate([wall_thickness_mm + case_width_mm - module_additional_width_mm - power_cable_inset_mm, case_margin_mm * 0.5 + wall_thickness_mm - board_thickness_mm, 0])
  cube([power_cable_inset_mm, power_cable_width_mm, power_cable_depth_mm + 1]);

  // Cable channel up to the bend.
  translate([wall_thickness_mm + device_box_mm * 0.5 - power_cable_thickness_mm * 0.5, case_margin_mm * 0.5 + wall_thickness_mm - board_thickness_mm + (power_cable_width_mm - power_cable_thickness_mm) / 2, 0])
  difference()
  {
    cube([(pi_width_mm / 2 + module_additional_width_mm) - module_additional_width_mm, power_cable_thickness_mm, power_cable_depth_mm + 1]);

    multmatrix([
      [1, 0, 0, power_cable_thickness_mm * 2],
      [0, 1, 0, 0],
      [-(power_cable_depth_mm - power_cable_thickness_mm - 4) / (case_width_mm / 2 - power_cable_thickness_mm * 2 - power_cable_inset_mm + power_cable_thickness_mm * 0.5), 0, 1, -4],
      [0, 0, 0, 1]])
    cube([case_width_mm / 2 - power_cable_thickness_mm, power_cable_thickness_mm, power_cable_depth_mm - power_cable_thickness_mm]);

    cube([power_cable_thickness_mm * 2, power_cable_thickness_mm, power_cable_depth_mm - power_cable_thickness_mm - 4]);
  }

  // Cable channel bend.
  translate([wall_thickness_mm + device_box_mm / 2 - power_cable_thickness_mm * 0.5, case_margin_mm * 0.5 + wall_thickness_mm - board_thickness_mm + (power_cable_width_mm - power_cable_thickness_mm) / 2, power_cable_depth_mm - power_cable_thickness_mm - 3])
  cube([power_cable_thickness_mm, power_cable_thickness_mm, case_base_height_mm + case_height_mm - device_box_depth_mm + case_wire_port_mm / sqrt(2) + 12]);

  // Cable channel from the bend to the cable port.
  translate([wall_thickness_mm + device_box_mm / 2 - power_cable_thickness_mm * 0.5, case_margin_mm * 0.5 + wall_thickness_mm - board_thickness_mm + (power_cable_width_mm - power_cable_thickness_mm) / 2 + power_cable_thickness_mm, power_cable_depth_mm - power_cable_thickness_mm])
  multmatrix([
    [1, 0, 0, 0],
    [0, 1, 0, 0],
    [0, 3 / (case_depth_mm + case_margin_mm - power_cable_thickness_mm), 1, -3],
    [0, 0, 0, 1]])
  cube([power_cable_thickness_mm, case_depth_mm + case_margin_mm - power_cable_thickness_mm, case_base_height_mm + case_height_mm - device_box_depth_mm + case_wire_port_mm / sqrt(2) + 12]);

  // Extra space at the bend for the cable to turn the corner.
  translate([0, 0, case_base_height_mm - 1])
  difference()
  {
    translate([wall_thickness_mm + device_box_mm / 2 - power_cable_thickness_mm * 0.5, case_margin_mm * 0.5 + wall_thickness_mm - board_thickness_mm + (power_cable_width_mm + power_cable_thickness_mm) / 2, -power_cable_thickness_mm - 1])
    multmatrix([
      [1, 0, 0, 0],
      [0, 1, 0, 0],
      [0, 3 / (case_depth_mm + case_margin_mm - power_cable_thickness_mm), 1, -3],
      [0, 0, 0, 1]])
    multmatrix([
      [1, 0, 0, 0],
      [-1, 1, 0, power_cable_thickness_mm],
      [0, 0, 1, 0],
      [0, 0, 0, 1]])
    cube([power_cable_thickness_mm * 2, power_cable_thickness_mm, power_cable_depth_mm + 1]);

    translate([wall_thickness_mm + device_box_mm / 2 - power_cable_thickness_mm * 0.5, case_margin_mm * 0.5 + wall_thickness_mm - board_thickness_mm + (power_cable_width_mm + power_cable_thickness_mm) / 2, -power_cable_thickness_mm - case_base_height_mm - wall_thickness_mm])
    multmatrix([
      [1, 0, 0, 0],
      [-1, 1, 0, power_cable_thickness_mm],
      [0, 0, 1, 0],
      [0, 0, 0, 1]])
    cube([power_cable_thickness_mm * 2, power_cable_thickness_mm, power_cable_depth_mm + 1]);
  }
}

module power_cable()
{
  // TODO
}

module device_box_support_connector(pin_thickness_mm, pin_extent_mm, pin_hook_mm, pin_tolerance_mm, avoid_pin_flat_roof, elephants_foot_compensation)
{
  pin_mm = pin_thickness_mm + 2 * pin_tolerance_mm;

  translate(
    [
      0,
      -0.5 * pin_extent_mm,
      0.5 * pin_mm
    ])
  cube(
    [
      pin_mm,
      pin_extent_mm + pin_tolerance_mm,
      pin_mm
    ],
    center = true);

  translate(
    [
      0.5 * pin_mm - 1.5 * pin_tolerance_mm,
      -pin_extent_mm + 0.5 * pin_mm - 1.5 * pin_tolerance_mm,
      0.5 * pin_mm
    ])
  cube(
    [
      pin_hook_mm + pin_thickness_mm + pin_tolerance_mm,
      pin_mm,
      pin_mm
    ],
    center = true);

  if (elephants_foot_compensation)
  {
    for (direction_x = [-1, 1])
      for (direction_y = [-1, 1])
      {
        multmatrix([
          [1, 0, elephants_foot_compensation_factor * direction_x, -elephants_foot_compensation_height_mm * elephants_foot_compensation_factor * direction_x],
          [0, 1, elephants_foot_compensation_factor * direction_y, -elephants_foot_compensation_height_mm * elephants_foot_compensation_factor * direction_y],
          [0, 0, 1, 0],
          [0, 0, 0, 1]])
        translate(
          [
            0,
            -0.5 * pin_extent_mm,
            0.5 * elephants_foot_compensation_height_mm
          ])
        cube(
          [
            pin_mm,
            pin_extent_mm + pin_tolerance_mm,
            elephants_foot_compensation_height_mm
          ],
          center = true);

        multmatrix([
          [1, 0, elephants_foot_compensation_factor * direction_x, -elephants_foot_compensation_height_mm * elephants_foot_compensation_factor * direction_x],
          [0, 1, elephants_foot_compensation_factor * direction_y, -elephants_foot_compensation_height_mm * elephants_foot_compensation_factor * direction_y],
          [0, 0, 1, 0],
          [0, 0, 0, 1]])
        translate(
          [
            0.5 * pin_mm - 1.5 * pin_tolerance_mm,
            -pin_extent_mm + 0.5 * pin_mm - 1.5 * pin_tolerance_mm,
            0.5 * elephants_foot_compensation_height_mm
          ])
        cube(
          [
            pin_hook_mm + pin_thickness_mm + pin_tolerance_mm,
            pin_mm,
            elephants_foot_compensation_height_mm
          ],
          center = true);
      }

    multmatrix([
      [1, 0, 0, 0],
      [0, 1, elephants_foot_compensation_factor, -elephants_foot_compensation_height_mm * elephants_foot_compensation_factor],
      [0, 0, 1, 0],
      [0, 0, 0, 1]])
      translate([-case_width_mm / 2, 0, 0])
    cube([case_width_mm, 2, elephants_foot_compensation_height_mm]);
  }

  if (avoid_pin_flat_roof)
  {
    union()
    {
      difference()
      {
        translate([0, 0, 0.5 * pin_mm])
        translate(
          [
            0,
            -0.5 * pin_extent_mm,
            0.5 * pin_mm
          ])
        rotate([0, 45, 0])
        scale([1 / sqrt(2), 1, 1 / sqrt(2)])
        cube(
          [
            pin_mm,
            pin_extent_mm + pin_tolerance_mm,
            pin_mm
          ],
          center = true);

        translate(
          [
            0,
            -pin_extent_mm - 1.5 * pin_tolerance_mm + 0.25 * pin_mm,
            1.25 * pin_mm,
          ])
        cube(
          [
            pin_mm,
            0.5 * pin_mm,
            0.5 * pin_mm
          ],
          center = true);
      }

      difference()
      {
        translate([0, 0, 0.5 * pin_mm])
        translate(
          [
            0.5 * pin_mm - 1.5 * pin_tolerance_mm,
            -pin_extent_mm + 0.5 * pin_thickness_mm - 0.5 * pin_tolerance_mm,
            0.5 * pin_mm
          ])
        rotate([45, 0, 0])
        scale([1, 1 / sqrt(2), 1 / sqrt(2)])
        cube(
          [
            pin_hook_mm + pin_mm - pin_tolerance_mm,
            pin_mm,
            pin_mm
          ],
          center = true);

        translate(
          [
            -0.25 * pin_mm,
            -pin_extent_mm - 1.5 * pin_tolerance_mm + 0.5 * pin_mm,
            1.25 * pin_mm,
          ])
        cube(
          [
            0.5 * pin_mm,
            pin_mm,
            0.5 * pin_mm
          ],
          center = true);
      }
    }

    intersection()
    {
      translate([0, 0, 0.5 * pin_mm])
      translate(
        [
          0,
          -0.5 * pin_extent_mm - pin_tolerance_mm,
          0.5 * pin_mm
        ])
      rotate([0, 45, 0])
      scale([1 / sqrt(2), 1, 1 / sqrt(2)])
      cube(
        [
          pin_mm,
          pin_extent_mm + pin_tolerance_mm,
          pin_mm
        ],
        center = true);

      translate([0, 0, 0.5 * pin_mm])
      translate(
        [
          0.5 * pin_mm - 1.5 * pin_tolerance_mm,
          -pin_extent_mm + 0.5 * pin_thickness_mm - 0.5 * pin_tolerance_mm,
          0.5 * pin_mm
        ])
      rotate([45, 0, 0])
      scale([1, 1 / sqrt(2), 1 / sqrt(2)])
      cube(
        [
          pin_hook_mm + pin_mm - pin_tolerance_mm,
          pin_mm,
          pin_mm
        ],
        center = true);
    }
  }
}

module device_box_support()
{
  color("orangered")
  translate([-0.5 * module_insertion_allowance_mm, case_depth_mm + 1.5 * case_margin_mm + 2 * wall_thickness_mm, 0])
  difference()
  {
    cube([device_box_mm, device_box_mm, device_box_elevation_mm]);

    scale([1, -1, 1])
    {
      translate([1.5 * device_box_pin_mm, 0, 0])
      device_box_support_connector(device_box_pin_mm, device_box_pin_mm * 2, device_box_pin_mm, module_insertion_allowance_mm * 2, avoid_pin_flat_roof = true, elephants_foot_compensation = true);

      translate([device_box_mm - 1.5 * device_box_pin_mm, 0, 0])
      scale([-1, 1, 1])
      device_box_support_connector(device_box_pin_mm, device_box_pin_mm * 2, device_box_pin_mm, module_insertion_allowance_mm * 2, avoid_pin_flat_roof = true, elephants_foot_compensation = true);
    }
  }
}

module case()
{
  color("orange")
  difference()
  {
    union()
    {
      // Primary hull
      translate([-module_insertion_allowance_mm, -0.5 * case_margin_mm, 0])
      difference()
      {
        // Primary volume
        cube([case_width_mm + 2 * wall_thickness_mm + 2 * module_insertion_allowance_mm, case_depth_mm + 2 * case_margin_mm + 2 * wall_thickness_mm, case_base_height_mm + case_height_mm + lid_allowance_mm]);

        // Interior space
        translate([wall_thickness_mm, wall_thickness_mm, case_base_height_mm])
          cube([case_width_mm + 2 * module_insertion_allowance_mm, case_depth_mm + 2 * case_margin_mm, case_height_mm + lid_allowance_mm + 1]);

        // Cable port
        translate([wall_thickness_mm + device_box_mm / 2, case_depth_mm + 2 * case_margin_mm + 5, case_base_height_mm + case_height_mm - device_box_depth_mm + case_wire_port_mm / sqrt(2) + 12])
        rotate([0, 45, 0])
          cube([case_wire_port_mm, 10, case_wire_port_mm], center = true);
      }

      // Bottom bracket pins
      for (snapin = [0, 1, 2])
        translate([-module_insertion_allowance_mm, snapin * next_module_offset_mm, 0])
        for (x = [0, 1])
          for (y = [0, 1])
            translate([wall_thickness_mm + x * (module_width_mm - module_snapin_depth_mm + 2 * module_insertion_allowance_mm), wall_thickness_mm + y * (module_thickness_mm + module_snapin_width_mm + 2 * module_insertion_allowance_mm) - module_insertion_allowance_mm, case_base_height_mm])
            cube([module_snapin_depth_mm, module_snapin_width_mm, module_snapin_height_mm]);

      // Top bracket pins
      bracket_pin_width = module_snapin_width_mm * 2 + module_thickness_mm;
      bracket_pin_height = module_snapin_width_mm + module_thickness_mm;

      for (snapin = [0, 1, 2])
      {
        for (y = [-1, 1])
        {
          translate(
            [
              -module_insertion_allowance_mm + (y + 1) * (case_width_mm / 2 + wall_thickness_mm),
              wall_thickness_mm + snapin * next_module_offset_mm,
              case_base_height_mm + case_height_mm - bracket_pin_height
            ])
          scale([-y, 1, 1])
          difference()
          {
            union()
            {
              cube([module_snapin_depth_mm, bracket_pin_width, bracket_pin_height]);

              difference()
              {
                multmatrix([
                  [1, 0, 1, 0],
                  [0, 1, 0, 0],
                  [0, 0, 1, 0],
                  [0, 0, 0, 1]])
                translate([0, 0, -module_snapin_depth_mm])
                cube([module_snapin_depth_mm, bracket_pin_width, module_snapin_depth_mm]);

                translate([-wall_thickness_mm - 20, -1, -wall_thickness_mm - 10])
                cube([wall_thickness_mm + 20, bracket_pin_width + 2, bracket_pin_height]);
              }
            }

            translate([0, module_snapin_width_mm, module_snapin_width_mm])
            cube([module_snapin_depth_mm + 1, module_thickness_mm, module_thickness_mm + 1]);
          }
        }
      }

      translate([wall_thickness_mm, case_depth_mm + 2 * case_margin_mm + 2 * wall_thickness_mm - 0.5 * case_margin_mm - 0.001 /* why? without this, the connector is treated as a separate hull for some reason... */, 0])
      scale([1, -1, 1])
      {
        translate([1.5 * device_box_pin_mm, 0, 0])
        device_box_support_connector(device_box_pin_mm, device_box_pin_mm * 2, device_box_pin_mm, pin_tolerance_mm = 0, avoid_pin_flat_roof = 0, elephants_foot_compensation = false);

        translate([device_box_mm - 1.5 * device_box_pin_mm, 0, 0])
        scale([-1, 1, 1])
        device_box_support_connector(device_box_pin_mm, device_box_pin_mm * 2, device_box_pin_mm, pin_tolerance_mm = 0, avoid_pin_flat_roof = 0, elephants_foot_compensation = false);
      }
    }

    translate([0, 0, case_base_height_mm - power_cable_depth_mm])
    power_cable_space();

    translate([wall_thickness_mm + module_additional_width_mm + 5 + pi_bottom_bracket_hdmi_space_start_mm + wall_thickness_mm, module_thickness_mm / 2 + 8, case_base_height_mm - 3.5])
    cube([pi_bottom_bracket_hdmi_space_end_mm - pi_bottom_bracket_hdmi_space_start_mm, module_snapin_depth_mm, pi_height_mm]);
  }

  translate([wall_thickness_mm, device_box_pin_mm * 2 + 5, 0])
  device_box_support();
}

module pi()
{
  color("blue")
  cube([pi_width_mm, board_thickness_mm, pi_height_mm]);
}

module pi_bottom_bracket()
{
  color("cornflowerblue")
  translate([wall_thickness_mm, wall_thickness_mm + module_snapin_width_mm, case_base_height_mm])
  {
    difference()
    {
      union()
      {
        cube([pi_width_mm + 2 * module_additional_width_mm, module_thickness_mm, 10]);

        // Wall extension behind battery connector space.
        translate([module_additional_width_mm + 3 + pi_bottom_bracket_bat_space_start_mm, module_thickness_mm / 2 - 4 - pi_bottom_bracket_bat_space_depth_mm, pi_bottom_bracket_bat_space_offset_mm])
        cube([pi_bottom_bracket_bat_space_end_mm - pi_bottom_bracket_bat_space_start_mm + 4, 12, 10 - pi_bottom_bracket_bat_space_offset_mm]);

        // Fillet to avoid overhang of wall extension.
        translate([module_additional_width_mm + 3 + pi_bottom_bracket_bat_space_start_mm, module_thickness_mm / 2 - 4 - pi_bottom_bracket_bat_space_depth_mm, 0])
        multmatrix([
          [1, 0, 0, 0],
          [0, 1, -1, 1.8],
          [0, 0, 1, 0],
          [0, 0, 0, 1]])
        cube([pi_bottom_bracket_bat_space_end_mm - pi_bottom_bracket_bat_space_start_mm + 4, 5, pi_bottom_bracket_bat_space_offset_mm]);
      }

      // Additional space for junk on the back of the board.
      translate([module_additional_width_mm, module_thickness_mm / 2 - board_thickness_mm / 2, -1])
      cube([pi_width_mm, board_thickness_mm, pi_height_mm]);

      // Board front components gap
      translate([module_additional_width_mm + 5, module_thickness_mm / 2, -1])
      cube([pi_width_mm - 6, module_snapin_depth_mm, pi_height_mm]);

      // Board back components gap
      translate([module_additional_width_mm + 5, module_thickness_mm / 2 - 3, 2])
      cube([pi_width_mm - 6, module_snapin_depth_mm, pi_height_mm]);

      // Additional space for the back side extensions of the HDMI port
      translate([module_additional_width_mm + 5 + pi_bottom_bracket_hdmi_space_start_mm, module_thickness_mm / 2 - 2, -1])
      cube([pi_bottom_bracket_hdmi_space_end_mm - pi_bottom_bracket_hdmi_space_start_mm, module_snapin_depth_mm, pi_height_mm]);

      // Battery connector gap
      translate([module_additional_width_mm + 5 + pi_bottom_bracket_bat_space_start_mm, module_thickness_mm / 2 - 2 - pi_bottom_bracket_bat_space_depth_mm, pi_bottom_bracket_bat_space_offset_mm])
      cube([pi_bottom_bracket_bat_space_end_mm - pi_bottom_bracket_bat_space_start_mm, 10, 10]);
    }
  }
}

module pi_top_bracket()
{
  color("cornflowerblue")
  translate([wall_thickness_mm, wall_thickness_mm + module_snapin_width_mm, case_base_height_mm - ($preview ? 0.01 : 0 /* Render fix */)])
  {
    difference()
    {
      union()
      {
        cube([pi_width_mm + 2 * module_additional_width_mm, module_thickness_mm, 10]);

        // Wall extension behind board.
        translate([module_additional_width_mm + 5, module_thickness_mm / 2 - 4 - pi_bottom_bracket_bat_space_depth_mm, pi_bottom_bracket_bat_space_offset_mm])
        cube([pi_width_mm - 10, 12, 10 - pi_bottom_bracket_bat_space_offset_mm]);

        // Fillet to avoid overhang of wall extension.
        translate([module_additional_width_mm + 5, module_thickness_mm / 2 - 4 - pi_bottom_bracket_bat_space_depth_mm, 0])
        multmatrix([
          [1, 0, 0, 0],
          [0, 1, -1, 1.8],
          [0, 0, 1, 0],
          [0, 0, 0, 1]])
        cube([pi_width_mm - 10, 5, pi_bottom_bracket_bat_space_offset_mm]);
      }

      // Board insertion space
      translate([module_additional_width_mm, module_thickness_mm / 2 - board_thickness_mm / 2, -module_thickness_mm - 10])
      cube([pi_width_mm, board_thickness_mm, pi_height_mm + 2]);

      // Front face of board opening
      translate([module_additional_width_mm + 5, module_thickness_mm / 2, -1])
      cube([pi_width_mm - 10, module_snapin_depth_mm, pi_height_mm + 2]);

      // Back component space
      translate([module_additional_width_mm + 5, module_thickness_mm / 2 - 3, -1])
      cube([pi_width_mm - 10, module_snapin_depth_mm / 2, module_thickness_mm + 2]);

      // Power/Reset button space
      translate([module_additional_width_mm + pi_width_mm - 6, module_thickness_mm / 2, -pi_power_button_depth_mm])
      cube([pi_power_button_width_mm + 1, module_snapin_depth_mm, 10]);

      // Audio port space
      translate([9 - pi_audio_port_width_mm, module_thickness_mm / 2, -pi_audio_port_depth_mm])
      cube([pi_audio_port_width_mm + 1, module_snapin_depth_mm, 10]);
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

module rb_bottom_bracket()
{
  color("pink")
  translate([wall_thickness_mm, module_snapin_width_mm, case_base_height_mm])
  {
    difference()
    {
      cube([pi_width_mm + 2 * module_additional_width_mm, module_thickness_mm, 10]);
      
      translate([module_additional_width_mm, 0, 0])
      {
        translate([
          pi_width_mm - rb_width_mm - ribbon_pi_inset_mm + ribbon_rb_inset_mm + wall_thickness_mm - 3,
          module_snapin_depth_mm / 2 + board_thickness_mm + 0.5,
          -1])
        cube([rb_width_mm, board_thickness_mm + rb_board_extra_thickness_mm, 12]);

        translate([
          pi_width_mm - rb_width_mm - ribbon_pi_inset_mm + ribbon_rb_inset_mm + wall_thickness_mm - 1,
          module_snapin_depth_mm / 2 + board_thickness_mm - 2,
          3])
        cube([rb_width_mm - 4, board_thickness_mm + 2, 12]);

        translate([
          pi_width_mm - rb_width_mm - ribbon_pi_inset_mm + ribbon_rb_inset_mm + wall_thickness_mm - 1,
          module_snapin_depth_mm / 2 + board_thickness_mm + 1,
          -1])
        cube([rb_width_mm - 4, module_snapin_depth_mm, 12]);
      }
    }
  }
}

module rb_top_bracket()
{
  color("pink")
  translate([wall_thickness_mm, module_snapin_width_mm, case_base_height_mm])
  {
    difference()
    {
      cube([pi_width_mm + 2 * module_additional_width_mm, module_thickness_mm, 10]);

      translate([module_additional_width_mm, 0, 0])
      {
        // Board insertion space
        translate([
          pi_width_mm - rb_width_mm - ribbon_pi_inset_mm + ribbon_rb_inset_mm + wall_thickness_mm - 3,
          module_snapin_depth_mm / 2 + board_thickness_mm + 0.5,
          -1])
        cube([rb_width_mm, board_thickness_mm + rb_board_extra_thickness_mm, 8]);

        // GPIO cable cutaway
        translate([
          pi_width_mm - rb_width_mm - ribbon_pi_inset_mm + ribbon_rb_inset_mm + wall_thickness_mm - 1,
          module_snapin_depth_mm / 2 + board_thickness_mm - 5,
          -1])
        cube([rb_width_mm - 4, module_snapin_depth_mm * 2, 8]);
      }
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


intersection()
{
  case();

  if (case_power_channel_test)
  {
    translate([40, 2, 0])
    cube([case_width_mm + 2 * wall_thickness_mm + 15, 18, 25]);
  }

  if (case_device_box_support_interface_test)
  {
    translate([-5, 95, 0])
    cube([case_width_mm + 2 * wall_thickness_mm + 15, 50, 13]);
  }
}

translate([0, 0, $preview ? 0 : (case_height_mm + 2 * lid_allowance_mm)])
{
  if (show_pi)
  {
    translate([wall_thickness_mm + module_additional_width_mm, wall_thickness_mm + module_snapin_width_mm + module_thickness_mm / 2 - board_thickness_mm / 2, case_base_height_mm])
    pi();
  }

  pi_bottom_bracket();

  translate([0, 0, case_height_mm - module_thickness_mm])
  pi_top_bracket();
}

if (show_rb)
{
  translate([
    wall_thickness_mm + module_additional_width_mm + pi_width_mm - rb_width_mm - (ribbon_pi_inset_mm - ribbon_rb_inset_mm),
    wall_thickness_mm + 2 * next_module_offset_mm + module_snapin_width_mm + module_thickness_mm / 2,
    case_base_height_mm])
  rb();
}

translate([0, 0, $preview ? 0 : (case_height_mm + 2 * lid_allowance_mm)])
{
  translate([
    0,
    wall_thickness_mm + 2 * next_module_offset_mm,
    0])
  {
    rb_bottom_bracket();

    translate([0, 0, case_height_mm - module_thickness_mm])
    rb_top_bracket();
  }
}

if (show_rb)
{
  translate([
    wall_thickness_mm + module_additional_width_mm + pi_width_mm - rb_width_mm - (ribbon_pi_inset_mm - ribbon_rb_inset_mm) + ribbon_gender_adapter_outset_mm,
    wall_thickness_mm + 2 * next_module_offset_mm + module_snapin_width_mm + module_thickness_mm / 2 - ribbon_gender_adapter_height_mm - rb_ribbon_pin_header_height_mm,
    case_base_height_mm + rb_height_mm - ribbon_gender_adapter_depth_mm])
  gender_adapter();
}

if (show_device_box)
{
  translate([(case_width_mm + wall_thickness_mm * 2) / 2 + module_additional_width_mm, device_box_mm / 2 - case_margin_mm / 2 + case_depth_mm + 2 * case_margin_mm + 2 * wall_thickness_mm, device_box_depth_mm / 2 + device_box_elevation_mm])
  device_box();
}