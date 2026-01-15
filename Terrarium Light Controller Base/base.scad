device_box_width_mm = 103.2;
device_box_depth_mm = 103.1;

device_box_hole_offsets_mm =
  [
    -32.6, -19.3, 19.1, 32.9, // horizontal row
    -19.4, 18.9         // vertical row
  ];

device_box_hole_diameters_mm =
  [
    6.3, 4, 6.3, 6.3,
    6.3, 6.3,
  ];
  
device_box_hole_axes =
  [
    1, 1, 1, 1,
    2, 2
  ];
  
tray_width_mm = 215;
tray_depth_mm = 155;
tray_thickness_mm = 4;
tray_edge_width_mm = 2.5 * tray_thickness_mm;

screw_hole_depth_mm = 11;
screw_hole_diameter_mm = 2.693;

device_box_platform_width_mm = device_box_width_mm + 7;
device_box_platform_depth_mm = device_box_depth_mm + 7;
device_box_platform_height_mm = screw_hole_depth_mm + 1;

controller_mount_width_mm = 67.4;
controller_mount_depth_mm = 59.3;

controller_pad_extra_mm = 3;

controller_pad_width_mm = controller_mount_width_mm + controller_pad_extra_mm * 2;
controller_pad_depth_mm = controller_mount_depth_mm + controller_pad_extra_mm * 2;
controller_pad_height_mm = tray_thickness_mm + controller_pad_extra_mm;

controller_mount_first_floor_width_mm = controller_mount_width_mm;
controller_mount_first_floor_depth_mm = 32.4;

controller_mount_hole_inset_x_mm = 13.7;
controller_mount_hole_inset_y_mm = 6.2;

controller_mount_position_x_mm = -60;
device_box_position_x_mm = 40;

module tray()
{
  roof()
  {
    difference()
    {
      square([tray_width_mm, tray_depth_mm], center = true);
      square([tray_width_mm - tray_edge_width_mm * 2, tray_depth_mm - tray_edge_width_mm * 2], center = true);
    }
  }
  
  translate([0, 0, tray_thickness_mm / 2])
  cube([tray_width_mm - tray_edge_width_mm, tray_depth_mm - tray_edge_width_mm, tray_thickness_mm], center = true);
}

module device_box_screw_holes(h = device_box_platform_height_mm + 1.5)
{
  for (i = [0 : len(device_box_hole_offsets_mm) - 1])
  {
    hole_offset = device_box_hole_offsets_mm[i];
    hole_size = device_box_hole_diameters_mm[i];
    
    if (hole_size - screw_hole_diameter_mm > 2)
    {
      axis = device_box_hole_axes[i];
      
      dx = (axis == 1) ? 1 : 0;
      dy = (axis == 2) ? 1 : 0;
    
      translate([dx * hole_offset, dy * hole_offset, h - screw_hole_depth_mm + 1])
      cylinder(screw_hole_depth_mm + 1, d = screw_hole_diameter_mm, $fn = 64);
    }
  }
}

module device_box_pins(h = device_box_platform_height_mm + 1.5)
{
  for (i = [0 : len(device_box_hole_offsets_mm) - 1])
  {
    hole_offset = device_box_hole_offsets_mm[i];
    hole_size = device_box_hole_diameters_mm[i];
    
    axis = device_box_hole_axes[i];
    
    dx = (axis == 1) ? 1 : 0;
    dy = (axis == 2) ? 1 : 0;
    
    translate([dx * hole_offset, dy * hole_offset, 0])
    cylinder(h, d = hole_size, $fn = 64);
  }
}

module device_box_platform()
{
  translate([0, 0, device_box_platform_height_mm / 2])
  cube([device_box_platform_width_mm, device_box_depth_mm, device_box_platform_height_mm], center = true);
}

module device_box_mount()
{
  difference()
  {
    union()
    {
      device_box_platform();
      device_box_pins();
    }
  
    device_box_screw_holes();
  }
}

module controller_pad()
{
  translate([0, 0, controller_pad_height_mm / 2])
  cube([controller_pad_width_mm, controller_pad_depth_mm, controller_pad_height_mm], center = true);
}

module controller_pad_screw_holes()
{
  for (x = [-1, 1])
    for (y = [-1, 1])
      translate([x * (controller_mount_first_floor_width_mm / 2 - controller_mount_hole_inset_x_mm), y * (controller_mount_first_floor_depth_mm / 2 - controller_mount_hole_inset_y_mm) + controller_mount_depth_mm / 2 - controller_mount_first_floor_depth_mm / 2, 1])
      rotate([0, 0, 0])
      cylinder(d = screw_hole_diameter_mm, h = screw_hole_depth_mm, $fn = 46);
}

difference()
{
  union()
  {
    tray();
    translate([device_box_position_x_mm, 0, 0])
    device_box_mount();
    translate([controller_mount_position_x_mm, 0, 0])
    controller_pad();
  }
  
  translate([controller_mount_position_x_mm, 0, 0])
  controller_pad_screw_holes();
}