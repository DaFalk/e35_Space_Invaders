import ddf.minim.*; //Import audio library
Minim minim;
AudioHandler audioHandler;

boolean gameStarted = false;
boolean gamePaused = false;
boolean isMultiplayer = false;
boolean mouseClicked = false;

Spawner spawner;
EnemyHandler enemyHandler;
MenUI menUI;

//Each game object is stored in an array list associated to that kind of object.
ArrayList<Player> players = new ArrayList<Player>(); //Player 1 is players.get(0) while Player 2 is players.get(1).
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<Shot> shots = new ArrayList<Shot>();
ArrayList<PowerUp> powerUps = new ArrayList<PowerUp>();
Cover cover;

void setup() {
  size(800, 600);
  minim = new Minim(this);
  audioHandler = new AudioHandler();
  spawner = new Spawner();
  enemyHandler = new EnemyHandler();
  menUI = new MenUI();
  cover = new Cover();
}

void draw() {
  background(0);
  audioHandler.manage();
  if(gameStarted) { displayGameObjects(); }
  menUI.display();
  //mouseClicked is set to false at end of draw() to allow only 1 mousebutton input when mouseClicked is true.
  mouseClicked = false;
}

void displayGameObjects() {
  //Iterates enemies array list and updates every enemy. 
  for(int i = enemies.size() - 1; i >= 0; i--) {
    Enemy _enemy = enemies.get(i);
    _enemy.update();
  }
  enemyHandler.update();
  
  //Iterate shots array list and updates every shot. 
  for(int i = shots.size() - 1; i >= 0; i--) {
    Shot _shot = shots.get(i);
    _shot.update();
  }
  
  //Iterates players array list and updates every player.
  for(int i = players.size() - 1; i >= 0; i--) {
    Player _player = players.get(i);
    _player.update();
  }
  
  //Iterates powerUps array list and updates every powerup. 
  for(int i = powerUps.size() - 1; i >= 0; i--) {
    PowerUp _powerUp = powerUps.get(i);
    _powerUp.update();
  }
  cover.display();
//  rectMode(CENTER);
//  noStroke();
//  fill(0, 255, 0);
//  rect(width/2 , height - height/60, width, height/30);
}

//keyReleased and keyPressed checks if keys are coded or not in case there is multiple players.
void keyReleased() {
  if(gameStarted) {
    if(key == CODED) { players.get(players.size()-1).keyUp(); }
    if(key != CODED) { players.get(0).keyUp(); }
  }
}
void keyPressed() {
  //If ESC cancel other ESC events (e.g. quiting the program) and pause game.
  if(key == 27) {
    key = 0;
    gamePaused = !gamePaused;
  }
  if(gameStarted) {
    if(key == CODED) { players.get(players.size()-1).keyDown(); }
    if(key != CODED) { players.get(0).keyDown(); }
  }
}
void mousePressed() {
  mouseClicked = true;
}

void mouseClicked() {
}
