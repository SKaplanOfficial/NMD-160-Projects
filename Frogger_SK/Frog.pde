// A user-controlled frog object for the game Frogger.
// Use arrow keys to move. Avoid cars and river water.
class Frog {
  // Position Attributes
  float xpos, ypos;
  float originX, originY;

  // Size Attributes
  int sizeX = width/10;
  float sizeY = heightOfRow;

  // State Attributes
  boolean riverDeath;
  boolean carDeath;
  boolean alive = true;

  int deathCount;
  int maxDeaths = 5;
  String deathReason;

  // Images
  PImage still, jumping;


  // Constructor
  Frog(float xpos_, float ypos_) {
    xpos = xpos_-width/20;
    ypos = ypos_;

    originX = xpos;
    originY = ypos;
  }


  // Check death amount && carry out death actions
  void update() {
    // Limit number of deaths
    if (deathCount >= maxDeaths && !debug) {
      if (alive) {
        // Log game lost message only once
        log(getExactTime()+" - Too many deaths on Scene "+currentScene+". Game lost.");
      }
      alive = false;
    } else if (carDeath || riverDeath && moveRight(20)) {
      // Record death
      deathCount += 1;
      log(getExactTime()+" - Death occurred. Reason: "+deathReason+". Total deaths: "+deathCount);

      // Reset Frog object
      carDeath = false;
      riverDeath = false;

      if (debug) {
        log("Debug mode is enabled. Ignoring death.");
      } else {
        if (deathReason == "river"){
          addNotification("Oh no! You got washed down the river!", 100);
        }else if (deathReason == "car"){
          addNotification("Whoops! You forgot to look both ways!", 100);
        }
        
        if (deathCount < maxDeaths) {
          xpos = originX;
          ypos = originY;
        }
      }
    }
  }


  // Show frog
  void display() {
    if (still != null) {
      image(still, xpos, ypos, sizeX, sizeY);
    }
  }


  // Add images to frog (Can be used to have differently colored/designed frogs for each level)
  void setImages(PImage still_, PImage jumping_) {
    still = still_;
    jumping = jumping_;
  }


  // Vertical movement
  void moveUp() {
    ypos-=heightOfRow;

    if (ypos < 0) {
      ypos = 0;
    }
  }

  void moveDown() {
    ypos+=heightOfRow;

    if (ypos > height-heightOfRow) {
      ypos = height-heightOfRow;
    }
  }


  // Horizontal movement
  void moveLeft() {
    xpos-=width/10;

    if (xpos < 0) {
      xpos = 0;
    }
  }

  void moveRight() {
    xpos+=width/10;

    if (xpos > width) {
      xpos = width;
    }
  }


  // Used only when a river death is ongoing. Returns true once Frogger flows off the screen.
  boolean moveRight(int amount) {
    if (!debug){
      xpos+=amount;
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