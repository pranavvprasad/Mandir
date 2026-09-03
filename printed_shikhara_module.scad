// ---------- 220x220x220 mm Bounded Shikhara (Phamsana Pyramid) ----------
include<turned_kalasa_module.scad>
module printed_shikhara_hollow(base_w,base_d,roof_top,includeKalasha=true) {
    shikhara_h    = num_tiers * tier_h;              // Total height of stacked tiers
    bottom_tier_w = tier_dims[0][0];                 // Footprint width of bottom-most tier
    wall_margin   = 4.0;                             // Minimum rim/wall thickness at base

    // ---------- 45-Degree Self-Supporting Geometry Derivations ----------
    // For a 45-degree angle, rise = run, meaning Height = Base_Width / 2
    cut_base_w    = bottom_tier_w - (2 * wall_margin); 
    cut_h         = cut_base_w / 2;                  

    // OpenSCAD cylinder $fn=4$ radius calculation:
    // An axis-aligned square of width W rotated 45° has a vertex radius r = (W / 2) * sqrt(2)
    cut_r1        = (cut_base_w / 2) * sqrt(2);

    // ---------- Hollowed Assembly ----------
    difference() {
        
        printed_shikhara_solid(base_w, base_d, roof_top,includeKalasha);
        
        // Subtraction cutout centered at base of Shikhara
        translate([base_w / 2, base_d / 2, roof_top - eps])
            rotate([0, 0, 45])
                cylinder(
                    h      = cut_h + eps, 
                    r1     = cut_r1, 
                    r2     = 0, 
                    $fn    = 4, 
                    center = false
                ); 
    }
}

module printed_shikhara_solid(base_w,base_d,roof_top,includeKalasha=true) {
    color([0.95, 0.82, 0.45]) {
        cx = base_w / 2;
        cy = base_d / 2;

        translate([cx, cy, roof_top]) {
            
            

            for (i = [0 : num_tiers - 1]) {
                tw = tier_dims[i][0];
                td = tier_dims[i][1];
                tz = i * tier_h;

                translate([-tw/2, -td/2, tz]) {
                    // Layer 1: Base step (4mm)
                    cube([tw, td, 4]);
                    
                    // Layer 2: Recessed middle neck (8mm)
                    translate([2.67, 2.67, 4])
                        cube([tw - 5.33, td - 5.33, 8]);
                        
                    // Layer 3: 45-degree chamfer transition (5.33mm rise over 5.33mm run)
                    translate([tw/2, td/2, 12])
                        rotate([0, 0, 45])
                            cylinder(
                                h  = 4, 
                                r1 = ((tw - 5.33) / 2) * sqrt(2), 
                                r2 = ((tw + 5.33) / 2) * sqrt(2), 
                                $fn = 4
                            );
                    
                    // Layer 3: Top overhang cap (4mm)
                    translate([-2.67, -2.67, 16])
                        cube([tw + 5.33, td + 5.33, 4]);
                }
                if (includeKalasha &&(i == 1 || i == 2)) {
                    tx_corner = tw / 2 - 8;
                    ty_corner = td / 2 - 8;
                    for (mx = [-tx_corner, tx_corner]) {
                        for (my = [-ty_corner, ty_corner]) {
                            translate([mx, my, tz + tier_h])
                                turned_kalasa(h = 28,fn=64); 
                        }
                    }
                }
            }

            top_z = num_tiers * tier_h; // 100mm
            translate([0, 0, top_z]) {
                cylinder(h = 5.00, r1 = 26.00, r2 = 22.00);
                translate([0, 0, 5.00])
                    cylinder(h = 10.00, r = 22.00, $fn = 128);
                if (includeKalasha)
                translate([0, 0, 15.00])
                    turned_kalasa(h = 60.00,fn=64); // Top spire finial
            }
                        

        }
    }
}
