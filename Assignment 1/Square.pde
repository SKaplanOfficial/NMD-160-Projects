// Objects of the Square class form the "pixels" in the art of my portrait
class Square {
  float x, y, targetX, targetY; 
  float r, targetR;
  float easing = random(0.02, 0.05); // x-position, y-position, and rotation ease to target => Image assembles

  float speedX, speedY; // Speed separate from easing movement

  int type; // Square variety - Background, outline, hair, skin, shadow, highlight


  Square(float x_, float y_, float targetX_, float targetY_, int type_) {
    x = x_;
    y = y_;

    speedX = random(-10, 10);
    speedY = random(30, 50); // Initial vertical/horizontal speeds to create "upward waterfall" effect

    targetX = targetX_ + width/2-(sideLength*tileSize)/2; // Each square has a set position to go to
    targetY = targetY_ + height/2-(sideLength*tileSize)/2; // Final image will be centered even if size in setup() is changed

    r = random(TWO_PI);
    targetR = 0; // All squares must be aligned at the end to form an image

    type = type_;
  }


  // Called every frame. Could separate all math operations into an update() method, but this works for now
  void display() {
    // Easing
    float dx = targetX - x;
    x += dx * easing + speedX;

    float dy = targetY - y;
    y += dy * easing + speedY;

    float dr = targetR - r;
    r += dr * easing;

    // Decrease magnitude of speedX and speedY over time so that movement due to easing becomes more prominent
    if (abs(speedX) > 0.5) {
      speedX /= 1.1;
    } else {
      speedX = 0;
    }

    if (speedY > 0.5) {
      speedY /= 1.1;
    } else {
      speedY = 0;
    }


    pushMatrix();

    translate(x+10, y+10); // Translate before rotating
    rotate(r);

    switch(type) { // Color of square based on type specified in portrait[]
    case 0: // Background - Gradient/interactive
      fill(targetX/5+mouseX/5, targetY/5+mouseY/5, dist(x, y, width/2-22, height/2));
      break;
    case 1: // Black outling
      fill(32);
      break;
    case 2: // Hair color - Change with right click
      fill(red(hairColor)+random(-20, 20), green(hairColor)+random(-20, 20), blue(hairColor)+random(-20, 20));
      break;
    case 3: // Shadow 1
      fill(240, 192, 124);
      break;
    case 4: // Skin
      fill(255, 210, 148);
      break;
    case 5: // Highlight
      fill(255, 220, 158);
      break;
    case 6: // Shadow 2
      fill(245, 210, 138);
      break;
    }
    
    noStroke();
    rectMode(RADIUS);
    rect(0, 0, tileSize/2, tileSize/2);
    popMatrix();
  }
}
