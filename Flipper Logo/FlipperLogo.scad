if ($preview)
{
  S = 2.834646;

  scale([S, S, 1])
  import("orange_text_transparent.svg");
}

t_F = [ [-0.25, 0], [0, 0.5], [5, 10.5], [5.75, 12], [20.5, 12], [18.5, 10], [7, 10], [6, 8], [15.5, 8], [13.5, 6], [5, 6], [2, 0] ];
t_l = [ [17.75, 2], [22.75, 12], [25, 12], [21, 4], [31.5, 4], [29.5, 2] ];
t_i = [ [32.75, 2], [37.75, 12], [39, 12], [39, 10], [35.5, 3], [34.5, 2] ];
t_p = [ [37.75, 2], [42.75, 12], [56, 12], [56, 10.5], [51.5, 6], [42, 6], [40, 2] ];
t_p_h = [ [43, 8], [44, 10], [52.75, 10], [50.75, 8] ];
t_p_2 = [ [53.75, 2], [58.75, 12], [72, 12], [72, 10.5], [67.5, 6], [58, 6], [56, 2] ];
t_p_2_h = [ [59, 8], [60, 10], [68.75, 10], [66.75, 8] ];
t_e = [ [69.75, 2], [74.75, 12], [88.5, 12], [86.5, 10], [76, 10], [75, 8], [84.5, 8], [82.5, 6], [74, 6], [73, 4], [84.5, 4], [82.5, 2] ];
t_r_h = [ [91, 8], [92, 10], [100.5, 10], [98.5, 8] ];
t_r = [ [85.75, 2], [90.75, 12], [105.5, 12], [99.5, 6], [104, 1.5], [104, 0], [102.5, 0], [96.5, 6], [90, 6], [88, 2] ];

p_F = [ 0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11 ];
p_l = [ 12, 13, 14, 15, 16, 17 ];
p_i = [ 18, 19, 20, 21, 22, 23 ];
p_p = [ 24, 25, 26, 27, 28, 29, 30 ];
p_p_h = [ 31, 32, 33, 34 ];
p_p_2 = [ 35, 36, 37, 38, 39, 40, 41 ];
p_p_2_h = [ 42, 43, 44, 45];
p_e = [ 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57 ];
p_r_h = [ 58, 59, 60, 61 ];
p_r = [ 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74 ];

t_Flipper = concat(t_F, t_l, t_i, t_p, t_p_h, t_p_2, t_p_2_h, t_e, t_r_h, t_r);

p_Flipper = [ p_F, p_l, p_i, p_p, p_p_h, p_p_2, p_p_2_h, p_e, p_r_h, p_r ];

module flipper()
{
  color("blue")
  polygon(t_Flipper, p_Flipper);
}

chamfer_extrude(height = 0.5, angle = 45)
{
  flipper();
}

module chamfer_extrude(height = 2, angle = 10, center = false) {
    /*
       chamfer_extrude - OpenSCAD operator module to approximate
        chamfered/tapered extrusion of a 2D path
    
       (C) 2019-02, Stewart Russell (scruss) - CC-BY-SA
    
       NOTE: generates _lots_ of facets, as many as
    
            6 * path_points + 4 * $fn - 4
    
       Consequently, use with care or lots of memory.
    
       Example:
            chamfer_extrude(height=5,angle=15,$fn=8)square(10);
    
       generates a 3D object 5 units high with top surface a
        10 x 10 square with sides flaring down and out at 15
        degrees with roughly rounded corners.
    
       Usage:
       
        chamfer_extrude (
            height  =   object height: should be positive
                            for reliable results               ,
            
            angle   =   chamfer angle: degrees                 ,
            
            center  =   false|true: centres object on z-axis [ ,
            
            $fn     =   smoothness of chamfer: higher => smoother
            ]
        ) ... 2D path(s) to extrude ... ;
        
       $fn in the argument list should be set between 6 .. 16:
            <  6 can result in striking/unwanted results
            > 12 is likely a waste of resources.
            
       Lower values of $fn can result in steeper sides than expected.
        
       Extrusion is not truly trapezoidal, but has a very thin
        (0.001 unit) parallel section at the base. This is a 
        limitation of OpenSCAD operators available at the time.
        
    */
    
    // shift base of 3d object to origin or
    //  centre at half height if center == true
    translate([ 0, 
                0, 
                (center == false) ? (height - 0.001) :
                                    (height - 0.002) / 2 ]) {
        minkowski() {
            // convert 2D path to very thin 3D extrusion
            linear_extrude(height = 0.001) {
                children();
            }
            // generate $fn-sided pyramid with apex at origin,
            // rotated "point-up" along the y-axis
            rotate(270) {
                rotate_extrude() {
                    polygon([
                        [ 0,                    0.001 - height  ],
                        [ height * tan(angle),  0.001 - height  ],
                        [ 0,                    0               ]
                    ]);
                }
            }
        }
    }
}