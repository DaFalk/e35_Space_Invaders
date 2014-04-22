class Menu {
  String title = "SPACE INVADERS";
  int textHeight = 20;
  float btnY = height/2 + height/4;
  int lastTick = 0;
  int nextTick = 2000;
  
  Menu() {
  }
  
  void display() {
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
            spawnEnemies();
            gameStarted = true;
          }
        }
      }
      text(btnText, width/2, btnY + (textHeight*2)*i);
    }
  }
  
  void spawnPlayers(int numPlayers) {
    for(int i = 0; i < numPlayers; i++) {
      players.add(new Player(width/(2+i) - ((width/2 - width/3)*(numPlayers-1))*(1-i) + (width/(2+i))*i));
    }
  }

  void spawnEnemies() {
    for(int i = 0; i < stackSize / 5; i++) {
      for(int j = 0; j < stackSize / 10; j++) {
        enemies.add(new Enemy(i, j));
      }
    }
  }
}
