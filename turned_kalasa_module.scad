
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