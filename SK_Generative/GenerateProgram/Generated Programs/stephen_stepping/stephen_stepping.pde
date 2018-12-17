/*
 * Program generated on 17/12/2018 at 10:25:5.
 */

// Versioning to keep track of changes
String version = "1.0";

// Wait until users interacts to begin generative piece
boolean begin = false;

// Dot list to manipulate
ArrayList<Dot> dots = new ArrayList<Dot>();
int amount = 233;


//Runs once when program is started
void setup() {
	size(1440, 760);
	background(10);

	for (int i=0; i<amount; i++) {
		dots.add(new Dot(0,0));
	}
}


//Runs every frame
void draw() {
	if (!begin) {
		// Display dark background until user interacts
		background(10);
		textAlign(CENTER, CENTER);
		fill(255);
		text("Click to begin", 0, 0, width, height);
	} else {

		pushMatrix();
		translate(width/2, height/2);
		for (int i=0; i<dots.size(); i++) {
			dots.get(i).update();
			dots.get(i).display();
		}

		popMatrix();

		// Display rotated text - Based on a root in your name
		pushMatrix();
		translate(width/2, height/2);
		rotate(degrees(888));
		textSize(width/8);
		fill(249.0, 55.0, 93.0, 5);
		text("stepping",0,0);
		popMatrix();

	}

}


