import SimpleOpenNI.*;

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import java.util.*;

import de.voidplus.leapmotion.*;

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
}

void draw()  {

    sketch.render();
    sketch.display();
}


