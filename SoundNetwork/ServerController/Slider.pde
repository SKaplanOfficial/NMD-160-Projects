//-- SLIDERS --//

// A class that provides an easy way to make and interact with UI sliders
class Slider {

  private int type;            // 0 = Vertical, 1 = Horizontal
  private int x, y, w, h;      // Location and dimensions
  private float value;         // Decimal value from 0-100
  private float barPosition;   // Position of slider, changed with mouse interaction

  private String name;         // Name of slider - Should correspond to what the slider controls!

  private boolean broadcast;   // Whether to broadcast value to all clients or not
  
  private color percentColor = color(100, 180, 100); // Color of slider as its value increases


  public Slider(int type_, int x_, int y_, int w_, int h_, String name_) {
    // Slider initialized with corresponding attributes
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
    //Responds to interaction and displays the slider
    mouseListener();
    display();
  }


  private void mouseListener() {
    // Set bar position according to mouseY position, sets value as percentage of h
    if (type == 0) { // VERTICAL SLIDER
      if (mousePressed & mouseX > x && mouseX < x+w && mouseY > barPosition-h/4 && mouseY < barPosition+2*h/4) {
        // If mouse is within reasonable vertical distance of slider bar

        barPosition = constrain(mouseY-10, y, y+h-h/4);    // Constrain to slider bounds
        value = 100-(barPosition-y)/(h-h/4)*100;           // Value as percentage of bounds
      }
    } else if (type == 1) { // HORIZONTAL SLIDER
      if (mousePressed & mouseY > y && mouseY < y+h && mouseX > barPosition-w/4 && mouseX < barPosition+2*w/4) {
        // If mouse is within reasonable horizontal distance of slider bar

        barPosition = constrain(mouseX-10, x, x+w-w/4);    // Constrain to slider bounds
        value = 100-(barPosition-x)/(w-w/4)*100;           // Value as percentage of bounds
      }
    }
  }


  private void display() {
    // Displays the slider
    strokeWeight(2);

    // Gray slider background
    stroke(200, 50);
    fill(50, 50);
    rect(x, y, w, h, 5);

    if (type == 0) { // VERTICAL SLIDER
      // Value indicator
      fill(percentColor, map(value, 0, 100, 0, 255));
      rect(x, barPosition, w, (y+h)-barPosition, 5);

      // White bar
      stroke(150, 155);
      fill(240);
      rect(x, barPosition, w, h/4, 5);

      // Value text
      fill(80);
      textAlign(CENTER, CENTER);
      text(""+int(value), x+w/2, barPosition+h/8);

      // Label
      fill(50);
      text(name, x+w/2, y+h+10);
    } else if (type == 1) { // HORIZONTAL SLIDER
      // Green value indicator
      fill(100, 180, 100, value*3);
      rect(barPosition, y, (x+w)-barPosition, h, 5);

      // Blue bar
      stroke(0, 55, 155);
      fill(0, 100, 255);
      rect(barPosition, y, w/4, h, 5);

      // Value text
      fill(255);
      textAlign(CENTER, CENTER);
      text(""+int(value), barPosition+w/8, y+h/2);

      // Label
      fill(50);
      text(name, x-10-name.length()*textWidth('a')/2, y+h/2);
    }
  }


  // Accessors
  public float getValue() {
    // Returns raw, unrounded value of the slider
    return value;
  }

  public float getBarPosition() {
    // Returns raw, unrounded bar position of the slider
    return barPosition;
  }

  public int getType() {
    // Returns type of the slider
    return type;
  }

  public int getXStart() {
    // Returns x-start position of the slider
    return x;
  }

  public int getYStart() {
    // Returns y-start position of the slider
    return y;
  }

  public int getWidth() {
    // Returns width of the slider
    return w;
  }

  public int getHeight() {
    // Returns height of the slider
    return h;
  }

  public String getName() {
    // Returns name the slider
    return name;
  }


  // Mutators
  public void setValue(float value_) {
    // Set value of the slider
    value = value_;
    if (type == 0) {
      barPosition = -1*((h-h/4)*(value/100 - 1) - y);
      barPosition = constrain(barPosition, y, y+h-4/3);
    } else {
      barPosition = -1*((w-w/4)*(value/100 - 1) - x);
      barPosition = constrain(barPosition, x, x+w-w/4);
    }
  }

  public void setBarPosition(float pos) {
    // Set bar position of the slider
    if (type == 0) {
      barPosition = constrain(pos, y, y+h-20);    // Constrain to slider bounds
      value = 100-(barPosition-y)/(h-20)*100;     // Value as percentage of bounds
    } else {
      barPosition = constrain(pos, x, x+w-20);     // Constrain to slider bounds
      value = 100-(barPosition-x)/(w-20)*100;      // Value as percentage of bounds
    }
  }

  public void setType(int type_) {
    // Set whether slider is horizontal or vertical orientation
    type = type_;
  }

  public void setXStart(int x_) {
    // Set x-start position of the slider
    x = x_;
  }

  public void setYStart(int y_) {
    // Set y-start position of the slider
    y = y_;
  }

  public void setWidth(int w_) {
    // Set width of the slider
    w = w_;
  }

  public void setHeight(int h_) {
    // Set height of the slider
    h = h_;
  }

  public void setName(String name_) {
    // Set name the slider
    name = name_;
  }
  
  
  public void setPercentColor(color c) {
    // Set color of slider as its value is increases
    percentColor = c;
  }

  public void setBroadcast(boolean b) {
    // Sets whether this slider broadcasts its data or not
    broadcast = b;
  }

  public boolean isBroadcast() {
    // Return whether this slider broadcasts its data or not
    return broadcast;
  }
}