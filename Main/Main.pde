
public static float eyeX;
public static float eyeY;
public static float eyeZ;
public static float centerX;
public static float centerY;
public static float centerZ;
public static float upX;
public static float upY;
public static float upZ;

ArrayList blockList;

Player player1;

void setup(){
 size(displayWidth/2, displayHeight/2, P3D);
 
 blockList = new ArrayList();
 
 
 player1 = new Player();
 player1.Initialize();
 
 eyeX = 0.0;
 eyeY = 0.0;
 eyeZ = 0.0;
 centerX = 10.0;
 centerY = 0.0;
 centerZ = 0.0;
 upX = 0.0;
 upY = 0.0;
 upZ = 0.0;
 
 camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);

 println(mouseX);
 println(mouseY);
 
 frameRate(24);
}

void Update()
{
  player1.Update();
}

void draw()
{
  Update();
}

public void GenerateEverything()
{
  for (int x = 0; x <= 100; x++) //x
  {
    for (int z = 0; z <= 100; z++) //z
    {
      for (int y = 0 y <= 50; y++)  //y
      {
        Block block = new Block();
        PVector blockPos = new PVector(10 * x, 10 * y, 10 * z);
        
      }
    }
  }
}




