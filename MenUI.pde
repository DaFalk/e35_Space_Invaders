// This class manage all menu and UI elements.
// It also controls the game state and resetsetting of the different array lists and booleans.
//
// Access classes: Enemy, EnemyHandler, Player, FloatingText, Ground, PowerUp, Shot, Highscores, AudioHandler and Spawner.

class MenUI {
  float titleSize = dynamicValue(120);
  int lastTick = 0;
  int nextTick = 2000;

  ArrayList<FloatingText> floatingTexts = new ArrayList<FloatingText>();
  
  int totalScore;
  String scoreLabel = "SCORE";
  String totalScoreLabel = "TOTAL SCORE";
  float labelHeight = dynamicValue(20);

  String btnLabel;
  float btnLabelY;

  Block[] starBlocks;  //Used for start menu stars.
  int lastMove;
  color c1 = color(0, 0, 0, 0);
  color c2 = color(70, 115, 120);  //Gradient color.
  
  String load = "Loading ";
  String upload = "Uploading ";
  boolean loading = false;

  MenUI() {
    resetStartMenu();  //Reset stars and enemyHandler and add stars and enemies.
  }

  void display() {
    if(!gameStarted) {
      //Start menu
      drawBackground(height*0.2, height*0.625);
      displayStars();
      displayTitle();
      displayEnemiesInfo();
      displayBtns(height/4 + labelHeight*3, 2);
    }
    else {
      //In-game UI
      displayPlayerUI();
      displayTotalScore();
      displayFloatingPoints();
    }
    //Display Pause menu (ESC) if game is paused.
    if(gamePaused) { displayESCMenu(); }
  }

  void displayTitle() {
    textAlign(CENTER, TOP);
    textSize(titleSize);
    fill(255);
    noStroke();
    text("CLONE", width/2 - titleSize/2, titleSize/5);
    fill(0, 255, 0);
    //Add flicker effect to last part of title.
    if(millis() - lastTick >= nextTick) {
      fill(0, 255, 0, random(50, 255));
      if(millis() >= lastTick + nextTick + 500) {
        lastTick = millis();
        nextTick = (int)random(3000, 10000);
      }
    }
    textSize(titleSize*0.65);
    text("INVADERS", width/2 + titleSize/3, titleSize*0.95);
  }
  
  //Display the start menu info text for each enemy type and update start menu enemies.
  void displayEnemiesInfo() {
    textSize(labelHeight);
    for(int i = enemies.size()-1; i > -1; i--) {
      enemies.get(i).update();
      String _pointsText = enemies.get(i).points + " PTS";  //Get points from enemy class (depends on enemy type).
      if(enemies.get(i).type != 10) {
        //Regular enemies info text positions.
        textAlign(LEFT, CENTER);
        text("=", width/2, enemies.get(i).enemyPos.y);
        text(_pointsText, width - (width/8)*3 - textWidth(_pointsText)/2, enemies.get(i).enemyPos.y);
      }
      else {
        //Boss info text positions.
        textAlign(CENTER, CENTER);
        text("BONUS", width - width/7, enemies.get(i).enemyPos.y - labelHeight*2);
        text(_pointsText, width - width/7, enemies.get(i).enemyPos.y + labelHeight*2);
      }
    }
  }

//Draw background gradient with lines.
  void drawBackground(float _y, float _height) {
    noFill();
    int _counter = 0;
    for(int i = 0; i < _height; i++) {
      if(i > _height/2) { _counter += 2; }
      //Do color transition from transparent black to gradient color depending on line's positions.
      //After drawing half the lines do transition back to transparent black (countering "i" with "_counter").
      color c = lerpColor(c1, c2, (i-_counter)/(height/2.75));
      stroke(c);
      line(0, _y + i, width, _y + i);
    }
  }

//Move and display start menu background stars.
  void displayStars() {
    fill(255);
    for(int i = 0; i < starBlocks.length; i++) {
      starBlocks[i].moveBlock();
      starBlocks[i].display();
    }
  }

  void displayBtns(float _offsetY, int _numBtns) {
    textAlign(CENTER, CENTER);
    //Iterate requested amount of buttons and set label, position and action according to game state.
    for(int i = 0; i < _numBtns; i++) {
      if(!gameStarted) {
        //Start menu button labels.
        if(!gamePaused) {
          if(i == 0) { btnLabel = "Singleplayer"; }
          if(i == _numBtns-1) { btnLabel = "Multiplayer"; }
        }
        //Start menu pause button labels.
        else {
          if(i == 0) { btnLabel = "yes"; }
          if(i == _numBtns-1) { btnLabel = "NO"; }
        }
      }
      else {
        //In-game pause button labels.
        if(i == 0) { btnLabel = "Resume"; }
        if(i == _numBtns-1) { btnLabel = "Quit"; }
      }

      fill(126, 126, 126);
      textSize(labelHeight);
      //Set Y positions according to requested offset.
      btnLabelY = height/2 + _offsetY + (labelHeight*2)*i;
      
      //Check if mouse hovers over buttons.
      if(mouseY < btnLabelY + labelHeight/2 && mouseY > btnLabelY - labelHeight/2) {
        if(mouseX < width/2 + textWidth(btnLabel)/2 && mouseX > width/2 - textWidth(btnLabel)/2) {
          //Fill with green and enlarge text.
          fill(0, 255, 0);
          textSize(labelHeight*1.1);
          
          //On mouse click execute action.
          if(mouseClicked && mouseButton == LEFT) {
            if(!gameStarted) {
              //Start menu button actions.
              if(!gamePaused) {
                if(i == 1) { isMultiplayer = true; }
                spawner.startGame(i + 1);  //Number of players depend on the number of the button (0 or 1).
              }
              //Start menu pause button actions.
              else {
                if(i == 0) { exit(); }  //Quit program.
                else if(i == 1) { resetGame(); }  //Return to start menu.
              }
            }
            //In-game pause button actions.
            else {
              //If 2 buttons exist (ie. not showing highscores).
              if(i == 0 && _numBtns > 1) { gamePaused = false; }
              //If only 1 button exist (ie. showing highscores) then update name and trigger potential saving.
              if(i == _numBtns-1) {
                if(showHighscores) { highscores.updateName(); }
                resetGame();  //Return to start menu.
              }
            }
            audioHandler.playSFX(1);  //Play click sound.
          }
        }
      }
      text(btnLabel, width/2, btnLabelY);
    }
  }

  //Display Player's ID, Lifes, Score and players total score.
  void displayPlayerUI() {
    totalScore = calcTotalScore();
    
    for(int i = players.size()-1; i > -1; i--) {
      Player _player = players.get(i);
      String numPlayer = "P" + nf(i+1, 0);
      String score = nf(_player.score, 0);
      String lifesLabel = _player.lifesLabel;

      if(_player.lifes > 0) { fill(255); }
      else { fill(255, 0, 0, 220); }

      float _x = labelHeight/2;  //Set x position.

      // Display player ID.
      textAlign(LEFT, CENTER);
      textSize(labelHeight*3 + labelHeight/10);
      float p1IDx = _x*(1-i);
      float p2IDx = (width - textWidth(numPlayer))*i;
      text(numPlayer, p1IDx + p2IDx, labelHeight*1.25);

      _x += textWidth(numPlayer);  //Adjust x position.

      // Display labels for lifes and scores.
      textSize(labelHeight);
      float p1LabelX = _x*(1-i);
      float p2LifesLabelX = (width - _x + labelHeight/4 - textWidth(lifesLabel))*i;
      text(lifesLabel, p1LabelX + p2LifesLabelX, _player.pWidth);
      if(isMultiplayer) {
        float p2ScoreLabelX = (width - _x + labelHeight/4 - textWidth(scoreLabel))*i;
        text(scoreLabel, p1LabelX + p2ScoreLabelX, _player.pWidth - labelHeight*1.25);
      }

      _x += textWidth(lifesLabel) + _player.pWidth/4;  //Adjust x position.

      // Display scores.
      textAlign(CENTER, CENTER);
      if(isMultiplayer) {
        float p1ScoreX = (_x + _player.pWidth*1.375)*(1-i);
        float p2ScoreX = (width - _x + labelHeight/4 - _player.pWidth*1.375)*i;
        text(score, p1ScoreX + p2ScoreX, _player.pWidth - labelHeight*1.25);
      }
      else { totalScoreLabel = scoreLabel; }  //Use total score label as score label if singleplayer.

      // Display lifes.
      for(int h = 0; h < _player.lifes; h++) {
        float p1LifesX = (_x + _player.pWidth/3 + _player.pWidth*h)*(1-i);
        float p2LifesX = (width - _x - _player.pWidth/4 - _player.pWidth*h)*i;
        _player.drawPlayer(p1LifesX + p2LifesX, _player.pWidth, 0.75, false);
      }
    }
  }

  void calcAllLifes() {
    int allLifes = 0;
    for(int i = players.size()-1; i > -1; i--) {
      allLifes += players.get(i).lifes;
    }
    //If all player lifes are lost trigger highscorelist.
    if(allLifes < 1) {
      displayLoadingScreen(load);
      loading = true;
      gamePaused = true;
    }
  }
  
  //Return the total score of all players.
  int calcTotalScore() {
    totalScore = 0;
    for(int i = players.size()-1; i> -1; i--) {
      totalScore += players.get(i).score;
    }
    return totalScore;
  }

  void displayTotalScore() {
    fill(255);
    textAlign(CENTER, TOP);
    textSize(labelHeight/1.5);
    text(totalScoreLabel, width/2, 0);
    textSize(labelHeight*2 + titleSize/10);
    text(totalScore, width/2, labelHeight/2);
  }
  
  //Initialize a custom floating text at a custom position.
  void addFloatingText(Player _owner, PVector _pos, String _text) {
    FloatingText floatingText = new FloatingText(_pos);  //Initialize a floating text at the requested position.
    
    //If floating text is passed a player owner then the text is points from a kill and adjusted accordingly. 
    if(_owner != null) {
      _owner.score += Integer.parseInt(_text);  //Convert score text to intergers and add to player's score.
      floatingText.score = Integer.parseInt(_text);  //Convert score text to intergers and set floating text score.
    }
    
    floatingText.textToDisplay = _text;  //Set text.
    floatingTexts.add(floatingText);  //Add floating text to the floating points array list in menUI.
  }
  
  void displayFloatingPoints() {
    for(int i = floatingTexts.size()-1; i > -1; i--) {
      floatingTexts.get(i).update();
    }
  }
  
  //Draw loading screen text (only shows on use of ENTER during highscorelist).
  void displayLoadingScreen(String _string) {
    String _text = _string;
    fill(0, 200);
    textAlign(CENTER, CENTER);
    rect(width/2, height/2, width, height);
    fill(255);
    textSize(labelHeight); 
    text(_text + "Highscores...", width/2, height/2);
  }

  void displayESCMenu() {
    //In-game ESC menu.
    if(gameStarted) {
      fill(0, 255, 0, 70);
      //In-game
      if(!showHighscores) {
        if(!loading) {
          float menuHeight = labelHeight*4;
          drawBackground(height/2 - menuHeight*1.5, menuHeight*3);
          displayBtns(-menuHeight/2 + labelHeight*0.9, 2);
        }
        else {
          displayLoadingScreen(load);  //Called again for smooth transition to highscorelist.
          highscores.updateHighscores();  //This takes a while to run and freezes the display while running.
          loading = false;
        }
      }
      //Highscorelist.
      else { highscores.display(); }
    }
    //Start menu ESC menu.
    else {
      fill(180, 0, 0);
      textAlign(CENTER, CENTER);
      textSize(labelHeight);
      text("Do you want to exit?", width/2, (height/4)*3 + labelHeight);
    }
  }
  
  void resetGame() {
    gamePaused = false;
    gameStarted = false;
    showHighscores = false;
    players.clear();
    shots.clear();
    powerUps.clear();
    ground.reset();
    resetStartMenu();
  }
  
  void resetStartMenu() {
    //reset starBlocks.
    starBlocks = new Block[50];
    for(int i = 0; i < starBlocks.length; i++) {
      starBlocks[i] = new Block(new PVector(0, 0), 2);
      starBlocks[i].bFill = color(255, 150);
    }
        
    //Spawn start menu enemies and boss.
    spawner.spawnStartMenuEnemies();
  }
}

