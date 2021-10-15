module Pawn()
{
  minkowski()
  {
    union()
    {
      import("Pawn.stl");

      translate([15, 25, -2])
      cylinder(23, 10, 6, $fn = 30);
    }

    sphere($fn = 1);
  }
}

//Pawn();