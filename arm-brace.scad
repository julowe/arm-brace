//arm brace
//justin lowe 2020-10-25

use <dotSCAD/src/shape_circle.scad>;
use <dotSCAD/src/loft.scad>;
use <dotSCAD/src/shape_ellipse.scad>;

//intent is to create a general arm brace to attach differnt platforms to

//construction idea - create hollow cylinder, then scale so x and differnt ratios. have larger (roughly 50% coverage) arc on bottom of arm, then have smaller arc (20%?) on top of arm, velcro or some such straps around outside of both parts

//ASSUMPTION!!! : Arm height is smaller than width

//can't think of an easy way to get a cylinder with seperate X & Y radii at bottom, and another set of seperate X & Y radii at top. Buuut since this will be mostly making a half (or less?) coverage of lower arm, we'll focus on getting the width right. Height variation from cylinder we are making can be accomodated with adjusting straps

//measurements - arm laying along a table with palm and elbow on table.
//length is along the elbow to wrist axis
armLengthInches = 8;
armLengthmm = armLengthInches * 25.4;

//width is along the pinky to thumb axis
//elbow measurement is width at the end towards elbow, not at elbow
//wrist measurement is width at the end towards wrist, not at wrist, actually best immediately below wrist (or further down) to avoid modeling complicated wrist shape, be closer to arm and hold better, and also allow for wrist movement if wanted
armWidthElbowInches = 5;
armWidthElbowmm = armWidthElbowInches * 25.4;
armWidthWristInches = 3.5;
armWidthWristmm = armWidthWristInches * 25.4;
echo("armWidthElbowmm = ", armWidthElbowmm);
echo("armWidthWristmm = ", armWidthWristmm);

//postive height is along the palm to back of hand axis
//elbow measurement is width at the end towards elbow, not at elbow
//wrist measurement is width at the end towards wrist, not at wrist, actually best immediately below wrist to avoid modeling complicated wrist shape, be closer to arm and hold better, and also allow for wrist movement if wanted 
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
strapHeight = 2; //ref: 2mm is thickness of webbing, so velcro around same?
strapLoopLength = 7; //how much of the strap will be inside the loop
strapLoopInnerWallWidth = 2; //inner wall thicker to supports strap compression
strapLoopOuterWallWidth = 1; //outer wall there mostly to stop straps snagging on anything
strapLoopSpacingFromBottom = 10;
strapLoopSpacingFromTop = 10;
//strapLoopHorizontalWallWidth = 2;



    

//translate([0,-200,0]){
//    cylinder(braceVoidHeight,armHeightElbowmm/2,armHeightWristmm/2);
//}

//loft(
//    [
//        [for(p = shape_ellipse([braceVoidElbowWidth/2, braceVoidElbowDepth/2], $fn = 36)) [p[0], p[1], 0]],
//        [for(p = shape_ellipse([braceVoidWristWidth/2, braceVoidWristDepth/2], $fn = 36)) [p[0], p[1], braceVoidHeight]]        
//    ],
//    slices = 6
//);


translate([0,0,0]){
difference(){
    
    //void of brace
    loft(
    [
        [for(p = shape_ellipse([braceVoidElbowWidth/2, braceVoidElbowDepth/2], $fn = 36)) [p[0], p[1], 0]],
        [for(p = shape_ellipse([braceVoidWristWidth/2, braceVoidWristDepth/2], $fn = 36)) [p[0], p[1], braceVoidHeight]]        
    ],
    slices = 6
);
        
        
                
                //TODO here i need to make the strap holes.
                
                //difference of (which creates two strap semicircles that will be subtracted from actual arm brace)
                    //outer shell (of strap hole) equal to void + inner wall width + strap thickness
                    //then
                    //inner shell (of strap hole) equal to void + inner wall width
                    //3 cubes to cut limit how big strap holes are - top, middle, bottom
                
                    
               



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
} //end of difference between inner and outer cylinders to form brace
}


//translate([0,0,0]){
//    scale([1,braceYScaleRatio,1]){
//        cylinder(braceVoidHeight,braceVoidElbowWidth/2,braceVoidWristWidth/2);
//    }
//}

//translate([300,0,0]){
//    cylinder(braceVoidHeight,armWidthElbowmm,armWidthWristmm);
//}