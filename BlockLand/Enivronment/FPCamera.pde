public class FPCamera{
 
//Variables
 
  float x,y,z;         //Location in space of camera
  float vY;            //Vertical velocity for jumping
  float tx,ty,tz;      //Location of target point in space
  float xComp, zComp, yComp;  //Composite X and Z lengths, used in angle calculations //ADDED yComp for flashlight effect
  float angle;         //The angle of the camera to the target point with the
                       //0/180 line resting along the z axis
  float yAngle;        //The reference angle for calculating the target y location
  boolean moveUP,      //Boolean variables for movement
          moveDOWN,
          moveLEFT,
          moveRIGHT,
          moveJUMP,
          canJUMP;
           
//Pseudo-Constants (not likely to change PER CAMERA)
  int standHeight;     //How high the camera stands off the reference point
  float sensitivityX;     //How fast the camera pans left/right/up/down
  float sensitivityY;
  int targetDistance;  //How far away the target will be drawn
  int stillBox;        //Size of the area in the center of the screen
                       //where the camera will not move if the mouse is there
                        
//Debugging
  boolean drawTarget = false;
   
   
  //================================================================================== Constructor(s)
  public FPCamera(float newX, float newY, float newZ){
     
    //Location Varaibles
    x = newX;    
    y = newY;
    z = newZ;
    vY = 0;
     
    //Target Variables   
    angle = 0;
    yAngle = 0;
    tx = width/2;
    ty = height/2;
    tz = 0;
    xComp = tx - x;
    zComp = tz - z;
    yComp = ty - y;
     
    //Movement Variables
    moveUP = false;  
    moveDOWN = false;
    moveLEFT = false;
    moveRIGHT = false;
    moveJUMP = false;
    canJUMP = true;
     
    //Default Constants
    standHeight = 200;
    sensitivityX = 120;
    sensitivityY = 120;
    targetDistance = 1000;
    stillBox = 50;
     
  }
   
  /*===========================================================*\
    Name : update()
    Takes: Nothing
    Does : Calls camera(args) with new settings
    Using: Variables: XComp,ZComp,tx,x,tz,z,
           Methods: correctAngle(int,int)
  =============================================================*/
  public void update(){
    camera(x,y-standHeight,z,tx,ty,tz,0,1,0);
    if(drawTarget){
      pushMatrix();
        translate(tx,ty,tz);
        fill(random(1,255),random(1,255),random(1,255),255);
        box(50);
      popMatrix();
    }
  }
   
  /*===========================================================*\
    Name : light(int mode)
    Takes: Light option
    Does : Sets lighting by mode relative to camera location
    Using: Variables: XComp,ZComp,tx,x,tz,z,
           Methods: correctAngle(int,int)
  =============================================================*/
  public void light(int mode){
    if(mode == 1)
      directionalLight(255,255,255,xComp,yComp,zComp);
    else if (mode == 2)
      pointLight(255,255,255,x,y-standHeight,z);
    else if (mode == 3)
      spotLight(255,255,255,x,y-standHeight*10,z,0,1,0,PI/2,10);
    else if (mode == 4)
      spotLight(255,255,255,x,y-standHeight/2,z,xComp,yComp,zComp,PI,10);
  }
   
  /*===========================================================*\
    Name : look(int,int)
    Takes: mouseX and mouseY locations
    Does : Updates camera target to reflect movement of the mouse
    Using: Variables: XComp,ZComp,tx,x,tz,z,angle
           Methods: correctAngle(int,int)
  =============================================================*/
  public void look(int mX, int mY){
    float diffX = mX - width/2;
    float diffY = mY - height/2;
    float hypotenuse = cos(radians(yAngle)) * targetDistance;
     
    //Up-Down Motion===================================================UDMOTION
    if(abs(diffY) > stillBox){   
      //Increment Angle
      if(abs(yAngle + (diffY/(sensitivityY))) < 60) //Bounds: +-80 degrees
        yAngle += diffY/(sensitivityY);
    }
             
      //Application of Up-Down Motion
      ty = y + hypotenuse * sin(radians(yAngle));
      yComp = ty - y;
      hypotenuse = cos(radians(yAngle)) * hypotenuse;
 
     
    //Left-Right Motion================================================LRMOTION
    //Get current angle
      xComp = tx - x;
      zComp = tz - z;
      angle = correctAngle(xComp,zComp);
     
    if(abs(diffX) > stillBox){
      //Increment angle
      angle += diffX/(sensitivityX);
    }     
       
      //Bounds Checking (0 to 359)
      if(angle < 0)
        angle += 360;
      else if(angle >= 360)
        angle -= 360;
         
      //Calculate new  tx and tz
      float nxComp = hypotenuse * sin(radians(angle));  //New variables cause otherwise it would
      float nzComp = hypotenuse * cos(radians(angle));  //mess up the movement pretty bad.
      tx = nxComp + x;
      tz = -nzComp + z;
  }
   
  /*===========================================================*\
    Name : move(String,int)
    Takes: direction(string) and magnitude of speed(inversely proportional)
    Does : Updates location of camera relative to current angle and location
    Using: Variables: XComp,ZComp,tx,x,tz,z,ty,y
  =============================================================*/
  public void move(int movementSpeed){
    if(moveUP){
      z += zComp/movementSpeed;
      tz+= zComp/movementSpeed;
      x += xComp/movementSpeed;
      tx+= xComp/movementSpeed;
    }
    else if(moveDOWN){
      z -= zComp/movementSpeed;
      tz-= zComp/movementSpeed;
      x -= xComp/movementSpeed;
      tx-= xComp/movementSpeed;
    }
    if (moveRIGHT){
      z += xComp/movementSpeed;
      tz+= xComp/movementSpeed;
      x -= zComp/movementSpeed;
      tx-= zComp/movementSpeed;
    }
    if (moveLEFT){
      z -= xComp/movementSpeed;
      tz-= xComp/movementSpeed;
      x += zComp/movementSpeed;
      tx+= zComp/movementSpeed;
    }
  }
   
  /*===========================================================*\
    Name : jump(int)
    Takes: magnitude of jump
    Does : moves the camera up and down in a jump-esque fashion
    Using: vY, y, standheight
  =============================================================*/
  public void jump(int magnitude){
    if(canJUMP && moveJUMP){
      vY -= magnitude;
      if(vY < -20)
        canJUMP = false;
    }
    else if (y < 0)
      vY ++;
    else if (y >= 0){
      vY = 0;
      y = 0;
    }
     
    y+= vY;
} 
   
  /*===========================================================*\
    Name : correctAngle(int,int)
    Takes: x and z composite distances
    Does : converts funky-angles to regular angles
    Using: only local variables
    Returning: Appropriate angle between 0 and 360 as a float
  =============================================================*/
  public float correctAngle(float xc, float zc){
    float newAngle = -degrees(atan(xc/zc));
    if (xComp > 0 && zComp > 0)
      newAngle = (90 + newAngle)+90;
    else if (xComp < 0 && zComp > 0)
      newAngle = newAngle + 180;
    else if (xComp < 0 && zComp < 0)
      newAngle = (90+ newAngle) + 270;
    return newAngle;
  }
   
  /*===========================================================*\
    Name : keyPress(char)
    Takes: character for key-based function
    Does : enables movement in wasd directions
    Using: moveUP,moveDOWN,moveLEFT,moveRIGHT
  =============================================================*/
  public void keyPress(char button){
    if(button == 'w')
      moveUP = true; 
    else if(button == 's')
      moveDOWN = true;      
    else if(button == 'a')
      moveLEFT = true;      
    else if(button == 'd')
      moveRIGHT = true;
    if(button == ' ')
      moveJUMP = true;
  }
   
  /*===========================================================*\
    Name : keyRelease(char)
    Takes: character for key-based function
    Does : disables movement in wasd directions
    Using: moveUP,moveDOWN,moveLEFT,moveRIGHT
  =============================================================*/
  public void keyRelease(char button){
    if(button == 'w')
      moveUP = false;
    else if(button == 's')
      moveDOWN = false;
    else if(button == 'a')
      moveLEFT = false;
    else if(button == 'd')
      moveRIGHT = false;
    if(button == ' '){
      moveJUMP = false;
      canJUMP = true;
    }
  }
}

