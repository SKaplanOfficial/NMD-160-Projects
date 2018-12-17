//-- SLIDERS --//

// A class that provides an easy way to make and interact with UI sliders
class Slider {

  private int type;            // 0 = Vertical, 1 = Horizontal
  private int x, y, w, h;      // Location and dimensions
  private float value;         // Decimal value from 0-100
  private float barPosition;   // Position of slider, changed with mouse interaction

  private String name;         // Name of slider - Should correspond to what the slider controls!
  
  private boolean broadcast;   // Whether to broadcast value to all clients or not


  public Slider(int type_, int x_, int y_, int w_, int h_, String name_) {
    // POST: Slider initialized with corresponding attributes
    type = type_;

    // (x,y) define first corner, w,h define width and height relative to that corner
    // default rectMode
    x = x_;
    y = y_;
    w = w_;
    h = h_;

    // barPosition and interaction changes depending on type
    if (type == 0) {
      barPosition = y;
    } else {
      barPosition = x;
    }

    // Initial value is 100%
    value = 100;

    name = name_;
  }


  public void run() {
    //POST: Responds to interaction and displays the slider
    mouseListener();
    display();
  }


  private void mouseListener() {
    // POST: Set bar position according to mouseY position, sets value as percentage of h
    if (type == 0) { // VERTICAL SLIDER
      if (mousePressed & mouseX > x && mouseX < x+w && mouseY > barPosition-20 && mouseY < barPosition+40) {
        // If mouse is within reasonable vertical distance of slider bar

        barPosition = constrain(mouseY-10, y, y+h-20);    // Constrain to slider bounds
        value = 100-(barPosition-y)/(h-20)*100;           // Value as percentage of bounds
      }
    } else if (type == 1) { // HORIZONTAL SLIDER
      if (mousePressed & mouseY > y && mouseY < y+h && mouseX > barPosition-20 && mouseX < barPosition+40) {
        // If mouse is within reasonable horizontal distance of slider bar

        barPosition = constrain(mouseX-10, x, x+w-20);    // Constrain to slider bounds
        value = 100-(barPosition-x)/(w-20)*100;           // Value as percentage of bounds
      }
    }
  }


  private void display() {
    // POST: Displays the slider
    strokeWeight(2);

    // Gray slider background
    stroke(10);
    fill(50, 100);
    rect(x, y, w, h, 5);

    if (type == 0) { // VERTICAL SLIDER
      // Green value indicator
      fill(0, 180, 100, value*2);
      rect(x, barPosition, w, (y+h)-barPosition, 5);

      // Blue bar
      stroke(0, 50, 155);
      fill(0, 150, 205);
      rect(x, barPosition, w, 20, 5);

      // Value text
      fill(255);
      textAlign(CENTER, CENTER);
      text(""+int(value), x+w/2, barPosition+10);

      // Label
      text(name, x+w/2, y+h+10);
    } else if (type == 1) { // HORIZONTAL SLIDER
      // Green value indicator
      fill(0, 180, 100, value*2);
      rect(barPosition, y, (x+w)-barPosition, h, 5);

      // Blue bar
      stroke(0, 50, 155);
      fill(0, 150, 205);
      rect(barPosition, y, 20, h, 5);

      // Value text
      fill(255);
      textAlign(CENTER, CENTER);
      text(""+int(value), barPosition+10, y+h/2);

      // Label
      text(name, x-10-name.length()*textWidth('a')/2, y+h/2);
    }
  }


  // Accessors
  public float getValue() {
    // POST: Returns raw, unrounded value of the slider
    return value;
  }

  public float getBarPosition() {
    // POST: Returns raw, unrounded bar position of the slider
    return barPosition;
  }

  public int getType() {
    // POST: Returns type of the slider
    return type;
  }

  public int getXStart() {
    // POST: Returns x-start position of the slider
    return x;
  }

  public int getYStart() {
    // POST: Returns y-start position of the slider
    return y;
  }

  public int getWidth() {
    // POST: Returns width of the slider
    return w;
  }

  public int getHeight() {
    // POST: Returns height of the slider
    return h;
  }

  public String getName() {
    // POST: Returns name the slider
    return name;
  }


  // Mutators
  public void setValue(float value_) {
    // POST: Set value of the slider
    value = value_;
    if (type == 0) {
      barPosition = -1*((h-20)*(value/100 - 1) - y);
      barPosition = constrain(barPosition, y, y+h-20);
    } else {
      barPosition = -1*((w-20)*(value/100 - 1) - x);
      barPosition = constrain(barPosition, x, x+w-20);
    }
  }

  public void setBarPosition(float pos) {
    // POST: Set bar position of the slider
    if (type == 0) {
      barPosition = constrain(pos, y, y+h-20);    // Constrain to slider bounds
      value = 100-(barPosition-y)/(h-20)*100;     // Value as percentage of bounds
    } else {
      barPosition = constrain(pos, x, x+w-20);     // Constrain to slider bounds
      value = 100-(barPosition-x)/(w-20)*100;      // Value as percentage of bounds
    }
  }

  public void setType(int type_) {
    type = type_;
  }

  public void setXStart(int x_) {
    // POST: Set x-start position of the slider
    x = x_;
  }

  public void setYStart(int y_) {
    // POST: Set y-start position of the slider
    y = y_;
  }

  public void setWidth(int w_) {
    // POST: Set width of the slider
    w = w_;
  }

  public void setHeight(int h_) {
    // POST: Set height of the slider
    h = h_;
  }

  public void setName(String name_) {
    // POST: Set name the slider
    name = name_;
  }

  void setBroadcast(boolean b) {
    broadcast = b;
  }

  boolean isBroadcast() {
    return broadcast;
  }
}



//-- BUTTONS --//

// Modified android button class (From Android example in File > Examples > Topics > GUI > Button)
class Button {
  int x, y;                          // Button shape origin
  int size;                          // Radius (for circles), 1 side length (for rectangles, other side defined in child class)
  color basecolor, highlightcolor;   // Hover/non-hover colors
  color togglecolor;                 // Active state color
  color currentcolor;                // Color of button at any given moment
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
    value = value_;
  }

  void setBroadcast(boolean b) {
    broadcast = b;
  }

  boolean isBroadcast() {
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

    fill(255-red(currentcolor), 255-green(currentcolor), 255-blue(currentcolor));
    textSize(size/10);
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

    fill(255-red(currentcolor), 255-green(currentcolor), 255-blue(currentcolor));
    textSize(15);
    text(name, x, y, size, size_2);
  }
}


void singleEnabled(Button button) {
  for (Button b : buttons.values()) {
    if (!b.equals(button)) {
      b.setValue(false);
    }
  }
}