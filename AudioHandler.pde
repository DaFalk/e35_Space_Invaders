class AudioHandler {
  AudioPlayer[] audioBank;
  
  AudioHandler() {
    audioBank = new AudioPlayer[7];
    audioBank[0] = minim.loadFile("theme.mp3");
    audioBank[1] = minim.loadFile("button.mp3");
    audioBank[2] = minim.loadFile("weaponType0.wav");
    audioBank[3] = minim.loadFile("weaponType1.wav");
    audioBank[4] = audioBank[2];
    audioBank[5] = audioBank[2];
    audioBank[6] = minim.loadFile("weaponType2.mp3");
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
      audioBank[SFXIndex].rewind();
      audioBank[SFXIndex].play();
    }
  }
}
