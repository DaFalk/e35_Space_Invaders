class AudioHandler {
  AudioPlayer[] audioBank;
  
  AudioHandler() {
    audioBank = new AudioPlayer[13];
    audioBank[0] = minim.loadFile("theme.mp3");
    audioBank[1] = minim.loadFile("button.mp3");
    audioBank[2] = minim.loadFile("enemyDeath.wav");
    audioBank[3] = audioBank[2];
    audioBank[4] = minim.loadFile("powerUp.wav");
    audioBank[5] = minim.loadFile("shield.wav");
    audioBank[6] = minim.loadFile("respawnEnemies.wav");
    audioBank[7] = minim.loadFile("weaponType0.wav");
    audioBank[8] = minim.loadFile("weaponType1.wav");
    audioBank[9] = audioBank[7];
    audioBank[10] = minim.loadFile("weaponType3.mp3");
    audioBank[11] = minim.loadFile("weaponType4.mp3");
    audioBank[12] = minim.loadFile("enemyWeaponType0.wav");
    for(int i = 1; i < audioBank.length; i++) {
      audioBank[i].setGain(-18);
      if(i == 2) { audioBank[i].setGain(0); }
    }
  }
  
  void manage() {
    playThemeSong();
    if(gamePaused) { audioBank[0].setGain(-20); }
    else { audioBank[0].setGain(-15); }
  }
  
  void playThemeSong() {
    if(!audioBank[0].isPlaying()) {
      audioBank[0].rewind();
      audioBank[0].play();
    }
  }
  
  void playSFX(int SFXIndex) {
    if(SFXIndex < audioBank.length) {
      if(SFXIndex == 11 && audioBank[11].isPlaying()) {
        return;
      }
      else {
        audioBank[SFXIndex].rewind();
        audioBank[SFXIndex].play();
      }
    }
  }
}
