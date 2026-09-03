// Carves out a self-supporting 45-degree hollow pyramid from beneath
include<printed_shikhara_module.scad>
include<parameters.scad>

// ---------- Parametric Shikhara Hollowing Parameters ----------
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
    translate([-base_w / 2, -base_d / 2, -roof_top + eps])

    printed_shikhara(base_w, base_d, roof_top,includeKalasha=false);
    
    // Subtraction cutout centered at base of Shikhara
        rotate([0, 0, 45])
            cylinder(
                h      = cut_h + eps, 
                r1     = cut_r1, 
                r2     = 0, 
                $fn    = 4, 
                center = false
            ); 
}