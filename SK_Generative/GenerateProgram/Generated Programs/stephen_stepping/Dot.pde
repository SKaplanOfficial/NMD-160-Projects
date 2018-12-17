class Dot {
	// Class Attributes
	float xpos, ypos;
	float size;
	float opacity;
	color c;
	int id;

	// Parameterized Constructor
	Dot(float xpos_, float ypos_) {
		xpos = xpos_;
		ypos = ypos_;
		id = dots.size();
		size = width/amount*1.2612681;
		c = color(random(255), 0, 0);
		opacity = 255;
	}

	void update() {
		c = color(dist(xpos, ypos, width/2, height/2), 0, 100+tan(id+frameCount/5.0)*100);
		xpos += 1.5294094;
		ypos += 1.890481;
		opacity *= 0.9926155;

	}

	void display() {
		pushMatrix();
		rotate(frameCount/10.0);
		fill(c, opacity);
		noStroke();
		triangle(xpos, ypos, xpos+size/2, ypos+size/2, xpos, ypos+size);
		popMatrix();
	}
}


