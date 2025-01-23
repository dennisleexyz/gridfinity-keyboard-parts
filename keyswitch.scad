include <units.scad>

function k(sw) = sw[0]; // spacing between key centers [X-axis, Y-axis]
function kco(sw) = sw[1]; // key cutout hole [X, Y, Z-height]
function keyc(sw) = sw[2]; // keycap [X, Y]
function pins(sw) = sw[3]; // [X position, Y position, Z-height, diameter]
function pinz(sw) = max([for (pin = pins(sw)) pin.z]); // max pin Z-height
function h(sw) = sw[4]; // total switch height including pins,  excluding caps
function plate(sw) = sw[5]; // plate Z-height

presets = [
    [ // Cherry MX
        [u, u],
        [14, 14, 5],
        [18, 18],
        [
            // diameter +- 0.05
            [-3.81, 2.54, 3.3, 1.5],
            [2.54, 5.08, 3.3, 1.5],
            // diameter +- 0.1
            [0, 0, 3.3, 4],
            // diameter - 0.05
            [-5.08, 0, 3.3, 1.7],
            [5.08, 0, 3.3, 1.7],
        ],
        3.3 + 11.6 + 3.6,
        1.5,
    ],
    [ // Kailh PG1350 Choc v1
        [u, u],
        [14.50, 13.80, 2.2],
        [17.5, 16.5],
        [
            [0, 5.90, 3.00, 1.20],
            [5.00, 3.80, 3.00, 1.20],
            [0, 0, 3.00, 3.40],
            [-11.00/2, 0, 3.00, 1.90],
            [11.00/2, 0, 3.00, 1.90],
        ],
        3.00 + 5.00 + 3.00,
        1.30,
    ],
    [ // Kailh PG1353 Choc v2
        [u, u],
        [13.95, 13.95, 2.2],
        [18, 18],
        [
            [0, 5.90, 3.00, 1.20],
            [5.00, 3.80, 3.00, 1.20],
            [0, 0, 3.30, 5.00],
            [-5, -5.15, 3.00, 1.60],
        ],
        3.30 + 2.20 + 6.40,
        1.65,
    ],
];

module ksw(sw) {
    // pin holes
    for (pin = pins(sw))
        translate([pin.x, pin.y])
            cylinder(h=pin.z, d=pin[3]);
    
    // key cutout hole
    let (x = kco(sw).x, y = kco(sw).y)
        translate([-x/2, -y/2, pinz(sw)])
            cube([x, y, kco(sw).z]);
}