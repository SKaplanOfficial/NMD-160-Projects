// A class that manages and displays a river row in the game Frogger.
class River {
  // Position Attributes
  float ypos;

  // Log Management
  int numLogs;
  float laneSpeed;
  ArrayList<Log> logs = new ArrayList<Log>();

  // Lily pad Management
  int numLilyPads;
  ArrayList<LilyPad> lilyPads = new ArrayList<LilyPad>();

  // River Particles
  float particleAmount = map(height, 500, 800, 1000, 500)/performanceModifier;
  ArrayList<RiverParticle> particles = new ArrayList<RiverParticle>();


  // Constructor
  River(float ypos_, int numLogs_) {
    ypos = ypos_;

    if (numLogs_ >= 0) {
      numLogs = numLogs_;
      numLilyPads = 0;
    } else {
      numLogs = 0;
      numLilyPads = abs(numLogs_);
    }
    laneSpeed = random(3, 8);

    // Populate river with particles
    for (int i=0; i<particleAmount; i++) {
      particles.add(new RiverParticle(random(width), ypos));
    }

    for (int i=0; i<numLogs; i++) {
      logs.add(new Log(numLogs, ypos, logs.size(), laneSpeed));
    }

    for (int i=0; i<numLilyPads; i++) {
      lilyPads.add(new LilyPad(numLilyPads, ypos, lilyPads.size(), laneSpeed));
    }
  }


  // To be used for log collision detect later on
  void update() {
    checkCollision();

    Frog frog = scenes.get(currentScene).frogger;
    if (frog.ypos == ypos) {
      if (!riverSound.isPlaying() && musicSetting == 0) {
        riverSound.rewind();
        riverSound.play();
      }
    }
  }


  // Check direct collision with Frog object
  void checkCollision() {
    // Initiate death of Frog object
    Frog frog = scenes.get(currentScene).frogger;
    if (frog.ypos == ypos) {
      frog.die("river");
    }
  }


  // Display the river row and all river particles within it
  void display() {
    // Blue row background
    noStroke();
    fill(0, 0, 255);
    rect(0, ypos, width, heightOfRow);

    for (int i=0; i<particles.size(); i++) {
      Frog frog = scenes.get(currentScene).frogger;

      // Move river particles if frog is alive
      if (frog.alive()) {
        particles.get(i).update();
      }
      particles.get(i).display();
    }
  }

  // Displays all log objects that belong to this row of river
  void displayLogs() {
    for (int i=0; i<logs.size(); i++) {
      logs.get(i).display();
    }

    for (int i=0; i<lilyPads.size(); i++) {
      lilyPads.get(i).display();
    }
  }


  // Updates/moves logs if frogger is alive
  void updateLogs() {
    for (int i=0; i<logs.size(); i++) {
      logs.get(i).update();
    }

    for (int i=0; i<lilyPads.size(); i++) {
      lilyPads.get(i).update();
    }
  }

  void setImage(PImage logImage, PImage lilyPadImage) {
    for (int i=0; i<logs.size(); i++) {
      logs.get(i).setImage(logImage);
    }

    for (int i=0; i<lilyPads.size(); i++) {
      lilyPads.get(i).setImage(lilyPadImage);
    }
  }
}


// A class that defines river particles that move fluidly and add depth to the game
class RiverParticle {
  // Position and Size Attributes
  float xpos, ypos;
  float originX, originY;

  // Unique Movement Attribute
  float sinMod;


  // Constructor
  RiverParticle(float xpos_, float ypos_) {
    xpos = xpos_;
    ypos = ypos_;

    originX = xpos;
    originY = ypos;

    sinMod = random(1, 30);
  }


  // Move particle in accordance with sin function, offset with unique sinMod attribute
  void update() {
    if (xpos > width) {
      xpos = -sinMod/2+noise(ypos)*2;
    }

    xpos += 1;
    ypos = originY+(heightOfRow/2)+sin((xpos+sinMod*50)/30)*(heightOfRow/2.2);
  }


  // Display the particle
  void display() {
    stroke(0, 50+sinMod*5, 100+sinMod*10, sinMod*20);
    strokeWeight(noise(ypos)*3);
    line(xpos-noise(ypos)*2, ypos, xpos+sinMod/2+noise(ypos)*2, ypos);
  }
}



// A class that manages and displays logs belonging to rivers rows in the game Frogger.
class Log {
  // Location & relation to cars array
  int id;
  int numLogs;

  // Position and Size Attributes
  float xpos, ypos;
  float sizeX, sizeY;

  float maxSizeX = 5;
  float maxSizeY = heightOfRow;

  float minSizeX = 1;
  float minSizeY = heightOfRow/2;

  // Collision Attributes
  boolean isCounted = false;
  int collisionCount = 0;
  boolean onScreen_Carrying = true;

  PImage logImage;

  // Movement Attributes
  float speedX;

  // Constructor
  Log(int numLogs_, float ypos_, int id_, float speedX_) {
    numLogs = numLogs_;
    id = id_;

    ypos = ypos_+(heightOfRow/2);

    xpos = -300*id;

    sizeX = int(random(minSizeX, maxSizeX))*width/10;
    sizeY = random(minSizeY, maxSizeY);

    speedX = speedX_;
  }


  // Checks for collision with Frog object
  void checkCollision() {
    Frog frog = scenes.get(currentScene).frogger;
    boolean foundCollision = false;

    float lx = xpos-sizeX/2;
    float rx = xpos+sizeX/2;
    float ty = ypos-heightOfRow/2;
    float by = ypos+heightOfRow/2;

    float ulx = frog.xpos+20;
    float urx = frog.xpos+frog.sizeX-20;
    float uty = frog.ypos;
    float uby = frog.ypos+frog.sizeY;

    if (ulx >= lx-frog.sizeX/3 && urx <= rx+frog.sizeX/3 && uty >= ty && uby <= by) {
      strokeWeight(3);
      stroke(0);
      if (debug) {
        // Display collision lines if debug mode is on
        line(0, ty, width, ty);
        line(0, uty, width, uty);

        line(0, by, width, by);
        line(0, uby, width, uby);

        line(lx, 0, lx, height);
        line(ulx, 0, ulx, height);

        line(rx, 0, rx, height);
        line(urx, 0, urx, height);
      }
      noStroke();
      foundCollision = true;
    }

    // Initiate death of frog object, count as collision, only if a collision is detected
    if (foundCollision && onScreen_Carrying && !frog.noReturn) {
      if (!isCounted) {
        isCounted = true;
      }

      frog.riverDeath = false;
      frog.onLog = true;
      frog.moveRight(speedX);

      if (frog.xpos > width) {
        onScreen_Carrying = false;
      }
    } else {
      frog.onLog = false;
      isCounted = false;
    }
  }


  // Move log object
  void update() {
    Frog frog = scenes.get(currentScene).frogger;
    // Move in direction specified in json
    xpos += speedX;

    // If the car goes out of bounds, reset on opposit side
    // Larger bounds than usual to add variation in current screen content over course of the game
    if (xpos > width*2) {
      xpos = -width;
    }
  }


  // Display log object
  void display() {
    checkCollision();

    pushStyle();

    if (logImage == null) {
      // If no log image is provided, resort to brown rectangles
      rectMode(CENTER);
      fill(139, 69, 19);
      rect(xpos, ypos, sizeX, sizeY);
    } else {
      image(logImage, xpos-sizeX/2, ypos-sizeY, sizeX, sizeY*2);
    }

    popStyle();
  }

  void setImage(PImage logImage_) {
    logImage = logImage_;
  }
}


// A class that manages and displays lily pads belonging to rivers rows in the game Frogger.
class LilyPad {
  // Location & relation to cars array
  int id;
  int numLilyPads;

  int ranMod;

  // Position and Size Attributes
  float xpos, ypos;
  float sizeX, sizeY;

  // Collision Attributes
  boolean isCounted = false;
  int collisionCount = 0;
  boolean onScreen_Carrying = true;

  PImage lilyPadImage;

  // Movement Attributes
  float speedX;

  // Constructor
  LilyPad(int numLogs_, float ypos_, int id_, float speedX_) {
    numLilyPads = numLogs_;
    id = id_+1;

    ypos = ypos_+(heightOfRow/2);

    ranMod = int(random(3, 6));

    if (id%ranMod != 3) {
      xpos = width/20 * id;
    } else {
      xpos = width + width/20 * id;
    }

    sizeX = width/20;
    sizeY = heightOfRow/2+random(-5, 0);

    speedX = -speedX_;
  }


  // Checks for collision with Frog object
  void checkCollision() {
    Frog frog = scenes.get(currentScene).frogger;
    boolean foundCollision = false;

    float lx = xpos-sizeX/2;
    float rx = xpos+sizeX/2;
    float ty = ypos-heightOfRow/2;
    float by = ypos+heightOfRow/2;

    float ulx = frog.xpos+20;
    float urx = frog.xpos+frog.sizeX-20;
    float uty = frog.ypos;
    float uby = frog.ypos+frog.sizeY;

    if (ulx >= lx-frog.sizeX/3 && urx <= rx+frog.sizeX/3 && uty >= ty && uby <= by) {
      strokeWeight(3);
      stroke(0);
      if (debug) {
        // Display collision lines if debug mode is on
        line(0, ty, width, ty);
        line(0, uty, width, uty);

        line(0, by, width, by);
        line(0, uby, width, uby);

        line(lx, 0, lx, height);
        line(ulx, 0, ulx, height);

        line(rx, 0, rx, height);
        line(urx, 0, urx, height);
      }
      noStroke();
      foundCollision = true;
    }

    // Initiate death of frog object, count as collision, only if a collision is detected
    if (foundCollision && onScreen_Carrying && !frog.noReturn) {
      if (!isCounted) {
        isCounted = true;
      }

      frog.riverDeath = false;
      frog.onLog = true;
      frog.moveRight(speedX);

      if (frog.xpos < -frog.sizeX/2) {
        onScreen_Carrying = false;
      }
    } else {
      frog.onLog = false;
      isCounted = false;
    }
  }


  // Move log object
  void update() {
    Frog frog = scenes.get(currentScene).frogger;
    // Move in direction specified in json
    xpos += speedX;

    // If the car goes out of bounds, reset on opposit side
    // Larger bounds than usual to add variation in current screen content over course of the game
    if (xpos < -(width + width/20 * numLilyPads)) {
        xpos = width+100;
    }
  }


  // Display log object
  void display() {
    checkCollision();

    pushStyle();

    if (lilyPadImage == null) {
      // If no log image is provided, resort to brown rectangles
      rectMode(CENTER);
      fill(139, 69, 19);
      rect(xpos, ypos, sizeX, sizeY);
    } else {
      pushMatrix();
      translate(xpos, ypos);
      rotate(sizeY/5);
      image(lilyPadImage, -sizeX/2, -sizeY, sizeX, sizeY*2);
      popMatrix();
    }

    popStyle();
  }

  void setImage(PImage lilyPadImage_) {
    lilyPadImage = lilyPadImage_;
  }
}