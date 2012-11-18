//Parameters to the genetic algorithm
final static int POPULATION_SIZE = 50;
final static float PERCENTAGE_KEEP = 0.1;
final static float PROBABILITY_KEEP = 0.3;
final static float PERCENTAGE_MUTATE = 0.2;

//Variables used for storing the goal image
PImage goalImage;
String imagefilename = "fallcolors_ra_hurd_flickr.jpg";
color[] goalPixels;

//Variables used in evolution
Candidate[] population;
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
  population = new Candidate[POPULATION_SIZE];
  for (int i = 0; i < POPULATION_SIZE; i++) {
    population[i] = new Candidate(goalPixels);
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
  
  population = sortPop(population);
  
  //Render the first candidate in our population to the screen 
  //Passing null means we are not asking it to render to an off-screen frame buffer
  population[0].render(null);
  
  /*
   * This is where you will put in the code that drives the evolutionary algorithm:
   *    - determining the fitness for each candidate 
   *    - sorting the population by fitness
   *    - evolving a new population
   */
// TODO : write this
  
  //Increment the generation number
  currentGeneration++;
  
  noLoop();
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
