// Objects of this class represent "light" (maybe more loosely "data packets") and travel across the screen
class Light {
  float lightX, lightY;   //Position at any given time
  int lightSpeed;         // Rate of movement across screen
  int lightLength;        // Length of text
  color lightColor;       // Color of text

  int id;

  Light(float lX, float lY, int id_) {
    lightX = lX;
    lightY = lY;
    id = id_;

    lightSpeed = round(random(1, 4)); // Using round() to include 4, could also use int() but would need random(1, 5) instead
    lightLength = lightSpeed*10;      // Length based on random speed

    int rg = int(random(200, 256));
    lightColor = color(100, rg, 100); // All lights have (slightly) random green color
  }

  void update() {
    if (!paused) { // Controlled by pressing P
      if (lightX > width) {
        lightX = -lightLength*textWidth("0"); // Reset position, take length into account
      } else {
        lightX += lightSpeed+fft.getFreq(id*10)/5; // Speed partially based on intensity of sound for ID
      }
    }
  }

  void display() {
    fill(lightColor);

    String binary = "";
    for (int i=0; i<lightLength; i++) {
      binary += ""+int(random(0, 2)); // String will contain sequence of 0s and 1s, greater speed => greater length => more 0s and 1s
    }

    textSize(15);
    text(binary, lightX, lightY);
  }
}