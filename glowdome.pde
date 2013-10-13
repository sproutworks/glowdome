import SimpleOpenNI.*;

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import java.util.*;


DeviceRegistry registry;

YoutopiaRender sketch;

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
  sketch = new YoutopiaRender();
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
     if (sketch.stripeWidth < 2) sketch.stripeWidth = 2;  
  }
    sketch.render();
    sketch.display();
}

void movieEvent(Movie m) {
  m.read();
}


