public class Candidate implements Comparable {
  
  // chance an individual circle will mutate when mutating
  public static final float PROB_MUTATE = 0.2;
  
  private static final int NUM_MUTATE = 5;
  
  private final int NUM_PIXELS = width * height;
  
  private final color START_COLOR = color(127, 127, 127);
  
  // Reference to the target this candidate is trying to approximate
  private color[] target;
  
  // Buffer for Candidate
  private color[] pixelA;
  
  // Fitness should be accessed through getFitness() 
  private boolean fitnessStale;
  private float fitness;
  
  //the background color (held constant here, could change as part of evolution if you want)
  public int backgroundColor = 128;
  
  //create a candidate made up of the specified pixels
  public Candidate(color[] target, color[] pixelA) {
    this.target = target;
    this.pixelA = pixelA;
  }
  
  //create a candidate made up of random pixels
  public Candidate(color[] target) {
    this.target = target;
    
    this.pixelA = new color[NUM_PIXELS];
    for (int i = 0; i < NUM_PIXELS; i++)
      this.pixelA[i] = this.getRandomColor();
//      this.pixelA[i] = START_COLOR;
  }
  
  public void mutate() {
    this.fitnessStale = true;
    
    for (int i = 0; i < NUM_PIXELS; i++)
      if (random(0, 1) < PROB_MUTATE)
        this.pixelA[i] = this.getRandomColor();
  }
  
  // Modified to compute crossover as half-alpha composite of self and other
  public Candidate crossover(Candidate other) {
    // Build up the new image surface with pixels that are halfway between the parents'
    color[] newPixelA = new color[NUM_PIXELS];
    for (int i = 0; i < NUM_PIXELS; i++) {
      color myP = this.pixelA[i];
      color otP = other.pixelA[i];
      newPixelA[i] = this.getLinearMidpoint(myP, otP);
    }
    
    // Return back a candidate wrapping the new pixel array
    return new Candidate(this.target, newPixelA);
  }
  
  // Calculates the linear midpoint of two colors, returning an average of them
  private color getLinearMidpoint(color c1, color c2) {
    int c1R = getRed(c1);
    int c1G = getGreen(c1);
    int c1B = getBlue(c1);
    int c1A = getAlpha(c1);
    int c2R = getRed(c2);
    int c2G = getGreen(c2);
    int c2B = getBlue(c2);
    int c2A = getAlpha(c2);
    int newR = (c1R + c2R) / 2;
    int newG = (c1G + c2G) / 2;
    int newB = (c1B + c2B) / 2;
    int newA = (c1A + c2A) / 2;
    return color(newR, newG, newB, newA);
  }
  
  private color getRandomColor() {
    int newR = (int)random(0, 255);
    int newG = (int)random(0, 255);
    int newB = (int)random(0, 255);
    int newA = (int)random(0, 255);
    return color(newR, newG, newB, newA);
  }
  
  // Modified to include target and fitness function
  public float getFitness() {
    if (this.fitnessStale) {
      int deviation = 0;
  
      // Add linear differences to deviation
      for (int i = 0; i < NUM_PIXELS; i++) {
        color selfP = this.pixelA[i];
        color goalP = this.target[i];
      
        int dRed = abs(getRed(selfP) - getRed(goalP));
        int dGreen = abs(getGreen(selfP) - getGreen(goalP));
        int dBlue = abs(getBlue(selfP) - getBlue(goalP));
      
        deviation += (dRed + dGreen + dBlue);
        /*
          TODO: Ideas:
           - root mean square color differences
        */
      }
  
      // Compute average deviation
      float avg_deviation = (deviation + 0.0) / NUM_PIXELS;
      
      // Cache the result
      this.fitness = avg_deviation;
      this.fitnessStale = false;
    }
    
    return this.fitness;
  }
  
  public void render(PGraphics buffer) {
    PImage img = createImage(width, height, RGB);
    
    img.loadPixels();
    img.pixels = this.pixelA;
    img.updatePixels();
    
    if (buffer == null)
      image(img, 0, 0);
    else
      buffer.image(img, 0, 0);
  }
  
  /*
    NOTE: I deleted getCandidatePixels and render, moving to this pixel-based mechanism because
    the system is MUCH MUCH faster and allows for many more generations
  */
  
  //compareTo makes it so that Candidates can be sorted based on fitness using Array.sort()
  public int compareTo(Object o) {
    Candidate other = (Candidate)o;
    
    float myFitness = this.getFitness();
    float otherFitness = other.getFitness();
    
//    if (abs(otherFitness - myFitness) < 0.0001)
//      return 0;
    if (otherFitness == myFitness)
      return 0;
    else if (otherFitness > myFitness)
      return -1;
    else
      return 1;
  }
  
}
