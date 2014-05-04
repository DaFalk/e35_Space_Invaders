class AudioHandler {
  AudioPlayer[] audioBank;
  
  AudioHandler() {
    audioBank = new AudioPlayer[11];
    audioBank[0] = minim.loadFile("theme.mp3");
    audioBank[1] = minim.loadFile("button.mp3");
    audioBank[2] = minim.loadFile("powerUp.wav");
    audioBank[3] = minim.loadFile("shield.wav");
    audioBank[4] = minim.loadFile("respawn.wav");
    audioBank[5] = minim.loadFile("weaponType0.wav");
    audioBank[6] = minim.loadFile("weaponType1.wav");
    audioBank[7] = audioBank[5];
    audioBank[8] = minim.loadFile("weaponType3.mp3");
    audioBank[9] = minim.loadFile("weaponType4.mp3");
    audioBank[10] = minim.loadFile("enemyWeaponType0.wav");
    for(int i = 1; i < audioBank.length; i++) {
      audioBank[i].setGain(-18);
    }
  }
  
  void manage() {
    if(gamePaused) { audioBank[0].setGain(-20); }
    else { audioBank[0].setGain(-15); }
    playThemeSong();
  }
  
  void playThemeSong() {
    if(!audioBank[0].isPlaying()) {
      audioBank[0].rewind();
      audioBank[0].play();
    }
  }
  
  void playSFX(int SFXIndex) {
    if(SFXIndex < audioBank.length) {
      if(SFXIndex == 9 && audioBank[9].isPlaying()) {
        return;
      }
      else {
        audioBank[SFXIndex].rewind();
        audioBank[SFXIndex].play();
      }
    }
  }
}
