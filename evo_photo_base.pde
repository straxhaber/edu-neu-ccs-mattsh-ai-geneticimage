//Parameters to the genetic algorithm
final static int POPULATION_SIZE_INITIAL = 50;
final static float PROB_MUTATE = 0.2;
final static int POPULATION_SIZE_MAX = 200;

//Variables used for storing the goal image
PImage goalImage;
String imagefilename = "fallcolors_ra_hurd_flickr.jpg";
color[] goalPixels;

//Variables used in evolution
ArrayList population; // List of Candidate objects
int currentGeneration;

//This function is called once, at the beginning of the program, and sets up the environment
//we will be working in.
void setup()
{
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
                                       
  //initialize our first population
  population = new ArrayList();
  for (int i = 0; i < POPULATION_SIZE_INITIAL; i++) {
    population.add(new Candidate(goalPixels, true));
  }
  currentGeneration = 0;  
}

Candidate[] sortPop(Candidate[] population) {
  return population; // TODO: write this for real
}

//This function is called once per frame
//It will drive our evolution -- on each frame, it will evolve the next population
//and render the best-matching candidate
void draw()
{
  //Print out what generation we are currently on
  println("Generation: " + currentGeneration);
  
  // Sort the candidates in order of their success
  Collections.sort(population);
  
  // Render the best candidate in our population to the screen
  // Passing null means we are not asking it to render to an off-screen frame buffer 
  Candidate bestCandidate = (Candidate)population.get(0);
  bestCandidate.render(null);
  
  /*
   * This is where you will put in the code that drives the evolutionary algorithm:
   *    - determining the fitness for each candidate 
   *    - sorting the population by fitness
   *    - evolving a new population
   */
  // TODO : write this
  mutateCandidates();
  breedCandidates();
  naturalSelection();
  
  //Increment the generation number
  currentGeneration++;
  
//  noLoop();
}

void mutateCandidates() {
  // TODO
}

void breedCandidates() {
  // TODO
}

void naturalSelection() {
  // TODO
}

void addBaby(Candidate a, Candidate b) {
  Candidate child = a.crossover(b);
  population.add(child);
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
