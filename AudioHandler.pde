/*
This class stores and handles all auidio in the game (play, loop, pause and rewind).
*/

class AudioHandler {
  AudioPlayer[] audioBank;

  AudioHandler() {
    //Audioplayer array (1 audio player for each sound).
    audioBank = new AudioPlayer[13];
    //Load all sounds in to audioBank.
    audioBank[0] = minim.loadFile("theme.wav");
    audioBank[1] = minim.loadFile("button.mp3");
    audioBank[2] = minim.loadFile("enemyDeath.wav");
    audioBank[3] = audioBank[2];
    audioBank[4] = minim.loadFile("powerUp.wav");
    audioBank[5] = minim.loadFile("shield.wav");
    audioBank[6] = minim.loadFile("respawnEnemies.wav");
    audioBank[7] = minim.loadFile("weaponType0.wav");
    audioBank[8] = minim.loadFile("weaponType1.wav");
    audioBank[9] = audioBank[7];
    audioBank[10] = minim.loadFile("weaponType3.wav");
    audioBank[11] = minim.loadFile("weaponType4.mp3");
    audioBank[12] = minim.loadFile("enemyWeaponType0.wav");
    //Adjust volume of the different sounds.
    for (int i = 1; i < audioBank.length; i++) {
      audioBank[i].setGain(-18);
      if (i == 2) { 
        audioBank[i].setGain(0);
      }
    }
  }

  void manage() {
    playThemeSong();
    //Adjust sound when pausing the game.
    if (gamePaused) { 
      audioBank[0].setGain(-20);
    }
    else { 
      audioBank[0].setGain(-15);
    }
  }

  //Play theme song in a loop.
  void playThemeSong() {
    if (!audioBank[0].isPlaying()) {
      audioBank[0].rewind();
      audioBank[0].play();
    }
  }

  //playSFX is called from other classes and plays and rewinds the requested sounds accordingly.
  void playSFX(int SFXIndex) {
    if (SFXIndex < audioBank.length) {
      if (SFXIndex == 11 && audioBank[11].isPlaying()) {
        return;
      }
      else {
        audioBank[SFXIndex].rewind();
        audioBank[SFXIndex].play();
      }
    }
  }
}

