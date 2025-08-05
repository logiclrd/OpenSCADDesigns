r1 = rands(0,1,1,0)[0.1];
r2 = rands(0,1,1)[0.2];

for (j = [1 : 0.25 : 4])
{
  color([j / 10, r2, r1, 1])
  linear_extrude(j / r2)
  offset(-2 * j)
  difference()
  {
    for (i = [1 : 0.25 : 20])
    {
      random_vect = rands(0, 50, 2, i / r2);
      
      translate(random_vect * 2)
      offset(i / j)
      square(j * 1.5 + i / 1.5, center = true);
    }
    
    for (i = [1 : 0.5 : 5])
    {
      random_vect = rands(0, 50, 2, i / r2);
      
      translate(random_vect * 2)
      offset(i / j)
      square(j * 1.5 + i / 1.5, center = true);
    }
  }
}

color("blue")
hull()
linear_extrude(0.5 / r2)
offset(-2)
difference()
{
  for (i = [1 : 0.25 : 20])
  {
    random_vect = rands(0, 50, 2, i / r2);
    
    translate(random_vect * 2)
    offset(i / 2)
    square(3 + i / 1.5, center = true);
  }
}
