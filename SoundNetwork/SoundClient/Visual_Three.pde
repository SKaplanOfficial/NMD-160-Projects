// Second Visual - Mode: 2
// Goal of visual: Show how objects can be used to provide a more interesting experience

ArrayList<Dot> dots = new ArrayList<Dot>();  // List of objects
int dotAmount;                               // Limit number of objects

void show_visual_three(String[] data) {
  if (dots.size() == 0) {                // Run once when this mode is initially entered
    dotAmount = width/3;
    for (int i=0; i<dotAmount; i++) {    // Populate dots ArrayList
      dots.add(new Dot(random(width), random(height), data.length));
    }
  } else {                               // Run continuously while mode is active
    background(bg);                      // Background controller by ServerController


    for (int i=0; i<dots.size(); i++) {  // Update and display each dot
      dots.get(i).update(data);
      dots.get(i).display();
    }
  }
}


void show_visual_three() {
  background(bg);

  for (int i=0; i<dots.size(); i++) {  // Update and display each dot without providing data
    dots.get(i).update();
    dots.get(i).display();
  }
}


class Dot {
  float x, y, speedX, speedY;
  color c;
  int myData;  // Index of the data that this dot is responding to

  float previousValue;

  Dot (float x_, float y_, int size) {
    x = x_;
    y = y_;

    if (random(10) < 5) {  // Diagonal motion either forward or backward
      speedX = 1;
      speedY = 1;
    } else {
      speedX = -1;
      speedY = -1;
    }

    myData = int(random(0, size));  // Select random index of the data array
  }

  void update(String[] data) {
    float newData = parseInt(data[myData]);
    float newValue = (newData + previousValue) / 2;       // Average old and new value to normalize the data slightly

    c = color(newValue*20, 0, 80);                        // Update color

    x += speedX * (newValue+noise(frameCount/50.0))/10;   // Update position
    y += speedY * (newValue+noise(frameCount/20.0))/10;

    if (x < 0 || x > width) {   // Reverse direction once boundary is reached
      speedX *= -1;
      speedY *= -1;
    }

    if (y < 0 || y > height) {
      speedY *= -1;
      speedX *= -1;
    }

    previousValue = newValue;   // Update previous value
  }

  void update() {
    c = color(previousValue*20, 0, 80);                        // Update color

    x += speedX * (previousValue+noise(frameCount/50.0))/10;   // Update position
    y += speedY * (previousValue+noise(frameCount/20.0))/10;

    if (x < 0 || x > width) {   // Reverse direction once boundary is reached
      speedX *= -1;
      speedY *= -1;
    }

    if (y < 0 || y > height) {
      speedY *= -1;
      speedX *= -1;
    }
  }

  void display() {
    stroke(c, 50);
    strokeWeight(1);

    for (Dot d : dots) {
      // Line from each dot to every neighboring dot within 100 pixels
      if (!d.equals(this) && dist(x, y, d.x, d.y) < 100) {
        line(x, y, d.x, d.y);
      }
    }

    // Stroke weight based on previous and current data
    noFill();
    strokeWeight(previousValue+myData);

    // Ellipse centered at (x,y) placed slightly in front of lines
    pushMatrix();
    translate(0, 0, 1);
    ellipse(x, y, 5+myData, 5+myData);
    popMatrix();
  }
}