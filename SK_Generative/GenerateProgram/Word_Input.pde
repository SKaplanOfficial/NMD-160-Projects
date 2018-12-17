//*****************************//
//         WORD  ENTRY         //
//*****************************//

// Declare list for flocking objects
ArrayList ballCollection;


void showWordInput() {
  pushMatrix();
  translate(0, 0, -1);
  renderWordBackground();
  popMatrix();

  pushMatrix();                // Restrict translations to this block
  pushStyle();                 // Restrict style changes to this block
  textAlign(CENTER, CENTER);   // Center text vertically and horizontally

  translate(0, 0, 1);

  stroke(20, startY);
  strokeWeight(5);
  fill(10, startY);
  rect(width/2-50, height-startY, 100, startY/2, 5);


  // Scene Intent
  textSize(40);
  fill(255);
  text("Enter a word", 0, startY, width, startY*2.5);

  // Scene Hint
  textSize(14);
  text(hour()+":"+minute()+":"+second(), 0, height-startY, width, startY/2);

  // Scene Input
  textSize(40);
  textBox(0, height-startY*4, width, 100, word);

  // Scene Data Collection
  textSize(12);
  textAlign(LEFT, TOP);
  text("Information Utilized:\n\t- Word\n\t- Word Length\n\t- Rhyme", width-startY*2, height-120, 200, 100);

  popStyle();
  popMatrix();
}



void wordListener() {
  if (second() < 15) {
    // Only allow word entry after the first 15 seconds of a minute
    addNotification("Too soon.", 150);
  } else if (key == BACKSPACE) {
    // Remove last letter from name
    if (word.length() > 0) {
      word = word.substring(0, word.length()-1);
    }
  } else if (key == ENTER) {    
    // Process Input
    word = word.toLowerCase();

    // Memory Management
    begin = false;
    ballCollection.clear();

    // Reset Positioning
    startY = -10;
    targetY = 130;

    // Next Scene (Number Input)
    scene = 3;
  } else if ((key == 'i' || key == 'I') && minute()%2 == 1) {
    // Only allow 'I' on odd minutes
    addNotification("You can't use the letter 'I'!", 150);
  } else if ((key == 'e' || key == 'E') && minute()%2 == 0) {
    // Only allow 'E' on even minutes
    addNotification("You can't use the letter 'E'!", 150);
  } else if (textWidth(word+key) < width && key >= 'A' && key <= 'z') {
    // Only allow users to enter A-Z, a-z characters
    word = word + key;
  }
}



void renderWordBackground() {
  if (!begin) {

    // Initialize list
    ballCollection = new ArrayList();

    // Add flocking objects
    for (int i=0; i<600; i++) {
      Vec3D origin = new Vec3D(random(width), random(200), 0);
      Ball myBall = new Ball(origin);
      ballCollection.add(myBall);
    }

    // Do not run this code again
    begin = true;
  }
  
  background(20+word.length());

  // Call flocking functionality
  for (int i=0; i<ballCollection.size(); i++) {
    Ball mb = (Ball) ballCollection.get(i);
    mb.run();
  }
}



// Flocking from previous assignments
class Ball {
  // Global Variables

  Vec3D loc = new Vec3D(0, 0, 0);
  Vec3D speed = new Vec3D(random(-2, 2), random(-2, 2), 0);
  Vec3D acc = new Vec3D();
  Vec3D grav = new Vec3D(0, 0.2, 0);

  // Constructor
  Ball(Vec3D loc_) {
    loc = loc_;
  }

  // Functions
  void run() {
    move();
    bounce();
    lineBetween();
    flock();
    display();
  }

  void flock() {
    separate(5);
    cohesion(0.001);
    align(0.1);
  }

  void align(float magnitude) {
    // Align speed with neighbors

    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i=0; i<ballCollection.size(); i++) {
      Ball other = (Ball) ballCollection.get(i);

      float distance = loc.distanceTo(other.loc);

      if (distance > 0 && distance < 40) {
        steer.addSelf(other.speed);
        count++;
      }
    }

    if (count > 0) {
      steer.scaleSelf(1.0/count);
    }

    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }

  void cohesion(float magnitude) {
    // Stick to neighbors

    Vec3D sum = new Vec3D();
    int count = 0;

    for (int i=0; i<ballCollection.size(); i++) {
      Ball other = (Ball) ballCollection.get(i);

      float distance = loc.distanceTo(other.loc);

      if (distance > 0 && distance < 60) {
        sum.addSelf(other.loc);
        count++;
      }
    }

    if (count > 0) {
      sum.scaleSelf(1.0/count);
    }

    Vec3D steer = sum.sub(loc);
    steer.scaleSelf(magnitude);

    acc.addSelf(steer);
  }

  void separate(float magnitude) {
    // Don't stick too close to neighbors

    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i=0; i<ballCollection.size(); i++) {
      Ball other = (Ball) ballCollection.get(i);

      float distance = loc.distanceTo(other.loc);

      if (distance > 0 && distance < 30) {
        Vec3D diff = loc.sub(other.loc);
        diff.normalizeTo(1.0/distance);

        steer.addSelf(diff);
        count++;
      }
    }

    Vec3D mouseLoc = new Vec3D(mouseX, mouseY, 0);
    float distance = loc.distanceTo(mouseLoc);

    if (distance > 0 && distance < 100) {
      Vec3D diff = loc.sub(mouseLoc);
      //diff.normalizeTo(1.0/distance);

      steer.addSelf(diff);
      count++;
    }

    if (count > 0) {
      steer.scaleSelf(1.0/count);
    }

    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }

  void lineBetween() {
    // Draw a line between this ball and neighbors

    for (int i=0; i<ballCollection.size(); i++) {
      Ball other = (Ball) ballCollection.get(i);

      float distance = loc.distanceTo(other.loc);

      if (distance > 0 && distance < 40) {
        stroke(dist(loc.x, 0, 0, 0)/4, dist(loc.x, 0, width, 0)/4, 255-dist(loc.x, 0, width/2, 0)/4, 100);
        strokeWeight(0.4);
        line(loc.x, loc.y, other.loc.x, other.loc.y);
      }
    }
  }

  void bounce() {
    // Bounce off of sides

    if (loc.x > width || loc.x < 0) {
      speed.x *= -1;
    }

    if (loc.y > height || loc.y < 0) {
      speed.y *= -1;
    }
  }

  void move() {
    speed.addSelf(acc);
    speed.limit(2);
    loc.addSelf(speed);

    acc.clear();
  }

  void display() {
    // Show ball

    strokeWeight(5);
    stroke(dist(loc.x, 0, 0, 0)/4, dist(loc.x, 0, width, 0)/4, 255-dist(loc.x, 0, width/2, 0)/4, 50);
    fill(dist(loc.x, 0, 0, 0)/4, dist(loc.x, 0, width, 0)/4, 255-dist(loc.x, 0, width/2, 0)/4, 200);
    ellipse(loc.x, loc.y, 10, 10);
  }
}