class MenUI {
  String title = "SPACE INVADERS";
  int titleSize = 74;
  String scoreLabel = "SCORE";
  String totalScoreLabel = "TOTAL SCORE";
  String btnLabel;
  int labelHeight = 20;
  int totalScore = 0;
  int lastTick = 0;
  int nextTick = 2000;
  
  MenUI() {
  }
  
  void display() {
    if(!gameStarted) { displayStartMenu(); }
    if(gamePaused) { displayESCMenu(); }
  }
  
  void displayStartMenu() {
    displayTitle();
    displayBtns(height/4);
  }
  
  void displayTitle() {
    fill(0, 255, 0);
    //Add flicker effect to title.
    if(millis() >= lastTick + nextTick) {
      fill(0, 255, 0, random(50, 255));
      if(millis() >= lastTick + nextTick + 500) {
        lastTick = millis();
        nextTick = (int)random(3000, 10000);
      }
    }
    textAlign(CENTER, TOP);
    textSize(titleSize);
    text(title, width/2, width/2 - textWidth(title)/1.75);
  }
  
  void displayBtns(float offsetY) {
    textAlign(CENTER, CENTER);
    for(int i = 0; i < 2; i++) {
      
      if(!gameStarted) {
        if(!gamePaused) {
          if(i == 0) { btnLabel = "Singleplayer"; }
          if(i == 1) { btnLabel = "Multiplayer"; }
        }
        else {
          if(i == 0) { btnLabel = "Yes"; }
          if(i == 1) { btnLabel = "NO"; }
        }
      }
      else {
        if(i == 0) { btnLabel = "Resume"; }
        if(i == 1) { btnLabel = "Quit"; }
      }
      
      fill(126, 126, 126);
      textSize(labelHeight);
      float btnLabelY = height/2 + offsetY + (labelHeight*2)*i;
      if(mouseY < btnLabelY + labelHeight/2 && mouseY > btnLabelY - labelHeight/2) {
        if(mouseX < width/2 + textWidth(btnLabel)/2 && mouseX > width/2 - textWidth(btnLabel)/2) {
          fill(0, 255, 0);
          textSize(labelHeight*1.1);
          if(mouseClicked && mouseButton == LEFT) {
            if(!gameStarted) {
              if(!gamePaused) {
                //Start menu button actions.
                if(i == 1) { isMultiplayer = true; }
                spawner.spawnPlayers(i + 1);
                spawner.spawnEnemies();
                gameStarted = true;
              }
              else {
                //Start menu pause button actions.
                if(i == 0) { exit(); }
                else if(i == 1) { resetGame(); }
              }
            }
            else {
              //In-game pause button actions.
              if(i == 0) { gamePaused = false; }
              else if(i == 1) { resetGame(); }
            }
            audioHandler.playSFX(2);
          }
        }
      }
      text(btnLabel, width/2, btnLabelY);
    }
  }
  
  void displayPlayerUI(Player player) {
    int playerIndex = players.indexOf(player);
    String numPlayer = "P" + nf(playerIndex+1, 0);
    String score = nf(player.score, 0);
    String lifesLabel = player.lifesLabel;
    
    if(player.lifes > 0) { fill(255); }
    else { fill(255, 0, 0, 220); }
    
    //Display player ID.
    float tx = player.pHeight/2;
    textAlign(LEFT, CENTER);
    textSize(62);
    float p1IDx = tx*(1-playerIndex);
    float p2IDx = (width - tx - textWidth(numPlayer))*playerIndex;
    text(numPlayer, p1IDx + p2IDx, player.pWidth/2);
    
    //Display labels for lifes and scores.
    tx += textWidth(numPlayer);
    textSize(labelHeight);
    float p1LabelX = tx*(1-playerIndex);
    float p2LifesLabelX = (width - tx - textWidth(lifesLabel))*playerIndex;
    text(lifesLabel, p1LabelX + p2LifesLabelX, player.pWidth);
    if(isMultiplayer) {
      float p2ScoreLabelX = (width - tx - textWidth(scoreLabel))*playerIndex;
      text(scoreLabel, p1LabelX + p2ScoreLabelX, player.pWidth - labelHeight*1.25);
    }
    
    //Display scores.
    tx += textWidth(lifesLabel) + player.pWidth/4;
    if(isMultiplayer) {
      //Display individual scores.
      float p1ScoreX = (tx + player.pWidth*1.75 - textWidth(score)/2)*(1-playerIndex);
      float p2ScoreX = (width - tx - textWidth(score)/2 - player.pWidth*2)*playerIndex;
      text(score, p1ScoreX + p2ScoreX, player.pWidth - labelHeight*1.25);
    }
    else {
      totalScoreLabel = scoreLabel;
    }
    
    //Display lifes.
    for(int i = 0; i < player.lifes; i++) {
      float p1LifesX = (tx + (player.pWidth*1.25)*i)*(1-playerIndex);
      float p2LifesX = (width - tx - player.pWidth - (player.pWidth*1.5)*i)*playerIndex;
      player.drawPlayer(p1LifesX + p2LifesX, player.pWidth);
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
      fill(126);
      textAlign(CENTER, CENTER);
      textSize(labelHeight);
      text("Do You want to exit?", width/2, height/2 + labelHeight*5);
    }
  }
}
