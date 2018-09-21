/* Stephen Kaplan - September 17th, 2018 - NMD 160 Assignment #3
 This program launches 5 balls of random mass at random velocities, then applies physics to them to mimic the effects of gravity.
 Click mouse to begin program, click again to add more ball objects. Press R to reset. Press 3 to switch between 2D and 3D view.
 Press S to switch between simple collide and a method based on an example from Processing.org.
 Requires PostFX library.
 Version 1.1
 */

// Post FX imports and variable reference declarations
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

PostFX fx;

ArrayList<Ball> balls = new ArrayList<Ball>();

boolean start;
boolean show_3D;
boolean simpleCollide = true;

float easing = 0.05;
float vignetteAmount = 0.3;
float vignetteIntensity = 0.3;

float view3D_Amount = 0;



// Runs once - PostDX requires P3D for OpenGL
void setup() {
  size(1080, 720, P3D);

  fx = new PostFX(this);  // Instantiate PostFX object


  // Create 5 Ball objects to start with
  balls.add(new Ball(width/2-400, height/2));
  balls.add(new Ball(width/2-200, height/2));
  balls.add(new Ball(width/2, height/2));
  balls.add(new Ball(width/2+200, height/2));
  balls.add(new Ball(width/2+400, height/2));
}



// Runs every frame
void draw() {
  // Background brightness depends on view
  background(map(view3D_Amount, -500, 0, 50, 150));

  pushMatrix();
  strokeWeight(1);
  stroke(100);
  translate(0, 0, view3D_Amount);
  line(0, 0, 1000, 0, 0, view3D_Amount);
  line(0, height, 500, 0, height, view3D_Amount);

  line(width, 0, 1000, width, 0, view3D_Amount);
  line(width, height, 1000, width, height, view3D_Amount);

  translate(0, 0, view3D_Amount);
  fill(map(view3D_Amount, -500, 0, 70, 170));
  rect(0, 0, width, height);
  popMatrix();

  // Add 3D-ness to spheres
  lights();

  // Control by pressing 3
  if (show_3D) {
    float target3D = -500;
    float d3D = target3D - view3D_Amount;
    view3D_Amount += d3D * easing;
  } else {
    float target3D = -10;
    float d3D = target3D - view3D_Amount;
    view3D_Amount += d3D * easing;
  }

  for (int i=0; i<balls.size(); i++) {
    // Applying y-force of .005 will decrease vertical velocity when ball moves upward
    PVector f = new PVector(0, 0, 0);

    // Only cause movement if user has clicked mouse to begin
    if (start) {
      balls.get(i).applyForce(f); 
      balls.get(i).update();
    }

    balls.get(i).display();  // Display all objects in ArrayList balls regardless of "starting" or not
  }

  if (!start || balls.get(0).reset == true) {

    // Animate removal of vignette
    changeVignette(0.3, 0.3);

    fx.render() // Add filters to everything currently on screen
      .vignette(vignetteAmount, vignetteIntensity)
      .blur(50, 50) // Frosted glass effect
      .compose();

    // Splash screen
    pushMatrix();
    fill(0, 100);
    textSize(20);
    textAlign(CENTER, CENTER);
    translate(0, 0, 20);
    text("Made by Stephen Kaplan. Click to begin.", 0, 0, width, height);
    popMatrix();
  } else {

    // Animate addition of vignette
    changeVignette(0.4, 0.5);

    fx.render() // Remove frosted glass effect once user clicks mouse
      .vignette(vignetteAmount, vignetteIntensity)
      .compose();
  }

  if (keyPressed && (key == 'S' || key == 's')) {
    textAlign(LEFT);
    fill(255);
    text("SimpleCollide: "+simpleCollide, 50, height-50);
  }
}

// Constant detection of interaction through mouse
void mousePressed() {
  if (!start) {
    start = true;
  } else if (balls.get(0).reset == true) {
    for (int i=0; i<balls.size(); i++) {
      balls.get(i).newVelocity();
    }
  } else {
    balls.add(new Ball(mouseX, mouseY));
  }
}

// Constant detection of interaction through keyboard
void keyPressed() {  
  if (key == 'R' || key == 'r') {
    for (int i=0; i<balls.size(); i++) {
      balls.get(i).reset();  // Reset position of all balls
    }
  } else if (key == 'S' || key == 's') {
    simpleCollide = !simpleCollide;
  } else if (key == '3') {
    show_3D = !show_3D;
  }
}

// "Ease" vignette in using similar method to Easing example on Processing.org
void changeVignette(float targetAmount, float targetIntensity) {
  float dx = targetAmount - vignetteAmount;
  vignetteAmount += dx * easing;

  float dy = targetIntensity - vignetteIntensity;
  vignetteIntensity += dy * easing;
}