width = 70;
height = 180;
controller_thickness = 39;
$fn = 24;

rotate([0, -90, -45])

difference() {
    union() {
        cube([width, height, 2]);

        translate([0, height*2/3, 0])
        hanger();

        hanger();
    }
    
    diff_thickness = height/3;

    // top
    translate([0, height*2/3, 0])
    triangle(5, diff_thickness);
    
    translate([0, height*2/3+2, 0])
    rotate([90, 0, 0])
    triangle(5);
    
    translate([10, height-10, 2]) {
        screw_hole(4, 10);
        cylinder(100, 6, 6);
    }
    translate([width-10, height-10, 2]) {
        screw_hole(4, 10);
        cylinder(100, 6, 6);
    }

    // mid
    translate([0, height/3, 0])
    triangle(5);

    // bottom
    triangle(5, diff_thickness);
    
    translate([0, 2, 0])
    rotate([90, 0, 0])
    triangle(5);
    
    translate([10, height/3-10, 2]) {
        screw_hole(4, 10);
        cylinder(100, 6, 6);
    }
    translate([width-10, height/3-10, 2]) {
        screw_hole(4, 10);
        cylinder(100, 6, 6);
    }
}

module triangle(_margin, _thickness=2) {
    color([1, 0, 0])
    linear_extrude(_thickness)
    polygon([
        [_margin, _margin],          // left
        [width/2, height/3-_margin], // top
        [width-_margin, _margin],    // right
    ]);
}

module hanger() {
    _height = height/3/cos(45);
    
    color([1, 0, 0])
    translate([0, 0, _height*sin(45)])
    rotate([-45, 0, 0])
    difference()
    {
        cube([width, _height, controller_thickness]);
        
        cylinder_r = 3;
        translate([0, 2+cylinder_r, 2+cylinder_r])
        minkowski() {
            cube([width, _height-2, controller_thickness-4-cylinder_r*2]);
            rotate([0, 90, 0])
            cylinder(width, cylinder_r, cylinder_r);
        }
        
        translate([0, 20, controller_thickness-2])
        cube([width, _height, 2]);
        
        union() {
            diameter = width/2-5;
            translate([diameter/2+4, diameter/2+7, controller_thickness-2])
            cylinder(2, diameter/2, diameter/2);

            translate([width-(diameter/2+4), diameter/2+7, controller_thickness-2])
            cylinder(2, diameter/2, diameter/2);

            translate([diameter/2+4, 7, controller_thickness-2])
            cube([diameter+2, diameter/2, 20]);
        }
    }
    
    cube([width, 2, height/3]);
}

module screw_hole(hole_width=4, hole_height=10) {
    head_height = hole_width*tan(45)/2;
    translate([0, 0, -hole_height]) {
        // head
        translate([0, 0, hole_height-head_height])
        cylinder(head_height, hole_width/2, hole_width);
        // screw
        cylinder(hole_height-head_height, hole_width/2, hole_width/2);
    }
}
