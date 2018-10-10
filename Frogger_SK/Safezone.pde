//*****************************//
//     END ZONE MANAGEMENT     //
//*****************************//

// A class that manages and displays a safezone row in the game Frogger.
class Safezone {
  // Position Attributes
  float ypos;

  // Images
  PImage grassImage;


  // Constructor
  Safezone(float ypos_) {
    ypos = ypos_;
  }


  // Currently unused, but kept for easy access later
  void update() {
  }


  // Displays this row
  void display() {
    noStroke();

    if (grassImage == null) {
      // If no grass image is provided, resort to green rectangles
      fill(100, 200, 0);
      rect(0, ypos, width, heightOfRow);
    } else {
      // Otherwise, use math to provide optimal tiling of image along the row
      float ratio = grassImage.height/heightOfRow;
      for (int x=0; x<width; x += grassImage.width/ratio) {
        pushStyle();
        if (ypos == 0) {
          tint(0, 155, 0, 200);
        }
        image(grassImage, x, ypos, grassImage.width/ratio, heightOfRow);
        popStyle();
      }
    }
  }


  // Add background image to row (Can be used to have different design for each level)
  void setImage(PImage grassImage_) {
    grassImage = grassImage_;
  }
}



// A bonus/power-up class that defines attributes and behaviors for Frogger power up objects.
class EndPoint {
  // Position Attributes
  float xpos, ypos;
  float originX, originY;

  // Direction of movement (Slight up/down motion)
  int direction = -1;

  boolean colliding;


  // Constructor
  EndPoint(float xpos_, float ypos_) {
    xpos = xpos_;
    ypos = ypos_;

    originX = xpos;
    originY = ypos;

    colliding = false;

    ypos += int(random(-6, 6)); // Offset ypos to add fluidity
  }


  // Move object up and down gently as long as Frog is alive
  void update() {
    // Check for collision with Frog
    checkCollision();
  }


  // Check proximity of Frog object to this power up
  void checkCollision() {
    Frog frog = scenes.get(currentScene).frogger;

    // Currently just prints a message
    // In the future, add bonus points or decrease speed of cars (or other bonuses...?)
    if (dist(xpos, ypos, frog.xpos+width/20, frog.ypos) < 30) {
      score += 2000;

      colliding = true;

      if (scenes.get(currentScene).endPoints.size() > 1) {
        frog.xpos = frog.originX;
        frog.ypos = frog.originY;
        frog.noReturn = false;
        frog.onLog = false;

        scenes.get(currentScene).endPoints.remove(this);
      } else if (currentScene < sceneAmount-1) {
        clearPersistantNotifications();

        currentScene += 1;

        // Load previous scene
        log("Loading Data For Scene "+currentScene);
        scenes.get(currentScene).loadData();

        log("Loading Assets For Scene "+currentScene + " - "+scenes.get(currentScene).getName());
        scenes.get(currentScene).loadAssets();

        addNotification(scenes.get(currentScene).getName()+" - "+scenes.get(currentScene).getCatchPhrase(), 0, height/2-100, width, 200, -1, false);

        // Unload unnecessary objects and images
        scenes.get(currentScene-1).unloadAssets();
      } else {
        if (score > highscore) {
          highscore = score;
          scoreObj.setFloat("highscore", score);
          saveJSONObject(scoreObj, "data/highscore.json");
        }

        clearPersistantNotifications();
        currentScene = sceneAmount;
        winGame = true;
        startGame = false;
        scenes.get(currentScene-1).unloadAssets();
      }
    } else {
      colliding = false;
    }
  }


  // Display power up object
  void display() {
    noStroke();
    pushStyle();
    rectMode(CENTER);

    JSONObject colorObj = loadJSONObject("./Scenes/"+currentScene+"/data.json");
    int colorMode = colorObj.getInt("colorMode");
    
    if (colorMode == 0) { // Light colors
      fill(222, 184, 135, 50);
      // Rounded rectangles
      rect(xpos, ypos+(heightOfRow/2), 55, 55, 50);

      fill(222, 184, 135, 100);
      rect(xpos, ypos+(heightOfRow/2), 52, 52, 40);

      fill(222, 184, 135, 150);
      rect(xpos, ypos+(heightOfRow/2), 47, 47, 30);

      fill(222, 184, 135, 200);
      rect(xpos, ypos+(heightOfRow/2), 40, 40, 30);
    } else {  // Dark colors
      fill(80, 92, 67, 50);
      rect(xpos, ypos+(heightOfRow/2), 55, 55, 50);

      fill(80, 92, 67, 100);
      rect(xpos, ypos+(heightOfRow/2), 52, 52, 40);

      fill(80, 92, 67, 150);
      rect(xpos, ypos+(heightOfRow/2), 47, 47, 30);

      fill(80, 92, 67, 200);
      rect(xpos, ypos+(heightOfRow/2), 40, 40, 30);
    }
    // 3 "concentric" rectangles with opacity increasing toward the center

    popStyle();
  }
}