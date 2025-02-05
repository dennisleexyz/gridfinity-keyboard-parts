# Gridfinity Mechanical Keyboard Switch Bin / Keyswitch Tester

Store and organize your mechanical switch samples, use as a switch tester. Compatible keycaps at https://github.com/dennisleexyz/keycaps.

A few pre-generated STLs are hosted for convenience. The [full source](https://github.com/dennisleexyz/gridfinity-keyboard-parts) is available for downloading and using locally with OpenSCAD Customizer (depends on loading external library files, which Thingiverse Customizer and MakerWorld Parametric Model Maker don't support).

- [Thingiverse](https://www.thingiverse.com/thing:6923422)
- [Printables.com](https://www.printables.com/model/1178769-gridfinity-mechanical-keyboard-switch-bin-keyswitc)
- [MakerWorld](https://makerworld.com/en/models/1075327)
- [Thangs](https://thangs.com/designer/dennislee/3d-model/Gridfinity%20Mechanical%20Keyboard%20Switch%20Bin%20%2F%20Keyswitch%20Tester-1261094)

## Libraries

- [gridfinity-rebuilt-openscad](https://github.com/kennetek/gridfinity-rebuilt-openscad/)
- [key.scad](https://github.com/dennisleexyz/key.scad)

The file paths are set up to work with libraries in either this folder or [OpenSCAD library path](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries).

## Settings

Tested with the following:

- Bambu Lab P1S
- 0.4 mm Stainless Steel Nozzle
- Bambu Textured PEI Plate, Smooth PEI Plate
- Overture Matte PLA White, Bambu Lab PLA Basic Orange

The holes are modeled to exact sizes specified in datasheets, but 3D printed holes shrink and become smaller. If this is an issue for you:

- [Decrease the value of `$fa` or `$fs` or increase the value of `$fn` to improve circle resolution in OpenSCAD](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#Circle_resolution:_$fa,_$fs,_and_$fn), since it only outputs `.stl` files, which don't have real circles.
- Adjust the X-Y hole compensation setting (OrcaSlicer) or the equivalent setting in your slicer of choice. I tried a value of 0.1mm and found it made things loose and wiggly.

Plate-mount-only MX switches (3-pin) need to be held by either the center pin or bottom housing to be secure. This means they cannot be used together with wider center pins (Choc v2, KS-33) and larger bottom housing cutouts (Choc v1, X) combined. Enabling KH support will also make MX PCB-mounting pins loose. TODO: alternatively the code could be reworked to align each switch by the top of the plate instead of where it touches the PCB.

Concentric Bottom surface pattern is suggested especially when there are many holes for different orientations/supported switches.

Bins larger than 4 Gridfinity bases (sizes larger than 2×2, 1×4, 4×1) may fail to generate:

```
WARNING: Normalized tree is growing past 200000 elements. Aborting normalization.  
WARNING: CSG normalization resulted in an empty tree
```

To fix this in OpenSCAD go to Edit > Preferences > Advanced > OpenCSG and increase the "Turn off rendering at 100000 elements" to a larger value, such as 500000.

The parametrization is such that grid unit sizes other than 42mm×42mm should work, but this is untested.

TODO: Fractional width bins are not yet handled correctly.

TODO: Try using lighter bins as a base such as https://www.printables.com/model/517479-reinforced-economical-gridfinity-bins-no-vase-mode

## License

The files are released under MIT license (same as the original Gridfinity by Zack Freedman and excellent gridfinity-rebuilt-openscad by kennetek, which this is based on).
