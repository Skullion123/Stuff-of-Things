/*=============================================//
  Ryan Darge  3d Camera Movement
   
  Date      Log
  ----      ---
  09/20/10  Project Started
  09/21/10  Added:
              -LookMode 3
              -Spotlight View Options
              -XYZ Movement
              -Jumping             
  09/23/10  Added:
              -LookMode 4
              -MoveMode 2
              -LookMode 5
            Fixed:
              -Small bug in arrow key movement (right would register as left)
  09/25/10  Added:
              -LookMode 6
              -LookMode 7
              -LookMode 8
            Fixed:
              -MoveMode 2
  09/27/10  Added:
              -SpotLightMode 4
            Fixed:
              -LookMode 8
              
  BUGLIST:
    -All fixed?
   
  Notes:
  I have to go through and add comments before
  I actually upload this -.- 
   
  Bharath gave me this to look at:
  loc.x+cos(relative+radians(90))*(senoffset)
  loc.y+sin(relative+radians(90))*(senoffset)
//=============================================*/
 
 
//Global Variables
 
  //Environment Variables
    //How am make arrysss?!
 
  //Camera Variables
    float x, y, z;
    float tx, ty, tz;
    float rotX, rotY;
    float mX, mY;
    float frameCounter;
    float xComp, zComp;
    float angle;
 
  //Movement Variables
    int moveX;
    int moveZ;
    float vY;
    boolean canJump;
    boolean moveUP, moveDOWN, moveLEFT, moveRIGHT;
    boolean xU, xD, zU, zD;
     
 
//Constants
  int ground = 0;
  int totalBoxes = 20;
  String blocktype;
  int standHeight = 100;
  int dragMotionConstant = 10;
  int pushMotionConstant = 100;
  int movementSpeed = 50;    //Bigger number = slower
  float sensitivity = 15;      //Bigger number = slower
  int stillBox = 100;        //Center of POV, mouse must be stillBox away from center to move
  float camBuffer = 10;
  int cameraDistance = 1000;  //distance from camera to camera target in lookmode... 8?
  ArrayList<PVector> blockloc;
   
//Options
  int lookMode = 8;
  int spotLightMode = 4;
  int cameraMode = 1;
  int moveMode = 2;
  

 
void setup() {
  size(800,600,P3D);
  noStroke();
   
    blockloc = new ArrayList();
    for(int y1 = 0; y1 < floor(totalBoxes / 2); y1 ++) {
      for(int x1 = 0; x1 < totalBoxes; x1 ++) {
        for(int z1 = 0; z1 < totalBoxes; z1 ++) {
          //Adding the Block Locations to blockloc for physics
          PVector block = new PVector ((width / 2 + x1 * 100 - (totalBoxes * 100 / 2) - 50), (height / 2 + y1 * 100 - (totalBoxes * 100 / 2) - 50), (z1 * 100 - (totalBoxes * 100 / 2) - 50));
          blockloc.add(block);
        }
      }
    }
   
  //Camera Initialization
  x = width / 2;
  y = height / 2;
    y-= standHeight;
  z = (height / 2.0) / tan(PI * 60.0 / 360.0);
  tx = width / 2;
  ty = height / 2;
  tz = 0;
  rotX = 0;
  rotY = 0;
  xComp = tx - x;
  zComp = tz - z;
  angle = 0;
   
  //Movement Initialization
  moveX = 0;
  moveZ = 0;
  moveUP = false;
  moveDOWN = false;
  moveLEFT = false;
  moveRIGHT = false; 
  canJump = true;
  vY = 0;
}


 
void draw() {
  
  //update frame
  background(58, 155, 160);
   
  if (spotLightMode == 0)
    lights();
  else if (spotLightMode == 1)
    spotLight(255, 255, 255, x, y - standHeight, z, tx, ty, tz, PI, 1);
  else if (spotLightMode == 2)
    spotLight(255, 255, 255, x, y - standHeight - 200, z, x + 100, y + 100, z, frameCounter / 10, 1);
  else if (spotLightMode == 3)
    spotLight(255, 255, 255, width / 2, height / 2 - 1000, 0, width / 2, height / 2, 0, PI, 1);
  else if (spotLightMode == 4)
    pointLight(255, 255, 255, x, y, z);
     
   
  //Draw Boxes
  
  for(int y1 = 0; y1 < floor(totalBoxes / 2); y1 ++) {
      if (y1 == 0)
      {
        blocktype = "grass";
      }
      else if (y1 == 1)
      {
        blocktype = "dirt";
      }
      else if (y1 == 9)
      {
        blocktype = "bedrock";
      }
      else
      {
        blocktype = "stone";
      }
    
    for(int x1 = 0; x1 < totalBoxes; x1 ++) {
      for(int z1 = 0; z1 < totalBoxes; z1 ++) {
          pushMatrix();
            translate(width / 2 + x1 * 100 - (totalBoxes * 100 / 2) - 5, height / 2 + y1 * 100 - (totalBoxes * 100 / 2), z1 * 100 - (totalBoxes * 100 / 2));
            if (blocktype == "grass")
              fill(0, 250, 20);
            else if (blocktype == "dirt")
              fill(142, 76, 14);
            else if (blocktype == "stone")
              fill(160, 160, 160);
            else if (blocktype == "bedrock")
              fill(30, 30, 30); 
            box(90);
          popMatrix();
      }
    }
  }
  
  //Checking for Solid Blocks
  zD = true;
  zU = true;
  xD = true;
  xU = true;
  
  cameraUpdate();
  locationUpdate();
  physicsEngine(10);
   
  //Camera Mode 1 - Original
  if (cameraMode == 1)
    camera(x, y, z, tx, ty, tz, 0, 1, 0);
   
  //Camera Mode 2 - Matrix'd
  if (cameraMode == 2) {
    beginCamera();
      camera();
      translate(x, y, z);
      translate(0, (2 * (-1 * standHeight)), 0);
 
      rotateX(rotY / 100.0); //This seems to work o.o
      rotateY(rotX / -100.0);
    endCamera();
  }
   
  frameCounter ++;
   
   
   
}
 
public void cameraUpdate() {
   
  //Drag-motion
  if (lookMode == 1) {
    if (pmouseX > mouseX)
      tx += dragMotionConstant;
    else if (pmouseX < mouseX)
      tx -= dragMotionConstant;
    if (pmouseY > mouseY)
      ty -= dragMotionConstant / 1.5;
    else if (pmouseY < mouseY)
      ty += dragMotionConstant / 1.5;
  }
   
  //Push-motion
  else if (lookMode == 2) {
    if (mouseX > (width / 2 + pushMotionConstant))
      tx += dragMotionConstant;
    else if (mouseX < (width / 2 - pushMotionConstant))
      tx -= dragMotionConstant;
    if (mouseY > (height / 2 + pushMotionConstant))
      ty += dragMotionConstant;
    else if (mouseY < (height / 2 - pushMotionConstant))
      ty -= dragMotionConstant;
  }
   
  //Push-motion V2 (Hopefully improved!)
  else if (lookMode == 3) {
    int diffX = mouseX - width / 2;
    int diffY = mouseY - width / 2;
     
    if (abs(diffX) > pushMotionConstant)
      tx += (diffX / 25);
    if (abs(diffY) > pushMotionConstant)
      ty += (diffY / 25);
  }
   
  //Push Motion V3 (For Camera-Mode 2)
  else if (lookMode == 4) {
    int diffX = mouseX - width / 2;
    int diffY = mouseY - width / 2;
  println(diffX);
  if (abs(diffX) > pushMotionConstant)
      rotX += diffX / 100;
    if (abs(diffY) > pushMotionConstant)
      rotY += diffY / 100;
  }
   
  //Push Motion V4.1 (Because it crashed and I lost V4.0 T.T
  //Designed to work in cohesion with movement mode 2
  else if (lookMode == 5) {
    int diffX = mouseX - width / 2;
    int diffY = mouseY - width / 2;
     
    if (abs(diffX) > stillBox) {
      xComp = tx - x;
      zComp = tz - z;
      angle = degrees(atan(xComp / zComp));
       
      //---------DEBUG STUFF GOES HERE----------
      println("tx:    " + tx);
      println("tz:    " + tz);
      println("xC:    " + xComp);
      println("zC:    " + zComp);
      println("Angle: " + angle);
      //--------------------------------------*/
       
      if (angle < 45 && angle > -45 && zComp < 0)
        tx += diffX / sensitivity;
      else if (angle < 45 && angle > -45 && zComp > 0)
        tx -= diffX / sensitivity;
         
      //Left Sector
      else if (angle > 45 && angle < 90 && xComp < 0 && zComp < 0)
        tz -= diffX / sensitivity;
      else if (angle > -90 && angle <-45 && xComp < 0 && zComp > 0)
        tz -= diffX / sensitivity;
         
      //Right Sector
      else if (angle < -45 && angle > -90)
        tz += diffX / sensitivity;
      else if (angle < 90 && angle > 45 && xComp > 0 && zComp > 0)
        tz += diffX / sensitivity;
    }
            
    if (abs(diffY) > stillBox)
      ty += diffY / (sensitivity / 1.5);
  }
   
  //Lookmode 4.2
  //Using a more proper unit circle.
  else if (lookMode == 6) {
    int diffX = mouseX - width / 2;
    int diffY = mouseY - width / 2;
     
    if (abs(diffX) > stillBox) {
      xComp = tx - x;
      zComp = tz - z;
      angle = correctAngle(xComp,zComp);
         
      //---------DEBUG STUFF GOES HERE----------
      println("tx:    " + tx);
      println("tz:    " + tz);
      println("xC:    " + xComp);
      println("zC:    " + zComp);
      println("Angle: " + angle);
      //--------------------------------------*/
       
      //Looking 'forwards'
      if ((angle >= 0 && angle < 45) || (angle > 315 && angle < 360))
        tx += diffX / sensitivity;
         
      //Looking 'left'
      else if (angle > 45 && angle < 135)
        tz += diffX / sensitivity;
         
      //Looking 'back'
      else if (angle > 135 && angle < 225)
        tx -= diffX / sensitivity;
         
      //Looking 'right'
      else if (angle > 225 && angle < 315)
        tz -= diffX / sensitivity;
        
    }
            
    if (abs(diffY) > stillBox)
      ty += diffY / (sensitivity / 1.5);
  }
   
  //Lookmode 7, trying to get rid of the slowdown in the corners with a sorta-buffer thing
  else if (lookMode == 7) {
    int diffX = mouseX - width / 2;
    int diffY = mouseY - width / 2;
     
    if (abs(diffX) > stillBox) {
      xComp = tx - x;
      zComp = tz - z;
      angle = correctAngle(xComp,zComp);
         
      //---------DEBUG STUFF GOES HERE----------
      println("tx:    " + tx);
      println("tz:    " + tz);
      println("xC:    " + xComp);
      println("zC:    " + zComp);
      println("Angle: " + angle);
      //--------------------------------------*/
 
      //Looking 'forwards'
      if ((angle >= 0 -camBuffer && angle < 45 + camBuffer) || (angle > 315 - camBuffer && angle < 360 + camBuffer))
        tx += diffX / sensitivity;
         
      //Looking 'left'
      else if (angle > 45 - camBuffer && angle < 135 + camBuffer)
        tz += diffX / sensitivity;
         
      //Looking 'back'
      else if (angle > 135 - camBuffer && angle < 225 + camBuffer)
        tx -= diffX / sensitivity;
         
      //Looking 'right'
      else if (angle > 225 - camBuffer && angle < 315 + camBuffer)
        tz -= diffX / sensitivity;
        
    }
            
    if (abs(diffY) > stillBox)
      ty += diffY/(sensitivity / 1.5);
  }
   
  else if (lookMode == 8) {
    int diffX = mouseX - width / 2;
    int diffY = mouseY - width / 2;
     
    if (abs(diffX) > stillBox) {
      xComp = tx - x;
      zComp = tz - z;
      angle = correctAngle(xComp,zComp);
        
      angle+= diffX / (sensitivity * 10);
       
      if (angle < 0)
        angle += 360;
      else if (angle >= 360)
        angle -= 360;
       
      float newXComp = cameraDistance * sin(radians(angle));
      float newZComp = cameraDistance * cos(radians(angle));
       
      tx = newXComp + x;
      tz = -newZComp + z;
     
      //---------DEBUG STUFF GOES HERE----------
      println("tx:    " + tx);
      println("tz:    " + tz);
      println("xC:    " + xComp);
      println("NewXC: " + newXComp);
      println("zC:    " + zComp);
      println("NewZC: " + newZComp);
      println("Angle: " + angle);
      //--------------------------------------*/
        
    }
            
    if (abs(diffY) > stillBox)
      ty += diffY / (sensitivity / 1.5);
  }
   
   
}
 
public void locationUpdate() {
   
  //Apply Movement
  if (moveMode == 1) {
    z += moveZ;
    tz += moveZ;
    x += moveX;
    tx += moveX;
  }
  else if (moveMode == 2) {
    if (moveUP) {
      z += zComp/movementSpeed;
      tz+= zComp/movementSpeed;
      x += xComp/movementSpeed;
      tx+= xComp/movementSpeed;
    }
    else if (moveDOWN) {
      z -= zComp/movementSpeed;
      tz-= zComp/movementSpeed;
      x -= xComp/movementSpeed;
      tx-= xComp/movementSpeed;
    }
    if (moveRIGHT) {
      z += xComp/movementSpeed;
      tz+= xComp/movementSpeed;
      x -= zComp/movementSpeed;
      tx-= zComp/movementSpeed;
    }
    if (moveLEFT) {
      z -= xComp/movementSpeed;
      tz-= xComp/movementSpeed;
      x += zComp/movementSpeed;
      tx+= zComp/movementSpeed;
    }
  }
}
 
public void physicsEngine(int magnitude) {
    for(int zDh = 0; zDh < blockloc.size(); zDh ++) {
      if (zD == true) {
        if ((z - 10) > (blockloc.get(zDh).z) && (z - 10) < (blockloc.get(zDh).z + 100) && (((x - 10) > (blockloc.get(zDh).x) && (x - 10) < (blockloc.get(zDh).x + 100)) || ((x + 10) > (blockloc.get(zDh).x) && (x + 10) < (blockloc.get(zDh).x + 100))) && (((y) > (blockloc.get(zDh).y) && (y) < (blockloc.get(zDh).y + 100)) || ((y - 100) > (blockloc.get(zDh).y) && (y - 100) < (blockloc.get(zDh).y)))) {
          zD = false;
          moveZ = 0;
          moveUP = false;
        }
      }
    }
    if (zU == true) {
      for(int zUh = 0; zUh < blockloc.size(); zUh ++) {
        if ((z + 10) > (blockloc.get(zUh).z) && (z + 10) < (blockloc.get(zUh).z + 100) && (((x - 10) > (blockloc.get(zUh).x) && (x - 10) < (blockloc.get(zUh).x + 100)) || ((x + 10) > (blockloc.get(zUh).x) && (x + 10) < (blockloc.get(zUh).x + 100))) && (((y) > (blockloc.get(zUh).y) && (y) < (blockloc.get(zUh).y + 100)) || ((y - 100) > (blockloc.get(zUh).y) && (y - 100) < (blockloc.get(zUh).y)))) {
          zU = false;
          moveZ = 0;
          moveDOWN = false;
        }
      }
    }
    if (xD == true) {
      for(int xDh = 0; xDh < blockloc.size(); xDh ++) {
        if ((x - 10) > (blockloc.get(xDh).x) && (x - 10) < (blockloc.get(xDh).x + 100) && (((z - 10) > (blockloc.get(xDh).z) && (z - 10) < (blockloc.get(xDh).z + 100)) || ((z + 10) > (blockloc.get(xDh).z) && (z + 10) < (blockloc.get(xDh).z + 100))) && (((y) > (blockloc.get(xDh).y) && (y) < (blockloc.get(xDh).y + 100)) || ((y - 100) > (blockloc.get(xDh).y) && (y - 100) < (blockloc.get(xDh).y)))) {
          xD = false;
          moveX = 0;
          moveLEFT = false;
        }
      }
    }
    if (xU == true) {
      for(int xUh = 0; xUh < blockloc.size(); xUh ++) {
        if ((x + 10) > (blockloc.get(xUh).x) && (x + 10) < (blockloc.get(xUh).x + 100) && (((z - 10) > (blockloc.get(xUh).z) && (z - 10) < (blockloc.get(xUh).z + 100)) || ((z + 10) > (blockloc.get(xUh).z) && (z + 10) < (blockloc.get(xUh).z + 100))) && (((y) > (blockloc.get(xUh).y) && (y) < (blockloc.get(xUh).y + 100)) || ((y - 100) > (blockloc.get(xUh).y) && (y - 100) < (blockloc.get(xUh).y)))) {
          xU = false;
          moveX = 0;
          moveRIGHT = false;
        }
      }
    }
 for (int block; block < blockloc.size(); block ++) {   
  if (keyPressed && key == ' ' && canJump) {
    vY -= magnitude;

    if (vY < -20)
      canJump = false;
    }
  else if ((z) > (blockloc.get(block).z) && (z) < (blockloc.get(block).z + 100) && (x) > (blockloc.get(block).x) && (x) < (blockloc.get(block).x + 100) && (y - standHeight) < (blockloc.get(block).y))
    vY ++;
  else if ((z) > (blockloc.get(block).z) && (z) < (blockloc.get(block).z + 100) && (x) > (blockloc.get(block).x) && (x) < (blockloc.get(block).x + 100) && (y - standHeight) >= (blockloc.get(block).y)) {
    vY = 0;
    y = ground + standHeight;
  }
   
  if ((!canJump) && (!keyPressed)) {
    println ("Jump Reset!");
    canJump = true;
  }
  y += vY;
 }
}
 
public void keyPressed() {
  if (keyCode == UP || key == 'w') {
    if (zD) {
      moveZ = -10;
      moveUP = true;
    }
    else {
      moveZ = 0;
      moveUP = false;
    }
  }
   
  else if (keyCode == DOWN || key == 's') {
    if (zU) {
      moveZ = 10;
      moveDOWN = true;
    }
    else {
      moveZ = 0;
      moveDOWN = false;
    }
  }
  
  else if (keyCode == LEFT || key == 'a') {
    if (xU) {
      moveX = -10;
      moveLEFT = true;
    }
    else {
      moveX = 0;
      moveLEFT = false;
    }
  }
   
  else if (keyCode == RIGHT || key == 'd') {
    if (xD) {
      moveX = 10;
      moveRIGHT = true;
    }
    else {
      moveX = 0;
      moveRIGHT = false;
    }
  }
}
 
public void keyReleased() {
  if (keyCode == UP || key == 'w') {
    moveUP = false;
    moveZ = 0;
  }
  else if (keyCode == DOWN || key == 's') {
    moveDOWN = false;
    moveZ = 0;
  }
     
  else if (keyCode == LEFT || key == 'a') {
    moveLEFT = false;
    moveX = 0;
  }
   
  else if (keyCode == RIGHT || key == 'd') {
    moveRIGHT = false;
    moveX = 0;
  }
}
 
public float correctAngle(float xc, float zc) {
  float newAngle = -degrees(atan(xc / zc));
  if (xComp > 0 && zComp > 0)
    newAngle = (90 + newAngle) + 90;
  else if (xComp < 0 && zComp > 0)
    newAngle = newAngle + 180;
  else if (xComp < 0 && zComp < 0)
    newAngle = (90 + newAngle) + 270;
  return newAngle;
}
 
/*Conclusions:
  Increasing ty rotates field of view down
    vice versa for reverse
     
  Increasing tX rotates field of view right
    vice versa for reverse
*/

