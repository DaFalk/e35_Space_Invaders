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
  
  color c1, c2;
  
  MenUI() {
    btnLabelY = btnLabelY;
    showEnemies();
    c1 = color(0, 0, 0);
    c2 = color(0, 0, 255);
  }
  
  void display() {
    if(!gameStarted) { displayStartMenu(); }
    else {
      displayPlayerUI();
      displayTotalScore();
      displayPoints();
    }
    if(gamePaused) { displayESCMenu(); }
  }
  
  void displayStartMenu() {
    displayTitle();
    displayEnemiesInfo();
    displayBtns(height/4 + labelHeight*3);
  }
  
  void displayTitle() {
    noFill();
    int _counter = 0;
    for(int i = 0; i < height*0.625; i++) {
      if(i > height*0.3125) {
        _counter += 2;
      }
      color c = lerpColor(c1, c2, (i-_counter)/(height/2.75));
      stroke(c);
      line(0, height*0.2 + i, width, height*0.2 + i);
    }
    
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
    for(int i = 0; i < 3; i++) {
      int _blockSize = 4;
      int _eOffset = _blockSize*12;
      enemies.add(new Enemy(1+i, (width/8)*3, height/2 + _eOffset*1.5 - (_eOffset*1.5)*i, _blockSize));
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
  
  void displayBtns(float offsetY) {
    textAlign(CENTER, CENTER);
    for(int i = 0; i < numBtns; i++) {
      if(!gameStarted) {
        if(!gamePaused) {
          if(i == 0) { btnLabel = "Singleplayer"; }
          if(i == 1) { btnLabel = "Multiplayer"; }
        }
        else {
          if(i == 0) { btnLabel = "yes"; }
          if(i == 1) { btnLabel = "NO"; }
        }
      }
      else {
        if(i == 0) { btnLabel = "Resume"; }
        if(i == 1) { btnLabel = "Quit"; }
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
              if(i == 0) { gamePaused = false; }
              else if(i == 1) { resetGame(); }
            }
            audioHandler.playSFX(1);
          }
        }
      }
      text(btnLabel, width/2, btnLabelY);
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
        _player.drawPlayer(p1LifesX + p2LifesX, _player.pWidth);
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
      fill(0, 255, 0, 50);
      float menuHeight = labelHeight*4;
      float menuWidth = menuHeight*4;
      rect(width/2, height/2, menuWidth, menuHeight);
      displayBtns(-menuHeight/2 + labelHeight*0.9);
    }
    else {
      fill(180, 0, 0);
      textAlign(CENTER, CENTER);
      textSize(labelHeight);
      text("Do you want to exit?", width/2, (height/4)*3 + labelHeight);
    }
  }
}
