/* Stephen Kaplan - September 12th, 2018 - NMD 160 Assignment #2
 This program, base on an initial class example, has "lights" (in the form of strings of 0 and 1s) that continuously move across the screen.
 The program uses the PostFX library to acheive an elegant look.
 Requires Minim and PostFX libraries.
 Version 1.0
 */


// Post FX imports and variable reference declarations
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioPlayer song;
FFT         fft;

PostFX fx;

ArrayList<Light> lights = new ArrayList<Light>();

boolean paused = false;


// Run once - PostDX requires P2D for OpenGL
void setup() {
  fullScreen(P2D);
  background(0,15,21);

  fx = new PostFX(this);  // Instantiate PostFX object

  // Minim Setup
  minim = new Minim(this);
  song = minim.loadFile("Livio_Amato_-_11_-_Yet_a_moment_once_again.mp3", 1024);
  fft = new FFT( song.bufferSize(), song.sampleRate() ); // Breaks down soundfile into individual frequencies to work with
  song.loop();

  lights.add(new Light(width/2, height/2, 0)); // Begin with one light object
}


// Run every frame
void draw() {
  fft.forward( song.mix ); // Begin FFT analysis
  
  background(0, 15-fft.getFreq(10), 21); // Dark BG for contrast
  
  noCursor();

  for (int i=0; i<lights.size(); i++) { // Move and show all light objects in lights ArrayList
    lights.get(i).update();
    lights.get(i).display();
  }
  
  fill(200, 20);
  noStroke();
  ellipse(mouseX, mouseY, 10, 10);

  fx.render() // Add filters to everything currently on screen
    .chromaticAberration()
    .bloom(.9, 10, 50)
    .compose();

  if (lights.size() < 2) {
    fill(255);
    textAlign(CENTER, CENTER);
    text("Click more or press R to add more lights.", 0, height-100, width, 100);
  }
}


// Add one light object as mouse position by clicking (left, right, and middle click all work)
void mousePressed() {
  lights.add(new Light(mouseX, mouseY, lights.size()));
}


// Further interaction with the keyboard
void keyPressed() {
  if (key == 'R' || key == 'r') { // Press R to generate 50 randomly placed lights
    for (int i=0; i<50; i++) {
      lights.add(new Light(random(width), random(height), lights.size()));
    }
  } else if (key == 'P' || key == 'p') { // Press P to pause/unpause all movement
    paused = !paused;
  }
}