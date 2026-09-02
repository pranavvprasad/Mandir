// Hybrid DIY Mandir with Smooth Lathe-Turned Pillars, Stepped Phamsana Shikhara, Rear Closure & Under-Deck Corner Bases
// Bounded for 220mm x 220mm x 220mm maximum 3D print volume
include<printed_diya_shelf.scad>;
include<printed_shikhara.scad>;
include<turned_kalasa.scad>
include<turned_pillar_profile.scad>

$fn = 64; // Resolution for rounded extrusions
eps = 0.05;

// ---------- Hardware & Material Parameters (Fixed Physical Hardware) ----------
wood_t        = 6.35;    // 1/4 inch wood plate thickness
cardboard_t   = 3.00;    // Standard single-wall corrugated cardboard thickness
pvc_od        = 21.34;   // 1/2" Schedule 40 PVC Pipe outer diameter
sleeve_id     = 22.20;   // Inner bore for 3D printed sleeves
r_inner       = sleeve_id / 2; // 11.1mm inner radius bore

// ---------- Sleeve Shell Thickness ----------
sleeve_wall_t = 2.0;    // Uniform hollow shell wall thickness (mm) to minimize weight

// ---------- Flange Clearance Parameters ----------
flange_bottom_h = 5.0;  // Clearance reserved at bottom for wide flat flange region (mm)
flange_top_h    = 5.0;  // Clearance reserved at top for upper mounting flange (mm)

// ---------- Main Structure Dimensions ----------
base_w = 400;             
base_d = 280;            

wall_h = 400;            
beam_h = 60;              
arch_r = 50.67;           

roof_overhang = 20;       

diya_proj_depth = 80;     
diya_proj_w     = 160;    
diya_seat_r     = 26.67;  

// ---------- Derived Coordinates & Heights ----------
deck_top   = wood_t;
pillar_top = deck_top + wall_h;
roof_bot   = pillar_top;
roof_top   = roof_bot + wood_t;

// Sleeve Height adjusted to clear top and bottom flanges
sleeve_h   = wall_h - flange_bottom_h - flange_top_h;

// Pillar Rod Center Offsets from Origin
pillar_x1 = 37.33;        
pillar_x2 = base_w - 37.33;
pillar_y1 = 37.33;        
pillar_y2 = base_d - 37.33;

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
        translate([x, y, deck_top + flange_bottom_h])
            turned_pillar_profile();
}




// Corner Pillar Kalasas (Printed as modular parts above corner posts)
module pillar_corner_kalasas() {
    color([0.95, 0.82, 0.45]) {
        for (pt = [[pillar_x1, pillar_y1], [pillar_x2, pillar_y1], 
                   [pillar_x1, pillar_y2], [pillar_x2, pillar_y2]]) {
            translate([pt[0], pt[1], roof_top])
                turned_kalasa(h = 65);
        }
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

bottom_wood_plate();
top_wood_plate();
printed_diya_shelf();

for (pt = [[pillar_x1, pillar_y1], [pillar_x2, pillar_y1], 
           [pillar_x1, pillar_y2], [pillar_x2, pillar_y2]]) {
    corner_base(pt[0], pt[1]);
    pvc_pipe(pt[0], pt[1]);
    turned_sleeve(pt[0], pt[1]);
}

printed_shikhara();
pillar_corner_kalasas();