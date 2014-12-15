//Global Variables
 
//Environment Variables
   boolean isNotBlockLeft;
   boolean isNotBlockRight;
   
   boolean creative = false; 
   
   
   float gravity = 0.00;
   
   boolean standing = false;
   
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
    int standHeight = 115;
    int dragMotionConstant = 10;
    int pushMotionConstant = 100;
    int movementSpeed = 50;    //Bigger number = slower
    float sensitivity = 15;      //Bigger number = slower
    int stillBox = 100;        //Center of POV, mouse must be stillBox away from center to move
    float camBuffer = 10;
    int cameraDistance = 1000;  //distance from camera to camera target in lookmode... 8?
    
//init block ids
    int blockTypeAir = 0;
    int blockTypeDirt = 1;
    int blockTypeStone = 2;
    int blockTypeObsidian = 3;
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
    size(960, 720 ,P3D);
    noStroke();
    
    initCamera();
    
    incrementPlayerY(-200);
    incrementPlayerX(-500);
    incrementPlayerZ(-600);
    
    initArray();
    
    clearArray();
    
    populateArray();
    
    drawArray();
}
 
 
void draw()
{
    //update frame
    background(135, 206, 250);
    pointLight(255, 255, 255, x, y, z);
    
    drawArray();
   
    updatePlayerPosition();
    
    applyGravity();
    
    cameraUpdate();

    camera(x, y, z, tx, ty, tz, 0, 1, 0);

    frameCounter++;
    
//    adjustCamera();
}

//void adjustCamera()
//{
//  float tempAngle = angle;
//  beginCamera();
//  translate(-getSpeedX(tempAngle + 90), 0, -getSpeedZ(tempAngle + 90));
//  endCamera();
//  translate(getSpeedX(tempAngle + 90), 0, getSpeedZ(tempAngle + 90));
//}

boolean checkNext(float nextX, float nextZ, float direction)
{
  //println(checkPosition(nextX, getPlayerY(), nextZ));
  boolean returnBool = (checkPosition(nextX, getPlayerY() + standHeight, nextZ) || checkPosition(nextX, getPlayerY() + standHeight - 32, nextZ) || checkPosition(nextX, getPlayerY() + standHeight, nextZ));
  return returnBool;
}

boolean checkLine(double angleT)
{
  
  println("Player X = " + getPlayerX());
  println("Player Z = " + getPlayerZ());
  
  println("Speed X = " + getSpeedX((float)angleT));
  println("Speed Z = " + getSpeedZ((float)angleT));
  
  println("Previous System X Checked = " + (getPlayerX() + getSpeedX(0)));
  println("Previous System Z Checked = " + (getPlayerZ() + getSpeedZ(0)));

  
  int adjustX = 10;
  boolean returnValue = true;
  double diffX;
  double diffZ;
  double slope = Math.tan(Math.toRadians(angleT));
  if (Math.abs(slope) > 1)
  {
  diffX = 1;
  diffZ = slope;
  }
  else
  {
  diffX = slope;
  diffZ = 1;
  }
  
  if(getSpeedX((float)angleT + 90) == 0)
    diffX = 0;
    
  if(getSpeedZ((float)angleT + 90) == 0) 
    diffZ = 0;
  
  int checkLineRadius = round((29 * sqrt(2)) / 2);
  for (int lineUnit = 0; lineUnit <= checkLineRadius; lineUnit ++)
  {
    double checkX = getPlayerX() + (getSpeedX((float)angleT + 90)) + (lineUnit * diffX);
    double checkZ = getPlayerZ() + (getSpeedZ((float)angleT + 90)) + (lineUnit * diffZ);
    
    if(lineUnit == 0)
    {
      println("CheckX = " + checkX);
      println("CheckZ = " + checkZ);
    }
    
    if (!checkPosition((float)checkX, getPlayerY() + standHeight, (float)checkZ) || !checkPosition((float)checkX, getPlayerY() + standHeight - 32, (float)checkZ) || !checkPosition((float)checkX, getPlayerY() + standHeight - 64, (float)checkZ))
    {
    returnValue = false;
    }
  }
  return (returnValue);
}

boolean checkPosition(float xPos, float yPos, float zPos)
{
//  fill(255, 255, 255);
//  drawCube((int)xPos, (int)yPos, (int)zPos, 35);
  return (getArrayBlock(round(xPos / 32), round(yPos / 32), round(zPos / 32)) == blockTypeAir);
}

void updateCollision(int xPos, int yPos, int zPos)
{
  if (abs(floor(getPlayerX()/32) - xPos) < 1 && abs(floor(getPlayerZ() / 32) - zPos) < 1 &&  abs(floor(getPlayerY() / 32) - yPos) < 1 && getArrayBlock(xPos, yPos, zPos) != blockTypeAir)
  {
    if ((wPressed) && (dPressed))
    {
        movePlayer(directionBackwardLeft);
    }
    else if ((wPressed) && (aPressed))
    {
        movePlayer(directionBackwardRight);
    }
    else if ((sPressed) && (dPressed))
    {
        movePlayer(directionForwardLeft);
    }
    else if ((sPressed) && (aPressed))
    {
        movePlayer(directionForwardRight);
    }
    else if (wPressed)
    {
        movePlayer(directionBackward);
    }
    else if (sPressed)
    {
        movePlayer(directionForward);
    }
    else if (dPressed)
    {
        movePlayer(directionLeft);
    }
    else if (aPressed)
    {
        movePlayer(directionRight);
    }
  }
}

//array stuff
void initArray()
{
    chunkArray = new int[32][32][32];
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
    setArrayLayer(0, blockTypeBedrock);
    setArrayLayer(1, blockTypeAir);
    setArrayLayer(2, blockTypeAir);
    setArrayLayer(3, blockTypeAir);
    setArrayLayer(4, blockTypeAir);
    setArrayLayer(5, blockTypeAir);
    setArrayLayer(6, blockTypeAir);
    setArrayLayer(7, blockTypeAir);
    setArrayLayer(8, blockTypeAir);
    setArrayLayer(9, blockTypeAir);
    setArrayLayer(10, blockTypeAir);
    setArrayLayer(11, blockTypeAir);
    setArrayLayer(12, blockTypeAir);
    setArrayLayer(13, blockTypeAir);
    setArrayLayer(14, blockTypeAir);
    setArrayLayer(15, blockTypeAir);
    setArrayLayer(16, blockTypeGrass);
    setArrayLayer(17, blockTypeDirt);
    setArrayLayer(18, blockTypeDirt);
    setArrayLayer(19, blockTypeDirt);
    setArrayLayer(20, blockTypeStone);
    setArrayLayer(21, blockTypeStone);
    setArrayLayer(22, blockTypeStone);
    setArrayLayer(23, blockTypeStone);
    setArrayLayer(24, blockTypeStone);
    setArrayLayer(25, blockTypeStone);
    setArrayLayer(26, blockTypeStone);
    setArrayLayer(27, blockTypeStone);
    setArrayLayer(28, blockTypeStone);
    setArrayLayer(29, blockTypeStone);
    setArrayLayer(30, blockTypeObsidian);
    setArrayLayer(31, blockTypeBedrock);
    //A tree
    setArrayBlock(10, 15, 4, 6);
    setArrayBlock(10, 14, 4, 6);
    setArrayBlock(10, 13, 4, 6);
    setArrayBlock(10, 12, 4, 6);
    setArrayBlock(10, 11, 4, 6);
    setArrayBlock(10, 10, 4, 6);
    setArrayBlock(10, 10, 5, 6);
    setArrayBlock(9, 10, 4, 7);
    setArrayBlock(8, 10, 4, 7);
    setArrayBlock(11, 10, 4, 7);
    setArrayBlock(12, 10, 4, 7);
    setArrayBlock(10, 10, 3, 7);
    setArrayBlock(10, 10, 2, 7);
    setArrayBlock(10, 10, 5, 7);
    setArrayBlock(10, 10, 6, 7);
    setArrayBlock(9, 10, 3, 7);
    setArrayBlock(9, 10, 5, 7);
    setArrayBlock(11, 10, 3, 7);
    setArrayBlock(11, 10, 5, 7);
    setArrayBlock(10, 9, 4, 7);
    setArrayBlock(9, 9, 4, 7);
    setArrayBlock(11, 9, 4, 7);
    setArrayBlock(10, 9, 3, 7);
    setArrayBlock(10, 9, 5, 7);
    setArrayBlock(10, 8, 4, 7);
    
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

  if (blockX < 0 || blockX > 31 || blockY < 0 || blockY > 31 || blockZ < 0 || blockZ > 31)  
    return blockTypeAir;
  else
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

void getFill(int blockType)
{
  if (blockType == blockTypeDirt)
      fill(51, 25, 0);
  else if (blockType == blockTypeGrass)
      fill(10, 250, 15);
  else if (blockType == blockTypeStone)
      fill(125, 125, 125);
  else if (blockType == blockTypeObsidian) 
      fill(13, 0, 25);
  else if (blockType == blockTypeBedrock) 
      fill(10, 10, 10);
  else if (blockType == blockTypeWood) 
      fill(102, 51, 0);
  else if (blockType == blockTypeLeaves)
      fill(51, 102, 0);  
}

boolean checkSurroundings(int arrayX, int arrayY, int arrayZ)
{ 
  if (arrayX == 0 || arrayX == 31 || arrayY == 0 || arrayY == 31 || arrayZ == 0 || arrayZ == 31)
    return true;
  else if (checkArrayEmpty(arrayX + 1, arrayY, arrayZ) || checkArrayEmpty(arrayX - 1, arrayY, arrayZ))
    return true;
  else if (checkArrayEmpty(arrayX, arrayY + 1, arrayZ) || checkArrayEmpty(arrayX, arrayY - 1, arrayZ))
    return true; 
  else if (checkArrayEmpty(arrayX, arrayY, arrayZ + 1) || checkArrayEmpty(arrayX, arrayY, arrayZ - 1))
    return true;
  else
    return false;
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
                    getFill(chunkArray[arrayX][arrayY][arrayZ]);
                    updateCollision(arrayX, arrayY, arrayZ);
                    if (checkSurroundings(arrayX, arrayY, arrayZ))
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
      blockSolid = false;
    }
    
    return (!blockSolid);
}

//player position functions
void applyGravity()
{
  if (!creative) {  
    
    if (checkPosition(getPlayerX(), getPlayerY() + standHeight + 10, getPlayerZ()))
    {
      standing = false;
      gravity += 0.5;
    }
    else 
    {   
      if (standing == false)
      {
        standing = true;
        gravity = 0;
      }
    }
    incrementPlayerY(gravity);
    
  }
}


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
      if (creative)
      {
        incrementPlayerY(-5);
        ty -= 5;
        gravity = 0;
      }
      else
      {
        if (standing)
          gravity -= 4;
      }
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

void movePlayer(float xSpeed, float zSpeed, float direction)
{
  if (checkNext((xSpeed * 75) + getPlayerX(), (zSpeed * 75) + getPlayerZ(), direction))
  {
    incrementPlayerX(xSpeed * 4.75);
    incrementPlayerZ(zSpeed * 4.75);
  }
}

void movePlayer(float direction)
{
    movePlayer(getSpeedX(direction), getSpeedZ(direction), direction);
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
}

void incrementPlayerZ(float setZ)
{
    setPlayerZ(getPlayerZ() + setZ);
    tz += setZ;
}

public void keyPressed()
{
    if (key == wKey || key == 'W')
    {
        wPressed = true;
    }
    
    if (key == sKey || key == 'S')
    {
        sPressed = true;
    }
    
    if (key == dKey || key == 'D')
    {
        dPressed = true;
    }
    
    if (key == aKey || key == 'A')
    {
        aPressed = true;
    }
    
    if (key == tKey || key == 'T')
    {
        tPressed = true;
    }
    
    if (keyCode == SHIFT && creative)
    {
        key = '\0';
        shiftPressed = true;
    }
    
    if (key == spaceKey)
    {
        spacePressed = true;
    }    
}

public void keyReleased()
{
    if (key == wKey || key == 'W')
    {
        wPressed = false;
    }
    
    if (key == sKey || key == 'S')
    {
        sPressed = false;
    }
    
    if (key == dKey || key == 'D')
    {
        dPressed = false;
    }
    
    if (key == aKey || key == 'A')
    {
        aPressed = false;
    }
    
    if (key == tKey || key == 'T')
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
    x = 1440/2;
    y = 1080/2;
    y -= standHeight;
    z = (1080/2.0) / tan(PI*60.0 / 360.0);
    tx = 1440/2;
    ty = 1080/2;
    tz = 0;
    rotX = 0;
    rotY = 0;
    xComp = tx - x;
    zComp = tz - z;
    angle = 0;
}

public void cameraUpdate()
{
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
    }
            
    if (abs(diffY) > stillBox)
      ty += diffY/(sensitivity/1.5);
    
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
