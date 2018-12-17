// Easy reference to UI elements
HashMap<String, Slider> sliders = new HashMap<String, Slider>();
HashMap<String, Button> buttons = new HashMap<String, Button>();


boolean begin = false;
void showControls() {

  if (!begin) {
    background(255);

    //-- COLOR SLIDERS --//
    sliders.put("Red", new Slider(0, 10, 10, 80, 180, "Red"));
    sliders.put("Green", new Slider(0, 100, 10, 80, 180, "Green"));
    sliders.put("Blue", new Slider(0, 190, 10, 80, 180, "Blue"));
    sliders.put("Size", new Slider(0, 280, 10, 80, 180, "Size"));

    // Initial value of sliders
    sliders.get("Red").setValue(4);
    sliders.get("Green").setValue(4);
    sliders.get("Blue").setValue(4);
    sliders.get("Size").setValue(5);

    // Broadcast states of sliders
    sliders.get("Size").setBroadcast(true);
    sliders.get("Red").setBroadcast(true);
    sliders.get("Green").setBroadcast(true);
    sliders.get("Blue").setBroadcast(true);

    // Colors of sliders
    sliders.get("Size").setPercentColor(color(30));
    sliders.get("Red").setPercentColor(color(190, 100, 100));
    sliders.get("Green").setPercentColor(color(100, 190, 100));  // Technically this is already the default, but I'll keep it in for clarity
    sliders.get("Blue").setPercentColor(color(100, 100, 190));


    //-- FIRST ROW OF BUTTONS --//-- VISUAL SELECTION --//
    buttons.put("1", new RectButton(480, 10, (width-550)/5, 200, color(100, 100, 255), color(10, 80), color(10, 80), false, "1"));
    buttons.put("2", new RectButton(490+(width-550)/5, 10, (width-550)/5, 200, color(110, 100, 255), color(10, 80), color(10, 80), false, "2"));
    buttons.put("3", new RectButton(500+(width-550)/5*2, 10, (width-550)/5, 200, color(120, 100, 255), color(10, 80), color(10, 80), false, "3"));
    buttons.put("4", new RectButton(510+(width-550)/5*3, 10, (width-550)/5, 200, color(130, 100, 255), color(10, 80), color(10, 80), false, "4"));
    buttons.put("5", new RectButton(520+(width-550)/5*4, 10, (width-550)/5, 200, color(140, 100, 255), color(10, 80), color(10, 80), false, "5"));

    // Broadcast visual selection to clients
    buttons.get("1").setBroadcast(true);
    buttons.get("2").setBroadcast(true);
    buttons.get("3").setBroadcast(true);
    buttons.get("4").setBroadcast(true);
    buttons.get("5").setBroadcast(true);


    //-- SECOND ROW OF BUTTONS --//-- FREE SONG SELECTION --//
    buttons.put("Empty Days", new RectButton(50, 250, (width-130)/4, 200, color(150, 100, 255), color(10, 80), color(10, 80), false, "Empty Days"));
    buttons.put("Beyond The Line", new RectButton(60+(width-130)/4, 250, (width-130)/4, 200, color(160, 100, 255), color(10, 80), color(10, 80), false, "Beyond The Line"));
    buttons.put("Endless Motion", new RectButton(70+(width-130)/4*2, 250, (width-130)/4, 200, color(170, 100, 255), color(10, 80), color(10, 80), false, "Endless Motion"));
    buttons.put("Seven Lights", new RectButton(80+(width-130)/4*3, 250, (width-130)/4, 200, color(180, 100, 255), color(10, 80), color(10, 80), false, "Seven Lights"));


    //-- THIRD ROW OF BUTTONS --//-- OTHER SONG SELECTION (Not packaged with final project) --//
    buttons.put("Footprints", new RectButton(50, 500, (width-130)/4, 200, color(190, 100, 255), color(10, 80), color(10, 80), false, "Footprints"));
    buttons.put("Footprints (Piano)", new RectButton(60+(width-130)/4, 500, (width-130)/4, 200, color(200, 100, 255), color(10, 80), color(10, 80), false, "Footprints (Piano)"));
    buttons.put("Baba Yetu", new RectButton(70+(width-130)/4*2, 500, (width-130)/4, 200, color(210, 100, 255), color(10, 80), color(10, 80), false, "Baba Yetu"));
    buttons.put("Elastic Heart", new RectButton(80+(width-130)/4*3, 500, (width-130)/4, 200, color(220, 100, 255), color(10, 80), color(10, 80), false, "Elastic Heart"));


    //-- SINGLE-USE BUTTONS --//
    buttons.put("Live", new CircleButton(width/2, height-(width)/5, (width/6), color(100), color(0), color(0), true, "Live"));
    buttons.put("Play/Pause", new CircleButton(50+(width/5), height-(height/5), (width/5), color(80, 80, 100, 100), color(40, 40, 60), color(0), true, "Play/Pause"));
    buttons.put("Set Background", new CircleButton(width-50-(width/5), height-(height/5), (width/5), color(100), color(10, 80), color(10, 80), true, "Set Background"));


    // Don't run this code again
    begin = !begin;
  } else {
    //-- Gradient Background --//
    beginShape(POLYGON);
    stroke(255);
    fill(255);
    vertex(0, 0);

    stroke(100, 255, 180);
    fill(255);
    vertex(width, 0);

    stroke(180, 100, 255);
    fill(180, 100, 255);
    vertex(width, height);

    stroke(100, 100, 255);
    fill(100, 100, 255);
    vertex(0, height);
    endShape(CLOSE);

    // Background button always shows current color
    float red = map(sliders.get("Red").getValue(), 0, 100, 0, 255);
    float green = map(sliders.get("Green").getValue(), 0, 100, 0, 255);
    float blue = map(sliders.get("Blue").getValue(), 0, 100, 0, 255);
    buttons.put("Set Background", new CircleButton(width-50-(width/5), height-(height/5), (width/5), color(red, green, blue), color(red/4, green/4, blue/4), color(0), true, "Set Background"));


    // Top bar
    noStroke();
    fill(10, 30);
    stroke(100, 20);
    rect(-10, -10, width+10, 230);


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