module turned_pillar_profile() {
    r_base   = 35 / 2;     // 17.5mm
    r_neck   = 25 / 2;     // 12.5mm
    r_spin   = 35 / 2;     // 17.5mm
    r_max    = 35 / 2;     // 17.5mm

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

    outer_pts = concat(
        [[r_base, 0], [r_base, z0 - cove_h]],
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
        [[r_base, sleeve_h]]
    );

    n_pts = len(outer_pts);
    inner_pts = [ for (i = [n_pts - 1 : -1 : 0]) let(
        pt     = outer_pts[i],
        is_end = (i == 0 || i == n_pts - 1),
        r_in   = is_end ? r_inner : max(r_inner, pt[0] - sleeve_wall_t)
    ) [r_in, pt[1]] ];

    points = concat(outer_pts, inner_pts);

    rotate_extrude()
        polygon(points);
}