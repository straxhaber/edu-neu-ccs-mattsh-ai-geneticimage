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
  size(goalImage.width, goalImage.height);
                                       
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
  //Print out what generation we are currently on
  println("Generation: " + currentGeneration);
  
  // Sort the candidates in order of their fitness
  Collections.sort(population);
  
  // Prune all but the best candidates
  naturalSelection(); // Done first while list is properly sorted
  
  // Passing null means we are not asking it to render to an off-screen frame buffer
  // Render the best candidate in our population to the screen
  Candidate bestCandidate = population.get(0);
  renderCandidate(bestCandidate);
  
  /*
   * This is where you will put in the code that drives the evolutionary algorithm:
   *    - determining the fitness for each candidate 
   *    - sorting the population by fitness
   *    - evolving a new population
   */
  // Evolve! Let Darwin's theories wreck their havoc
  mutateCandidates();
  breedCandidates();
  
  //Increment the generation number
  currentGeneration++;
  
  //noLoop();
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

void renderCandidate(Candidate c) {
  PImage img = c.img;
  image(img, 0, 0);
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
