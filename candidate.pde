public class Candidate implements Comparable {
  
  //the total number of shapes that make up the representation
  public static final int NUM_SHAPES_PER_CANDIDATE = 250;
  
  // Reference to the target this candidate is trying to approximate
  private color[] target;
  
  //the array of shapes that makes up the candidate representation
  public Circle[] shapes;
  
  //the background color (held constant here, could change as part of evolution if you want)
  public int backgroundColor = 128;
  
  // Cache of fitness
  private boolean fitnessStale;
  private float fitness;
  
  //create a candidate made up of random circles
  public Candidate(color[] target) {
    this.target = target;
    this.shapes = new Circle[NUM_SHAPES_PER_CANDIDATE];
    
    this.fitnessStale = true;
    this.fitness = 0.0f;
    
    for (int i = 0; i < NUM_SHAPES_PER_CANDIDATE; i++) {
      Circle c = new Circle(null);
      c.setToRandom();
      this.shapes[i] = c;
    }
  }

  public Candidate(color[] target, Circle[] circles) {
    this(target);
    this.shapes = circles;
  }
  
  public Candidate mutate() {
    this.fitnessStale = true;
    return this;  //TODO: write me!
  }
  
  // Modified to compute crossover as half-alpha composite of self and other
  public Candidate crossover(Candidate other) {
    int numCircles = shapes.length + other.shapes.length;
    Circle[] allCircles = new Circle[numCircles];
    
    Circle c; // Placeholder for circles being added to new candidate
    
    // Add half-alpha copies of self
    for (int i = 0; i < this.shapes.length; i++) {
      c = new Circle(this.shapes[i]);
      c.halveVisibility();
      allCircles[i] = c;
    }

    // Add half-alpha copies of 'other'
    for (int i = 0; i < other.shapes.length; i++) {
      c = new Circle(other.shapes[i]);
      c.halveVisibility();
      allCircles[this.shapes.length + i] = c;
    }

    return new Candidate(this.target, allCircles);
    
    // TODO: Consider using blend()
  }
  
  // Modified to include target and fitness function
  public float getFitness() {
    if (this.fitnessStale) {
      color[] myPixels = this.getCandidatePixels();
      int deviation = 0;
  
      // Add linear differences to deviation
      for (int i = 0; i < (width * height); i++) {
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
    PGraphics buffer = createGraphics(width, height);
    buffer.beginDraw();
    render(buffer);
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
    
    for (int i = 0; i < NUM_SHAPES_PER_CANDIDATE; i++)
      this.shapes[i].render(buffer);
  }
  
  //compareTo makes it so that Candidates can be sorted based on fitness using Array.sort()
  public int compareTo(Object o) {
    Candidate other = (Candidate) o;
    
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
