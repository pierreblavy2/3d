//breadboard_measurment
bb_x=84.5;
bb_y=56.5;
bb_z=9.5;

//walls
w_fl = 3; //floor
w_si = 3; //side walls


//triangle over the board used to keep it in place
// w is the with of the triangle (perpendicular to the folliwing drawing)
//  |\
//h1|  \
//  |   \
//  |___a|h2
//    x
t_h1  = 4;
t_h2  = 1;
t_x   = 5;
t_w   = 5;

//walls and clip along the X axis must be defined manually, see the section : X_STUFF
//  bb_clip4(x1,x2) will create 4 clips according the the x coordinates of the bottom left one (lowest x values). Don't forget to add space around clips
//  bb_wall4(x1,x2) will create 4 walls according the the x coordinates of the bottom left one (lowest x values)

//=== CLIPS ====
module triangle_clip(h1,h2,x,w){
  translate([0,0,0])
  rotate([90,0,90])
  linear_extrude(w){
     polygon(
       points=[ [0,0] , [x,0] , [x,h2], [0,h1]  ]
     );
  }  
}

module bb_clip(x1,x2){

   translate([0,0,0]){
   union() {
   //wall
   linear_extrude(bb_z){
      polygon([ [x1,0] , [x2,0] , [x2 , w_si] , [x1, w_si] ]);
   }
   
   //triangle
   translate([x1,0,bb_z]){
     triangle_clip (t_h1,t_h2,t_x,x2-x1);
   }
   }}
}

module bb_clip2(x1,x2){
    union() {
    bb_clip(x1,x2);
    
    translate([x2,bb_y + 2*w_si ,0]){
        rotate([0,0,180]){
                bb_clip(0,x2-x1);
        }
    }
    }
}

module bb_clip4(x1,x2){
    union() {
    bb_clip2(x1,x2);
    bb_clip2(bb_x+2*w_si-x2, bb_x+2*w_si-x1 );
    }
}


//=== X_WALLS ====
module bb_wall(x1,x2){
   linear_extrude(bb_z){
      polygon([ [x1,0] , [x2,0] , [x2 , w_si] , [x1, w_si] ]);
   }
}

module bb_wall2(x1,x2){
   union() {    
   bb_wall(x1,x2);
    
    translate([x2,bb_y + 2*w_si ,0]){
        rotate([0,0,180]){
                bb_wall(0,x2-x1);
        }
    } 
   }
}




module bb_wall4(x1,x2){
    union() {
    bb_wall2(x1,x2);
    bb_wall2(bb_x+2*w_si-x2, bb_x+2*w_si-x1 );
    }
}





//level 0 : floor
linear_extrude(w_fl){
     polygon(
       points=[ [0,0] , [bb_x+2*w_si ,0] , [bb_x+2*w_si ,bb_y+2*w_si], [0,bb_y+2*w_si]  ]
     );
} 

//level 1 
translate([0,0,w_fl]){

    //solid wall left
    linear_extrude(bb_z){
      polygon([ [0,0] , [w_si,0] , [w_si ,bb_y+2*w_si] , [0,bb_y+2*w_si] ]);
    }
    
    //solid wall right
    linear_extrude(bb_z){
      polygon([ [bb_x+w_si,0] , [bb_x+2*w_si,0] , [bb_x + 2*w_si ,bb_y+2*w_si] , [bb_x+w_si,bb_y+2*w_si] ]);
    }
   
    //--- X_STUFF ---
    //define what's along the X axis
    
    //clip (don't forget to add holes around)
    bb_clip4(w_si+1 , w_si+1 +10 ); 
    
    //x_wall
    bb_wall4(w_si + 20, w_si + 50 ); 
    
}

