//
//
// Access classes: Enemy, Player, FloatingText

class MenUI {
  float titleSize = 0.15*width;
  int lastTick = 0;
  int nextTick = 2000;

  int totalScore;
  ArrayList<FloatingText> floatingTexts = new ArrayList<FloatingText>();
  String scoreLabel = "SCORE";
  String totalScoreLabel = "TOTAL SCORE";
  float labelHeight = 0.025*width;

  String btnLabel;
  float btnLabelY;
  int numBtns = 2;

  Block[] blocks;
  int lastMove;
  color c1, c2;
  
  String load = "Loading ";
  String upload = "Uploading ";
  boolean loading = false;

  MenUI() {
    btnLabelY = btnLabelY;
    showEnemies();
    c1 = color(0, 0, 0, 0);
    c2 = color(70, 115, 120);
    resetStartMenu();
  }

  void display() {
    //Start menu
    if (!gameStarted) {
      drawBackground(height*0.2, height*0.625);
      displayStars();
      displayTitle();
      showEnemies();
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
    text("SPACE", width/2 - titleSize/2, titleSize/5);
    fill(0, 255, 0);
    //Add flicker effect to title.
    if (millis() - lastTick >= nextTick) {
      fill(0, 255, 0, random(50, 255));
      if (millis() >= lastTick + nextTick + 500) {
        lastTick = millis();
        nextTick = (int)random(3000, 10000);
      }
    }
    textSize(titleSize*0.65);
    text("INVADERS", width/2 + titleSize/3, titleSize*0.95);
  }

  void showEnemies() {
    if (enemies.size() > 0) {
      for (int i = enemies.size()-1; i > -1; i--) {
        enemies.get(i).update();
      }
    }
  }

  void displayEnemiesInfo() {
    textAlign(LEFT, CENTER);
    textSize(labelHeight);
    for (int i = enemies.size()-1; i > -1; i--) {
      enemies.get(i).update();
      text("=", width/2, enemies.get(i).enemyPos.y);
      String _pointsText = enemies.get(i).points + " PTS";
      text(_pointsText, width - (width/8)*3 - textWidth(_pointsText)/2, enemies.get(i).enemyPos.y);
    }
  }

  void drawBackground(float _y, float _height) {
    noFill();
    int _counter = 0;
    for (int i = 0; i < _height; i++) {
      if (i > _height/2) { _counter += 2; }
      
      color c = lerpColor(c1, c2, (i-_counter)/(height/2.75));
      stroke(c);
      line(0, _y + i, width, _y + i);
    }
  }

  void displayStars() {
    fill(255);
    for (int i = 0; i < blocks.length; i++) {
      blocks[i].moveBlock();
    }
  }

  void displayBtns(float offsetY, int numBtns) {
    textAlign(CENTER, CENTER);
    for (int i = 0; i < numBtns; i++) {
      if (!gameStarted) {
        if (!gamePaused) {
          if (i == 0) { btnLabel = "Singleplayer"; }
          if (i == numBtns-1) { btnLabel = "Multiplayer"; }
        }
        else {
          if (i == 0) { btnLabel = "yes"; }
          if (i == numBtns-1) { btnLabel = "NO"; }
        }
      }
      else {
        if (i == 0) { btnLabel = "Resume"; }
        if (i == numBtns-1) { btnLabel = "Quit"; }
      }

      fill(126, 126, 126);
      textSize(labelHeight);
      btnLabelY = height/2 + offsetY + (labelHeight*2)*i;
      if (mouseY < btnLabelY + labelHeight/2 && mouseY > btnLabelY - labelHeight/2) {
        if (mouseX < width/2 + textWidth(btnLabel)/2 && mouseX > width/2 - textWidth(btnLabel)/2) {
          fill(0, 255, 0);
          textSize(labelHeight*1.1);
          if (mouseClicked && mouseButton == LEFT) {
            if (!gameStarted) {
              //Start menu button actions.
              if (!gamePaused) {
                if (i == 1) { isMultiplayer = true; }
                spawner.startGame(i + 1);
              }
              //Start menu pause button actions.
              else {
                if (i == 0) { exit(); }
                else if (i == 1) { resetGame(); }
              }
            }
            //In-game pause button actions.
            else {
              if (i == 0 && numBtns > 1) {
                gamePaused = false;
                calcAllLifes();
              }
              if (i == numBtns-1) {
                if(showHighscores) {
                  highscores.updateName();
                }
                resetGame();
              }
            }
            audioHandler.playSFX(1);
          }
        }
      }
      text(btnLabel, width/2, btnLabelY);
    }
  }

  //Display Player's ID, Lifes, Score and players total score.
  void displayPlayerUI() {
    totalScore = calcTotalScore();
    for (int i = players.size()-1; i > -1; i--) {
      Player _player = players.get(i);
      String numPlayer = "P" + nf(i+1, 0);
      String score = nf(_player.score, 0);
      String lifesLabel = _player.lifesLabel;

      if (_player.lifes > 0) { fill(255); }
      else { fill(255, 0, 0, 220); }

      float _x = labelHeight/2;

      // Display player ID.
      textAlign(LEFT, CENTER);
      textSize(labelHeight*3 + labelHeight/10);
      float p1IDx = _x*(1-i);
      float p2IDx = (width - textWidth(numPlayer))*i;
      text(numPlayer, p1IDx + p2IDx, labelHeight*1.25);

      _x += textWidth(numPlayer);

      // Display labels for lifes and scores.
      textSize(labelHeight);
      float p1LabelX = _x*(1-i);
      float p2LifesLabelX = (width - _x + labelHeight/4 - textWidth(lifesLabel))*i;
      text(lifesLabel, p1LabelX + p2LifesLabelX, _player.pWidth);
      if (isMultiplayer) {
        float p2ScoreLabelX = (width - _x + labelHeight/4 - textWidth(scoreLabel))*i;
        text(scoreLabel, p1LabelX + p2ScoreLabelX, _player.pWidth - labelHeight*1.25);
      }

      _x += textWidth(lifesLabel) + _player.pWidth/4;

      // Display scores.
      textAlign(CENTER, CENTER);
      if (isMultiplayer) {
        float p1ScoreX = (_x + _player.pWidth*1.375)*(1-i);
        float p2ScoreX = (width - _x + labelHeight/4 - _player.pWidth*1.375)*i;
        text(score, p1ScoreX + p2ScoreX, _player.pWidth - labelHeight*1.25);
      }
      else { totalScoreLabel = scoreLabel; }

      // Display lifes.
      for (int h = 0; h < _player.lifes; h++) {
        float p1LifesX = (_x + _player.pWidth/3 + _player.pWidth*h)*(1-i);
        float p2LifesX = (width - _x - _player.pWidth/4 - _player.pWidth*h)*i;
        _player.drawPlayer(p1LifesX + p2LifesX, _player.pWidth, 0.75, false);
      }
    }
  }

  void calcAllLifes() {
    int allLifes = 0;
    for (int i = players.size()-1; i > -1; i--) {
      allLifes += players.get(i).lifes;
    }
    if (allLifes < 1) {
      displayLoadingScreen(load);
      loading = true;
      gamePaused = true;
    }
  }
  
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

  void displayFloatingPoints() {
    for (int i = floatingTexts.size()-1; i > -1; i--) {
      floatingTexts.get(i).update();
    }
  }
  
  void displayLoadingScreen(String _string) {
    String _text = _string;
    fill(0, 200);
    textAlign(CENTER, CENTER);
    rect(width/2, height/2, width, height);
    fill(255);
    textSize(labelHeight); 
    text(_text + "Highscores...", width/2, height/2);
    textSize(labelHeight/2);
    text("^^^^^^ " + _text + "^^^^^^", width/2, height - labelHeight*2);
  }

  void displayESCMenu() {
    if (gameStarted) {
      fill(0, 255, 0, 70);
      if (!showHighscores) {
        if(loading) {
          displayLoadingScreen(load);  //Called again for smooth transition to highscorelist.
          highscores.updateHighscores();  //This takes a while to run and freezes the display while running.
          loading = false;
        }
        else {
          float menuHeight = labelHeight*4;
          drawBackground(height/2 - menuHeight*1.5, menuHeight*3);
          displayBtns(-menuHeight/2 + labelHeight*0.9, 2);
        }
      }
      else { highscores.display(); }
    }
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
    //reset blocks
    blocks = new Block[50];
    for (int i = 0; i < blocks.length; i++) {
      blocks[i] = new Block(new PVector(0, 0), 2);
      blocks[i].bFill = color(255, 150);
    }

    //add start menu enemies
    enemyHandler.reset();
    for (int h = 5; h > 0; h--) {
      for (int i = 0; i < 3; i++) {
        int _blockSize = (int)labelHeight/5;
        float _eOffset = _blockSize*18;
        PVector _pos = new PVector((width/8)*3 - _eOffset*(h-1), height/2 + _eOffset - _eOffset*i);
        Enemy enemy = new Enemy(1+i, _pos, _blockSize);
        enemies.add(enemy);
        enemy.eFill = color(255, 255 - h*48);
        enemy.setBlocksFill();
      }
    }
  }
}

