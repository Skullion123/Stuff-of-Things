
public static float eyeX;
public static float eyeY;
public static float eyeZ;
public static float centerX;
public static float centerY;
public static float centerZ;
public static float upX;
public static float upY;
public static float upZ;



Player player1;

void setup(){
 size(displayWidth/2, displayHeight/2, P3D);
 
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




