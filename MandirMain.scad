// Hybrid DIY Mandir with Smooth Lathe-Turned Pillars, Stepped Phamsana Shikhara, Rear Closure & Under-Deck Corner Bases
// Bounded for 220mm x 220mm x 220mm maximum 3D print volume
include<printed_diya_shelf_module.scad>;
include<printed_shikhara_module.scad>;
include<turned_pillar_profile_module.scad>;
include<parameters.scad>



// ---------- Corner Base Feet (Strictly Below Bottom Panel) ----------

module corner_base(x, y) {
    base_sq1 = 53.33;     
    base_sq2 = 45.33;     
    h_step1  = 8;         
    h_step2  = 8;         
    h_total  = h_step1 + h_step2;

    color([0.85, 0.70, 0.35]) {
        translate([x, y, 0]) {
            difference() {
                union() {
                    translate([-base_sq2/2, -base_sq2/2, -h_step2])
                        cube([base_sq2, base_sq2, h_step2]);
                    translate([-base_sq1/2, -base_sq1/2, -h_total])
                        cube([base_sq1, base_sq1, h_step1]);
                }
                translate([0, 0, -h_total - eps])
                    cylinder(h = h_total + 2*eps, r = pvc_od/2);
            }
        }
    }
}

// ---------- Lightweight Hollow Turned Pillar Profile ----------



module turned_sleeve(x, y) {
    color([0.2, 0.15, 0.12]) 
    translate([x, y, flange_bottom_h+deck_top]) {
        union() {
            // Lower half (z = 0 to sleeve_h / 2)
            turned_half_pillar_profile(r_inner, sleeve_wall_t, sleeve_h);
            
            // Upper half (mirrored and moved to full height)
            translate([0, 0, sleeve_h])
                mirror([0, 0, 1])
                    turned_half_pillar_profile(r_inner, sleeve_wall_t, sleeve_h);
        }
    }
}



// Corner Pillar Kalasas (Printed as modular parts above corner posts)
module pillar_corner_kalasas() {
     color([0.95, 0.82, 0.45]) //Gold
        for (pt = [[pillar_x1, pillar_y1], [pillar_x2, pillar_y1], 
                   [pillar_x1, pillar_y2], [pillar_x2, pillar_y2]]) {
            translate([pt[0], pt[1], roof_top])
                turned_kalasa(h = 65);
        }
    
}

// ---------- Assembly Plates & Components ----------

module bottom_wood_plate() {
    color([0.75, 0.52, 0.30]) union() {
        cube([base_w, base_d, wood_t]);
        x0 = (base_w - diya_proj_w) / 2;
        translate([x0, -diya_proj_depth, 0])
            cube([diya_proj_w, diya_proj_depth + eps, wood_t]);
    }
}

module top_wood_plate() {
    color([0.75, 0.52, 0.30])
        translate([-roof_overhang, -roof_overhang, roof_bot])
            cube([base_w + 2*roof_overhang, base_d + 2*roof_overhang, wood_t]);
}



module pvc_pipe(x, y) {
    color([0.9, 0.9, 0.9])
        translate([x, y, deck_top])
            cylinder(h = wall_h, r = pvc_od/2);
}

// ---------- Full Assembly Rendering ----------
//color([0.25, 0.15, 0.12]) //Brown 
{
bottom_wood_plate();
top_wood_plate();
printed_diya_shelf();

for (pt = [[pillar_x1, pillar_y1], [pillar_x2, pillar_y1], 
           [pillar_x1, pillar_y2], [pillar_x2, pillar_y2]]) {
    corner_base(pt[0], pt[1]);
    pvc_pipe(pt[0], pt[1]);
    turned_sleeve(pt[0], pt[1]);
}

printed_shikhara(base_w,base_d,roof_top);
pillar_corner_kalasas();
}