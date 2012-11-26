public class Candidate implements Comparable {
  
  // the total number of shapes that make up the representation
  public static final int NUM_SHAPES = 250;
  
  // Reference to the target this candidate is trying to approximate
  private color[] target;
  
  //the array of shapes that makes up the candidate representation
  public Circle[] shapes;
  
  //the background color (held constant here, could change as part of evolution if you want)
  public int backgroundColor = 127;
  
  // Cache of fitness
  private double fitness;
  
  //create a candidate made up of random circles
  public Candidate(color[] target, boolean genShapesP) {
    this.target = target;
    
    if (genShapesP) {
      // Build up shapes array
      this.shapes = new Circle[NUM_SHAPES];
      for (int i = 0; i < NUM_SHAPES; i++) {
        this.shapes[i] = new Circle(null);
        this.shapes[i].setToRandom();
      }
      this.updateFitness();
    }
  }

  public Candidate(color[] target, Circle[] circles) {
    this(target, false);
    this.shapes = circles;
    this.updateFitness();
  }

  /**
  Randomize a random circle in the candidate
  */
  public void mutate() {
    this.getRandomElement(this.shapes).setToRandom();
    this.updateFitness();
  }
  
  public boolean equals(Object o) {
    Candidate c = (Candidate)o;
    if (this == c)
      return true;
    else if (this.fitness != c.fitness)
      return false;
    else {
      Arrays.sort(this.shapes);
      Arrays.sort(c.shapes);
      for (int i = 0; i < NUM_SHAPES; i++)
        if (! this.shapes[i].equals(c.shapes[i]))
          return false;
      return true;
    }
  }
  
  public Candidate crossover(Candidate other) {
    Circle[] combined = new Circle[NUM_SHAPES];
    
//    for (int i = 0; i < NUM_SHAPES; i++) {
//      Candidate srcShapeList;
//      if (randomEventOccursP(0.5))
//        srcShapeList = this;
//      else
//        srcShapeList = other;
//      combined[i] = getRandomElement(srcShapeList.shapes);
//    }
    for (int i = 0; i < NUM_SHAPES; i++)
      combined[i] = this.shapes[i].crossover(other.shapes[i]);
    
    return new Candidate(this.target, combined);
  }
  
  // Modified to include target and fitness function
  public void updateFitness() {
    color[] myPixels = this.getCandidatePixels();
    int deviation = 0;

    // Add linear differences to deviation
    for (int i = 0; i < myPixels.length; i++) {
      color myP = myPixels[i];
      color tgP = this.target[i];
    
      int dRed = abs(getRed(myP) - getRed(tgP));
      int dGreen = abs(getGreen(myP) - getGreen(tgP));
      int dBlue = abs(getBlue(myP) - getBlue(tgP));
    
      deviation += (dRed + dGreen + dBlue);
      /*
        TODO: Ideas:
         - root mean square color differences
      */
    }

    // Compute average deviation
    double avg_deviation = ((double)deviation) / (3 * 255 * this.target.length);
    
    // Cache the result
    this.fitness = 1 - avg_deviation;
  }
  
  

  /*
    ## Utilities ##############################################################
  */
  
  Circle getRandomElement(Circle[] shapes) {
    int mutationLocus = (int)random(0, this.shapes.length);
    return shapes[mutationLocus];
  }
  
  /**
    Return true prob*100% of the time
  */
  boolean randomEventOccursP(float prob) {
    return prob > random(0, 1);
  }
  
  //gets a single dimension array of colors referring to each pixel in the candidate
  //does this by rendering the candidate to a frame buffer
  //warning: this function is very slow! you should call it sparingly
  public color[] getCandidatePixels() {
    PGraphics buffer = createGraphics(width, height);
    buffer.beginDraw();
    this.render(buffer);
    buffer.endDraw();    
    buffer.loadPixels(); 
    return buffer.pixels; 
  }
    
  //render the candidate to either a PGraphics buffer or to the main canvas (by passing in null)
  public void render(PGraphics buffer) {
    if (buffer == null)
      background(this.backgroundColor);
    else
      buffer.background(this.backgroundColor);
    
    Circle c; // Place-holder for circles being looped through
    for (int i = 0; i < NUM_SHAPES; i++)
      this.shapes[i].render(buffer);
  }
  
  //compareTo makes it so that Candidates can be sorted based on fitness using Array.sort()
  public int compareTo(Object o) {
    Candidate other = (Candidate)o;
    double myFitness = this.fitness;
    double otherFitness = other.fitness;
    return new Double(otherFitness).compareTo(myFitness);
  }
}
