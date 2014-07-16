
class Player {
  
  PVector previousMousePosition = new PVector(0, 0);
  PVector currentMousePosition = new PVector();
  
  
  public void Initialize()
  {
    currentMousePosition.x = mouseX;
    currentMousePosition.y = mouseY;
  }
  
  public void Update()
  {
    
    //println(mouseX);
    //println(previousMousePosition.x);
    //println(currentMousePosition.x);
    //println(statusCheck);
    currentMousePosition.x = mouseX;
    currentMousePosition.y = mouseY;
    


    println(previousMousePosition.x);
    println(currentMousePosition.x);
    if (currentMousePosition.x > previousMousePosition.x /*&& currentMousePosition.x - previousMousePosition.x >= 3*/)
    {
      //Main.centerX += 5;
      //camera(Main.eyeX, Main.eyeY, Main.eyeZ, Main.centerX, Main.centerY, Main.centerZ, Main.upX, Main.upY, Main.upZ);
      RotateCamera(0, 100, 0);
      println("Rotate right 3 degrees");
    }
    else if (currentMousePosition.x < previousMousePosition.x /*&& previousMousePosition.x - currentMousePosition.x >= 3*/)
    {
      //Main.centerX -= 5;
      //camera(Main.eyeX, Main.eyeY, Main.eyeZ, Main.centerX, Main.centerY, Main.centerZ, Main.upX, Main.upY, Main.upZ);
      RotateCamera(0, -100, 0);
      println("Rotate left 3 degrees");
    }
    
    if (currentMousePosition.y > previousMousePosition.y /*&& currentMousePosition.y - previousMousePosition.y >= 3*/)
    {
      //Main.centerZ -= -5;
      //camera(Main.eyeX, Main.eyeY, Main.eyeZ, Main.centerX, Main.centerY, Main.centerZ, Main.upX, Main.upY, Main.upZ);
      RotateCamera(-100, 0, 0);
      println("Rotate down 3 degrees");
    }
    else if (currentMousePosition.y < previousMousePosition.y /*&& previousMousePosition.y - currentMousePosition.y >= 3*/)
    {
      //Main.centerZ += -5;
      //camera(Main.eyeX, Main.eyeY, Main.eyeZ, Main.centerX, Main.centerY, Main.centerZ, Main.upX, Main.upY, Main.upZ);
      RotateCamera(100, 0, 0);
      println("Rotate up 3 degrees");
    }
    previousMousePosition.x = mouseX;
    previousMousePosition.y = mouseY;
 // }
  
  
  if (keyPressed('w'))
  {
    
  }
    
    
    
  }
  
  //camera functions
  
  public void ChangeCameraXYZ(int x, int y, int z)
  {
    Main.eyeX += x;
    Main.eyeY += y;
    Main.eyeZ += z;
    camera(Main.eyeX, Main.eyeY, Main.eyeZ, Main.centerX, Main.centerY, Main.centerZ, Main.upX, Main.upY, Main.upZ);
  }
  
  public void RotateCamera(int x, int y, int z)
  {
    beginCamera();
    rotateX((int)radians(x));
    rotateY((int)radians(y));
    rotateZ((int)radians(z));
    endCamera();
  }
 
 
  boolean keyPressed(char character)
  {
    if (key == character)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
 
 
 /*
 
 2D           |    3D
 ------------------------
 X                Y
 Y                X
*/ 
  
}
