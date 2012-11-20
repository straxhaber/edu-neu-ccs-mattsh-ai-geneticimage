public class Candidate implements Comparable {
  
  // chance an individual circle will mutate when mutating
  public static final float PROB_MUTATE = 0.2;
  
  private static final int NUM_MUTATE = 5;
  
  private final color START_COLOR = color(127, 127, 127);
  
  // Reference to the target this candidate is trying to approximate
  private color[] target;
  
  // Buffer for Candidate
  private PImage img;
  
  // Cache of fitness
  private boolean fitnessStale;
  private float fitness;
  
  //the background color (held constant here, could change as part of evolution if you want)
  public int backgroundColor = 128;
  
  //create a candidate made up of the specified pixels
  public Candidate(color[] target, PImage image) {
    this.target = target;
    this.img = image;
  }
  
  //create a candidate made up of random pixels
  public Candidate(color[] target) {
    this.target = target;
    this.img = createImage(width, height, ARGB);
    this.img.loadPixels();
    for (int i = 0; i < this.img.pixels.length; i++)
//      this.img.pixels[i] = this.getRandomColor();
      this.img.pixels[i] = START_COLOR;
    this.img.updatePixels();
  }
  
  public void mutate() {
    this.fitnessStale = true;
    
    this.img.loadPixels();
    for (int i = 0; i < this.img.pixels.length; i++)
      if (random(0, 1) < PROB_MUTATE)
        this.img.pixels[i] = this.getRandomColor();
    this.img.updatePixels();
  }
  
  // Modified to compute crossover as half-alpha composite of self and other
  public Candidate crossover(Candidate other) {
    this.img.loadPixels();
    other.img.loadPixels();
    
    // It would be an error to crossover candidates with different size buffers
    if (this.img.pixels.length == other.img.pixels.length) {
      // Create a new image surface and init it
      PImage newImg = createImage(width, height, ARGB);
      newImg.loadPixels();
      
      // Build up the new image surface with pixels that are halfway between the parents'
      for (int i = 0; i < this.img.pixels.length; i++) {
        color myP = this.img.pixels[i];
        color otP = other.img.pixels[i];
        newImg.pixels[i] = this.getLinearMidpoint(myP, otP);
      }
      
      // Commit the pixel changes to the new image and return back a candidate wrapping it
      newImg.updatePixels();
      return new Candidate(this.target, newImg);
    } else {
      println("ERROR: Unmatched pixel array size!!");
      return null;
    }
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
    return color(random(0, 255),
                 random(0, 255),
                 random(0, 255),
                 random(0, 255));
  }
  
  // Modified to include target and fitness function
  public float getFitness() {
    if (this.fitnessStale) {
      int deviation = 0;
  
      this.img.loadPixels();
      // Add linear differences to deviation
      for (int i = 0; i < this.img.pixels.length; i++) {
        color selfP = this.img.pixels[i];
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
      float avg_deviation = (deviation + 0.0) / (width * height);
      
      // Cache the result
      this.fitness = avg_deviation;
      this.fitnessStale = false;
    }
    
    return this.fitness;
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
    
    if (abs(otherFitness - myFitness) < 0.001)
      return 0;
    else if (otherFitness > myFitness)
      return -1;
    else
      return 1;
  }
  
}
