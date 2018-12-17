// Each mode reacts to data in a specific way. Some will be create exactly the same display across all clients,
// while others will create nearly the same (ex: scatter). It is possible to achieve the same display across all devices,
// but it is, for the most part, unnecessary.

void lines(int[] data, float size) {
  // Simply draw a line from previous point to current point
  strokeWeight(size);
  line(data[0], data[1], data[2], data[3]);
}


void scatter(int[] data, float size) {
  // Draw points random within radius of size
  strokeWeight(1);

  for (int i=0; i<size*10; i++) {
    float angle = random(TWO_PI);
    float dist = random(size);
    point(data[0]+cos(angle)*dist, data[1]+sin(angle)*dist);
  }
}



void sparkler(int[] data, float size) {
  // Draw lines from current point to random point within radius of size
  strokeWeight(1);

  for (int i=0; i<50; i++) {
    float angle = random(TWO_PI);
    float dist = random(size);
    line(data[0], data[1], data[0]+cos(angle)*dist, data[1]+sin(angle)*dist);
  }
}



void tri(int[] data, float size) {
  // Draw triangle pointed toward point
  noStroke();

  pushMatrix();
  translate(data[0], data[1]);
  rotate(PI+atan2(data[0]-data[2], data[1]-data[3]));
  triangle(-size/4, size/4, size/4, size/4, 0, -size/sqrt(2)/4);
  popMatrix();
}



void square(int[] data, float size) {
  // Draw square pointed toward point 
  noStroke();

  pushMatrix();
  translate(data[0], data[1]);
  rotate(PI+atan2(data[0]-data[2], data[1]-data[3]));
  rect(-size/4, -size/4, size/2, size/2);
  popMatrix();
}



void phatch(int[] data, float size) {
  // Draw parallel cross-hatching
  strokeWeight(1);

  for (int i=0; i<size/10; i++) {
    float sX = random(-size/2, size/2);

    line(data[0]+sX, data[1]-size/2, data[0]+sX, data[1]+size/2);
  }

  for (int i=0; i<size/10; i++) {
    float sY = random(-size/2, size/2);

    line(data[0]-size/2, data[1]+sY, data[0]+size/2, data[1]+sY);
  }
}



void rhatch(int[] data, float size) {
  // Draw random cross-hatching
  strokeWeight(1);

  for (int i=0; i<size/10; i++) {
    float sX = random(-size/2, size/2);
    float eX = random(-size/2, size/2);

    line(data[0]+sX, data[1]-size/2, data[0]+eX, data[1]+size/2);
  }

  for (int i=0; i<size/10; i++) {
    float sY = random(-size/2, size/2);
    float eY = random(-size/2, size/2);

    line(data[0]-size/2, data[1]+sY, data[0]+size/2, data[1]+eY);
  }
}



void stripes(int[] data, float size) {
  // Draw horiztonal stipes
  strokeWeight(1);

  for (int i=0; i<size/10; i++) {
    float sY = random(-size/2, size/2);

    line(data[0]-size/2, data[1]+sY, data[0]+size/2, data[1]+sY);
  }
}



void columns(int[] data, float size) {
  // Draw vertical columns
  strokeWeight(1);
  
    for (int i=0; i<size/10; i++) {
    float sX = random(-size/2, size/2);

    line(data[0]+sX, data[1]-size/2, data[0]+sX, data[1]+size/2);
  }
}



void wave(int[] data, float size) {
  // Draw points with a strokeweight that changes according to position
  strokeWeight(size/2+sin((data[0]*data[1])/400.0)*size/2);
  point(data[0], data[1]);
}



void bubble(int[] data, float size) {
  // Draw points with strokeweight that changes according to distance from previous point
  strokeWeight(dist(data[0], data[1], data[2], data[3]));
  point(data[0], data[1]);
}



void triScatter(int[] data, float size) {
  // Draw small triangles scattered throughout radius of size
  noStroke();

  for (int i=0; i<10; i++) {
    float angle = random(TWO_PI);
    float dist = random(size);

    pushMatrix();
    translate(data[0]+cos(angle)*dist, data[1]+sin(angle)*dist);
    rotate((mouseX+mouseY)/100.0);
    triangle(-3, 3, 3, 3, 0, -3/sqrt(2));
    popMatrix();
  }
}



void squareScatter(int[] data, float size) {
  // Draw small squares scattered throughout radius of size
  noStroke();

  for (int i=0; i<10; i++) {
    float angle = random(TWO_PI);
    float dist = random(size);

    pushMatrix();
    translate(data[0]+cos(angle)*dist, data[1]+sin(angle)*dist);
    rotate((mouseX+mouseY)/100.0);
    rect(0, 0, 4, 4);
    popMatrix();
  }
}



void blur(int[] data, float size) {
  // Blur the boundary between two colors
  loadPixels();

  for (int i=0; i<size*5; i++) {
    float angle1 = random(TWO_PI);            // Random distances and angles
    float dist1 = random(size/2);
    
    float angle2 = random(TWO_PI);
    float dist2 = random(size/2);
    
    int x1 = int(data[0]+cos(angle1)*dist1);
    int x2 = int(data[0]+cos(angle2)*dist2);
    
    int y1 = int(data[1]+sin(angle1)*dist1);
    int y2 = int(data[1]+sin(angle2)*dist2);
    
    int loc1 = x1+y1*width;                  // Two pixel locations
    int loc2 = x2+y2*width;
    
    float r = (red(pixels[loc1])+red(pixels[loc2]))/2;
    float g = (green(pixels[loc1])+green(pixels[loc2]))/2;
    float b = (blue(pixels[loc1])+blue(pixels[loc2]))/2;
    float a = (alpha(pixels[loc1])+alpha(pixels[loc2]))/2;
    int temp = color(r,g,b,a);
    pixels[loc1] = pixels[loc2];            // Switch colors of those locations, decrease intensity
    pixels[loc2] = temp;
  }

  updatePixels();
}