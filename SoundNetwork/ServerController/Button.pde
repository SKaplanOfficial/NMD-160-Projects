//-- BUTTONS --//

// Modified android button class (From Android example in File > Examples > Topics > GUI > Button)
class Button {
  int x, y;                          // Button shape origin
  int size;                          // Radius (for circles), 1 side length (for rectangles, other side defined in child class)
  color basecolor, highlightcolor;   // Hover/non-hover colors
  color togglecolor;                 // Active state color
  color currentcolor;                // Color of button at any given moment
  color textcolor = -1;              // Button's inner text color (-1 for default)
  boolean over = false;              // Hover detection
  boolean pressed = false;           // Click detection
  boolean value;                     // State memory
  boolean singleUse;                 // Persistant state vs. one-click actions
  String name;                       // Name of button - Should correspond to what the button controls!
  boolean broadcast;                 // Whether to relay to all clients or not

  void update() {
    // Color based on whether the mouse is hovering over the button or not
    if (over()) {
      currentcolor = highlightcolor;
    } else if (value) {
      currentcolor = togglecolor;
    } else {
      currentcolor = basecolor;
    }
  }

  void display() { 
    // To be defined by child classes
  }

  void setValue(Boolean value_) {
    // Sets value to value_
    value = value_;
  }

  void setBroadcast(boolean b) {
    // Set value of broadcast to b
    broadcast = b;
  }

  public void setTextColor(color c) {
    // Sets button's inner text color
    textcolor = c;
  }

  boolean isBroadcast() {
    // Return whether button value is broadcasted to all clients or not
    return broadcast;
  }

  boolean over() { 
    // To be defined by child classes
    return true;
  }

  boolean isSingleUse() {
    // Return whether button is single use or not
    return singleUse;
  }

  boolean getValue() {
    // Get value of the button
    return value;
  }

  boolean overRect(int x, int y, int width, int height) {
    // Detect is mouse is hovering over a rectangular button object
    return (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height);
  }

  boolean overCircle(int x, int y, int diameter) {
    // Detect is mouse is hovering over a circular button object
    return dist(x, y, mouseX, mouseY) < diameter/2;
  }

  boolean equals(Button b) {
    return name.equals(b.getName());
  }

  String getName() {
    return name;
  }
}



class CircleButton extends Button { 
  CircleButton(int ix, int iy, int isize, color icolor, color ihighlight, color itoggle, boolean isingle, String iname) {
    // Assign values to attributes of Button parent class
    name = iname;
    x = ix;
    y = iy;
    size = isize;
    basecolor = icolor;
    highlightcolor = ihighlight;
    togglecolor = itoggle;
    currentcolor = basecolor;
    singleUse = isingle;
  }

  boolean over() {
    // Check whether mouse is within bounds of circle
    if ( overCircle(x, y, size) ) {
      over = true;
    } else {
      over = false;
    }

    if (over && !singleUse) {
      value = true;
    }

    return over;
  }

  void display() {
    stroke(255, 20);            // Mostly transparent border
    strokeWeight(size/15);

    fill(currentcolor);         // Fill color depends on state (hovering, pressed, etc)
    ellipse(x, y, size, size);  // Display circle

    if (textcolor == -1) {      // Try to make a color that contrasts with the button background if no text color is provided
      fill(255-red(currentcolor), 255-green(currentcolor), 255-blue(currentcolor));
    } else {
      fill(textcolor);
    }
    textSize(40);
    text(name, x, y);
  }
}



class RectButton extends Button {
  int size_2;

  RectButton(int ix, int iy, int isize, int isize_2, color icolor, color ihighlight, color itoggle, boolean isingle, String iname) {
    // Assign values to attributes of Button parent class
    name = iname;
    x = ix;
    y = iy;
    size = isize;
    size_2 = isize_2;
    basecolor = icolor;
    highlightcolor = ihighlight;
    togglecolor = itoggle;
    currentcolor = basecolor;
    singleUse = isingle;

    this.setTextColor(color(255));
  }

  boolean over() {
    // Check whether mouse is within bounds of rectangle
    if ( overRect(x, y, size, size_2) ) {
      over = true;
    } else {
      over = false;
    }

    if (over && !singleUse) {
      value = true;
    }

    return over;
  }

  void display() {
    stroke(255, 20);                 // Mostly transparent border
    strokeWeight(5);

    fill(currentcolor);              // Fill color depends on state (hovering, pressed, etc)
    rect(x, y, size, size_2, 5);     // Display rectangle

    fill(textcolor);
    textSize(30);
    text(name, x, y, size, size_2);
  }
}



void singleEnabled(Button button) {
  // Keep only one singleEnabled button enabled at a time
  for (Button b : buttons.values()) {
    if (!b.equals(button)) {
      b.setValue(false);
    }
  }
}