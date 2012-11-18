public class Candidate implements Comparable {
  
  // chance an individual circle will mutate when mutating
  public static final float PROB_MUTATE = 0.2;
  
  private static final int NUM_MUTATE = 5;
  
  // Reference to the target this candidate is trying to approximate
  private color[] target;
  
  // Buffer for Candidate
  private color[] pixelArray;
  
  // Cache of fitness
  private boolean fitnessStale;
  private float fitness;
  
  //the background color (held constant here, could change as part of evolution if you want)
  public int backgroundColor = 128;
  
  //create a candidate made up of the specified pixels
  public Candidate(color[] target, color[] newPixels) {
    this.target = target;
    this.pixelArray = newPixels;
  }
  
  //create a candidate made up of random pixels
  public Candidate(color[] target) {
    this.target = target;
    this.pixelArray = new color[width * height];
    for (int i = 0; i < this.pixelArray.length; i++)
      this.pixelArray[i] = this.getRandomColor();
  }
  
  public void mutate() {
    this.fitnessStale = true;
    for (int i = 0; i < pixels.length; i++) {
      if (random(0, 1) < PROB_MUTATE)
        pixels[i] = this.getRandomColor();
    }
  }
  
  // Modified to compute crossover as half-alpha composite of self and other
  public Candidate crossover(Candidate other) {
    color[] otherPixels = other.pixelArray;
    int myPixelsLength = this.pixelArray.length;
    
    // It would be an error to crossover candidates with different size buffers
    if (myPixelsLength == otherPixels.length) {
      color[] newPixels = new color[myPixelsLength];
      for (int i = 0; i < myPixelsLength; i++) {
        color myP = this.pixelArray[i];
        color otP = otherPixels[i];
        newPixels[i] = this.getLinearMidpoint(myP, otP);
      }
      return new Candidate(this.target, newPixels);
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
  
      // Add linear differences to deviation
      for (int i = 0; i < this.pixelArray.length; i++) {
        color selfP = this.pixelArray[i];
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
  
  //gets a single dimension array of colors referring to each pixel in the candidate
  //does this by rendering the candidate to a frame buffer
  //warning: this function is very slow! you should call it sparingly
  public color[] getCandidatePixels() {
    return this.pixelArray;
//    PGraphics buffer = createGraphics(width, height);
//    buffer.beginDraw();
//    this.render(buffer);
//    buffer.endDraw();    
//    buffer.loadPixels(); 
//    return buffer.pixels; 
  }
    
  //render the candidate to either a PGraphics buffer or to the main canvas (by passing in null)
  public void render(PGraphics buffer) {
    if (buffer == null) {
      background(this.backgroundColor);
      loadPixels();
      pixels = this.pixelArray;
      updatePixels();
    } else {
      buffer.background(this.backgroundColor);
      buffer.loadPixels();
      buffer.pixels = this.pixelArray;
      updatePixels();
    }
  }
  
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
