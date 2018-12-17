//*****************************//
//     PROGRAM  GENERATION     //
//*****************************//

// Used to stop misinterpreting color selection as button click
int wait = 10;

//-- PROGRAM DATA --//
// Scene 0
String startTimeString = "";   // Time of running this program
int startTimeNumber = 0;
int previousStartTime = 0;     // Previous iteration's time of run

// Scene 1
String name = "";              // User's name (Expected first name, but does not ultimately matter)
String nameRoot = "";          // First root of user's name that has more than 5 superstrings
String adj = "";               // Adjective superstring of root of user's name

// Scene 2
String word = "";              // User-entered word
String rhyme = "";             // Rhyme of user-entered word

// Scene 3
String myNumber = "";          // User-entered number

// Scene 4
color myColor = color(0);      // User-selected color
float timeToSelect = 0;        // Time it takes for the user to select a color (in frames)

// Finalization
String programName = "";       // Name of generated program


void showResult() {
  // Preview user-select color
  background(myColor);


  // Results container
  fill(10, 100);
  stroke(20, 50);
  strokeWeight(10);
  rect(100, 100, width-200, height-200, 5);

  fill(255);

  // User-entered data
  textAlign(LEFT, TOP);
  textSize(15);
  text("Start Time: "+startTimeString+"\n\n"+

    "Your Name: "+name+"\n"+
    "Name Length: "+name.length()+"\n"+
    "Name Root: "+nameRoot+"\n\n"+

    "Word: "+word+"\n"+
    "Word Length: "+word.length()+"\n"+
    "Rhyme: "+rhyme+"\n\n"+

    "3-Digit Number: "+myNumber+"\n"+
    "Parity: "+parseInt(myNumber)%2+"\n\n"+

    "Color: rgb("+red(myColor)+", "+green(myColor)+", "+blue(myColor)+")\n"+
    "Time To Select: "+timeToSelect+" frames", 150, 200, width, height);


  // "was used for" (Not necessarily the best way to program this, but it gets the job done)
  text("--->\n\n"+

    "--->\n"+
    "--->\n"+
    "--->\n\n"+

    "--->\n"+
    "--->\n"+
    "--->\n\n"+

    "--->\n"+
    "--->\n\n"+

    "--->\n"+
    "--->", width/2-20, 200, width, height);


  // Where data went in terms of generated program
  text("Color Function: "+(startTimeNumber-previousStartTime)+" + "+previousStartTime+" (Previous) -> "+startTimeNumber+"\n\n"+

    "Program Name: "+programName+"\n"+
    "Dot rotation\n"+
    "See program name. Rotated text.\n\n"+

    "Dot shape\n"+
    "Dot rotation\n"+
    "Color function\n\n"+

    "Text Rotation, Window Dimensions\n"+
    "Dot Placement (Build-up vs. Pre-built array)\n\n"+

    "Background Color, Position functions\n"+
    "Size and shape of dots", width/2+60, 200, width, height);


  // Results title
  textAlign(CENTER, CENTER);
  textSize(30);
  text("Your Program Data", 0, 80, width, 125);


  // Buttons
  if (wait == 0) {

    pushStyle();
    rectMode(CENTER);

    int button1 = button(width/2-200, height/1.25, 300, 100, "Restart");
    if (button1 == 1) {  // Reset everything, start from beginning
      scene = 0;
      begin = false;

      // Scene 0 - RESET
      previousStartTime = startTimeNumber;
      startTimeString = hour()+":"+minute()+":"+second();
      startTimeNumber = startTimeNumber+hour()+minute()+second();
      // Scene 1
      name = "";
      nameRoot = "";
      // Scene 2
      word = "";
      rhyme = "";
      // Scene 3
      myNumber = "";
      // Scene 4
      myColor = color(0);
    }

    int button2 = button(width/2+200, height/1.25, 300, 100, "Show Me My Program");
    if (button2 == 1) {  // Go to folder
      exec("open", sketchPath("Generated Programs/"+programName));
    }

    popStyle();
  } else {
    wait--;
  }
}



void finalize() {
  //-- Turn user-entered data into usable information --//

  // RiTa Library used for Word Manipulation
  RiLexicon lexicon;
  lexicon = new RiLexicon();
  String[] supers = {};
  String temp = name;

  // name => Program name, adjective from based
  int n = temp.length();
  do {
    temp = temp.substring(0, n).toLowerCase();

    supers = lexicon.superstrings(temp);

    n = n-1;
  } while (supers.length <= 1);

  // Root of name used is one with first list of words with more than 5 entries
  nameRoot = temp;


  // Rhyme of name => Color function
  String[] possibleRhymes = RiTa.rhymes(word);
  if (possibleRhymes.length > 0) {
    rhyme = possibleRhymes[int(random(possibleRhymes.length))];
  } else {
    rhyme = word;
  }


  // Program Name => Name_Adjective
  n = 0;
  do {
    if (n<supers.length) {
      adj = supers[n];
    } else {
      adj = "absent";
    }

    n++;
  } while (!RiTa.isAdjective(adj));
  programName = name+"_"+adj;




  //-- Create necesarry files --//

  // Create main file if none exists
  mainFile = createWriter("Generated Programs/"+programName+"/"+programName+".pde");


  // Create extra files if they don't already exist, add references to list
  for (int i=0; i<amountOfExtraFiles; i++) {
    extraFiles.add(createWriter("Generated Programs/"+programName+"/"+classNames[i]+".pde"));
    classPrograms.add(new ArrayList<String>());
  }


  // Add pre-setup, setup, and draw blocks to main file
  mainProgram.add(generatePreSetup());
  mainProgram.add(generateSetup());
  mainProgram.add(generateDraw());


  // Add other blocks to respective extra file
  for (int i=0; i<amountOfExtraFiles; i++) {
    classPrograms.get(i).add(generateClass(classNames[i]));
  }


  //-- Generate program --//
  // Write main file
  for (int i=0; i<mainProgram.size(); i++) {
    mainFile.println(mainProgram.get(i));
  }

  // Close main file
  mainFile.flush();
  mainFile.close();


  // Write extra files
  for (int i=0; i<classPrograms.size(); i++) {
    for (int o=0; o<classPrograms.get(i).size(); o++) {
      extraFiles.get(i).println(classPrograms.get(i).get(o));
    }

    // Close extra files
    extraFiles.get(i).flush();
    extraFiles.get(i).close();
  }


  mainProgram.clear();
  classPrograms.clear();
  extraFiles.clear();
}




String generatePreSetup() {
  String version = "1.0";
  String description = "Program generated on "+day()+"/"+month()+"/"+year()+" at "+hour()+":"+minute()+":"+second()+".";

  String line = "/*\n * "+description+"\n */\n\n";

  line += "// Versioning to keep track of changes\nString version = \""+version+"\";\n\n";
  line += "// Wait until users interacts to begin generative piece\nboolean begin = false;\n\n";
  line += "// Dot list to manipulate\nArrayList<Dot> dots = new ArrayList<Dot>();\n";

  if (parseInt(myNumber)%2 == 0) { // Slow building
    line += "int amount = "+int(random(500))+";\n\n";
  } else { // Array already built
    line += "int amount = "+int(random(50, min(timeToSelect/3.0, 200)))+";\n\n";
  }

  return line;
}



String generateSetup() {
  // Setup Header
  String line = "//Runs once when program is started\nvoid setup() {\n";

  // Size
  float w = min(parseFloat(myNumber)*2, 1440);
  float h = min(parseFloat(myNumber)*1.5, 760);

  w = max(w, 200);
  h = max(h, 200);
  line += "\tsize("+int(w)+", "+int(h)+");\n";

  // Background
  line += "\tbackground(10);\n\n";

  if (parseInt(myNumber)%2 == 0) { // Slow building
    line += "\tfor (int i=0; i<amount; i++) {\n";
    line += "\t\tdots.add(new Dot(0,0));\n";
    line += "\t}\n";
  } else { // Array already built
    line += "\tfor (int y=0; y<=height; y+=width/amount) {\n";
    line += "\t\tfor (int x=0; x<=width; x+=height/amount) {\n";
    line += "\t\t\tdots.add(new Dot(x,y));\n";
    line += "\t\t}\n";
    line += "\t}\n";
  }

  line += "}\n\n";
  return line;
}



String generateDraw() {
  float r = red(myColor);
  float g = green(myColor);
  float b = blue(myColor);

  float rOp = 255-red(myColor);
  float gOp = 255-green(myColor);
  float bOp = 255-blue(myColor);

  String rotateFunction = "";
  if (name.length() < 4) {
    rotateFunction = "frameCount/10.0";
  } else if (name.length() < 6) {
    rotateFunction = "(frameCount/10.0)*100";
  } else if (name.length() < 600) {
    rotateFunction = "frameCount/"+(myNumber+1)+".0";
  }


  // Draw Header
  String line = "//Runs every frame\nvoid draw() {\n";


  // Background - Selected Color
  line += "\tif (!begin) {\n";
  line += "\t\t// Display dark background until user interacts\n\t\tbackground(10);\n";
  line += "\t\ttextAlign(CENTER, CENTER);\n";
  line += "\t\tfill(255);\n";
  line += "\t\ttext(\"Click to begin\", 0, 0, width, height);\n";
  line += "\t} else {\n\n";


  // Display dot objects 
  // Position relative to center if myNumber is even
  if (parseInt(myNumber)%2 == 0) {
    line += "\t\tpushMatrix();\n";
    line += "\t\ttranslate(width/2, height/2);\n";

    // Rotate around center if word length is odd
    if (word.length()%2 == 1) {
      line += "\t\trotate("+rotateFunction+");\n\n";
    }
  }
  line += "\t\tfor (int i=0; i<dots.size(); i++) {\n";
  line += "\t\t\tdots.get(i).update();\n";
  line += "\t\t\tdots.get(i).display();\n";
  line += "\t\t}\n\n";

  if (parseInt(myNumber)%2 == 0) {
    line += "\t\tpopMatrix();\n\n";
  }


  // Background Text - Adjective, Number
  line += "\t\t// Display rotated text - Based on a root in your name\n";
  line += "\t\tpushMatrix();\n";
  line += "\t\ttranslate(width/2, height/2);\n";
  line += "\t\trotate(degrees("+myNumber+"));\n";
  line += "\t\ttextSize(width/"+adj.length()+");\n";
  line += "\t\tfill("+rOp+", "+gOp+", "+bOp+", 5);\n";
  line += "\t\ttext(\""+adj+"\",0,0);\n";
  line += "\t\tpopMatrix();\n\n";

  line += "\t}\n\n";

  line += "}\n\n";
  return line;
}



String generateClass(String name) {
  float r = red(myColor);
  float g = green(myColor);
  float b = blue(myColor);

  if (name == "Dot") {

    // Rotation function used when word length is even
    String rotateFunction = "";
    if (name.length() < 4) {
      rotateFunction = "frameCount/10.0";
    } else if (name.length() < 6) {
      rotateFunction = "(frameCount/10.0)*100";
    } else if (name.length() < 8) {
      rotateFunction = "frameCount/"+(myNumber+1)+".0";
    } else if (name.length() < 10) {
      rotateFunction = "pow(frameCount, 0.2)";
    } else {
      rotateFunction = "pow(dist(xpos, ypos, width/2, height/2), 0.4)";
    }


    // Color function used when word length is even
    String colorFunction = "";
    if (startTimeNumber < 80) {
      colorFunction = "100+sin(id+frameCount/"+rhyme.length()+".0)*100, dist(xpos, ypos, width/2, height/2), 0";
    } else if (startTimeNumber < 100) {
      colorFunction = "0, dist(xpos, ypos, width/2, height/2), 100+sin(id+frameCount/"+rhyme.length()+".0)*100";
    } else if (startTimeNumber < 120) {
      colorFunction = "100+sin(id+frameCount/"+rhyme.length()+".0)*100, 0, dist(xpos, ypos, width/2, height/2)";
    } else if (startTimeNumber < 140) {
      colorFunction = "0, 100+sin(id+frameCount/"+rhyme.length()+".0)*100, dist(xpos, ypos, width/2, height/2)";
    } else if (startTimeNumber < 160) {
      colorFunction = "dist(xpos, ypos, width/2, height/2), 100+sin(id+frameCount/"+rhyme.length()+".0)*100, 0";
    } else if (startTimeNumber < 180) {
      colorFunction = "dist(xpos, ypos, width/2, height/2), 0, 100+sin(id+frameCount/"+rhyme.length()+".0)*100";
    } else if (startTimeNumber < 200) {
      colorFunction = "dist(xpos, ypos, width/2, height/2), 0, 100+tan(id+frameCount/"+rhyme.length()+".0)*100";
    } else if (startTimeNumber < 220) {
      colorFunction = "dist(xpos, ypos, width/2, height/2), 0, 100+tan(id+frameCount/"+rhyme.length()+".0)*100";
    } else if (startTimeNumber < 240) {
      colorFunction = "100+sin(id+frameCount/"+rhyme.length()+")*100, 0, id%255";
    } else if (startTimeNumber < 260) {
      colorFunction = "id%255, 100+sin(id+frameCount/"+rhyme.length()+")*100, 0";
    } else if (startTimeNumber < 260) {
      colorFunction = "0, id%255, 100+sin(id+frameCount/"+rhyme.length()+")*100";
    } else {
      colorFunction = "255*(id+frameCount)%"+rhyme.length()+".0";
    }


    // Position functions
    String xFunction = "";
    String yFunction = "";
    if (r < 30) {
      xFunction = ""+random(2);
      yFunction = ""+random(2);
    } else if (r < 60 || g > 110 || b > 90) {
      xFunction = "tan(id/10.0)";
      yFunction = "0";
    } else if (r < 90 || g > 90 || b > 60 ) {
      xFunction = "id";
    } else {
      xFunction = "0";
      yFunction = "tan(id/10.0)";
    }

    // Shape Selection
    String shape = "";
    if (timeToSelect < 200) {
      shape = "circ";
    } else if (timeToSelect < 400) {
      shape = "rect";
    } else {
      shape = "tri";
    }

    float ran = random(90);

    // Constructor
    String line = "class Dot {\n";
    line += "\t// Class Attributes\n";
    line += "\tfloat xpos, ypos;\n";
    
    if (shape.equals("circ") || shape.equals("rect")) {
      line += "\tfloat sizeX;\n\tfloat sizeY;\n";
    }else{
      line += "\tfloat size;\n";
    }
    
    line += "\tfloat opacity;\n";
    line += "\tcolor c;\n";
    line += "\tint id;\n\n";
    line += "\t// Parameterized Constructor\n\tDot(float xpos_, float ypos_) {\n";
    line += "\t\txpos = xpos_;\n";
    line += "\t\typos = ypos_;\n";
    line += "\t\tid = dots.size();\n";


    if (shape.equals("circ") || shape.equals("rect")) {
      line += "\t\tsizeX = width/amount*"+random(1.5)+";\n";
      line += "\t\tsizeY = height/amount*"+random(1.5)+";\n";
    }else{
      line += "\t\tsize = width/amount*"+random(1.5)+";\n";
    }

    if (ran < 30) {
      line += "\t\tc = color(random(255), 0, 0);\n";
    } else if (ran < 60) {
      line += "\t\tc = color(0, random(255), 0);\n";
    } else {
      line += "\t\tc = color(0, 0, random(255));\n";
    }

    line += "\t\topacity = 255;\n";

    line += "\t}\n\n";



    // Update
    line += "\tvoid update() {\n";

    line += "\t\tc = color("+colorFunction+");\n";

    if (parseInt(myNumber)%2 == 0) {
      line += "\t\txpos += "+xFunction+";\n";
      line += "\t\typos += "+yFunction+";\n";
    }
    line += "\t\topacity *= "+random(0.99, 1.0)+";\n\n";
    line += "\t}\n\n";



    // Display
    line += "\tvoid display() {\n";
    line += "\t\tpushMatrix();\n";
    if (word.length()%2 == 0 && parseInt(myNumber)%2 == 0) {
      line += "\t\trotate("+rotateFunction+");\n";
    }
    line += "\t\tfill(c, opacity);\n";
    line += "\t\tnoStroke();\n";

    if (shape.equals("circ")) {
      line += "\t\tellipse(xpos, ypos, sizeX, sizeY);\n";
    } else if (shape.equals("rect")) {
      line += "\t\trect(xpos, ypos, sizeX, sizeY);\n";
    } else if (shape.equals("tri")) {
      line += "\t\ttriangle(xpos, ypos, xpos+size/2, ypos+size/2, xpos, ypos+size);\n";
    }

    line += "\t\tpopMatrix();\n";


    line += "\t}\n";
    line += "}\n\n";
    return line;
  } else if (name == "Interaction") {

    String line = "void mousePressed() {\n";
    line += "\tif (!begin) {\n";

    // Set background color for slow building pieces
    line += "\t\t//Display selected background after interaction has been detected\n\t\tbackground("+r+", "+g+", "+b+");\n";

    line += "\t\tbegin = !begin;\n";
    line += "\t}\n";
    line += "}\n\n";
    return line;
  }

  return "// Nothing here yet!";
}