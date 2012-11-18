public class Candidate implements Comparable
{ 
  //the total number of shapes that make up the representation
  public static final int NUM_SHAPES_PER_CANDIDATE = 250;
  //a variable that stores the fitness value for this candidate
  public float fitness;
  //the array of shapes that makes up the candidate representation
  public Circle[] shapes;
  //the background color (held constant here, could change as part of evolution if you want)
  public int backgroundColor = 128;
  
  //create a candidate made up of random circles
  public Candidate()
  {
    fitness = 0.0f;
    shapes = new Circle[NUM_SHAPES_PER_CANDIDATE];
    for (int i = 0; i < NUM_SHAPES_PER_CANDIDATE; i++) {
      shapes[i] = new Circle();
    }
  }
  
  //TODO: write me!
  public Candidate mutate() {
    return this;
  }
  
  //TODO: write me!
  public Candidate crossover(Candidate other) {
    return this;
  }
  
  //TODO: write me!
  public float calculateFitness() {
    return 0.0f;
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
    if (buffer == null) background(backgroundColor);
    else buffer.background(backgroundColor);
    
    for (int i = 0; i < NUM_SHAPES_PER_CANDIDATE; i++) {
      shapes[i].render(buffer);
    }
  }
  
  //compareTo makes it so that Candidates can be sorted based on fitness using Array.sort()
  public int compareTo(Object o) {
    Candidate other = (Candidate)o;
    if (abs(other.fitness - this.fitness) < 0.001) {
      return 0;
    }
    else if (other.fitness > this.fitness) {
      return -1;
    }
    else {
      return 1;
    }
  }
  
}
