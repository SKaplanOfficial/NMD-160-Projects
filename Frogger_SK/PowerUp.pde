// A bonus/power-up class that defines attributes and behaviors for Frogger power up objects.
class PowerUp {
  // Position Attributes
  float xpos, ypos;
  float originX, originY;

  // Direction of movement (Slight up/down motion)
  int direction = -1;


  // Constructor
  PowerUp(float xpos_, float ypos_) {
    xpos = xpos_;
    ypos = ypos_;

    originX = xpos;
    originY = ypos;

    ypos += int(random(-6, 6)); // Offset ypos to add fluidity
  }


  // Move object up and down gently as long as Frog is alive
  void update() {
    // Check for collision with Frog
    checkCollision();

    // Up & Down, Periodic motion
    if (ypos < originY-5) {
      direction *= -1;
    }

    if (ypos > originY+5) {
      direction *= -1;
    }

    Frog frog = scenes.get(currentScene).frogger;
    if (frog.alive()) {
      ypos += 1*direction;
    }
  }


  // Check proximity of Frog object to this power up
  void checkCollision() {
    Frog frog = scenes.get(currentScene).frogger;

    // Currently just prints a message
    // In the future, add bonus points or decrease speed of cars (or other bonuses...?)
    if (dist(xpos+width/10, ypos, frog.xpos+width/20, frog.ypos) < 40) {
      print("COLLIDE");
    }
  }


  // Display power up object
  void display() {
    noStroke();
    pushStyle();
    rectMode(CENTER);

    fill(0, 200, 255, 50);
    // Rounded rectangles
    rect(xpos+width/10, ypos+(heightOfRow/2), 40, 40, 50);

    fill(0, 200, 255, 100);
    rect(xpos+width/10, ypos+(heightOfRow/2), 20, 20, 40);

    fill(0, 200, 255);
    rect(xpos+width/10, ypos+(heightOfRow/2), 10, 10, 30);
    // 3 "concentric" rectangles with opacity increasing toward the center

    popStyle();
  }
}