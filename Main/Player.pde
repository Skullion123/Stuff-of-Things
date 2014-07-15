
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
      RotateCamera(0, 3, 0);
      println("Rotate right 3 degrees");
    }
    else if (currentMousePosition.x < previousMousePosition.x /*&& previousMousePosition.x - currentMousePosition.x >= 3*/)
    {
      RotateCamera(0, -3, 0);
      println("Rotate left 3 degrees");
    }
    
    if (currentMousePosition.y > previousMousePosition.y /*&& currentMousePosition.y - previousMousePosition.y >= 3*/)
    {
      RotateCamera(-3, 0, 0);
      println("Rotate down 3 degrees");
    }
    else if (currentMousePosition.y < previousMousePosition.y /*&& previousMousePosition.y - currentMousePosition.y >= 3*/)
    {
      RotateCamera(3, 0, 0);
      println("Rotate up 3 degrees");
    }
    previousMousePosition.x = mouseX;
    previousMousePosition.y = mouseY;
 // }
  
    
    
    
  }
  
  //camera functions
  
  public void ChangeCameraXYZ(int x, int y, int z)
  {
    Main.eyeX += x;
    Main.eyeY += y;
    Main.eyeZ += z;
    camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
  }
  
  public void RotateCamera(int x, int y, int z)
  {
    cam.rotateX((int)radians(x));
    cam.rotateY((int)radians(y));
    cam.rotateZ((int)radians(z));
  }
 
 
 
 /*
 
 2D           |    3D
 ------------------------
 X                Y
 Y                X
*/ 
  
}
