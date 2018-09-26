// A class that manages and displays a river row in the game Frogger.
class River {
  // Position Attributes
  float ypos;
  
  // River Particles
  int particleAmount = 800;
  ArrayList<RiverParticle> particles = new ArrayList<RiverParticle>();


  // Constructor
  River(float ypos_) {
    ypos = ypos_;

    // Populate river with particles
    for (int i=0; i<particleAmount; i++) {
      particles.add(new RiverParticle(random(width), ypos));
    }
  }

  
  // To be used for log collision detect later on
  void update() {
    checkCollision();
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
    if (xpos < 0) {
      xpos = width;
    } else if (xpos > width) {
      xpos = 0;
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