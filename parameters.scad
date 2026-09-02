$fn = 128; // Resolution for rounded extrusions
eps = 0.05;

// ---------- Hardware & Material Parameters (Fixed Physical Hardware) ----------
wood_t        = 6.35;    // 1/4 inch wood plate thickness
cardboard_t   = 3.00;    // Standard single-wall corrugated cardboard thickness
pvc_od        = 21.34;   // 1/2" Schedule 40 PVC Pipe outer diameter
sleeve_id     = 22.20;   // Inner bore for 3D printed sleeves
r_inner       = sleeve_id / 2; // 11.1mm inner radius bore

// ---------- Sleeve Shell Thickness ----------
sleeve_wall_t = 1.2;    // Uniform hollow shell wall thickness (mm) to minimize weight

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