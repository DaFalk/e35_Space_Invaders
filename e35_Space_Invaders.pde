// MPGD: Exercise 35: Space Invaders
// Jimmie Gustafsson (jgus) & Troels Falkenberg (tfal)
//
//

import java.net.URL;
import java.util.*;
import com.google.gdata.client.spreadsheet.*;
import com.google.gdata.data.*;
import com.google.gdata.data.spreadsheet.*;
import com.google.gdata.util.*;

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
Highscores highscores;

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
  rectMode(CENTER);
  minim = new Minim(this);
  audioHandler = new AudioHandler();
  spawner = new Spawner();
  enemyHandler = new EnemyHandler();
  SpaceFont = createFont("ca.ttf", 48);
  menUI = new MenUI();
  highscores = new Highscores();
  ground = new Ground();
  println(dynamicValue(10));
}

void draw() {
  background(0);
  textFont(SpaceFont);
  audioHandler.manage();
  if (gameStarted) { 
    displayGameObjects();
  }
  menUI.display();
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
  spawner.spawnEnemyBoss();
}

//time fix function (to avoid typo's).
float timeFix(float _amount, int _lastTick) {
  float amount = _amount*(millis()-_lastTick)*0.001;
  return amount;
}

float dynamicValue(float _value) {
  float value = (_value/800)*width;
  return value;
}

boolean collisionCheck(PVector _pos1, PVector _pos2, float _offsetX, float _offsetY) {
  if (_pos1.x > _pos2.x - _offsetX && _pos1.x < _pos2.x + _offsetX) {
    if (_pos1.y > _pos2.y - _offsetY && _pos1.y < _pos2.y + _offsetY) {
      return true;
    }
  }
  return false;
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
      if (!menUI.loading) { 
        gamePaused = !gamePaused;
      }
    }
    else {
      highscores.updateName();
      menUI.resetGame();
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
  if (!showHighscores) {
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

