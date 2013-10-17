//import SimpleOpenNI.*;

import org.openkinect.*;
import org.openkinect.processing.*;

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;

import de.voidplus.leapmotion.*;


import java.util.*;

Kinect kinect;


DeviceRegistry registry;

GlowdomeRender sketch;


boolean useKinect = true;
boolean useLeap = true;

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
    size(480, 480, P3D);
    frameRate(400);

    sketch = new GlowdomeRender(this, useKinect, useLeap);
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
        }

        switch(key) {

            case 'z':
                sketch.traceSpeed--;
                if (sketch.traceSpeed < 0)
                    sketch.traceSpeed = 0;
                break;
            case 'x':
                sketch.traceSpeed++;

                break;
        }

        if (sketch.stripeWidth < 2) sketch.stripeWidth = 2;
    }

    sketch.render();

    sketch.display();

}

void keyPressed() {
    switch(key) {
       
        case 't':
            //sketch.cycleMode();
            break;
        case '0':
            sketch.clearLayers();
            break;
    }
    
    if (key >= '1' && key <= '9') {
       sketch.toggleLayer(key - '0'); 
    }
}

void movieEvent(Movie m) {
    m.read();
}

void stop() {
    sketch.stop();
    super.stop();
}


void leapOnSwipeGesture(SwipeGesture g, int state){
    int     id                  = g.getId();
    Finger  finger              = g.getFinger();
    PVector position            = g.getPosition();
    PVector position_start      = g.getStartPosition();
    PVector direction           = g.getDirection();
    float   speed               = g.getSpeed();
    long    duration            = g.getDuration();
    float   duration_seconds    = g.getDurationInSeconds();

    switch(state){
        case 1: // Start
            break;
        case 2: // Update
            break;
        case 3: // Stop
            println("SwipeGesture: "+id);
            //sketch.cycleMode();
            break;
    }
}




