// A class that manages and displays a road row in the game Frogger.
class Road {
  // Position Attributes
  float ypos;

  // Variation Attributes
  int showWhiteLine, showYellowLines;

  // Images
  PImage roadImage;

  // Car Management
  int numCars;
  int carDirection;
  float laneSpeed;
  ArrayList<Car> cars = new ArrayList<Car>();


  // Constructor
  Road(float ypos_, int whiteLine, int yellowLines, int numCars_, int carDirection_) {
    ypos = ypos_;

    showWhiteLine = whiteLine;
    showYellowLines = yellowLines;

    numCars = numCars_;
    carDirection = carDirection_;

    // Each row of road has different base speed
    laneSpeed = random(5, 10);

    // Add appropriate number of cars based on json data
    for (int i=0; i<numCars; i++) {
      cars.add(new Car(numCars, ypos, cars.size(), carDirection, laneSpeed));
    }
  }


  // Currently unused, but kept for easy access later
  void update() {
    Frog frog = scenes.get(currentScene).frogger;
    if (frog.ypos == ypos) {
      if (!roadSound.isPlaying() && musicSetting == 0) {
        roadSound.rewind();
        roadSound.play();
      }
    }
  }


  // Displays the road (NOT the cars)
  void display() {
    noStroke();

    // If no road image is provided, resort to gray rectangles
    if (roadImage == null) {
      fill(20);
      rect(0, ypos, width, heightOfRow);
    } else {
      // Otherwise, use math to provide optimal tiling of image along the row
      float ratio = roadImage.height/heightOfRow;
      for (int x=0; x<width; x += roadImage.width/ratio) {
        image(roadImage, x, ypos, roadImage.width/ratio, heightOfRow);
      }
    }

    // Add white lines to top or bottom of row according to json data
    if (showWhiteLine == 1) {
      noStroke();
      fill(255);
      rect(0, ypos+5, width, 5);
    } else if (showWhiteLine == 2) {
      noStroke();
      fill(255);
      rect(0, ypos+height/12-10, width, 5);
    }

    // Add yellows lines to middle of row according to json data
    if (showYellowLines == 1) {
      noStroke();
      fill(255, 255, 0);
      rect(0, ypos+height/24-10, width, 5);
      rect(0, ypos+height/24+5, width, 5);
    }
  }


  // Displays all car objects that belong to this row of road
  void displayCars() {
    for (int i=0; i<cars.size(); i++) {
      cars.get(i).display();
    }
  }


  // Updates/moves cars if frogger is alive
  void updateCars() {
    for (int i=0; i<cars.size(); i++) {
      cars.get(i).update();
    }
  }


  // Add background image to row (Can be used to have different design for each level)
  void setImage(PImage roadImage_) {
    roadImage = roadImage_;
  }
}


// A class that manages and displays cars belonging to road rows in the game Frogger.
class Car {
  // Location & relation to cars array
  int id;
  int numCars;

  // Position and Size Attributes
  float xpos, ypos;
  float sizeX, sizeY;

  float maxSizeX = 100;
  float maxSizeY = heightOfRow;

  float minSizeX = 30;
  float minSizeY = heightOfRow/2;

  // Collision Attributes
  boolean isCounted = false;
  int collisionCount = 0;

  // Movement Attributes
  float speedX;
  int direction;

  PImage carImage;


  // Constructor
  Car(int numCars_, float ypos_, int id_, int direction_, float speedX_) {
    numCars = numCars_;
    id = id_;

    ypos = ypos_+(heightOfRow/2);
    xpos = id*(width*2)/numCars;


    sizeX = random(minSizeX, maxSizeX);
    sizeY = random(minSizeY, maxSizeY);

    speedX = speedX_;
    direction = direction_;
  }


  // Checks for collision with Frog object
  void checkCollision() {
    Frog frog = scenes.get(currentScene).frogger;
    boolean foundCollision = false;

    float lx = xpos-sizeX/2;
    float rx = xpos+sizeX/2;
    float ty = ypos-sizeY/2;
    float by = ypos+sizeY/2;

    float ulx = frog.xpos+20;
    float urx = frog.xpos+frog.sizeX-20;
    float uty = frog.ypos+10;
    float uby = frog.ypos+frog.sizeY-10;

    if (rx > ulx && lx < urx && ty < uby && by > uty) {
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
    if (foundCollision) {
      if (!isCounted) {
        frog.die("car");
        collisionCount++;
        isCounted = true;
      }
    } else {
      isCounted = false;
    }
  }


  // Move car object
  void update() {
    // Move in direction specified in json
    xpos += speedX*direction;

    // If the car goes out of bounds, reset on opposit side
    // Larger bounds than usual to add variation in current screen content over course of the game
    if (xpos < -(numCars*(width*2)/numCars)) {
      xpos = width+500;
    } else if (xpos > (numCars*(width*2)/numCars)) {
      xpos = -500;
    }
  }


  // Display car object
  void display() {
    checkCollision();

    pushStyle();
    pushMatrix();
    rectMode(CENTER);

    // If no car image is provided, resort to gray rectangles
    if (carImage == null) {
      fill(255, 0, 0);
      rect(xpos, ypos, sizeX, sizeY);
    } else {
      translate(xpos, ypos);
      if (direction < 0) {
        rotate(PI);
      } else {
        rotate(0);
      }
      image(carImage, -sizeX/2, -sizeY/2, sizeX, sizeY);
    }

    popStyle();
    popMatrix();
  }

  void setImages() {
    carImage = carImages[int(random(carImages.length))];
  }
}