// A user-controlled frog object for the game Frogger.
// Use arrow keys to move. Avoid cars and river water.
class Frog {
  // Position Attributes
  float xpos, ypos;
  float originX, originY;

  float opacity = 255;

  // Size Attributes
  int sizeX = width/10;
  float sizeY = heightOfRow;

  // State Attributes
  boolean riverDeath;
  boolean carDeath;
  boolean alive = true;
  boolean onLog = false;
  boolean noReturn;

  int deathCount;
  int maxDeaths = 5;
  String deathReason;

  // Images
  PImage still, jumping;

  float currentRotation;


  // Constructor
  Frog(float xpos_, float ypos_) {
    xpos = xpos_-width/20;
    ypos = ypos_;

    originX = xpos;
    originY = ypos;
  }


  // Check death amount && carry out death actions
  void update() {

    float dx = width/10 - sizeX;
    sizeX += dx * 0.4;

    // Limit number of deaths
    if (deathCount >= maxDeaths && !debug) {
      if (alive) {
        // Log game lost message only once
        log(getExactTime()+" - Too many deaths on Scene "+currentScene+". Game lost.");
        
        if (score > highscore){
          highscore = score;
          scoreObj.setFloat("highscore", score);
          saveJSONObject(scoreObj, "data/highscore.json");
        }
      }
      alive = false;
      score = 0;
    } else if (carDeath || !onLog && riverDeath && moveRight(30)) {
      // Record death
      deathCount += 1;
      log(getExactTime()+" - Death occurred. Reason: "+deathReason+". Total deaths: "+deathCount);

      // Reset Frog object
      carDeath = false;
      riverDeath = false;

      if (debug) {
        log("Debug mode is enabled. Ignoring death.");
      } else {
        score /= 2;

        if (deathReason == "river") {
          addNotification("Oh no! You got washed down the river!", 100, color(0, 0, 200, 150));

          if (soundSetting == 0) {
            riverDeathSound.play();
            riverDeathSound.rewind();
          }
        } else if (deathReason == "car") {
          addNotification("Whoops! You forgot to look both ways!", 100, color(200, 0, 0, 150));
          if (soundSetting == 0) {
            carDeathSound.play();
            carDeathSound.rewind();
          }
        }

        if (deathCount < maxDeaths) {
          xpos = originX;
          ypos = originY;
          noReturn = false;
          onLog = false;
        }
      }
    }
  }


  // Show frog
  void display() {
    if (still != null) {
      pushStyle();
      pushMatrix();
      tint(255, opacity);
      translate(xpos+sizeX/2, ypos+sizeY/2);
      rotate(currentRotation);
      image(still, -sizeX/2, -sizeY/2, sizeX, sizeY);
      popMatrix();
      popStyle();
    }
  }


  // Add images to frog (Can be used to have differently colored/designed frogs for each level)
  void setImages(PImage still_, PImage jumping_) {
    still = still_;
    jumping = jumping_;
  }


  // Vertical movement
  void moveUp() {
    currentRotation = 0;
    sizeX = width/8;

    ypos-=heightOfRow;

    if (ypos < 0) {
      ypos = 0;
    }
  }

  void moveDown() {
    currentRotation = PI;

    sizeX = width/8;

    ypos+=heightOfRow;

    if (ypos > height-heightOfRow) {
      ypos = height-heightOfRow;
    }
  }


  // Horizontal movement
  void moveLeft() {
    currentRotation = 3*PI/2;
    sizeX = width/8;

    xpos-=width/10;

    if (xpos < -width/20) {
      xpos = -width/20;
    }
  }

  void moveRight() {
    currentRotation = PI/2;
    sizeX = width/8;

    xpos+=width/10;

    if (xpos > width-width/20) {
      xpos = width-width/20;
    }
  }


  // Used only when a river death is ongoing. Returns true once Frogger flows off the screen.
  boolean moveRight(float amount) {
    if (!debug) {
      xpos+=amount;
    }

    if (riverDeath) {
      noReturn = true;
    }

    if (xpos > width) {
      return true;
    } else {
      return false;
    }
  }


  // Checks life status of Frog object
  boolean alive() {
    return alive;
  }


  // Checks changing life status of Frog object
  boolean isNotDying() {
    return !(riverDeath || carDeath);
  }


  // Initiate death of Frog object
  void die(String reason) {
    if (reason == "river") {
      riverDeath = true;
    } else if (reason == "car") {
      carDeath = true;
    }

    deathReason = reason;
  }
}