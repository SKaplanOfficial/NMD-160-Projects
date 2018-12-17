//*****************************//
//       PRE  DATA-ENTRY       //
//*****************************//

// Beziers to generate background
ArrayList<Curve> curves = new ArrayList<Curve>();


void showStartScreen() {
  if (!begin) {
    // Set background once, to be drawn over
    background(12);

    // Number of curves to draw
    int amount = 20;

    // Add curves to list
    for (int i=0; i<amount; i++) {
      curves.add(new Curve());
    }

    // Do not run this code again
    begin = true;
  } else {


    // Display each curve
    for (int i=0; i<curves.size(); i++) {
      curves.get(i).display();
    }


    pushMatrix();                // Restrict translations to this block
    pushStyle();                 // Restrict mode changes to this block
    textAlign(CENTER, CENTER);   // Center text vertically and horizontally
    translate(0, 0, 1);          // Put all text and buttons slightly in front of curves


    // Use startY and easing from Utility to smoothly bring content into display
    // Only apply stroke once everything is in the correct position (otherwise odd visual errors occur)
    if (abs(targetY-startY) < 10) {
      stroke(15);
      strokeWeight(10);
    } else {
      noStroke();
    }


    // Text background
    fill(21);
    rect(-10, -10, width+20, startY);
    rect(width/2-80, height-startY/2, 160, startY/2);


    // Program name with slight 3D text effect (kinda)
    textSize(80);
    fill(100);
    text("THE BLACK BOX", 0, -50, width, startY*1.5);

    textSize(79);
    fill(255);
    text("THE BLACK BOX", 0, -50, width, startY*1.5);


    // Program version
    textSize(12);
    text("Version "+version, 0, height-startY/2, width, startY/2);


    // Advance scene button
    rectMode(CENTER);
    int button = button(width/2, height/1.5, 300, 100, "Click to begin");
    // Button with center at (width/2, height/1.5), width=300, height=100, text="Click to begin"
    
    // When button is clicked...
    if (button == 1) {
      // Memory management
      begin = false;
      curves.clear();

      // Reset Positioning
      startY = -10;
      targetY = 130;

      // Next Scene (Name Input)
      scene = 1;
    }

    popStyle();
    popMatrix();
  }
}



// Beziers
class Curve {
  PVector pos1, pos2, vel1, vel2, acc1, acc2;
  float opacity;

  float offSet1, offSet2;

  Curve() {
    pos1 = new PVector(random(width), 0);           // Random start position
    pos2 = new PVector(random(width), height);      // Random end position on other side of screen

    vel1 = new PVector(0, 0);                       // No velocity to start with
    vel2 = new PVector(0, 0);

    acc1 = new PVector (random(-1, 1)*0.1, 0);      // Very small, random acceleration
    acc2 = new PVector (random(-1, 1)*0.1, 0);

    opacity = 20;                                   // Low opacity

    offSet1 = random(width);                        // Random intensity of curve
    offSet2 = random(width);
  }

  void display() {
    acc1.add(new PVector (random(-1, 1)*0.01, 0));  // Modify acceleration randomly over time
    acc2.add(new PVector (random(-1, 1)*0.01, 0));

    vel1.add(acc1);                                 // Modify velocity
    pos1.add(vel1);                                 // Modify position

    vel2.add(acc2);
    pos2.add(vel2);

    strokeWeight(1);
    
    // Color based on position
    stroke(dist(pos2.x, pos2.y, width/2, height/2)/5, 0, dist(pos1.x, pos1.y, width/2, height/2)/5, opacity);
    noFill();
    
    // Bezier starts at pos1, ends at pos2, curves according to acceleration and velocity (Curve is not constant)
    bezier(pos1.x, pos1.y, acc1.x+offSet1, height/2+vel1.y, width-acc2.x-offSet2, height/2+vel2.y, pos2.x, pos2.y);

    // Decreasing opacity -> Eventually, static art is made
    opacity *= 0.995;
  }
}