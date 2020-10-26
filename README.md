# arm-brace
OpenSCAD model of arm brace

## Status
First steps in first rough cut of arm brace off of user input measurements.

STL files are created from notional arm measurements of:

Arm length in inches = 8;

Arm Width at Elbow in Inches = 5;
Arm Width at Wrist in Inches = 3.5;

Arm Height at Elbow in Inches = 3;
Arm Height at Wrist in Inches = 2;

Have not yet printed, but Cura gives the following info for bottom brace (larger, with 45% arm coverage):
101g, 3.56267oz weight at 30% cubic infill.
Would take about 9.5 hours to print and have a 138.9 x 39.0 x 203.2 mm print area.

Most 1.75mm diameter filament spools are 1kg for about $25, so this would only cost $2.50 to print this. Even less for smaller braces.

## Measurement Descriptions & Picture
Measurements are taken from an arm laying along a table with palm and elbow on table.

Length is along the elbow to wrist axis.
Width is along the pinky to thumb axis.
Height is along the palm to back of hand axis.

"Elbow" measurement is the width or height at the end of the brace which is towards the elbow (not at the elbow).

"Wrist" measurement is width or height at the end of the brace which is towards the wrist (not at wrist). Probably actually best if measurement is taken immediately below wrist (or even further down) to avoid the need to model the complicated wrist shape and so the brace is closer to arm and will move around less. And then also it will allow for wrist movement if wanted.

TODO Add picture with axis drawn on.


## Images

Quick screenshots of models form side and bottom showing curvature of 30% coverage of top side of arm and hoepfully showing strap holes that go through the model.

![Side Preview](arm-brace-upper-preview-side.png "Preview of Top side of arm brace from side")
![Bottom Preview](arm-brace-upper-preview-bottom.png "Preview of Top side of arm brace from bottom (side touching arm)")
