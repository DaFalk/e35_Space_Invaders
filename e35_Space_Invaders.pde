/*
 MPGD: Exercise 35: Space Invaders
 Jimmie Gustafsson (jgus) & Troels Falkenberg (tfal)
 
 INFO:
 This program is a clone of the classic game "Space Invaders" with a few addons, 
 which includes various weapon types, shield and online highscore lists for single- 
 and multiplayer. 
 
 Computer runnnig program should preferably be connected to the internet.
 
 CONTROLS:
 
 SINGLEPLAYER:
 
   Pause menu = "ESC".
   Move = "LEFT" and "RIGHT" . 
   Shoot = "UP" or "SPACE". 
 
 
 MULTIPLAYER:
 
   Pause menu = "ESC".
   Player 1: 
     Move = "A" and "D". 
     Shoot = "SPACE".     
   Player 2: 
     Move = "LEFT" and "RIGHT". 
     Shoot = "UP".
 */

//Import java libraries.
import java.net.URL;
import java.util.*;

//Import Google spreadsheet libraries.
import com.google.gdata.client.spreadsheet.*;
import com.google.gdata.data.*;
import com.google.gdata.data.spreadsheet.*;
import com.google.gdata.util.*;

//Import audio library
import ddf.minim.*;

Minim minim;
AudioHandler audioHandler;

boolean gameStarted = false;
boolean gamePaused = false;
boolean showHighscores = false;
boolean isMultiplayer = false;
boolean mouseClicked = false;

PFont SpaceFont;

// the classes that is called by the main program.
Spawner spawner;
EnemyHandler enemyHandler;
MenUI menUI;
Highscores highscores;
Ground ground;

//Each game object is stored in an array list associated to that kind of object.
ArrayList<Player> players = new ArrayList<Player>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<Enemy> deadEnemies = new ArrayList<Enemy>();
ArrayList<Shot> shots = new ArrayList<Shot>();
ArrayList<PowerUp> powerUps = new ArrayList<PowerUp>();

void setup() {
  int _width = 800;
  int _height = _width - _width/4;
  size(_width, _height);

  SpaceFont = createFont("ca.ttf", 48);
  rectMode(CENTER);

  //Initialize the main classes.
  minim = new Minim(this);
  audioHandler = new AudioHandler();
  spawner = new Spawner();
  enemyHandler = new EnemyHandler();
  menUI = new MenUI();
  highscores = new Highscores();
  ground = new Ground();
}

void draw() {
  background(0);
  textFont(SpaceFont);
  audioHandler.manage();

  if (gameStarted) { 
    displayGameObjects();
  }

  menUI.display();  //Display menu, UI or highscores.
  enemyHandler.update();  //Manage enemies (both in menu and in-game).
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

//time fix function (to avoid typo's).
float timeFix(float _amount, int _lastTick) {
  float amount = _amount*(millis()-_lastTick)*0.001;
  return amount;
}

//Convert value to fit the current screen size.
float dynamicValue(float _value) {
  float value = (_value/800)*width;
  return value;
}

//Check collision between two objects (function takes the position and half the width and height of each object).
boolean collisionCheck(PVector _pos1, float _offset1X, float _offset1Y, PVector _pos2, float _offset2X, float _offset2Y) {
  if (_pos1.x + _offset1X> _pos2.x - _offset2X && _pos1.x - _offset1X < _pos2.x + _offset2X) {
    if (_pos1.y + _offset1Y > _pos2.y - _offset2Y && _pos1.y - _offset1Y < _pos2.y + _offset2Y) {
      return true;
    }
  }
  return false;
}

//keyReleased and keyPressed checks if keys are coded or not in case there is multiple players.
void keyReleased() {
  if (gameStarted) {
    //Affect player 1 if in singleplayer
    //If in multiplayer, CODED keys affect player 2
    if (key == CODED) { 
      players.get(players.size()-1).keyUp();
    }
    //and non-CODED keys affect player 1.
    if (key != CODED) { 
      players.get(0).keyUp();
    }
  }
}
void keyPressed() {
  if (key == 27) {  //Key 27 = ESC
    key = 0;  //Cancel other ESC events(e.g. quit processing).
    //If not in highscore screen pause/unpause the game
    if (!showHighscores) {
      if (!menUI.loading) { 
        gamePaused = !gamePaused;
      }
    }
    else {
      //if not save highscore list (if any changes has been made) and quit to main menu.
      highscores.updateName();
      menUI.resetGame();
    }
  }
  if (gameStarted) {
    //Affect player 1 if in singleplayer
    //If in multiplayer, CODED keys affect player 2
    if (key == CODED) { 
      players.get(players.size()-1).keyDown();
    }
    //and non-CODED keys affect player 1.
    if (key != CODED) { 
      players.get(0).keyDown();
    }
  }
  if (!showHighscores) {
    //In start menu ENTER starts singplayer mode.
    if (keyCode == ENTER && !gameStarted) { 
      spawner.startGame(1);
    }
  }
  else { 
    highscores.updateName();
  }  //Update the highscore name whenever there is a key input during highscore screen.
}
void mousePressed() {
  mouseClicked = true;  //Register mousePressed as a click (for the buttons).
}

