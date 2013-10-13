//import SimpleOpenNI.*;

import org.openkinect.*;
import org.openkinect.processing.*;

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import java.util.*;


DeviceRegistry registry;

GlowdomeRender sketch;

KinectTracker tracker;
// Kinect Library object
Kinect kinect;

int drawMode = 1;

boolean useKinect = true;

class TestObserver implements Observer {
    public boolean hasStrips = false;
    public void update(Observable registry, Object updatedDevice) {
        println("Registry changed!");
        if (updatedDevice != null) {
            println("Device change: " + updatedDevice);
        }
        this.hasStrips = true;
    }
}

void setup() {
  size(240, 240, P2D);
  if (useKinect) {
    kinect = new Kinect(this);
    tracker = new KinectTracker(); 
  }
  
  sketch = new GlowdomeRender();
  sketch.setup();
  //sketch.loadMovie(this);
}

void draw()  {

  if (keyPressed) {
     if( key == 'w' || key == 'W') {
         sketch.speed += 0.2; 
     } else if (key == 's' || key == 'S') {
        sketch.speed -= 0.2; 
     } else if (key == 'p') {
       sketch.stripeWidth++;
     }
     else if (key == 'l') {
       sketch.stripeWidth--;
     } else if (key == 't') {
        drawMode++;
        if (drawMode > 2) drawMode = 1; 
     }
     if (sketch.stripeWidth < 2) sketch.stripeWidth = 2;  
  }
 
  PVector v1;
  if (useKinect) {
    v1 = tracker.getPos();
  } else {
    v1 = new PVector(0, 0); 
  }
    
  switch(drawMode) {
    case 1:
      sketch.render();   
    break;
    case 2:
     sketch.renderTest(v1);  
    break; 
  }
    
  if (useKinect) {
    tracker.track();
    //tracker.display();    
  }
  
  sketch.display();
 
}

void movieEvent(Movie m) {
  m.read();
}

void stop() {
  if (useKinect) {
    tracker.quit();
  }
  super.stop();
}


