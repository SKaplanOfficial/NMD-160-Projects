//*****************************//
//       FROG MANAGEMENT       //
//*****************************//

// A user-controlled frog object for the game Frogger.
// Use arrow keys to move. Avoid cars and river water.
class Frog {
  // Position Attributes
  float xpos, ypos;
  float originX, originY;
  float currentRotation;

  // Size Attributes
  int sizeX = width/10;
  float sizeY = heightOfRow;

  // State Attributes
  boolean riverDeath;
  boolean carDeath;
  boolean lethalDeath;

  boolean alive = true;
  boolean onLog = false;
  boolean noReturn;

  int deathCount;
  int maxDeaths = 5;
  String deathReason;

  // Images
  PImage still;


  //***CONSTRUCTOR***//

  Frog(float xpos_, float ypos_) {
    xpos = xpos_-width/20;
    ypos = ypos_;

    originX = xpos;
    originY = ypos;
  }


  //***UPDATE METHOD***//

  // Check death amount && carry out death actions
  void update() {

    // Ease sizeX to width/10 -- Creates "jump" effect
    float dx = width/10 - sizeX;
    sizeX += dx * 0.4;

    // Limit number of deaths
    if (deathCount >= maxDeaths && !debug) {  // maxDeaths reached - Losing

      // Done once upon death
      if (alive) {
        // Log game lost message
        log(getExactTime()+" - Too many deaths on Scene "+currentScene+". Game lost.");

        // Remove notification buildup
        clearAllNotifications();

        // Compare, set, and save high score
        if (score > highscore) {
          highscore = score;
          scoreObj.setFloat("highscore", score);
          saveJSONObject(scoreObj, "data/highscore.json");
        }
      }

      // Called contuiously after death (To ensure correct course of events)
      // Kill frog and set score back to zero
      alive = false;
      score = 0;
    } else if (lethalDeath || carDeath || !onLog && riverDeath && moveRight(30)) {  // maxDeaths not yet reached

      // Record death
      deathCount += 1;
      log(getExactTime()+" - Death occurred. Reason: "+deathReason+". Total deaths: "+deathCount);

      // Reset Frog object
      carDeath = false;
      riverDeath = false;
      lethalDeath = false;

      if (debug) {
        log("Debug mode is enabled. Ignoring death.");
      } else {
        // Decrease score
        score /= 2;

        // Display notifications & play sounds relevent to the type of death
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
        } else if (deathReason == "lethalSpot") {
          addNotification("Look's like you can't jump there...", 100, color(200, 100, 0, 150));

          if (soundSetting == 0) {
            carDeathSound.play();
            carDeathSound.rewind();
          }
        }

        // Reset position & state of frog
        if (deathCount < maxDeaths) {
          xpos = originX;
          ypos = originY;
          noReturn = false;
          onLog = false;
        }
      }
    }

    if (currentScene != scenes.size()) {
      boolean checkSafe = scenes.get(currentScene).checkSafe();
      if (ypos == 0 && !checkSafe) {
        this.die("lethalSpot");
      }
    }
  }


  //***DISPLAY METHOD***//

  // Show frog
  void display() {
    if (still != null) {  // Make sure frog image is present
      pushMatrix();
      translate(xpos+sizeX/2, ypos+sizeY/2);

      // 0 = UP, PI/2 = RIGHT, PI = DOWN, 3*PI/2 = LEFT
      rotate(currentRotation);

      image(still, -sizeX/2, -sizeY/2, sizeX, sizeY);
      popMatrix();
    } else {              // Default "frog" in case no image is provided
      pushMatrix();
      translate(xpos+sizeX/2, ypos+sizeY/2);

      // 0 = UP, PI/2 = RIGHT, PI = DOWN, 3*PI/2 = LEFT
      rotate(currentRotation);

      // Body
      fill(0, 200, 0);
      ellipse(0, 0, sizeX/2, sizeY/2);

      // Eyes
      fill(255);
      ellipse(-sizeX/6, -sizeY/5, 18, 18);
      ellipse(sizeX/6, -sizeY/5, 18, 18);

      fill(0);
      ellipse(-sizeX/6, -sizeY/5, 8, 8);
      ellipse(sizeX/6, -sizeY/5, 8, 8);
      popMatrix();
    }
  }


  // Add image to frog (Can be used to have differently colored/designed frogs for each level)
  void setImages(PImage still_) {
    still = still_;
  }


  //***MOVEMENT***//

  // Vertical movement
  void moveUp() {
    currentRotation = 0;

    // Increase sizeX (Jump effect)
    sizeX = width/8;

    ypos-=heightOfRow;

    // Check boundary
    if (ypos < 0) {
      ypos = 0;
    }
  }

  void moveDown() {
    currentRotation = PI;

    // Increase sizeX (Jump effect)
    sizeX = width/8;

    ypos+=heightOfRow;

    // Check boundary
    if (ypos > height-heightOfRow) {
      ypos = height-heightOfRow;
    }
  }


  // Horizontal movement
  void moveLeft() {
    currentRotation = 3*PI/2;

    // Increase sizeX (Jump effect)
    sizeX = width/8;

    xpos-=width/10;

    // Check boundary
    if (xpos < -width/20) {
      xpos = -width/20;
    }
  }

  void moveRight() {
    currentRotation = PI/2;

    // Increase sizeX (Jump effect)
    sizeX = width/8;

    xpos+=width/10;

    // Check boundary
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


  //***STATE MANAGEMENT***//

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
    } else if (reason == "lethalSpot") {
      lethalDeath = true;
    }

    deathReason = reason;
  }
}