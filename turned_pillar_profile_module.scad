// ---------- 3D HALF-PILLAR PROFILE (z = 0 to z = sleeve_h / 2) ----------
module turned_half_pillar_profile(r_inner, sleeve_wall_t, sleeve_h) {
    r_base   = 35 / 2;     // 17.5mm
    r_neck   = 24.5 / 2;     // 12.5mm 
    r_spin   = 35 / 2;     // 17.5mm
    r_max    = 35 / 2;     // 17.5mm

    // Scaled proportionally relative to sleeve_h
    scale_h       = sleeve_h / 400;
    h_bead        = 17.39 * scale_h;  
    h_spindle     = 104.35 * scale_h; 
    h_center      = 18.55 * scale_h;  

    // Height calculation for lower half
    h_half_middle = 2 * h_bead + h_spindle + h_center;
    h_cove        = (sleeve_h / 2) - h_half_middle;
    
    z0 = h_cove;                                          
    z1 = z0 + h_bead;                                     
    z2 = z1 + h_bead;                                     
    z3 = z2 + h_spindle;                                  

    // --- 2D LOWER HALF OUTER POINTS ---
    base_cove_pts = [ for (a = [0 : 5 : 90]) 
        [ r_neck + (r_base - r_neck) * cos(a), h_cove * sin(a) ] 
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

    half_outer_pts = concat(base_cove_pts, bead1_pts, bead2_pts, spindle1_pts, center_bead1_pts);

    // --- 2D LOWER HALF INNER BORE POINTS ---
    n_half_outer = len(half_outer_pts);
    half_inner_pts = [ for (i = [n_half_outer - 1 : -1 : 0]) let(
        pt   = half_outer_pts[i],
        r_in = max(r_inner, pt[0] - sleeve_wall_t)
    ) [r_in, pt[1]] ];

    half_points = concat(half_outer_pts, half_inner_pts);

    // Rotate extrude into a 3D half-sleeve solid
    rotate_extrude()
        polygon(half_points);
}