PImage[] carImages;             // Car Textures

// A class for Scenes (levels) in the game Frogger. Includes functional game elements as well as (basic) memory management.
class Scene {
  int id;                    // Location of this scene in scenes array

  PImage frogImage_still;    // Landed/unmoving frog
  PImage frogImage_jumping;  // Mid-jump from (Currently unused)
  PImage roadImage;          // Asphalt Texture
  PImage grassImage;         // Grass Texture
  PImage logImage;           // Log Texture
  PImage lilyPadImage;       // Lily Pad Texture


  JSONObject json;           // Information loaded from data.json
  String name;  
  String catchPhrase;
  String difficultyName;
  int difficulty;
  String[] layout;


  // Per-scene object arrays
  ArrayList<River> rivers = new ArrayList<River>();
  ArrayList<Road> roads = new ArrayList<Road>();
  ArrayList<Safezone> safeZones = new ArrayList<Safezone>();
  ArrayList<PowerUp> powerUps = new ArrayList<PowerUp>();
  ArrayList<EndPoint> endPoints = new ArrayList<EndPoint>();

  // Per-scene frogger
  Frog frogger;


  // Constructor - Only id is needed to load json data to fill all other attributes
  Scene(int id_) {
    id = id_;
  }


  // Currently unused, but kept for easy access later
  void update() {
  }


  // Run ~60 times per second
  void display() {

    // Rivers have lowest priority. Display them first.
    for (int i=0; i<rivers.size(); i++) {
      rivers.get(i).update();
      rivers.get(i).display();
    }

    // Safezones second.
    for (int i=0; i<safeZones.size(); i++) {
      safeZones.get(i).update();
      safeZones.get(i).display();
    }

    // Roads third.
    for (int i=0; i<roads.size(); i++) {
      roads.get(i).update();
      roads.get(i).display();
    }


    // Logs fourth
    for (int i=0; i<rivers.size(); i++) {
      // Only move cars if frogger is alive
      if (frogger.alive()) {
        rivers.get(i).updateLogs();
      }

      rivers.get(i).displayLogs();
    }

    // EndPoints fifth.
    for (int i=0; i<endPoints.size(); i++) {
      endPoints.get(i).display();
      endPoints.get(i).update();
    }

    // PowerUps sixth.
    for (int i=0; i<powerUps.size(); i++) {
      powerUps.get(i).display();
      powerUps.get(i).update();
    }

    // Frogger second to last.
    if (frogger != null) {
      frogger.update();
      frogger.display();
    }

    // Cars last  (highest priority -> always on top)
    for (int i=0; i<roads.size(); i++) {
      // Only move cars if frogger is alive
      if (frogger.alive()) {
        roads.get(i).updateCars();
      }

      roads.get(i).displayCars();
    }
  }


  // Retrieve data from json file
  void loadData() {
    // Location
    json = loadJSONObject("./Scenes/"+id+"/data.json");

    // Set name of scene - Ignore label ("Name: ")
    name = json.getString("name");
    log("\tName: "+name);

    catchPhrase = json.getString("catchPhrase");
    log("\tCatchphrase: "+catchPhrase);

    // Set difficulty - Currently unused, later indicate difficult at level selection
    difficultyName = json.getString("difficulty");
    if (difficultyName.equals("---")) {
      difficulty = -1;
      log("\tNo difficulty set.");
    } else if (difficultyName.equals("Easy")) {
      difficulty = 0;
      log("\tDifficulty: Easy");
    } else if (difficultyName.equals("Medium")) {
      difficulty = 1;
      log("\tDifficulty: Medium");
    } else if (difficultyName.equals("Hard")) {
      difficulty = 2;
      log("\tDifficulty: Hard");
    }

    // Symbol-based map of level
    String arrayText = "";      // To be logged
    int safezoneAmount = 0;     // Count each zone amount (to be logged)
    int roadAmount = 0;
    int riverAmount = 0;
    int powerUpAmount = 0;
    int endPointAmount = 0;
    int totalCarAmount = 0;
    int totalLogAmount = 0;
    int totalLilyPadAmount = 0;

    log("\tLoading object map...");
    JSONArray test = json.getJSONArray("layout");

    layout = new String[test.size()];
    float numberOfRows = test.size()/11;
    heightOfRow = height/numberOfRows;

    // Layout array is 12 rows long and 11 columns across
    // Move through all values in array
    for (int y=0; y<numberOfRows; y++) {
      for (int x=0; x<11; x++) {
        // Current position
        int pos = x+y*11;

        // Add value at position to logged string
        arrayText += "\t"+test.getString(pos);

        // Transfer JSON Array into useable array in Processing
        layout[pos] = test.getString(pos);

        // Check symbols in array & populate ArrayLists with respective features
        if (layout[pos].equals("E")) {               // End row
          safeZones.add(new Safezone(y*heightOfRow));
          // Increment count of this row type
          safezoneAmount++;
        } else if (layout[pos].equals("S")) {                  // Safespot row
          safeZones.add(new Safezone(y*heightOfRow));
          safezoneAmount++;
        } else if (layout[pos].equals("B")) {                  // Beginning row
          safeZones.add(new Safezone(y*heightOfRow));
          safezoneAmount++;
        } else if (layout[y*11].equals("R") && x==10) {        // Road row
          // Find number and direction of movement of cars in this row
          int numberOfCars = abs(parseInt(layout[2+y*11]));
          int directionOfCars = (parseInt(layout[2+y*11]) < 0) ? -1: 1;
          totalCarAmount += numberOfCars;

          if (layout[1+y*11].equals("-1")) {                   // Normal road
            roads.add(new Road(y*heightOfRow, 0, 0, numberOfCars, directionOfCars));
            roadAmount++;
          } else if (layout[1+y*11].equals("1")) {             // Upper white line
            roads.add(new Road(y*heightOfRow, 1, 0, numberOfCars, directionOfCars));
            roadAmount++;
          } else if (layout[1+y*11].equals("2")) {             // Lower white line
            roads.add(new Road(y*heightOfRow, 2, 0, numberOfCars, directionOfCars));
            roadAmount++;
          } else if (layout[1+y*11].equals("3")) {             // Middle yellow lines
            roads.add(new Road(y*heightOfRow, 0, 1, numberOfCars, directionOfCars));
            roadAmount++;
          }
        } else if (layout[y*11].equals("W") && x==10) {                  // Water/River row
          performanceModifier *= 1.25;
          int numberOfLogs = parseInt(layout[1+y*11]);

          if (numberOfLogs >= 0) {
            totalLogAmount += numberOfLogs;
          } else {
            totalLilyPadAmount += abs(numberOfLogs);
          }

          rivers.add(new River(y*heightOfRow, numberOfLogs));
          riverAmount++;
        } else if (layout[pos].equals("P")) {                  // Power Ups (At a specific spot)
          powerUps.add(new PowerUp(x*(width/10), y*heightOfRow));
          powerUpAmount++;
        } else if (layout[pos].equals("x")) {                  // End point (At a specific spot)
          endPoints.add(new EndPoint(x*(width/10), y*heightOfRow));
          endPointAmount++;
        } else if (layout[pos].equals("F")) {                  // Frogger (At a specific spot)
          frogger = new Frog(x*(width/10), y*heightOfRow);
        }
      }
      // Start new row of array in log
      arrayText += "\n";
    }

    // Log information
    log(arrayText);
    log("\t"+safezoneAmount+" Safezone rows found.");
    log("\t"+roadAmount+" Road rows found.");
    log("\t"+riverAmount+" River rows found.\n");

    log("\t"+endPointAmount+" End points found.");
    log("\t"+powerUpAmount+" Power Ups found.\n");

    log("\t"+totalCarAmount+" Cars found.\n");

    log("\t"+totalLogAmount+" Logs found.");
    log("\t"+totalLilyPadAmount+" Lily pads found.\n");
  }


  // Bring in assets from this scene's Assets folder
  void loadAssets() {

    // Frogger Images
    String imgLocation = "./Scenes/"+id+"/Assets/frogImage_still.png";
    frogImage_still = loadImage(imgLocation);

    // Eventually, add animation when jumping
    //imgLocation = "./Scenes/"+id+"/Assets/frogImage_jumping.png";
    frogImage_jumping = loadImage(imgLocation);

    frogger.setImages(frogImage_still, frogImage_jumping);

    // Car Textures
    int numCarImages = getFolders(sketchPath("Scenes/"+currentScene+"/Assets/Cars/"));
    carImages = new PImage[numCarImages];

    for (int i=0; i<numCarImages; i++) {
      imgLocation = "./Scenes/"+id+"/Assets/Cars/"+i+".png";
      carImages[i] = loadImage(imgLocation);
    }

    // Road texture
    imgLocation = "./Scenes/"+id+"/Assets/roadImage.png";
    roadImage = loadImage(imgLocation);

    for (int i=0; i<roads.size(); i++) {
      roads.get(i).setImage(roadImage);
      for (int o=0; o<roads.get(i).cars.size(); o++) {
        roads.get(i).cars.get(o).setImages();
      }
    }

    imgLocation = "./Scenes/"+id+"/Assets/logImage.png";
    logImage = loadImage(imgLocation);


    imgLocation = "./Scenes/"+id+"/Assets/lilyPadImage.png";
    lilyPadImage = loadImage(imgLocation);

    for (int i=0; i<rivers.size(); i++) {
      rivers.get(i).setImage(logImage, lilyPadImage);
    }

    // Grass texture
    imgLocation = "./Scenes/"+id+"/Assets/grassImage.png";
    grassImage = loadImage(imgLocation);

    for (int i=0; i<safeZones.size(); i++) {
      safeZones.get(i).setImage(grassImage);
    }

    File roadFile = new File(sketchPath("Scenes/"+currentScene+"/Assets/roadSound.mp3"));
    File riverFile = new File(sketchPath("Scenes/"+currentScene+"/Assets/riverSound.mp3"));
    File powerUpFile = new File(sketchPath("Scenes/"+currentScene+"/Assets/powerUp.mp3"));
    File riverDeathFile= new File(sketchPath("Scenes/"+currentScene+"/Assets/riverDeath.mp3"));
    File carDeathFile = new File(sketchPath("Scenes/"+currentScene+"/Assets/carDeath.mp3"));

    if (roadFile.exists()) {      
      roadSound = minim.loadFile(sketchPath("Scenes/"+currentScene+"/Assets/roadSound.mp3"), 2048);
    } else {
      roadSound = minim.loadFile("DefaultSounds/roadSound.mp3", 2048);
    }

    if (riverFile.exists()) {      
      riverSound = minim.loadFile(sketchPath("Scenes/"+currentScene+"/Assets/riverSound.mp3"), 2048);
    } else {
      riverSound = minim.loadFile("DefaultSounds/riverSound.mp3", 2048);
    }

    if (powerUpFile.exists()) {      
      powerUpSound = minim.loadFile(sketchPath("Scenes/"+currentScene+"/Assets/powerUp.mp3"), 2048);
    } else {
      powerUpSound = minim.loadFile("DefaultSounds/powerUp.mp3", 2048);
    }

    if (riverDeathFile.exists()) { 
      riverDeathSound = minim.loadFile(sketchPath("Scenes/"+currentScene+"/Assets/riverDeath.mp3"), 2048);
    } else {
      riverDeathSound = minim.loadFile("DefaultSounds/riverDeath.mp3", 2048);
    }

    if (carDeathFile.exists()) { 
      carDeathSound = minim.loadFile(sketchPath("Scenes/"+currentScene+"/Assets/carDeath.mp3"), 2048);
    } else {
      carDeathSound = minim.loadFile("DefaultSounds/carDeath.mp3", 2048);
    }
  }


  // Clear ArrayLists and nullify PImages
  void unloadAssets() {
    log("\nUnloading assets for Scene "+id+"\n");

    rivers.clear();
    roads.clear();
    safeZones.clear();
    powerUps.clear();
    endPoints.clear();

    frogImage_still = null;
    frogImage_jumping = null;
    roadImage = null;
    grassImage = null;

    carImages = null;

    performanceModifier = 1;
  }


  String loadPreGameData() {
    String toReturn = "";

    // Location
    json = loadJSONObject("./Scenes/"+id+"/data.json");

    toReturn += json.getString("name");
    toReturn += " -- "+json.getString("difficulty");

    return toReturn;
  }

  // Return name of this scene
  String getName() {
    return name;
  }

  String getCatchPhrase() {
    return catchPhrase;
  }
}