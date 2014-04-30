class AudioHandler {
  AudioPlayer[] audioBank;
  
  AudioHandler() {
    audioBank = new AudioPlayer[3];
    audioBank[0] = minim.loadFile("theme.mp3");
    audioBank[1] = minim.loadFile("playerShot.wav");
    audioBank[2] = minim.loadFile("button.mp3");
    audioBank[1].setGain(-10);
    audioBank[2].setGain(-10);
  }
  
  void manage() {
    if(gamePaused) { audioBank[0].setGain(-15); }
    else { audioBank[0].setGain(-10); }
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
