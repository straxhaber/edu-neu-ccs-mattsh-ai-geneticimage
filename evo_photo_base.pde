//Parameters to the genetic algorithm
final static int POPULATION_SIZE_INITIAL = 200;

final static double SURVIVAL_RATE_MIN = 0.2;
final static double SURVIVAL_RATE_MAX = 0.8;
final static double SURVIVAL_MUTATE_PROB = 0.1;

final static int BREEDING_NUM_ALPHA = 5;
final static int BREEDING_NUM_BETA = 10;
//final static double BREED_CHANCE_MIN = 0.0001;
//final static double BREED_CHANCE_MAX = 0.2;

//Variables used for storing the goal image
PImage goalImage;
String imagefilename = "fallcolors_ra_hurd_flickr.jpg";
color[] goalPixels;

//Variables used in evolution
List<Candidate> population; // List of Candidate objects
int currentGeneration;

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
  size(goalImage.width, goalImage.height, P2D);
                                       
  // initialize our first population
  population = new ArrayList<Candidate>();
  for (int i = 0; i < POPULATION_SIZE_INITIAL; i++)
    population.add(new Candidate(goalPixels));

  currentGeneration = 0;
}

//This function is called once per frame
//It will drive our evolution -- on each frame, it will evolve the next population
//and render the best-matching candidate
void draw() {
  // Print out what generation we are currently on
  println(String.format("Generation: %d\t(%d in population)", currentGeneration, population.size()));
  
  // Prune all but the best candidates and render the best
  Collections.sort(population); // naturalSelection and renderBest require a sorted population
  renderBest();
  
  List<Candidate> newGeneration = evolve();
  population = newGeneration;
  
  // Increment the generation number
  currentGeneration++;
}

List<Candidate> evolve() {
  List<Candidate> newGeneration = new ArrayList<Candidate>();
  
  // Evolve! Let Darwin's theories wreck their havoc
  reproductionOfTheSexiest(newGeneration);
  survivalOfTheFittest(newGeneration);
  
  return newGeneration;
}

void survivalOfTheFittest(List<Candidate> newGeneration) {
  int numLiving = population.size();
  
  for (int i = 0; i < numLiving; i++) {
    // Survival rates evenly distributed between 20% and 80%
    double chanceOfSurvival = getDistributionValue(SURVIVAL_RATE_MIN, SURVIVAL_RATE_MAX, numLiving, i);
    
    if (random(0, 1) < chanceOfSurvival) {
      Candidate newCandidate = population.get(i);
      
      if (random(0, 1) < SURVIVAL_MUTATE_PROB)
        newCandidate.mutate();
        
      newGeneration.add(newCandidate);
    }
  }
}

double getDistributionValue(double pMin, double pMax, int numIntervals, int interval) {
  double buckets = (double)numIntervals;
  double val =   (  (  (buckets - interval - 1)
                     / (buckets - 1)
                    )
                  * (pMax - pMin)
                 )
               + pMin;
  return val;
}


void reproductionOfTheSexiest(List<Candidate> newGeneration) {
  // Just like in animal reproduction, the best alphas mate with a wider number of betas
  // In this case, they are polygamous and hermaphroditic
  // Each of the fit candidates mate in a round-robin
  for (int i = 0; i < BREEDING_NUM_ALPHA; i++)
    for (int j = 0; j < BREEDING_NUM_BETA; j++) {
      // Add a baby
      Candidate alphaParent = population.get(i);
      Candidate betaParent = population.get(j);
      Candidate baby = alphaParent.crossover(betaParent);
      newGeneration.add(baby);
    }
  
//  for (int i = 0; i < numLiving; i++)
//    for (int j = 0; j < numLiving; j++) {
//      double alphaChance = getDistributionValue(BREED_CHANCE_MIN, BREED_CHANCE_MAX, numLiving, i);
//      double betaChance = getDistributionValue(BREED_CHANCE_MIN, BREED_CHANCE_MAX, numLiving, j);
//      if (random(0, 1) < (alphaChance * betaChance)) {
//        Candidate baby = population.get(i).crossover(population.get(j));
//        newGeneration.add(baby);
//      }
//    }
}

void renderBest() {
  Candidate bestCandidate = population.get(0);
  // Passing null means we are not asking it to render to an off-screen frame buffer
  bestCandidate.render(null);
}

//helper function that extracts the alpha value from a color (on [0, 255])
int getAlpha(color c) {
  return c >> 24 & 0xFF;
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
