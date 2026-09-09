include<turned_kalasa_module.scad>

module printed_diya_shelf() {
    w  = diya_proj_w;
    d  = diya_proj_depth;
    x0 = (base_w - w) / 2;
    
    tray_h = 24.0; 
    tx = x0 + 8; 
    ty = -d + 8;
    tw = w - 16;
    td = d - 8;
    
    // True center of the tray platform
    center_x = tx + tw / 2;
    center_y = ty + td / 2;
    
    num_steps  = 3;           
    step_h      = tray_h / num_steps; 
    step_inset  = 3.5;        

    eps = 0.01;
    $fn = 64;

    color([0.95, 0.82, 0.45]) { 
        difference() {
            // 1. Stepped Pyramid Base
            union() {
                for (i = [0 : num_steps - 1]) {
                    inset = i * step_inset;
                    translate([tx + inset, ty + inset, deck_top + (i * step_h)])
                        cube([tw - (2 * inset), td - (2 * inset), step_h]);
                }
            }

            // 2. Central Diya Seating Recess (Centered on Platform)
            translate([center_x, center_y, deck_top + tray_h - 8])
                cylinder(h = 8 + eps, r = diya_seat_r);

            // Chamfered Entry Ring
            translate([center_x, center_y, deck_top + tray_h - 2])
                cylinder(h = 2 + eps, r1 = diya_seat_r, r2 = diya_seat_r + 2.5);
        }

        // 3. Mini Corner Finials on Top Tier
        top_inset = (num_steps - 1) * step_inset;
        top_w = tw - (2 * top_inset);
        top_d = td - (2 * top_inset);
        top_tx = tx + top_inset;
        top_ty = ty + top_inset;

        corner_pts = [
            [top_tx + 4, top_ty + 4],
            [top_tx + top_w - 4, top_ty + 4],
            [top_tx + 4, top_ty + top_d - 4],
            [top_tx + top_w - 4, top_ty + top_d - 4]
        ];

        /*for (pt = corner_pts) {
            translate([pt[0], pt[1], deck_top + tray_h]) {
                turned_kalasa(14);
            }
        }*/
    }
}