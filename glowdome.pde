//import SimpleOpenNI.*;

import org.openkinect.*;
import org.openkinect.processing.*;

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;

//import com.onformative.leap.LeapMotionP5;
//import com.leapmotion.leap.Finger;

import de.voidplus.leapmotion.*;


import java.util.*;

Kinect kinect;


DeviceRegistry registry;

GlowdomeRender sketch;


int drawMode = 1;
int numModes = 4;

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
            sketch.cycleMode();
            break;
    }
}

void movieEvent(Movie m) {
    m.read();
}

void stop() {
    sketch.stop();
    super.stop();
}




