// ===== INFORMATION ===== //
/*
 IMPORTANT: rendering will be better in development builds and not the official release of OpenSCAD, but it makes rendering only take a couple seconds, even for comically large bins.
 the magnet holes can have an extra cut in them to make it easier to print without supports
 tabs will automatically be disabled when gridz is less than 3, as the tabs take up too much space
 base functions can be found in "gridfinity-rebuilt-utility.scad"
 comments like ' //.5' after variables are intentional and used by the customizer
 examples at end of file

 #BIN HEIGHT
 The original gridfinity bins had the overall height defined by 7mm increments.
 A bin would be 7*u millimeters tall with a stacking lip at the top of the bin (4.4mm) added onto this height.
 The stock bins have unit heights of 2, 3, and 6:
 * Z unit 2 -> 7*2 + 4.4 -> 18.4mm
 * Z unit 3 -> 7*3 + 4.4 -> 25.4mm
 * Z unit 6 -> 7*6 + 4.4 -> 46.4mm

 ## Note:
 The stacking lip provided here has a 0.6mm fillet instead of coming to a sharp point.
 Which has a height of 3.55147mm instead of the specified 4.4mm.
 This **has no impact on stacking height, and can be ignored.**

https://github.com/kennetek/gridfinity-rebuilt-openscad

*/

include <gridfinity-rebuilt-openscad/src/core/standard.scad>
include <keyswitch.scad>
use <gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-utility.scad>
use <gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-holes.scad>
use <gridfinity-rebuilt-openscad/src/helpers/generic-helpers.scad>

// ===== PARAMETERS ===== //

/* [Setup Parameters] */
$fa = 8;
$fs = 0.25; // .01

/* [General Settings] */
// number of bases along x-axis
gridx = 3; //.5
// number of bases along y-axis
gridy = 2; //.5
// Keyswitch
switch = 0; // [0: Cherry MX, 1: Kailh PG1350 Choc v1]
sw = presets[switch];
// bin height. See bin height information and "gridz_define" below.
gridz = ceil(h(sw)/7); //.1

/* [Linear Compartments] */
// number of X Divisions (set to zero to have solid bin)
divx = 1;
// number of Y Divisions (set to zero to have solid bin)
divy = 1;

/* [Cylindrical Compartments] */
// number of cylindrical X Divisions (mutually exclusive to Linear Compartments)
cdivx = 0;
// number of cylindrical Y Divisions (mutually exclusive to Linear Compartments)
cdivy = 0;
// orientation
c_orientation = 2; // [0: x direction, 1: y direction, 2: z direction]
// diameter of cylindrical cut outs
cd = 10; // .1
// cylinder height
ch = 1;  //.1
// spacing to lid
c_depth = 1;
// chamfer around the top rim of the holes
c_chamfer = 0.5; // .1

/* [Height] */
// determine what the variable "gridz" applies to based on your use case
gridz_define = 0; // [0:gridz is the height of bins in units of 7mm increments - Zack's method,1:gridz is the internal height in millimeters, 2:gridz is the overall external height of the bin in millimeters]
// overrides internal block height of bin (for solid containers). Leave zero for default height. Units: mm
height_internal = 0;
// snap gridz height to nearest 7mm increment
enable_zsnap = false;

/* [Features] */
// the type of tabs
style_tab = 5; //[0:Full,1:Auto,2:Left,3:Center,4:Right,5:None]
// which divisions have tabs
place_tab = 0; // [0:Everywhere-Normal,1:Top-Left Division]
// how should the top lip act
style_lip = 0; //[0: Regular lip, 1:remove lip subtractively, 2: remove lip and retain height]
// scoop weight percentage. 0 disables scoop, 1 is regular scoop. Any real number will scale the scoop.
scoop = 0; //[0:0.1:1]

/* [Base Hole Options] */
// only cut magnet/screw holes at the corners of the bin to save uneccesary print time
only_corners = false;
//Use gridfinity refined hole style. Not compatible with magnet_holes!
refined_holes = false;
// Base will have holes for 6mm Diameter x 2mm high magnets.
magnet_holes = false;
// Base will have holes for M3 screws.
screw_holes = false;
// Magnet holes will have crush ribs to hold the magnet.
crush_ribs = true;
// Magnet/Screw holes will have a chamfer to ease insertion.
chamfer_holes = true;
// Magnet/Screw holes will be printed so supports are not needed.
printable_hole_top = true;
// Enable "gridfinity-refined" thumbscrew hole in the center of each base: https://www.printables.com/model/413761-gridfinity-refined
enable_thumbscrew = false;

hole_options = bundle_hole_options(refined_holes, magnet_holes, screw_holes, crush_ribs, chamfer_holes, printable_hole_top);

// ===== IMPLEMENTATION ===== //

sx = GRID_DIMENSIONS_MM.x;
sy = GRID_DIMENSIONS_MM.y;
kx = k(sw).x;
ky = k(sw).y;
kcoz = kco(sw).z;
rows = floor(sx/kx);
cols = floor(sy/ky);

difference(){
color("tomato") {
gridfinityInit(gridx, gridy, height(gridz, gridz_define, style_lip, enable_zsnap), height_internal, sl=style_lip) {

    if (divx > 0 && divy > 0) {

        cutEqual(n_divx = divx, n_divy = divy, style_tab = style_tab, scoop_weight = scoop, place_tab = place_tab);

    } else if (cdivx > 0 && cdivy > 0) {

        cutCylinders(n_divx=cdivx, n_divy=cdivy, cylinder_diameter=cd, cylinder_height=ch, coutout_depth=c_depth, orientation=c_orientation, chamfer=c_chamfer);
    }
}
gridfinityBase([gridx, gridy], hole_options=hole_options, only_corners=only_corners, thumbscrew=enable_thumbscrew);
}
pattern_linear(x=gridx, y=gridy, sx=sx, sy=sy) {
    pattern_linear(x=rows, y=cols, sx=kx, sy=ky)
        ksw(sw);
    // keycap lower cutout hole
    let (
        x = base_bottom_dimensions().x,
        y = base_bottom_dimensions().y,
        z = pinz(sw)+kcoz,
        r = r_c1
    ) {
        translate([-x/2+r, -y/2+r, z])
            rounded_square(
                [x, y, fromGridfinityUnits(1,true)-z], r
            );
    }
}
// keycap upper cutout hole
let (
    x = sx*(gridx-1)+rows*kx,
    y = sy*(gridy-1)+cols*ky,
    z = pinz(sw)+kcoz,
    r = r_base-max(sx-kx*rows, sy-ky*cols)/2
) {
    translate([-x/2+r, -y/2+r, z])
        rounded_square([x, y, fromGridfinityUnits(gridz,true)-z], r);
}
}