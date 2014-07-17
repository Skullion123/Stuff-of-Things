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
   boolean isNotBlockLeft;
   boolean isNotBlockRight;
   
   boolean creative = false; 
   
  //Camera Variables
    float x, y, z;
    float tx, ty, tz;
    float rotX, rotY; 
    float mX, mY;
    float frameCounter;
    float xComp, zComp;
    float angle;
    
//Constants
    int ground = 0;
    int totalBoxes = 20;
    int standHeight = 100;
    int dragMotionConstant = 10;
    int pushMotionConstant = 100;
    int movementSpeed = 50;    //Bigger number = slower
    float sensitivity = 15;      //Bigger number = slower
    int stillBox = 100;        //Center of POV, mouse must be stillBox away from center to move
    float camBuffer = 10;
    int cameraDistance = 1000;  //distance from camera to camera target in lookmode... 8?
   
//Options
    int lookMode = 8;
    int spotLightMode = 4;
    int cameraMode = 1;
    int moveMode = 2;
    
//init block ids
int blockTypeAir = 0;
int blockTypeDirt = 1;
int blockTypeStone = 2;
int blockTypeObsidion = 3;
int blockTypeGrass = 4;
int blockTypeBedrock = 5;
int blockTypeWood = 6;
int blockTypeLeaves = 7;

//array
int[][][] chunkArray;

//block varaibles
int blockSize = 32;
int blockSolidSize = 29;

//immutables
char wKey = 'w';
char sKey = 's';
char dKey = 'd';
char aKey = 'a';
char tKey = 't';
char spaceKey = ' ';

//directions
int directionForward = 0;
int directionBackward = 180;
int directionRight = 90;
int directionLeft = 270;
int directionForwardRight = 45;
int directionForwardLeft = 315;
int directionBackwardRight = 135;
int directionBackwardLeft = 225;

//key press variables
boolean wPressed = false;
boolean sPressed = false;
boolean dPressed = false;
boolean aPressed = false;
boolean tPressed = false;
boolean shiftPressed = false;
boolean spacePressed = false;

void setup()
{
    size(1440,1080,P3D);
    noStroke();
    initCamera();
    
    initArray();
    
    clearArray();
    
    populateArray();
    
    drawArray();
    
    incrementPlayerY(-570);
}
 
 
void draw()
{
    //update frame
    background(135, 206, 250);
   
    if(spotLightMode == 0)
      lights();
    else if(spotLightMode == 1)
      spotLight(255, 255, 255, x, y - standHeight, z, tx, ty, tz, PI, 1);
    else if(spotLightMode == 2)
      spotLight(255, 255, 255, x, y - standHeight - 200, z, x + 100, y + 100, z, frameCounter / 10, 1);
    else if(spotLightMode == 3)
      spotLight(255, 255, 255, width / 2, height / 2 - 1000, 0, width / 2, height / 2, 0, PI, 1);
    else if(spotLightMode == 4)
      pointLight(255, 255, 255, x, y, z);
    
    drawArray();
   
    updatePlayerPosition();
    
    updateCollision();
    
    cameraUpdate();
   
    //Camera Mode 1 - Original
    if(cameraMode == 1)
    camera(x, y, z, tx, ty, tz, 0, 1, 0);
   
    //Camera Mode 2 - Matrix'd
    if(cameraMode == 2){
    beginCamera();
    camera();
    translate(x,y,z);
    translate(0, 2 * -standHeight, 0);
 
    rotateX(rotY / 100.0); //This seems to work o.o
    rotateY(-rotX / 100.0);
    //rotateX(rotX/100.0);
    endCamera();
    }
    frameCounter++;
}

//array stuff
void initArray()
{
    chunkArray = new int[16][16][16];
}

void clearArray()
{
    for (int arrayX = 0; arrayX < chunkArray[0].length; arrayX ++)
    {
        for (int arrayY = 0; arrayY < chunkArray[1].length; arrayY ++)
        {
            for (int arrayZ = 0; arrayZ < chunkArray[2].length; arrayZ ++)
            {
                setArrayBlock(arrayX, arrayY, arrayZ, blockTypeAir);
            }
        }
    }
}

void populateArray()
{
    setArrayLayer(0, blockTypeGrass);
    setArrayLayer(1, blockTypeDirt);
    setArrayLayer(2, blockTypeDirt);
    setArrayLayer(3, blockTypeDirt);
    setArrayLayer(4, blockTypeStone);
    setArrayLayer(5, blockTypeStone);
    setArrayLayer(6, blockTypeStone);
    setArrayLayer(7, blockTypeStone);
    setArrayLayer(8, blockTypeStone);
    setArrayLayer(9, blockTypeStone);
    setArrayLayer(10, blockTypeStone);
    setArrayLayer(11, blockTypeStone);
    setArrayLayer(12, blockTypeStone);
    setArrayLayer(13, blockTypeStone);
    setArrayLayer(14, blockTypeObsidion);
    setArrayLayer(15, blockTypeBedrock);
}

void setArrayLayer(int layerY, int blockType)
{
    for (int arrayX = 0; arrayX < chunkArray[0].length; arrayX ++)
    {
        for (int arrayZ = 0; arrayZ < chunkArray[2].length; arrayZ ++)
        {
            setArrayBlock(arrayX, layerY, arrayZ, blockType);
        }
    }
}

int getArrayBlock(int blockX, int blockY, int blockZ)
{
    return chunkArray[blockX][blockY][blockZ];
}

void setArrayBlock(int blockX, int blockY, int blockZ, int blockType)
{
    chunkArray[blockX][blockY][blockZ] = blockType;
}

void drawCube(int xCenter, int yCenter, int zCenter, int cubeSize)
{
    translate(xCenter, yCenter, zCenter);
    box(cubeSize);
    translate(-xCenter, -yCenter, -zCenter);
}

void drawArray()
{
    for (int arrayX = 0; arrayX < chunkArray[0].length; arrayX ++)
    {
        for (int arrayY = 0; arrayY < chunkArray[1].length; arrayY ++)
        {
            for (int arrayZ = 0; arrayZ < chunkArray[2].length; arrayZ ++)
            {
                if (chunkArray[arrayX][arrayY][arrayZ] != blockTypeAir)
                {
                    if (chunkArray[arrayX][arrayY][arrayZ] == blockTypeDirt) {
                        fill(51, 25, 0);
                    }
                    else if (chunkArray[arrayX][arrayY][arrayZ] == blockTypeGrass) {
                        fill(10, 250, 15);
                    }
                    else if (chunkArray[arrayX][arrayY][arrayZ] == blockTypeStone) {
                        fill(125, 125, 125);
                    }
                    else if (chunkArray[arrayX][arrayY][arrayZ] == blockTypeObsidion) {
                        fill(13, 0, 25);
                    }
                    else if (chunkArray[arrayX][arrayY][arrayZ] == blockTypeBedrock) {
                        fill(10, 10, 10);
                    }
                    else if (chunkArray[arrayX][arrayY][arrayZ] == blockTypeWood) {
                        fill(102, 51, 0);
                    }
                    else if (chunkArray[arrayX][arrayY][arrayZ] == blockTypeLeaves) {
                        fill(51, 102, 0);
                    }
                    drawCube(arrayX * blockSize, arrayY * blockSize, arrayZ * blockSize, blockSolidSize);
                }
            }
        }
    }
}

boolean checkArrayEmpty(int arrayX, int arrayY, int arrayZ)
{
    boolean blockSolid = false;
    
    if (getArrayBlock(arrayX, arrayY, arrayZ) != 0)
    {
        blockSolid = true;
    }
    else
    {
        blockSolid = true;
    }
    
    return (!blockSolid);
}

//player position functions

void updatePlayerPosition()
{
    boolean realWPressed = wPressed;
    boolean realSPressed = sPressed;
    boolean realDPressed = dPressed;
    boolean realAPressed = aPressed;
    
    if (shiftPressed)
    {
      incrementPlayerY(5);
      ty += 5;
    }
    
    if (spacePressed)
    {
      incrementPlayerY(-5);
      ty -= 5;
    }    
    
    if ((wPressed) && (sPressed))
    {
        wPressed = false;
        sPressed = false;
    }
    
    if ((dPressed) && (aPressed))
    {
        dPressed = false;
        aPressed = false;
    }
    
    if ((wPressed) && (dPressed))
    {
        movePlayer(directionForwardRight);
    }
    else if ((wPressed) && (aPressed))
    {
        movePlayer(directionForwardLeft);
    }
    else if ((sPressed) && (dPressed))
    {
        movePlayer(directionBackwardRight);
    }
    else if ((sPressed) && (aPressed))
    {
        movePlayer(directionBackwardLeft);
    }
    else if (wPressed)
    {
        movePlayer(directionForward);
    }
    else if (sPressed)
    {
        movePlayer(directionBackward);
    }
    else if (dPressed)
    {
        movePlayer(directionRight);
    }
    else if (aPressed)
    {
        movePlayer(directionLeft);
    }
    
    wPressed = realWPressed;
    sPressed = realSPressed;
    dPressed = realDPressed;
    aPressed = realAPressed;
}

void movePlayer(float xSpeed, float zSpeed)
{
    incrementPlayerX(xSpeed * 4.75);
    incrementPlayerZ(zSpeed * 4.75);
}

void movePlayer(float direction)
{
    movePlayer(getSpeedX(direction), getSpeedZ(direction));
}

float getPlayerX()
{
    return x;
}

float getPlayerY()
{
    return y;
}

float getPlayerZ()
{
    return z;
}

void setPlayerX(float setX)
{
    x = setX;
}

void setPlayerY(float setY)
{
    y = setY;
}

void setPlayerZ(float setZ)
{
    z = setZ;
}

void incrementPlayerX(float setX)
{
    setPlayerX(getPlayerX() + setX);
    tx += setX;
}

void incrementPlayerY(float setY)
{
    setPlayerY(getPlayerY() + setY);
    ty += setY;
}

void incrementPlayerZ(float setZ)
{
    setPlayerZ(getPlayerZ() + setZ);
    tz += setZ;
}

public void keyPressed()
{
    if (key == wKey)
    {
        wPressed = true;
    }
    
    if (key == sKey)
    {
        sPressed = true;
    }
    
    if (key == dKey)
    {
        dPressed = true;
    }
    
    if (key == aKey)
    {
        aPressed = true;
    }
    
    if (key == tKey)
    {
        tPressed = true;
    }
    
    if (keyCode == SHIFT && creative)
    {
        shiftPressed = true;
    }
    
    if (key == spaceKey && creative)
    {
        spacePressed = true;
    }    
}

public void keyReleased()
{
    if (key == wKey)
    {
        wPressed = false;
    }
    
    if (key == sKey)
    {
        sPressed = false;
    }
    
    if (key == dKey)
    {
        dPressed = false;
    }
    
    if (key == aKey)
    {
        aPressed = false;
    }
    
    if (key == tKey)
    {
      tPressed = false;
      if (creative == false)
        creative = true;
      else
        creative = false;  
    }
    
    if (keyCode == SHIFT)
    {
        shiftPressed = false;
    }
    
    if (key == spaceKey)
    {
      spacePressed = false;
    }    
}

float getSpeedX(float playerAngle)
{
    return (float)Math.cos(Math.toRadians(angle - 90 + playerAngle));
}

float getSpeedZ(float playerAngle)
{
    return (float)Math.sin(Math.toRadians(angle - 90 + playerAngle));
}

















//camera stuff... do not change

void initCamera()
{
    //Camera Initialization
    x = width/2;
    y = height/2;
    y -= standHeight;
    z = (height/2.0) / tan(PI*60.0 / 360.0);
    tx = width/2;
    ty = height/2;
    tz = 0;
    rotX = 0;
    rotY = 0;
    xComp = tx - x;
    zComp = tz - z;
    angle = 0;
}

public void cameraUpdate()
{
    //Drag-motion
    if (lookMode == 1)
    {
        if(pmouseX > mouseX)
            tx += dragMotionConstant;
        else if (pmouseX < mouseX)
            tx -= dragMotionConstant;
        if(pmouseY > mouseY)
            ty -= dragMotionConstant/1.5;
        else if (pmouseY < mouseY)
            ty += dragMotionConstant/1.5;
  }
   
  //Push-motion
  else if (lookMode == 2){
      if (mouseX > (width/2+pushMotionConstant))
          tx += dragMotionConstant;
      else if (mouseX < (width/2-pushMotionConstant))
          tx -= dragMotionConstant;
      if (mouseY > (height/2+pushMotionConstant))
          ty += dragMotionConstant;
      else if (mouseY < (height/2-pushMotionConstant))
          ty -= dragMotionConstant;
  }
   
  //Push-motion V2 (Hopefully improved!)
  else if (lookMode == 3)
  {
      int diffX = mouseX - width/2;
      int diffY = mouseY - width/2;
     
      if (abs(diffX) > pushMotionConstant)
          tx += diffX/25;
      if (abs(diffY) > pushMotionConstant)
          ty += diffY/25;
  }
   
  //Push Motion V3 (For Camera-Mode 2)
  else if (lookMode == 4)
  {
      int diffX = mouseX - width/2;
      int diffY = mouseY - width/2;
      println(diffX);
      if (abs(diffX) > pushMotionConstant)
          rotX += diffX/100;
      if (abs(diffY) > pushMotionConstant)
          rotY += diffY/100;//diffY/100;
  }
   
  //Push Motion V4.1 (Because it crashed and I lost V4.0 T.T
  //Designed to work in cohesion with movement mode 2
  else if (lookMode == 5)
  {
      int diffX = mouseX - width/2;
      int diffY = mouseY - width/2;
     
      if(abs(diffX) > stillBox){
          xComp = tx - x;
          zComp = tz - z;
          angle = degrees(atan(xComp/zComp));
       
          //---------DEBUG STUFF GOES HERE----------
          println("tx:    " + tx);
          println("tz:    " + tz);
          println("xC:    " + xComp);
          println("zC:    " + zComp);
          println("Angle: " +angle);
          //--------------------------------------*/
       
          if (angle < 45 && angle > -45 && zComp < 0)
              tx += diffX/sensitivity;
          else if (angle < 45 && angle > -45 && zComp > 0)
              tx -= diffX/sensitivity;
         
          //Left Sector
          else if (angle > 45 && angle < 90 && xComp < 0 && zComp < 0)
              tz -= diffX/sensitivity;
          else if (angle >-90 && angle <-45 && xComp < 0 && zComp > 0)
              tz -= diffX/sensitivity;
         
          //Right Sector
          else if (angle <-45 && angle >-90)
              tz += diffX/sensitivity;
          else if (angle < 90 && angle > 45 && xComp > 0 && zComp > 0)
              tz += diffX/sensitivity;
    }
            
    if (abs(diffY) > stillBox)
      ty += diffY/(sensitivity/1.5);
}
   
    //Lookmode 4.2
  //Using a more proper unit circle.
  else if (lookMode == 6){
    int diffX = mouseX - width/2;
    int diffY = mouseY - width/2;
     
    if(abs(diffX) > stillBox){
      xComp = tx - x;
      zComp = tz - z;
      angle = correctAngle(xComp,zComp);
         
      //---------DEBUG STUFF GOES HERE----------
      println("tx:    " + tx);
      println("tz:    " + tz);
      println("xC:    " + xComp);
      println("zC:    " + zComp);
      println("Angle: " +angle);
      //--------------------------------------*/
       
      //Looking 'forwards'
      if ((angle >= 0 && angle < 45) || (angle > 315 && angle < 360))
        tx += diffX/sensitivity;
         
      //Looking 'left'
      else if (angle > 45 && angle < 135)
        tz += diffX/sensitivity;
         
      //Looking 'back'
      else if (angle > 135 && angle < 225)
        tx -= diffX/sensitivity;
         
      //Looking 'right'
      else if (angle > 225 && angle < 315)
        tz -= diffX/sensitivity;
        
    }
            
    if (abs(diffY) > stillBox)
      ty += diffY/(sensitivity/1.5);
  }
   
  //Lookmode 7, trying to get rid of the slowdown in the corners with a sorta-buffer thing
  else if (lookMode == 7){
    int diffX = mouseX - width/2;
    int diffY = mouseY - width/2;
     
    if(abs(diffX) > stillBox){
      xComp = tx - x;
      zComp = tz - z;
      angle = correctAngle(xComp,zComp);
         
      //---------DEBUG STUFF GOES HERE----------
      println("tx:    " + tx);
      println("tz:    " + tz);
      println("xC:    " + xComp);
      println("zC:    " + zComp);
      println("Angle: " +angle);
      //--------------------------------------*/
 
      //Looking 'forwards'
      if ((angle >= 0-camBuffer && angle < 45+camBuffer) || (angle > 315-camBuffer && angle < 360+camBuffer))
        tx += diffX/sensitivity;
         
      //Looking 'left'
      else if (angle > 45-camBuffer && angle < 135+camBuffer)
        tz += diffX/sensitivity;
         
      //Looking 'back'
      else if (angle > 135-camBuffer && angle < 225+camBuffer)
        tx -= diffX/sensitivity;
         
      //Looking 'right'
      else if (angle > 225-camBuffer && angle < 315+camBuffer)
        tz -= diffX/sensitivity;
        
    }
            
    if (abs(diffY) > stillBox)
      ty += diffY/(sensitivity/1.5);
}
   
  else if (lookMode == 8){
    int diffX = mouseX - width/2;
    int diffY = mouseY - width/2;
     
    if(abs(diffX) > stillBox){
      xComp = tx - x;
      zComp = tz - z;
      angle = correctAngle(xComp,zComp);
        
      angle+= diffX/(sensitivity*10);
       
      if(angle < 0)
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
      println("Angle: " +angle);
      //--------------------------------------*/
        
    }
            
    if (abs(diffY) > stillBox)
      ty += diffY/(sensitivity/1.5);
  }  
}
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

public void updateCollision()
{
  int arrayPlayerX = floor (x / blockSize);
  int arrayPlayerY = floor (y / blockSize);
  int arrayPlayerZ = floor (z / blockSize);
  
    for (int arrayX = 0; arrayX < chunkArray[0].length; arrayX ++)
    {
        for (int arrayY = 0; arrayY < chunkArray[1].length; arrayY ++)
        {
            for (int arrayZ = 0; arrayZ < chunkArray[2].length; arrayZ ++)
            {
                if (chunkArray[arrayX][arrayY][arrayZ] != blockTypeAir)
                {
                    //&& abs(arrayX - arrayPlayerX  = 1) && abs(arrayY - arrayPlayerY = 1) && abs(arrayZ - arrayPlayerZ = 1)
                    if (arrayY - arrayPlayerY == 1)
                    {
                      //turn jump off
                    }
                    else if (arrayY - arrayPlayerY == -1)
                    {
                      // turn gravity off
                    }
                    
                    if (arrayZ - arrayPlayerZ == 1)
                    {
                      isNotBlockLeft = false;
                      isNotBlockRight = true;
                    }
                    else if (arrayZ - arrayPlayerZ == -1)
                    {
                      isNotBlockLeft = true;
                      isNotBlockRight = false;
                    }
                    else 
                    {
                      isNotBlockLeft = true;
                      isNotBlockRight = true;
                    }
  
                    /*if (arrayX - arrayPlayerX == 1)
                      isNotBlockLeft = false;
                    else if (arrayZ - arrayPlayerZ == -1)
                      isNotBlockLeft = true;
                    else 
                      isBlockLeft = true; */ 
                                      
                    
                    
                    
                }
            }
        }
    }
}
 
/*Conclusions:
  Increasing ty rotates field of view down
    vice versa for reverse
     
  Increasing tX rotates field of view right
    vice versa for reverse
*/
