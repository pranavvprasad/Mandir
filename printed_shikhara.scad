// ---------- 220x220x220 mm Bounded Shikhara (Phamsana Pyramid) ----------

module printed_shikhara() {
    color([0.95, 0.82, 0.45]) {
        cx = base_w / 2;
        cy = base_d / 2;

        translate([cx, cy, roof_top]) {
            num_tiers = 5;
            tier_h    = 20.00; // Total tier stack = 100mm
            
            tier_dims = [
                [208.00, 208.00], 
                [165.00, 165.00], 
                [122.00, 122.00], 
                [82.00,  82.00],  
                [48.00,  48.00]   
            ];

            for (i = [0 : num_tiers - 1]) {
                tw = tier_dims[i][0];
                td = tier_dims[i][1];
                tz = i * tier_h;

                translate([-tw/2, -td/2, tz]) {
                    cube([tw, td, 4]);
                    translate([2.67, 2.67, 4])
                        cube([tw - 5.33, td - 5.33, tier_h - 8]);
                    translate([-2.67, -2.67, tier_h - 4])
                        cube([tw + 5.33, td + 5.33, 4]);
                }

                if (i == 1 || i == 2) {
                    tx_corner = tw / 2 - 8;
                    ty_corner = td / 2 - 8;
                    for (mx = [-tx_corner, tx_corner]) {
                        for (my = [-ty_corner, ty_corner]) {
                            translate([mx, my, tz + tier_h])
                                turned_kalasa(h = 28); 
                        }
                    }
                }
            }

            top_z = num_tiers * tier_h; // 100mm
            translate([0, 0, top_z]) {
                cylinder(h = 5.00, r1 = 26.00, r2 = 22.00);
                translate([0, 0, 5.00])
                    cylinder(h = 10.00, r = 22.00, $fn = 64);
                translate([0, 0, 15.00])
                    turned_kalasa(h = 60.00); // Top spire finial
            }
        }
    }
}