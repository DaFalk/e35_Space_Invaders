import ddf.minim.*; //Import audio library

Menu menu;
boolean gameStarted = false;
boolean isMultiplayer = false;
int stackSize = 50;

ArrayList<Player> players = new ArrayList<Player>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<Shot> shots = new ArrayList<Shot>();

AudioPlayer[] audio = new AudioPlayer[5];
Minim minim;

void setup() {
  size(800, 600);
  smooth();
  menu = new Menu();
  minim = new Minim(this);
  audio[0] = minim.loadFile("theme.mp3");
  audio[1] = minim.loadFile("playerShot.wav");
}

void draw() {
  background(0);
  
  if(!gameStarted) {
    menu.display();
  }
  else {
    iterateObjects();
  }
  
  //Play theme song
  if(!audio[0].isPlaying()) {
    audio[0].rewind();
    audio[0].play();
  }
}

void iterateObjects() {
  //Iterate players
  for(int i = players.size() - 1; i >= 0; i--) {
    Player player = players.get(i);
    player.update();
  }
  //Iterate enemies
  for(int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    e.update();
  }
  //Iterate shots
  for(int i = shots.size() - 1; i >= 0; i--) {
    Shot s = shots.get(i);
    s.update();
  }
}
  
void shoot(float posX, float posY, int size, int dir) {
  Shot s = new Shot(posX, posY + (size*dir), dir);
  shots.add(s);
  audio[1].rewind();
  audio[1].play();
}

void keyReleased() {
  if(gameStarted) {
    if(key == CODED && isMultiplayer) { players.get(1).keyUp(); }
    else { players.get(0).keyUp(); }
  }
}
void keyPressed() {
  if(gameStarted) {
    if(key == CODED && isMultiplayer) { players.get(1).keyDown(); }
    else { players.get(0).keyDown(); }
  }
}

void mousePressed() {
  if(gameStarted) {
    enemies.get(0).attack();
  }
}
