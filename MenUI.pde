//
//
// Accesse classes: Enemy, Player

class MenUI {
  int titleSize = 74;
  int lastTick = 0;
  int nextTick = 2000;
  
  int totalScore;
  ArrayList<PointsText> pointsTexts = new ArrayList<PointsText>();
  String scoreLabel = "SCORE";
  String totalScoreLabel = "TOTAL SCORE";
  int labelHeight = 20;
  
  String btnLabel;
  float btnLabelY;
  int numBtns = 2;
  
  Block[] blocks;
  int lastMove;
  color c1, c2;
  
  MenUI() {
    btnLabelY = btnLabelY;
    showEnemies();
    c1 = color(0, 0, 0, 0);
    c2 = color(70, 115, 120);
    resetStartMenu();
  }
  
  void display() {
    //Start menu
    if(!gameStarted) {
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
      displayPoints();
    }
    //ESC menu
    if(gamePaused) { displayESCMenu(); }
  }
   
  void displayTitle() {
    textAlign(CENTER, TOP);
    textSize(titleSize*1.55);
    fill(255);
    noStroke();
    text("SPACE", width/2, -titleSize/10);
    fill(0, 255, 0);
    //Add flicker effect to title.
    if(millis() - lastTick >= nextTick) {
      fill(0, 255, 0, random(50, 255));
      if(millis() >= lastTick + nextTick + 500) {
        lastTick = millis();
        nextTick = (int)random(3000, 10000);
      }
    }
    textSize(titleSize);
    text("INVADERS", width/2, titleSize*1.25);
  }
  
  void showEnemies() {
    if(enemies.size() > 0) {
      for(int i = enemies.size()-1; i > -1; i--) {
        enemies.get(i).update();
      }
    }
  }
  
  void displayEnemiesInfo() {
    textAlign(LEFT, CENTER);
    textSize(labelHeight);
    for(int i = enemies.size()-1; i > -1; i--) {
      enemies.get(i).update();
      text("=", width/2, enemies.get(i).y);
      String _pointsText = enemies.get(i).points + " PTS";
      text(_pointsText, width - (width/8)*3 - textWidth(_pointsText)/2, enemies.get(i).y);
    }
  }
  
  void drawBackground(float _y, float _height) {
    noFill();
    int _counter = 0;
    for(int i = 0; i < _height; i++) {
      if(i > _height/2) {
        _counter += 2;
      }
      color c = lerpColor(c1, c2, (i-_counter)/(height/2.75));
      stroke(c);
      line(0, _y + i, width, _y + i);
    }
  }
  
  void displayStars() {
    fill(255);
    for(int i = 0; i < blocks.length; i++) {
      blocks[i].moveBlock();
    }
  }
  
  void displayBtns(float offsetY, int numBtns) {
    textAlign(CENTER, CENTER);
    for(int i = 0; i < numBtns; i++) {
      if(!gameStarted) {
        if(!gamePaused) {
          if(i == 0) { btnLabel = "Singleplayer"; }
          if(i == numBtns-1) { btnLabel = "Multiplayer"; }
        }
        else {
          if(i == 0) { btnLabel = "yes"; }
          if(i == numBtns-1) { btnLabel = "NO"; }
        }
      }
      else {
        if(i == 0) { btnLabel = "Resume"; }
        if(i == numBtns-1) { btnLabel = "Quit"; }
      }
      
      fill(126, 126, 126);
      textSize(labelHeight);
      btnLabelY = height/2 + offsetY + (labelHeight*2)*i;
      if(mouseY < btnLabelY + labelHeight/2 && mouseY > btnLabelY - labelHeight/2) {
        if(mouseX < width/2 + textWidth(btnLabel)/2 && mouseX > width/2 - textWidth(btnLabel)/2) {
          fill(0, 255, 0);
          textSize(labelHeight*1.1);
          if(mouseClicked && mouseButton == LEFT) {
            if(!gameStarted) {
              //Start menu button actions.
              if(!gamePaused) {
                if(i == 1) { isMultiplayer = true; }
                spawner.startGame(i + 1);
              }
              //Start menu pause button actions.
              else {
                if(i == 0) { exit(); }
                else if(i == 1) { resetGame(); }
              }
            }
            //In-game pause button actions.
            else {
              if(i == 0 && numBtns > 1) {
                gamePaused = false;
                calcAllLifes();
              }
              if(i == numBtns-1) { resetGame(); }
            }
            audioHandler.playSFX(1);
          }
        }
      }
      text(btnLabel, width/2, btnLabelY);
    }
  }
  
  void calcAllLifes() {
    int allLifes = 0;
    for(int i = players.size()-1; i > -1; i--) {
      allLifes += players.get(i).lifes;
    }
    if(allLifes < 1) {
      showHighscores = true;
      gamePaused = true;
    }
  }
  
  void displayPlayerUI() {
    totalScore = 0;
    for(int p = players.size()-1; p > -1; p--) {
      Player _player = players.get(p);
      String numPlayer = "P" + nf(p+1, 0);
      String score = nf(_player.score, 0);
      String lifesLabel = _player.lifesLabel;
      
      if(_player.lifes > 0) { fill(255); }
      else { fill(255, 0, 0, 220); }
      
      //Display player ID.
      float tx = _player.pHeight/2;
      textAlign(LEFT, CENTER);
      textSize(62);
      float p1IDx = tx*(1-p);
      float p2IDx = (width - tx - textWidth(numPlayer))*p;
      text(numPlayer, p1IDx + p2IDx, _player.pWidth/2);
      
      //Display labels for lifes and scores.
      tx += textWidth(numPlayer);
      textSize(labelHeight);
      float p1LabelX = tx*(1-p);
      float p2LifesLabelX = (width - tx - textWidth(lifesLabel))*p;
      text(lifesLabel, p1LabelX + p2LifesLabelX, _player.pWidth);
      if(isMultiplayer) {
        float p2ScoreLabelX = (width - tx - textWidth(scoreLabel))*p;
        text(scoreLabel, p1LabelX + p2ScoreLabelX, _player.pWidth - labelHeight*1.25);
      }
      
      //Display scores.
      tx += textWidth(lifesLabel) + _player.pWidth/4;
      if(isMultiplayer) {
        //Display individual scores.
        float p1ScoreX = (tx + _player.pWidth*1.75 - textWidth(score)/2)*(1-p);
        float p2ScoreX = (width - tx - textWidth(score)/2 - _player.pWidth*2)*p;
        text(score, p1ScoreX + p2ScoreX, _player.pWidth - labelHeight*1.25);
      }
      else {
        totalScoreLabel = scoreLabel;
      }
      
      //Display lifes.
      for(int i = 0; i < _player.lifes; i++) {
        float p1LifesX = (tx + (_player.pWidth*1.25)*i)*(1-p);
        float p2LifesX = (width - tx - _player.pWidth - (_player.pWidth*1.5)*i)*p;
        _player.drawPlayer(p1LifesX + p2LifesX, _player.pWidth, false);
      }
      totalScore += _player.score;
    }
  }
  
  void displayTotalScore() {
    fill(255);
    textAlign(CENTER, TOP);
    textSize(labelHeight/1.5);
    text(totalScoreLabel, width/2, 0);
    textSize(42);
    text(totalScore, width/2, labelHeight/2);
  }
  
  void displayPoints() {
    for(int i = pointsTexts.size()-1; i > -1; i--) {
      PointsText pointsText = pointsTexts.get(i);
      pointsText.update();
    }
  }
  
  void displayESCMenu() {
    if(gameStarted) {
      rectMode(CENTER);
      fill(0, 255, 0, 70);
      int playersAlive = 0;
      for(int i = players.size()-1; i > -1; i--) {
        if(!players.get(i).isDead) { playersAlive++; }
      }
      if(playersAlive > 0) {
        float menuHeight = labelHeight*4;
        drawBackground(height/2 - menuHeight*1.5, menuHeight*3);
        displayBtns(-menuHeight/2 + labelHeight*0.9, 2);
      }
      else {
        drawBackground(height*0.65, height*0.625);
        displayBtns(height/4 + labelHeight*3, 1);
      }
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
    resetStartMenu();
  }
  
  void resetStartMenu() {
    //reset blocks
    blocks = new Block[100];
    for(int i = 0; i < blocks.length; i++) {
      blocks[i] = new Block(new PVector(0, 0), 2);
      blocks[i].bFill = color(255, 150);
    }
  
    //add start menu enemies
    enemyHandler.reset();
    for(int h = 5; h > 0; h--) {
      for(int i = 0; i < 3; i++) {
        int _blockSize = 4;
        float _eOffset = _blockSize*12;
        Enemy enemy = new Enemy(1+i, (width/8)*3 - (_eOffset*1.5)*(h-1), height/2 + _eOffset*1.5 - (_eOffset*1.5)*i, _blockSize);
        enemies.add(enemy);
        enemy.eFill = color(255, 255 - h*48);
        enemy.setBlocksFill();
      }
    }
  }
}
