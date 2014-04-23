int textHeight = 20;

class MenUI {
  String title = "SPACE INVADERS";
  String scoreText = "SCORE";
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
    fill(0, 255, 0);
    if(millis() >= lastTick + nextTick) {
      fill(0, 255, 0, random(50, 255));
      if(millis() >= lastTick + nextTick + 500) {
        lastTick = millis();
        nextTick = (int)random(3000, 10000);
      }
    }
    textAlign(CENTER, TOP);
    textSize(74);
    text(title, width/2, width/2 - textWidth(title)/1.75);
  }
  
  void displayBtns() {
    textAlign(CENTER, CENTER);
    for(int i = 0; i < 2; i++) {
      String btnText;
      if(i == 0) { btnText = "Singleplayer"; }
      else { btnText = "Multiplayer"; }
      
      fill(126, 126, 126);
      textSize(textHeight);
      if(mouseY < btnY + textHeight/2 + ((textHeight*2)*i) && mouseY > btnY - textHeight/2 + ((textHeight*2)*i)) {
        if(mouseX < width/2 + textWidth(btnText)/2 && mouseX > width/2 - textWidth(btnText)/2) {
          fill(0, 255, 0);
          textSize(textHeight*1.1);
          if(mousePressed && mouseButton == LEFT) {
            spawnPlayers(i + 1);
            if(i == 1) {
              isMultiplayer = true;
            }
            spawnEnemies(20);
            gameStarted = true;
          }
        }
      }
      text(btnText, width/2, btnY + (textHeight*2)*i);
    }
  }
  
  void displayLifes(Player player) {
    int playerIndex = players.indexOf(player);
    String numPlayer = "P" + nf(playerIndex+1, 0);
    String pts = nf(player.score, 0);
    
    if(player.lifes > 0) { fill(255); }
    else { fill(255, 0, 0, 220); }
    
    float tx = player.pHeight/2;
    textAlign(LEFT, CENTER);
    textSize(62);
    text(numPlayer, tx*(1-playerIndex) + (width - tx - textWidth(numPlayer))*playerIndex, player.pWidth/2);
    tx += textWidth(numPlayer);
    textSize(textHeight);
    text(player.pLifes, tx*(1-playerIndex) + (width - tx - textWidth(player.pLifes))*playerIndex, player.pWidth);
    text(scoreText, tx*(1-playerIndex) + (width - tx - textWidth(scoreText))*playerIndex, player.pWidth - textHeight*1.25);
    tx += textWidth(player.pLifes) + player.pWidth/4;
    text(pts, (tx + player.pWidth*1.75 - textWidth(pts)/2)*(1-playerIndex) + (width - tx - textWidth(pts)/2 - player.pWidth*2)*playerIndex, player.pWidth - textHeight*1.25);
    for(int i = 0; i < player.lifes; i++) {
      player.drawPlayer((tx + (player.pWidth*1.25)*i)*(1-playerIndex) + (width - tx - player.pWidth - (player.pWidth*1.5)*i)*playerIndex, player.pWidth);
    }
  }

  void displayTotalScore() {
    textAlign(CENTER, TOP);
    textSize(textHeight/1.5);
    text("TOTAL SCORE", width/2, 0);
    textSize(42);
    fill(255);
    text(nf(totalScore, 0), width/2, textHeight/2);
  }

  void playThemeSong() {
    if(!audio[0].isPlaying()) {
      audio[0].rewind();
      audio[0].play();
    }
  }
  
  void spawnPlayers(int numPlayers) {
    for(int i = 0; i < numPlayers; i++) {
      players.add(new Player(width/(2+i) - ((width/2 - width/3)*(numPlayers-1))*(1-i) + (width/(2+i))*i));
    }
  }

  void spawnEnemies(int eSize) {
    int enemyRows = 9;
    int enemyCols = 5;
    for(int i = 0; i < enemyCols; i++) {
      for(int j = 0; j < enemyRows; j++) {
        enemies.add(new Enemy(j, i));
      }
    }
  }
}
