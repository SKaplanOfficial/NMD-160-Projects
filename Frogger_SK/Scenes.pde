// A class for Scenes (levels) in the game Frogger. Includes functional game elements as well as (basic) memory management.
class Scene {
  int id;                    // Location of this scene in scenes array
  
  PImage bgImage;            // Overall background image (Currently not visible)
  PImage frogImage_still;    // Landed/unmoving frog
  PImage frogImage_jumping;  // Mid-jump from (Currently unused)
  PImage roadImage;          // Asphalt texture
  PImage grassImage;         // Grass texture


  JSONObject json;           // Information loaded from data.json
  String name;  
  String catchPhrase;
  String difficultyName;
  int difficulty;
  String[] layout;


  // Per-scene object arrays
  ArrayList<River> rivers = new ArrayList<River>();
  ArrayList<Road> roads = new ArrayList<Road>();
  ArrayList<Safezone> safezones = new ArrayList<Safezone>();
  ArrayList<PowerUp> powerUps = new ArrayList<PowerUp>();
  
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
    // Unnecessary image call, but useful during level development
    // Remove or find use later
    image(bgImage, 0, 0, width, height);

    // Rivers have lowest priority. Display them first.
    for (int i=0; i<rivers.size(); i++) {
      rivers.get(i).update();
      rivers.get(i).display();
    }

    // Safezones second.
    for (int i=0; i<safezones.size(); i++) {
      safezones.get(i).update();
      safezones.get(i).display();
    }

    // Roads third.
    for (int i=0; i<roads.size(); i++) {
      roads.get(i).update();
      roads.get(i).display();
    }

    // PowerUps fourth.
    for (int i=0; i<powerUps.size(); i++) {
      powerUps.get(i).update();
      powerUps.get(i).display();
    }

    // Frogger fifth
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
    int totalCarAmount = 0;

    log("\tLoading object map...");
    JSONArray test = json.getJSONArray("layout");
    
    layout = new String[test.size()];
    int numberOfRows = test.size()/11;
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
        if (layout[pos].equals("E")) {                         // End row
          safezones.add(new Safezone(y*heightOfRow));
          // Increment count of this row type
          safezoneAmount++;
          
        } else if (layout[pos].equals("S")) {                  // Safespot row
          safezones.add(new Safezone(y*heightOfRow));
          safezoneAmount++;
          
        } else if (layout[pos].equals("B")) {                  // Beginning row
          safezones.add(new Safezone(y*heightOfRow));
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
          
        } else if (layout[pos].equals("W")) {                  // Water/River row
          rivers.add(new River(y*heightOfRow));
          riverAmount++;
          
        } else if (layout[pos].equals("P")) {                  // Power Ups (At a specific spot)
          powerUps.add(new PowerUp(x*(width/10), y*heightOfRow));
          powerUpAmount++;
          
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
    log("\t"+powerUpAmount+" Power Ups found.\n");
    
    log("\t"+totalCarAmount+" cars found.\n");
  }


  // Bring in assets from this scene's Assets folder
  void loadAssets() {
    String imgLocation = "./Scenes/"+id+"/Assets/bgImage.png";
    bgImage = loadImage(imgLocation);


    // Frogger Images
    imgLocation = "./Scenes/"+id+"/Assets/frogImage_still.png";
    frogImage_still = loadImage(imgLocation);

    imgLocation = "./Scenes/"+id+"/Assets/frogImage_jumping.png";
    frogImage_jumping = loadImage(imgLocation);
    
    frogger.setImages(frogImage_still, frogImage_jumping);


    // Road texture
    imgLocation = "./Scenes/"+id+"/Assets/roadImage.png";
    roadImage = loadImage(imgLocation);

    for (int i=0; i<roads.size(); i++) {
      roads.get(i).setImage(roadImage);
    }


    // Grass texture
    imgLocation = "./Scenes/"+id+"/Assets/grassImage.png";
    grassImage = loadImage(imgLocation);

    for (int i=0; i<safezones.size(); i++) {
      safezones.get(i).setImage(grassImage);
    }
  }


  // Clear ArrayLists and nullify PImages
  void unloadAssets() {
    log("\nUnloading assets for Scene "+id+"\n");

    rivers.clear();
    roads.clear();
    safezones.clear();
    powerUps.clear();

    bgImage = null;
    frogImage_still = null;
    frogImage_jumping = null;
    roadImage = null;
    grassImage = null;
  }


  // Return name of this scene
  String getName() {
    return name;
  }
  
  String getCatchPhrase() {
    return catchPhrase;
  }
}