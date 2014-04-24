import ddf.minim.*; //Import audio library
Minim minim;
AudioHandler audioHandler;
AudioPlayer[] audioPlayer = new AudioPlayer[3];

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
  audioPlayer[0] = minim.loadFile("theme.mp3");
  audioPlayer[1] = minim.loadFile("playerShot.wav");
  audioPlayer[2] = minim.loadFile("button.mp3");
  spawner = new Spawner();
  menUI = new MenUI();
}

void draw() {
  background(0);
  audioHandler.manage();
  if(gameStarted) { displayGameObjects(); }
  menUI.display();
  mouseClicked = false;
}

void displayGameObjects() {
  //Iterates enemies array list and updates every enemy. 
  for(int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    e.update();
  }
  //Iterate shots array list and updates every shot. 
  for(int i = shots.size() - 1; i >= 0; i--) {
    Shot s = shots.get(i);
    s.update();
  }
  //Iterates players array list and updates every player.
  //and adjusts total score and displays players UI.
  menUI.totalScore = 0;
  for(int i = players.size() - 1; i >= 0; i--) {
    Player player = players.get(i);
    player.update();
    menUI.displayPlayerUI(player);
    menUI.totalScore += players.get(i).score;
  }
  menUI.displayTotalScore();
  //Iterates powerUps array list and updates every powerup. 
  for(int i = powerUps.size() - 1; i >= 0; i--) {
    PowerUp powerUp = powerUps.get(i);
    powerUp.update();
  }
}

//Shoot function handles both player and enemy shots.
void shoot(float posX, float posY, int size, int dir, int owner) {
  Shot s = new Shot(posX, posY + (size*dir), dir, owner);
  shots.add(s);
}

void resetGame() {
  gamePaused = false;
  gameStarted = false;
  players.clear();
  enemies.clear();
  shots.clear();
}

//keyReleased and keyPressed checks if keys are coded or not.
//player 1 controls A, D and SPACE are not coded while
//player 2 controls LEFT, RIGHT and CONTROL are coded.
void keyReleased() {
  if(gameStarted && !gamePaused) {
    if(key == CODED && isMultiplayer) { players.get(1).keyUp(); }
    else { players.get(0).keyUp(); }
  }
}
void keyPressed() {
  //if ESC
  if(key == 27) {
    //cancel other ESC events
    key = 0;
    gamePaused = !gamePaused;
  }
  if(gameStarted && !gamePaused) {
    if(key == CODED) {
      if(isMultiplayer) { players.get(1).keyDown(); }
    }
    else { players.get(0).keyDown(); }
  }
}
void mousePressed() {
  mouseClicked = true;
  //enemy shoot (for testing only).
  if(gameStarted && !gamePaused) {
    enemies.get(0).attack();
  }
}
