// Easy reference to UI elements
HashMap<String, Slider> sliders = new HashMap<String, Slider>();
HashMap<String, Button> buttons = new HashMap<String, Button>();


boolean begin = false;
void showControls() {

  if (!begin) {
    background(255);

    //-- COLOR SLIDERS --//
    sliders.put("Red", new Slider(0, 10, 10, 50, 80, "Red"));
    sliders.put("Green", new Slider(0, 70, 10, 50, 80, "Green"));
    sliders.put("Blue", new Slider(0, 130, 10, 50, 80, "Blue"));
    sliders.put("Alpha", new Slider(0, 190, 10, 50, 80, "Alpha"));
    sliders.put("Size", new Slider(0, 250, 10, 50, 80, "Size"));

    // Initial value of size
    sliders.get("Size").setValue(5);

    // Broadcast states of sliders
    sliders.get("Size").setBroadcast(true);
    sliders.get("Red").setBroadcast(true);
    sliders.get("Green").setBroadcast(true);
    sliders.get("Blue").setBroadcast(true);
    sliders.get("Alpha").setBroadcast(true);


    //-- FIRST ROW OF BUTTONS --//
    buttons.put("Line", new RectButton(350, 10, (width-400)/5, 100, color(40, 40, 50), color(0), color(0), false, "Line"));
    buttons.put("Scatter", new RectButton(360+(width-400)/5, 10, (width-400)/5, 100, color(40, 40, 60), color(0), color(0), false, "Scatter"));
    buttons.put("Sparkler", new RectButton(370+(width-400)/5*2, 10, (width-400)/5, 100, color(40, 40, 70), color(0), color(0), false, "Sparkler"));
    buttons.put("Triangle", new RectButton(380+(width-400)/5*3, 10, (width-400)/5, 100, color(40, 40, 80), color(0), color(0), false, "Triangle"));
    buttons.put("Square", new RectButton(390+(width-400)/5*4, 10, (width-400)/5, 100, color(40, 40, 90), color(0), color(0), false, "Square"));


    //-- SECOND ROW OF BUTTONS --//
    buttons.put("Cross-Hatch (P)", new RectButton(50, 150, (width-130)/4, 100, color(50, 40, 40), color(0), color(0), false, "Hatch (P)"));
    buttons.put("Cross-Hatch (R)", new RectButton(60+(width-130)/4, 150, (width-130)/4, 100, color(60, 40, 40), color(0), color(0), false, "Hatch (R)"));
    buttons.put("Stripes", new RectButton(70+(width-130)/4*2, 150, (width-130)/4, 100, color(70, 40, 40), color(0), color(0), false, "Stripes"));
    buttons.put("Columns", new RectButton(80+(width-130)/4*3, 150, (width-130)/4, 100, color(80, 40, 40), color(0), color(0), false, "Columns"));


    //-- THIRD ROW OF BUTTONS --//
    buttons.put("Wave", new RectButton(50, 300, (width-130)/4, 100, color(40, 50, 40), color(0), color(0), false, "Wave"));
    buttons.put("Bubble", new RectButton(60+(width-130)/4, 300, (width-130)/4, 100, color(40, 60, 40), color(0), color(0), false, "Bubble"));
    buttons.put("Triangle Scatter", new RectButton(70+(width-130)/4*2, 300, (width-130)/4, 100, color(40, 70, 40), color(0), color(0), false, "Triangle Scatter"));
    buttons.put("Square Scatter", new RectButton(80+(width-130)/4*3, 300, (width-130)/4, 100, color(40, 80, 40), color(0), color(0), false, "Square Scatter"));


    //-- EXPERIMENTAL BLURRING TOOL --//
    buttons.put("Blur", new CircleButton(width/2, height-(width)/5, (width/6), color(100), color(0), color(0), false, "Blur"));


    //-- SINGLE-USE BUTTONS --//
    buttons.put("Clear", new CircleButton(50+(width/5), height-(height/5), (width/5), color(80, 80, 100), color(40, 40, 60), color(0), true, "Clear"));
    buttons.put("Set Background", new CircleButton(width-50-(width/5), height-(height/5), (width/5), color(100), color(0), color(0), true, "Set Background"));


    // Don't run this code again
    begin = !begin;
  } else {
    background(20);

    // Background button always shows current color
    float red = map(sliders.get("Red").getValue(), 0, 100, 0, 255);
    float green = map(sliders.get("Green").getValue(), 0, 100, 0, 255);
    float blue = map(sliders.get("Blue").getValue(), 0, 100, 0, 255);
    buttons.put("Set Background", new CircleButton(width-50-(width/5), height-(height/5), (width/5), color(red, green, blue), color(red/4, green/4, blue/4), color(0), true, "Set Background"));


    // Top bar
    noStroke();
    fill(10);
    stroke(50, 20);
    rect(-10, -10, width+10, 130);


    // Display each slider
    boolean nearElement = false;
    textSize(14);
    for (Slider s : sliders.values()) {
      s.run();

      // Avoid drawing in control area when in normal desktop usage mode
      if (mouseX > s.getXStart()-20 && mouseX < s.getXStart()+s.getWidth()+20 && mouseY > s.getYStart()-20 && mouseY < s.getYStart()+s.getHeight()+20) {
        nearElement = true;
      }
    }


    // Display and update each button
    for (Button b : buttons.values()) {
      b.update();
      b.display();
    }
  }
}