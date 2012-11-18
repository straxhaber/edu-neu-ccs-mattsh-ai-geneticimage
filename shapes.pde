class Circle {
  public int radius;      //radius of the circle
  public int xPos, yPos;  //center point of the circle
  public int r, g, b, a;  //red, green, blue, and alpha values
  public int smallestRadius;
  public int largestRadius;
  
  /*
    constructor that creates either a copy or an incomplete circle
    
    NOTE: Must either:
      - run a setTo method before use
      - provide a circle to copy (not null)
      - run a more thorough constructor that fills in all fields
      
      I am doing this because I couldn't figure out how to make a static
        factory method in Processing. This cleaned up the other code while
        allowing me to make 'children' without 'killing' parents
  */
  public Circle(Circle c) {
    this.smallestRadius = 2;
    this.largestRadius = width / 4;

    if (c != null) {
      this.xPos = c.xPos;
      this.yPos = c.yPos;
      this.radius = c.radius;
      this.r = c.r;
      this.g = c.g;
      this.b = c.b;
      this.a = c.a;
    }
  }

  public void setToRandom() {
    xPos = int(random(0, width));  //xPos should be somewhere within the canvas size
    yPos = int(random(0, height)); //yPos should be somewhere within the canvas size
    radius = int(random(smallestRadius, largestRadius));  //randomly sized radius
    r = int(random(0, 255));       //random red value
    g = int(random(0, 255));       //random green value
    b = int(random(0, 255));       //random blue value
    a = 128;                       //circles should be semi-transparent

    this.xPos = xPos;
    this.yPos = yPos;
    this.radius = radius;
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = a;
  }
  
  public void halveVisibility() {
    this.a = this.a / 2; // TODO: should this be * 2?
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
