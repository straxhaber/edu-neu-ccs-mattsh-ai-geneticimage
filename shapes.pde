class Circle
{
  public int radius;      //radius of the circle
  public int xPos, yPos;  //center point of the circle
  public int r, g, b, a;  //red, green, blue, and alpha values
  public int smallestRadius;
  public int largestRadius;
  
  //constructor that creates a random circle!
  public Circle()
  {
    smallestRadius = 2;
    largestRadius = width/4;
    
    xPos = int(random(0, width));      //xPos should be somewhere within the canvas size
    yPos = int(random(0, height));     //yPos should be somewhere within the canvas size
    radius = int(random(smallestRadius, largestRadius));  //randomly sized radius
    r = int(random(0, 255));  //random red value
    g = int(random(0, 255));  //random green value
    b = int(random(0, 255));  //random blue value
    a = 128;                  //circles should be semi-transparent
  }
  
  //copy constructor
  public Circle(Circle c) {
    xPos = c.xPos;
    yPos = c.yPos;
    radius = c.radius;
    r = c.r;
    g = c.g;
    b = c.b;
    a = c.a;
  }
  
  //render the circle to either a PGraphics buffer or to the screen (by passing in null)
  public void render(PGraphics buffer) {
    if (buffer == null) {
      noStroke();  //the circle has no outline
      fill(r, g, b, a);  //set the fill color to the color of the circle
      ellipse(xPos, yPos, radius, radius);  //draw the circle to the screen
    }
    else {
      buffer.noStroke();  //the circle has no outline
      buffer.fill(r, g, b, a);  //set the fill color on the buffer to the color of the circle
      buffer.ellipse(xPos, yPos, radius, radius);  //draw the circle to the buffer
    }
  }
  
}
