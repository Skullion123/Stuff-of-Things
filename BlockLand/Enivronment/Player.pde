public class Player extends FPCamera{
  int pSize;
   
  public Player(float x, float y, float z){
    super(x,y,z);
    pSize = 100;
  }
   
  public Player(float x, float y, float z, float a){
    super(x,y,z);
    pSize = 100;
     
    //Borrowed from FPCamera to change angle
    float nxComp = targetDistance * sin(radians(a));  //New variables cause otherwise it would
    float nzComp = targetDistance * cos(radians(a));  //mess up the movement pretty bad.
    tx = nxComp + x;
    tz = -nzComp + z;
  }
   
  public void move(int movementSpeed, Environment world){
    //To move, we wanna undo what changes the up-down motion did to the hypotenuse variable
    float xDisp = targetDistance * sin(radians(angle));
    float zDisp = -targetDistance * cos(radians(angle));
     
    if(moveUP){
      //Arbitrary distance based on angle variable recycling this method:  nxComp = hypotenuse * sin(radians(angle));
      if(!world.checkBlock(x,-y,z+zComp/movementSpeed+(zComp/abs(zComp)*pSize))){
        z += zDisp/movementSpeed;
        tz+= zDisp/movementSpeed;
      }
      if(!world.checkBlock(x+xComp/movementSpeed+(xComp/abs(xComp)*pSize),-y,z)){
        x += xDisp/movementSpeed;
        tx+= xDisp/movementSpeed;
      }
    }
    else if(moveDOWN){
      if(!world.checkBlock(x,-y,z-zComp/movementSpeed+(zComp/abs(zComp)*pSize))){
        z -= zDisp/movementSpeed;
        tz-= zDisp/movementSpeed;
      }
      if(!world.checkBlock(x-xComp/movementSpeed+(xComp/abs(xComp)*pSize),-y,z)){
        x -= xDisp/movementSpeed;
        tx-= xDisp/movementSpeed;
      }
    }
    if (moveRIGHT){
      if(!world.checkBlock(x,-y,z+xComp/movementSpeed+(xComp/abs(xComp)*pSize))){
        z += xDisp/movementSpeed;
        tz+= xDisp/movementSpeed;
      }
      if(!world.checkBlock(x-zComp/movementSpeed+(zComp/abs(zComp)*pSize),-y,z)){
        x -= zDisp/movementSpeed;
        tx-= zDisp/movementSpeed;
      }
    }
    if (moveLEFT){
      if(!world.checkBlock(x,-y,z-xComp/movementSpeed+(xComp/abs(xComp)*pSize))){
        z -= xDisp/movementSpeed;
        tz-= xDisp/movementSpeed;
      }
      if(!world.checkBlock(x+zComp/movementSpeed+(zComp/abs(zComp)*pSize),-y,z)){
      x += zDisp/movementSpeed;
      tx+= zDisp/movementSpeed;
      }
    }
  }
   
  public void jump(int magnitude,Environment world){
    if(canJUMP && moveJUMP && world.checkBlock(x,-y-standHeight+pSize,z)){
      vY = -magnitude;
      if(vY < -20)
        canJUMP = false;
    }
     
    /*else if (y >= 0){
      vY = 0;
      y = 0;
    }*/
     
    if(vY < 0 && world.checkBlock(x,-(y+vY+pSize/2),z))
      vY = 0;
     
    if((vY >= 0 && !world.checkBlock(x,-(y+vY+pSize/2),z))|| (vY < 0)){
      vY ++;
      y +=vY;
      ty+=vY;
      y--;
 
    }
    else
      vY = 10;
  }
   
  public void teleport(int nx, int ny, int nz){
    x += nx;
    tx += nx;
    y += ny;
    ty += ny;
    z += nz;
    tz += tz;
  }
   
  public void look(int requestedAngle){
    angle = requestedAngle;
  }
}

