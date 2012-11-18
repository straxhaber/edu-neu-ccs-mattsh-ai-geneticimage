static class Circle {
  public int radius;      //radius of the circle
  public int xPos, yPos;  //center point of the circle
  public int r, g, b, a;  //red, green, blue, and alpha values
  public int smallestRadius;
  public int largestRadius;
  
  //constructor that creates a random circle!
  private Circle(int xPos, int yPos, int radius, int r, int g, int b, int a) {
    this.smallestRadius = 2;
    this.largestRadius = width / 4;
    
    this.xPos = xPos;
    this.yPos = yPos;
    this.radius = radius;
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = a;
  }
  
  public static Circle getRandomCircle() {
    return new Circle(int(random(0, width)),  //xPos should be somewhere within the canvas size
                      int(random(0, height)), //yPos should be somewhere within the canvas size
                      int(random(smallestRadius, largestRadius)),  //randomly sized radius
                      int(random(0, 255)),    //random red value
                      int(random(0, 255)),    //random green value
                      int(random(0, 255)),    //random blue value
                      128);                   //circles should be semi-transparent
  }
  
  //copy constructor
  public static Circle getCircleCopy(Circle c) {
    return new Circle(c.xPos, c.yPos, c.radius, c.r, c.g, c.b, c.a);
  }
  
  public Circle getHalfAlphaCopy() {
    Circle newC = Circle.getCircleCopy(this);
    newC.a = this.a / 2; // TODO: should this be * 2?
    return newC;
  }
	
  //render the circle to either a PGraphics buffer or to the screen (by passing in null)
  public void render(PGraphics buffer) {
    if (buffer == null) {
      //the circle has no outline
      noStroke();
      
      //set the fill color to the color of the circle
      fill(this.r, this.g, this.b, this.a);
      
      //draw the circle to the screen
      ellipse(this.xPos, this.yPos, this.radius, this.radius);
      
    } else {
      //the circle has no outline
      buffer.noStroke();
      
      //set the fill color on the buffer to the color of the circle
      buffer.fill(this.r, this.g, this.b, this.a);
      
      //draw the circle to the buffer
      buffer.ellipse(this.xPos, this.yPos, this.radius, this.radius);
    }
  }
  
}
