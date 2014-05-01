import ddf.minim.*; //Import audio library
Minim minim;
AudioHandler audioHandler;

boolean gameStarted = false;
boolean gamePaused = false;
boolean isMultiplayer = false;
boolean mouseClicked = false;

//Each game object is stored in an array list associated to that kind of object.
ArrayList<Player> players = new ArrayList<Player>(); //Player 1 is players.get(0) while Player 2 is players.get(1).
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<Shot> shots = new ArrayList<Shot>();
ArrayList<PowerUp> powerUps = new ArrayList<PowerUp>();

Spawner spawner;
MenUI menUI;

void setup() {
  size(800, 600);
  smooth();
  minim = new Minim(this);
  audioHandler = new AudioHandler();
  spawner = new Spawner();
  menUI = new MenUI();
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
  if(enemies.size() > 0) {
    enemies.get(0).shoot();
    spawner.moveEnemies();
  }
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
}

void resetGame() {
  gamePaused = false;
  gameStarted = false;
  players.clear();
  enemies.clear();
  shots.clear();
  powerUps.clear();
  menUI.showEnemies();
}

//keyReleased and keyPressed checks if keys are coded or not in case there is multiple players.
void keyReleased() {
  if(gameStarted) {
    if(key == CODED) { players.get(players.size()-1).keyUp(); }
    else { players.get(0).keyUp(); }
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
    else { players.get(0).keyDown(); }
  }
}
void mousePressed() {
  mouseClicked = true;
}

void mouseClicked() {
}
