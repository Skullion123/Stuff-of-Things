/*Ryan Darge: ryan.darge@gmail.com
  Credits: Bharath S. for helping with the camera panning and general advice
  Details: An environment program designed to test the improved-first-person camera
           I started making a week or two ago.
     
  Controls:
    WASD - Move around
    SPACE - Jump
    Q - Generate a new map and change the default color
    R - Generate a new map and reset your location
    + - Generate a new map, one block bigger in every direction
    - - Generate a new map, one block smaller in every direction.
     
    1 - Directional light pointing the way you look (sorta)
    2 - Point-light from the center of the camera
    3 - Spot-Light from above
    4 - Spot-Light flashlight
     
    Tab - Changes the colors of the blocks from default color to assigned per block
     
  Bugs:
    -Sometimes you'll fall into an area you can't get out of by walking. (you can jump out though)
     
*/
 
Player p1;
Environment world;
int totalBoxes;
int lightMode;
 
void setup(){
  size(800,600,P3D);
  totalBoxes = 10;
  lightMode = 2;
  p1 = new Player(0,-400,0,135); 
  world = new Environment(totalBoxes,400);
}
 
void draw(){
   
  //Update Environment
  background(0);
  noStroke();
   
  //Update Camera
  p1.look(mouseX,mouseY);
  p1.move(50,world);  //If it moves, move this fast.
  p1.jump(30,world);  //if it jumps, jump this fast.
  p1.update();
  p1.light(lightMode);
   
  //Draw Environment
  world.update();
   
}
 
void keyPressed(){
  p1.keyPress(key);
  if(key == '+')
    totalBoxes++;
  else if(key == '-')
    totalBoxes--;
  if(key == 'q' || key == 'r' || key == '+' || key == '-')
    world = new Environment(totalBoxes,400);
  if(key == 'r')
    p1 = new Player(0,-400,0,135);
  if(key == '1'){
    lightMode = 1;
    stroke(0);
  }
  else if (key == '2')
    lightMode = 2;
  else if (key == '3')
    lightMode = 3;
  else if (key == '4')
    lightMode = 4;
  else if (keyCode == TAB)
    world.toggleColor();
     
}
 
void keyReleased(){
  p1.keyRelease(key);
}

