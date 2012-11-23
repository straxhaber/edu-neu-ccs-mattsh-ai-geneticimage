//Parameters to the genetic algorithm
final static int POPULATION_SIZE_INITIAL = 200;
final static float MUTATE_PROB = 0.1;
final static int BREEDING_PRIMARY = 5;
final static int BREEDING_SECONDARY = 10;
final static int NATSELECT_N = 30;

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
  naturalSelection();
  renderBest();
  
  // Evolve! Let Darwin's theories wreck their havoc
  mutateCandidates();
  breedCandidates();
  
  // Increment the generation number
  currentGeneration++;
}

void naturalSelection() {
  // Kill all but first NATSELECT_N candidates
  population = population.subList(0, NATSELECT_N);
}

void mutateCandidates() {
  // Mutate each candidate with a PROB_MUTATE chance
  for (int i = 0; i < population.size(); i++)
    if (random(0, 1) < MUTATE_PROB)
      population.get(i).mutate();
}

void breedCandidates() {
  // Just like in real life, the best BREED_NUM candidates find mates
  // In this case, they are polygamous and each of the best candidates mate in a round-robin
  for (int i = 0; i < BREEDING_PRIMARY; i++)
    for (int j = i + 1; j < BREEDING_SECONDARY; j++) {
      // Add a baby
      Candidate mother = population.get(i);
      Candidate father = population.get(j);
      population.add(mother.crossover(father));
    }
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
