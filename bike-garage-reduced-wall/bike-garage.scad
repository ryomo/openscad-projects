width_lumber_qty = 8;  // x
depth_lumber_qty = 13;  // y
height_ft = 6;  // z
foot_height = 200;

width_mm = y_to_mm(8) * width_lumber_qty;  // x
depth_mm = y_to_mm(8) * depth_lumber_qty;  // y
height_mm = ft_to_mm(height_ft);  // z

echo ("<b>[SIZE]</b>", width_mm=width_mm, depth_mm=depth_mm, height_mm=height_mm);


// Suzuki Gixxer(GSX-150) mock (disabled)
*translate([300, 100, 0]) cube([785, 2005, 1030]);


// pillars
{
    two_by_four(4, 4, length_ft=6, color=[0, 1, 0]);

    translate([0, depth_mm - y_to_mm(4), 0])
    two_by_four(4, 4, length_ft=6, color=[0, 1, 0]);

    translate([width_mm - x_to_mm(4), 0, 0])
    two_by_four(4, 4, length_ft=6, color=[0, 1, 0]);

    translate([width_mm - x_to_mm(4), depth_mm - y_to_mm(4), 0])
    two_by_four(4, 4, length_ft=6, color=[0, 1, 0]);
}


// ceiling frames
translate([0, 0, height_mm + y_to_mm(4)]) {
    // back
    translate([width_mm , depth_mm - x_to_mm(2), 0])
    rotate([-90, 0, 90])
    two_by_four(2, 4, length_mm = width_mm, color=[1, 0, 0]);

    // front
    translate([width_mm , 0, 0])
    rotate([-90, 0, 90])
    two_by_four(2, 4, length_mm = width_mm, color=[1, 0, 0]);
}

for(i=[0:3]){
    translate([i * (width_mm - x_to_mm(2)) / 3, 0, 0]) {
        translate([ 0, x_to_mm(2), height_mm + y_to_mm(4)])
        rotate([-90, 0, 0])
        two_by_four(2, 4, length_mm = depth_mm - x_to_mm(2)*2, color=[0, 0, 1]);
    }
}


// piller supports
for(i=[0:2]) {
    translate([0, 0, i*(height_mm)/3])
    translate([0, 0, foot_height + y_to_mm(4)]) {
        // left
        translate([0, y_to_mm(4), 0])
        rotate([-90, 0, 0])
        two_by_four(2, 4, length_mm = depth_mm - y_to_mm(4)*2, color=[0, 1, 1]);

        // back
        translate([width_mm - x_to_mm(4), depth_mm - x_to_mm(2), 0])
        rotate([-90, 0, 90])
        two_by_four(2, 4, length_mm = width_mm - x_to_mm(4)*2, color=[0, .5, .5]);

        // right
        translate([width_mm - x_to_mm(2), y_to_mm(4), 0])
        rotate([-90, 0, 0])
        two_by_four(2, 4, length_mm = depth_mm - y_to_mm(4)*2, color=[0, 1, 1]);
    }
}


// walls
wall_lumber_x = 1;
wall_lumber_y = 8;
wall_height = height_mm + y_to_mm(4) - foot_height;
echo ("<b>[SIZE]</b>", foot_height = foot_height);

translate([0, 0, foot_height]) {
    translate([-x_to_mm(wall_lumber_x), depth_mm, 0])
    rotate([90, 0, 0])
    wall(depth_lumber_qty, wall_height, color=[1, 1, 0]);

    translate([width_mm, depth_mm + x_to_mm(1), 0])
    rotate([90, 0, -90])
    wall(width_lumber_qty, wall_height, color=[1, 1, 0]);

    *translate([width_mm, depth_mm, 0])
    rotate([90, 0, 0])
    wall(depth_lumber_qty, wall_height, color=[1, 1, 0]);
}


// ceiling
margin_width = 100;
margin_far_side = 100;
translate([-margin_width, depth_mm + margin_far_side, height_mm + x_to_mm(1) + y_to_mm(4)])
rotate([90, 90, 0])
wall(depth_lumber_qty + 1, width_mm + margin_width*2, color=[.5, .5, 0]);


// functions
// Note: `x_to_mm(4)` is different to `x_to_mm(2) * 2`.
function x_to_mm(x) = [19, 38, 63, 89][x-1];

function y_to_mm(y) = [19, 38, 63, 89, 0, 140, 0, 184, 0, 235][y-1];

function ft_to_mm(ft) = ft * 305;


module wall(lumber_qty, wall_width, color=undef) {
    for (i=[0:lumber_qty-1]) {
        translate([0, wall_width, i*y_to_mm(wall_lumber_y)])
        rotate([90, 0, 0])
        two_by_four(wall_lumber_x, wall_lumber_y, length_mm=wall_width, color=color);
    }
}


// Usage1: two_by_four(2, 4, length_ft=6)
// Usage2: two_by_four(2, 4, length_mm=2000, color=[1, 0, 0])
module two_by_four(x=2, y=4, length_ft=undef, length_mm=undef, color=undef) {
    assert(x<=y, "x must be lower than or equal to y.");
    
    x_mm = x_to_mm(x);
    y_mm = y_to_mm(y);
    _length_mm = (length_mm==undef) ? ft_to_mm(length_ft) : length_mm;

    assert(x_mm != 0, "Invalid x is set. x must be 1, 2 or 4.");
    assert(y_mm != 0, "Invalid y is set. y must be 4, 6, 8 or 10.");
    assert(_length_mm != undef, "length_ft or length_mm must be set.");
    
    color(color)
    scale([0.999, 0.999, 1])  // Scale to avoid `2-manifold` error.
    linear_extrude(_length_mm) {
        r = 5;
        translate([r, r, 0])
        offset(r)
        square([x_mm - r*2, y_mm - r*2]);
    }
    
    echo("<b>[LUMBER]</b>", x=x, y=y, length_mm=_length_mm, color=color);
}
