public class Candidate implements Comparable {
  
  // the total number of shapes that make up the representation
  public static final int NUM_SHAPES_INITIAL = 250;
  
  // chance an individual circle will mutate when mutating
  public static final float PROB_MUTATE = 0.2;
  
  private static final int NUM_MUTATE = 5;
  
  // Reference to the target this candidate is trying to approximate
  private color[] target;
  
  //the array of shapes that makes up the candidate representation
  public ArrayList shapes;
  
  //the background color (held constant here, could change as part of evolution if you want)
  public int backgroundColor = 128;
  
  // Cache of fitness
  private boolean fitnessStale;
  private float fitness;
  
  //create a candidate made up of random circles
  public Candidate(color[] target, boolean genShapesP) {
    this.target = target;
    this.shapes = new ArrayList();
    
    this.fitnessStale = true;
    this.fitness = 0.0f;
    
    if (genShapesP) {
      for (int i = 0; i < NUM_SHAPES_INITIAL; i++) {
        Circle c = new Circle(null);
        c.setToRandom();
        this.shapes.add(c);
      }
    }
  }

  public Candidate(color[] target, ArrayList circles) {
    this(target, false);
    this.shapes = circles;
  }
  
  public Candidate mutate() {
    return new Candidate(this.target, true);

//    // Add NUM_MUTATE circles to this Candidate
//    Circle newC; // Place-holder for circles being looped through
//    for (int i = 0; i < NUM_MUTATE; i++) {
//      newC = new Circle(null);
//      newC.setToRandom();
//      this.shapes.add(newC);
//    }
    
//    Circle[] newShapes = new ArrayList();
//    for (int i = 0; i < this.shapes.size(); i++) {
//      Circle newC;
//      if (random(0, 1) < PROB_MUTATE) {
//        newC = new Circle(null);
//        newC.setToRandom();
//        
//      } else {
//        newC = new Circle(this.shapes.get(i));
//      }
//      newShapes.add(newC);
//    }
    
//    Candidate newC = new Candidate(this.target, newShapes);
//    return newC;  //TODO: write me!
  }
  
  // Modified to compute crossover as half-alpha composite of self and other
  public Candidate crossover(Candidate other) {
    // Add all circles to a new ArrayList with each having its visibility halved
    ArrayList allCircles = new ArrayList();
    addCirclesHalfVisibility(allCircles, this.shapes); // Add half-alpha copies of self
    addCirclesHalfVisibility(allCircles, other.shapes); // Add half-alpha copies of self
    
    return new Candidate(this.target, allCircles);
    
    // TODO: Consider using blend()
  }
  
  public void addCirclesHalfVisibility(ArrayList target, ArrayList source) {
    Circle oldC; // Placeholder for circles being looped through
    Circle newC; // Placeholder for circles being generated
    
    for (int i = 0; i < source.size(); i++) {
      oldC = (Circle)source.get(i);
      newC = new Circle(oldC);
      newC.halveVisibility();
      target.add(newC);
    }
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
    for (int i = 0; i < this.shapes.size(); i++) {
      c = (Circle)this.shapes.get(i);
      c.render(buffer);
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
