#!/bin/sh
for supported in \
	"[mx, choc_v1, choc_v2, x, ks33]" \
	"[choc_v1, choc_v2, x, ks33]" \
	"[x]" \
; do
	openscad \
		gridfinity-keyswitch-bins.scad \
		-qo $(echo $supported-stackable.stl | tr -d "[]" | sed 's/, /-/g') \
		-D"supported=$supported" \

	openscad \
		gridfinity-keyswitch-bins.scad \
		-qo $(echo $supported.stl | tr -d "[]" | sed 's/, /-/g') \
		-D"supported=$supported" \
		-D"stackable=false" \
; done
