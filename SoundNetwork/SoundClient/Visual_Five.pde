// Second Visual - Mode: 4
// Goal of visual: Show how, with some extra effort, you can create more and more complex visualizations (3D, based on distance from center, etc)
ArrayList<Point> points = new ArrayList<Point>();

void show_visual_five(String[] data) {
  if (points.size() == 0) {                 // Run once when this mode is initially entered

    // Point matrix creation
    for (int x=0; x<=width+width/50; x+=(width/100)) {
      for (int y=0; y<=height; y+=(height/80)) {
        points.add(new Point(x, y, data));
      }
    }
  } else {
    background(bg);

    for (int i=0; i<points.size(); i++) {  // Update and display points, provide new data
      points.get(i).update(data);
      points.get(i).display();
    }
  }
}



void show_visual_five() {
  background(bg);

  for (int i=0; i<points.size(); i++) {    // Display all points without providing new data
    points.get(i).display();
  }
}


class Point {
  float x, y;
  int freq = 0;  // Index of data array to respond to
  float weight = 1;
  float previousWeight;

  Point(float xpos, float ypos, String[] data) {
    x = xpos;
    y = ypos;

    float dist = dist(x, y, width/2, height/2);
    freq = int(map(dist, 0, width/1.5, 0, data.length));  // Index based on distance from center
  }

  void update(String[] data) {
    weight = (parseFloat(data[freq])+previousWeight)/2; //Average old and new weight to normalize the data slightly
    previousWeight = weight;                            // Update previous weight
  }

  void display() {
    // Color based on position
    stroke(red, dist(x, y, width, height/2)/4, dist(x, y, 0, height/2)/4, 100);

    //  Stroke weight based on data
    if (weight > 1) {
      strokeWeight(weight);
    }

    point(x, y);
  }
}