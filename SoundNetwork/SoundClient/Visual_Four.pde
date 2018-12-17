// Second Visual - Mode: 3
// Goal of visual: Show how objects can be used to provide a more interesting experience
ArrayList<FallingPoint> fallingPoints = new ArrayList<FallingPoint>();

void show_visual_four(String[] data) {
  background(bg);

  if (frameRate > 30) {
    // Add a new point for each index of the data array if the computer can handle it
    for (int i=0; i<data.length; i++) {
      fallingPoints.add(new FallingPoint(0, height+random(8), data));
    }
  } else {
    // Otherwise only add one
    fallingPoints.add(new FallingPoint(0, height+random(8), data));
  }

  for (int i=0; i<fallingPoints.size(); i++) { // Update and display each fallingPoint
    fallingPoints.get(i).update();
    fallingPoints.get(i).display();
  }
}


void show_visual_four() {                      // Run without new data provided
  background(bg);

  for (int i=0; i<fallingPoints.size(); i++) { // Update and display each fallingPoint
    fallingPoints.get(i).display();
    fallingPoints.get(i).update();
  }
}


class FallingPoint {
  PVector loc, vel, acc;
  float size;
  color c;
  int myData;  // Index of data array to respond to

  float previousValue;

  FallingPoint (float x, float y, String[] data) {
    myData = int(random(0, data.length));  // Select random index of the data array
    size = parseFloat(data[myData]);       // Derive amplitude of sound from data array

    if (size*10 < 300) {                   // Color is blue until the size is large enough, then turns yellow -> Somewhat imitating fountains, but not really
      c = color(80, 10, 40+size*10);
    } else {
      c = color(255, 255, 204);
    }

    loc = new PVector((0.5+myData)*width/data.length, y);  // Location based on which index was selected
    vel = new PVector(random(-0.5, 0.5), -size);           // Initial velocity
    acc = new PVector(0, size/20);                         // Acceleration based on size

    if (size/20 < 2) {                     // Remove this point if the size is too small
      fallingPoints.remove(this);
    }
  }

  void update() {
    vel.add(acc);  // Update vectors
    loc.add(vel);

    if (loc.x > width || loc.x < 0) {  // Remove point when it reaches boundaries
      fallingPoints.remove(this);
    }

    if (loc.y > height+10) {
      fallingPoints.remove(this);
    }
  }

  void display() {
    // Display line from the bottom of the screen to the point (loc.x, loc.y)
    stroke(c, 100);
    strokeWeight(4);
    line(loc.x, height, loc.x, loc.y);
  }
}