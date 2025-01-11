// TODO: PTFE connectors

// Design:
// * The filaments meet at a mix chamber.
// * Each filament is extruded into the mix chamber through a nozzle-sized hole.
// * The mix chamber has a mixing plate with many small holes that the combined
//   filament must pass through.
// * The actual extrusion nozzle is attached to the bottom end and mechanically
//   clamps the mixing plate into place.
// * Heater core is down the middle axle, which has some solid metal to act as
//   a heat body.
// * The heat body is wrapped in a silicone sock. This allows cooling to be
//   directed at the top end of the nozzle body without pulling heat away
//   from the core.
//
// Obvious challenge is the current design of the heat sink. The fins would be
// difficult to manufacture. Perhaps a design like the Diamond 5-colour hot end
// could be used, with each of the inputs being wrapped in a cylindrical
// heat sink instead.

nozzle_body_diameter_mm = 40;
nozzle_body_height_mm = 24;
heater_diameter_mm = 6.4;
heater_length_mm = 20;
heat_body_diameter_mm = 13;
heat_body_wrap_thickness_mm = 2.5;
heat_sink_fin_size_mm = 1.2;
heat_sink_fin_separation_mm = heat_sink_fin_size_mm + 1.2;
inlet_angle = 60;
ptfe_connector_thread_diameter_mm = 10;
ptfe_connector_thread_wall_thickness_mm = 2;
throat_diameter_mm = 1.9;
constriction_angle = 62;
internal_nozzle_diameter_mm = 0.3;
internal_nozzle_length_mm = 0.4;
mixing_chamber_height_mm = 1;
mixing_chamber_diameter_mm = 2;
mixing_chamber_wall_width_mm = 0.25;
external_nozzle_thread_diameter_mm = 10;
external_nozzle_thread_wall_thickness_mm = 1.8;
external_nozzle_diameter_mm = 0.4;
external_nozzle_length_mm = 0.65;
external_nozzle_foot_width_mm = 1;
external_nozzle_seal_diameter_mm = mixing_chamber_diameter_mm + 0.8;
external_nozzle_seal_thickness_mm = 0.25;
external_nozzle_seal_height_mm = 0.25;
mixing_plate_thickness_mm = 0.08;
mixing_plate_tolerance_mm = 0.05;
mixing_plate_hole_size_mm = 0.15;
mixing_plate_hole_separation_mm = 0.28;
mixing_plate_rim_width_mm = 0.2;

heat_body_radius_mm = heat_body_diameter_mm / 2;
throat_radius_mm = throat_diameter_mm / 2;
internal_nozzle_radius_mm = internal_nozzle_diameter_mm / 2;
mixing_chamber_radius_mm = mixing_chamber_diameter_mm / 2;
external_nozzle_thread_radius_mm = external_nozzle_thread_diameter_mm / 2;

constriction_distance_to_nozzle_diameter_mm = internal_nozzle_radius_mm / tan(constriction_angle / 2);
constriction_distance_to_throat_diameter_mm = throat_radius_mm / tan(constriction_angle / 2);

constriction_height_mm = constriction_distance_to_throat_diameter_mm - constriction_distance_to_nozzle_diameter_mm;

body_wall_distance_mm = cos(30) * nozzle_body_diameter_mm / 2;
body_inlet_height_mm = (body_wall_distance_mm - (internal_nozzle_radius_mm - mixing_chamber_radius_mm)) * cos(inlet_angle) + mixing_chamber_height_mm - internal_nozzle_diameter_mm;

mixing_plate_diameter_mm = external_nozzle_seal_diameter_mm - external_nozzle_seal_thickness_mm - mixing_plate_tolerance_mm;

external_nozzle_body_length_mm = mixing_chamber_height_mm + constriction_height_mm + external_nozzle_length_mm;
external_nozzle_body_diameter_mm = external_nozzle_thread_diameter_mm + external_nozzle_thread_wall_thickness_mm;
external_nozzle_thread_height_mm = (body_inlet_height_mm - throat_diameter_mm) * (external_nozzle_thread_diameter_mm - mixing_chamber_radius_mm - mixing_chamber_wall_width_mm) / nozzle_body_diameter_mm;

module ptfe_connector()
{

}

module filament_path(nozzle_length_mm, constriction_height_mm, throat_diameter_mm, nozzle_diameter_mm)
{
  translate([0, 0, nozzle_length_mm])
  {
    translate([0, 0, constriction_height_mm])
    cylinder(100, d = throat_diameter_mm, $fn = 100);
    cylinder(constriction_height_mm, d1 = nozzle_diameter_mm, d2 = throat_diameter_mm, $fn = 100);
  }
  
  cylinder(nozzle_length_mm, d = nozzle_diameter_mm, $fn = 100);
}

module inlet()
{
  translate([0, internal_nozzle_radius_mm - mixing_chamber_radius_mm, mixing_chamber_height_mm - internal_nozzle_diameter_mm])
  rotate([inlet_angle, 0, 0])
  filament_path(internal_nozzle_length_mm, constriction_height_mm, throat_diameter_mm, internal_nozzle_diameter_mm);
}

function hexagon_contains_point(hexagon_diameter, x, y)
  = let (side_length = hexagon_diameter  / 2)
    let (height = hexagon_diameter * cos(30))
    (abs(x) <= side_length / 2)
    ? (abs(y) <= height / 2)
    : let (t = (abs(x) - side_length / 2) / (hexagon_diameter / 4))
      (abs(y) <= (1 - t) * height / 2);

module body()
{
  difference()
  {
    cylinder(nozzle_body_height_mm, d = nozzle_body_diameter_mm, $fn = 6);
    
    translate([0, 0, nozzle_body_height_mm - heater_length_mm])
    cylinder(heater_length_mm * 2, d = heater_diameter_mm, $fn = 100);
    
    let (heat_break_height_mm = nozzle_body_height_mm - body_inlet_height_mm - throat_diameter_mm * sin(inlet_angle) - ptfe_connector_thread_diameter_mm * sin(inlet_angle) / 2 - ptfe_connector_thread_wall_thickness_mm)
    translate([0, 0, nozzle_body_height_mm - heat_break_height_mm])
    difference()
    {
      union()
      {
        cylinder(heat_break_height_mm + 5, d = 2 * nozzle_body_diameter_mm);
        
        let (taper_height_mm = (nozzle_body_diameter_mm - heat_body_diameter_mm) / tan(inlet_angle) / 2)
        translate([0, 0, -taper_height_mm])
        cylinder(taper_height_mm, d1 = heat_body_diameter_mm, d2 = nozzle_body_diameter_mm, $fn = 100);
      }
      
      cylinder(5 * heat_break_height_mm, d = heat_body_diameter_mm, center = true, $fn = 100);
      
      let (grid_spots = floor(nozzle_body_diameter_mm / heat_sink_fin_separation_mm / 2))
      for (i = [-grid_spots : grid_spots])
        for (j = [-grid_spots : grid_spots])
          let (x = i * heat_sink_fin_separation_mm)
          let (y = j * heat_sink_fin_separation_mm)
          let (r = sqrt(x * x + y * y))
          if ((r > heat_body_radius_mm + heat_body_wrap_thickness_mm) && hexagon_contains_point(nozzle_body_diameter_mm - heat_sink_fin_size_mm * 1.5, x, y))
            translate([x, y, 0])
            rotate([0, 0, 45])
            cylinder(3 * heat_break_height_mm, d = heat_sink_fin_size_mm, center = true, $fn = 4);
    }
    
    cylinder(mixing_chamber_height_mm, d = mixing_chamber_diameter_mm, $fn = 100);

    for (i = [1 : 6])
      rotate([0, 0, i * 60])
      inlet();
      
    let (bottom_edge_rise_mm = body_inlet_height_mm + throat_diameter_mm * sin(inlet_angle) - ptfe_connector_thread_diameter_mm * sin(inlet_angle) / 2 - ptfe_connector_thread_wall_thickness_mm)
    {
      difference()
      {
        translate([0, 0, -50 + bottom_edge_rise_mm])
        cube([100, 100, 100], center = true);
        
        cylinder(bottom_edge_rise_mm, d1 = mixing_chamber_diameter_mm + mixing_chamber_wall_width_mm * 2, d2 = nozzle_body_diameter_mm, $fn = 100);
        cylinder(body_inlet_height_mm, d = external_nozzle_thread_diameter_mm, $fn = 100);
      }
    }

    difference()
    {
      cylinder(external_nozzle_seal_height_mm, d = external_nozzle_seal_diameter_mm, $fn = 100);
      cylinder(external_nozzle_seal_height_mm * 3, d = external_nozzle_seal_diameter_mm - external_nozzle_seal_thickness_mm, $fn = 100);
    }
  }
}

module mixing_plate()
{
  difference()
  {
    cylinder(mixing_plate_thickness_mm, d = mixing_plate_diameter_mm, $fn = 100);
    
    let (column_count_mm = mixing_plate_diameter_mm / mixing_plate_hole_separation_mm)
    let (row_count_mm = ceil(column_count_mm * sqrt(3) / 2))
    let (row_separation_mm = mixing_plate_hole_separation_mm / (sqrt(3) / 2))
    for (x = [-ceil(column_count_mm / 2) : ceil(column_count_mm / 2)])
    for (y = [-ceil(row_count_mm / 2) : ceil(row_count_mm / 2)])
      let (row_offset_mm = (y % 2) * mixing_plate_hole_separation_mm / 2)
      let (dx = x * mixing_plate_hole_separation_mm + row_offset_mm)
      let (dy = y * row_separation_mm)
      let (d = sqrt(dx * dx + dy * dy))
      if (d < mixing_plate_diameter_mm / 2 - mixing_plate_rim_width_mm)
        translate([dx, dy, 0])
          cylinder(3 * mixing_plate_thickness_mm, d = mixing_plate_hole_size_mm, center = true, $fn = 100);
  }
}

module nozzle()
{
  union()
  {
    difference()
    {
      union()
      {
        cylinder(external_nozzle_body_length_mm, d1 = external_nozzle_foot_width_mm, d2 = external_nozzle_body_diameter_mm, $fn = 100);
        
        translate([0, 0, external_nozzle_body_length_mm])
        cylinder(external_nozzle_thread_height_mm, d = external_nozzle_body_diameter_mm / cos(30), $fn = 6);
      }
      
      translate([0, 0, external_nozzle_body_length_mm])
      cylinder(external_nozzle_thread_height_mm, d = external_nozzle_thread_diameter_mm, $fn = 100);
      
      filament_path(external_nozzle_length_mm, constriction_height_mm, mixing_chamber_diameter_mm, internal_nozzle_diameter_mm);

      translate([0, 0, external_nozzle_body_length_mm - mixing_plate_thickness_mm])
      cylinder(mixing_plate_thickness_mm * 2, d = external_nozzle_seal_diameter_mm - external_nozzle_seal_thickness_mm, $fn = 100);
    }

    translate([0, 0, external_nozzle_body_length_mm])
    difference()
    {
      cylinder(external_nozzle_seal_height_mm, d = external_nozzle_seal_diameter_mm, $fn = 100);
      cylinder(external_nozzle_seal_height_mm * 3, d = external_nozzle_seal_diameter_mm - external_nozzle_seal_thickness_mm, $fn = 100);
    }
    
  }
      
}

difference()
{
  body();
  cube(100);
}

translate([0, 0, -(external_nozzle_body_length_mm - external_nozzle_thread_height_mm) / 2])
mixing_plate();

translate([0, 0, -external_nozzle_body_length_mm * 2])
difference()
{
  nozzle();
  cube([100, 100, 100]);
}
