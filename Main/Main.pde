public static float eyeX;
public static float eyeY;
public static float eyeZ;
public static float centerX;
public static float centerY;
public static float centerZ;
public static float upX;
public static float upY;
public static float upZ;

ArrayList<Block> blockList;

Player player1;

void setup(){
 size(displayWidth/2, displayHeight/2, P3D);
 
 blockList = new ArrayList();
 
 
 player1 = new Player();
 player1.Initialize();
 
 eyeX = width/2.0;
 eyeY = height;
 eyeZ =  (height/2.0) / tan(PI*30.0 / 180.0);
 centerX = width/2.0;
 centerY = height/2.0;
 centerZ = 0.0;
 upX = 0.0;
 upY = 1.0;
 upZ = 0.0;
 
 camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);

 println(mouseX);
 println(mouseY);
 
 frameRate(24);
 
 GenerateEverything();
}

void Update()
{
  player1.Update();
}

void draw()
{
  Update();
  //clear();
  background(58, 155, 160);
  for (int i = 0; i < blockList.size(); i++)
  {
    println(blockList.get(i));
    blockList.get(i).Draw();
  }
  
}

public void GenerateEverything()
{
  pushMatrix();
  for (int x = 1; x <= 4; x++) //x
  {
    for (int z = 1; z <= 4; z++) //z
    {
      for (int y = 1; y <= 4; y++)  //y
      {
        Block block = new Block();
        PVector blockPos = new PVector(10 * x, 10 * y, 10 * z);
        String type;
        if (y == 1)
        {
          type = "bedrock";
        }
        else if (y == 49)
        {
          type = "dirt";
        }
        else if (y == 50)
        {
          type = "grass";
        }
        else
        {
          type = "stone";
        }
        block.Initialize(blockPos, type);
        blockList.add(block);

      }
    }
  }
  pushMatrix();
}




