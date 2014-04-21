class Menu {
  int textHeight = 20;
  
  Menu() {
  }
  
  void display() {
    textAlign(CENTER, TOP);
    fill(0, 255, 0);
    textSize(54);
    text("SPACE INVADERS", width/2, 0);
    
    textAlign(CENTER, CENTER);
    for(int i = 0; i < 2; i++) {
      String btnText;
      if(i == 0) { btnText = "Singleplayer"; }
      else { btnText = "Multiplayer"; }
      
      fill(126, 126, 126);
      textSize(textHeight);
      if(mouseY < height/2 + textHeight/2 + ((textHeight*2)*i) && mouseY > height/2 - textHeight/2 + ((textHeight*2)*i)) {
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
      text(btnText, width/2, height/2 + ((textHeight*2)*i));
    }
  }
  
  void spawnPlayers(int numPlayers) {
    if(numPlayers >= 1 && numPlayers <= 2) {
      player1 = new Player(width/2);
    }
    if(numPlayers == 2) {
      player2 = new Player(width/3);
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
