scale([1.2, 1.2, 1])
intersection()
{
  scale([1, 1, 2.5])
  roof()
  polygon([[26, 0], [0, 30], [0, 0]]);

  cube([30, 30, 20], center = true);
}

