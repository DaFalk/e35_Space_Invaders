class AudioHandler {
  AudioPlayer[] audioBank;
  
  AudioHandler() {
    audioBank = new AudioPlayer[5];
    audioBank[0] = minim.loadFile("theme.mp3");
    audioBank[1] = minim.loadFile("button.mp3");
    audioBank[2] = minim.loadFile("weaponType0.wav");
    audioBank[3] = minim.loadFile("weaponType1.wav");
    audioBank[4] = minim.loadFile("weaponType2.mp3");
    audioBank[1].setGain(-18);
    audioBank[2].setGain(-18);
    audioBank[3].setGain(-18);
    audioBank[4].setGain(-18);
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
    audioBank[SFXIndex].rewind();
    audioBank[SFXIndex].play();
  }
}
