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