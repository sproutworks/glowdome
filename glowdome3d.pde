import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;

class Glowdome3d {
  
  Ellipsoid earth;
  
  
  public void setup(PApplet applet) {
      earth = new Ellipsoid(applet, 16, 16);
      earth.setTexture("pattern3.png");
      earth.setRadius(180);
      earth.moveTo(new PVector(0, 0, 0));
      earth.strokeWeight(1.0f);
      earth.stroke(color(255, 255, 0));
      earth.moveTo(20, 40, -80);
      earth.tag = "Earth";
      earth.drawMode(Shape3D.TEXTURE);
      
  }  
  
  public void render(PVector handsDelta) {
    pushStyle();
    
    // Change the rotations before drawing
    earth.rotateBy(radians(handsDelta.y), radians(handsDelta.x), 0);
  
    //background(0);
    pushMatrix();
    camera(0, -190, 350, 0, 0, 0, 0, 1, 0);
    lights();
  
    // Draw the earth (will cause all added shapes
    // to be drawn i.e. the moon)
    earth.draw();
  
    //stars.draw();
    popMatrix();
    popStyle();
  }
  
  
}
