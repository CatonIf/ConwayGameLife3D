import java.io.Console;
import java.util.Random;

void setup() {
  size(1000, 1000, P3D);
  reset();
}

boolean[][][] tiles = new boolean[32][32][32]; 

// Camera movement variables
float cY, cX;
boolean aY, aX;

int mouseSpeed = 3;

int howMuch = 7; // The number of neighbours that can kill a cell. In the original Game of Life this is 3.

Random rnd = new Random();

void reset() { // Makes all the tiles random.
  for (int x = 0; x < 32; x++)
    for(int y = 0; y < 32; y++)
      for(int z = 0; z < 32; z++)
        tiles[x][y][z] = rnd.nextBoolean();
}

void generate() { // The rules of the game
  for (int x = 0; x < 32; x++) {
    for(int y = 0; y < 32; y++) {
      for(int z = 0; z < 32; z++) {
        int c = neighboursCount(x, y, z);
        print("tile at " + x + " ; " + y + " ; " + z + " was " + (tiles[x][y][z] ? "live" : "dead"));
        if (tiles[x][y][z]) {
          if (c >= howMuch || c == 1) tiles[x][y][z] = false;
        } else {
          if (c == howMuch) tiles[x][y][z] = true;
        } print(" and now with " + c + " neighbours is " + (tiles[x][y][z] ? "live" : "dead") + ".\n");
      }
    }
  }
}

int neighboursCount(int x, int y, int z) { // The number of neighbours that a cell has.
  int c = 0;
  for (int fx = -1; fx < 2; fx++)
    for(int fy = -1; fy < 2; fy++)
      for(int fz = -1; fz < 2; fz++)
        c += tiles[position(x + fx)][position(y + fy)][position(z + fz)] ? 1 : 0;
  return c;
}

int position(int i) { // Goes back to the start or to the end if a value is bigger than the array or negative.
  return i == -1 ? 31 : i == 32 ? 0 : i;
}

void draw() {
  
  background(190);
  fill(255);
  stroke(0);
  
  // automatic camera movement
  cX+=aX?.02:0;
  cY+=aY?.02:0;
  
  // mouse camera movement
  translate(500, 500, 0);
  if (mousePressed) {
    cY += (mouseX - pmouseX) * mouseSpeed / 1000f;
    cX += -(mouseY - pmouseY) * mouseSpeed / 1000f;
  } rotateX(cX); rotateY(cY);
  translate(-15*32/2, -15*32/2, -15*32/2);
  
  // draws the cubes that are live
  for (int x = 0; x < 32; x++) {
    for(int y = 0; y < 32; y++) {
      for(int z = 0; z < 32; z++) {
        if (tiles[x][y][z]) box(15);
        translate(0, 0, 15);
      } translate(0, 15, -15*32);
    } translate(15, -15*32, 0);
  }
}

void keyPressed() {
  switch (key) {
    case '1': aY = !aY; break; // press 1 to rotate in the Y axis.
    case '2': aX = !aX; break; // 2 for the X axis
    case ' ': generate(); break; // press space to go to the next generation
  }
}
