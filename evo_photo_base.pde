// Initial population size
final static int POPULATION_SIZE_INITIAL = 1000;

// Constants that control survival rates
final static float SURVIVAL_PROB_KEEP = 0.9;
final static float SURVIVAL_PROB_MUTATE = 0.9;
final static int SURVIVAL_MAX = 100;

// Constants that control breeding rates
final static int BREEDING_ALPHA = 10;  //0.757296 (3,4); 0.784250/0.791389 (5,10); 0.802809 (10,20)
final static int BREEDING_BETA = 20;

// Variables used for storing the goal image
static PImage goalImage;
static String imagefilename = "quilt_daintytime_flickr.jpg";
static color[] goalPixels;

// Variables used in evolution
int currentGeneration;
List<Candidate> curGenPop; // List of Candidate objects
List<Candidate> newGenPop; // List of Candidate objects

//This function is called once, at the beginning of the program, and sets up the environment
//we will be working in.
void setup() {
  //load the goal image as a PImage
  goalImage = loadImage(imagefilename);  
  
  //resize the goal image to be 100 pixels wide, '0' as the second parameter
  //instructs it to resize the image proportionally
  //we want the image to be 100 pixels wide just to make it faster
  //the larger the goal image, the more expensive our fitness computation will be
  //(because we will have more pixels to compare)
  goalImage.resize(100, 0); 

  //store the pixels in the goal image in goalPixels for use in calculating fitness
  goalPixels = goalImage.pixels;  
                                         
  //set the size of the canvas to the size of the goal image
  //after we have set the size of the canvas, the global variables
  //width and height can be used to refer to the size of the canvas
  size(goalImage.width, goalImage.height);  
                                       
  // initialize our first population
  newGenPop = new ArrayList<Candidate>();
  for (int i = 0; i < POPULATION_SIZE_INITIAL; i++)
    newGenPop.add(new Candidate(goalPixels, true));
  Collections.sort(newGenPop); // Sort list at start
  
  currentGeneration = 0;
  advanceWorld();
}

/*
  #############################################################################
*/

/**
This function is called once per frame. It will drive our evolution -- on each
frame, it will evolve the next population and render the best-matching
candidate
*/
void draw() {
  /*
    NOTE: There is an expectation that curGenPop is kept sorted
  */
  
  /*
   * This code drives the evolutionary algorithm:
   *    - determining the fitness for each candidate 
   *    - sorting the population by fitness
   *    - evolving a new population
   */
  
  // Evolve! Let Darwin's theories wreck their havoc
  newGenPop = new ArrayList<Candidate>(); // reset new generation
  breedCandidates();
  keepCandidates();
  mutateCandidates();
  removeDuplicates();
  
  // Move forward to the next generation
  advanceWorld();
}

/**
Just like in real life, the best BREED_NUM candidates find mates
In this case, they are polygamous and each of the best candidates mate in a round-robin
*/
void breedCandidates() {
  int popSize = curGenPop.size();
  int breedNAlpha = min(popSize, BREEDING_ALPHA);
  int breedNBeta = min(popSize, BREEDING_BETA);
  
  for (int i = 0; i < breedNAlpha; i++)
    for (int j = i + 1; j < breedNBeta; j++) {
      // Add a baby
      Candidate mother = curGenPop.get(i);
      Candidate father = curGenPop.get(j);
      newGenPop.add(mother.crossover(father));
    }
}

/**
  Allow some candidates to survive
*/
void keepCandidates() {
  for (int i = 0; i < curGenPop.size(); i++)
    if (randomEventOccursP(SURVIVAL_PROB_KEEP))
      newGenPop.add(curGenPop.get(i));
}

/**
  Mutate some PROB_MUTATE*100% of candidates
*/
void mutateCandidates() {
  for (int i = 0; i < newGenPop.size(); i++)
    if (randomEventOccursP(SURVIVAL_PROB_MUTATE))
      newGenPop.get(i).mutate();
}

/**
  Remove duplicates
*/
void removeDuplicates() {
  Collections.sort(newGenPop);
  List<Candidate> tmpPop = new ArrayList<Candidate>();
  for (int i = 0; i < newGenPop.size(); i++) {
    Candidate c = newGenPop.get(i);
    if (! tmpPop.contains(c))
      tmpPop.add(c);
  }
  curGenPop = tmpPop;
}

/**
  Bring the world to the next generation (advance data structures, display results to user) 
*/
void advanceWorld() {
  /*
  Advance to the next generation
   - sort new generation's candidates
   - kill all but first SURVIVAL_MAX of them -- there is only so much room on the 'island'
   - set the current generation to the next generation
   - advance the generation counter
  */ 
  Collections.sort(newGenPop);
  int remainingPop = min(SURVIVAL_MAX, newGenPop.size());
  curGenPop = newGenPop.subList(0, remainingPop);
  currentGeneration++;
  
  /*
  Display status message to user
  */
  String best10Str="";
  for (int i = 0; i < min(10, curGenPop.size()); i++)
    best10Str += String.format("[%d]=%f", i, curGenPop.get(i).fitness);
  println(String.format("Gen #%d (popSize=%d) (bestFit=%f) (best10:%s)",
          currentGeneration,
          curGenPop.size(),
          curGenPop.get(0).fitness,
          best10Str));
  
  /*
  Render best candidate
  */
  Candidate bestCandidate = curGenPop.get(0);
  bestCandidate.render(null); // Pass null to render to on-screen frame buffer
}

/*
  ## Utilities ################################################################
*/

/**
  Return true prob*100% of the time
*/
boolean randomEventOccursP(float prob) {
  return prob > random(0, 1);
}

//helper function that extracts the red value from a color (on [0, 255])
int getRed(color c) {
  return c >> 16 & 0xFF;
}

//helper function that extracts the green value from a color (on [0, 255])
int getGreen(color c) {
  return c >> 8 & 0xFF;
}

//helper function that extracts the blue value from a color (on [0, 255])
int getBlue(color c) {
  return c & 0xFF;
}
