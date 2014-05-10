import ddf.minim.*; //Import audio library
Minim minim;
AudioHandler audioHandler;

boolean gameStarted = false;
boolean gamePaused = false;
boolean showHighscores = false;
boolean isMultiplayer = false;
boolean mouseClicked = false;
PFont SpaceFont;

Spawner spawner;
EnemyHandler enemyHandler;
MenUI menUI;

//Each game object is stored in an array list associated to that kind of object.
ArrayList<Player> players = new ArrayList<Player>(); //Player 1 is players.get(0) while Player 2 is players.get(1).
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<Enemy> deadEnemies = new ArrayList<Enemy>();
ArrayList<Shot> shots = new ArrayList<Shot>();
ArrayList<PowerUp> powerUps = new ArrayList<PowerUp>();
Ground ground;

void setup() {
  int _width = 800;
  int _height = _width - _width/4;
  size(_width, _height);
  minim = new Minim(this);
  audioHandler = new AudioHandler();
  spawner = new Spawner();
  enemyHandler = new EnemyHandler();
  SpaceFont = createFont("ca.ttf", 48);
  menUI = new MenUI();
  ground = new Ground();
}

void draw() {
  background(0);
  textFont(SpaceFont);
  audioHandler.manage();
  menUI.display();
  if (gameStarted) { 
    displayGameObjects();
  }
  enemyHandler.update();
  mouseClicked = false;  //At the end of draw() to register a single mousebutton input.
}

void displayGameObjects() {
  //Iterates enemies array list and updates every enemy. 
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy _enemy = enemies.get(i);
    _enemy.update();
  }
  
  //Iterates deadEnemies array list and updates every enemy.
  for (int i = deadEnemies.size()-1; i > -1; i--) {
    deadEnemies.get(i).update();
  }
  
  //Iterate shots array list and updates every shot. 
  for (int i = shots.size() - 1; i >= 0; i--) {
    Shot _shot = shots.get(i);
    _shot.update();
  }

  //Iterates players array list and updates every player.
  for (int i = players.size() - 1; i >= 0; i--) {
    Player _player = players.get(i);
    _player.update();
  }

  //Iterates powerUps array list and updates every powerup. 
  for (int i = powerUps.size() - 1; i >= 0; i--) {
    PowerUp _powerUp = powerUps.get(i);
    _powerUp.update();
  }
  //Display ground and cover
  ground.display();
}

//keyReleased and keyPressed checks if keys are coded or not in case there is multiple players.
void keyReleased() {
  if (gameStarted) {
    if (key == CODED) { 
      players.get(players.size()-1).keyUp();
    }
    if (key != CODED) { 
      players.get(0).keyUp();
    }
  }
}
void keyPressed() {
  if (key == 27) {  //Key 27 = ESC
    key = 0;  //Cancel other ESC events(e.g. quit processing).
    if (!showHighscores) { 
      gamePaused = !gamePaused;
    }
  }
  if (gameStarted) {
    if (key == CODED) { 
      players.get(players.size()-1).keyDown();
    }
    if (key != CODED) { 
      players.get(0).keyDown();
    }
  }
}
void mousePressed() {
  mouseClicked = true;  //Register mousePressed as a click (for the buttons).
}

