import ddf.minim.*; //Import audio library
Minim minim;
AudioPlayer[] audio = new AudioPlayer[2];

boolean gameStarted = false;
boolean isMultiplayer = false;

//Each game object is stored in an array list associated to that kind of object.
ArrayList<Player> players = new ArrayList<Player>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<Shot> shots = new ArrayList<Shot>();

MenUI menUI;

void setup() {
  size(800, 600);
  smooth();
  menUI = new MenUI();
  minim = new Minim(this);
  audio[0] = minim.loadFile("theme.mp3");
  audio[1] = minim.loadFile("playerShot.wav");
}

void draw() {
  background(0);
  if(!gameStarted) {
    menUI.displayStartMenu();
  }
  else {
    displayGameObjects();
    menUI.displayTotalScore();
  }
  menUI.playThemeSong();
}

void displayGameObjects() {
  //Iterate enemies array list and updates every enemy. 
  for(int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    e.update();
  }
  //Iterate shots array list and updates every shot. 
  for(int i = shots.size() - 1; i >= 0; i--) {
    Shot s = shots.get(i);
    s.update();
  }
  //Iterate players array list and updates every player
  //and adjust the total score of all player scores.
  menUI.totalScore = 0;
  for(int i = players.size() - 1; i >= 0; i--) {
    Player player = players.get(i);
    player.update();
    menUI.totalScore += player.score;
    menUI.displayLifes(player);
  }
}

//Shoot function handles both player and enemy shots.
void shoot(float posX, float posY, int size, int dir, int owner) {
  Shot s = new Shot(posX, posY + (size*dir), dir, owner);
  shots.add(s);
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

//enemy shoot for testing only
void mousePressed() {
  if(gameStarted) {
    enemies.get(0).attack();
  }
}
