import ddf.minim.*; //Import audio library

Menu menu;
boolean gameStarted = false;
boolean isMultiplayer = false;
int stackSize = 50;
int totalScore = 0;

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
  frameRate(15);
  background(0);
  if(!gameStarted) {
    menu.display();
  }
  else {
    displayEnemies();
    displayShots();
    displayPlayers();
    displayTotalScore();
  }
  playMusic();
}

void displayEnemies() {
  for(int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    e.update();
    e.display();
  
  }
}

void displayShots() {
  for(int i = shots.size() - 1; i >= 0; i--) {
    Shot s = shots.get(i);
    s.update();
  }
}

void displayPlayers() {
  totalScore = 0;
  for(int i = players.size() - 1; i >= 0; i--) {
    Player player = players.get(i);
    player.update();
    totalScore += player.score;
  }
}
  
void shoot(float posX, float posY, int size, int dir, int owner) {
  Shot s = new Shot(posX, posY + (size*dir), dir, owner);
  shots.add(s);
  audio[1].rewind();
  audio[1].play();
}

void playMusic() {
  if(!audio[0].isPlaying()) {
    audio[0].rewind();
    audio[0].play();
  }
}

void displayTotalScore() {
  textAlign(CENTER, TOP);
  textSize(textHeight/1.5);
  text("TOTAL SCORE", width/2, 0);
  textSize(42);
  fill(255);
  text(nf(totalScore, 0), width/2, textHeight/2);
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
