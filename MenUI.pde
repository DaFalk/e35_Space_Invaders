class MenUI {
  String title = "SPACE INVADERS";
  int titleSize = 74;
  String scoreLabel = "SCORE";
  String totalScoreLabel = "TOTAL SCORE";
  int labelHeight = 20;
  int totalScore = 0;
  float btnY = height/2 + height/4;
  int lastTick = 0;
  int nextTick = 2000;
  
  MenUI() {
  }
  
  void displayStartMenu() {
    displayTitle();
    displayBtns();
  }
  
  void displayTitle() {
    //Add flicker effect to title.
    fill(0, 255, 0);
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
  
  void displayBtns() {
    textAlign(CENTER, CENTER);
    for(int i = 0; i < 2; i++) {
      String btnLabel;
      float btnLabelY = btnY + (labelHeight*2)*i;
      
      if(i == 0) { btnLabel = "Singleplayer"; }
      else { btnLabel = "Multiplayer"; }
      
      fill(126, 126, 126);
      textSize(labelHeight);
      if(mouseY < btnLabelY + labelHeight/2 && mouseY > btnLabelY - labelHeight/2) {
        if(mouseX < width/2 + textWidth(btnLabel)/2 && mouseX > width/2 - textWidth(btnLabel)/2) {
          fill(0, 255, 0);
          textSize(labelHeight*1.1);
          if(mousePressed && mouseButton == LEFT) {
            if(i == 1) { isMultiplayer = true; }
            spawner.spawnPlayers(i + 1);
            spawner.spawnEnemies(20);
            gameStarted = true;
          }
        }
      }
      text(btnLabel, width/2, btnLabelY);
    }
  }
  
  void displayUI(Player player) {
    int playerIndex = players.indexOf(player);
    String numPlayer = "P" + nf(playerIndex+1, 0);
    String score = nf(player.score, 0);
    String lifesLabel = player.lifesLabel;
    float labelWidth;
    
    if(player.lifes > 0) { fill(255); }
    else { fill(255, 0, 0, 220); }
    
    //Display player id.
    float tx = player.pHeight/2;
    textAlign(LEFT, CENTER);
    textSize(62);
    text(numPlayer, tx*(1-playerIndex) + (width - tx - textWidth(numPlayer))*playerIndex, player.pWidth/2);
    
    //Display labels for lifes and scores.
    tx += textWidth(numPlayer);
    textSize(labelHeight);
    text(lifesLabel, tx*(1-playerIndex) + (width - tx - textWidth(lifesLabel))*playerIndex, player.pWidth);
    text(scoreLabel, tx*(1-playerIndex) + (width - tx - textWidth(scoreLabel))*playerIndex, player.pWidth - labelHeight*1.25);
    
    //Display lifes and scores.
    tx += textWidth(lifesLabel) + player.pWidth/4;
    text(score, (tx + player.pWidth*1.75 - textWidth(score)/2)*(1-playerIndex) + (width - tx - textWidth(score)/2 - player.pWidth*2)*playerIndex, player.pWidth - labelHeight*1.25);
    for(int i = 0; i < player.lifes; i++) {
      player.drawPlayer((tx + (player.pWidth*1.25)*i)*(1-playerIndex) + (width - tx - player.pWidth - (player.pWidth*1.5)*i)*playerIndex, player.pWidth);
    }
  }

  void displayTotalScore() {
    if(!isMultiplayer) {
      totalScoreLabel = scoreLabel;
    }
    fill(255);
    textAlign(CENTER, TOP);
    textSize(labelHeight/1.5);
    text(totalScoreLabel, width/2, 0);
    textSize(42);
    text(nf(totalScore, 0), width/2, labelHeight/2);
  }

  void playThemeSong() {
    if(!audio[0].isPlaying()) {
      audio[0].rewind();
      audio[0].play();
    }
  }
}
