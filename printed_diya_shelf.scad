module printed_diya_shelf() {
    w  = diya_proj_w;
    d  = diya_proj_depth;
    x0 = (base_w - w) / 2;
    
    tray_h = 21.33; 
    tx = x0 + 8;    
    ty = -d + 8;
    tw = w - 16;
    td = d - 8;

    color([0.95, 0.82, 0.45]) {
        difference() {
            translate([tx, ty, deck_top])
                cube([tw, td, tray_h]);

            translate([base_w/2, -d/2, deck_top + tray_h - 6.67])
                cylinder(h = 8 + eps, r = diya_seat_r);

            num_front_arches = 5;
            arch_spacing_x  = tw / (num_front_arches + 1);
            for (i = [1 : num_front_arches]) {
                arch_cx = tx + i * arch_spacing_x;
                translate([arch_cx, ty - eps, deck_top + 4]) {
                    translate([-4, 0, 0]) cube([8, 6.67, 8]);
                    translate([0, 0, 8]) rotate([-90, 0, 0]) cylinder(h = 6.67, r = 4);
                }
            }

            num_side_arches = 3;
            arch_spacing_y  = td / (num_side_arches + 1);
            for (i = [1 : num_side_arches]) {
                arch_cy = ty + i * arch_spacing_y;
                translate([tx - eps, arch_cy, deck_top + 4]) {
                    translate([0, -4, 0]) cube([6.67, 8, 8]);
                    translate([0, 0, 8]) rotate([0, 90, 0]) cylinder(h = 6.67, r = 4);
                }
                translate([tx + tw - 6.67 + eps, arch_cy, deck_top + 4]) {
                    translate([0, -4, 0]) cube([6.67, 8, 8]);
                    translate([0, 0, 8]) rotate([0, 90, 0]) cylinder(h = 6.67, r = 4);
                }
            }
        }

        rim_h = 5.33;
        rim_t = 4.00;
        translate([tx, ty, deck_top + tray_h]) {
            cube([tw, rim_t, rim_h]);                  
            cube([rim_t, td, rim_h]);          
            translate([tw - rim_t, 0, 0])
                cube([rim_t, td, rim_h]);      
        }

        corner_pts = [
            [tx, ty],
            [tx + tw - 5.33, ty],
            [tx, ty + td - 5.33],
            [tx + tw - 5.33, ty + td - 5.33]
        ];
        for (pt = corner_pts) {
            translate([pt[0], pt[1], deck_top + tray_h]) {
                cube([5.33, 5.33, rim_h + 4]);
                translate([2.67, 2.67, rim_h + 4])
                    sphere(r = 3.33);
            }
        }
    }
}