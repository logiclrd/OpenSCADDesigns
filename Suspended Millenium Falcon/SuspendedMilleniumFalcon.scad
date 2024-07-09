TUNNEL_ANGLE = 15;
TUNNEL_OFFSET_X = 10;
TUNNEL_OFFSET_Y = 0;
TUNNEL_HEIGHT = 100;
SPRUE_SIZE = 1;

module ship()
{
  import("MilleniumFalcon.stl");
}

module tunnel()
{
  translate([TUNNEL_OFFSET_X, TUNNEL_OFFSET_Y, 0])
  scale([1.2, 1.2, 1.2])
  rotate([0, 0, TUNNEL_ANGLE])
  import("Tunnel.stl");
}

module hull()
{
  translate([TUNNEL_OFFSET_X, TUNNEL_OFFSET_Y, 0])
  scale([1.17, 1.17, 1.2])
  rotate([0, 0, TUNNEL_ANGLE])
  import("TunnelHull.stl");
}

module random_sprue(z)
{
  a = rands(0, 360, 1)[0];

  rotate([0, 0, a])
  translate([0, -0.5 * SPRUE_SIZE, z])
  cube([120, SPRUE_SIZE, SPRUE_SIZE]);
}

ship();
tunnel();
/*
intersection()
{
  hull();
  
  for (i = [0 : TUNNEL_HEIGHT])
    random_sprue(i);
}
*/