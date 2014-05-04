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
  mouseClicked = false;  //At the end of draw() to register a single mousebutton input.
}

void displayGameObjects() {
 //Iterates enemies array list and updates every enemy. 
  for(int i = enemies.size() - 1; i >= 0; i--) {
    Enemy _enemy = enemies.get(i);
    _enemy.update();
  }
  enemyHandler.update();
  spawner.respawnEnemies();
  
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
 //Display ground and cover
  cover.display();
}

//keyReleased and keyPressed checks if keys are coded or not in case there is multiple players.
void keyReleased() {
  if(gameStarted) {
    if(key == CODED) { players.get(players.size()-1).keyUp(); }
    if(key != CODED) { players.get(0).keyUp(); }
  }
}
void keyPressed() {
  if(key == 27) {  //Key 27 = ESC
    key = 0;  //Cancel other ESC events(e.g. quit processing).
    gamePaused = !gamePaused;
  }
  if(gameStarted) {
    if(key == CODED) { players.get(players.size()-1).keyDown(); }
    if(key != CODED) { players.get(0).keyDown(); }
  }
}
void mousePressed() {
  mouseClicked = true;  //Register mousePressed as a click.
}
