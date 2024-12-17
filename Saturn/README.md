# Saturn Filleting Example

The approach here is to use a Minkowski product to round the hard edge between Saturn and the rings. A straightforward Minkowski won't do the trick, because it's the negative image of a rounded boundary that we want to stamp onto the edge. So, we negate the proto-Saturn, and then do a Minkowski of that with a sphere, then negate it again. This screenshot shows the steps:

![Screenshot](Screenshot.png)

1: Proto-Saturn. Combines the main sphere of the planet with a simple disc for the rings.

2: Negative of proto-Saturn. Subtracts proto-Saturn from a solid rectangular prism. We do just one half and then flip the result and combine to make it whole again because the Minkowski operator doesn't play well with solids with interior space.

3: The Minkowski product of the shape from step 2 with a small sphere. Note how the boundary between the planet and the rings has been filleted (in the negative) exactly as desired.

4: Subtracting step 3 from a box again turns it back into positive space. In the screenshot, we can't see the bulge of the planet because it is below the disc of the rings. This is the bottom half.

5: The top half is just the bottom half flipped vertically.

6: Splat steps 4 and 5 together into a single shape to make the desired result.

