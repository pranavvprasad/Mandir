// Hybrid DIY Mandir with Smooth Lathe-Turned Pillars, Stepped Phamsana Shikhara, Rear Closure & Under-Deck Corner Bases
// Bounded for 220mm x 220mm x 220mm maximum 3D print volume

$fn = 64; // Resolution for rounded extrusions
eps = 0.05;

// ---------- Hardware & Material Parameters (Fixed Physical Hardware) ----------
wood_t        = 6.35;    // 1/4 inch wood plate thickness
cardboard_t   = 3.00;    // Standard single-wall corrugated cardboard thickness
pvc_od        = 21.34;   // 1/2" Schedule 40 PVC Pipe outer diameter
sleeve_id     = 22.20;   // Inner bore for 3D printed sleeves
r_inner       = sleeve_id / 2; // 11.1mm inner radius bore

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

// ---------- Extended Turned Pillar Profile ----------

module turned_pillar_profile() {
    r_base   = 35 /2;      
    r_neck   = 25 /2;      
    r_spin   = 35 /2;      
    r_max    = 35 /2;      

    // Scaled proportionally relative to reduced sleeve_h
    scale_h     = sleeve_h / 400;
    h_base      = 46.37 * scale_h;  
    h_bead      = 17.39 * scale_h;  
    h_spindle   = 104.35 * scale_h; 
    h_center    = 18.55 * scale_h;  
    cove_h      = 11.59 * scale_h;
    
    z0 = h_base;                                         
    z1 = z0 + h_bead;                                    
    z2 = z1 + h_bead;                                    
    z3 = z2 + h_spindle;                                 
    z4 = z3 + h_center;                                  
    z5 = z4 + h_center;                                  
    z6 = z5 + h_spindle;                                 
    z7 = z6 + h_bead;                                    
    z8 = z7 + h_bead;                                    

    base_cove_pts = [ for (a = [0 : 5 : 90]) 
        [ r_neck + (r_base - r_neck) * cos(a), (z0 - cove_h) + cove_h * sin(a) ] 
    ];

    bead1_pts = [ for (a = [0 : 5 : 180]) 
        [ r_neck + (r_max - r_neck) * sin(a), z0 + h_bead * (a / 180) ] 
    ];
    
    bead2_pts = [ for (a = [0 : 5 : 180]) 
        [ r_neck + (r_max - r_neck) * sin(a), z1 + h_bead * (a / 180) ] 
    ];

    spindle1_pts = [ for (i = [0 : 30]) let(
        t = i / 30,
        swell = sin(t * 180) * (0.75 + 0.35 * sin(t * 360))
    ) [ r_neck + (r_spin - r_neck) * max(0, swell), z2 + h_spindle * t ] ];

    center_bead1_pts = [ for (a = [0 : 5 : 180]) 
        [ r_neck + (r_max - r_neck) * sin(a), z3 + h_center * (a / 180) ] 
    ];

    center_bead2_pts = [ for (a = [0 : 5 : 180]) 
        [ r_neck + (r_max - r_neck) * sin(a), z4 + h_center * (a / 180) ] 
    ];

    spindle2_pts = [ for (i = [0 : 30]) let(
        t = i / 30,
        swell = sin(t * 180) * (0.75 + 0.35 * sin(t * 360))
    ) [ r_neck + (r_spin - r_neck) * max(0, swell), z5 + h_spindle * t ] ];

    bead3_pts = [ for (a = [0 : 5 : 180]) 
        [ r_neck + (r_max - r_neck) * sin(a), z6 + h_bead * (a / 180) ] 
    ];
    
    bead4_pts = [ for (a = [0 : 5 : 180]) 
        [ r_neck + (r_max - r_neck) * sin(a), z7 + h_bead * (a / 180) ] 
    ];

    top_cove_pts = [ for (a = [0 : 5 : 90]) 
        [ r_neck + (r_base - r_neck) * sin(a), z8 + (sleeve_h - z8) * (1 - cos(a)) ] 
    ];

    points = concat(
        [[r_inner, 0], [r_base, 0], [r_base, z0 - cove_h]],
        base_cove_pts,
        bead1_pts,
        bead2_pts,
        spindle1_pts,
        center_bead1_pts,
        center_bead2_pts,
        spindle2_pts,
        bead3_pts,
        bead4_pts,
        top_cove_pts,
        [[r_base, sleeve_h], [r_inner, sleeve_h]]
    );

    rotate_extrude()
        polygon(points);
}

module turned_sleeve(x, y) {
    color([0.2, 0.15, 0.12]) 
        translate([x, y, deck_top + flange_bottom_h])
            turned_pillar_profile();
}

// ---------- Turned Kalasa Finial Module ----------

module turned_kalasa(h = 60) {
    scale_factor = h / 45;
    scale([scale_factor, scale_factor, scale_factor])
    rotate_extrude($fn = 64) {
        cove_pts  = [ for (a = [0 : 6 : 90]) [ 7.5 + 5.5 * cos(a), 2.0 + 3.0 * sin(a) ] ];
        belly_pts = [ for (a = [0 : 5 : 180]) [ 7.5 + 7.0 * sin(a), 5.0 + 17.0 * (a / 180) ] ];
        neck_pts  = [ for (a = [0 : 10 : 90]) [ 6.0 + 1.5 * cos(a), 22.0 + 2.0 * sin(a) ] ];
        ring_pts  = [ for (a = [0 : 6 : 180]) [ 6.0 + 4.5 * sin(a) - 1.5 * (a / 180), 24.0 + 7.0 * (a / 180) ] ];
        spire_pts = [ for (i = [0 : 15]) let(t = i / 15) [ 1.5 + 3.0 * pow(1 - t, 1.3), 31.0 + 12.5 * t ] ];
        tip_pts   = [ for (a = [0 : 10 : 90]) [ 1.5 * cos(a), 43.5 + 1.5 * sin(a) ] ];

        profile = concat(
            [[0, 0], [13.0, 0], [13.0, 2.0]],
            cove_pts,
            belly_pts,
            neck_pts,
            ring_pts,
            spire_pts,
            tip_pts,
            [[0, 45]]
        );
        
        polygon(profile);
    }
}

// ---------- 220x220x220 mm Bounded Shikhara (Phamsana Pyramid) ----------

module printed_shikhara() {
    color([0.95, 0.82, 0.45]) {
        cx = base_w / 2;
        cy = base_d / 2;

        translate([cx, cy, roof_top]) {
            num_tiers = 5;
            tier_h    = 20.00; // Total tier stack = 100mm
            
            // Constrained tier footprints: Tier 0 = 208mm x 208mm (fits within 220mm bed)
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