//arm brace
//justin lowe 2020-10-25

use <dotSCAD/src/shape_circle.scad>;
use <dotSCAD/src/loft.scad>;
use <dotSCAD/src/shape_ellipse.scad>;

//intent is to create a general arm brace to attach differnt platforms to

//construction idea - create hollow cylinder, then scale so x and differnt ratios. have larger (roughly 50% coverage) arc on bottom of arm, then have smaller arc (20%?) on top of arm, velcro or some such straps around outside of both parts

//ASSUMPTION!!! : Arm height is smaller than width

//can't think of an easy way to get a cylinder with seperate X & Y radii at bottom, and another set of seperate X & Y radii at top. Buuut since this will be mostly making a half (or less?) coverage of lower arm, we'll focus on getting the width right. Height variation from cylinder we are making can be accomodated with adjusting straps


//
//
//measurements - arm laying along a table with palm and elbow on table.
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

//ratios/additions
braceVoidPadding = 2;
braceWallMinimumWidth = 3; //just using scale to make bigger cylinder because cna't hink of easy way to get constant width walls. so min width would probably be under the wrist/depth.

braceBottomCoverageRatio = 0.45; //how much of cylinder to actually print - 1 would be whole cylinder, 0.5 would be bottom half of cylinder, creating a cup like bottom. this measures from center bottom, so 0.5 will be 25% up from bottom on each side. 0.3 would be 15% up from cetner bottom towards center plane

braceTopCoverageRatio = 0.2; //same, but starting from top center

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
strapWidth = 50;
strapHeight = 3; //ref: 2mm is thickness of webbing, so velcro around same? add 1mm for printing tolerances
strapLoopLength = 7; //how much of the strap will be inside the loop
strapLoopInnerWallThickness = 2; //inner wall thicker to supports strap compression
strapLoopOuterWallThickness = 1; //outer wall there mostly to stop straps snagging on anything
strapLoopSpacingFromBottom = 10;
strapLoopSpacingFromTop = 10;
//strapLoopHorizontalWallWidth = 2;

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


//
//MAKE STUFF
//

translate([0,0,0]){
    //diffrence to make main brace wall
    difference(){
        //outermost wall of brace
        loft(
            [
                [for(p = shape_ellipse([braceOuterElbowWidth/2, braceOuterElbowDepth/2], $fn = 9)) [p[0], p[1], 0]],
                [for(p = shape_ellipse([braceOuterWristWidth/2, braceOuterWristDepth/2], $fn = 9)) [p[0], p[1], braceVoidHeight]]        
            ],
            slices = 6
        );
        
        
        //void of brace
        loft(
            [
                [for(p = shape_ellipse([braceVoidElbowWidth/2, braceVoidElbowDepth/2], $fn = 9)) [p[0], p[1], 0]],
                [for(p = shape_ellipse([braceVoidWristWidth/2, braceVoidWristDepth/2], $fn = 9)) [p[0], p[1], braceVoidHeight]]        
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


//translate([0,0,0]){
//    scale([1,braceYScaleRatio,1]){
//        cylinder(braceVoidHeight,braceVoidElbowWidth/2,braceVoidWristWidth/2);
//    }
//}

//translate([300,0,0]){
//    cylinder(braceVoidHeight,armWidthElbowmm,armWidthWristmm);
//}