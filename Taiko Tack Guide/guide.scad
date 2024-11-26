module cone(inclination, sweep, slice = [0, 200])
{
  rotate_extrude(angle = sweep)
  polygon(
    [
      [0, slice[0]],
      [slice[0] * sin(inclination), slice[0]],
      [slice[1] * sin(inclination), slice[1]],
      [0, slice[1]]
    ]);
}

circumference_mm = 1990;
diameter_mm = circumference_mm / PI;
radius_mm = diameter_mm / 2;
inclination = 15;
tack_count = 72;
segments = 8;
guide_thickness_mm = 10;
guide_height_mm = 25;
pin_slot_width_mm = 5;
pin_height_mm = 15;
pin_inset_mm = 6.5;
pin_thickness_mm = 3;
tack_shaft_diameter_mm = 1.3;
pin_tolerance_mm = 0.12;

segment_sweep = 360 / segments;
tacks_per_segment = floor(tack_count / segments);
tack_sweep = segment_sweep / tacks_per_segment;
radius_top_mm = radius_mm - guide_height_mm * 0.5 * sin(inclination);
radius_bottom_mm = radius_mm + guide_height_mm * 0.5 * sin(inclination);
cutaway_vertical_displacement_mm = guide_thickness_mm / tan(inclination);
slice_start = (radius_bottom_mm + guide_thickness_mm) / sin(inclination);
slice_end = (radius_top_mm + guide_thickness_mm) / sin(inclination);
tack_y_mm = radius_mm / tan(inclination) + cutaway_vertical_displacement_mm;
tack_shaft_radius_mm = tack_shaft_diameter_mm * 0.5;
pin_width_mm = 2 * (pin_inset_mm + pin_slot_width_mm);
pin_slot_y_mm = (guide_height_mm - pin_height_mm) * 0.5;

assert(tacks_per_segment * segments == tack_count, "Tack count does not divide evenly among segments.");

module guide_segment()
{
  difference()
  {
    // Base shape
    translate([0, 0, slice_start])
    scale([1, 1, -1])
    difference()
    {
      cone(inclination, segment_sweep, [slice_start, slice_end], $fn = 100);
      
      translate([0, 0, cutaway_vertical_displacement_mm])
      cone(inclination, 360, [0, tack_y_mm * 2], $fn = 300);
    }

    // Pinning slots
    translate([0, pin_inset_mm, (guide_height_mm - pin_height_mm) * 0.5])
    cube([diameter_mm, pin_slot_width_mm, pin_height_mm]);

    translate([radius_bottom_mm + guide_thickness_mm - pin_thickness_mm - pin_slot_y_mm * sin(inclination), 0, (guide_height_mm - pin_height_mm) / 2])
    rotate([0, -inclination, 0])
    cube([pin_thickness_mm + 5, pin_slot_width_mm + pin_inset_mm, guide_height_mm]);

    translate([radius_bottom_mm + guide_thickness_mm - pin_thickness_mm - pin_slot_y_mm * sin(inclination), 0, (guide_height_mm - pin_height_mm) / 2])
    cube([pin_thickness_mm + 5, pin_slot_width_mm + pin_inset_mm, guide_height_mm]);
    
    rotate([0, 0, segment_sweep])
    {
      translate([0, -pin_inset_mm - pin_slot_width_mm, (guide_height_mm - pin_height_mm) * 0.5])
      cube([diameter_mm, pin_slot_width_mm, pin_height_mm]);

      translate([radius_bottom_mm + guide_thickness_mm - pin_thickness_mm - pin_slot_y_mm * sin(inclination), -pin_inset_mm - pin_slot_width_mm, (guide_height_mm - pin_height_mm) / 2])
      rotate([0, -inclination, 0])
      cube([pin_thickness_mm + 5, pin_slot_width_mm + pin_inset_mm, guide_height_mm]);

      translate([radius_bottom_mm + guide_thickness_mm - pin_thickness_mm - pin_slot_y_mm * sin(inclination), -pin_inset_mm - pin_slot_width_mm, (guide_height_mm - pin_height_mm) / 2])
      cube([pin_thickness_mm + 5, pin_slot_width_mm + pin_inset_mm, guide_height_mm]);
    }

    // Tack shaft channels
    for (tack = [1 : tacks_per_segment])
    {
      translate([0, 0, guide_height_mm / 2])
      scale([1, 1, guide_height_mm])
      translate([0, 0, tack_shaft_radius_mm])
      rotate([0, 0, tack * tack_sweep - tack_sweep * 0.5])
      rotate([0, 90, 0])
      rotate([0, 0, 45])
      cylinder(radius_mm * 1.2, r = tack_shaft_radius_mm * sqrt(2), $fn = 4);
    }
  }
}

module pin()
{
  difference()
  {
    intersection()
    {
      rotate([0, 0, -segment_sweep * 0.5])
      translate([0, 0, slice_start])
      scale([1, 1, -1])
      difference()
      {
        cone(inclination, segment_sweep, [slice_start, slice_end], $fn = 100);
        
        translate([0, 0, cutaway_vertical_displacement_mm])
        cone(inclination, 360, [0, tack_y_mm * 2], $fn = 300);
      }
      
      translate([0, pin_tolerance_mm - pin_width_mm / 2, pin_slot_y_mm + pin_tolerance_mm])
      cube([diameter_mm, pin_width_mm - 2 * pin_tolerance_mm, pin_height_mm - 2 * pin_tolerance_mm]);
    }

    translate([radius_bottom_mm - pin_thickness_mm, -pin_inset_mm, 0])
    rotate([0, -inclination, 0])
    cube([guide_thickness_mm, 2 * pin_inset_mm, guide_height_mm * 2]);

    // Angled edges to ease insertion
    for (angle_bias = [-1, 1])
    {
      translate([radius_bottom_mm - pin_thickness_mm, -pin_inset_mm, 0])
      rotate([0, -inclination, 0])
      translate([guide_thickness_mm * 0.8, 0, 0])
      multmatrix(
        [[1, 0, 0, 0],
         [0.1 * angle_bias, 1, 0, 0],
         [0, 0, 1, 0],
         [0, 0, 0, 1]])
      translate([-guide_thickness_mm, 0, 0])
      cube([guide_thickness_mm, 2 * pin_inset_mm, guide_height_mm * 2]);
    }
  }
}

guide_segment();

translate([15, 0, 0])
pin();