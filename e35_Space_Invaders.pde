Menu menu;
Player player1;
Player player2;

boolean gameStarted = false;
boolean isMultiplayer = false;
int stackSize = 50;
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<Shot> shots = new ArrayList<Shot>();

void setup() {
  size(800, 600);
  smooth();
  menu = new Menu();
}

void draw() {
  background(0);
  
  if(!gameStarted) {
    menu.display();
  }
  else {
    player1.update();
    if(isMultiplayer) { player2.update(); }
    
    for(int i = enemies.size() - 1; i >= 0; i--) {
      Enemy e = enemies.get(i);
      e.update();
    }
    
    for(int i = shots.size() - 1; i >= 0; i--) {
      Shot s = shots.get(i);
      s.update();
    }
  }
}
  
void shoot(float tx, float ty, int size, int dir) {
  Shot s = new Shot(tx, ty + (size*dir), dir);
  shots.add(s);
}

void keyReleased() {
  if(key == CODED && isMultiplayer) { player2.keyUp(); }
  else { player1.keyUp(); }
}
void keyPressed() {
  if(key == CODED && isMultiplayer) { player2.keyDown(); }
  else { player1.keyDown(); }
}
