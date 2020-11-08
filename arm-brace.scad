//arm brace
//justin lowe 2020-10-25
//uses this library: https://github.com/JustinSDK/dotSCAD

use <dotSCAD/src/shape_circle.scad>;
use <dotSCAD/src/loft.scad>;
use <dotSCAD/src/shape_ellipse.scad>;

//intent is to create a general arm brace to attach differnt platforms to

//construction idea - create hollow cylinder, then scale so x and differnt ratios. have larger (roughly 50% coverage) arc on bottom of arm, then have smaller arc (20%?) on top of arm, velcro or some such straps around outside of both parts

//ASSUMPTION!!! : Arm height is smaller than width

//TODO make attachment point at wrist end of brace for different platforms
//TODO round edges
//TODO think about differnt attachment points & methods
  //e.g. pressfit holes in brace shells? bottom slot for palm/finger accessible platforms?box on top for arduino for keyboards or costume stuff?
 
//TODO paste libraries' text inside this file so this model/file works in the thingiverse customizer? 

//TODO figure out if better to subtract angles and/or inside/void from ellipse and then loft, or do after as we do here with cubes sutracting aroudn the brace and another lofted ellipse subtracting the void. can we difference two shape_ellipse functions and still ahve the points needed to loft it?

draftingFNs = 18;
renderingFNs = 180;
currentFNs = draftingFNs;
//draftingFNs can leave weird zero/non-zero plane at top of void...

//
//
//arm measurements - arm laying along a table with palm and elbow on table.
//
//

//LENGTH is along the elbow to wrist axis
armLengthInches = 8;
armLengthmm = armLengthInches * 25.4;

//WIDTH is along the pinky to thumb axis
//elbow measurement is width at the end towards elbow, not at elbow
//wrist measurement is width at the end towards wrist, not at wrist, actually best immediately below wrist (or further down) to avoid modeling complicated wrist shape, be closer to arm and hold better, and also allow for wrist movement if wanted
armWidthElbowInches = 5;
armWidthElbowmm = armWidthElbowInches * 25.4;
armWidthWristInches = 3.5;
armWidthWristmm = armWidthWristInches * 25.4;
echo("armWidthElbowmm = ", armWidthElbowmm);
echo("armWidthWristmm = ", armWidthWristmm);

//HEIGHT (postive) is along the palm to back of hand axis
//elbow measurement is height at the end towards elbow, not at elbow
//wrist measurement is height at the end towards wrist, not at wrist, actually best immediately below wrist to avoid modeling complicated wrist shape, be closer to arm and hold better, and also allow for wrist movement if wanted 
armHeightElbowInches = 3;
armHeightElbowmm = armHeightElbowInches * 25.4;
armHeightWristInches = 2;
armHeightWristmm = armHeightWristInches * 25.4;
echo("armHeightElbowmm = ", armHeightElbowmm);
echo("armHeightWristmm = ", armHeightWristmm);

//
//
//END arm measurements - arm laying along a table with palm and elbow on table.
//
//

//ratios/additions
braceVoidPadding = 2; //added space between arm and actual brace
//TODO delete if no longer needed
//braceWallMinimumWidth = 3; //just using scale to make bigger cylinder because cna't hink of easy way to get constant width walls. so min width would probably be under the wrist/depth.

braceBottomCoverageRatio = 0.45; //how much of cylinder to actually print - 1 would be whole cylinder, 0.5 would be bottom half of cylinder, creating a cup like bottom. this measures from center bottom, so 0.5 will be 25% up from bottom on each side. 0.3 would be 15% up from cetner bottom towards center plane

braceTopCoverageRatio = 0.3; //same, but starting from top center

if ( braceBottomCoverageRatio > 1 ){
    echo("FAIL - ratio above 1 not supported. Or sensical");
}


//then of course we switch up the axes... picturing rasiing you hand, elbow still on table but with arm pointing straight up now.

//positive brace height is arm length, elbow at/near origin, then towards the wrist is up (and positive Z)
braceVoidHeight = armLengthmm;

//brace width is same as arm width, but origin is in middle, so for a right arm then from center to pinky is positive X, from center to thumb is negative X 
braceVoidElbowWidth = armWidthElbowmm + braceVoidPadding*2;
braceVoidWristWidth = armWidthWristmm + braceVoidPadding*2;
//todo account for scaling on Y and make this different?

//brace depth is arm height, origin again in middle, so positive Y is form center to palm, negative Y is from center to back of hand
braceVoidElbowDepth = armHeightElbowmm + braceVoidPadding*2;
braceVoidWristDepth = armHeightWristmm + braceVoidPadding*2;
//braceVoidElbowDepth = armHeightElbowmm;
//braceVoidWristDepth = armHeightWristmm;


//strap measurements
strapWidth = 30;
strapHeight = 3; //ref: 2mm is thickness of webbing, so velcro around same? add 1mm for printing tolerances

//TODO huh? what did i mean for this variable below??
strapLoopLength = 7; //how much of the strap will be inside the loop

strapLoopInnerWallThickness = 1; //inner wall thicker to supports strap compression
strapLoopOuterWallThickness = 2; //outer wall there mostly to stop straps snagging on anything
//TODO changing this from 1 makes a weird plane appear at top of brace.... FIXME
//workaround so far is to set FNs higher and that stops this... ?


//FIXME yeah this isn't used. use or delete.
strapLoopSpacingFromBottom = 10;
strapLoopSpacingFromTop = 14;
//strapLoopHorizontalWallWidth = 2;

attachmentTongueThickness = 3; //how thick is tongue of hand/etc attachment joint that goes into brace
attachmentTongueThicknessTolerance = 0.2; //how much gap to leave between each side of tongue that goes into brace
attachmentTongueLength = 30;
//braceBottomCoverageRatio
attachmentTongueCoverageRatio = 0.2;

strapWallInnerElbowWidth = (strapLoopInnerWallThickness)*2 + braceVoidElbowWidth;
strapWallInnerElbowDepth = (strapLoopInnerWallThickness)*2 + braceVoidElbowDepth;
strapWallInnerWristWidth = (strapLoopInnerWallThickness)*2 + braceVoidWristWidth;
strapWallInnerWristDepth = (strapLoopInnerWallThickness)*2 + braceVoidWristDepth;

strapWallOuterElbowWidth = (strapHeight + strapLoopInnerWallThickness)*2 + braceVoidElbowWidth;
strapWallOuterElbowDepth = (strapHeight + strapLoopInnerWallThickness)*2 + braceVoidElbowDepth;
strapWallOuterWristWidth = (strapHeight + strapLoopInnerWallThickness)*2 + braceVoidWristWidth;
strapWallOuterWristDepth = (strapHeight + strapLoopInnerWallThickness)*2 + braceVoidWristDepth;

braceOuterElbowWidth = (strapLoopOuterWallThickness + strapHeight + strapLoopInnerWallThickness)*2 + braceVoidElbowWidth;
braceOuterElbowDepth = (strapLoopOuterWallThickness + strapHeight + strapLoopInnerWallThickness)*2 + braceVoidElbowDepth;
braceOuterWristWidth = (strapLoopOuterWallThickness + strapHeight + strapLoopInnerWallThickness)*2 + braceVoidWristWidth;
braceOuterWristDepth = (strapLoopOuterWallThickness + strapHeight + strapLoopInnerWallThickness)*2 + braceVoidWristDepth;

echo("braceVoidElbowWidth = ", braceVoidElbowWidth);
echo("braceOuterElbowWidth = ", braceOuterElbowWidth);

strapXelbowOffset = braceVoidHeight/4;
strapXwristOffset = braceVoidHeight/4*3;

echo("strapXelbowOffset = ", strapXelbowOffset);
echo("strapXwristOffset = ", strapXwristOffset);

if (attachmentTongueLength > braceVoidHeight-strapXwristOffset) {
    echo("FAIL - attachment Tongue Length is too long and will stick into strap path");
    //ugh make a better fail or make an if statement that matter down below
}


//
//MAKE STUFF
//

//subtract strap voids from main brace wall
difference(){
    translate([0,0,0]){
        //diffrence to make main brace wall
        difference(){
            //outermost wall of brace
            loft(
                [
                    [for(p = shape_ellipse([braceOuterElbowWidth/2, braceOuterElbowDepth/2], $fn = currentFNs)) [p[0], p[1], 0]],
                    [for(p = shape_ellipse([braceOuterWristWidth/2, braceOuterWristDepth/2], $fn = currentFNs)) [p[0], p[1], braceVoidHeight]]        
                ],
                slices = 6
            );
            
            
            //void of brace
            loft(
                [
                    [for(p = shape_ellipse([braceVoidElbowWidth/2, braceVoidElbowDepth/2], $fn = currentFNs)) [p[0], p[1], 0]],
                    [for(p = shape_ellipse([braceVoidWristWidth/2, braceVoidWristDepth/2], $fn = currentFNs)) [p[0], p[1], braceVoidHeight]]        
                ],
                slices = 6
            );
                
        
            //KEEP
            if ( braceBottomCoverageRatio <= 0.5 ) {
                translate([0,0,0]){
                    rotate([0,0,-180*(0.5-braceBottomCoverageRatio)]){
                        color("Red")
                        cube([braceVoidElbowWidth,braceVoidElbowDepth,braceVoidHeight]);
                    }
                }
                translate([0,0,0]){
                    rotate([0,0,180*(0.5-braceBottomCoverageRatio)]){
                        rotate([0,0,90]){
                        color("Blue")
                            //swap X & Y b/c of 90 deg rotation
                        cube([braceVoidElbowDepth,braceVoidElbowWidth,braceVoidHeight]);
                        }
                    }
                }
                
                translate([-braceVoidElbowWidth/2,0,0]){
                    color("Green")
                    cube([braceVoidElbowWidth,braceVoidElbowDepth,braceVoidHeight]);
                }
            } else { //end of first if clause for rotating subtraction cubes
                echo("fail. less than 0.5 coverage ratio of bottom brace not coded yet.");
            } //end of if for rotating subtraction cubes
        } //end of difference between inner and outer cylinders to form main brace wall
    } //end of translate
    //whitespace
    
    
    //
    // STRAPS
    //
    translate([0,0,0]){
        //removing cubes from strap wall to make positive objects which will be strap voids
        difference(){
        //diffrence to make overall strap brace wall
            difference(){
                //outermost strap wall
                loft(
                    [
                        [for(p = shape_ellipse([strapWallOuterElbowWidth/2, strapWallOuterElbowDepth/2], $fn = currentFNs)) [p[0], p[1], 0]],
                        [for(p = shape_ellipse([strapWallOuterWristWidth/2, strapWallOuterWristDepth/2], $fn = currentFNs)) [p[0], p[1], braceVoidHeight]]        
                    ],
                    slices = 6
                );
                
                //inner strap wall
                loft(
                    [
                        [for(p = shape_ellipse([strapWallInnerElbowWidth/2, strapWallInnerElbowDepth/2], $fn = currentFNs)) [p[0], p[1], 0]],
                        [for(p = shape_ellipse([strapWallInnerWristWidth/2, strapWallInnerWristDepth/2], $fn = currentFNs)) [p[0], p[1], braceVoidHeight]]        
                    ],
                    slices = 6
                );
         
            } //end of difference between inner and outer lofted objects to form overall strap wall 
            
            //TODO change so you can specify 'distance from ends' for random lengths of brace and easier placing of strap holes in general if desired
            //
            //remove cubes
            //elbow cube offset
            translate([-strapWallOuterElbowWidth/2, -strapWallOuterElbowDepth/2, 0]){
                cube([strapWallOuterElbowWidth, strapWallOuterElbowDepth, strapXelbowOffset-strapWidth/2]);
            }
            
            //middle cube offset
            translate([-strapWallOuterElbowWidth/2, -strapWallOuterElbowDepth/2, strapXelbowOffset+strapWidth/2]){
                cube([strapWallOuterElbowWidth, strapWallOuterElbowDepth, (strapXwristOffset-strapWidth/2) - (strapXelbowOffset+strapWidth/2)]);
            }
            
            //now some fanciness to make the tongue attachment void
            //area right above wrist strap
//            translate([-strapWallOuterElbowWidth/2, -strapWallOuterElbowDepth/2, strapXwristOffset+strapWidth/2]){
//                cube([strapWallOuterElbowWidth, strapWallOuterElbowDepth, braceVoidHeight - (strapXwristOffset+strapWidth/2)]);
////                cube([strapWallOuterElbowWidth, strapWallOuterElbowDepth, braceVoidHeight - (strapXwristOffset+strapWidth/2)-attachmentTongueLength]);
//            }
            
            //tongue attachment void
            difference(){
                translate([-strapWallOuterElbowWidth/2, -strapWallOuterElbowDepth/2, strapXwristOffset+strapWidth/2]){
                    cube([strapWallOuterElbowWidth, strapWallOuterElbowDepth, braceVoidHeight - (strapXwristOffset+strapWidth/2)]);
                }

                xCoordAttachmentTongueAngleCutout = tan((attachmentTongueCoverageRatio/2)*360)*100;
                
                translate([0,0,braceVoidHeight-attachmentTongueLength]){
                    linear_extrude(attachmentTongueLength){
                        polygon([
                        [0,0],
                        [xCoordAttachmentTongueAngleCutout,-100],
                        [-xCoordAttachmentTongueAngleCutout,-100]
                        ]);
                    }
                }
                
                
            }
            
        } //end of cube subtraction difference
    } //end of translate
}
//whitespace



//        translate([-strapWallOuterElbowWidth/2, -strapWallOuterElbowDepth/2, 0]){
//            color("Green", 0.3)
//            cube([strapWallOuterElbowWidth, strapWallOuterElbowDepth, strapXelbowOffset-strapWidth/2]);
//        }
        
//translate([0,0,0]){
//    scale([1,braceYScaleRatio,1]){
//        cylinder(braceVoidHeight,braceVoidElbowWidth/2,braceVoidWristWidth/2);
//    }
//}

//translate([300,0,0]){
//    cylinder(braceVoidHeight,armWidthElbowmm,armWidthWristmm);
//}