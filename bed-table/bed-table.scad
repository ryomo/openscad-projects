export_stl_mode = true;

thickness_top = 5;
recession_depth = 2;

module bed_bar(margin) {
    width = 300;
    length_top = 70;
    height_top = 20;
    length_bottom = 20;
    height_bottom = 45;
    // top
    translate([-50, 0, 0])
    cube([width, length_top+margin*2, height_top+margin*2]);
    //bottom
    translate([-50, 15-margin, -height_bottom-margin*2])
    cube([width, length_bottom+margin*2, height_bottom+margin*2]);
}

module joint(margin, bed_margin) {
    // 奥
    translate([0, margin, bed_margin])
    polyhedron(
        [
            [0, 85, 0-bed_margin],  // 0
            [0, 95, 10],            // 1
            [0, 85, 20+bed_margin], // 2
            [200, 85, 0-bed_margin],  // 3
            [200, 95, 10],            // 4
            [200, 85, 20+bed_margin], // 5
        ],
        [
            [0, 1, 2], [0, 3, 4, 1], [1, 4, 5, 2], [3, 0, 2, 5], [3, 5, 4],
        ]
    );
    // 真ん中
    padding_front = 8;
    translate([0, padding_front-margin, 0])
    cube([200, 70+margin*2+15-padding_front, 20+bed_margin*2]);
    // 手前
    thickness = 5;
    margin_front = 3;
    translate([0, -margin, bed_margin])
    polyhedron(
        [
            [0, margin_front+thickness, 0-bed_margin],  // 0
            [0, margin_front, 10],                      // 1
            [0, margin_front+thickness, 20+bed_margin], // 2
            [200, margin_front+thickness, 0-bed_margin],  // 3
            [200, margin_front, 10],                      // 4
            [200, margin_front+thickness, 20+bed_margin], // 5
        ],
        [
            [0, 2, 1], [3, 0, 1, 4], [4, 1, 2, 5], [0, 3, 5, 2], [3, 4, 5],
        ]
    );
}

module part_top() {
    width = 200;
    length = 100;
    bed_height = 20;
    height = bed_height + thickness_top;
    thickness_front = 10;
    
    difference()
    {
        // 本体
        cube([width, length, height]);
        
        // 凹み
        padding = 5;
        recession_depth = 2;
        color([0, 0, 1])
        translate([padding, padding, height-recession_depth])
        cube([width-padding*2, length-padding*2, recession_depth]);
        
        // ベッドのバー
        color([1, 0, 0])
        translate([0, thickness_front, 0])
        bed_bar(1);
        
        // 継ぎ目
        color([0, 1, 0])
        joint(1, 1);
    }
}

module part_bottom() {
    thickness = 5;
    bed_margin = 1;
    width = 200;
    length = 70;
    height_bottom = 45+thickness+bed_margin*2;
    length_bottom = 20+thickness*2+bed_margin*2;
    thickness_front = 10;

    difference()
    {
        union()
        {
            // 継ぎ目
            color([0, 1, 0])
            translate([0, 0, 1])
            joint(0, 0);
            
            // 下の部分
            color([0, 0, 1])
            translate([0, thickness_front-2, -thickness+bed_margin])
            cube([width, length+7, thickness]);
            
            // 更に下の部分
            color([0, 1, 1])
            translate([0, 20-bed_margin, -height_bottom])
            cube([width, length_bottom, height_bottom]);
        }

        // ベッドのバー
        color([1, 0, 0])
        translate([0, thickness_front, 0])
        bed_bar(1);
    }
}


// 本体
part_top();

if (export_stl_mode) {
    translate([0, 200, 21])
    rotate([180, 0, 0])
    part_bottom();
} else {
    part_bottom();
}

