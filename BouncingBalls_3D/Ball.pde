// Objects of this class mimic real-world physics
class Ball {
  PVector location, velocity, acceleration;
  int originalX;
  float mass;

  color c;
  boolean reset;
  float wait;

  Ball(int x_, int y_) {
    location = new PVector(x_, y_, 0);
    originalX = x_;

    if (show_3D) {
      velocity = new PVector(random(-1, 1)*5, random(-1, 1)*5, random(-1, 1)*5);
    } else {
      velocity = new PVector(random(-1, 1)*5, random(-1, 1)*5, 0);
    }
    acceleration = new PVector(0, 0, 0);

    // Eventually make non-random mass?
    mass = random(1, 5);

    c = color(random(255), 0, random(255));
  }

  // Method to move ball objects
  void update() {

    // Bring to front if not viewing in 3D mode
    if (!show_3D) {
      float targetZ = 0;
      float dZ = targetZ - location.z;
      location.z += dZ * easing;

      float targetVZ = 0;
      float dVZ = targetVZ - velocity.z;
      velocity.z += dVZ * easing;
    }

    if (reset) { // Reset position to initial
      float targetX = originalX;
      float dx = targetX - location.x;
      location.x += dx * easing;

      float targetY = height/2;
      float dy = targetY - location.y;
      location.y += dy * easing;

      float targetZ;
      if (show_3D) {
        targetZ = -100;
      } else {
        targetZ = 0;
      }
      float dZ = targetZ - location.z;
      location.z += dZ * easing;
    } else { // If not resetting, motion based on physics

      for (int i=0; i<balls.size(); i++) {
        if (balls.get(i) != this) {
          checkCollision(balls.get(i));
        }
      }

      velocity.add(acceleration);
      location.add(velocity);

      //velocity.x *= map(mass, 1, 5, 0.99, 0.999); // Decrease horizontal velocity, due to "friction" perhaps

      if (location.x > width-mass/1.5) {
        location.x = width-mass/1.5; // Daniel Shiffman had this in his tutorial -- I don't see any difference having it or not having it?
        velocity.x *= -1;

        c = color(blue(c), 0, red(c)); // When ball hits border, alternate between two colors by switching red and blue values
      }

      if (location.x < 0+mass/1.5) {
        location.x = 0+mass/1.5;
        velocity.x *= -1;

        c = color(blue(c), 0, red(c));
      }

      if (location.y > height-mass/1.5) {
        location.y = height-mass/1.5;
        velocity.y *= -1;

        if (acceleration.y < abs(velocity.y)) {
          c = color(blue(c), 0, red(c));
        }
      }

      if (location.y < 0+mass/1.5) {
        location.y = 0+mass/1.5;
        velocity.y *= -1;

        c = color(blue(c), 0, red(c));
      }

      if (location.z > 0+mass/1.5) {
        location.z = 0+mass/1.5;
        velocity.z *= -1;

        c = color(blue(c), 0, red(c));
      }

      if (location.z < -1000) {
        location.z = -1000;
        velocity.z *= -1;

        c = color(blue(c), 0, red(c));
      }
    }
  }

  // Method to relate movement of ball objects to F=MA
  void applyForce(PVector force) {
    force.div(mass);
    acceleration.add(force);
  }

  // Triggered when user presses 'R'
  void reset() {
    reset = true;
  }

  // Triggered when user clicks mouse AFTER having pressed 'R' to reset
  void newVelocity() {
    reset = false;

    if (show_3D) {
      velocity = new PVector(random(-1, 1)*5, random(-1, 1)*5, random(-1, 1)*5);
    } else {
      velocity = new PVector(random(-1, 1)*5, random(-1, 1)*5, 0);
    }
  }

  // Checks if another ball comes in contact with this one, then applies physics on both
  void checkCollision(Ball other) {
    float dist = dist(location.x, location.y, location.z, other.location.x, other.location.y, other.location.z);
    float dx = other.location.x - location.x;
    float dy = other.location.y - location.y;
    float dz = other.location.z - location.z;

    if (dist < (mass*15 + other.mass*15)) {
      if (simpleCollide) { // Toggle with 'S'
        velocity.div(-1);
        location.add(velocity);
        other.velocity.div(-1);
        other.location.add(other.velocity);
      } else { // Based on the "BouncyBubbles" example on Processing.org
        float angle = atan2(dy, dx);
        float targetX = location.x + cos(angle) * (mass*15 + other.mass*15);
        float targetY = location.y + sin(angle) * (mass*15 + other.mass*15);

        angle = atan2(dz, dy);
        float targetZ = location.z + sin(angle) * (mass*15 + other.mass*15);

        float ax = (targetX - other.location.x) * 0.1; // 2D collision is the same as example
        float ay = (targetY - other.location.y) * 0.1;
        float az;  // Added 3D collision myself

        if (show_3D) { // Only influence z velocities when view_3D is true
          az = (targetZ - other.location.z) * 0.1;
        } else {
          az = 0;
        }
        PVector av = new PVector(ax, ay, az);
        velocity.sub(av);
        other.velocity.add(av);
      }

      c = color(random(255), 0, random(255));
      other.c = c = color(random(255), 0, random(255));
    }
  }

  // Method to display ball object
  void display() {
    fill(c);
    pushMatrix();
    translate(location.x, location.y, location.z);
    sphereDetail(20);
    if (show_3D) { // Spheres if 3D
      noStroke();
      sphere(mass*15);
    } else { // Ellipses if 2D
      stroke(red(c)*1.5, 0, blue(c)*1.5, 100);
      strokeWeight(mass*3);
      ellipse(0, 0, mass*30, mass*30);
    }
    popMatrix();
  }
}